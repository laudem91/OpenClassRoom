

prompt database

select name,created from v$database;


prompt table  SAP_ARFAC_COI


delete sap_arfac_coi
where lot = '&&1'
and org_id = &&2;



insert into sap_arfac_coi 
( cust_acct_site_id ,
org_id ,
lot,
customer_trx_id ,
BUKRS,
XBLNR,
KUNNR,
GKONT,
BLART,
BLDAT,
BUDAT,
BKTXT,
SGTXT,
WAERS,
WRBTR,
montant_initial,
exchange_rate,
HWAER,
DMBTR,
MWSKZ,
ZTERM,
ZFBDT,
ZLSCH,
ZLSPR,
HBKID,
HKTID,
BVTYP,
MSCHL,
coeff_payment 
)
select 
asa.cust_acct_site_id,
mvt.org_id , 
'&&1',
mvt.customer_trx_id ,
sap_tools_ar.org_id_to_sap_company ( mvt.org_id) ,  --BUKRS
mvt.trx_number ,        -- XBLNR
sap_tools_ar.account_number( asa.cust_acct_site_id) ,      -- KUNNR
sap_tools_arfac.gkont(mvt.customer_trx_id) , -- 99999998         GKONT
sap_tools_arfac.type_piece(typ.type) ,        -- BLART
mvt.trx_date  ,      -- BLDAT
sysdate ,        -- BUDAT
substr(mvt.comments,1,25)     ,   -- BKTXT
mvt.purchase_order ,       -- SGTXT
mvt.invoice_currency_code ,        -- WAERS
sch.amount_due_remaining ,       -- WRBTR
sch.amount_due_original ,       -- montant_initial
nvl(mvt.EXCHANGE_RATE,1) , -- exchange_rate
'EUR',        -- HWAER
round(sch.amount_due_remaining * nvl(mvt.EXCHANGE_RATE,1) ,2) ,        -- DMBTR
null   ,   --   le code tva sera deduit des lignes  ,        -- MWSKZ
-- sap_tools_arfac.transco_code_terms(   mvt.customer_trx_id ),        -- ZTERM
decode ( sap_tools_ar.condition_paiement_term_id(mvt.term_id), 
         null ,   decode (sap_tools_arfac.type_piece(typ.type) ,
                      'CX'    , 'COMPTANT',
                      null) ,
         sap_tools_ar.condition_paiement_term_id(mvt.term_id)                              ),    -- ZTERM
mvt.term_due_date ,        -- ZFBDT
 ( select  distinct v.RECEIPT_METHOD_NAME from ar_cust_receipt_methods_v v
where v.customer_id = hca.cust_account_id
and v.SITE_USE_ID = su.site_use_id)   , --ZLSCH
-- sap_tools_arfac.transco_code_method(   mvt.customer_trx_id) ,       -- ZLSCH
null ,    --  ZLSPR
null ,      -- HBKID
null ,   -- sap_tools_arfac.boucler_hbkid(   mvt.customer_trx_id ) ,       -- HKTID
sap_tools_arfac.boucler_bvtyp(   mvt.customer_trx_id ) ,      -- BVTYP
'ZFRA', --MSCHL
sch.amount_due_remaining / sch.amount_due_original    -- coeff_payment
/*
substr(orgn.name,5,5) Code_societe,hla.LOCATION_CODE Nom_societe
  ,hca.ACCOUNT_NUMBER Num_client
  ,hp.PARTY_NAME Nom_client, hca.account_number,substr(gcc.segment4,2,6) Cost
  ,decode(typ.type, 'CM','AVOIR','INV', 'FACTURE', typ.type) classe_mouvement, mvt.trx_number Num_mouvement
  ,sch.TRX_DATE Date_mouvement,sch.DUE_DATE Echeance
  ,mvt.PURCHASE_ORDER Ordre_achat,mvt.COMMENTS Commentaire
  ,gcc.segment2
  , sch.AMOUNT_DUE_ORIGINAL Mt_initial_ttc,sch.AMOUNT_DUE_REMAINING Solde,sch.INVOICE_CURRENCY_CODE Devise,decode(sch.STATUS,'OP','Ouvert','CL','Fermé') statut
  --,typ.name numero_encaissement
  -- ,let.gl_date date_gl_lettrage,
   --let.STATUS
*/
from ra_customer_trx_all mvt
,ar_payment_schedules_all sch
,RA_CUST_TRX_TYPES_all typ
,apps.HZ_PARTIES hp,
  apps.hz_party_sites hps,
  apps.HZ_CUST_ACCOUNTS hca,
  apps.hz_cust_acct_sites_all asa,
  apps.hz_cust_site_uses_all su,
  apps.hz_locations loc,
