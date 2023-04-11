/* BELOW WILL CREATE ASSOCIATIONS BETWEEN INPUT VARIABLES AND TARGET */
proc cas;
	loadactionset "dataSciencePilot";
	dataSciencePilot.exploreCorrelation / 

		/* table we want to gain insights around is below */
		table={caslib="CASUSER",	name="PUREPREM_DATA"} 

		/* where do we want to save data around associations and correlations is below */
		casOut={caslib="CASUSER", name="ASSOC_W_TARGET"} 

		/* what metrics around associations and correlations do we want is below */
		stats=
			{nominalNominal={"CHISQ", "CRAMERSV", "ENTROPY", "G2","MI", "NORMMI", "SU"}, 
			 nominalInterval={"ENTROPY", "FTEST", "MI", "NORMMI","SU"}, 
			 intervalInterval={"ENTROPY", "MI", "NORMMI", "PEARSON", "SU"}} 
		
		/* what variables do we want  as inputs to be used in our statistical test is below*/
		inputs={
					{name="MARITAL_STATUS"}, {name="GENDER"}, {name="CARUSE"}, 
					{name="RATING_CATEGORY"}, {name="EDUCATION"}, {name="OCCUPATION"}, 
					{name="CAR_TYPE"}, {name="Revoked"}, {name="DUI"}, {name="AGE"}, 
					{name="BLUEBOOK"}, {name="CAR_AGE"}, {name="INCOME"}, {name="MVR_PNTS"}, 
					{name="TRAVEL_TIME"}
		} 

		/* which input variables are nominal_categorical variables is below. need this for associations that work specifically on nominal_categorical variables */
			nominals=
				{"MARITAL_STATUS", "GENDER", "CARUSE", "RATING_CATEGORY", "EDUCATION","OCCUPATION", "CAR_TYPE"},
		target="PurePremium";
	run;
quit;

/* BELOW WILL REMOVE TARGET SO THAT WE ONLY GET ASSOCIATIONS BETWEEN INPUT VARIABLES */
proc cas;
	loadactionset "dataSciencePilot";
	dataSciencePilot.exploreCorrelation / 

		/* table we want to gain insights around is below */
		table={caslib="CASUSER",	name="PUREPREM_DATA"} 

		/* where do we want to save data around associations and correlations is below */
		casOut={caslib="CASUSER", name="ASSOC_NO_TARGET"} 

		/* what metrics around associations and correlations do we want is below */
		stats=
			{nominalNominal={"CHISQ", "CRAMERSV", "ENTROPY", "G2","MI", "NORMMI", "SU"}, 
			 nominalInterval={"ENTROPY", "FTEST", "MI", "NORMMI","SU"}, 
			 intervalInterval={"ENTROPY", "MI", "NORMMI", "PEARSON", "SU"}} 
		
		/* what variables do we want  as inputs to be used in our statistical test is below*/
		inputs={
					{name="MARITAL_STATUS"}, {name="GENDER"}, {name="CARUSE"}, 
					{name="RATING_CATEGORY"}, {name="EDUCATION"}, {name="OCCUPATION"}, 
					{name="CAR_TYPE"}, {name="Revoked"}, {name="DUI"}, {name="AGE"}, 
					{name="BLUEBOOK"}, {name="CAR_AGE"}, {name="INCOME"}, {name="MVR_PNTS"}, 
					{name="TRAVEL_TIME"}
		} 

		/* which input variables are nominal_categorical variables is below. need this for associations that work specifically on nominal_categorical variables */
			nominals=
				{"MARITAL_STATUS", "GENDER", "CARUSE", "RATING_CATEGORY", "EDUCATION","OCCUPATION", "CAR_TYPE"};

	run;
quit;


Data CASUSER.TEMP_ASSOC_NO_TARGET; SET CASUSER.ASSOC_NO_TARGET;LENGTH TARGET_INCLUDED $1; TARGET_INCLUDED='N';RUN;
Data CASUSER.TEMP_ASSOC_W_TARGET; SET CASUSER.ASSOC_W_TARGET;LENGTH TARGET_INCLUDED $1; TARGET_INCLUDED='Y';RUN;

proc casutil;
	droptable incaslib="CASUSER" casdata="ASSOCIATIONS_OUT" quiet;
run;quit;

DATA CASUSER.ASSOCIATIONS_OUT(PROMOTE=YES);

SET 
	CASUSER.TEMP_ASSOC_NO_TARGET
	CASUSER.TEMP_ASSOC_W_TARGET;

RUN;

/* Save a physical copy of the table. The end result of the code below will be the creation of the physical file ASSOCIATIONS_OUT.HDAT IN THE CASUSER FOLDER */
proc casutil;
	save incaslib="CASUSER" outcaslib="CASUSER" casdata="ASSOCIATIONS_OUT" replace;
run;quit;


/* run below only if the table has dropped out of memory */
/* proc casutil incaslib="CASUSER" outcaslib="CASUSER"; */
/* 	droptable casdata="ASSOCIATIONS_OUT" quiet; */
/* 	load casdata="ASSOCIATIONS_OUT.sashdat" casout="ASSOCIATIONS_OUT" promote; */
/* run;quit; */































