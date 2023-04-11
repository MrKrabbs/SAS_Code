
/* BELOW WILL POPULATE THE VALUE OF PREMIUM AND FREQUENCY IN OUR ESTIMATES TABLE*/




data _null_;
set work.Estimates2;
where GROUPSUM > 0;

CALL EXECUTE('%UpdatePremiumAndFreq(Record_Id='||RECORD_ID||', GROUPSUM='||GROUPSUM ||',Level1='||LEVEL1 ||',Value1='||Value1 ||
',Level2='||LEVEL2 ||',Value2='||Value2 ||
',Level3='||LEVEL3 ||',Value3='||Value3 ||
',Level4='||LEVEL4 ||',Value4='||Value4 ||');');

run;


/***********************    BELOW THE FOLLOWING ARE FICTITIOUS VARIABLES. WE DO THIS BECAUSE WE DON'T HAVE REAL DATA     *******************************/
/***********************    IN A REAL MODEL YOU WOULD HAVE ACCESS TO THE CURRENT PREMIUM (OR METRIC OF INTEREST) FOR A SPECIFIC SEGMENT  ***************/
/***********************    ADDITIONALLY YOU WOULD KNOW WHAT YOUR CURRETN FACTORS ARE FOR SEGMENTS SUCH AS A FACTOR FOR A SPECIFIC SUV LIKE FORD EXPLORER*/
/***********************    SINCE WE DON'T HAVE CURRENT PREMIUM OR FACTORS WE MAKE UP THOSE VALUES BELOW TO CREATE A MORE UNDERSTANDABLE VIEW   ********/

DATA WORK.FINAL_TABLE;
retain CW_RULE_USED	MODEL	EFFECT	EXPOSURE	CURRENT_WP	STATE	LEVEL1	LEVEL2	LEVEL3	LEVEL4	VALUE1	VALUE2	VALUE3	VALUE4	
CURRENT_CW_FACTOR	CW_MODEL_FACTOR	SUGGESTED_CW_FACTOR	ANALYST SELECTED_CW_FACTOR	COMMENTS;

SET work.Estimates2;

LENGTH ANALYST $15;

CW_MODEL_FACTOR=exp(estimate);
SUGGESTED_CW_FACTOR=CW_MODEL_FACTOR;

call streaminit(123);
a = .95; 
b = 1.05;
u = rand("Uniform");            /* decimal values in (0,1)    */
x = a + (b-a)*u;                /* decimal values (a,b)       */

CURRENT_CW_FACTOR=CW_MODEL_FACTOR * x;
LENGTH CW_RULE_USED $30;
CW_RULE_USED='';


call streaminit(456);
c = .93; 
d = 1.07;
e = rand("Uniform");            /* decimal values in (0,1)    */
z = c + (d-c)*e;                /* decimal values (a,b)       */

/* REMINDER THAT BELOW IS FICTITIOUS AS WE DON'T HAVE AN EXISTING OF BUSINESS */
CURRENT_WP = int(3.21 * &TARGET_VAR.);

REVIEWED=0;

SUGGESTED_CW_FACTOR=CW_MODEL_FACTOR;

/* below will stop our factors from being +- more than 3%. A 3% up or down cap from CURRENT_CW_FACTOR */
/* will execute below via a rule instead of doing here*/
/* if (CURRENT_CW_FACTOR/CW_MODEL_FACTOR) < .97 then SUGGESTED_CW_FACTOR = 1.03 * CURRENT_CW_FACTOR; */
/* if (CURRENT_CW_FACTOR/CW_MODEL_FACTOR) > 1.03 then SUGGESTED_CW_FACTOR =  .97 * CURRENT_CW_FACTOR; */


LENGTH SELECTED_CW_FACTOR 8 ;
/* Will set below in our ruleset */
/* SELECTED_CW_FACTOR=SUGGESTED_CW_FACTOR; */

