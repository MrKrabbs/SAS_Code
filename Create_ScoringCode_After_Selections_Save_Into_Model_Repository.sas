%let InsFolder = %str(/export/home/&sysuserid./CW_SCORING); /*BASE LEVEL FOLDER FOR SCORING ARTIFACTS */
%let ModelName = %str(CW_Auto_LIAB_PP);
%LET SRC_TABLE =CASUSER.PUREPREM_W_DATAPREP; /* TABLE ONLY USED TO GET CORRECT WIDTH OF INPUT VARIABLES */ 
%LET FACTOR_TABLE=CASUSER.CW_FACTORS_WITH_RULES;
%LET SEND_SCORE_CODE_TO =&InsFolder./Model_Score_From_Factor_Selected.sas;
%LET ProgramName =%SCAN( &SEND_SCORE_CODE_TO.,-1, /);
%LET BasePP=; /* AVERAGE USING INTERCEPT FROM MODEL */



proc sql;
/* DATAFLDR.TEMPPARMEST holds our model estimates exactly as output by model */
select distinct(exp(estimate)) into :BasePP from DATAFLDR.TEMPPARMEST where upcase(effect) = 'INTERCEPT';
QUIT;


DATA DATAFLDR.RateTable;
/* PUBLIC.CW_FACTORS_WITH_RULES = &FACTOR_TABLE holds our CW factors AFTER being modified by analyst */
set &FACTOR_TABLE.;
run;

/* What are the unique effects in the model? */
data DATAFLDR.AllEffects;
   set DATAFLDR.RateTable (keep = EFFECT VALUE:);
	WHERE UPCASE(EFFECT) NOT IN ('ONE LEVEL SUMMARY');
   EFFECT = strip(EFFECT);
run;


/* What are the unique variable names used in the model? */
data DATAFLDR.AllVarName;
   length name $ 32;         /* SAS variable name */
   length type $ 7;          /* decimal or string */
   length level $ 8;         /* interval or nominal */
   length length 8;          /* declared length of string variable, 8 for numeric variable */

   set DATAFLDR.AllEffects;

   array VALUES {*} VALUE:;

   lastpos = 0;
   i_effect = 1;
   do until (starpos eq 0);
      name = ' ';
      starpos = find(EFFECT, '*', 'T', (lastpos+1));

      if (compare(VALUES[i_effect], 'INTERVAL', 'LI') ne 0) then do;
         level = 'nominal';
         length = length(VALUES[i_effect]);
/* 		 length =50; */
         type = 'string';
      end;
      else do;
         level = 'interval';
         length = 8;
         type = 'decimal';
      end;

      if (starpos gt 0) then do;
         i_effect = i_effect + 1;
         name = substr(EFFECT, (lastpos+1), (starpos-lastpos-1));
         lastpos = starpos;
      end;
      else name = substr(EFFECT, (lastpos+1));

      name = strip(name);
      output;
   end;
   keep level name length type;
run;

/*********************  BELOW UPDATES VARIABLE LENGTH TO AVOID WARNING MESSAGES    ******************************/;
PROC CONTENTS DATA=&SRC_TABLE. OUT=WORK.SRC_NAMES_LENGTH(KEEP=NAME TYPE LENGTH);

proc sql noprint;
	update DATAFLDR.AllVarName as A set LENGTH=(select LENGTH from 
		WORK.SRC_NAMES_LENGTH as B where TRIM(UPCASE(A.NAME))=TRIM(UPCASE(B.NAME))) 
		WHERE TRIM(UPCASE(A.LEVEL))='NOMINAL';
quit;

/*********************  END OF UPDATING VARIABLE LENGTH   ******************************/;

proc summary data = DATAFLDR.AllVarName nway;
   class level name type;
   var length;
   output out = DATAFLDR.InputVar (drop = _TYPE_ _FREQ_) max(length) = length;
run;


