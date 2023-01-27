/* Partons de la table PERSO.BRANCHES_COTISATIONS créée précédemment (dans les Techniques avancées) */

/* 1 */
proc report data=PERSO.BRANCHES_COTISATIONS;
	columns LIBELLE_BRANCHE_FMT NB_CTR ECART_JOUR_MAX ;
	define LIBELLE_BRANCHE_FMT / display 'Libellé branche';
	define NB_CTR / analysis 'Nombre de contrat';
	define ECART_JOUR_MAX / analysis mean 'Nb de jours max entre 2 dates successives de souscriptions';
run;

/* 2 */
proc report data=PERSO.BRANCHES_COTISATIONS;
	columns LIBELLE_BRANCHE_FMT NB_CTR ECART_JOUR_MAX ;
	define LIBELLE_BRANCHE_FMT / display 'Libellé branche';
	define NB_CTR / analysis 'Nombre de contrat';
	define ECART_JOUR_MAX / analysis mean 'Nb de jours max entre 2 dates successives de souscriptions';
	rbreak after / summarize ;
run;

/* 3 */
proc report data=PERSO.BRANCHES_COTISATIONS;
	columns LIBELLE_BRANCHE_FMT NB_CTR ECART_JOUR_MAX ;
	define LIBELLE_BRANCHE_FMT / display 'Libellé branche';
	define NB_CTR / analysis 'Nombre de contrat';
	define ECART_JOUR_MAX / analysis mean 'Nb de jours max entre 2 dates successives de souscriptions';
	rbreak after / summarize ;
	compute after;
		LIBELLE_BRANCHE_FMT='Résumé';
	endcomp;
run;

/* 4 */
proc report data=PERSO.BRANCHES_COTISATIONS
style(header)=Header{background=#074a7c color=#ffffff font_weight=bold};
	columns LIBELLE_BRANCHE_FMT NB_CTR ECART_JOUR_MAX ;
	define LIBELLE_BRANCHE_FMT / display 'Libellé branche';
	define NB_CTR / analysis 'Nombre de contrat' ;
	define ECART_JOUR_MAX / analysis mean 'Nb de jours max entre 2 dates successives de souscriptions';
	rbreak after / summarize ;
	compute after;
		LIBELLE_BRANCHE_FMT='Résumé';
		call define(_row_,"style","style=[backgroundcolor=grey color=#ffffff]");
	endcomp;
run;


/* 5 */
ods excel file="/SASDECI/FormationProductionRapports.xlsx";

ods excel options(start_at="2,2" embedded_titles="yes" autofilter="yes" sheet_name="Mon Rapport");

proc report data=PERSO.BRANCHES_COTISATIONS
style(header)=Header{background=#074a7c color=#ffffff font_weight=bold};
	columns LIBELLE_BRANCHE_FMT NB_CTR ECART_JOUR_MAX ;
	define LIBELLE_BRANCHE_FMT / display 'Libellé branche';
	define NB_CTR / analysis 'Nombre de contrat' ;
	define ECART_JOUR_MAX / analysis mean 'Nb de jours max entre 2 dates successives de souscriptions';
	rbreak after / summarize ;
	compute after;
		LIBELLE_BRANCHE_FMT='Résumé';
		call define(_row_,"style","style=[backgroundcolor=grey color=#ffffff]");
	endcomp;
run;

ods excel close;

/* 6 */
ods excel file="/SASDECI/FormationProductionRapports_2.xlsx";

ods excel options(start_at="2,2" embedded_titles="yes" autofilter="yes" sheet_name="Mon Rapport");

proc report data=PERSO.BRANCHES_COTISATIONS
style(header)=Header{background=#074a7c color=#ffffff font_weight=bold};
	columns LIBELLE_BRANCHE_FMT NB_CTR ECART_JOUR_MAX ;
	define LIBELLE_BRANCHE_FMT / display 'Libellé branche';
	define NB_CTR / analysis 'Nombre de contrat' style=[tagattr="format:# ##0.00"];
	define ECART_JOUR_MAX / analysis mean 'Nb de jours max entre 2 dates successives de souscriptions' style=[tagattr="format:# ##0.00"];
	rbreak after / summarize ;
	compute after;
		LIBELLE_BRANCHE_FMT='Résumé';
		call define(_row_,"style","style=[backgroundcolor=grey color=#ffffff]");
	endcomp;
run;

ods excel close;
