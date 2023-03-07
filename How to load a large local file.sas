/* THE PATH SHOWN BELOW IS A PATH ACCESSIBLE BY BOTH LINUX AND WINDOWS. */
/* USING WINDOWS PLACE A COPY OF THE CSV FILE IN THE FOLDER SHOWN BELOW*/
proc cas;
   session casauto;

   upload path="/opt/sas/viya/config/data/cas/default/public/ExampleLoadingCSV.csv"
   casOut={
	  caslib="PUBLIC",
      name='TestLoad'
      replace=True
    }
    importOptions={fileType="csv"};
run;
                          
quit;

/* Save table in CAS */
/* above loaded a table into memory, however, no physical SAS file exists on the Server (other than the original csv)*/
/* below will create a physical sas hdat file that can be re-loaded extremely fast */
proc casutil;
	save incaslib="PUBLIC" outcaslib="PUBLIC" casdata="TestLoad" replace;
run;quit;






