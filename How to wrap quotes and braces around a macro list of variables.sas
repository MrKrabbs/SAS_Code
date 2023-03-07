/* macro below will take 'word1'n 'word2'n 'word3'n and format it like this: NEW={name="word1"}, {name="word2"}, {name="word3"} */
%let list_have = 'word1'n 'word2'n 'word3'n;

%macro namelist(varlist);
   %let word_cnt=%sysfunc(countw(&varlist)); 
   %let Namelst=;
   %do i = 1 %to &word_cnt;
		%if &i < &word_cnt %then %let tmpName={name=%bquote("%SYSFUNC(DEQUOTE(%qscan(&varlist,&i)))")},;
		%if &i=&word_cnt %then %let tmpName={name=%bquote("%SYSFUNC(DEQUOTE(%qscan(&varlist,&i)))")};
     %let Namelst = &Namelst %bquote(&tmpName.);
   %end;
   &Namelst;
%mend;

%let new = %namelist(&list_have);

%put &=new;


/* macro below will take word1 word2 word3 and format it like this: NEW= "word1" "word2" "word3" */
%let list_have = word1 word2 word3;

%macro namelist(varlist);
   %let word_cnt=%sysfunc(countw(&varlist)); 
   %let list=;
   %do i = 1 %to &word_cnt; 
     %let tmpName=%qscan(%bquote(&varlist),&i);
     %let list = &list %bquote("&tmpName.");
   %end;
   &list;
%mend;

%let new = %namelist(&list_have);

%put &=new;