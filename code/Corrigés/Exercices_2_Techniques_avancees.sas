/* 1 */
libname FORFMT "/deci/Zsasfmt/VGD_Fmt/FormationSasLangage";

data PERSO.REF_BRANCHES_FMT ;
	set PERSO.REFERENTIEL_BRANCHES (rename=(CODE_BRANCHE=START LIBELLE_BRANCHE=LABEL));
	FMTNAME="libbrch";
	TYPE="C";
run;

proc format cntlin = PERSO.REF_BRANCHES_FMT lib=FORFMT.formats;
run ;

proc format library=FORFMT.formats fmtlib;
run;

/* 2 */
options fmtsearch = (FORFMT.formats); 

data PERSO.FUSION_TAWICTR_BRANCHE;
	set PERSO.FUSION_TAWICTR_BRANCHE;
	LIBELLE_BRANCHE_FMT=put(AWICTR_CODBCH,$libbrch.);
run;

/* 3 */
data PERSO.FUSION_TAWICTR_BRANCHE_2;
	set PERSO.FUSION_TAWICTR_BRANCHE;
	prx="/[a-zA-Z]\d{4}[a-zA-Z]{2}/";
	if prxmatch(prx,AWICTR_USRSASSOU) ne 0 
		then ID_SOUSC_LETTRE = 1 ;
		else ID_SOUSC_LETTRE = 0 ;
run;

/* 4 */
data PERSO.FUSION_TAWICTR_BRANCHE_3;
	set PERSO.FUSION_TAWICTR_BRANCHE;
	array flagctr AWICTR_FLGFRTPTR AWICTR_FLGFNCPTR AWICTR_FLGCRTPTR AWICTR_FLGIPYPTR AWICTR_FLGELIFRT ;
	array flag FLAG_1 FLAG_2 FLAG_3 FLAG_4 FLAG_5;
	do i=1 to dim(flagctr);
		if flagctr(i)="1" 
			then flag(i)=1;
			else if flagctr(i)="" then flag(i)=99;
			else flag(i)=0;
	end;
run;

data PERSO.FUSION_TAWICTR_BRANCHE_4;
	set PERSO.FUSION_TAWICTR_BRANCHE;
	select (AWICTR_FLGFRTPTR);
		when ("1") FLAG_1=1;
		when ("") FLAG_1=99;
		otherwise FLAG_1=0;
	end;
	select (AWICTR_FLGFNCPTR);
		when ("1") FLAG_2=1;
		when ("") FLAG_2=99;
		otherwise FLAG_2=0;
	end;
	select (AWICTR_FLGCRTPTR);
		when ("1") FLAG_3=1;
		when ("") FLAG_3=99;
		otherwise FLAG_3=0;
	end;
	select (AWICTR_FLGIPYPTR);
		when ("1") FLAG_4=1;
		when ("") FLAG_4=99;
		otherwise FLAG_4=0;
	end;
	select (AWICTR_FLGELIFRT);
		when ("1") FLAG_5=1;
		when ("") FLAG_5=99;
		otherwise FLAG_5=0;
	end;
run;

data PERSO.FUSION_TAWICTR_BRANCHE_5;
	set PERSO.FUSION_TAWICTR_BRANCHE;
	if AWICTR_FLGFRTPTR="1" 
		then FLAG_1=1;
		else if AWICTR_FLGFRTPTR="" then FLAG_1=99;
		else FLAG_1=0;
	if AWICTR_FLGFNCPTR="1" 
		then FLAG_2=1;
		else if AWICTR_FLGFNCPTR="" then FLAG_2=99;
		else FLAG_2=0;
	if AWICTR_FLGCRTPTR="1"
		then FLAG_3=1;
		else if AWICTR_FLGCRTPTR="" then FLAG_3=99;
		else FLAG_3=0;
	if AWICTR_FLGIPYPTR="1" 
		then FLAG_4=1;
		else if AWICTR_FLGIPYPTR="" then FLAG_4=99;
		else FLAG_4=0;
	if AWICTR_FLGELIFRT="1" 
		then FLAG_5=1;
		else if AWICTR_FLGELIFRT="" then FLAG_5=99;
		else FLAG_5=0;
run;

proc freq data=PERSO.FUSION_TAWICTR_BRANCHE_3;
tables AWICTR_FLGFRTPTR*FLAG_1 / missing;
run;
proc freq data=PERSO.FUSION_TAWICTR_BRANCHE_4;
tables AWICTR_FLGFRTPTR*FLAG_1 / missing;
run;
proc freq data=PERSO.FUSION_TAWICTR_BRANCHE_5;
tables AWICTR_FLGFRTPTR*FLAG_1 / missing;
run;




/* 5 */

proc sort data=PERSO.FUSION_TAWICTR_BRANCHE;
	by AWICTR_CODBCH AWICTR_DATSAICTR;
run;

data PERSO.BRANCHES_COTISATIONS (keep=AWICTR_CODBCH LIBELLE_BRANCHE_FMT FIRST_DATE LAST_DATE DATE_INF_ECART DATE_SUP_ECART ECART_JOUR_MAX NB_CTR);
	set PERSO.FUSION_TAWICTR_BRANCHE(where=(AWICTR_DATSAICTR ne .));
	retain DATE_COMP COTIS_TOT NB_CTR ECART_JOUR_MAX DATE_INF_ECART DATE_SUP_ECART FIRST_DATE;
	by AWICTR_CODBCH AWICTR_DATSAICTR;
	format DATE_COMP FIRST_DATE LAST_DATE DATE_INF_ECART DATE_SUP_ECART date9.;
	if first.AWICTR_CODBCH then do;
		DATE_COMP = AWICTR_DATSAICTR ;
		COTIS_TOT = AWICTR_CTSANNHT ;
		FIRST_DATE = AWICTR_DATSAICTR ;
		NB_CTR = 0;
		ECART_JOUR_MAX = 0;
	end;
	else do;
		COTIS_TOT = sum(COTIS_TOT,AWICTR_CTSANNHT);
		NB_CTR = sum(NB_CTR,1);
		if sum(AWICTR_DATSAICTR,-DATE_COMP) > ECART_JOUR_MAX then do ;
			ECART_JOUR_MAX = sum(AWICTR_DATSAICTR,-DATE_COMP) ;
			DATE_INF_ECART  = DATE_COMP ;
			DATE_SUP_ECART = AWICTR_DATSAICTR ;
			DATE_COMP = AWICTR_DATSAICTR ;
		end;
	end;
	if last.AWICTR_CODBCH then do;
		LAST_DATE = AWICTR_DATSAICTR;
		output;
	end;
run;
