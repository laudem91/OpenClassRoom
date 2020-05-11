
create or replace package sap_tools_ar
as

function ACCOUNT_NUMBER ( p_cust_acct_site_id in number) return varchar2;

function number_category_du_pays ( p_country in varchar2) return varchar2;

function is_pays_dependance ( p_country in varchar2) return varchar2;

function transco_ACCOUNT_NUMBER ( p_cust_acct_site_id in number) return varchar2;

function solde_site ( p_cust_acct_site_id in number) return number;

function derniere_ecriture_site ( p_cust_acct_site_id in number) return date;

function org_id_to_sap_company ( p1 in number) return varchar2;

function agent_compte ( p_cust_account_id in number ) return varchar2;

function agent_site ( p_cust_acct_site_id in number ) return varchar2;

function code_naf_gfi ( p_cust_account_id in number ) return varchar2;

function email_site ( p_cust_acct_site_id in number ) return varchar2;

function url_site ( p_cust_acct_site_id in number ) return varchar2;

function condition_paiement_term_id ( p_term_id in number ) return varchar2;

function condition_paiement_site_compta ( p_cust_acct_site_id in number ) return varchar2;

function envoyer_releve_site ( p_cust_acct_site_id in number ) return varchar2;

function envoyer_lettre_relance_site ( p_cust_acct_site_id in number ) return varchar2;

function eligible_effet_commerce_site ( p_cust_acct_site_id in number ) return varchar2;

function bill_to ( p_cust_acct_site_id in number ) return varchar2;

function site_a_desactiver (  p_cust_acct_site_id in number) return varchar2;

function cle_comptable_site ( p_cust_acct_site_id in number ) return varchar2;

function secteur_activite_site (  p_cust_acct_site_id in number) return varchar2;

function bp_grouping_site (  p_cust_acct_site_id in number) return varchar2;

function siret_site (  p_cust_acct_site_id in number) return varchar2;

function siren_site (  p_cust_acct_site_id in number) return varchar2;

function tvaintracom_site (  p_cust_acct_site_id in number) return varchar2;

function duns_site (  p_cust_acct_site_id in number) return varchar2;

function decompose_chaine_4_40 ( 
         p_in in varchar2,
         p_c1 in out varchar2 ,
         p_c2 in out varchar2 ,
         p_c3 in out varchar2 ,
         p_c4 in out varchar2,
         p_zone in number default null ) return varchar2;

function decompose_chaine_4_40 (
          p_in in varchar2,
          p_zone in number ) return varchar2;

function telephone_site ( p_party_site_id in number ) return varchar2;

function decompose_org_id ( p1 in varchar2, p_org_id in number default null ) return number;
function decompose_party_id ( p1 in varchar2 , p_org_id in number default null ) return number;
function decompose_party_site_id ( p1 in varchar2,p_org_id in number default null ) return number;
function decompose_cust_account_id ( p1 in varchar2,p_org_id in number default null ) return number;
function decompose_cust_acct_site_id ( p1 in varchar2,p_org_id in number default null ) return number;

end sap_tools_ar;
/

show error

create or replace package body sap_tools_ar
as

function format_contact( p_id in number , p_table in varchar2) return varchar2
is
-- function qui ne sert à rien pour l'instant
retour varchar2(80);
begin

null;

end;



function ACCOUNT_NUMBER (  p_cust_acct_site_id in number) return varchar2
is
retour varchar2(80);
begin

retour := 'INCONNU_ACCOUNT_NUMBER';

begin
select 'C' || hca.account_number || '-' || to_char(hps.party_site_number) 
into retour
from hz_cust_accounts hca , hz_cust_acct_sites_all hcasa , hz_party_sites hps
where hca.CUST_ACCOUNT_ID = hcasa.CUST_ACCOUNT_ID
and cust_acct_site_id = p_cust_acct_site_id
and hps.party_site_id = hcasa.party_site_id;
exception
when no_data_found then retour := 'INCONNU_ACCOUNT_NUMBER=cust_acct_site_id='|| p_cust_acct_site_id;
end;

return retour;
end;

function is_pays_dependance ( p_country in varchar2) return varchar2
is
retour varchar2(80);
begin

begin
select dependance_code2 
into retour
from sap_tr_pays
where code2 = p_country;
exception when no_data_found then retour := p_country;
end;


return nvl(retour,p_country);

end;

function number_category_du_pays ( p_country in varchar2) return varchar2
is
retour varchar2(80);
begin
begin
select tr_category
into retour
from sap_tr_number_category
where vat=1
and substr(tr_category,1,2) = p_country;


