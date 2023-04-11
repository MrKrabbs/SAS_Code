filename mc url "https://raw.githubusercontent.com/sasjs/core/main/all.sas";
%inc mc;

%mv_createfolder(path=/Users/&sysuserid./My Folder/Leverage_Transformation_And_Scoring_Code)   ;
%mv_createfolder(path=/Users/&sysuserid./My Folder/Generate_CW_ScoringCode_Save_Into_Model_Repository)   ;
%mv_createfolder(path=/Users/&sysuserid./My Folder/OTS_Create_State_Factor_Table)   ;
%mv_createfolder(path=/Users/&sysuserid./My Folder/OTS_My_Tasks)   ;
%mv_createfolder(path=/Users/&sysuserid./My Folder/OTS_My_Programs)   ;
%mv_createfolder(path=/Users/&sysuserid./My Folder/OTS_Data_Preparation_Template)   ;
%mv_createfolder(path=/Users/&sysuserid./My Folder/OTS_Data_Preparation_Save_Here)   ;
%mv_createfolder(path=/Users/&sysuserid./My Folder/OTS_My_Data_Exported)   ;
%mv_createfolder(path=/Users/&sysuserid./My Folder/OTS_Build_GLM)   ;
%mv_createfolder(path=/Users/&sysuserid./My Folder/OTS_Build_GLM_Template)   ;
%mv_createfolder(path=/Users/&sysuserid./My Folder/OTS_GLM_SCORE_PROGRAMS)   ;
%mv_createfolder(path=/Users/&sysuserid./My Folder/OTS_Create_CW_Factor_Table)   ;

/*************************      COPY          ****************************/
filename sendfrom filesrvc folderpath='/Public/OverTheShoulder_SAS_Studio/Objects' filename='DATA_TO_BE_SCORED.sas';
filename sendto filesrvc folderpath="/Users/&sysuserid/My Folder/Leverage_Transformation_And_Scoring_Code" filename='DATA_TO_BE_SCORED.sas';


%let x=%sysfunc(fcopy(sendfrom, sendto));
%if &x %then %do;
%put &x - %sysfunc(sysmsg());
%end;
filename sendfrom clear;
filename sendto CLEAR;
/*************************      END   COPY       ****************************/


/*************************      COPY          ****************************/
filename sendfrom filesrvc folderpath='/Public/OverTheShoulder_SAS_Studio/Generate_CW_ScoringCode_Save_Into_Model_Repository' filename='Create_ScoringCode_After_Selections_Save_Into_Model_Repository.sas';
filename sendto filesrvc folderpath="/Users/&sysuserid/My Folder/Generate_CW_ScoringCode_Save_Into_Model_Repository" filename='Create_ScoringCode_After_Selections_Save_Into_Model_Repository.sas';


%let x=%sysfunc(fcopy(sendfrom, sendto));
%if &x %then %do;
%put &x - %sysfunc(sysmsg());
%end;
filename sendfrom clear;
filename sendto CLEAR;
/*************************      END   COPY       ****************************/

/*************************      COPY          ****************************/
filename sendfrom filesrvc folderpath='/Public/OverTheShoulder_SAS_Studio/Create_State_Factor_Table' filename='Create_All_Fifty_States.sas';
filename sendto filesrvc folderpath="/Users/&sysuserid/My Folder/OTS_Create_State_Factor_Table" filename='Create_All_Fifty_States.sas';


%let x=%sysfunc(fcopy(sendfrom, sendto));
%if &x %then %do;
%put &x - %sysfunc(sysmsg());
%end;
filename sendfrom clear;
filename sendto CLEAR;
/*************************      END   COPY       ****************************/

/*************************      COPY          ****************************/
filename sendfrom filesrvc folderpath='/Public/OverTheShoulder_SAS_Studio/Create_CW_Factor_Table' filename='Step A - View Models and Choose Model.sas';
filename sendto filesrvc folderpath="/Users/&sysuserid/My Folder/OTS_Create_CW_Factor_Table" filename='Step A - View Models and Choose Model.sas';


%let x=%sysfunc(fcopy(sendfrom, sendto));
%if &x %then %do;
%put &x - %sysfunc(sysmsg());
%end;
filename sendfrom clear;
filename sendto CLEAR;
/*************************      END   COPY       ****************************/

/*************************      COPY          ****************************/
filename sendfrom filesrvc folderpath='/Public/OverTheShoulder_SAS_Studio/Create_CW_Factor_Table' filename='Step C - Selected Model and Parameter Estimates .sas';
filename sendto filesrvc folderpath="/Users/&sysuserid/My Folder/OTS_Create_CW_Factor_Table" filename='Step C - Selected Model and Parameter Estimates .sas';


