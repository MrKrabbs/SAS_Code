%if %sysfunc( exist(sashelp.class2) ) %then %do;

  proc print data=sashelp.class;

  run;

%end;

%else %do;

  data _null_;

    file print ods;

    text="table does not exist";

    put text;

  run;

%end;