exception when no_data_found then retour := null;
          when too_many_rows then retour :='ERROR too many for '|| p_country;
end;

return retour;
end;

function transco_ACCOUNT_NUMBER (  p_cust_acct_site_id in number) return varchar2
is
retour varchar2(80);
begin

retour := 'INCONNU_ACCOUNT_NUMBER';

begin
select attribute4
into retour
from hz_cust_acct_sites_all hcasa 
where hcasa.cust_acct_site_id = p_cust_acct_site_id;

if retour is null then 
  retour := 'Transco erreur HZ_CUST_ACCT_SITES_ALL.attribute4 is null ?';
end if ;

exception
when no_data_found then retour := 'INCONNU_TRANSCO_ACCOUNT_NUMBER=cust_acct_site_id='|| p_cust_acct_site_id;
end;

return retour;
end;

function solde_site (  p_cust_acct_site_id in number) return number
is
retour number;
begin

SELECT sum(APSA.AMOUNT_DUE_REMAINING)
into retour
FROM AR_PAYMENT_SCHEDULES_ALL APSA
WHERE     APSA.CUSTOMER_SITE_USE_ID = ( select site_use_id 
                                        from hz_cust_site_uses_all hcsua
                                        where hcsua.site_use_code = 'BILL_TO'
                                        and  hcsua.status ='A'
                                        and hcsua.cust_acct_site_id = p_cust_acct_site_id
                                        )
AND APSA.AMOUNT_DUE_REMAINING <> 0;
        
return retour;
end;


function derniere_ecriture_site (  p_cust_acct_site_id in number) return date
is
retour date;
begin

begin

  select  max(ael.ACCOUNTING_DATE )
  into retour
  from xla_ae_lines ael
  where (ael.party_site_id,ael.party_id,ael.application_id) = ( select hcsua.site_use_id , hcasa.cust_account_id , 222
                                             from hz_cust_site_uses_all hcsua , hz_cust_acct_sites_all hcasa 
                                             where hcsua.site_use_code = 'BILL_TO'
                                             and  hcsua.status ='A'
                                             and hcsua.cust_acct_site_id = p_cust_acct_site_id
                                             and hcasa.cust_acct_site_id = hcsua.cust_acct_site_id
                                             )
  ;

exception when no_data_found then retour := null;
end;

return retour;
        

end;




function org_id_to_sap_company ( p1 in number) return varchar2
is 
retour varchar2(20);
begin

--if p1 = 189 then retour := '1504';
--elsif p1 = 5726 then retour := '1437';
--else retour := '000';
--end if;
retour := '000';

for c1 in ( 
select  a.organization_id , substr(b.name,-3) name -- ,  a.vat_country_code
from hr_operating_units a
 ,  gl_sets_of_books b
where a.set_of_books_id = b.SET_OF_BOOKS_ID
and a.organization_id = p1
--select a.org_id , substr(b.name,-3) name ,  a.vat_country_code 
--from financials_system_params_all a ,  gl_sets_of_books b
--where a.set_of_books_id = b.SET_OF_BOOKS_ID
-- and a.org_id = p1

)
loop
retour := '1' || c1.name;
end loop;

return retour;

end;

function agent_compte ( p_cust_account_id in number ) return varchar2
is
retour varchar2(1000);
begin
retour := null;
for c1 in ( 
select distinct ac.name name
from hz_customer_profiles hcp , hz_cust_site_uses_all hcsua , hz_cust_acct_sites_all hcasa , ar_collectors ac
where hcsua.CUST_ACCT_SITE_ID = hcasa.CUST_ACCT_SITE_ID
and  hcasa.CUST_ACCOUNT_ID = hcp.CUST_ACCOUNT_ID
and hcp.CUST_ACCOUNT_ID = P_CUST_ACCOUNT_ID 
-- and hcasa.cust_acct_site_id = P_CUST_ACCT_SITE_ID
-- and hcsua.org_id = P_ORG_ID 
-- and hcsua.primary_flag = 'Y' --LDT 14042020
and hcsua.site_use_code = 'BILL_TO'
and ac.COLLECTOR_ID = hcp.COLLECTOR_ID
and hcp.SITE_USE_ID = hcsua.SITE_USE_ID)
loop 
if retour is null 
  then
  retour := retour || c1.name ;
  else
  retour := retour || '|' || c1.name;
end if;

end loop;

return retour;

end;