%let x=%sysfunc(fcopy(sendfrom, sendto));
%if &x %then %do;
%put &x - %sysfunc(sysmsg());
%end;
filename sendfrom clear;
filename sendto CLEAR;
/*************************      END   COPY       ****************************/

/*************************      COPY          ****************************/
filename sendfrom filesrvc folderpath='/Public/OverTheShoulder_SAS_Studio/Create_CW_Factor_Table' filename='Step E - Create Table For CW Factor Selection.sas';
filename sendto filesrvc folderpath="/Users/&sysuserid/My Folder/OTS_Create_CW_Factor_Table" filename='Step E - Create Table For CW Factor Selection.sas';


%let x=%sysfunc(fcopy(sendfrom, sendto));
%if &x %then %do;
%put &x - %sysfunc(sysmsg());
%end;
filename sendfrom clear;
filename sendto CLEAR;
/*************************      END   COPY       ****************************/

/*************************      COPY          ****************************/
filename sendfrom filesrvc folderpath='/Public/OverTheShoulder_SAS_Studio/Create_CW_Factor_Table' filename='Step G - Prepare for CW Rules.sas';
filename sendto filesrvc folderpath="/Users/&sysuserid/My Folder/OTS_Create_CW_Factor_Table" filename='Step G - Prepare for CW Rules.sas';


%let x=%sysfunc(fcopy(sendfrom, sendto));
%if &x %then %do;
%put &x - %sysfunc(sysmsg());
%end;
filename sendfrom clear;
filename sendto CLEAR;
/*************************      END   COPY       ****************************/

/*************************      COPY       ****************************/
filename sendfrom filesrvc folderpath='/Public/OverTheShoulder_SAS_Studio/SendTo_OTS_My_Tasks' filename='Generate Syntax.ctm';
filename sendto filesrvc folderpath="/Users/&sysuserid/My Folder/OTS_My_Tasks" filename='Generate Syntax.ctm';


%let x=%sysfunc(fcopy(sendfrom, sendto));
%if &x %then %do;
%put &x - %sysfunc(sysmsg());
%end;
filename sendfrom clear;
filename sendto CLEAR;
/*************************      END   COPY       ****************************/

/*************************      COPY    Step A - Create Freqs and ranges for UW.ctm        ****************************/
filename sendfrom filesrvc folderpath='/Public/OverTheShoulder_SAS_Studio/SendTo_OTS_My_Tasks' filename='Step A - Create Freqs and ranges for UW.ctm';
filename sendto filesrvc folderpath="/Users/&sysuserid/My Folder/OTS_My_Tasks" filename='Step A - Create Freqs and ranges for UW.ctm';


%let x=%sysfunc(fcopy(sendfrom, sendto));
%if &x %then %do;
%put &x - %sysfunc(sysmsg());
%end;
filename sendfrom clear;
filename sendto CLEAR;
/*************************      END   COPY       ****************************/


/*************************      COPY        ****************************/
filename sendfrom filesrvc folderpath='/Public/OverTheShoulder_SAS_Studio/SendTo_OTS_My_Programs' filename='Correlations and Associations.sas';
filename sendto filesrvc folderpath="/Users/&sysuserid/My Folder/OTS_My_Programs" filename='Correlations and Associations.sas';

%let x=%sysfunc(fcopy(sendfrom, sendto));
%if &x %then %do;
%put &x - %sysfunc(sysmsg());
%end;
filename sendfrom clear;
filename sendto CLEAR;
/*************************      END   COPY       ****************************/

/*************************      COPY        ****************************/
filename sendfrom filesrvc folderpath='/Public/OverTheShoulder_SAS_Studio/SendTo_OTS_Data_Preparation_Template' filename='Step D - DataPrep Missing Labels Ordinals.sas';
filename sendto filesrvc folderpath="/Users/&sysuserid/My Folder/OTS_Data_Preparation_Template" filename='Step D - DataPrep Missing Labels Ordinals.sas';

%let x=%sysfunc(fcopy(sendfrom, sendto));
%if &x %then %do;
%put &x - %sysfunc(sysmsg());
%end;
filename sendfrom clear;
filename sendto CLEAR;
/*************************      END   COPY       ****************************/

/*************************      COPY        ****************************/
filename sendfrom filesrvc folderpath='/Public/OverTheShoulder_SAS_Studio/SendTo_OTS_Data_Preparation_Template' filename='Step G - Transform and Bin Interval Variables.ctm';
filename sendto filesrvc folderpath="/Users/&sysuserid/My Folder/OTS_Data_Preparation_Template" filename='Step G - Transform and Bin Interval Variables.ctm';

%let x=%sysfunc(fcopy(sendfrom, sendto));
%if &x %then %do;
%put &x - %sysfunc(sysmsg());
%end;
filename sendfrom clear;
filename sendto CLEAR;
/*************************      END   COPY       ****************************/

