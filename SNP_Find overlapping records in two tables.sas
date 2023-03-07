/*      This code will find out if we have overlapping records based off of a unique record ID  */
proc sql;
   title 'A INTERSECT B';
   Create table overlap as select &ID_Var.  from &_input1.
   intersect
   select  &ID_Var. from &_input2.;
   select count(&ID_Var) as overlap_cnt from work.overlap;
QUIT;