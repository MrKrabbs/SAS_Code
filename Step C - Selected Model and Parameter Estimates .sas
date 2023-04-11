/*************************    PLACE DESIRED MODEL NUMBER BELOW     *****************************/
%LET WANT_TO_USE_THIS_MODEL=3;
/*************************    END OF UPDATING DESIRED MODEL         ****************************/

/************************    BELOW SHOULD NOT CHANGE ONCE SET  ****************************************/
%LET SRC_TABLE=CASUSER.PUREPREM_W_DATAPREP;
%LET TARGET_VAR=PUREPREMIUM;
%LET MODEL_BLD=Pure Premium Liability;
%LET MODEL_STATE=CW; /*CW stands for CountryWide  */

/************************    ABOVE SHOULD NOT CHANGE ONCE SET  ****************************************/


/************* Below will pull our inputs required as determined by model chosen */



PROC SQL;
create table WORK.OUR_MODEL as select * from DATAFLDR.AIC_TBL_&SYSUSERID. WHERE MDL_NBR = &WANT_TO_USE_THIS_MODEL.;
SELECT TRIM(MDL_SLCTN_MTHD) INTO:SEL_METHOD_USED FROM DATAFLDR.AIC_TBL_&SYSUSERID. WHERE MDL_NBR = &WANT_TO_USE_THIS_MODEL.;
QUIT;

DATA _NULL_;
 	SET WORK.OUR_MODEL;
	RESULT=catx(' ',of MDL_INPT:);
 	CALL SYMPUT('CLASS_INPUTS', RESULT); /* INPUTS TO THE MODEL  */
RUN;


%LET INTERACT=BLUEBOOK_U_L*CAR_AGE_U_L;
/* BELOW IF WE HAVE ANY INTERACTIONS, BELOW WILL STRIP OUT THE ASTERISK SO WE CAN USE THIS IN THE CLASS STATEMENT*/
/* MUST DELCARE INTERACTION VARIABLES THAT ARE CLASS (AND ALL OURS ARE) YOU MUST HAVE THE VARIABLE IN TEH CLASS STATEMENT*/
/* HOWEVER, CANNOT HAVE GENDER*AGE IN CLASS , MUST HAVE GENDER AGE IN THE CLASS STATEMENT */
%LET CLASS_INTERACT=%sysfunc(tranwrd(%quote(%trim(&INTERACT)),%str(*),%str( )));


ods output close;
ods output  ParameterEstimates=work.tempParmEst;
proc genselect data=&SRC_TABLE. TECH=nrridg maxiter=1000;
partition role=_PartInd_ (validate='0');
	class &CLASS_INPUTS. &CLASS_INTERACT ; 
	model &TARGET_VAR= &CLASS_INPUTS. &INTERACT.  /  dist=tweedie;

output out=CASUSER.GLM_OUT predicted copyvars=(_all_);
ods output ConvergenceStatus=CS;
run;
ods work.tempParmEst CLOSE;

/* TABLE OUTPUT BELOW WILL BE TO LOADED INTO MODEL MANAGER SO WE HAVE THE OUTPUTS AS THEY CAME FROM MODEL WITHOUT BEING SUBJECT TO MODIFICATIONS*/
DATA ORIG_GLM.ORIG_EST;
SET work.tempParmEst;

RUN;

/* TABLE OUTPUT BELOW WILL BE USED TO CREATE THE CW FACTOR TABLE */
DATA DATAFLDR.TEMPPARMEST;
SET work.tempParmEst;
RUN;

