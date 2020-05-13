rem  P1=LOT
rem  P2= rien
rem  P3= rien

set linesize 255

prompt database

select name,created from v$database;

prompt  Extraction pour 

select 'Extraction pour le lot ' || sap_lot  from dual;

select org_id , sap_tools_ar.org_id_to_sap_company(org_id ) SAP_COMPANY
from sap_glob_perimetre 
where lot = sap_lot;


prompt table  SAP_AR_GD


insert into SAP_AR_GD 
(ORG_ID,
lot ,
SOLDE_SITE ,
DERNIERE_ECRITURE_SITE,
CUSTOMER_NUMBER ,
BP_GROUPING,
KTOKD,
party_name ,
NAME,
NAME_2,
NAME_3,
NAME_4,
SEARCH_TERM_1,
SEARCH_TERM_2,
KONZS,
KUKLA,
INDUSTRY_CODE_1,
INDUSTRY_CODE_2,
INDUSTRY_CODE_3,
STREET,
STREET_2,
STREET_3,
STREET_4,
HOUSE_NUMBER,
POSTAL_CODE1,
CITY1,
COUNTRY1,
LANGUAGE,
EMAIL,
COMMUNICATION_TYPE,
WEB_SITE,
Actif,
TELEPHONE,
party_id  ,
party_site_id ,
cust_account_id ,
cust_acct_site_id  
 ) 
SELECT
hcasa.org_id,
sap_lot,
sap_tools_ar.solde_site ( hcasa.cust_acct_site_id),
sap_tools_ar.derniere_ecriture_site ( hcasa.cust_acct_site_id),
sap_tools_ar.account_number(hcasa.cust_acct_site_id),
sap_tools_ar.bp_grouping_site(hcasa.cust_acct_site_id) , --  decode(hca.attribute3,'GR1','ZGR1','Z001') ,
sap_tools_ar.bp_grouping_site(hcasa.cust_acct_site_id) , --  KTOKD
hca.account_name,
sap_tools_ar.decompose_chaine_4_40 (hca.ACCOUNT_NAME,1) ,
sap_tools_ar.decompose_chaine_4_40 (hca.ACCOUNT_NAME,2) ,
sap_tools_ar.decompose_chaine_4_40 (hca.ACCOUNT_NAME,3) ,
sap_tools_ar.decompose_chaine_4_40 (hca.ACCOUNT_NAME,4) ,
substr(hca.ACCOUNT_NAME,1,20),
sap_tools_ar.account_number(hcasa.cust_acct_site_id)  ,            -- 'C:'||hca.account_number ,
hca.attribute2,     -- KONZS
decode (hca.customer_class_code,'PRIVATE','PR', 'PUBLIC','PU',hca.customer_class_code) ,
sap_tools_ar.code_naf_gfi( hca.cust_account_id),
hca.attribute1,
hca.attribute4,
substr(loc.ADDRESS1,1,40) ,
substr(loc.ADDRESS2,1,35) ,
substr(loc.ADDRESS3,1,35) ,
substr(loc.ADDRESS4,1,35) ,
'',
loc.postal_code,
loc.city,
loc.country,
decode(loc.language,'FR','FR','F','FR','EN'),
sap_tools_ar.email_site(hcasa.cust_acct_site_id),
hcasa.attribute20,
sap_tools_ar.url_site(hcasa.cust_acct_site_id),
hcasa.status,
sap_tools_ar.telephone_site(hps.party_site_id),
hp.party_id,
hps.party_site_id,
hca.cust_account_id,
hcasa.cust_acct_site_id
FROM apps.HZ_PARTIES hp,
  apps.hz_party_sites hps,
  apps.HZ_CUST_ACCOUNTS hca,
  apps.hz_cust_acct_sites_all hcasa,
  hz_locations loc
WHERE 1=1
and hp.party_id = hca.party_id
and hca.cust_account_id = hcasa.cust_account_id
and hps.party_site_id = hcasa.party_site_id
AND hps.LOCATION_ID               = loc.LOCATION_ID
and ( hcasa.org_id , hp.party_id , hps.party_site_id , hca.cust_account_id , hcasa.cust_acct_site_id) 
in ( select  ORG_ID_ATTRIBUTE4 , PARTY_ID_ATTRIBUTE4 , PARTY_SITE_ID_ATTRIBUTE4 , CUST_ACCOUNT_ID_ATTRIBUTE4 , CUST_ACCT_SITE_ID_ATTRIBUTE4    from sap_ar_v)
;


prompt Insert des CONTACTS dans SAP_AR_GD

declare
tot number;