/* Extract the variable names into a macro variable */
data _NULL_;
   length OutList $ 1024;
   length OutListQ $ 1024;
   length OutCat $ 1024;

   retain nVarName 0;
   retain OutList ' ';
   retain OutListQ ' ';
   retain OutCat ' ';

   set DATAFLDR.InputVar end = eof;

   nVarName + 1;
   OutList = catx(' ', OutList, strip(name));
   OutListQ = catx(' ', OutListQ, quote(strip(name)));

   if (level eq 'nominal') then OutCat = catx(' ', OutCat, '1');
   else OutCat = catx(' ', OutCat, '0');

   if (eof eq 1) then do;
      call symput('nVarName', trim(put(nVarName, best32.-l)));
      call symput('ListVarName', OutList);
      call symput('ListVarQuote', OutListQ);
      call symput('ListVarCat', OutCat);
   end;
run;

%put Number of Variable Names = &nVarName.;
%put List of All Variable Names = &ListVarName.;
%put List of All Variable Names Quoted = &ListVarQuote.; 
%put List of Categorical Indicator = &ListVarCat.; 

/* How do the parameter estimates correspond to variable values? */
data DATAFLDR.ParamEstimate;
   length varname $ 32;
   length varvalue $ 256;

   set DATAFLDR.RateTable (keep = EFFECT VALUE: SELECTED_CW_FACTOR);
	WHERE UPCASE(EFFECT) NOT IN ('ONE LEVEL SUMMARY');

   array ListVarName {&nVarName.} $ 32 _TEMPORARY_ (&ListVarQuote.);
   array NAMES {&nVarName.} $ 256 NAME1 - NAME&nVarName.;
   array VALUES {*} VALUE:;

   lastpos = 0;
   _NWAY_ = 1;
   do until (starpos eq 0);
      varname = ' ';
      starpos = find(EFFECT, '*', 'T', (lastpos+1));
      varvalue = VALUES[_NWAY_];

      if (starpos gt 0) then do;
         _NWAY_ = _NWAY_ + 1;
         varname = substr(EFFECT, (lastpos+1), (starpos-lastpos-1));
         lastpos = starpos;
      end;
      else varname = substr(EFFECT, (lastpos+1));

      varname = strip(varname);
      i_var = whichc(varname, of ListVarName[*]);
      NAMES[i_var] = varvalue;

      if (compare(varvalue, 'INTERVAL', 'LI') eq 0) then NAMES[i_var] = '1';
      else NAMES[i_var] = varvalue;      
   end;
   keep EFFECT SELECTED_CW_FACTOR NAME1 - NAME&nVarName. _NWAY_;
run;

proc sort data = DATAFLDR.ParamEstimate;
   by _NWAY_ EFFECT NAME1 - NAME&nVarName.;
run;

/* Write SAS code based on parameter estimates */
filename outcode "&SEND_SCORE_CODE_TO.";
data _NULL_;
   set DATAFLDR.ParamEstimate end = eof;
   array ListVarName {&nVarName.} $ 32 _TEMPORARY_ (&ListVarQuote.);
   array ListVarCat {&nVarName.} _TEMPORARY_ (&ListVarCat.);
   array NAMES {&nVarName.} $ 256 NAME1 - NAME&nVarName.;

   file outcode;
   length synline1 $ 256;
   length synline2 $ 256;
   length synline3 $ 256;
   length synline4 $ 256;

   if (_N_ eq 1) then do;
      synline1 = 'LNPP = 0.0;';
      put synline1;
      put ;
   end;

   n_cat = 0;
   n_cont = 0;
   synline3 = put(log(SELECTED_CW_FACTOR), best32.-l);
   do i_name = 1 to &nVarName.;
      if (missing(NAMES(i_name)) eq 0) then do;
         if (ListVarCat[i_name] eq 1) then do;
            n_cat = n_cat + 1;

            if (n_cat gt 1) then synline1 = 'AND';
            else synline1 = 'IF (';

            synline2 = catx(' ', '(COMPARE(', ListVarName[i_name],', ', quote(trim(NAMES(i_name))), ", 'L') eq 0)");
            synline1 = catx(' ', synline1, synline2);

            if (n_cat gt 1) then put +3 synline1;
            else put synline1;
         end;
         else do;
            n_cont = n_cont + 1;
            if (n_cont gt 1) then synline4 = catx(' ', synline4, '*');
            else synline4 = ' '; 
            synline4 = catx(' ', synline4, ListVarName[i_name]);
         end;
      end;
   end;
   if (n_cat gt 0) then synline1 = ') THEN';
   else synline1 = ' ';

   if (n_cont gt 0) then do;
      synline3 = catx(' ', synline3, '*', synline4);
   end;
  
   synline1 = catx(' ', synline1, 'LNPP = LNPP + (', synline3, ');');
   if (n_cat gt 0) then put +3 synline1;
   else put synline1;
   put ;

