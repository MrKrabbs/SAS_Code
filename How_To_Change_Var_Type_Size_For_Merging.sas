libname sasdl '/home/sasdemo/AIMS/';
 
/* create study2016 data table */
data sasdl.study2016;
   length subjid dob 8 state $2 start_date end_date 8;
   infile datalines truncover;
   input subjid dob : mmddyy10. state start_date : mmddyy10. end_date : mmddyy10.;
   format dob start_date end_date mmddyy10.;
   datalines;
123456 08/15/1960 MD 01/02/2016
234567 11/13/1970 AL 05/12/2016 12/30/2016
;
 
/* create study2017 data table */
data sasdl.study2017;
   length subjid $6 dob 4 state $2 start_date end_date 4;
   infile datalines truncover;
   input subjid dob : mmddyy10. state start_date : mmddyy10. end_date : mmddyy10.;
   format dob start_date end_date mmddyy10.;
   datalines;
987654 03/15/1980 VA 02/13/2017
876543 11/13/1970 NC 01/11/2017 01/30/2017
765432 12/15/1990 NY 03/14/2017
;


/* will have issues appending due to different lengths */
proc append base=sasdl.study2016 data=sasdl.study2017 force;
run;

/* create a list of all the variable names and their order and place in the macro varible called varlist */
proc sql noprint;
   select name into :varlist separated by ' '
   from sashelp.vcolumn
   where upcase(libname) eq 'SASDL' and upcase(memname) eq 'STUDY2016';
quit;
 
/* modify variable type and length */
/* short description of what we are doing, we set the length\type first for the variable then we copy in the existing */
/* values of those variables record  by record. That is why the var subjid requires a put as we are copying a numeric*/
/* into a newly created character field (length 6) */
data sasdl.study2016 (drop=v1-v4);
   retain &varlist; /*<-- preserve variable order */ 
   length subjid $6 dob start_date end_date 4; /*<-- define new types/lengths */
   format dob start_date end_date mmddyy10.; /*<-- recreate formats */
   set sasdl.study2016 (rename=(subjid=v1 dob=v2 start_date=v3 end_date=v4)); /* due to rename we can now create new vars with same name */
   subjid = put(v1,6.); /*<-- redefine subjid variable */
   dob = v2;            /*<-- redefine dob variable */
   start_date = v3;     /*<-- redefine start_date variable */
   end_date = v4;       /*<-- redefine end_date variable */
run;
 
/* make sure new concatenated file (study_all) does not exist */
proc datasets library=sasdl nolist;
   delete study_all;
quit;
 
/* append both (study2016 and study2017) to study_all */
proc append base=sasdl.study_all data=sasdl.study2016;
run;
proc append base=sasdl.study_all data=sasdl.study2017;
run;