procedure ins_contact_site ( p_customer in varchar2 , p_cust_account_id in number,p_cust_acct_site_id in number,p_org_id in number)
is
totc number;
begin
totc := 0;
for c2 in (
SELECT * FROM 
  ( SELECT hcar.CUST_ACCOUNT_ROLE_ID as CARI, hcar.PARTY_ID, hcar.CUST_ACCOUNT_ID, hcar.CURRENT_ROLE_STATE, 
hcar.CUST_ACCT_SITE_ID, hcar.PRIMARY_FLAG, hcar.ROLE_TYPE, hcar.SOURCE_CODE, hcar.ORIG_SYSTEM_REFERENCE, hcar.STATUS, 
hpsub.PARTY_NAME, hps.LOCATION_ID, hprel.PRIMARY_PHONE_COUNTRY_CODE, hprel.PRIMARY_PHONE_AREA_CODE, hprel.PRIMARY_PHONE_NUMBER, 
hprel.PRIMARY_PHONE_EXTENSION, hprel.PRIMARY_PHONE_LINE_TYPE, hprel.EMAIL_ADDRESS, hoc.JOB_TITLE, hps.MAILSTOP, 
ftv.TERRITORY_SHORT_NAME as COUNTRY, hps.ORIG_SYSTEM_REFERENCE as PS_REFERENCE, hpsub.PARTY_ID as SUB_PARTY_ID, 
hpsub.PARTY_TYPE, hprel.PARTY_ID as REL_PARTY_ID, hr.RELATIONSHIP_ID, lookups.meaning JOB_TITLE_CODE, 
hoc.contact_number 
-- ,HZ_UTILITY_V2PUB.get_lookupmeaning ( 'FND_LOOKUP_VALUES' , 'HZ_CPUI_REGISTRY_STATUS' , hcar.STATUS ) as CONTACT_STATUS_MEANING 
FROM HZ_CUST_ACCOUNT_ROLES hcar, HZ_PARTIES hpsub, HZ_PARTIES hprel, HZ_ORG_CONTACTS hoc, HZ_RELATIONSHIPS hr, HZ_PARTY_SITES hps, 
FND_TERRITORIES_VL ftv,fnd_lookup_values_vl lookups 
WHERE hcar.CUST_ACCOUNT_ID = p_cust_account_id  --- LDT
AND hcar.ROLE_TYPE = 'CONTACT' AND hcar.PARTY_ID = hr.PARTY_ID 
AND hr.PARTY_ID = hprel.PARTY_ID AND hr.SUBJECT_ID = hpsub.PARTY_ID 
AND hoc.PARTY_RELATIONSHIP_ID = hr.RELATIONSHIP_ID AND hr.DIRECTIONAL_FLAG = 'F'
AND hps.PARTY_ID(+) = hprel.PARTY_ID AND nvl(hps.IDENTIFYING_ADDRESS_FLAG, 'Y') = 'Y' 
AND nvl(hps.STATUS, 'A') = 'A' AND hprel.COUNTRY = ftv.TERRITORY_CODE(+) 
AND nvl(hcar.CUST_ACCT_SITE_ID, 1) = nvl( p_cust_acct_site_id  , 1) AND lookups.LOOKUP_TYPE (+)='RESPONSIBILITY'
AND lookups.LOOKUP_CODE(+)=hoc.JOB_TITLE_CODE) QRSLT WHERE (STATUS='A')

)


loop
totc := totc + 1;
insert into sap_ar_gd( lot,org_id,bpee_customer_number,customer_number,bp_grouping,first_name,last_name,telephone,email,language)
values ( sap_lot,p_org_id,p_customer, c2.cari , 'ZCP1' , c2.party_name , null, c2.primary_phone_number,c2.email_address , 'FR');
-- values ( sap_lot,p_org_id,p_customer, c2.party_id , 'ZCP1' , c2.party_name , null, c2.primary_phone_number,c2.email_address , 'FR');
end loop;
end;


begin
for c1 in ( 
select 
hcasa.org_id ,
sap_tools_ar.account_number( hcasa.cust_acct_site_id)  cust_omer,
hps.party_site_id ,
hcasa.cust_acct_site_id ,
hcasa.cust_account_id
from hz_cust_acct_sites_all hcasa , hz_cust_accounts hca , hz_party_sites hps
where hca.CUST_ACCOUNT_ID = hcasa.CUST_ACCOUNT_ID
and hps.party_site_id = hcasa.party_site_id
and ( hcasa.org_id , hcasa.cust_acct_site_id ) in  ( select org_id_attribute4 , cust_acct_site_id_attribute4 from sap_ar_v where lot=sap_lot)
)
loop
ins_contact_site( c1.cust_omer , c1.cust_account_id,c1.cust_acct_site_id, c1.org_id);
end loop;

end;
/





-- regle generale sur la population à extraire


-- delete sap_ar_gd
-- where Customer_Number not in ( select Customer_Number from sap_filtre_Customer_Number)
-- and lot = sap_lot
-- and org_id = sap_org_id
-- and bp_grouping != 'ZCP1';

prompt supprimer les ZCP1 de customer rejetes

-- delete sap_ar_gd a
-- where bp_grouping = 'ZCP1'
-- and lot = sap_lot
-- and org_id = sap_org_id
-- and not exists ( select null from sap_ar_gd b
                 -- where a.bpee_customer_number = b.customer_number
                  -- and b.lot = sap_lot
                  -- and b.org_id = sap_org_id);



prompt Controle de la longueur de zip code

rem  delete sap_errors;


delete sap_errors
where lot = sap_lot 
and table_name ='SAP_AR_GD';

