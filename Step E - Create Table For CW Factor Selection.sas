data Estimates;
set DATAFLDR.TEMPPARMEST(RENAME=(Effect=TEMP_EFFECT));

WHERE UPCASE(TEMP_EFFECT) not in ('DISPERSION', 'INTERCEPT','POWER');



LENGTH LEVEL1 LEVEL2 LEVEL3 LEVEL4 $32;
LENGTH VALUE1 VALUE2 VALUE3 VALUE4  CW_RULE_USED MODEL $50;
LENGTH STATE $2;
LENGTH EFFECT $100;
EFFECT=TRIM(TEMP_EFFECT);

MODEL="&MODEL_BLD."; /* from step C */
STATE="&MODEL_STATE."; /* from step C */


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

Current_WP =.;
Exposure=.;
&TARGET_VAR.=.;
keep value: level: GROUP: Record_ID Estimate EFFECT Exposure Model State Current_WP &TARGET_VAR.;
run;
