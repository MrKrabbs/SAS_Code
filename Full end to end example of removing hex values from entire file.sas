LIBNAME TEMP_CLM '/opt/sas/viya/config/data/cas/default/public/';

data work.clean_step1;
set TEMP_CLM.SMALL_PREM_LOSS;

length New_AGE 8.;		
length New_BLUEBOOK 8.;		
length New_CAR_AGE 8.;		
length New_CELLPHONE 8.;		
length New_CITY_LAT 8.;		
length New_CITY_LONG 8.;		
length New_DUI 8.;		
length New_INCOME 8.;		
length New_KIDSDRIV 8.;		
length New_MVR_POINTS 8.;		
length New_PARENT1 8.;		
length New_Property_Exposure 8.;		
length New_REGION_LAT 8.;		
length New_REGION_LONG 8.;		
length New_REVOKED 8.;		
length New_TIF 8.;		
length New_YOJ 8.;		
length New_Ho_loss 8.;		
length New_Ho_prem 8.;		
length New_Auto_Loss 8.;		
length New_Auto_prem 8.;		
length New_clm_date 8.;		
length New_effective_date 8.;		
length New_clm_mo 8.;		
length New_effective_mo 8.;		
length New_clm_yr 8.;		
length New_effective_yr 8.;		
length New_Auto_Gross_profit 8.;		
length New_COUNTY 8.;		
length New_Ho_Gross_profit 8.;		
length New_LossAll 8.;		
length New_PremiumAll 8.;		
length New_ProfitAll 8.;		
length New_RISK_SCORE 8.;		
length New_TRAVTIME 8.;		
length New_Unique_rec 8.;		
length New_ZIPNBR 8.;		
length New_CAR_TYPE $11.;		
length New_CAR_USE $10.;		
length New_CDESCR $1024.;		
length New_CITY $50.;		
length New_COMPDESC $128.;		
length New_EDUCATION $16.;		
length New_GENDER $1.;		
length New_LOB $12.;		
length New_MAKETXT $25.;		
length New_MFR_NAME $40.;		
length New_MODELTXT $256.;		
length New_MSTATUS $1.;		
length New_OCCUPATION $12.;		
length New_OFFICE $50.;		
length New_POLICYNO $10.;		
length New_RATING_CATEGORY $1.;		
length New_REGION $41.;		
length New_URBANICITY $5.;		
length New_Adjuster $12.;		
length New_Broker $20.;		
length New_ID $15.;		
length New_ID1 $15.;		
length New_IDNAME $55.;		
length New_STATECODE $2.;		
length New_UW_Office $50.;		
length New_ZipCode $5.;		