insert into sap_errors (
lot,
org_id,
table_name  ,
cle1    ,
libelle )
select lot,org_id,'SAP_AR_GD' , customer_number , 'Classification( KUKLA)  PU ou PR inconnu : '|| nvl(KUKLA,'null')
from sap_ar_gd
where nvl(KUKLA,'Xx') not in ( 'PR','PU')
and bp_grouping != 'ZCP1'       -- sauf les contact
and lot = sap_lot
;


insert into sap_errors (
lot,
org_id,
table_name  ,
cle1    ,
libelle )
select lot,org_id,'SAP_AR_GD' , customer_number , 'SEARCH_TERM_1 trop grand- probleme de caracteres UTF8  ( 20 max ) :'|| search_term_1
from sap_ar_gd
where length(SEARCH_TERM_1) > 20
and lot = sap_lot
;

insert into sap_errors (
lot,
org_id,
table_name  ,
cle1    ,
libelle,
groupesearch  )
select lot,org_id,'SAP_AR_GD' , customer_number , 'Code postal trop grand ( 10 max ) :'|| postal_code1 , 'POSTAL_CODE'
from sap_ar_gd
where length(postal_code1) > 10
and lot = sap_lot
;

insert into sap_errors (
lot,
org_id,
table_name  ,
cle1    ,
libelle,groupesearch )
select lot,org_id,'SAP_AR_GD' , customer_number , 'Code postal non conforme (longueur <> 5 caracteres ) pour la france :'|| postal_code1 ,'POSTAL_CODE'
from sap_ar_gd
where length(postal_code1) != 5
and country1 ='FR'
and lot = sap_lot
;


insert into sap_errors (
lot,
org_id,
table_name  ,
cle1    ,
libelle , groupesearch)
select lot,org_id,'SAP_AR_GD' , customer_number , 
     'WARNING Telephone non conforme :'|| telephone || ' devient ' || REGEXP_REPLACE( replace(replace(telephone,' ' ,''),'.',''), '[^0-9]+', '')  ,
     'TELEPHONE'
from sap_ar_gd
where lot = sap_lot
and replace(replace(telephone,' ',''),'.','') !=  REGEXP_REPLACE( replace(replace(telephone,' ' ,''),'.',''), '[^0-9]+', '')
;

prompt formatage du No de telephone

update sap_ar_gd
set telephone_transco = REGEXP_REPLACE( replace(replace(telephone,' ' ,''),'.',''), '[^0-9]+', '')
where lot = sap_lot;

insert into sap_errors (
lot,
org_id,
table_name  ,
cle1    ,
libelle ,groupesearch)
select lot,org_id,'SAP_AR_GD' , customer_number , 'Telephone trop grand ( 30 max ) :'|| telephone ,'TELEPHONE'
from sap_ar_gd
where length(telephone_transco) > 30
and lot = sap_lot
;

insert into sap_errors (
lot,
org_id,
table_name  ,
cle1    ,
libelle )
select lot,org_id,'SAP_AR_GD' , customer_number , 'First_name trop grand ( 40 max ) :'|| first_name
from sap_ar_gd
where length(first_name) > 40
and lot = sap_lot
;

insert into sap_errors (
lot,
org_id,
table_name  ,
cle1    ,
libelle )
select lot,org_id,'SAP_AR_GD' , customer_number , 'name_4 trop grand ( 40 max ) :'|| name_4
from sap_ar_gd
where length(name_4) > 40
and lot = sap_lot
;

insert into sap_errors (
lot,
org_id,
table_name  ,
cle1    ,
libelle )
select lot,org_id,'SAP_AR_GD' , customer_number , 'name_3 trop grand ( 40 max ) :'|| name_3
from sap_ar_gd
where length(name_3) > 40
and lot = sap_lot
;

insert into sap_errors (
lot,
org_id,
table_name  ,
cle1    ,
libelle )
select lot,org_id,'SAP_AR_GD' , customer_number , 'name_2 trop grand ( 40 max ) :'|| name_2
from sap_ar_gd
where length(name_2) > 40
and lot = sap_lot
;

insert into sap_errors (
lot,
org_id,
table_name  ,
cle1    ,
libelle )
select lot,org_id,'SAP_AR_GD' , customer_number , 'name trop grand ( 40 max ) :'|| name
from sap_ar_gd
where length(name) > 40
and lot = sap_lot
;


prompt table  sap_ar_bp_roles


insert into sap_ar_bp_roles ( CUSTOMER_NUMBER , BP_ROLE , ORG_ID , lot )
select distinct CUSTOMER_NUMBER , 'FLCU00' , null , sap_lot
from sap_ar_gd
where lot = sap_lot
-- and org_id = sap_org_id
and bp_grouping != 'ZCP1';

insert into sap_ar_bp_roles ( CUSTOMER_NUMBER , BP_ROLE , ORG_ID  , lot)
select distinct CUSTOMER_NUMBER , 'FLCU01' , '' , sap_lot
from sap_ar_gd
where lot = sap_lot
-- and org_id = sap_org_id
and bp_grouping != 'ZCP1';