/*************************      COPY        ****************************/
filename sendfrom filesrvc folderpath='/Public/OverTheShoulder_SAS_Studio/SendTo_OTS_Data_Preparation_Template' filename='Step J - Automated Feature Engineering.ctm';
filename sendto filesrvc folderpath="/Users/&sysuserid/My Folder/OTS_Data_Preparation_Template" filename='Step J - Automated Feature Engineering.ctm';

%let x=%sysfunc(fcopy(sendfrom, sendto));
%if &x %then %do;
%put &x - %sysfunc(sysmsg());
%end;
filename sendfrom clear;
filename sendto CLEAR;
/*************************      END   COPY       ****************************/

/*************************      COPY        ****************************/
filename sendfrom filesrvc folderpath='/Public/OverTheShoulder_SAS_Studio/SendTo_OTS_Data_Preparation_Template' filename='Step P - Ordinal and One-Hot Encoding.ctm';
filename sendto filesrvc folderpath="/Users/&sysuserid/My Folder/OTS_Data_Preparation_Template" filename='Step P - Ordinal and One-Hot Encoding.ctm';

%let x=%sysfunc(fcopy(sendfrom, sendto));
%if &x %then %do;
%put &x - %sysfunc(sysmsg());
%end;
filename sendfrom clear;
filename sendto CLEAR;
/*************************      END   COPY       ****************************/

/*************************      COPY        ****************************/
filename sendfrom filesrvc folderpath='/Public/OverTheShoulder_SAS_Studio/SendTo_OTS_Data_Preparation_Template' filename='Step R - Review Data.sas';
filename sendto filesrvc folderpath="/Users/&sysuserid/My Folder/OTS_Data_Preparation_Template" filename='Step R - Review Data.sas';

%let x=%sysfunc(fcopy(sendfrom, sendto));
%if &x %then %do;
%put &x - %sysfunc(sysmsg());
%end;
filename sendfrom clear;
filename sendto CLEAR;
/*************************      END   COPY       ****************************/

/*************************      COPY        ****************************/
filename sendfrom filesrvc folderpath='/Public/OverTheShoulder_SAS_Studio/SendTo_OTS_Data_Preparation_Template' filename='Step S - Load and Save Data.sas';
filename sendto filesrvc folderpath="/Users/&sysuserid/My Folder/OTS_Data_Preparation_Template" filename='Step S - Load and Save Data.sas';

%let x=%sysfunc(fcopy(sendfrom, sendto));
%if &x %then %do;
%put &x - %sysfunc(sysmsg());
%end;
filename sendfrom clear;
filename sendto CLEAR;
/*************************      END   COPY       ****************************/

/*************************      COPY        ****************************/
filename sendfrom filesrvc folderpath='/Public/OverTheShoulder_SAS_Studio/SendTo_OTS_Data_Preparation_Template' filename='Step Z - Create Data Dictionary.ctm';
filename sendto filesrvc folderpath="/Users/&sysuserid/My Folder/OTS_Data_Preparation_Template" filename='Step Z - Create Data Dictionary.ctm';

%let x=%sysfunc(fcopy(sendfrom, sendto));
%if &x %then %do;
%put &x - %sysfunc(sysmsg());
%end;
filename sendfrom clear;
filename sendto CLEAR;
/*************************      END   COPY       ****************************/

/*************************      COPY        ****************************/
filename sendfrom filesrvc folderpath='/Public/OverTheShoulder_SAS_Studio/SendTo_OTS_Build_GLM_Template' filename='Macro Variables For Flow.sas';
filename sendto filesrvc folderpath="/Users/&sysuserid/My Folder/OTS_Build_GLM_Template" filename='Macro Variables For Flow.sas';

%let x=%sysfunc(fcopy(sendfrom, sendto));
%if &x %then %do;
%put &x - %sysfunc(sysmsg());
%end;
filename sendfrom clear;
filename sendto CLEAR;
/*************************      END   COPY       ****************************/

/*************************      COPY        ****************************/
filename sendfrom filesrvc folderpath='/Public/OverTheShoulder_SAS_Studio/SendTo_OTS_Build_GLM_Template' filename='Variable Selection Core vs Non Core.ctm';
filename sendto filesrvc folderpath="/Users/&sysuserid/My Folder/OTS_Build_GLM_Template" filename='Variable Selection Core vs Non Core.ctm';

%let x=%sysfunc(fcopy(sendfrom, sendto));
%if &x %then %do;
%put &x - %sysfunc(sysmsg());
%end;
filename sendfrom clear;
filename sendto CLEAR;
/*************************      END   COPY       ****************************/

/************                       DATA Prep filled out sas, ctk and cqy files                        ******************/


