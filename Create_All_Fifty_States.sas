Proc sql;
select distinct statecode into :StateTables1- from MAPSGFK.US_STATES where statecode not in ('DC','PR');
quit;

%macro create_state_tables;

%do i = 1 %to &sqlobs;


Data WORK.TEMP_&&StateTables&i.._FACTORS;
SET &_input1.(DROP=UNIQUE_ID);
BY EFFECT;


ANALYST ='';
/* LINES BELOW ARE USED TO "MAKE UP" A PREVIOUS STATE FACTOR SINCE WE DON'T HAVE ONE */
call streaminit(123);
a = .97; 
b = 1.02;
u = rand("Uniform");            /* decimal values in (0,1)    */
x = a + (b-a)*u;                /* decimal values (a,b)       */


CURRENT_CW_FACTOR=CURRENT_CW_FACTOR * x;

CURRENT_WP = INT(CURRENT_WP/50);
EXPOSURE = INT(EXPOSURE/50);

IF FIRST.EFFECT THEN DO;
	TEMP_BOOK_PREMIUM=0;
	TEMP_BOOK_EXPOSURE=0;
END;

TEMP_BOOK_PREMIUM + CURRENT_WP;
TEMP_BOOK_EXPOSURE + EXPOSURE;

IF LAST.EFFECT THEN DO;
BOOK_PREMIUM =TEMP_BOOK_PREMIUM;
BOOK_EXPOSURE =TEMP_BOOK_EXPOSURE;
END;

/* END OF CREATING PREVIOUS STATE FACTOR ---NOTE: CURRENT_CW_FACTOR WILL BE RENAMED TO CURRENT_STATE_FACTOR */
LENGTH UNIQUE_ID $8;
UNIQUE_ID=CATS("&&StateTables&i.",'_',put(_n_,z5.));
STATE="&&StateTables&i.";

CW_RULE_USED='';

SUGGESTED_CW_FACTOR = SELECTED_CW_FACTOR;

LABEL CW_RULE_USED = 'STATE_RULE_USED';

RENAME CW_RULE_USED = STATE_RULE_USED
CURRENT_CW_FACTOR=CURRENT_STATE_FACTOR
SUGGESTED_CW_FACTOR=SUGGESTED_STATE_FACTOR
SELECTED_CW_FACTOR	=SELECTED_STATE_FACTOR;


Drop CW_Model_FACTOR _sid_perf a b u x TEMP_BOOK_PREMIUM TEMP_BOOK_EXPOSURE;
RUN;
%END;

proc casutil;
	droptable incaslib="CASUSER" casdata="STATES" quiet;
run;QUIT;

DATA CASUSER.STATES(PROMOTE=YES);
SET 
%do j = 1 %to &sqlobs;
WORK.TEMP_&&StateTables&j.._FACTORS
%end;
;
run;

%MEND create_state_tables;

%create_state_tables ;

proc casutil;
    save incaslib="CASUSER" outcaslib="CASUSER" casdata="STATES" replace;
run;QUIT;

proc datasets lib=WORK;
delete Temp_: ;
quit;
	