New_AGE = prxchange('s/[^\x20-\x7E\x0A\x0D]//', -1,AGE);
New_Adjuster = prxchange('s/[^\x20-\x7E\x0A\x0D]//', -1,Adjuster);
New_Auto_Gross_profit = prxchange('s/[^\x20-\x7E\x0A\x0D]//', -1,Auto_Gross_profit);
New_Auto_Loss = prxchange('s/[^\x20-\x7E\x0A\x0D]//', -1,Auto_Loss);
New_Auto_prem = prxchange('s/[^\x20-\x7E\x0A\x0D]//', -1,Auto_prem);
New_BLUEBOOK = prxchange('s/[^\x20-\x7E\x0A\x0D]//', -1,BLUEBOOK);
New_Broker = prxchange('s/[^\x20-\x7E\x0A\x0D]//', -1,Broker);
New_CAR_AGE = prxchange('s/[^\x20-\x7E\x0A\x0D]//', -1,CAR_AGE);
New_CAR_TYPE = prxchange('s/[^\x20-\x7E\x0A\x0D]//', -1,CAR_TYPE);
New_CAR_USE = prxchange('s/[^\x20-\x7E\x0A\x0D]//', -1,CAR_USE);
New_CDESCR = prxchange('s/[^\x20-\x7E\x0A\x0D]//', -1,CDESCR);
New_CELLPHONE = prxchange('s/[^\x20-\x7E\x0A\x0D]//', -1,CELLPHONE);
New_CITY = prxchange('s/[^\x20-\x7E\x0A\x0D]//', -1,CITY);
New_CITY_LAT = prxchange('s/[^\x20-\x7E\x0A\x0D]//', -1,CITY_LAT);
New_CITY_LONG = prxchange('s/[^\x20-\x7E\x0A\x0D]//', -1,CITY_LONG);
New_COMPDESC = prxchange('s/[^\x20-\x7E\x0A\x0D]//', -1,COMPDESC);
New_COUNTY = prxchange('s/[^\x20-\x7E\x0A\x0D]//', -1,COUNTY);
New_DUI = prxchange('s/[^\x20-\x7E\x0A\x0D]//', -1,DUI);
New_EDUCATION = prxchange('s/[^\x20-\x7E\x0A\x0D]//', -1,EDUCATION);
New_GENDER = prxchange('s/[^\x20-\x7E\x0A\x0D]//', -1,GENDER);
New_Ho_Gross_profit = prxchange('s/[^\x20-\x7E\x0A\x0D]//', -1,Ho_Gross_profit);
New_Ho_loss = prxchange('s/[^\x20-\x7E\x0A\x0D]//', -1,Ho_loss);
New_Ho_prem = prxchange('s/[^\x20-\x7E\x0A\x0D]//', -1,Ho_prem);
New_ID = prxchange('s/[^\x20-\x7E\x0A\x0D]//', -1,ID);
New_ID1 = prxchange('s/[^\x20-\x7E\x0A\x0D]//', -1,ID1);
New_IDNAME = prxchange('s/[^\x20-\x7E\x0A\x0D]//', -1,IDNAME);
New_INCOME = prxchange('s/[^\x20-\x7E\x0A\x0D]//', -1,INCOME);
New_KIDSDRIV = prxchange('s/[^\x20-\x7E\x0A\x0D]//', -1,KIDSDRIV);
New_LOB = prxchange('s/[^\x20-\x7E\x0A\x0D]//', -1,LOB);
New_LossAll = prxchange('s/[^\x20-\x7E\x0A\x0D]//', -1,LossAll);
New_MAKETXT = prxchange('s/[^\x20-\x7E\x0A\x0D]//', -1,MAKETXT);
New_MFR_NAME = prxchange('s/[^\x20-\x7E\x0A\x0D]//', -1,MFR_NAME);
New_MODELTXT = prxchange('s/[^\x20-\x7E\x0A\x0D]//', -1,MODELTXT);
New_MSTATUS = prxchange('s/[^\x20-\x7E\x0A\x0D]//', -1,MSTATUS);
New_MVR_POINTS = prxchange('s/[^\x20-\x7E\x0A\x0D]//', -1,MVR_POINTS);
New_OCCUPATION = prxchange('s/[^\x20-\x7E\x0A\x0D]//', -1,OCCUPATION);
New_OFFICE = prxchange('s/[^\x20-\x7E\x0A\x0D]//', -1,OFFICE);
New_PARENT1 = prxchange('s/[^\x20-\x7E\x0A\x0D]//', -1,PARENT1);
New_POLICYNO = prxchange('s/[^\x20-\x7E\x0A\x0D]//', -1,POLICYNO);
New_PremiumAll = prxchange('s/[^\x20-\x7E\x0A\x0D]//', -1,PremiumAll);
New_ProfitAll = prxchange('s/[^\x20-\x7E\x0A\x0D]//', -1,ProfitAll);
New_Property_Exposure = prxchange('s/[^\x20-\x7E\x0A\x0D]//', -1,Property_Exposure);
New_RATING_CATEGORY = prxchange('s/[^\x20-\x7E\x0A\x0D]//', -1,RATING_CATEGORY);
New_REGION = prxchange('s/[^\x20-\x7E\x0A\x0D]//', -1,REGION);
New_REGION_LAT = prxchange('s/[^\x20-\x7E\x0A\x0D]//', -1,REGION_LAT);
New_REGION_LONG = prxchange('s/[^\x20-\x7E\x0A\x0D]//', -1,REGION_LONG);
New_REVOKED = prxchange('s/[^\x20-\x7E\x0A\x0D]//', -1,REVOKED);
New_RISK_SCORE = prxchange('s/[^\x20-\x7E\x0A\x0D]//', -1,RISK_SCORE);
New_STATECODE = prxchange('s/[^\x20-\x7E\x0A\x0D]//', -1,STATECODE);
New_TIF = prxchange('s/[^\x20-\x7E\x0A\x0D]//', -1,TIF);
New_TRAVTIME = prxchange('s/[^\x20-\x7E\x0A\x0D]//', -1,TRAVTIME);
New_URBANICITY = prxchange('s/[^\x20-\x7E\x0A\x0D]//', -1,URBANICITY);
New_UW_Office = prxchange('s/[^\x20-\x7E\x0A\x0D]//', -1,UW_Office);
New_Unique_rec = prxchange('s/[^\x20-\x7E\x0A\x0D]//', -1,Unique_rec);
New_YOJ = prxchange('s/[^\x20-\x7E\x0A\x0D]//', -1,YOJ);
New_ZIPNBR = prxchange('s/[^\x20-\x7E\x0A\x0D]//', -1,ZIPNBR);
New_ZipCode = prxchange('s/[^\x20-\x7E\x0A\x0D]//', -1,ZipCode);
New_clm_date = prxchange('s/[^\x20-\x7E\x0A\x0D]//', -1,clm_date);
New_clm_mo = prxchange('s/[^\x20-\x7E\x0A\x0D]//', -1,clm_mo);
New_clm_yr = prxchange('s/[^\x20-\x7E\x0A\x0D]//', -1,clm_yr);
New_effective_date = prxchange('s/[^\x20-\x7E\x0A\x0D]//', -1,effective_date);
New_effective_mo = prxchange('s/[^\x20-\x7E\x0A\x0D]//', -1,effective_mo);
New_effective_yr = prxchange('s/[^\x20-\x7E\x0A\x0D]//', -1,effective_yr);