RA_CUST_TRX_LINE_GL_DIST_ALL dis,
GL_CODE_COMBINATIONS_V gcc,
apps.hr_locations_all hla,
HR_ORGANIZATION_UNITS orgn --,
where 1=1
and sch.STATUS != 'CL'
and orgn.LOCATION_ID = hla.LOCATION_ID
AND orgn.ORGANIZATION_ID = asa.ORG_ID
and gcc.CODE_COMBINATION_ID = dis.CODE_COMBINATION_ID
and mvt.customer_trx_id = dis.customer_trx_id
and typ.type in ('CM','INV')
and dis.ACCOUNT_CLASS = 'REC'
and typ.CUST_TRX_TYPE_ID = mvt.CUST_TRX_TYPE_ID
and orgn.organization_id = mvt.org_id
and mvt.org_id = asa.org_id
-- and mvt.org_id = let.org_id
and sch.CUSTOMER_TRX_ID = mvt.CUSTOMER_TRX_ID
and mvt.org_id = &&2
-- and trunc(mvt.TRX_DATE) >= to_date('01/10/2018','dd/mm/yyyy')
AND orgn.ORGANIZATION_ID = asa.ORG_ID
AND asa.PARTY_SITE_ID = hps.PARTY_SITE_ID
AND hps.LOCATION_ID = loc.LOCATION_ID
AND hp.PARTY_ID = hca.PARTY_ID
AND hca.CUST_ACCOUNT_ID = asa.CUST_ACCOUNT_ID
AND su.CUST_ACCT_SITE_ID = asa.CUST_ACCT_SITE_ID
AND su.ORG_ID = asa.ORG_ID
AND su.SITE_USE_CODE = 'BILL_TO'
AND hca.CUST_ACCOUNT_ID = mvt.BILL_TO_CUSTOMER_ID
AND su.SITE_USE_ID = mvt.BILL_TO_SITE_USE_ID;



delete sap_errors
where table_name ='SAP_ARFAC_COI'            
and lot = '&&1'
and org_id = &&2;

insert into sap_errors (
lot,
org_id,
table_name  ,
cle1    ,
libelle )
select '&&1' , &&2,'SAP_ARFAC_COI' , xblnr , 'numero de facture client trop grand (max=16) :'||xblnr 
from sap_arfac_coi
where length(xblnr) > 16
and lot = '&&1'
and org_id = &&2;

set serveroutput on size 1000000

delete sap_arfac_ti
where lot = '&&1'
and org_id = &&2;

declare
tot number :=0;
procedure sap_detail ( p_customer_trx_id in number,p_kunnr in varchar2,p_cust_acct_site_id in number,p_coeff_payment in number )
is
nb number := 0;
begin
nb := nb + 1;
insert into sap_arfac_ti (
org_id,
lot,
cust_acct_site_id,
customer_trx_id,
BUKRS,
XBLNR,
KUNNR,
BUZEI,
HKONT,
GKONT2,
MWSKZ,
FWBAS,
FWSTE,
HWBAS,
HWSTE,
coeff_payment)
select
mvt.org_id ,
'&&1',
p_cust_acct_site_id,
mvt.customer_trx_id ,
sap_tools_ar.org_id_to_sap_company ( mvt.org_id) ,  --BUKRS
mvt.trx_number ,        -- XBLNR
p_kunnr ,      -- KUNNR
rownum  , -- BUZEI
 gcc.segment2  ,        -- HKONT
