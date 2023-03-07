proc sql;
   create table UW_Data.tblRecords
          (Records num, tblName char(32),timestamp num informat=DATETIME19. format=DATETIME19., Analyst char(32));
quit;

proc sql;
  delete from UW_Data.tblRecords;
quit;