insert into sap_ar_bp_roles ( CUSTOMER_NUMBER , BP_ROLE , ORG_ID  , lot)
select distinct CUSTOMER_NUMBER , 'BUP001' , '' , sap_lot
from sap_ar_gd
where lot = sap_lot
-- and org_id = sap_org_id
and bp_grouping = 'ZCP1';

prompt table  sap_ar_gt


insert into sap_ar_gt ( 
org_id , 
lot,
Customer_Number ,
Text_ID ,
Language_Key ,
Text) 
select '' , 
sap_lot,
sap_tools_ar.account_number( hcasa.cust_acct_site_id) ,
'TX01' ,
'FR',
replace (replace ( hcasa.attribute16,chr(10),' '),chr(13),' ')
from hz_cust_acct_sites_all hcasa
where hcasa.attribute16 is not null
and ( hcasa.cust_acct_site_id) in ( select   distinct CUST_ACCT_SITE_ID_ATTRIBUTE4    from sap_ar_v)
;


prompt table SAP_AR_SD    par organisation

insert into SAP_AR_SD ( 
org_id,
lot,
KUNNR,
VKORG,
VTWEG,
SPART,
WAERS,
KALKS,
VSBED,
VWERK,
BOKRE,
PRFRE,
ZTERM,
KTGRD,
KVGR1)
select distinct org_id_source,
sap_lot ,
sap_tools_ar.account_number( cust_acct_site_id_attribute4) ,  --KUNNR
sap_tools_ar.org_id_to_sap_company( org_id_source) , -- VKORG
decode(sap_tools_ar.bp_grouping_site(cust_acct_site_id_attribute4),'ZGR1', '90','10') , --  VTWEG decode(hca.attribute3,'GRP','ZGR1','Z001') ,  
'01' , --SPART
(select b.CURRENCY_CODE from hr_operating_units a , gl_sets_of_books b
where b.set_of_books_id = a.set_of_books_id
and organization_id = org_id_source) ,  -- WAERS
'1' , -- KALKS
'01' , -- VSBED
sap_tools_ar.org_id_to_sap_company( org_id_source) ,  -- VWERK
'X' ,  -- BOKRE
'X' ,  -- PRFRE
sap_tools_ar.condition_paiement_site_compta(CUST_ACCT_SITE_ID_ATTRIBUTE5)  , -- ZTERM
'KTGRD',
(select attribute20 from hz_cust_acct_sites_all  b
 where b.cust_acct_site_id = cust_acct_site_id_attribute5 )   --- KVGR1
FROM apps.HZ_PARTIES hp,
  apps.hz_party_sites hps,
  apps.HZ_CUST_ACCOUNTS hca,
  apps.hz_cust_acct_sites_all hcasa,
  hz_locations loc,
  sap_ar_v v
WHERE 1=1
and hp.party_id = hca.party_id
and hca.cust_account_id = hcasa.cust_account_id
and hps.party_site_id = hcasa.party_site_id
AND hps.LOCATION_ID               = loc.LOCATION_ID
and  hcasa.org_id =ORG_ID_ATTRIBUTE5
and hp.party_id =PARTY_ID_ATTRIBUTE5
and hps.party_site_id =PARTY_SITE_ID_ATTRIBUTE5
and hca.cust_account_id =CUST_ACCOUNT_ID_ATTRIBUTE5
and hcasa.cust_acct_site_id = CUST_ACCT_SITE_ID_ATTRIBUTE5
;


prompt table  sap_ar_cd par organisation;

insert into sap_ar_cd ( 
org_id,
lot,
customer_number,
company_code,
DUNNING_PROCEDURE,
BUSAB_D,
ACCOUNT_MEMO,
ZTERM,
PAYMENT_METHOD_1,
HBKID,
TOLERANCE_GROUP,
AKONT)
select 
distinct 
org_id_source,
sap_lot ,
sap_tools_ar.account_number( v.CUST_ACCT_SITE_ID_ATTRIBUTE4) , -- customer_number,
sap_tools_ar.org_id_to_sap_company( org_id_source) , -- company_code,
decode ( sap_tools_ar.envoyer_lettre_relance_site(CUST_ACCT_SITE_ID_ATTRIBUTE5),'Y','ZFRA',null) ,  -- DUNNING_PROCEDURE, 
sap_tools_ar.agent_site ( CUST_ACCT_SITE_ID_ATTRIBUTE5), -- BUSAB_D
 decode ( sap_tools_ar.envoyer_releve_site(CUST_ACCT_SITE_ID_ATTRIBUTE5),'Y','2',null)  , -- ACCOUNT_MEMO,
 sap_tools_ar.condition_paiement_site_compta(CUST_ACCT_SITE_ID_ATTRIBUTE5) , --PAYMENT_TERMS,
 decode(sap_tools_ar.eligible_effet_commerce_site (CUST_ACCT_SITE_ID_ATTRIBUTE5),'Y','H','E') , --PAYMENT_METHOD_1,
null  , --HBKID
sap_tools_ar.org_id_to_sap_company(ORG_ID_SOURCE) , -- TOLERANCE_GROUP,
sap_tools_ar.cle_comptable_site ( CUST_ACCT_SITE_ID_ATTRIBUTE5) --AKONT 
from hz_cust_acct_sites_all hcasa , sap_ar_v  v
where  hcasa.cust_acct_site_id = CUST_ACCT_SITE_ID_ATTRIBUTE5
;


