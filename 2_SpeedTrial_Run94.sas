proc printto log='/home/sasdemo/Claims/mylog.log';run;

options fullstimer;run;
 LIBNAME MY_DATA '/home/sasdemo/Claims/CLM_Data';RUN;

/* --- Start of code for "Cartesian Product". --- */
DATA MY_DATA.ending(rename=(time=end_time value=end_value));
SET MY_DATA.stack(keep=obs time value);
RUN;
   
*Do a cartesian product of the beginning and ending file.;
       
 proc sql;
CREATE TABLE MY_DATA.CARTESIAN as
 SELECT b.*, e.end_time, e.end_value, e.end_value - b.value as walk
FROM MY_DATA.stack as b, MY_DATA.ending as e
WHERE      b.obs = e.obs
AND b.time < e.end_time
ORDER BY b.obs, b.time, e.end_time
      ;
quit;

     

 /* --- End of code for "Cartesian Product". --- */
     
   /* --- Start of code for "Summarize". --- */
 proc sql;
create table MY_DATA.summary as
select attribute, time, end_time
,sum(value)/count(*) as avg_initial_value
 ,sum(end_value)/count(*) as avg_end_value
,sum(walk)/count(*) as avg_walk
 ,mean(walk) as mean_walk
,count(*) as count
from MY_DATA.CARTESIAN
group by attribute, time, end_time
;
quit;
      
proc printto;run;