function agent_site ( p_cust_acct_site_id in number ) return varchar2
is
retour varchar2(1000);
begin
retour := null;
for c1 in ( 
select name 
from (
select  ROW_NUMBER() OVER(  ORDER BY nvl(primary_flag,'N') desc ) row_num  , ac.name name
from hz_customer_profiles hcp , hz_cust_site_uses_all hcsua , hz_cust_acct_sites_all hcasa , ar_collectors ac
where hcsua.CUST_ACCT_SITE_ID = hcasa.CUST_ACCT_SITE_ID
and  hcasa.CUST_ACCOUNT_ID = hcp.CUST_ACCOUNT_ID
and hcasa.CUST_ACCT_SITE_ID = P_CUST_ACCT_SITE_ID 
and hcsua.site_use_code = 'BILL_TO'
-- and hcsua.primary_flag = 'Y'  -- LDT le 14042020
and ac.COLLECTOR_ID = hcp.COLLECTOR_ID
and hcp.SITE_USE_ID = hcsua.SITE_USE_ID)
where row_num = 1)
loop 
if retour is null 
  then
  retour := retour || c1.name ;
  else
  retour := retour || '|' || c1.name;
end if;

end loop;

return retour;

end;

function code_naf_gfi ( p_cust_account_id in number ) return varchar2
is
retour varchar2(80);
begin

begin
select hcas.class_code 
into retour
from hz_cust_accounts hca , hz_parties hp , HZ_CODE_ASSIGNMENTS hcas 
where cust_account_id = p_cust_account_id
and hp.PARTY_ID = hca.party_id
and hcas.OWNER_TABLE_ID = hp.party_id
and hcas.OWNER_TABLE_NAME = 'HZ_PARTIES'
and class_category = 'GFI_CODE_NAF'
;   
exception when no_data_found then null;
          when too_many_rows then retour := 'too_many_rows pour cust_account_id='|| p_cust_account_id;
end;

return retour;

end;

function email_site ( p_cust_acct_site_id in number ) return varchar2
is
retour varchar2(2000);
begin

retour := null;
for c1 in ( 
select hcas.email_address email_address
from hz_cust_accounts hca , hz_parties hp , HZ_CONTACT_POINTS hcas , hz_party_sites hps , hz_cust_acct_sites_all hcasa
where  hcasa.cust_acct_site_id = p_cust_acct_site_id 
and hps.party_site_id = hcasa.party_site_id
and hp.PARTY_ID = hca.party_id
and hps.PARTY_ID = hp.PARTY_ID
and hcas.OWNER_TABLE_ID = hps.party_site_id
and hcas.OWNER_TABLE_NAME = 'HZ_PARTY_SITES'
and hcas.CONTACT_POINT_TYPE = 'EMAIL' -- in ('WEB','EMAIL')
and hcas.status = 'A')
loop
if retour is null 
  then
  retour := retour || c1.email_address ;
  else
  retour := retour || '|' || c1.email_address;
end if;
end loop;

return retour;
end;

function url_site ( p_cust_acct_site_id in number ) return varchar2
is
retour varchar2(2000);
begin

retour := null;
for c1 in ( 
select hcas.url url
from hz_cust_accounts hca , hz_parties hp , HZ_CONTACT_POINTS hcas , hz_party_sites hps , hz_cust_acct_sites_all hcasa
where  hcasa.cust_acct_site_id = p_cust_acct_site_id 
and hps.party_site_id = hcasa.party_site_id
and hp.PARTY_ID = hca.party_id
and hps.PARTY_ID = hp.PARTY_ID
and hcas.OWNER_TABLE_ID = hps.party_site_id
and hcas.OWNER_TABLE_NAME = 'HZ_PARTY_SITES'
and hcas.CONTACT_POINT_TYPE = 'WEB' -- in ('WEB','EMAIL')
and hcas.status = 'A')
loop
if retour is null 
  then
  retour := retour || c1.url ;
  else
  retour := retour || '|' || c1.url;
end if;
end loop;

return retour;
end;

function condition_paiement_term_id ( p_term_id in number ) return varchar2
is
retour varchar2(80);
begin
retour := null;
begin
select termprf.name 
into retour
from ra_terms termprf
where p_term_id  = termprf.term_id ;
exception when no_data_found then null;
end;

return retour;

end;

function condition_paiement_site_compta ( p_cust_acct_site_id in number ) return varchar2
is
retour varchar2(80);
begin
retour := null;
begin

