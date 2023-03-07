DATA PUBLIC.TEST_CARS_ENC(PROMOTE=YES);
SET SASHELP.CARS;
RUN;

proc cas;datapreprocess.cattrans /table ={caslib="Public",name="TEST_CARS_ENC"} inputs=${Make} tech="label" 
casout={name="ENC_OUT",replace=true} outVarsNamePrefix="ENC" copyallvars=true;run;quit;

data casuser.step2;
set CASUSER.ENC_OUT;

keep make ENC_MAKE;
RUN;
