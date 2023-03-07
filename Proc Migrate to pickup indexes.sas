cas;
caslib _ALL_ assign;
libname DATA_IN '/warehouse/public/';RUN;
libname DATA_OUT '/warehouse/DATA_OUT/';RUN;

/* below will migrate from the windows environment to the linux */
proc migrate in=DATA_IN out=DATA_OUT;
run;

/* below will show that our migrated data has an index */
PROC CONTENTS DATA=DATA_OUT.expwl1_mtd_adj_202106;RUN;
PROC CONTENTS DATA=DATA_IN.expwl1_mtd_adj_202106;RUN;






/**************************   Below is a speed test, index vs no index *******************************************/
/* 78   data work.junk; */
/* 79   set DATA_OUT.expwl1_mtd_adj_202106; */
/* 80   where activity_date > '06JUN2021'd ; */
/* 81   run; */
/* NOTE: There were 1198021 observations read from the data set DATA_OUT.EXPWL1_MTD_ADJ_202106. */
/*       WHERE activity_date>'06JUN2021'D; */
/* NOTE: The data set WORK.JUNK has 1198021 observations and 81 variables. */
/* NOTE: DATA statement used (Total process time): */
/*       real time           16.90 seconds */
/*       cpu time            3.52 seconds */

/* ABOVE IS A DATASET THAT HAS BEEN MIGRATED OVER TO LINUX AND THE INDEX REBUILT*/
/* BELOW IS A DATASET  THAT HAS BEEN MIGRATED OVER TO LINUX WITHOUT BUILDING AN INDEX */
/* WE CAN SEE THAT A SIGNIFICANT TIME IMPROVEMENT (ABOUT 50% LESS TIME) FOR THE DATASET WITH THE INDEX */



/* 78   data work.junk; */
/* 79   /* set DATA_IN.expwl1_mtd_adj_202106; */
/* 80   set DATA_OUT.TEST_INDEX; */
/* 81   where activity_date > '06JUN2021'd ; */
/* 82   run; */
/* NOTE: There were 1198021 observations read from the data set DATA_OUT.TEST_INDEX. */
/*       WHERE activity_date>'06JUN2021'D; */
/* NOTE: The data set WORK.JUNK has 1198021 observations and 81 variables. */
/* NOTE: DATA statement used (Total process time): */
/*       real time           31.36 seconds */
/*       cpu time            7.45 seconds */


/******************* No way to move indexes from 9.4 to CAS that I am aware of **************************/
/******************* Also CAS does support simple indexes but do not support composite indexes **********/

data casuser.mytest;
set data_out.expwl1_mtd_adj_202106;
run;


/* check for index on cas table */
proc cas;
  session casauto;

  table.columninfo / table="mytest";
run;
quit;

/* below will create an index on the cas table */
proc cas;
  session casauto;

  table.index /
    table="mytest",
    casOut={
      name="mytest_indexed",
      indexVars={"activity_date"},                
      replace=True
     };
    
  table.columnInfo /                                             
    table="mytest_indexed";
run;
quit;

/*************    below is our save\export to sas7bdat or csv example */
DATA casuser.junk_cars;
set sashelp.cars;
run;


/* Below you can save\export your in-memory table to a csv or a sas7bdat */

proc cas;
table.save / 
  table={name="junk_cars" caslib="casuser"} 
/*   name="junk_cars.sas7bdat";        use this if you want a sas7bdat */
	   name="junk_cars.csv";       
run;
quit;









