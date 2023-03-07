/* below is from my Yammer conversation */
/* Matt Bailey – May 18 at 09:53 AM */
/* Hello: */

/* I can append records to my cas table, so far so good. My issue is when I want to  */
/* append records that only have two of the fields that exist on the table. The table in memory  */
/* is sashelp.cars and has 15 variables, but the data I want to append only has two fields.  */
/* The syntax below is a no go (can't use varlist and load data at same time). Can this be done?  */
/* If yes, can I get some help with the syntax?  */


/* I think you always need the complete set of all variables when you want to append. */
/* I suggest to use a DATA Step with append=yes and add all the necessary variables from the target CAS table, see sample code below: */


cas sugus sessopts=(metrics=true);

libname casuser cas caslib="casuser";

 

proc delete data=casuser.mycars;

run;

 

data casuser.mycars(promote=yes);

	set sashelp.cars;

	where origin="Europe";

run;

 

data casuser.newcars;

	set sashelp.cars;

	where origin="Asia";

	keep make model origin;

run;

 

data casuser.mycars(append=yes);

	if _n_=0 then

		do;

			set casuser.mycars;

		end;

	set casuser.newcars;

run;

/* Greg Smith – May 26 at 09:22 AM */
/* That IF statement is never true and, therefore, the 1st SET statement never executes.   */
/* So, one might ask: why is it there?  It's there to "trick" SAS into adding all of the  */
/* variables in the CASUSER.MYCARS table to the program data vector (PDV) so they are "added"  */
/* to the output table structure. The PDV is constructed during the DATA Step compilation  */
/* phase, which happens before the execution phase, and involves scanning the DATA  Step code  */
/* to identify all of the variables that will be used during the execution of the code.   */
/* When execution starts, all of the variables are initialized to missing and since your  */
/* input data set only has two of the variables, the other 13 stay set to missing through  */
/* every iteration of the DATA Step.  But since all 15 variables are there in the PDV, the  */
/* appended records match the structure of the output table.  */