/**** the amount of 709 is not related to the model. if something goes wrong, would rather set PRED_PP TO 0 OR MISSING INSTEAD OF ALLOWING */
/*** OVERFLOW ERRORS. BY RANDOM CHANCE THE 709 IS CLOSE TO THE INTERCEPT, BUT THAT IS PURE LUCK */
   if (eof eq 1) then do;
      synline1 = 'IF (LNPP LT -709.0) THEN PRED_PP = 0.0;';
      put synline1;
      synline1 = 'ELSE IF (LNPP GT 709.0) THEN PRED_PP = .;';
      put synline1;
      synline1 = "ELSE PRED_PP = &BasePP. * EXP(LNPP);";
      put synline1;
   end;
run;

/****************   BELOW STARTS PROCESS FOR CREATING ZIP FILE FOR MODEL MANAGER  **********/
data DATAFLDR.InputVar;
   retain name description role type level format length;
   set DATAFLDR.InputVar;

   length description $ 256; /* A variable label */
   length role $ 6;          /* input or output */
   length format $ 16;       /* SAS format name */

   description = name;
   role = 'input';
   format = '';
run;

data DATAFLDR.OutputVar;
   length name $ 32;         /* SAS variable name */
   length description $ 256; /* A variable label */
   length role $ 6;          /* input or output */
   length type $ 7;          /* decimal or string */
   length level $ 8;         /* interval or nominal */
   length format $ 16;       /* SAS format name */
   length length 8;          /* declared length of string variable, 8 for numeric variable */

   name = 'PRED_PP';
   description = 'Predicted Pure Premium';
   role = 'output';
   type = 'decimal';
   level = 'interval';
   format = '10.2';
   length = 8;
   output;
run;

data DATAFLDR.fileMetadata;
   length name $ 256;
   length role $ 32;

   name = 'inputVar.json';
   role = 'inputVariables';
   output;

   name = 'outputVar.json';
   role = 'outputVariables';
   output;

   name = "&ProgramName.";
   role = 'score';
   output;
run;

proc json nosastags pretty trimblanks out = "&InsFolder./Import2MM/inputVar.json";
   export DATAFLDR.InputVar;
run;

proc json nosastags pretty trimblanks out = "&InsFolder./Import2MM/outputVar.json";
   export DATAFLDR.outputVar;
run;

proc json nosastags pretty trimblanks out = "&InsFolder./Import2MM/fileMetadata.json";
   export DATAFLDR.fileMetadata;
run;

proc json nosastags pretty trimblanks out = "&InsFolder./Import2MM/ModelProperties.json";
   write open object;
   write values "createdBy" "&SYSUSERID.";
   write values "name" "&ModelName.";
   write values "description" "Predict Pure Premium using model estimates after revisions";
   write values "scoreCodeType" "dataStep";
   write values "algorithm" "glm";
   write values "function" "prediction";
   write values "modeler" "&SYSUSERID.";
   write values "trainCodeType" "dataStep";
   write values  "predictionVariable" "PRED_PP";
   write values "targetVariable" "PP";
   write values "targetLevel" "interval";
   write values "trainTable" "";
   write values "tool" "SAS";
   write values "toolVersion" "&SYSVER.";
   write values "modelVersionName" "1.0";
   write close;
run;

/* Create the ZIP file that contains the necessary JSON files. The ZIP file is ready to be imported to Model Manager */
ods package(Input2MM) open nopf;
ods package(Input2MM) add file = "&InsFolder./Import2MM/inputVar.json" text;
ods package(Input2MM) add file = "&InsFolder./Import2MM/outputVar.json" text;
ods package(Input2MM) add file = "&InsFolder./Import2MM/ModelProperties.json" text;
ods package(Input2MM) add file = "&InsFolder./Import2MM/fileMetadata.json" text;
ods package(Input2MM) add file = outcode text;
ods package(Input2MM) publish archive properties(archive_name = "&ModelName..zip" archive_path = "&InsFolder./Import2MM");
ods package(Input2MM) close;
quit;

filename outcode clear;