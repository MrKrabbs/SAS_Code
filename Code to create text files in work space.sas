%put Work folder is %sysfunc(getoption(work));

filename stuff "%sysfunc(getoption(work))/mystuff.txt";

data _null_;
file stuff;
put "Hello";
run;


data _null_;
file stuff MOD;
put "world";
run;

data _null_;
infile stuff;
input word $;
put word=;
run;