
create or replace package SAP_TOOLS_APFAC
as

function solde_invoice ( p_invoice_id in number) return number;
function dernier_ecriture_vendor_site ( p_vendor_site_id in number) return date;

function gkont(   p_invoice_id in number) return varchar2;
function type_piece(   p_type in varchar2) return varchar2;
function transco_code_tva(   p_in_code_tva in varchar2) return varchar2;
function transco_compte_tva(   p_in  in varchar2) return varchar2;
function transco_code_terms(   p_invoice_id in number) return varchar2;
function transco_payment_method(   p_invoice_id in number) return varchar2;
function transco_code_blocage(   p_invoice_id in number) return varchar2;
function baseline_date ( p_invoice_id in number) return date;
function boucler_hbkid(   p_invoice_id in number) return varchar2;
function boucler_hktid(   p_invoice_id in number) return varchar2;
function boucler_bvtyp(   p_invoice_id in number) return varchar2;
function transco_nom_to_vendor_number ( p_attribute4 in varchar2 , p_org_id in number) return varchar2;

end SAP_TOOLS_APFAC;
/

show error

create or replace package body SAP_TOOLS_APFAC
as

function solde_invoice ( p_invoice_id in number) return number
is
retourn number;
madevise varchar2(10);
begin

select invoice_currency_code 
into madevise
from ap_invoices_all
where invoice_id = p_invoice_id;

if madevise = 'EUR'
   then
select nvl(solde1,0) -  nvl(solde2,0)
into retourn
from (
SELECT NVL ( SUM (NVL (aid1.base_amount, aid1.amount)),
                                      0) solde1
       FROM ap_invoice_distributions_all aid1

       WHERE     aid1.invoice_id = p_invoice_id
    -- AND aid1.accounting_date <= sysdate
       AND aid1.posted_flag = 'Y' )
      ,
     (SELECT NVL (SUM(NVL (aip.PAYMENT_BASE_AMOUNT, aip.amount)),0) solde2
      FROM ap_invoice_payments_all aip
     WHERE    aip.invoice_id = p_invoice_id
 --  and  aip.accounting_date <= sysdate
     AND aip.posted_flag = 'Y')  ;
else
select nvl(solde1,0) -  nvl(solde2,0)
into retourn
from (
SELECT NVL ( SUM (NVL (aid1.amount, aid1.amount)),
                                      0) solde1
       FROM ap_invoice_distributions_all aid1

       WHERE     aid1.invoice_id = p_invoice_id
    -- AND aid1.accounting_date <= sysdate
       AND aid1.posted_flag = 'Y' )
      ,
     (SELECT NVL (SUM(NVL (aip.AMOUNT, aip.amount)),0) solde2
      FROM ap_invoice_payments_all aip
     WHERE    aip.invoice_id = p_invoice_id
 --  and  aip.accounting_date <= sysdate
     AND aip.posted_flag = 'Y')  ;

end if;

 

return retourn;

end;


function solde_invoice_old ( p_invoice_id in number) return number
is
retourn number;

begin
select nvl(solde1,0) -  nvl(solde2,0)
into retourn
from (
SELECT NVL ( SUM (NVL (aid1.base_amount, aid1.amount)),
                                      0) solde1
       FROM ap_invoice_distributions_all aid1

       WHERE     aid1.invoice_id = p_invoice_id
    -- AND aid1.accounting_date <= sysdate
       AND aid1.posted_flag = 'Y' )
      ,
     (SELECT NVL (SUM(NVL (aip.PAYMENT_BASE_AMOUNT, aip.amount)),0) solde2
      FROM ap_invoice_payments_all aip
     WHERE    aip.invoice_id = p_invoice_id
 --  and  aip.accounting_date <= sysdate
     AND aip.posted_flag = 'Y')  ;
 

return retourn;

end;

function dernier_ecriture_vendor_site ( p_vendor_site_id in number) return date
is
returndate date;
begin
select  max(ael.ACCOUNTING_DATE )
into returndate
from xla_ae_lines ael
where
( party_id,party_site_id,application_id )  =
   ( select  vendor_id , vendor_site_id , 200
     from ap_supplier_sites_all 
     where vendor_site_id = p_vendor_site_id
      );


return returndate;
end;


function gkont(   p_invoice_id in number) return varchar2
is
begin

return '99999998';

end;

function type_piece(   p_type in varchar2) return varchar2
is
retour varchar2(80);
begin

select decode(p_type, 'STANDARD','CX','CREDIT', 'CY', p_type)
into retour
from dual;

return retour;

end;

function transco_compte_tva(   p_in  in varchar2) return varchar2
is
begin

return p_in;

end;

function transco_code_tva(   p_in_code_tva in varchar2) return varchar2
is
begin

return p_in_code_tva;

end;

function transco_code_terms(   p_invoice_id in number) return varchar2
is
retour varchar2(80);
begin

begin
select name 
into retour
from ap_invoices_all aia  , ap_terms at
where aia.invoice_id = p_invoice_id
and aia.terms_id = at.term_id;

exception 
when no_data_found then retour := 'Code TERM inconnu'  ;
end;

return retour ;

end;

function transco_payment_method(   p_invoice_id in number) return varchar2
is
retour varchar2(80);
begin

begin
select aia.payment_method_code
into retour
from ap_invoices_all aia  
where aia.invoice_id = p_invoice_id;

exception
when no_data_found then retour := 'Code PAYMENT_METHOD_CODE  inconnu'  ;
end;

return retour ;

end;

function transco_code_blocage(   p_invoice_id in number) return varchar2
is
begin

return 'BLOCAGE';

end;

function baseline_date ( p_invoice_id in number) return date
is
begin
return sysdate;
end;

function boucler_hbkid(   p_invoice_id in number) return varchar2
is
begin

return 'BOUCLE_RETOUR_HBKID';

end;

function boucler_hktid(   p_invoice_id in number) return varchar2
is
begin

return 'BOUCLE_RETOUR_HKTID';

end;

function boucler_bvtyp(   p_invoice_id in number) return varchar2
is
begin

return 'BOUCLE_RETOUR_BVTYP';

end;

function transco_nom_to_vendor_number ( p_attribute4 in varchar2 , p_org_id in number) return varchar2
is
retour varchar2(80);
begin

begin
select sap_tools_ap.vendor_number(c.vendor_site_id)
into retour
 from (
 select ROW_NUMBER() OVER(  ORDER BY sap_glob_ordre.ordre) row_num ,
       sap_glob_ordre.ordre , 'F' || aps.segment1 || '-' || hps.party_site_number vendor_number,
       apsa.org_id org_id ,
       aps.party_id party_id,
       hps.party_site_id party_site_id ,
       apsa.vendor_site_id vendor_site_id
 from ap_suppliers aps, ap_supplier_sites_all apsa, hz_party_sites hps , sap_glob_ordre
 where aps.vendor_id = apsa.vendor_id
 and aps.segment1  = substr(p_attribute4,2,instr(p_attribute4,'-') -2 )
 and apsa.vendor_site_code = substr(p_attribute4,instr(p_attribute4,'-') +1 )
 and hps.party_site_id = apsa.party_site_id
 and apsa.org_id = nvl( p_org_id,apsa.org_id)
 and apsa.org_id = sap_glob_ordre.org_id ) c
 where row_num = 1;
 exception when no_data_found then retour :='ERREUR transco_vendor_nom_to_vendor_number:'|| p_attribute4 || '  -  ' || p_org_id;
end;

return retour;

end;


end SAP_TOOLS_APFAC;
/


show error

