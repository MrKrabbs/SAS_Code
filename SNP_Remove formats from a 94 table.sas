/* proc contents below will show two variable with formats */
proc contents data=sashelp.cars;

data work.temp_cars;
set sashelp.cars;
run;

/* step below will strip out all variable formats */
proc datasets lib=work memtype=data;
   modify temp_cars;
     attrib _all_ format=;
run;
quit;


/* proc contents below will show no formats */
proc contents data=work.temp_cars;