sap_tools_arfac.gkont(mvt.customer_trx_id) , -- 99999998         GKONT2
-- sap_tools_arfac.transco_code_tva(zlv.TAX_RATE_CODE)  ,  --MWSKZ
zlv.TAX_RATE_CODE  ,  --MWSKZ
zlv.taxable_amt  , -- FWBAS
zlv.tax_amt ,   -- FWSTE
nvl(zlv.taxable_amt_funcl_curr , zlv.taxable_amt),  -- HWBAS
nvl(zlv.tax_amt_funcl_curr,zlv.tax_amt),     -- HWSTE
p_coeff_payment   -- coeff_payment
from ra_customer_trx_all mvt ,
RA_CUST_TRX_LINE_GL_DIST_ALL dis,
GL_CODE_COMBINATIONS_V gcc ,
RA_CUSTOMER_TRX_LINES_ALL rctla,
zx_lines_v zlv
where 1=1
and zlv.tax_line_id = rctla.tax_line_id
and rctla.customer_trx_line_id = dis.customer_trx_line_id
and gcc.CODE_COMBINATION_ID = dis.CODE_COMBINATION_ID
and dis.ACCOUNT_CLASS = 'TAX'
and mvt.customer_trx_id = dis.customer_trx_id
and mvt.customer_trx_id = p_customer_trx_id ;

end;
begin
delete sap_arfac_ti
where lot = '&&1'
and org_id = &&2;
for c1 in ( select * from sap_arfac_coi
            where lot = '&&1'
            and org_id = &&2)
loop
dbms_output.put_line ('Trait fac='|| c1.customer_trx_id);
sap_detail(c1.customer_trx_id, c1.kunnr,c1.cust_acct_site_id,c1.coeff_payment);
end loop;
end;
/

delete sap_errors
where table_name ='SAP_ARFAC_TI'            
and lot = '&&1'
and org_id = &&2;


prompt ajustement de la tva par rapport au paiement de la facture

update sap_arfac_ti
set FWBAS_CALC = FWBAS * coeff_payment,
FWSTE_CALC = FWSTE * coeff_payment,
HWBAS_CALC = HWBAS * coeff_payment,
HWSTE_CALC = HWSTE * coeff_payment 
where lot = '&&1'
and org_id = &&2;

select * from sap_errors
where table_name in ( 'SAP_ARFAC_COI','SAP_ARFAC_TI')
            and lot = '&&1'
            and org_id = &&2;

prompt Transco des account number

update sap_arfac_coi
set kunnr_transco = sap_tools_ar.transco_account_number(cust_acct_site_id)
where lot = '&&1'
and org_id = &&2;

update sap_arfac_ti
set kunnr_transco = sap_tools_ar.transco_account_number(cust_acct_site_id)
where lot = '&&1'
and org_id = &&2;

prompt mise à jour du code tva sur l'enete

declare
begin
for c1 in ( select  lot , org_id , bukrs , xblnr , kunnr , count( distinct mwskz ) NB , max (mwskz) mwskz
            from sap_arfac_ti
            where lot = '&&1'
            and org_id = &&2
            group by lot , org_id ,bukrs , xblnr , kunnr )
loop


if c1.nb = 1 
   then
update sap_arfac_coi
    set mwskz = c1.mwskz
    where (lot,org_id,bukrs,xblnr,kunnr) in (select  c1.lot,c1.org_id,c1.bukrs,c1.xblnr,c1.kunnr from dual);
   else
update sap_arfac_coi
    set mwskz = c1.mwskz
    where (lot,org_id,bukrs,xblnr,kunnr) in ( select  c1.lot,c1.org_id,c1.bukrs,c1.xblnr,c1.kunnr from dual );
    insert into sap_errors (
    lot,
    org_id,
    table_name  ,
    cle1    ,
    libelle )
    values ( c1.lot , c1.org_id, 'SAP_ARFAC_COI' , c1.xblnr , 'La facture client : '||c1.xblnr|| ' a plusieurs code tva : impact sur l''entete de la facture');
end if;
end loop;
end;
/



commit;
