proc cas ;
 /* build function to load from caslib source to memory */
 function loadSource2cas(xCaslib);
table.queryCaslib result=results status=rc / caslib=xCaslib ;     
print results;

if results[1] = TRUE then do;

  table.casLibInfo result=gcl_list / caslib=xCaslib;
  describe (gcl_list);
  print gcl_list;
  gcl_path=gcl_list[1, 1, "path"];
  put gcl_path;
  table.fileInfo result=fileList / caslib=xCaslib;
  describe (fileList);
  flTable=findtable(fileList);
  describe flTable;
  do row over flTable;
    print "NOTE: Loading data:" (row.Name) " table:" scan(row.Name, 1, ".");
    table.loadTable status=rc / casOut={
            caslib=xCaslib
            , name=scan(row.Name, 1, ".") , replace=TRUE 
          }
          , caslib=xCaslib
          , path=row.Name;
    print rc;
  end;
end;
else do;
  print "ERROR: caslib " xCaslib " does not exist";
end;

end;


end;

/* use the the function */ 
 myCaslib="gcl_d01";
 loadSource2cas(myCaslib);
 quit;