select name 
into retour
from (
select ROW_NUMBER() OVER(  ORDER BY nvl(primary_flag,'N') desc ) row_num , termprf.name  name
from hz_cust_acct_sites_all hcasa , hz_cust_site_uses_all hcsua ,  hz_CUSTOMER_PROFILES prf , ra_terms termprf
where hcasa.cust_acct_site_id =  p_cust_acct_site_id
and hcasa.CUST_ACCT_SITE_ID = hcsua.CUST_ACCT_SITE_ID
-- and hcsua.org_id = 189
and site_use_code = 'BILL_TO'
-- and hcsua.primary_flag = 'Y'   --LDT 14042020
and prf.CUST_ACCOUNT_ID = hcasa.CUST_ACCOUNT_ID
and prf.STANDARD_TERMS = termprf.term_id 
and prf.site_use_id = hcsua.site_use_id)
where row_num = 1;
exception when no_data_found then null;
end;

return retour;

end;

function envoyer_releve_site ( p_cust_acct_site_id in number ) return varchar2
is
retour varchar2(1000);
begin
retour := null;
begin
select send_statements
into retour
from (
select ROW_NUMBER() OVER(  ORDER BY nvl(primary_flag,'N') desc ) row_num , hcp.send_statements  send_statements
from hz_customer_profiles hcp , hz_cust_site_uses_all hcsua , hz_cust_acct_sites_all hcasa 
where hcsua.CUST_ACCT_SITE_ID = hcasa.CUST_ACCT_SITE_ID
and  hcasa.CUST_ACCOUNT_ID = hcp.CUST_ACCOUNT_ID
and hcasa.CUST_ACCT_SITE_ID = p_cust_acct_site_id 
and hcsua.site_use_code = 'BILL_TO'
-- and hcsua.primary_flag = 'Y'  -- LDT 14042020
and hcp.SITE_USE_ID = hcsua.SITE_USE_ID)
where row_num = 1;

exception when no_data_found then null;

end;

return retour;

end;

function envoyer_lettre_relance_site ( p_cust_acct_site_id in number ) return varchar2
is
retour varchar2(1000);
begin
retour := null;
begin
select dunning_letters
into retour
from ( 
select  ROW_NUMBER() OVER(  ORDER BY nvl(primary_flag,'N') desc ) row_num , hcp.dunning_letters dunning_letters
from hz_cust_accounts hca ,hz_customer_profiles hcp , hz_cust_site_uses_all hcsua , hz_cust_acct_sites_all hcasa 
where hca.CUST_ACCOUNT_ID = hcasa.CUST_ACCOUNT_ID
and hcsua.CUST_ACCT_SITE_ID = hcasa.CUST_ACCT_SITE_ID
and  hcasa.CUST_ACCOUNT_ID = hcp.CUST_ACCOUNT_ID
and hcasa.CUST_ACCT_SITE_ID = p_cust_acct_site_id 
and hcp.SITE_USE_ID = hcsua.SITE_USE_ID
-- and hcsua.primary_flag = 'Y'  --LDT 14042020
and hcsua.site_use_code = 'BILL_TO'
and hcp.PARTY_ID = hca.PARTY_ID)
where row_num = 1;

exception when no_data_found then null;
          when too_many_rows then retour := 'TROP';

end;

return retour;

end;

function eligible_effet_commerce_site ( p_cust_acct_site_id in number ) return varchar2
is
retour varchar2(1000);
begin
retour := 'N';
begin
select yesno
into retour
from ( 
select  ROW_NUMBER() OVER(  ORDER BY nvl(primary_flag,'N') desc ) row_num ,  'Y' yesno
from hz_customer_profiles hcp , hz_cust_site_uses_all hcsua , hz_cust_acct_sites_all hcasa 
where hcsua.CUST_ACCT_SITE_ID = hcasa.CUST_ACCT_SITE_ID
and  hcasa.CUST_ACCOUNT_ID = hcp.CUST_ACCOUNT_ID
and hcasa.CUST_ACCT_SITE_ID = p_cust_acct_site_id 
and hcp.SITE_USE_ID = hcsua.SITE_USE_ID
-- and hcsua.primary_flag = 'Y'  -- LDT 14042020
and hcsua.site_use_code ='DRAWEE'
and hcsua.status = 'A')
where row_num =1 ;

exception when no_data_found then null;

end;

return retour;

end;

