/* we know we have missing for our variable occupancy. lets deal with that before we send to label encoding */

proc casutil;
    droptable incaslib="CASUSER" casdata="D_TEMP_PUREPREM_DATA_MISSING" quiet;
run;QUIT;

data CASUSER.D_TEMP_PUREPREM_DATA_MISSING(promote=yes);
	set CASUSER.PUREPREM_DATA;

	/* 0 means false-not missing and 1 means missing */
	Occup_Miss_Flag=0;

	if Occupation='' then
		Do;
			Occupation='Value was missing';
			Occup_Miss_Flag=1;
		END;

label 
Age = 'Driver Age'
Bluebook = 'Blue book value of vehicle'
CarUse = 'Car use commercial or personal'
Car_Age= 'Age of vehicle'
Car_Type = 'Type of Vehicle'
DUI='Convicted of DUI in the last five years'
Education='Level of education obtained'
Gender='Gender'
Income='Annualized income'
Marital_Status='Married or Single(to include divorced)'
MVR_PNTS='Number of motor vehicle penatly points assessed in last three years'
Occupation = 'Current occupation'
Origination_source='Procurring source of insured: Web or agent'
PurePremium='Total ultimate loss dollars (to include IBNR) for policy'
Rating_Category='Rating category based off issuing company'
Revoked='Had license revoked in last five years'
Travel_time = 'Travel time to work'
_PartInd_ = 'Parition variable (training and validation)'
uniqueRecordID='Unique record ID'
Occup_Miss_Flag='Is Occupancy value missing'
;

/**************    Create Ordinal Variables from review of our Excel file: LessHS,HighSchool,Bachelors,Masters, PHD ****************************/
length ORD_Education 8;

/* using upcase so I don't have to worry about case */
if UPCASE(Education)='LESSHS' THEN ORD_Education = 1;
ELSE IF UPCASE(Education)='HIGHSCHOOL' THEN ORD_Education = 2;
ELSE IF UPCASE(Education)='BACHELORS' THEN ORD_Education = 3;
ELSE IF UPCASE(Education)='MASTERS' THEN ORD_Education = 4;
ELSE IF UPCASE(Education)='PHD' THEN ORD_Education = 5;
ELSE ORD_Education = 6;

label ORD_Education ='Ordinal encoding for education';
run;

