/* Following assumptions are made for the code below and the macros */
/* 1. Assumed your data to be scored will reside in the casuser library*/
/* 2. You want your output data sent to the Public library and to be promoted and it's name will be myCars_SCORED*/


cas;
caslib _all_ assign;

LIBNAME CASUSER CAS;


DATA CASUSER.myCars;
set sashelp.cars;

/* below just tests to see what happens if we have an extra variable not used in scoring. By using hte ignore option is the runmodel option */
/* extra variables that play no roles in scoring will simply be ignored, however they do come along for the ride in the output of scoring */
/* no need to drop our target (MSRP) as it will be ignored */ 
Test_Ignore=5;

run;

/*************   below you will need to know three items    *************/
/*****    1. The name of the dataset you would like to score      *******/
/*****    2. Name of your published model to use for scoring      *******/
/*****    3. Name to call your output dataset with attached score *******/

%LET Data_2_Score=myCars;
/* the line below MUST MATCH The NAME OF YOUR PUBLISHED MODEL WHEN YOU CLICKED THE PUBLISH TO CAS BUTTON. YOU MUST UPDATE THE LINE BELOW*/
%LET MyScoreCode=GB_W_TRANS_8d914140_67bf_4531_895f_79cff973d1a4; /*name of model published to CAS*/
%LET Out_W_Score=myCars_SCORED;

/**********************    No need to modify code below        *****************/

proc casutil;                        
  droptable casdata="&Out_W_Score." INCASLIB="Public" QUIET;
quit;

proc cas;
loadactionset "ds2";
action runModel submit /
modelTable={name="SAS_MODEL_TABLE", caslib="Public"}
modelName="&MyScoreCode."
table={name="&Data_2_Score."}
casOut={name="&Out_W_Score."}
strictLevel="IGNORE";
run;
quit;

proc casutil outcaslib="Public";                        
   promote casdata="&Out_W_Score.";
quit;
