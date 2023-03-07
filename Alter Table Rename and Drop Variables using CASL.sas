
proc cas;
  session casauto;
table.alterTable /
caslib="CASUSER"
columns={{name="P_BAD0",RENAME="GB_P_BAD0"},{name="P_BAD1",RENAME="GB_P_BAD1"},
{name="EM_CLASSIFICATION",DROP=TRUE},{name="EM_EVENTPROBABILITY",DROP=TRUE},{name="EM_PROBABILITY",DROP=TRUE}}
name="HMEQ_GB_SCORED"
;RUN;
QUIT;

