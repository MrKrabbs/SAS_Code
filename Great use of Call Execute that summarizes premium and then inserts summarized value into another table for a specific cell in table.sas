%LET SRC_TABLE=CASUSER.CARS_GLM;
%LET TARGET_VAR=MSRP;



DATA &SRC_TABLE.;
SET SASHELP.CARS;
RUN;

ods output close;
ods output  ParameterEstimates=work.tempParmEst;
proc genselect data=&SRC_TABLE. TECH=nrridg maxiter=1000;
	class TYPE ORIGIN DRIVETRAIN; 
	model &TARGET_VAR=EngineSize Cylinders Horsepower Weight Wheelbase TYPE ORIGIN DRIVETRAIN
TYPE*ORIGIN*DRIVETRAIN EngineSize*Cylinders*Horsepower TYPE*Cylinders*Horsepower EngineSize*Cylinders*DRIVETRAIN
 / dist=GAMMA;
/* 	selection method=stepwise(select=aic stop=aic choose=aic) hierarchy=none; */
output out=CASUSER.GLM_OUT predicted copyvars=(_all_);
run;
ods work.tempParmEst CLOSE;



/* below we rename Effect and then re-establish Effect as a new variable with length $100. Want to make length of Effect longer to avoid data errors*/
/* will get log errors as VValueX pukes if you pass it a null, this error is ok\expected*/
data Estimates;
set WORK.tempParmEst(RENAME=(Effect=TEMP_EFFECT));
WHERE UPCASE(TEMP_EFFECT) not in ('DISPERSION', 'INTERCEPT','POWER');



LENGTH LEVEL1 LEVEL2 LEVEL3 LEVEL4 $32;
LENGTH VALUE1 VALUE2 VALUE3 VALUE4  CW_RULE_USED MODEL $50;
LENGTH STATE $2;
LENGTH EFFECT $100;
EFFECT=TRIM(TEMP_EFFECT);

MODEL='Pure Premium Liability';
STATE='CW';

LEVEL1=''; LEVEL2=''; LEVEL3=''; LEVEL4=''; 
VALUE1=''; VALUE2=''; VALUE3=''; VALUE4=''; 

LEVELS=countc(effect,'*') + 1;
if LEVELS > 0 then 
do;
LEVEL1=scan(effect,1,'*');
VALUE1=VVALUEX(LEVEL1);
IF VALUE1='' THEN VALUE1='INTERVAL';
end;

if LEVELS > 1 then 
do;
LEVEL2=scan(effect,2,'*');
VALUE2=VVALUEX(LEVEL2);
IF VALUE2='' THEN VALUE2='INTERVAL';

end;

if LEVELS > 2 then 
do;
LEVEL3=scan(effect,3,'*');
VALUE3=VVALUEX(LEVEL3);
IF VALUE3='' THEN VALUE3='INTERVAL';

end;

if LEVELS > 3 then 
do;
LEVEL4=scan(effect,4,'*');
VALUE4=VVALUEX(LEVEL4);
IF VALUE4='' THEN VALUE4='INTERVAL';

end;

KEEP EFFECT ESTIMATE LEVEL1 LEVEL2 LEVEL3 LEVEL4 VALUE1 VALUE2 VALUE3 VALUE4
MODEL STATE LEVELS MODEL STATE;

run;



data Estimates2;
set Estimates;

Record_ID=_n_;

LENGTH GroupStatement $150;

if Value1='INTERVAL' then Level1='';
if Value2='INTERVAL' then Level2='';
if Value3='INTERVAL' then Level3='';
if Value4='INTERVAL' then Level4='';

if LEVEL1 ='' THEN GROUP1=0;else GROUP1=1;
if LEVEL2 ='' THEN GROUP2=0;else GROUP2=2;
if LEVEL3 ='' THEN GROUP3=0;else GROUP3=4;
if LEVEL4 ='' THEN GROUP4=0;else GROUP4=8;

GroupSum=sum(0,GROUP1,GROUP2,GROUP3,GROUP4);