drop AGE Adjuster Auto_Gross_profit Auto_Loss Auto_prem BLUEBOOK Broker CAR_AGE CAR_TYPE CAR_USE CDESCR CELLPHONE CITY CITY_LAT CITY_LONG COMPDESC COUNTY DUI EDUCATION GENDER
Ho_Gross_profit	Ho_loss	Ho_prem	ID	ID1	IDNAME	INCOME	KIDSDRIV	LOB	LossAll	MAKETXT	MFR_NAME	MODELTXT MSTATUS	MVR_POINTS	OCCUPATION	OFFICE	PARENT1	POLICYNO	
PremiumAll	ProfitAll	Property_Exposure	RATING_CATEGORY	REGION	REGION_LAT	REGION_LONG	REVOKED	RISK_SCORE	STATECODE	TIF	TRAVTIME	URBANICITY	UW_Office	Unique_rec	YOJ	ZIPNBR	
ZipCode	clm_date	clm_mo	clm_yr	effective_date	effective_mo	effective_yr;

label
New_AGE = 'Age of Driver'
New_BLUEBOOK = 'Blue book value of Vehicle'
New_CAR_AGE = 'Age of Vehicle'
New_CELLPHONE = 'Cell Phone Usage: 1 = Lowest 6=Highest'
New_CITY_LAT = 'xyCity Latitude'
New_CITY_LONG = 'xyCity Longitude'
New_DUI = 'Convicted Driving Under the Influence'
New_INCOME = 'Income of Primary Insured'
New_KIDSDRIV = 'Number of Youthful drivers on policy'
New_MVR_POINTS = 'Number of Driver points (penalty) assessed'
New_PARENT1 = 'Number of Adults on Policy: 1 means 1 Adult, 0 means 2 Adults'
New_Property_Exposure = 'Property_Exposure'
New_REGION_LAT = 'xyRegion Latitude'
New_REGION_LONG = 'xyRegion Longitude'
New_REVOKED = 'Flag for Drivers License revocation'
New_TIF = 'Time in Force, number of years as customer'
New_YOJ = 'Years on job'
New_Ho_loss = 'HO Claim Amount'
New_Ho_prem = 'HO Prem Amount'
New_Auto_Loss = 'Auto Claim Amt'
New_Auto_prem = 'Auto Prem Amt'
New_clm_date = 'Claim Date'
New_effective_date = 'Policy Effective Date'
New_clm_mo = 'Claim Month'
New_effective_mo = 'Policy Effective Month'
New_clm_yr = 'Claim Year'
New_effective_yr = 'Policy Effective Year'
New_Auto_Gross_profit = 'Auto Grs Profit'
New_COUNTY = 'FIPS county code.'
New_Ho_Gross_profit = 'HO grs profit'
New_LossAll = 'Losss all lines'
New_PremiumAll = 'Premium all lines'
New_ProfitAll = 'Grs Profit all lines'
New_RISK_SCORE = 'Risk Score'
New_TRAVTIME = 'Travel Time to work'
New_Unique_rec = 'Unique Record ID'
New_ZIPNBR = 'Zip code nf'
New_CAR_TYPE = 'Type of Vehicle'
New_CAR_USE = 'Vehicle use'
New_CDESCR = 'DESCRIPTION OF COMPLAINT'
New_CITY = 'City'
New_COMPDESC = 'COMPONENT DESCRIPTION'
New_EDUCATION = 'Level of Education'
New_GENDER = 'Gender'
New_LOB = 'Line of Business'
New_MAKETXT = 'MAKE TEXT'
New_MFR_NAME = 'MFR NAME'
New_MODELTXT = 'MODEL TEXT'
New_MSTATUS = 'Marital Status'
New_OCCUPATION = 'Occupation'
New_OFFICE = 'Claim Handling Office'
New_POLICYNO = 'Policy Number'
New_RATING_CATEGORY = 'Rating Category'
New_REGION = 'Region'
New_URBANICITY = 'Located in Urban or Rural area'
New_Adjuster = 'Claim Handler'
New_Broker = 'Broker'
New_ID = 'Counties code'
New_ID1 = 'States code'
New_IDNAME = 'Counties name'
New_STATECODE = 'State'
New_UW_Office = 'Underwriting Office'
New_ZipCode = 'Zip code tf'
;