/*************************      COPY        ****************************/
filename sendfrom filesrvc folderpath='/Public/OverTheShoulder_SAS_Studio/SendTo_OTS_Data_Preparation_Save_Here' filename='Step D - DataPrep Missing Labels Ordinals.sas';
filename sendto filesrvc folderpath="/Users/&sysuserid/My Folder/OTS_Data_Preparation_Save_Here" filename='Step D - DataPrep Missing Labels Ordinals.sas';

%let x=%sysfunc(fcopy(sendfrom, sendto));
%if &x %then %do;
%put &x - %sysfunc(sysmsg());
%end;
filename sendfrom clear;
filename sendto CLEAR;
/*************************      END   COPY       ****************************/

/*************************      COPY        ****************************/
filename sendfrom filesrvc folderpath='/Public/OverTheShoulder_SAS_Studio/SendTo_OTS_Data_Preparation_Save_Here' filename='Step G - Transform and Bin Interval Variables.ctk';
filename sendto filesrvc folderpath="/Users/&sysuserid/My Folder/OTS_Data_Preparation_Save_Here" filename='Step G - Transform and Bin Interval Variables.ctk';

%let x=%sysfunc(fcopy(sendfrom, sendto));
%if &x %then %do;
%put &x - %sysfunc(sysmsg());
%end;
filename sendfrom clear;
filename sendto CLEAR;
/*************************      END   COPY       ****************************/

/*************************      COPY        ****************************/
filename sendfrom filesrvc folderpath='/Public/OverTheShoulder_SAS_Studio/SendTo_OTS_Data_Preparation_Save_Here' filename='Step J - Automated Feature Engineering.ctk';
filename sendto filesrvc folderpath="/Users/&sysuserid/My Folder/OTS_Data_Preparation_Save_Here" filename='Step J - Automated Feature Engineering.ctk';

%let x=%sysfunc(fcopy(sendfrom, sendto));
%if &x %then %do;
%put &x - %sysfunc(sysmsg());
%end;
filename sendfrom clear;
filename sendto CLEAR;
/*************************      END   COPY       ****************************/

/*************************      COPY        ****************************/
filename sendfrom filesrvc folderpath='/Public/OverTheShoulder_SAS_Studio/SendTo_OTS_Data_Preparation_Save_Here' filename='Step P - Ordinal and One-Hot Encoding.ctk';
filename sendto filesrvc folderpath="/Users/&sysuserid/My Folder/OTS_Data_Preparation_Save_Here" filename='Step P - Ordinal and One-Hot Encoding.ctk';

%let x=%sysfunc(fcopy(sendfrom, sendto));
%if &x %then %do;
%put &x - %sysfunc(sysmsg());
%end;
filename sendfrom clear;
filename sendto CLEAR;
/*************************      END   COPY       ****************************/

/*************************      COPY        ****************************/
filename sendfrom filesrvc folderpath='/Public/OverTheShoulder_SAS_Studio/SendTo_OTS_Data_Preparation_Save_Here' filename='Step R - Review Data.sas';
filename sendto filesrvc folderpath="/Users/&sysuserid/My Folder/OTS_Data_Preparation_Save_Here" filename='Step R - Review Data.sas';

%let x=%sysfunc(fcopy(sendfrom, sendto));
%if &x %then %do;
%put &x - %sysfunc(sysmsg());
%end;
filename sendfrom clear;
filename sendto CLEAR;
/*************************      END   COPY       ****************************/

/*************************      COPY        ****************************/
filename sendfrom filesrvc folderpath='/Public/OverTheShoulder_SAS_Studio/SendTo_OTS_Data_Preparation_Save_Here' filename='Step S - Load and Save Data.sas';
filename sendto filesrvc folderpath="/Users/&sysuserid/My Folder/OTS_Data_Preparation_Save_Here" filename='Step S - Load and Save Data.sas';

%let x=%sysfunc(fcopy(sendfrom, sendto));
%if &x %then %do;
%put &x - %sysfunc(sysmsg());
%end;
filename sendfrom clear;
filename sendto CLEAR;
/*************************      END   COPY       ****************************/

/*************************      COPY        ****************************/
filename sendfrom filesrvc folderpath='/Public/OverTheShoulder_SAS_Studio/SendTo_OTS_Data_Preparation_Save_Here' filename='Step Z - Create Data Dictionary.ctk';
filename sendto filesrvc folderpath="/Users/&sysuserid/My Folder/OTS_Data_Preparation_Save_Here" filename='Step Z - Create Data Dictionary.ctk';

%let x=%sysfunc(fcopy(sendfrom, sendto));
%if &x %then %do;
%put &x - %sysfunc(sysmsg());
%end;
filename sendfrom clear;
filename sendto CLEAR;
/*************************      END   COPY       ****************************/













