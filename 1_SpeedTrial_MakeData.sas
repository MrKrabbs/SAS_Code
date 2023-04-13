
proc printto log='/home/sasdemo/Claims/mylog.log';run;
options fullstimer; /* options nofullstimer */


 LIBNAME MY_DATA '/home/sasdemo/Claims/CLM_Data';RUN;
 

/********************          DANGER WILL ROBINSON DANGER             It's ok to start at 100,000 then add zeros carefully ******/
/* after creating the dataset using the 100,000 if it's a case of it does not take long enough, then come back and add a zero */
%let n = 100000; /*number of observations (per time period) it's ok to change n */
%let t = 100; /*number of time periods to loop through LEAVE THIS LINE OF CODE ALONE */
 
 
/* %let n = 10; *number of observations (per time period); */
/* %let t = 10; *number of time periods to loop through;  */
 
 
*total count of cartesian will be (n)(t)(t-1)/2;
 
 
/* --- End of code for "Settings". --- */
 

*create initial data;
proc sql;
     drop table MY_DATA.stack
;quit;
 
data MY_DATA.stack;
call streaminit(765);
do obs=1 to &n.;
     time = 1;
     attribute = ranbin(765,1,.5);
     if attribute = 0 then value = rand("Uniform",0,1);
     else value = rand("Uniform",0,.95);
     output;
end;
run;
 
*start the random walk;
%macro time_loop;
     %do i=1 %to &t.-1;
           data _null_;
                call symput('j',&i + 1);
           run;
           proc sort data=MY_DATA.stack; by obs time; run;
 
           data MY_DATA.stack;
           set MY_DATA.stack;
           by obs time;
           output;
 
           if last.obs then do;
                time = &j.;
                value = value + rand("Uniform",-.1,.1);
                output;
           end;
 
           run;
     %end;
%mend;
 
%time_loop;
 


proc printto;run;