run;

DATA TEMP_CLM.SMALL_PREM_LOSS_CLEAN;
set work.clean_step1;


FORMAT New_AGE BEST12.;
FORMAT New_BLUEBOOK BEST12.;
FORMAT New_CAR_AGE BEST12.;
FORMAT New_CELLPHONE BEST12.;
FORMAT New_CITY_LAT BEST12.;
FORMAT New_CITY_LONG BEST14.;
FORMAT New_DUI BEST12.;
FORMAT New_INCOME BEST12.;
FORMAT New_KIDSDRIV BEST12.;
FORMAT New_MVR_POINTS BEST12.;
FORMAT New_PARENT1 BEST12.;
FORMAT New_Property_Exposure BEST12.;
FORMAT New_REGION_LAT BEST12.;
FORMAT New_REGION_LONG BEST14.;
FORMAT New_REVOKED BEST12.;
FORMAT New_TIF BEST12.;
FORMAT New_YOJ BEST12.;
FORMAT New_Ho_loss BEST12.;
FORMAT New_Ho_prem BEST12.;
FORMAT New_Auto_Loss BEST12.;
FORMAT New_Auto_prem BEST12.;
FORMAT New_clm_date MMDDYY10.;
FORMAT New_effective_date MMDDYY10.;
FORMAT New_clm_mo MMYYS7.;
FORMAT New_effective_mo MMYYS7.;
FORMAT New_clm_yr YEAR7.;
FORMAT New_effective_yr YEAR7.;
FORMAT New_Auto_Gross_profit BEST12.;
FORMAT New_COUNTY BEST12.;
FORMAT New_Ho_Gross_profit BEST12.;
FORMAT New_LossAll BEST12.;
FORMAT New_PremiumAll BEST12.;
FORMAT New_ProfitAll BEST12.;
FORMAT New_RISK_SCORE BEST12.;
FORMAT New_TRAVTIME BEST12.;
FORMAT New_Unique_rec BEST12.;
FORMAT New_ZIPNBR BEST12.;

RENAME
New_AGE = AGE
New_BLUEBOOK = BLUEBOOK
New_CAR_AGE = CAR_AGE
New_CELLPHONE = CELLPHONE
New_CITY_LAT = CITY_LAT
New_CITY_LONG = CITY_LONG
New_DUI = DUI
New_INCOME = INCOME
New_KIDSDRIV = KIDSDRIV
New_MVR_POINTS = MVR_POINTS
New_PARENT1 = PARENT1
New_Property_Exposure = Property_Exposure
New_REGION_LAT = REGION_LAT
New_REGION_LONG = REGION_LONG
New_REVOKED = REVOKED
New_TIF = TIF
New_YOJ = YOJ
New_Ho_loss = Ho_loss
New_Ho_prem = Ho_prem
New_Auto_Loss = Auto_Loss
New_Auto_prem = Auto_prem
New_clm_date = clm_date
New_effective_date = effective_date
New_clm_mo = clm_mo
New_effective_mo = effective_mo
New_clm_yr = clm_yr
New_effective_yr = effective_yr
New_Auto_Gross_profit = Auto_Gross_profit
New_COUNTY = COUNTY
New_Ho_Gross_profit = Ho_Gross_profit
New_LossAll = LossAll
New_PremiumAll = PremiumAll
New_ProfitAll = ProfitAll
New_RISK_SCORE = RISK_SCORE
New_TRAVTIME = TRAVTIME
New_Unique_rec = Unique_rec
New_ZIPNBR = ZIPNBR
New_CAR_TYPE = CAR_TYPE
New_CAR_USE = CAR_USE
New_CDESCR = CDESCR
New_CITY = CITY
New_COMPDESC = COMPDESC
New_EDUCATION = EDUCATION
New_GENDER = GENDER
New_LOB = LOB
New_MAKETXT = MAKETXT
New_MFR_NAME = MFR_NAME
New_MODELTXT = MODELTXT
New_MSTATUS = MSTATUS
New_OCCUPATION = OCCUPATION
New_OFFICE = OFFICE
New_POLICYNO = POLICYNO
New_RATING_CATEGORY = RATING_CATEGORY
New_REGION = REGION
New_URBANICITY = URBANICITY
New_Adjuster = Adjuster
New_Broker = Broker
New_ID = ID
New_ID1 = ID1
New_IDNAME = IDNAME
New_STATECODE = STATECODE
New_UW_Office = UW_Office
New_ZipCode = ZipCode
;


RUN;