IF GroupSum=1 then GroupStatement = LEVEL1;
IF GroupSum=2 then GroupStatement = LEVEL2;
IF GroupSum=3 then GroupStatement = CATS(LEVEL1,'*',LEVEL2);
IF GroupSum=4 then GroupStatement = LEVEL3;
IF GroupSum=5 then GroupStatement = CATS(LEVEL1,'*',LEVEL3);
IF GroupSum=6 then GroupStatement = CATS(LEVEL2,'*',LEVEL3);
IF GroupSum=7 then GroupStatement = CATS(LEVEL1,'*',LEVEL2,' ',LEVEL3);
IF GroupSum=8 then GroupStatement = LEVEL4;
IF GroupSum=9 then GroupStatement = CATS(LEVEL1,'*',LEVEL4);
IF GroupSum=10 then GroupStatement = CATS(LEVEL2,'*',LEVEL4);
IF GroupSum=11 then GroupStatement = CATS(LEVEL1,'*',LEVEL2,'*',LEVEL4);
IF GroupSum=12 then GroupStatement = CATS(LEVEL3,'*',LEVEL4);
IF GroupSum=13 then GroupStatement = CATS(LEVEL1,'*',LEVEL3,'*',LEVEL4);
IF GroupSum=14 then GroupStatement = CATS(LEVEL2,'*',LEVEL3,'*',LEVEL4);
IF GroupSum=15 then GroupStatement = CATS(LEVEL1,'*',LEVEL2,'*',LEVEL3,'*',LEVEL4);

&TARGET_VAR.=.;
Exposure=.;

keep value: level: GROUP: Record_ID Estimate EFFECT &target_var. Exposure Model State;
run;

/* SIMPLY NEED TO RUN MACRO TO COMPILE FOR USE */

/* Goal of Marco: Tag summarized premium (or some other metric) onto our Estimates table */

/* OPTIONS MERROR SYMBOLGEN MLOGIC MPRINT SOURCE SOURCE2; */

%macro UpdatePremiumAndFreq(Record_ID,GROUPSUM,Level1=,Value1=,Level2=,Value2=,Level3=,Value3=,Level4=,Value4=);

%if &GROUPSUM=1 %then %do;

proc sql noprint;
	update work.Estimates2 as u set &TARGET_VAR=(select sum(&TARGET_VAR) from 
		&SRC_TABLE. where &Level1="&Value1") , Exposure=(select 
		count(*) from &SRC_TABLE. where &Level1="&Value1") where 
		u.Record_ID=&Record_ID;
quit;

%end;

%if &GROUPSUM=2 %then %do;

proc sql noprint;
	update work.Estimates2 as u set &TARGET_VAR=(select sum(&TARGET_VAR) from 
		&SRC_TABLE. where &Level2="&Value2") , Exposure=(select 
		count(*) from &SRC_TABLE. where &Level2="&Value2") where 
		u.Record_ID=&Record_ID;
quit;

%end;
%if &GROUPSUM=3 %then %do;

proc sql noprint;
	update work.Estimates2 as u set &TARGET_VAR=(select sum(&TARGET_VAR) from 
		&SRC_TABLE. where &Level1="&Value1" and &Level2="&Value2") , 
		Exposure=(select count(*) from &SRC_TABLE. 
		where &Level1="&Value1" and &Level2="&Value2") where u.Record_ID=&Record_ID;
quit;

%end;
%if &GROUPSUM=4 %then %do;

proc sql noprint;
	update work.Estimates2 as u set &TARGET_VAR=(select sum(&TARGET_VAR) from 
		&SRC_TABLE. where &Level3="&Value3") , Exposure=(select 
		count(*) from &SRC_TABLE. where &Level3="&Value3") where 
		u.Record_ID=&Record_ID;
quit;

%end;
%if &GROUPSUM=5 %then %do;

proc sql noprint;
	update work.Estimates2 as u set &TARGET_VAR=(select sum(&TARGET_VAR) from 
		&SRC_TABLE. where &Level1="&Value1" and &Level3="&Value3") , 
		Exposure=(select count(*) from &SRC_TABLE. 
		where &Level1="&Value1" and &Level3="&Value3") where u.Record_ID=&Record_ID;
