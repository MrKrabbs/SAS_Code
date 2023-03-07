/*https://blogs.sas.com/content/sgf/2020/08/12/expanding-lengths-of-all-character-variables-in-sas-data-sets/ */



/*Regardless of character transcoding, SAS’ CVP Engine is short and effective answer to this question. CVP stands for Character Variable Padding which is exactly what */
/*this special-purpose engine does – it pads or expands, increases character variables by a number of bytes. CVP engine is part of Base SAS and does not require any*/ 
/*additional licensing.*/

/*The CVP engine is a read-only engine for SAS data sets only. You can think of it as of a magnifying glass: it creates an expanded view of the character data */
/*descriptors (lengths) without changing them. Still we can use the CVP Engine to actually change a data set or a whole data library to their expanded character */
/*variables version. All we need to do is to define our source library as CVP library, for example:*/




libname inlib cvp 'c:\source_folder';
/*Then use PROC COPY to create expanded versions of our original data sets in a target library:*/

libname outlib 'c:\target_folder';
proc copy in=inlib out=outlib noclone;
   select dataset1 dataset2;
run;
/*Or, if we need to expand character variable lengths for the whole library, then we use the same PROC COPY without the SELECT statement:*/

proc copy in=inlib out=outlib noclone;
run;
