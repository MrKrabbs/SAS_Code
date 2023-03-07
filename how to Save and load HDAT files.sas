libname CLM_DATA '/home/sasdemo/Claims/CLM_Data';RUN;

/* below will save a physical copy but give the physical copy a different name (casout) */
proc casutil;
	save incaslib="PUBLIC" outcaslib="PUBLIC" casdata="PUREPREM_W_DATAPREP"  casout="PUREPREM_W_DATAPREP_RETIREDNOV12" replace;
run;QUIT;

/*  */
/* proc casutil; */
/* 	droptable incaslib="PUBLIC" casdata="CLMS_DATA_122019" quiet; */
/* run;QUIT; */
/*  */
/* Promoting the tabel in CAS */
/* data PUBLIC.CLMS_DATA_122019(promote=yes); */
/* 	set CLM_DATA.PRM_LSS_FNL; */
/* run; */
/*  */
/* Save table in CAS */
/* proc casutil; */
/* 	save incaslib="PUBLIC" outcaslib="PUBLIC" casdata="CLMS_DATA_122019" replace; */
/* run;QUIT; */



/* below will drop a table from memory if it exists ....then */
/* will load physical data (csv, hdat, oracle..) into a cas table .....then */
/* will promote the newly loaded table to Global scope */

proc casutil incaslib="PUBLIC" outcaslib="PUBLIC";
	droptable casdata="CLMS_DATA_122019" quiet;
	load casdata="CLMS_DATA_122019.sashdat" casout="CLMS_DATA_122019" promote;
quit;



/****************     below will promote a session scope table to a Global Table as long as that table name is not being used */
/****************     in connection wiht another global table  */
proc casutil;
PROMOTE CASDATA="junk412" INCASLIB="casuser"
CASOUT="junk_promoted" OUTCASLIB="casuser";
quit;


