/****************************************************************************************/
/*	Macro-Programme : kpi_m_sp_w_publication_pixis                                      */
/*  Fichier         : /sqdd/app/kpi/macro/kpi_m_sp_w_publication_pixis.sas    	        */
/****************************************************************************************/
/*																						*/
/* Description      : Macro restituant les KPI à publier avec la vision mois précédent	*/
/* Paramètres       :																	*/
/*																						*/
/****************************************************************************************/
/*	Auteur  : Vincent GAILLARD                                                          */
/*  Version :                                                                           */
/*           - 1.0 : 27/04/2021                                                         */  
/*																						*/
/****************************************************************************************/

%macro kpi_m_sp_w_publication_pixis(prfMkpiPUBLICATION_etape=);

	libname perftd "SASDECI/PERF/SAS";

	/* Récupération du dernier jour du mois précédent */
	data _null_;
		call symput("precmoisfin",-1+intnx('month', today(), 0));
	run;

	%if &prfMkpiPUBLICATION_etape. eq periode %then %do;
		goptions reset=all border;
		data squares;
		   length function style color $ 8 text $ 150;
		   xsys="1"; ysys="1";hsys="1";
	   	   color='white';
		   function="move"; x=10; y=0; output;
		   function="bar";  x=90; y=10; style="solid"; output;
		   function="label"; x=4; y=50; position="6";
	       style="Arial"; size=36; text=compbl("%sysfunc(putn(&precmoisfin,mmyys7.)) ");color="black"; output;
		run;

		proc ganno annotate=squares 
		   gout=excat;
		run;
		quit;
	%end;

	%else %do;

		%if &prfMkpiPUBLICATION_etape. eq Vertica %then %do;
			%let MvarTable = kpi_Etape_1_Vertica;
			%let MvTitre = Vertica;
		%end;
		%if &prfMkpiPUBLICATION_etape. eq VerticaToSAS %then %do;
			%let MvarTable = kpi_Etape_2_VerticaToSAS;
			%let MvTitre = Transfert Vertica-SAS;
		%end;
		%if &prfMkpiPUBLICATION_etape. eq ServeurSAS %then %do;
			%let MvarTable = kpi_Etape_3_ServeurSas;
			%let MvTitre = Serveur SAS;
		%end;
		%if &prfMkpiPUBLICATION_etape. eq SasToWindows %then %do;
			%let MvarTable = kpi_Etape_4_SasVersWindows;
			%let MvTitre = Transfert SAS-Windows;
		%end;


		/* Récupération des KPI du mois précédent */
		data _null_;
			set perftd.prf_tt_consolidation_kpi(where=(date_trt=&precmoisfin. and periode_kpi="M"));
			call symput("kpi",compress(&MvarTable.));
		run;

		/* Récupération des paramètres de la table paramètres */
		data _null_;
			set perftd.prf_tt_param end=eof;
			call symput('MvParam'||left(_n_),Param);
			call symputx('MvValue'||left(_n_),Value);
			if eof then call symputx('nbparam',_n_);;
		run;

		/* Allocation des macros paramètres */
		%do i=1 %to &nbparam.;
			%let &&MvParam&i = &&MvValue&i;
		%end;

		goptions reset=all device=javaimg xpixels=210 ypixels=200 transparency;

		proc gkpi mode=modern;
			speedometer actual=%sysfunc(compbl(%sysevalf(&kpi./100))) 
			bounds=(0.5 %sysfunc(compbl(%sysevalf(&KpiSeuilBas./100))) %sysfunc(compbl(%sysevalf(&KpiSeuilHaut./100))) 1) /
			colors=(cxD06959 cxF1DC63 cx84AF5B)
			format="percent8.0"
			lfont=(f="Calibri" height=.7cm)
			type=half;
		run; 

	%end;

%mend kpi_m_sp_w_publication_pixis;
