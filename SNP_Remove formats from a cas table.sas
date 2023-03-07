%let myTable=Retail;
%let myCasLibrary=casuser;

/* load a sashelp table that has some formats into a cas table for test of removing formats from a cas table */
data &myCasLibrary..&myTable.;
	set sashelp.retail;
run;

proc cas;
	session casauto;

	/* below will do two things, print out the formats before changing and creating a temp table r that holds info on the columns(variables) */
	table.columninfo result=r / table={caslib="&myCasLibrary.", name="&myTable."};
	run;

	/* print to the results window column info, specifically formats if they exist */
	print r;
	run;

	/* the object cols below is an array */
	cols={};

	do row over r.ColumnInfo;
		cols=cols + {{name=row.Column, format=""}};
	end;

	/* below will print out our array called cols, IMPORTANT, the array will be printed to the log and NOT the results window */
	/* this array will simply have the column name and format=missing\blank\empty */
	print cols;
	run;

	/* below will alter our table by setting all formats to missing (empty) by leveraging the array called cols */
	table.altertable / caslib="&myCasLibrary.", columns=cols, name="&myTable.";
	table.columninfo result=t / table={caslib="&myCasLibrary.", name="&myTable."};
	run;
	print t;
	run;

	/* goal, when I have some time */
	/*see if I can't reapply the original formats onto the table after the FedSQL join. */
	/*As the only reason I am taking off formats is so that FedSQL does not output every variables as a varchar */
quit;