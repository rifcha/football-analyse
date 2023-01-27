/* 1 */
%let MvCodePrd = 3 6 9 12 ;

%let MvCodePrdTransfo = %sysfunc(tranwrd(&MvCodePrd," ",","));
%put MvCodePrdTransfo = &MvCodePrdTransfo;

/* Cela n'a rien changé.
   Notre variable macro ne contient pas de virgules entre guillemets simples. 
   En macro-langage, tout est une chaîne de caractères, il n'est pas nécessaire d'utiliser des guillemets autour des chaînes de caractères.
   Mais vous devrez mettre les virgules et les espaces entre guillemets pour qu'ils soient traités comme du texte et non comme des délimiteurs.
   ==> Utilisons donc %str() qui empêche l'interprétation des blancs et des virgules (et autres...)
*/
%let MvCodePrdTransfo = %sysfunc(tranwrd(&MvCodePrd,%str( ),%str(,)));
%put MvCodePrdTransfo = &MvCodePrdTransfo;


/* Soit le programme suivant */
data PERSO.FUSION_TAWICTR_BRANCHE_6;
	set PERSO.FUSION_TAWICTR_BRANCHE_5(where=(MOIS_SAISIE in (3,6,9,12)));
run;

data PERSO.BRANCHE_AUTOMOBILE;
set PERSO.FUSION_TAWICTR_BRANCHE_6(where=(AWICTR_CODBCH="01"));
run;

data PERSO.BRANCHE_IARD_ET_PJ;
set PERSO.FUSION_TAWICTR_BRANCHE_6(where=(AWICTR_CODBCH="02"));
run;

data PERSO.BRANCHE_PREV_SANTE;
set PERSO.FUSION_TAWICTR_BRANCHE_6(where=(AWICTR_CODBCH="03"));
run;

data PERSO.BRANCHE_PREV_DECES;
set PERSO.FUSION_TAWICTR_BRANCHE_6(where=(AWICTR_CODBCH="04"));
run;

data PERSO.BRANCHE_CREDITS;
set PERSO.FUSION_TAWICTR_BRANCHE_6(where=(AWICTR_CODBCH="05"));
run;

data PERSO.BRANCHE_COURTAGE;
set PERSO.FUSION_TAWICTR_BRANCHE_6(where=(AWICTR_CODBCH="06"));
run;

data PERSO.BRANCHE_BON_DE_CAPI;
set PERSO.FUSION_TAWICTR_BRANCHE_6(where=(AWICTR_CODBCH="07"));
run;

data PERSO.BRANCHE_PRIME_UNIQUE;
set PERSO.FUSION_TAWICTR_BRANCHE_6(where=(AWICTR_CODBCH="08"));
run;

data PERSO.BRANCHE_LIVRET;
set PERSO.FUSION_TAWICTR_BRANCHE_6(where=(AWICTR_CODBCH="09"));
run;

data PERSO.BRANCHE_CAUTION;
set PERSO.FUSION_TAWICTR_BRANCHE_6(where=(AWICTR_CODBCH="12"));
run;


/* 2 */
%macro mon_macro_pgm;

data PERSO.FUSION_TAWICTR_BRANCHE_6;
	set PERSO.FUSION_TAWICTR_BRANCHE_5(where=(MOIS_SAISIE in (3,6,9,12)));
run;

data PERSO.BRANCHE_AUTOMOBILE;
set PERSO.FUSION_TAWICTR_BRANCHE_6(where=(AWICTR_CODBCH="01"));
run;

data PERSO.BRANCHE_IARD_ET_PJ;
set PERSO.FUSION_TAWICTR_BRANCHE_6(where=(AWICTR_CODBCH="02"));
run;

data PERSO.BRANCHE_PREV_SANTE;
set PERSO.FUSION_TAWICTR_BRANCHE_6(where=(AWICTR_CODBCH="03"));
run;

data PERSO.BRANCHE_PREV_DECES;
set PERSO.FUSION_TAWICTR_BRANCHE_6(where=(AWICTR_CODBCH="04"));
run;

data PERSO.BRANCHE_CREDITS;
set PERSO.FUSION_TAWICTR_BRANCHE_6(where=(AWICTR_CODBCH="05"));
run;

data PERSO.BRANCHE_COURTAGE;
set PERSO.FUSION_TAWICTR_BRANCHE_6(where=(AWICTR_CODBCH="06"));
run;