function bill_to ( p_cust_acct_site_id in number ) return varchar2
is
retour number;
begin
retour := null;
begin
select count(*)
into retour
from hz_cust_acct_sites_all hcasa , hz_cust_site_uses_all hcsua 
where hcasa.cust_acct_site_id =  p_cust_acct_site_id
and hcasa.CUST_ACCT_SITE_ID = hcsua.CUST_ACCT_SITE_ID
and site_use_code = 'BILL_TO'
-- and hcsua.primary_flag = 'Y'
and hcsua.status = 'A';

exception when no_data_found then null;
end;

if retour = 0
  then
  return 'N';
  else
  return 'Y';
end if;


end;

function site_a_desactiver (  p_cust_acct_site_id in number) return varchar2
is
retour varchar2(80);
begin

retour := '';

begin
select decode(hcasa.attribute15,'Y','Y','N')
into retour
from hz_cust_accounts hca , hz_cust_acct_sites_all hcasa , hz_party_sites hps
where hca.CUST_ACCOUNT_ID = hcasa.CUST_ACCOUNT_ID
and cust_acct_site_id = p_cust_acct_site_id
and hps.party_site_id = hcasa.party_site_id;
exception
when no_data_found then retour := 'PAS DE SITE A DESCATIVER acct_site_id='|| p_cust_acct_site_id;
end;

return retour;
end;

function cle_comptable_site ( p_cust_acct_site_id in number ) return varchar2
is
retour varchar2(80);
begin
retour := null;
begin
select segment2
into retour
from (
select ROW_NUMBER() OVER(  ORDER BY nvl(primary_flag,'N') desc ) row_num ,  gcc.segment2 segment2
from hz_cust_acct_sites_all hcasa , hz_cust_site_uses_all hcsua , GL_CODE_COMBINATIONS gcc
where hcasa.cust_acct_site_id =  p_cust_acct_site_id
and hcasa.CUST_ACCT_SITE_ID = hcsua.CUST_ACCT_SITE_ID
-- and hcsua.org_id = 189
and site_use_code = 'BILL_TO'
-- and hcsua.primary_flag = 'Y'    -- LDT le 14042020
and hcsua.gl_id_rec = gcc.code_combination_id)
where row_num = 1;

exception when no_data_found then null;
end;

return retour;

end;

function secteur_activite_site (  p_cust_acct_site_id in number) return varchar2
is
retour varchar2(80);
begin

retour := '';

begin
select hca.attribute3
into retour
from hz_cust_accounts hca , hz_cust_acct_sites_all hcasa , hz_party_sites hps
where hca.CUST_ACCOUNT_ID = hcasa.CUST_ACCOUNT_ID
and cust_acct_site_id = p_cust_acct_site_id
and hps.party_site_id = hcasa.party_site_id;
exception
when no_data_found then retour := 'PAS DE SECTEUR pour cust_acct_site_id='|| p_cust_acct_site_id;
end;

return retour;
end;

function bp_grouping_site (  p_cust_acct_site_id in number) return varchar2
is
retour varchar2(80);
begin

retour := '';

begin
select decode(hca.attribute3,'GRP','ZGR1','Z001') 
into retour
from hz_cust_accounts hca , hz_cust_acct_sites_all hcasa , hz_party_sites hps
where hca.CUST_ACCOUNT_ID = hcasa.CUST_ACCOUNT_ID
and cust_acct_site_id = p_cust_acct_site_id
and hps.party_site_id = hcasa.party_site_id;
exception
when no_data_found then retour := 'PAS DE GROUPING  pour cust_acct_site_id='|| p_cust_acct_site_id;
end;

return retour;
end;

function siret_site (  p_cust_acct_site_id in number) return varchar2
is
retour varchar2(80);
begin

retour := '';

begin
select hcasa.attribute3 
into retour
from hz_cust_accounts hca , hz_cust_acct_sites_all hcasa , hz_party_sites hps
where hca.CUST_ACCOUNT_ID = hcasa.CUST_ACCOUNT_ID
and cust_acct_site_id = p_cust_acct_site_id
and hps.party_site_id = hcasa.party_site_id;
exception
when no_data_found then retour := 'PAS DE SIRET  pour cust_acct_site_id='|| p_cust_acct_site_id;
end;

return retour;
end;

function tvaintracom_site  (  p_cust_acct_site_id in number) return varchar2
is
retour varchar2(80);
begin

retour := '';

begin
select hp.tax_reference
into retour
from hz_cust_accounts hca , hz_parties hp , hz_cust_acct_sites_all hcasa 
where hca.cust_account_id = hcasa.cust_account_id
and hcasa.cust_acct_site_id = p_cust_acct_site_id
and hp.PARTY_ID = hca.party_id;

