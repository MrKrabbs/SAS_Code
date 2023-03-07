/* Using the GUI import tool in Manage Data: assume we have two users usrABC and usrDEF  */
/* If usrABC imports a table called Premium, the Public (cas) library is the destination. usrDEF can */
/* see and use the Premium table */

/*********************************             However                       ******************************************/
/* using the GUI tool if usrABC selects the Casuser (cas) library as the destination for the import table Premium.  */
/* then user usrDEF cannot see or work with the Premium table */

/*Check scope of the CAS table in Public & Casuser Caslib*/

proc cas;

	table.tableInfo result=r / caslib="Public";

/* below Name represents the table names, and Global represents the table scope */
	print r.tableInfo[,{"Name","Global"}];

	table.tableInfo result=r / caslib="CASUSER";

/* below Name represents the table names, and Global represents the table scope */
	print r.tableInfo[,{"Name","Global"}];

quit;




/* Remember session-scope tables can only be seen by a single CAS session and  */
/* are dropped from CAS when that session is terminated, while global-scope tables */
/*  can be seen publicly and will not be dropped when the CAS session is terminated. */