prompt table  sap_ar_i;

insert into sap_ar_i (
org_id ,
lot,
KUNNR  ,
IND_SECTOR ,
ISDEF)
select hcasa.org_id,
sap_lot ,
sap_tools_ar.account_number( hcasa.cust_acct_site_id) ,
sap_tools_ar.SECTEUR_ACTIVITE_SITE( hcasa.cust_acct_site_id),
null
from hz_cust_acct_sites_all hcasa , hz_cust_accounts hca , hz_party_sites hps
where hca.CUST_ACCOUNT_ID = hcasa.CUST_ACCOUNT_ID
and hps.party_site_id = hcasa.party_site_id
and ( hcasa.org_id , hps.party_id , hps.party_site_id , hca.cust_account_id , hcasa.cust_acct_site_id) 
in ( select  distinct ORG_ID_ATTRIBUTE4 , PARTY_ID_ATTRIBUTE4 , PARTY_SITE_ID_ATTRIBUTE4 , CUST_ACCOUNT_ID_ATTRIBUTE4 , CUST_ACCT_SITE_ID_ATTRIBUTE4    from sap_ar_v)
;


prompt table  sap_ar_tc;





declare
begin

for c1 in (
select hcasa.org_id org_id,
sap_tools_ar.account_number( hcasa.cust_acct_site_id) kunnr,
(select c.vat_country_code  from hr_operating_units a , gl_sets_of_books b , financials_system_params_all c
where b.set_of_books_id = a.set_of_books_id
and b.SET_OF_BOOKS_ID = c.SET_OF_BOOKS_ID
and organization_id  = hcasa.org_id  ) aland ,
'MWST' tatyp ,
'1' taxkd 
from hz_cust_acct_sites_all hcasa , hz_cust_accounts hca , hz_party_sites hps
where hca.CUST_ACCOUNT_ID = hcasa.CUST_ACCOUNT_ID
and hps.party_site_id = hcasa.party_site_id
and ( hcasa.org_id , hps.party_id , hps.party_site_id , hca.cust_account_id , hcasa.cust_acct_site_id) 
in ( select  distinct ORG_ID_ATTRIBUTE4 , PARTY_ID_ATTRIBUTE4 , PARTY_SITE_ID_ATTRIBUTE4 , CUST_ACCOUNT_ID_ATTRIBUTE4 , CUST_ACCT_SITE_ID_ATTRIBUTE4    from sap_ar_v)
)
loop



insert into sap_ar_tc  ( lot,ORG_ID , KUNNR  , ALAND  , TATYP , TAXKD )
values (sap_lot , c1.ORG_ID , c1.KUNNR  , c1.ALAND  , 'FTX1' , '1' ); 

insert into sap_ar_tc  ( lot , ORG_ID , KUNNR  , ALAND  , TATYP , TAXKD )
values (sap_lot , c1.ORG_ID , c1.KUNNR  , c1.ALAND  , 'LCFR' , '0' ); 

end loop;
end;
/

select count(*) from sap_ar_tc;

commit;




prompt table  sap_ar_tn;
-- Insertion du SIRET
insert into SAP_AR_TN (
ORG_ID ,
lot,
KUNNR  ,
TAXTYPE  ,
TAXNUM)
select 
hcasa.org_id ,
sap_lot,
sap_tools_ar.account_number( hcasa.cust_acct_site_id) ,
'FR1',
sap_tools_ar.siret_site(hcasa.cust_acct_site_id)
from hz_cust_acct_sites_all hcasa , hz_cust_accounts hca , hz_party_sites hps
where hca.CUST_ACCOUNT_ID = hcasa.CUST_ACCOUNT_ID
and hps.party_site_id = hcasa.party_site_id
and ( hcasa.org_id , hps.party_id , hps.party_site_id , hca.cust_account_id , hcasa.cust_acct_site_id) 
in ( select  distinct ORG_ID_ATTRIBUTE4 , PARTY_ID_ATTRIBUTE4 , PARTY_SITE_ID_ATTRIBUTE4 , CUST_ACCOUNT_ID_ATTRIBUTE4 , CUST_ACCT_SITE_ID_ATTRIBUTE4    from sap_ar_v)
;

-- Insertion du Siren

insert into SAP_AR_TN (
ORG_ID ,
lot,
KUNNR  ,
TAXTYPE  ,
TAXNUM)
select 
hcasa.org_id ,
sap_lot ,
sap_tools_ar.account_number( hcasa.cust_acct_site_id) ,
'FR2',
sap_tools_ar.siren_site(hcasa.cust_acct_site_id)
from hz_cust_acct_sites_all hcasa , hz_cust_accounts hca , hz_party_sites hps
where hca.CUST_ACCOUNT_ID = hcasa.CUST_ACCOUNT_ID
and hps.party_site_id = hcasa.party_site_id
and ( hcasa.org_id , hps.party_id , hps.party_site_id , hca.cust_account_id , hcasa.cust_acct_site_id) 
in ( select  distinct ORG_ID_ATTRIBUTE4 , PARTY_ID_ATTRIBUTE4 , PARTY_SITE_ID_ATTRIBUTE4 , CUST_ACCOUNT_ID_ATTRIBUTE4 , CUST_ACCT_SITE_ID_ATTRIBUTE4    from sap_ar_v)
;