quit;

%end;
%if &GROUPSUM=6 %then %do;

proc sql noprint;
	update work.Estimates2 as u set &TARGET_VAR=(select sum(&TARGET_VAR) from 
		&SRC_TABLE. where &Level3="&Value3" and &Level2="&Value2") , 
		Exposure=(select count(*) from &SRC_TABLE. 
		where &Level3="&Value3" and &Level2="&Value2") where u.Record_ID=&Record_ID;
quit;

%end;
%if &GROUPSUM=7 %then %do;

proc sql noprint;
	update work.Estimates2 as u set &TARGET_VAR=(select sum(&TARGET_VAR) from 
		&SRC_TABLE. where &Level1="&Value1" and &Level2="&Value2" 
		and &Level3="&Value3") , Exposure=(select count(*) from 
		&SRC_TABLE. where &Level1="&Value1" and &Level2="&Value2" 
		and &Level3="&Value3") where u.Record_ID=&Record_ID;
quit;

%end;
%if &GROUPSUM=8 %then %do;

proc sql noprint;
	update work.Estimates2 as u set &TARGET_VAR=(select sum(&TARGET_VAR) from 
		&SRC_TABLE. where &Level3="&Value4") , Exposure=(select 
		count(*) from &SRC_TABLE. where &Level4="&Value4") where 
		u.Record_ID=&Record_ID;
quit;

%end;
%if &GROUPSUM=9 %then %do;

proc sql noprint;
	update work.Estimates2 as u set &TARGET_VAR=(select sum(&TARGET_VAR) from 
		&SRC_TABLE. where &Level1="&Value1" and &Level4="&Value4") , 
		Exposure=(select count(*) from &SRC_TABLE. 
		where &Level1="&Value1" and &Level4="&Value4") where u.Record_ID=&Record_ID;
quit;

%end;
%if &GROUPSUM=10 %then %do;

proc sql noprint;
	update work.Estimates2 as u set &TARGET_VAR=(select sum(&TARGET_VAR) from 
		&SRC_TABLE. where &Level4="&Value4" and &Level2="&Value2") , 
		Exposure=(select count(*) from &SRC_TABLE. 
		where &Level4="&Value4" and &Level2="&Value2") where u.Record_ID=&Record_ID;
quit;

%end;
%if &GROUPSUM=11 %then %do;

proc sql noprint;
	update work.Estimates2 as u set &TARGET_VAR=(select sum(&TARGET_VAR) from 
		&SRC_TABLE. where &Level1="&Value1" and &Level2="&Value2" 
		and &Level4="&Value4") , Exposure=(select count(*) from 
		&SRC_TABLE. where &Level1="&Value1" and &Level2="&Value2" 
		and &Level4="&Value4") where u.Record_ID=&Record_ID;
quit;

%end;
%if &GROUPSUM=12 %then %do;

proc sql noprint;
	update work.Estimates2 as u set &TARGET_VAR=(select sum(&TARGET_VAR) from 
		&SRC_TABLE. where &Level3="&Value3" and &Level4="&Value4") , 
		Exposure=(select count(*) from &SRC_TABLE. 
		where &Level3="&Value3" and &Level4="&Value4") where u.Record_ID=&Record_ID;
quit;

%end;
%if &GROUPSUM=13 %then %do;

proc sql noprint;
	update work.Estimates2 as u set &TARGET_VAR=(select sum(&TARGET_VAR) from 
		&SRC_TABLE. where  &Level1="&Value1" and &Level3="&Value3" 
		and &Level4="&Value4") , Exposure=(select count(*) from 
		&SRC_TABLE. where  &Level1="&Value1" and &Level3="&Value3" 
		and &Level4="&Value4") where u.Record_ID=&Record_ID;
quit;

%end;
%if &GROUPSUM=14 %then %do;

