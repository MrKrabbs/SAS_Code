proc printto log='/home/sasdemo/Claims/mylog.log';run;

cas;
caslib _all_ assign;


options fullstimer;run;
 LIBNAME MY_DATA '/home/sasdemo/Claims/CLM_Data';RUN;
     
DATA CASUSER.STACK;
SET MY_DATA.STACK;
RUN;
       
DATA CASUSER.ENDING(rename=(time=end_time value=end_value));
SET CASUSER.STACK(keep=obs time value);
RUN;
      
proc sql;
select count(*) into:Numrecs from MY_DATA.STACK;
quit;
      
%put number of records in Stack and Ending is &Numrecs;
     
proc fedsql SESSREF=CASAUTO;
CREATE TABLE CASUSER.CARTESIAN {options replace=true copies=0} as
SELECT B.*, E.END_TIME, E.END_VALUE, E.END_VALUE - B.VALUE as WALK
FROM CASUSER.STACK as B, CASUSER.ENDING as E
 WHERE      B.OBS = E.OBS
AND B.TIME < E.END_TIME;
 quit;
      
 /* below just tells us how many records were output by the Cartesian process */
proc cas;
session casauto;
simple.numRows result=nrows status=s /
table={caslib="CASUSER", name="CARTESIAN"};
       
if (s.severity == 0) then
print "Number of records in Cartesian table is :" nrows["numrows"];
run;
quit;

       
Proc cas;
session casauto;
simple.summary  /
inputs={"VALUE","END_VALUE","WALK"},
subSet={"SUM", "MEAN", "N"},
table={caslib="CASUSER", name="CARTESIAN",
 groupBy={"ATTRIBUTE","TIME","END_TIME"}},
casout={caslib="CASUSER",name="MY_SUM_USING_SIMPLE", replace=True};
run;
quit;



proc printto;run;

