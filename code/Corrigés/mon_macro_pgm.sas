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
