/* 1 */
proc sql;
	create table PERSO.MOYENNE_COTIS_BRANCHE as
	select AWICTR_CODBCH, mean(AWICTR_CTSANNHT) as MOY_COTIS 
	from PERSO.FUSION_TAWICTR_BRANCHE_5 
	group by AWICTR_CODBCH;
quit;


/* 2 */
proc sql;
create table PERSO.FUSION_TAWICTR_BRANCHE_SQL as 
select a.*,b.LIBELLE_BRANCHE
from PERSO.TAWICTR_EXTRACT as a
inner join PERSO.REFERENTIEL_BRANCHES as b
on a.AWICTR_CODBCH = b.CODE_BRANCHE;
quit;


/* 3 */
proc sql;
	select mean(AWICTR_CTSANNHT) into: MvMoyCotis 
	from PERSO.FUSION_TAWICTR_BRANCHE_5;
quit;
%put Moyenne Cotisation annnuelle : &MvMoyCotis ;

/* 4 */
proc sql;
	select name into:VarListe separated by ','
	from sashelp.vcolumn 
	where libname=upcase("PERSO") and memname=upcase("FUSION_TAWICTR_BRANCHE_5")
	and upcase(substr(name,1,5)) ne "FLAG_";
quit;
%put Liste variables : &VarListe;

proc sql;
	create table PERSO.FUSION_TAWICTR_SANS_FLAG as 
	select &VarListe. 
	from PERSO.FUSION_TAWICTR_BRANCHE_5;
quit;

