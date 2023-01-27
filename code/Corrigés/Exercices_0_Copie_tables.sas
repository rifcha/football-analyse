libname forma "/ker7/Qsasgrp/FormationSasLangage";
/*
proc surveyselect data=siadidw.tawictr out=forma.tawictr n=100000;
run;
*/

proc sql;
select AWICTR_CODBCH,count(*) as nb from forma.tawictr group by AWICTR_CODBCH;
quit;
