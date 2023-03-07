data work.hmeq2;
set PUBLIC.HMEQ_TRAIN_2;
ID=_n_;
run;

DATA PUBLIC.HMEQ3 (PROMOTE=YES);
SET WORK.HMEQ2;
RUN;

%prn(CASUSER.HMEQ_GB_SCORED,50,);

proc fedsql sessref=casauto _method ;
   create table CASUSER.GB_NN_SCORES
   {options replication=0 replace=true} as
   select country, product, substr(prodtype,1,3) as onTheFly, sum(actual) as actual, sum(predict) as predict
   from CASUSER.BigPrdsale
   group by country, product, onTheFly ;
quit ;


proc cas;
  session casauto;
table.alterTable /
caslib="CASUSER"
columns={{name="P_BAD0",RENAME="GB_P_BAD0"},{name="P_BAD1",RENAME="GB_P_BAD1"},
{name="EM_CLASSIFICATION",DROP=TRUE},{name="EM_EVENTPROBABILITY",DROP=TRUE},{name="EM_PROBABILITY",DROP=TRUE}}
name="HMEQ_GB_SCORED"
;RUN;
QUIT;

proc cas;
   aggregation.aggregate result=r status=s /
      table={caslib="CASUSER",
         name="BigPrdsale",
         groupBy={"country","product","onTheFly"},
         vars={"actual","predict"},
         computedVars={{name="onTheFly"}},
         computedVarsProgram="onTheFly=substr(prodtype,1,3);"
      },
	  saveGroupbyFormat=FALSE, /* This line will remove the variables product_f and prodtype_f from the output */
      varSpecs={
         {name='PREDICT', summarySubset={'SUM'}, columnNames={'PREDICT'}}
         {name='ACTUAL', summarySubset={'SUM'}, columnNames={'ACTUAL'}}
      }
      casout={caslib="CASUSER",name="BigPrdsale_aggregate_w_NewVars", replace=True, replication=0};
quit ;
