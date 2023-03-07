/* Step1 Put in a valid location to output your log file below */
/* Step2  Paste in your code from VDMML. Serach for the word fit and replace with work.fit*/
/* Step3  Search for data = and replace with your data that you saved in VDMML */
/* Step4  Search for &dm_datalib and comment out line for Astore */
/* Step5  Drop filter code */

proc printto log='/xxxx/xxxx/xxxx/xxxx/mylog.log';run;
options fullstimer;






proc printto;run;