-- Insertion de la tva Intar communautaire

insert into SAP_AR_TN (
ORG_ID ,
lot,
KUNNR  ,
TAXTYPE  ,
TAXNUM)
select 
hcasa.org_id ,
sap_lot ,
sap_tools_ar.account_number( hcasa.cust_acct_site_id) ,
sap_tools_ar.number_category_du_pays( loc.country)   ,    -- 'FR0'
sap_tools_ar.tvaintracom_site(hcasa.cust_acct_site_id)
from hz_cust_acct_sites_all hcasa , hz_cust_accounts hca , hz_party_sites hps , hz_locations loc
where hca.CUST_ACCOUNT_ID = hcasa.CUST_ACCOUNT_ID
and hps.party_site_id = hcasa.party_site_id
and sap_tools_ar.number_category_du_pays( loc.country) is not null
and hps.LOCATION_ID               = loc.LOCATION_ID
and ( hcasa.org_id , hps.party_id , hps.party_site_id , hca.cust_account_id , hcasa.cust_acct_site_id) 
in ( select  distinct ORG_ID_ATTRIBUTE4 , PARTY_ID_ATTRIBUTE4 , PARTY_SITE_ID_ATTRIBUTE4 , CUST_ACCOUNT_ID_ATTRIBUTE4 , CUST_ACCT_SITE_ID_ATTRIBUTE4    from sap_ar_v)
;


delete SAP_AR_TN 
where taxnum is null
and lot = sap_lot;

prompt table  sap_ar_in;

insert into SAP_AR_IN (
ORG_ID,
lot,
KUNNR  ,
TTYPE ,
IDNUMBER)
select 
hcasa.org_id ,
sap_lot,
sap_tools_ar.account_number( hcasa.cust_acct_site_id) ,
'BUP001',
sap_tools_ar.duns_site( hcasa.cust_acct_site_id)
from hz_cust_acct_sites_all hcasa , hz_cust_accounts hca , hz_party_sites hps
where hca.CUST_ACCOUNT_ID = hcasa.CUST_ACCOUNT_ID
and hps.party_site_id = hcasa.party_site_id
and ( hcasa.org_id , hps.party_id , hps.party_site_id , hca.cust_account_id , hcasa.cust_acct_site_id) 
in ( select  distinct ORG_ID_ATTRIBUTE4 , PARTY_ID_ATTRIBUTE4 , PARTY_SITE_ID_ATTRIBUTE4 , CUST_ACCOUNT_ID_ATTRIBUTE4 , CUST_ACCT_SITE_ID_ATTRIBUTE4    from sap_ar_v)
;

prompt delete SAP_AR_IN where duns is null

delete SAP_AR_IN 
where lot = sap_lot
and idnumber is null;



prompt table  sap_ar_cp;



declare
tot number;

