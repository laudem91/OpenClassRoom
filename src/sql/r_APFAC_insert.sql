

set serveroutput on size 1000000

prompt database

select name,created from v$database;


prompt table  SAP_APFAC_VOI


delete sap_apfac_voi
where lot = '&&1'
and org_id = &&2;



insert into sap_apfac_voi 
( org_id ,
lot,
invoice_id ,
vendor_site_id,
BUKRS ,
XBLNR ,
LIFNR ,
GKONT ,
BLART ,
BLDAT ,
BUDAT ,
BKTXT ,
SGTXT ,
WAERS ,
WRBTR ,
HWAER ,
DMBTR ,
MWSKZ ,
ZTERM ,
ZFBDT ,
ZLSCH,
ZLSPR,
HBKID,
HKTID,
BVTYP
)
select
org_id  ,
'&&1',
invoice_id,
aia.vendor_site_id ,
 sap_tools_ar.ORG_ID_TO_SAP_COMPANY ( aia.org_id)     ,  -- BUKRS
  aia.invoice_num  ,  -- XBLNR
 SAP_TOOLS_AP.VENDOR_NUMBER ( aia.vendor_site_id)     ,  -- LIFNR
 SAP_TOOLS_APFAC.GKONT ( aia.invoice_id)    ,  -- GKONT
 SAP_TOOLS_APFAC.TYPE_PIECE ( aia.invoice_type_lookup_code)    ,  -- BLART
 aia.invoice_date     ,  -- BLDAT
 sysdate     ,  -- BUDAT
 substrb(aia.description,1,25)     ,  -- BKTXT
   substrb(aia.description,1,50)     ,  -- SGTXT
 aia.invoice_currency_code     ,  -- WAERS
  sap_tools_apfac.solde_invoice ( aia.invoice_id)     ,  -- WRBTR montant devise 
  'EUR'    ,  -- HWAER
   nvl(aia.base_amount,sap_tools_apfac.solde_invoice ( aia.invoice_id) )   ,  -- DMBTR
   -- SAP_TOOLS_APFAC.transco_code_tva( aia.invoice_id)   ,  -- MWSKZ
   null   ,  -- MWSKZ  calculer par rapport au ligne de la facture
   sap_tools_apfac.transco_code_terms(aia.invoice_id)     ,  -- ZTERM
  sap_tools_apfac.baseline_date(aia.invoice_id)  ,  -- ZFBDT
   sap_tools_apfac.transco_payment_method( aia.invoice_id) ,    -- ZLSCH aia
   sap_tools_apfac.transco_code_blocage( aia.invoice_id )      , -- ZLSPR
 null , -- sap_tools_apfac.boucler_hbkid( aia.invoice_id  ) ,      -- HBKID
 null ,   -- sap_tools_apfac.boucler_hbkid( aia.invoice_id  ) ,       -- HKTID
sap_tools_apfac.boucler_bvtyp( aia.invoice_id  )       -- BVTYP
from ap_invoices_all aia
where org_id = &2
and SAP_TOOLS_APFAC.SOLDE_INVOICE ( aia.invoice_id) != 0
;

delete sap_errors
where table_name ='SAP_APFAC_VOI'
and lot = '&&1'
and org_id = &&2;

insert into sap_errors (
org_id,
lot,
table_name  ,
cle1    ,
libelle )
select &&2 , '&&1','SAP_APFAC_VOI' , xblnr , 'REGLE - numero de facture fournisseurs trop grand (max=16) , application regle de reduction : '||xblnr 
from sap_apfac_voi
where length(xblnr) > 16
and lot = '&&1'
and org_id = '&&2';


prompt delete sap_apfac_ti

delete sap_apfac_ti
where lot = '&&1'
and org_id = &&2;


declare
tot number :=0;
procedure sap_detail ( p_invoice_id in number,p_lifnr in varchar2 ,p_vendor_site_id in number )
is
nb number := 0;
begin
nb := nb + 1;
insert into sap_apfac_ti (
 lot,
 org_id,
 vendor_site_id,
 invoice_distribution_id,
 invoice_id,
 line_number ,
 BUKRS,
 XBLNR,
  LIFNR,
  BUZEI,
  HKONT,
  GKONT2,
  MWSKZ,
  FWBAS,
  FWSTE,
  HWBAS,
 HWSTE
)
select 
 '&&1' ,
 &&2,