if upper(retour) like 'EXPORT%'
   then
   retour := null;
end if;

exception
when no_data_found then retour := 'PAS DE SIREN  pour cust_acct_site_id='|| p_cust_acct_site_id;
end;

return retour;
end;

function siren_site (  p_cust_acct_site_id in number) return varchar2
is
retour varchar2(80);
begin

retour := '';

begin
select hp.jgzz_fiscal_code
into retour
from hz_cust_accounts hca , hz_parties hp , hz_cust_acct_sites_all hcasa 
where hca.cust_account_id = hcasa.cust_account_id
and hcasa.cust_acct_site_id = p_cust_acct_site_id
and hp.PARTY_ID = hca.party_id;

-- LDT le 04/12/2019
if upper(retour) like 'EXPORT%'
   then
   retour := null;
end if;
  
exception
when no_data_found then retour := 'PAS DE TVAINTRACOM  pour cust_acct_site_id='|| p_cust_acct_site_id;
end;

return retour;
end;

function duns_site (  p_cust_acct_site_id in number) return varchar2
is
retour varchar2(80);
begin

retour := '';

begin
select  hcasa.attribute12   --  hcasa.attribute12
into retour
from hz_cust_accounts hca , hz_cust_acct_sites_all hcasa , hz_party_sites hps
where hca.CUST_ACCOUNT_ID = hcasa.CUST_ACCOUNT_ID
and cust_acct_site_id = p_cust_acct_site_id
and hps.party_site_id = hcasa.party_site_id;
exception
when no_data_found then retour := 'PAS DE DUNS  pour cust_acct_site_id='|| p_cust_acct_site_id;
end;

return retour;
end;

function decompose_chaine_4_40 ( 
 p_in in varchar2,
 p_c1 in out varchar2 ,
 p_c2 in out varchar2 ,
 p_c3 in out varchar2 ,
 p_c4 in out varchar2,
 p_zone in number default null ) return varchar2
is
chaine varchar2(400);
chaine1 varchar2(80);
chaine2 varchar2(80);
chaine3 varchar2(80);
chaine4 varchar2(400);
x number;
result varchar2(80);
begin
-- chaine := 'REMY CUISNIER ou PEIRRE CELLARD ou Pascal NOURRY-MAISONS DU MONDE FRANCE SAS-104 54444444444444444443 44444444444444444445';
-- chaine := 'REMY CUISNIER sdffffffffffffffffffffffff x dddd y hhhhhhhhhhhhhhhhhhh z hhhhhddddddhhhhhoooo';
-- chaine := '123456789012345678901234567890123456789x123456789012345678901234567890123456789y 123456789012345678901234567890123456789Z123456789012345678901234567890123456789z';

chaine := p_in;

if substr(chaine,1,1) =' ' then chaine := substr(chaine,2); end if;  -- pour enlever le 1er espace de la chaine

if length(chaine) <= 40 
 then
  chaine1 := chaine;
  chaine := null;
  else
  chaine1 := substr(chaine,1,40);
  x := instr(chaine1,' ',-1);
  if x <= 40 and x != 0 then
  chaine1 := substr(chaine1,1,x);
  else
  x := 40;
  chaine1 := substr(chaine1,1,40);
  end if;
end if;

chaine := substr(chaine,x+1);

if substr(chaine,1,1) =' ' then chaine := substr(chaine,2); end if;  -- pour enlever le 1er espace de la chaine

if length(chaine) <= 40 
 then
  chaine2 := chaine;
  chaine := null;
  else
  chaine2 := substr(chaine,1,40);
  x := instr(chaine2,' ',-1);
  if x <= 40 and x != 0 then
  chaine2 := substr(chaine2,1,x);
  else
  x := 40;
  chaine2 := substr(chaine2,1,40);
  end if;
 end if;

chaine := substr(chaine,x+1);
if substr(chaine,1,1) =' ' then chaine := substr(chaine,2); end if;  -- pour enlever le 1er espace de la chaine

if length(chaine) <= 40 
 then
  chaine3 := chaine;
  chaine := null;
  else
  chaine3 := substr(chaine,1,40);
  x := instr(chaine3,' ',-1);
  if x <= 40  and x != 0  then
  chaine3 := substr(chaine3,1,x);
  else
  x := 40;
  chaine3 := substr(chaine3,1,40);
  end if;
end if;

  chaine := substr(chaine,x+1);
if substr(chaine,1,1) =' ' then chaine := substr(chaine,2); end if;  -- pour enlever le 1er espace de la chaine

