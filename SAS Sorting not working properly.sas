/* if you are seeing that your sorts are not sorting properly the root cause of this issue is the OS default sort is not giving you want you want*/
/******************************   below is from sas help and then below that are some code examples of how to implement a sort sequence(sortseq) ***************/

/* SORTSEQ= is a PROC SQL statement option that specifies the sorting sequence for PROC SQL to use when a query contains an ORDER BY clause. Use this option only if you want to use a  */
/* sorting sequence other than your operating environment's default sorting sequence. Possible values include ASCII, EBCDIC, and some languages other than English. For example,  */
/* in an operating environment that supports the EBCDIC sorting sequence, you could use the following option in the PROC SQL statement to set the sorting sequence to EBCDIC: */
/* Beginning with SAS 9.4M3, linguistic collation is supported with the SORTSEQ statement option. For more information, see SORTSEQ=sort-table | LINGUISTIC. */



PROC SQL sortseq=linguistic;
	Create Table testsort  as select make, model from sashelp.cars order by make;
quit;

PROC SORT DATA=sashelp.cars SORTSEQ=LINGUISTIC out=WORK.carsSorted;
	by descending Make model;
run;