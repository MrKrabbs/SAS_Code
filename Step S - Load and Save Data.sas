/* Goal of this program is to:      */
/****** If existing table PUREPREM_W_DATAPREP exists, the drop it */
/****** Load our finale data prep table into memory    */
/****** Create a physical copies of tables used in the process*/
/****** Drop tables used in the process from memory, after we have made physical back up copies (step above) */


 
/* if table CASUSER.PUREPREM_W_DATAPREP exists In-memory, then drop\delete the table from memory*/
/* please note: This drop\delete applies only to the In-memory table, if a physical table exists, the statement below will have no impact on physical copy*/
proc casutil;
    droptable incaslib="CASUSER" casdata="PUREPREM_W_DATAPREP" quiet;
run;QUIT;

 
/* create the table CASUSER.PUREPREM_W_DATAPREP (In-memory) and make available to yourself outside SAS Studio*/
DATA CASUSER.PUREPREM_W_DATAPREP(PROMOTE=YES);
    SET CASUSER.P_ORD_AND_ONEHOT_ENCODING;

RUN;

/********     BELOW WILL CREATE PHYSICAL COPIES OF OUR TABLES AND THEN DROP FROM MEMORY        ***************************/
proc casutil;
    save incaslib="CASUSER" outcaslib="CASUSER" casdata="PUREPREM_W_DATAPREP" replace;
run;QUIT;
 

proc casutil;
    save incaslib="CASUSER" outcaslib="CASUSER" casdata="D_TEMP_PUREPREM_DATA_MISSING" replace;
run;QUIT;
 

proc casutil;
    save incaslib="CASUSER" outcaslib="CASUSER" casdata="G_CONT_TRANSFORMS_PLUS_BINS" replace;
run;QUIT;

 

proc casutil;
    save incaslib="CASUSER" outcaslib="CASUSER" casdata="J_GENERATEDFEATURES" replace;
run;QUIT;

 

proc casutil;
    save incaslib="CASUSER" outcaslib="CASUSER" casdata="M_MSNG_TRANSFRMS_FTRENG" replace;
run;QUIT;


proc casutil;
    save incaslib="CASUSER" outcaslib="CASUSER" casdata="P_ORD_AND_ONEHOT_ENCODING" replace;
run;QUIT;
 

/********     DROPPING TABLES BELOW FROM MEMORY AS WE NO LONGER NEED THEM           ***************************/
/********     ABOVE WE MADE A PHYSICAL COPY OF DATA WE CAN ALWAYS RELOAD IF NEEDED   **************************/
proc casutil;
    droptable incaslib="CASUSER"  casdata="D_TEMP_PUREPREM_DATA_MISSING" quiet;
run;QUIT;
 

proc casutil;
    droptable incaslib="CASUSER"  casdata="G_CONT_TRANSFORMS_PLUS_BINS" quiet;
run;QUIT;

 

proc casutil;
    droptable incaslib="CASUSER"  casdata="J_GENERATEDFEATURES" quiet;
run;QUIT;

 

proc casutil;
    droptable incaslib="CASUSER"  casdata="M_MSNG_TRANSFRMS_FTRENG" quiet;
run;QUIT;


proc casutil;
    droptable incaslib="CASUSER"  casdata="P_ORD_AND_ONEHOT_ENCODING" quiet;
run;QUIT;