if length(chaine) <= 40 
 then
  chaine4 := chaine;
  chaine := null;
  else
  chaine4 := substr(chaine,1,40);
  x := instr(chaine4,' ',-1);
  if x <= 40 and x != 0  then
  chaine4 := substr(chaine4,1,x);
  else
  x := 40;
  chaine4 := substr(chaine4,1,40);
  end if;
end if;
  

p_c1 := chaine1;
p_c2 := chaine2;
p_c3 := chaine3;
p_c4 := chaine4;

dbms_output.put_line ( 'ch1=' || chaine1 );
dbms_output.put_line ( 'ch2=' || chaine2 );
dbms_output.put_line ( 'ch3=' || chaine3 );
dbms_output.put_line ( 'ch4=' || chaine4 );

if p_zone is null
   then
   return null;
   elsif p_zone = 1 then return p_c1;
   elsif p_zone = 2 then return p_c2;
   elsif p_zone = 3 then return p_c3;
   elsif p_zone = 4 then return p_c4;
end if;
end;


function decompose_chaine_4_40 (
          p_in in varchar2,
          p_zone in number ) return varchar2
is
chainetemp1 varchar2(400);
chainetemp2 varchar2(400);
chainetemp3 varchar2(400);
chainetemp4 varchar2(400);
begin
return decompose_chaine_4_40 ( 
 p_in ,
 chainetemp1  ,
 chainetemp2  ,
 chainetemp3  ,
 chainetemp4 ,
 p_zone );

end;


function telephone_site ( p_party_site_id in number ) return varchar2
is
retour varchar2(200);
begin

retour := null;

for c2 in (
select owner_table_id, contact_point_id,phone_area_code , phone_country_code , phone_number,raw_phone_number
from HZ_CONTACT_POINTS
where CONTACT_POINT_TYPE = 'PHONE'
and OWNER_TABLE_NAME = 'HZ_PARTY_SITES'
and OWNER_TABLE_ID = p_party_site_id
and status ='A')
loop

if retour is null
  then
  retour := retour || c2.raw_phone_number ;
  else
  retour := retour || '|' || c2.raw_phone_number;
end if;

end loop;

return retour;

end;

function decompose_org_id ( p1 in varchar2, p_org_id in number default null ) return number
is
-- p1 est au format Cxxxxxxx-yyyyyyy
retourn number;
begin
begin
select org_id
into retourn
from (
select ROW_NUMBER() OVER(  ORDER BY sap_glob_ordre.ordre) row_num , 
       sap_glob_ordre.ordre , 'C' || hca.account_number || '-' || hps.party_site_number account_number, 
       hcasa.org_id org_id ,
       hca.party_id party_id, 
       hps.party_site_id party_site_id , 
       hcasa.CUST_ACCT_SITE_ID cust_acct_site_id 
from hz_cust_accounts hca , hz_cust_acct_sites_all hcasa , hz_party_sites hps , sap_glob_ordre
where hca.CUST_ACCOUNT_ID = hcasa.CUST_ACCOUNT_ID
and hca.account_number  = substr(p1,2,instr(p1,'-') -2 ) 
and hps.party_site_number = substr(p1,instr(p1,'-') +1 )
and hps.party_site_id = hcasa.party_site_id
and hcasa.org_id = nvl(p_org_id,hcasa.org_id)
and hcasa.org_id = sap_glob_ordre.org_id )
where row_num = 1 ;

exception when no_data_found then retourn := null;
end;

return retourn;


end;

 
function decompose_party_id ( p1 in varchar2 , p_org_id in number default null ) return number
is
-- p1 est au format Cxxxxxxx-yyyyyyy
-- si p_org_id est null , on recherche par l'ordre des org_is sinon on recherche pour p_org_id
retourn number;
begin
begin
select party_id
into retourn
from (
select ROW_NUMBER() OVER(  ORDER BY sap_glob_ordre.ordre) row_num , 
       sap_glob_ordre.ordre , 'C' || hca.account_number || '-' || hps.party_site_number account_number, 
       hcasa.org_id org_id ,
       hca.party_id party_id, 
       hps.party_site_id party_site_id , 
       hcasa.CUST_ACCT_SITE_ID cust_acct_site_id 
from hz_cust_accounts hca , hz_cust_acct_sites_all hcasa , hz_party_sites hps , sap_glob_ordre
where hca.CUST_ACCOUNT_ID = hcasa.CUST_ACCOUNT_ID
and hca.account_number  = substr(p1,2,instr(p1,'-') -2 ) 
and hps.party_site_number = substr(p1,instr(p1,'-') +1 )
and hps.party_site_id = hcasa.party_site_id
and hcasa.org_id = nvl(p_org_id,hcasa.org_id)
and hcasa.org_id = sap_glob_ordre.org_id )
where row_num = 1 ;

