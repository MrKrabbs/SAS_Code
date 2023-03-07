/***** Partition a cas table for the purpose of building a model */				
data CASUSER.CARS_TEMP;				
SET SASHELP.CARS;				
RUN;				
				
proc partition data=CASUSER.CARS_TEMP partind samppct=60 samppct2=10;	
by target variable;
	output out=CASUSER.MYCARS_PARTITION;			
run;				
				
/* 0=VALIDATION , 1=TRAIN, 2=TEST */				
/*** Analyze numeric variables ***/				
title "Descriptive Statistics for Numeric Variables";				
				
proc means data=CASUSER.MYCARS_PARTITION n nmiss min mean median max std;				
	var _PartInd_;			
run;				
				
title;				
				
proc univariate data=CASUSER.MYCARS_PARTITION noprint;				
	histogram _PartInd_;			
run;				