p_vendor_site_id,
aida.invoice_distribution_id ,
aia.invoice_id,
aila.line_number,
sap_tools_ar.org_id_to_sap_company ( aia.org_id) , -- BUKRS
aia.invoice_num     , -- XBLNR
p_lifnr     , -- LIFNR
rownum     , -- BUZEI
sap_tools_apfac.transco_compte_tva(   gcc.segment2 )     , -- HKONT
 sap_tools_apfac.gkont(aia.invoice_id)    , -- GKONT2
 SAP_TOOLS_APFAC.TRANSCO_CODE_TVA (aila.tax_rate_code)    , -- MWSKZ
 aida.taxable_amount    , -- FWBAS
 aila.total_rec_tax_amount    , -- FWSTE
 aida.taxable_base_amount     , -- HWBAS
 aila.total_rec_tax_amt_funcl_curr -- HWSTE)
from ap_invoice_lines_all aila ,  ap_invoice_distributions_all aida , ap_invoices_all aia , gl_code_combinations gcc
where aida.invoice_id  = aila.invoice_id
and aia.invoice_id = aila.invoice_id
and aila.LINE_NUMBER = aida.INVOICE_LINE_NUMBER
and aila.LINE_TYPE_LOOKUP_CODE = 'TAX'
and aida.LINE_TYPE_LOOKUP_CODE = 'REC_TAX'
and aida.invoice_id = p_invoice_id
and gcc.code_combination_id = aida.dist_code_combination_id 
and aida.posted_flag = 'Y'
 ;
end;
begin
delete sap_apfac_ti
where lot = '&&1'
and org_id = &&2;

for c1 in ( select * from sap_apfac_voi
            where lot = '&&1'
            and org_id = &&2)
loop
dbms_output.put_line ('Trait fac='|| c1.invoice_id);
sap_detail(c1.invoice_id, c1.lifnr,c1.vendor_site_id);
end loop;
end;
/

delete sap_errors
where table_name ='SAP_APFAC_TI'
and lot = '&&1'
and org_id = &&2;


prompt transcodage des fournisseurs


update sap_apfac_voi a
set LIFNR_TRANSCO = sap_tools_apfac.transco_nom_to_vendor_number(
                        (select attribute4  from ap_supplier_sites_all b
                        where a.vendor_site_id = b.vendor_site_id) ,
                        (select org_id  from ap_supplier_sites_all b
                        where a.vendor_site_id = b.vendor_site_id )
)
where lot = '&&1'
and org_id = &&2;
;

update sap_apfac_ti a
set LIFNR_TRANSCO = sap_tools_apfac.transco_nom_to_vendor_number(
                        (select attribute4  from ap_supplier_sites_all b
                        where a.vendor_site_id = b.vendor_site_id) ,
                        (select org_id  from ap_supplier_sites_all b
                        where a.vendor_site_id = b.vendor_site_id )
)
where lot = '&&1'
and org_id = &&2;
;
 
select count(*) from sap_apfac_ti
where lot = '&&1'
and org_id = &&2;

select * from sap_errors
where table_name in ( 'SAP_APFAC_VOI','SAP_APFAC_TI')
and lot = '&&1'
and org_id = &&2;


prompt mise à jour du code tva sur l'entete

declare
begin
for c1 in ( select  lot , org_id , bukrs , xblnr , lifnr , count( distinct mwskz ) NB , max (mwskz) mwskz
            from sap_apfac_ti
            where lot = '&&1'
            and org_id = &&2
            group by lot , org_id ,bukrs , xblnr , lifnr )
loop


if c1.nb = 1 
   then
update sap_apfac_voi
    set mwskz = c1.mwskz
    where (lot,org_id,bukrs,xblnr,lifnr) in (select  c1.lot,c1.org_id,c1.bukrs,c1.xblnr,c1.lifnr from dual);
   else
/* update sap_apfac_voi
    set mwskz = c1.mwskz
    where (lot,org_id,bukrs,xblnr,lifnr) in ( select  c1.lot,c1.org_id,c1.bukrs,c1.xblnr,c1.lifnr from dual );
*/
    insert into sap_errors (
    lot,
    org_id,
    table_name  ,
    cle1    ,
    libelle )
    values ( c1.lot , c1.org_id, 'SAP_APFAC_VOI' , c1.xblnr , 'WARNING:La facture fournisseur : '||c1.xblnr|| ' a plusieurs code tva : impact sur l''entete de la facture:pas de code tva');
end if;
end loop;
end;
/


prompt troncage du numero de facture



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
   select &&2 , '&&1','SAP_APFAC_VOI' , c1.xblnr , 'FATAL -numero de facture fournisseurs en double : '||c1.xblnr 
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
   select &&2 , '&&1','SAP_APFAC_VOI' , c1.xblnr , 'INFO : numero de facture fournisseurs tronqués :'||c1.xblnr || ' devient ' || c1.xblnr_trunc
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



commit;