data PERSO.BRANCHE_BON_DE_CAPI;
set PERSO.FUSION_TAWICTR_BRANCHE_6(where=(AWICTR_CODBCH="07"));
run;

data PERSO.BRANCHE_PRIME_UNIQUE;
set PERSO.FUSION_TAWICTR_BRANCHE_6(where=(AWICTR_CODBCH="08"));
run;

data PERSO.BRANCHE_LIVRET;
set PERSO.FUSION_TAWICTR_BRANCHE_6(where=(AWICTR_CODBCH="09"));
run;

data PERSO.BRANCHE_CAUTION;
set PERSO.FUSION_TAWICTR_BRANCHE_6(where=(AWICTR_CODBCH="12"));
run;

%mend mon_macro_pgm;

%mon_macro_pgm;


/* 3 */
%macro mon_macro_pgm(MvTabOut=,MvFiltreMois=);

data &MvTabOut.;
	set PERSO.FUSION_TAWICTR_BRANCHE_5(where=(MOIS_SAISIE in (&MvFiltreMois.)));
run;

data PERSO.BRANCHE_AUTOMOBILE;
set &MvTabOut.(where=(AWICTR_CODBCH="01"));
run;

data PERSO.BRANCHE_IARD_ET_PJ;
set &MvTabOut.(where=(AWICTR_CODBCH="02"));
run;

data PERSO.BRANCHE_PREV_SANTE;
set &MvTabOut.(where=(AWICTR_CODBCH="03"));
run;

data PERSO.BRANCHE_PREV_DECES;
set &MvTabOut.(where=(AWICTR_CODBCH="04"));
run;

data PERSO.BRANCHE_CREDITS;
set &MvTabOut.(where=(AWICTR_CODBCH="05"));
run;

data PERSO.BRANCHE_COURTAGE;
set &MvTabOut.(where=(AWICTR_CODBCH="06"));
run;

data PERSO.BRANCHE_BON_DE_CAPI;
set &MvTabOut.(where=(AWICTR_CODBCH="07"));
run;

data PERSO.BRANCHE_PRIME_UNIQUE;
set &MvTabOut.(where=(AWICTR_CODBCH="08"));
run;

data PERSO.BRANCHE_LIVRET;
set &MvTabOut.(where=(AWICTR_CODBCH="09"));
run;

data PERSO.BRANCHE_CAUTION;
set &MvTabOut.(where=(AWICTR_CODBCH="12"));
run;

%mend mon_macro_pgm;

%mon_macro_pgm(MvTabOut=PERSO.TABLE_PARAMETRES,MvFiltreMois=%str(3,6,9,12));


/* 4 */
%macro mon_macro_pgm(MvTabOut=,MvFiltreMois=);

	data &MvTabOut.;
		set PERSO.FUSION_TAWICTR_BRANCHE_5(where=(MOIS_SAISIE in (&MvFiltreMois.)));
	run;

	data _null_;
		set PERSO.REFERENTIEL_BRANCHES;
		call symput(COMPRESS('MvCodeBrch'||_N_),CODE_BRANCHE) ;
		call symput(COMPRESS('MvLibelleBrch'||_N_),LIBELLE_BRANCHE) ;
		call symput(COMPRESS('MvLibelleBrchBis'||_N_),tranwrd(trim(compress(LIBELLE_BRANCHE,"."))," ","_")) ;
		call symput(COMPRESS('MvNb'),_N_) ;
	run;

	%do i=1 %to &MvNb.;

		%let MvLibelleBrchTransfo&i = %sysfunc(tranwrd(%sysfunc(tranwrd(&&MvLibelleBrch&i.,%str(.),%str( ))),%str( ),%str(_)));
		%let MvLibelleBrchTransfo&i = %sysfunc(tranwrd(%sysfunc(compress(&&MvLibelleBrch&i.,%str(.))),%str( ),%str(_)));

		data PERSO.BRANCHE_&&MvLibelleBrchTransfo&i.;
			set &MvTabOut.(where=(AWICTR_CODBCH="&&MvCodeBrch&i"));
		run;

		%put MvLibelleBrch&i = &&MvLibelleBrch&i;
		%put MvLibelleBrchTransfo&i = &&MvLibelleBrchTransfo&i;
		%put MvLibelleBrchBis&i = &&MvLibelleBrchBis&i;
	%end;
%mend mon_macro_pgm;

%mon_macro_pgm(MvTabOut=PERSO.TABLE_PARAMETRES,MvFiltreMois=%str(3,6,9,12));
