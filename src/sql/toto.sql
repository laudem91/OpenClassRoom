declare
x number := 0;
avant number := 0;
avant_trunc number := 0;
apres number := 0;
begin
--recherche des facture par fournisseur avec depassement de capacité
for c1 in ( select lifnr , xblnr , substr(xblnr,-16) xblnr_trunc, count(*) nb  
            from sap_apfac_voi
            where length(xblnr) > 16 
            and lot = '&&1'
            and org_id = &&2
            group by  lifnr , xblnr ,  substr(xblnr,-16) )
loop


if c1.nb != 1 
   then

   insert into sap_errors (
   org_id,
   lot,
   table_name  ,
   cle1    ,
   libelle )
   select &&2 , '&&1','SAP_APFAC_VOI' , c1.xblnr , 'numero de facture fournisseurs en double : '||c1.xblnr 
   from dual;
else

-- comptage des lignes de la facture
select count(*) 
into avant
from sap_apfac_ti
where lifnr = c1.lifnr
and xblnr = c1.xblnr
and lot = '&&1'
and org_id = &&2;

 
select count(*) 
into avant_trunc
from sap_apfac_ti
where lifnr = c1.lifnr
and xblnr = c1.xblnr_trunc
and lot = '&&1'
and org_id = &&2;

if avant_trunc = 0 
   then
   -- mise a jour de l'entete de la facture
   update sap_apfac_voi
   set XBLNR = c1.xblnr_trunc ,
    sgtxt = substr(c1.xblnr_trunc || ' ' || sgtxt ,1 ,50)
    where lifnr = c1.lifnr
    and xblnr = c1.xblnr
    and  lot = '&&1'
    and org_id = &&2;

   -- mise a jour des lignes de la facture
   update sap_apfac_ti
   set XBLNR = c1.xblnr_trunc 
    where lifnr = c1.lifnr
    and xblnr = c1.xblnr
    and  lot = '&&1'
    and org_id = &&2;

   insert into sap_errors (
   org_id,
   lot,
   table_name  ,
   cle1    ,
   libelle )
   select &&2 , '&&1','SAP_APFAC_VOI' , c1.xblnr , 'numero de facture fournisseurs tronqués :'||c1.xblnr || ' devient ' || c1.xblnr_trunc
   from dual;
   else
   -- le numero de facture existe deja avant tronquage
insert into sap_errors (
   org_id,
   lot,
   table_name  ,
   cle1    ,
   libelle )
   select &&2 , '&&1','SAP_APFAC_VOI' , c1.xblnr , 'FATAL- numero de facture fournisseurs a tronquer deja existant ' ||c1.xblnr || ' ne peut pas devenir ' || c1.xblnr_trunc
   from dual;

 
end if;
end if;

end loop;

end;
/


