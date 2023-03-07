/* COMPLETETYPES */
/* creates all possible combinations of class variables even if the combination does not occur in the input data set. */
/* Interaction	The PRELOADFMT option in the CLASS statement ensures that PROC MEANS writes all user-defined format ranges or */
/* values for the combinations of class variables to the output, even when a frequency is zero. */
/* Tip	Using COMPLETETYPES does not increase the memory requirements. */
/* See	Using Preloaded Formats with Class Variables */


data work.cars;
set sashelp.cars;
count=1;
run;


proc means data=work.cars n completetypes;
class Drivetrain Origin Type;
var msrp;
freq count;
run;

/* Note cannot get the CASL code below to display zero frequency combinations. I think I am close, but not there yet */

data casuser.mycars;
set work.cars;
run;





proc cas;
   action freqTab.freqTab /
      table='mycars',
      weight='Count',
		includeZeroWeight=true,
      tabDisplay={format='LIST', missingFreq=true},
      tabulate={'Drivetrain', {vars={'Drivetrain', 'Type'}}};
run;
quit;