procedure ins_telephone_site ( p_party_site_id in number,p_customer in varchar2,p_org_id in number)
is
totc number;
begin
totc := 0;
for c2 in (
select owner_table_id, contact_point_id,phone_area_code , phone_country_code , phone_number,raw_phone_number
from HZ_CONTACT_POINTS
where CONTACT_POINT_TYPE = 'PHONE'
and OWNER_TABLE_NAME = 'HZ_PARTY_SITES'
and OWNER_TABLE_ID = p_party_site_id)
loop
totc := totc + 1;
insert into sap_ar_cp( lot,org_id,kunnr,parnr,langucorr,abtnr,pafkt,tel_no,lname)
values ( sap_lot, p_org_id  , p_customer, c2.contact_point_id , -- p_party_site_id 
-- values ( sap_lot, p_org_id  , p_customer, c2.owner_table_id , -- p_party_site_id 
'FR','0003' ,'0003',c2.raw_phone_number,'Téléphone BP');
end loop;
end;

procedure ins_contact_site ( p_customer in varchar2 , p_cust_account_id in number,p_cust_acct_site_id in number,p_org_id in number)
is
totc number;
begin
totc := 0;
for c2 in (
SELECT * FROM 
  ( SELECT hcar.CUST_ACCOUNT_ROLE_ID as CARI, hcar.PARTY_ID, hcar.CUST_ACCOUNT_ID, hcar.CURRENT_ROLE_STATE, 
hcar.CUST_ACCT_SITE_ID, hcar.PRIMARY_FLAG, hcar.ROLE_TYPE, hcar.SOURCE_CODE, hcar.ORIG_SYSTEM_REFERENCE, hcar.STATUS, 
hpsub.PARTY_NAME, hps.LOCATION_ID, hprel.PRIMARY_PHONE_COUNTRY_CODE, hprel.PRIMARY_PHONE_AREA_CODE, hprel.PRIMARY_PHONE_NUMBER, 
hprel.PRIMARY_PHONE_EXTENSION, hprel.PRIMARY_PHONE_LINE_TYPE, hprel.EMAIL_ADDRESS, hoc.JOB_TITLE, hps.MAILSTOP, 
ftv.TERRITORY_SHORT_NAME as COUNTRY, hps.ORIG_SYSTEM_REFERENCE as PS_REFERENCE, hpsub.PARTY_ID as SUB_PARTY_ID, 
hpsub.PARTY_TYPE, hprel.PARTY_ID as REL_PARTY_ID, hr.RELATIONSHIP_ID, lookups.meaning JOB_TITLE_CODE, 
hoc.contact_number -- ,HZ_UTILITY_V2PUB.get_lookupmeaning ( 'FND_LOOKUP_VALUES' , 'HZ_CPUI_REGISTRY_STATUS' , hcar.STATUS ) as CONTACT_STATUS_MEANING 
FROM HZ_CUST_ACCOUNT_ROLES hcar, HZ_PARTIES hpsub, HZ_PARTIES hprel, HZ_ORG_CONTACTS hoc, HZ_RELATIONSHIPS hr, HZ_PARTY_SITES hps, 
FND_TERRITORIES_VL ftv,fnd_lookup_values_vl lookups 
WHERE hcar.CUST_ACCOUNT_ID = p_cust_account_id  --- LDT
AND hcar.ROLE_TYPE = 'CONTACT' AND hcar.PARTY_ID = hr.PARTY_ID 
AND hr.PARTY_ID = hprel.PARTY_ID AND hr.SUBJECT_ID = hpsub.PARTY_ID 
AND hoc.PARTY_RELATIONSHIP_ID = hr.RELATIONSHIP_ID AND hr.DIRECTIONAL_FLAG = 'F'
AND hps.PARTY_ID(+) = hprel.PARTY_ID AND nvl(hps.IDENTIFYING_ADDRESS_FLAG, 'Y') = 'Y' 
AND nvl(hps.STATUS, 'A') = 'A' AND hprel.COUNTRY = ftv.TERRITORY_CODE(+) 
AND nvl(hcar.CUST_ACCT_SITE_ID, 1) = nvl( p_cust_acct_site_id  , 1) AND lookups.LOOKUP_TYPE (+)='RESPONSIBILITY'
AND lookups.LOOKUP_CODE(+)=hoc.JOB_TITLE_CODE) QRSLT WHERE (STATUS='A')

)


loop
totc := totc + 1;
insert into sap_ar_cp( lot,org_id,kunnr,parnr,langucorr,abtnr,pafkt,lname,tel_no,e_mail)
values ( sap_lot,p_org_id,p_customer, c2.cari , 'FR','0003' ,'0003',c2.party_name , c2.primary_phone_number,c2.email_address);
-- values ( sap_lot,p_org_id,p_customer, c2.party_id , 'FR','0003' ,'0003',c2.party_name , c2.primary_phone_number,c2.email_address);
end loop;
end;


begin
for c1 in ( 
select 
hcasa.org_id ,
sap_tools_ar.account_number( hcasa.cust_acct_site_id)  cust_omer,
hps.party_site_id ,
hcasa.cust_acct_site_id ,
hcasa.cust_account_id
from hz_cust_acct_sites_all hcasa , hz_cust_accounts hca , hz_party_sites hps
where hca.CUST_ACCOUNT_ID = hcasa.CUST_ACCOUNT_ID
and hps.party_site_id = hcasa.party_site_id
and ( hcasa.org_id , hps.party_id , hps.party_site_id , hca.cust_account_id , hcasa.cust_acct_site_id) 
in ( select  distinct ORG_ID_ATTRIBUTE4 , PARTY_ID_ATTRIBUTE4 , PARTY_SITE_ID_ATTRIBUTE4 , CUST_ACCOUNT_ID_ATTRIBUTE4 , CUST_ACCT_SITE_ID_ATTRIBUTE4    from sap_ar_v)
)
loop
ins_telephone_site( c1.party_site_id,c1.cust_omer , c1.org_id);
ins_contact_site( c1.cust_omer , c1.cust_account_id,c1.cust_acct_site_id , c1.org_id);
end loop;

end;
/

delete sap_errors
where lot = sap_lot 
and table_name ='SAP_AR_CP';

insert into sap_errors (
lot,
org_id,
table_name  ,
cle1    ,
libelle )
select lot,org_id,'SAP_AR_CP' , kunnr , 'Lname trop grand  ( 40 max ) :'|| lname
from sap_ar_cp
where length(lname) > 40
and lot = sap_lot
;


insert into sap_errors (
lot,
org_id,
table_name  ,
cle1    ,
libelle , groupesearch)
select lot,org_id,'SAP_AR_CP' , kunnr , 
     'WARNING Telephone non conforme :'|| tel_no || ' devient ' || REGEXP_REPLACE( replace(replace(tel_no,' ' ,''),'.',''), '[^0-9]+', '')  ,
     'TELEPHONE'
from sap_ar_cp
where lot = sap_lot
and replace(replace(tel_no,' ',''),'.','') !=  REGEXP_REPLACE( replace(replace(tel_no,' ' ,''),'.',''), '[^0-9]+', '')
;

prompt formatage du No de telephone

update sap_ar_cp
set tel_no_transco = REGEXP_REPLACE( replace(replace(tel_no,' ' ,''),'.',''), '[^0-9]+', '')
where lot = sap_lot;


select count(*) from sap_ar_cp;


prompt table  sap_ar_sp;



declare

begin

for c1 in (
select a.org_id_source org_id,
attribute4 kunnr ,
sap_tools_ar.org_id_to_sap_company(a.org_id_attribute5) vkorg,
decode (a.groupe_source ,'ZGR1', '90','10') vtweg,
'01' spart,
max(b.parnr) parnr ,                                                  -- MAX
'DUMMY' parvw,
a.attribute4 kunn2,
a.groupe_source bp_grouping
from sap_ar_v a , sap_ar_cp b
where b.kunnr = a.attribute4
-- and bp_grouping  != 'ZCP1'
and a.lot = sap_lot
and b.lot = sap_lot
group by a.org_id_source ,
attribute4  ,
sap_tools_ar.org_id_to_sap_company(a.org_id_attribute5) ,
decode (a.groupe_source ,'ZGR1', '90','10') ,
'01' ,
'DUMMY' ,
a.attribute4 ,
a.groupe_source

 )
loop

if c1.bp_grouping = 'Z001'
 then
  insert into sap_ar_sp( lot,org_id , KUNNR, VKORG, VTWEG, SPART, PARNR, PARVW, KUNN2) 
          values ( sap_lot,c1.org_id , c1.KUNNR, c1.VKORG, c1.VTWEG, c1.SPART, null, 'DO', c1.KUNN2) ;
  insert into sap_ar_sp( lot,org_id , KUNNR, VKORG, VTWEG, SPART, PARNR, PARVW, KUNN2) 
          values ( sap_lot,c1.org_id , c1.KUNNR, c1.VKORG, c1.VTWEG, c1.SPART, null , 'RC', c1.KUNN2) ;
  insert into sap_ar_sp( lot,org_id , KUNNR, VKORG, VTWEG, SPART, PARNR, PARVW, KUNN2) 
          values ( sap_lot,c1.org_id , c1.KUNNR, c1.VKORG, c1.VTWEG, c1.SPART, null , 'PY', c1.KUNN2) ;
  insert into sap_ar_sp( lot,org_id , KUNNR, VKORG, VTWEG, SPART, PARNR, PARVW, KUNN2) 
          values ( sap_lot,c1.org_id , c1.KUNNR, c1.VKORG, c1.VTWEG, c1.SPART, null , 'DF', c1.KUNN2) ;
 elsif c1.bp_grouping = 'ZGR1'
      then
       insert into sap_ar_sp( lot,org_id , KUNNR, VKORG, VTWEG, SPART, PARNR, PARVW, KUNN2)
          values ( sap_lot,c1.org_id , c1.KUNNR, c1.VKORG, c1.VTWEG, c1.SPART, c1.PARNR, '' , null) ;
      else
       null;
end if;

end loop;

-- Boucle pour les contacts DES BP  Z4
for c1 in (
select a.org_id_source org_id,
attribute4 kunnr ,
sap_tools_ar.org_id_to_sap_company(a.org_id_attribute5) vkorg,
decode (a.groupe_source ,'ZGR1', '90','10') vtweg,
'01' spart,
b.parnr parnr ,                                                  -- MAX
'DUMMY' parvw,
a.attribute4 kunn2,
a.groupe_source bp_grouping
from sap_ar_v a , sap_ar_cp b
where b.kunnr = a.attribute4
-- and bp_grouping  != 'ZCP1'
and a.lot = sap_lot
and b.lot = sap_lot
and b.parnr is not null
group by a.org_id_source ,
attribute4  ,
sap_tools_ar.org_id_to_sap_company(a.org_id_attribute5) ,
decode (a.groupe_source ,'ZGR1', '90','10') ,
'01' ,
b.parnr,
'DUMMY' ,
a.attribute4 ,
a.groupe_source

 )
loop

if c1.bp_grouping = 'Z001'
 then
  insert into sap_ar_sp( lot,org_id , KUNNR, VKORG, VTWEG, SPART, PARNR, PARVW, KUNN2) 
          values ( sap_lot,c1.org_id , c1.KUNNR, c1.VKORG, c1.VTWEG, c1.SPART, c1.PARNR, 'Z4', null) ;
 elsif c1.bp_grouping = 'ZGR1'
      then
       insert into sap_ar_sp( lot,org_id , KUNNR, VKORG, VTWEG, SPART, PARNR, PARVW, KUNN2)
          values ( sap_lot,c1.org_id , c1.KUNNR, c1.VKORG, c1.VTWEG, c1.SPART, c1.PARNR, '' , null) ;
      else
       null;
end if;

end loop;

end;
/


select count(*) from sap_ar_sp;

commit;

select sap_tools_ar.org_id_to_sap_company(org_id ) 
from sap_glob_perimetre 
where lot = sap_lot;

select * from sap_errors
where table_name like 'SAP_AR%'
and lot = sap_lot;

commit;