/* Definitions */
/* CURRENT_CW_FACTOR='What is the value of the factor we are currently using? Example: What is the factor today being used when a car color is red? ' */
/* CW_MODEL_FACTOR = 'This is the factor output by the Model after exponentiation (exp(.06) = 1.06183). No modifications have been made to this factor after exponentiation' */
/* CW_RULE_USED='What rules have been applied if any? Example: Capping rule that caps the change from new to old factor at +-3%' */
/* COMMENTS='Use of field is optional for analyst. Can use this field to explain their motivation for their final selected factor' */
/* CURRENT_WP='Sum of key metric to show how much business we have in a segment. This variable will be very useful during impact analyst studies' */
/* EFFECT='These are the input variables to the model. Examples: Gender, Age, State and to include interactions, Interaction Example: Gender*Age' */
/* EXPOSURE='Very similar to the CURRENT_WP variable, but it can be a different variable. Example: You could use Current_Revenue and EXPOSURE could represent Count of customers' */
/* MODEL='Name of our Model' */
/* SELECTED_CW_FACTOR='Automatically set to SUGGESTED_CW_FACTOR, then analyst reviews, they can accept the default value or change to any logical value. Think of this as the Final Factor because  */
/* this factor will be used in desired calculation' */
/* SUGGESTED_CW_FACTOR='This is the value of the factor output by the model AFTER any rules have been applied. If no rules have been applied, then SUGGESTED_CW_FACTOR=CW_MODEL_FACTOR' */

label
CURRENT_CW_FACTOR='Current CW Factor'
CW_MODEL_FACTOR = 'Factor\Estimate from CW Model'
CW_RULE_USED='CW Rule Used'
COMMENTS='Analyst COMMENTS'
CURRENT_WP='Currrent WP'
EFFECT='Effect\Inputs'
EXPOSURE='EXPOSURE'
MODEL='Model'
SELECTED_CW_FACTOR='Select CW Factor'
SUGGESTED_CW_FACTOR='Suggested CW Factor';

Length COMMENTS $100;
Length UNIQUE_ID $5;

UNIQUE_ID=put(_n_,z5.);

/* NumericValue1=input(substr(value1,1,2),8.); */

drop Group: a b u  &TARGET_VAR. Estimate LEVELS	Record_ID x z c d e;
RUN;

PROC SQL;
/* THE NUMBER 3.21 BELOW IS ARBITRARY, JUST WANTED TO BUMP UP TOTAL, AS IS VALUE OF PUREPREMIUM WAS ABOUT $5M. PUREPREMIM DOES NOT REMAIN ON TABLE */
/* THAT IS WHY I SAY IT'S ARBITRARY */
SELECT SUM(PurePremium) * 3.21 INTO :ONE_LEVEL_PREM FROM CASUSER.PUREPREM_W_DATAPREP;
SELECT COUNT(*) INTO :ONE_LEVEL_EXPOSURE FROM CASUSER.PUREPREM_W_DATAPREP;
QUIT;

DATA WORK.FINAL_TABLE2;
SET WORK.FINAL_TABLE(OBS=1);
UNIQUE_ID='99999';
CW_RULE_USED='N/A';
EFFECT='ONE LEVEL SUMMARY';
ANALYST='N/A';
LEVEL1 = 'N/A';LEVEL2 = 'N/A';LEVEL3 = 'N/A';LEVEL4 = 'N/A';
VALUE1 = 'N/A';VALUE2 = 'N/A';VALUE3 = 'N/A';VALUE4 = 'N/A';
COMMENTS = 'N/A';

BOOK_PREMIUM = &ONE_LEVEL_PREM;
BOOK_EXPOSURE = &ONE_LEVEL_EXPOSURE;

EXPOSURE=0;
CURRENT_WP=0;
CURRENT_CW_FACTOR=1;
CW_MODEL_FACTOR=1;
SUGGESTED_CW_FACTOR=1;

RUN;



proc casutil;
	droptable incaslib="CASUSER" casdata="CW_FACTORS" quiet;
run;QUIT;

DATA CASUSER.CW_FACTORS(PROMOTE=YES);
retain
UNIQUE_ID CW_RULE_USED MODEL EFFECT EXPOSURE CURRENT_WP STATE LEVEL1 LEVEL2 LEVEL3 LEVEL4 VALUE1 VALUE2 VALUE3
VALUE4 CURRENT_CW_FACTOR CW_MODEL_FACTOR SUGGESTED_CW_FACTOR ANALYST SELECTED_CW_FACTOR COMMENTS;

	SET WORK.FINAL_TABLE  WORK.FINAL_TABLE2
;

RUN;

proc casutil;
	save incaslib="CASUSER" outcaslib="CASUSER" casdata="CW_FACTORS" replace;
run;QUIT;