proc sql noprint;
	update work.Estimates2 as u set &TARGET_VAR=(select sum(&TARGET_VAR) from 
		&SRC_TABLE. where &Level2="&Value2" and &Level3="&Value3" 
		and &Level4="&Value4") , Exposure=(select count(*) from 
		&SRC_TABLE. where  &Level2="&Value2" and &Level3="&Value3" 
		and &Level4="&Value4") where u.Record_ID=&Record_ID;
quit;

%end;
%if &GROUPSUM=15 %then %do;

proc sql noprint;
	update work.Estimates2 as u set &TARGET_VAR=(select sum(&TARGET_VAR) from 
		&SRC_TABLE. where &Level1="&Value1" and &Level2="&Value2" 
		and &Level3="&Value3" and &Level4="&Value4") , Exposure=(select count(*) from 
		&SRC_TABLE. where  &Level1="&Value1" and &Level2="&Value2" 
		and &Level3="&Value3" and &Level4="&Value4") where u.Record_ID=&Record_ID;
quit;

%end;

%mend UpdatePremiumAndFreq;


/* BELOW WILL POPULATE THE VALUE OF PREMIUM AND FREQUENCY IN OUR ESTIMATES TABLE*/
/* IS THERE A BETTER WAY TO ACCOMPLISH? PROBABLY, BUT HAD TO MOVE ON */
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
retain CW_RULE_USED	MODEL	EFFECT	Exposure	Current_&TARGET_VAR.	STATE	LEVEL1	LEVEL2	LEVEL3	LEVEL4	VALUE1	VALUE2	VALUE3	VALUE4	
CURRENT_CW_Factor	CW_Model_Factor	Suggested_CW_Factor	SELECTED_CW_FACTOR	Comments;

SET work.Estimates2;

CW_Model_Factor=exp(estimate);
Suggested_CW_Factor=CW_Model_Factor;

call streaminit(123);
a = .95; 
b = 1.05;
u = rand("Uniform");            /* decimal values in (0,1)    */
x = a + (b-a)*u;                /* decimal values (a,b)       */

CURRENT_CW_Factor=CW_Model_Factor * x;
CW_RULE_USED='CW_CappingRule_0';


call streaminit(456);
a = .92; 
b = 1.08;
u = rand("Uniform");            /* decimal values in (0,1)    */
x = a + (b-a)*u;                /* decimal values (a,b)       */
Current_&TARGET_VAR. = x * &TARGET_VAR.;



Suggested_CW_Factor=CW_Model_Factor;

if X < .97 then Suggested_CW_Factor = CURRENT_CW_Factor * 1.03;
if X > 1.03 then Suggested_CW_Factor = CURRENT_CW_Factor * .97;

SELECTED_CW_FACTOR=Suggested_CW_Factor;

label
CURRENT_CW_Factor='What is the value of the factor we are currently using? Example: What is the factor today being used when a car color is red? '
CW_Model_Factor = 'This is the factor output by the Model after exponentiation (exp(.06) = 1.06183). No modifications have been made to this factor after exponentiation'
CW_RULE_USED='What rules have been applied if any? Example: Capping rule that caps the change from new to old factor at +-3%'
Comments='Use of field is optional for analyst. Can use this field to explain their motivation for their final selected factor'
Current_&TARGET_VAR.='Sum of key metric to show how much business we have in a segment. This variable will be very useful during impact analyst studies'
EFFECT='These are the input variables to the model. Examples: Gender, Age, State and to include interactions, Interaction Example: Gender*Age'
Exposure='Very similar to the Current variable, but it can be a different variable. Example: You could use Current_Revenue and Exposure could represent Count of customers'
MODEL='Name of our Model'
SELECTED_CW_FACTOR='Automatically set to Suggested_CW_Factor, then analyst reviews, they can accept the default value or change to any logical value. Think of this as the Final Factor because 
this factor will be used in desired calculation'
Suggested_CW_Factor='This is the value of the factor output by the model AFTER any rules have been applied. If no rules have been applied, then Suggested_CW_Factor=CW_Model_Factor'

;

Length Comments $100;
drop Group: a b u x &TARGET_VAR. Estimate LEVELS	Record_ID;


RUN;

proc contents data=work.final_table;






