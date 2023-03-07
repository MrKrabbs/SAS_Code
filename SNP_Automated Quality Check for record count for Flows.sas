proc sql;
	delete from UW_Data.tblRecords;
quit;

%Macro QC_Records;
	%local TableNm I TitleName J;
	%let TableNm=_input;

	Proc sql;
		%Do I=1 %TO &_INPUTCOUNT.;
			insert into UW_Data.tblRecords select count(*) as records, "&&&TableNm&I." 
				as tblName, datetime() as timestamp, "&SYSUSERID" as Analyst 
				from &&&TableNm&I.;
		%end;
	quit;

	%let TitleName=;

	%Do J=1 %TO &_INPUTCOUNT.;
		%let TitleName= &TitleName &&&TableNm&J.;
	%end;
	Title "Comparing records for tables: &TitleName. ";
	%prn(UW_Data.tblRecords, 50, );
    Title;
%mend QC_Records;


%QC_Records;