exception when no_data_found then retourn := null;
end;

return retourn;


end;

function decompose_party_site_id ( p1 in varchar2,p_org_id in number default null ) return number
is
-- p1 est au format Cxxxxxxx-yyyyyyy
retourn number;
begin
begin
select party_site_id
into retourn
from (
select ROW_NUMBER() OVER(  ORDER BY sap_glob_ordre.ordre) row_num , 
       sap_glob_ordre.ordre , 'C' || hca.account_number || '-' || hps.party_site_number account_number, 
       hcasa.org_id org_id ,
       hca.party_id party_id, 
       hps.party_site_id party_site_id , 
       hcasa.CUST_ACCT_SITE_ID cust_acct_site_id 
from hz_cust_accounts hca , hz_cust_acct_sites_all hcasa , hz_party_sites hps , sap_glob_ordre
where hca.CUST_ACCOUNT_ID = hcasa.CUST_ACCOUNT_ID
and hca.account_number  = substr(p1,2,instr(p1,'-') -2 ) 
and hps.party_site_number = substr(p1,instr(p1,'-') +1 )
and hps.party_site_id = hcasa.party_site_id
and hcasa.org_id = nvl(p_org_id,hcasa.org_id)
and hcasa.org_id = sap_glob_ordre.org_id )
where row_num = 1 ;

exception when no_data_found then retourn := null;
end;

return retourn;


end;

function decompose_cust_account_id ( p1 in varchar2,p_org_id in number default null ) return number
is
-- p1 est au format Cxxxxxxx-yyyyyyy
retourn number;
begin
begin
select cust_account_id
into retourn
from (
select ROW_NUMBER() OVER(  ORDER BY sap_glob_ordre.ordre) row_num , 
       sap_glob_ordre.ordre , 'C' || hca.account_number || '-' || hps.party_site_number account_number, 
       hcasa.org_id org_id ,
       hca.party_id party_id, 
       hps.party_site_id party_site_id , 
       hca.cust_account_id,
       hcasa.CUST_ACCT_SITE_ID cust_acct_site_id 
from hz_cust_accounts hca , hz_cust_acct_sites_all hcasa , hz_party_sites hps , sap_glob_ordre
where hca.CUST_ACCOUNT_ID = hcasa.CUST_ACCOUNT_ID
and hca.account_number  = substr(p1,2,instr(p1,'-') -2 ) 
and hps.party_site_number = substr(p1,instr(p1,'-') +1 )
and hps.party_site_id = hcasa.party_site_id
and hcasa.org_id = nvl(p_org_id,hcasa.org_id)
and hcasa.org_id = sap_glob_ordre.org_id )
where row_num = 1 ;

exception when no_data_found then retourn := null;
end;

return retourn;


end;

function decompose_cust_acct_site_id ( p1 in varchar2,p_org_id in number default null ) return number
is
-- p1 est au format Cxxxxxxx-yyyyyyy
retourn number;
begin
begin
select cust_acct_site_id
into retourn
from (
select ROW_NUMBER() OVER(  ORDER BY sap_glob_ordre.ordre) row_num , 
       sap_glob_ordre.ordre , 'C' || hca.account_number || '-' || hps.party_site_number account_number, 
       hcasa.org_id org_id ,
       hca.party_id party_id, 
       hps.party_site_id party_site_id , 
       hcasa.CUST_ACCT_SITE_ID cust_acct_site_id 
from hz_cust_accounts hca , hz_cust_acct_sites_all hcasa , hz_party_sites hps , sap_glob_ordre
where hca.CUST_ACCOUNT_ID = hcasa.CUST_ACCOUNT_ID
and hca.account_number  = substr(p1,2,instr(p1,'-') -2 ) 
and hps.party_site_number = substr(p1,instr(p1,'-') +1 )
and hps.party_site_id = hcasa.party_site_id
and hcasa.org_id = nvl(p_org_id,hcasa.org_id)
and hcasa.org_id = sap_glob_ordre.org_id )
where row_num = 1 ;

exception when no_data_found then retourn := null;
end;

return retourn;


end;

end sap_tools_ar;
/


show error


