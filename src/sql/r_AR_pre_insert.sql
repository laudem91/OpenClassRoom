

prompt Initialisation de la table SAP_AR


delete sap_ar;

insert into sap_ar
(
LOT                                   ,
 ORG_ID_SOURCE                        ,
 PARTY_ID_SOURCE                      ,
 PARTY_SITE_ID_SOURCE                 ,
 CUST_ACCOUNT_ID_SOURCE               ,
 CUST_ACCT_SITE_ID_SOURCE             ,
 ACCOUNT_NUMBER_SOURCE                ,
 SOLDE_SOURCE                         ,
 DERNIERE_ECRITURE_SITE_SOURCE        ,
 SITE_A_DESACTIVER                      ,
 SITE_FACTURATION                     ,
 GROUPE_SOURCE                        ,
 ATTRIBUTE4                           ,
 ORG_ID_ATTRIBUTE4                    ,
 PARTY_ID_ATTRIBUTE4                  ,
 PARTY_SITE_ID_ATTRIBUTE4             ,
 CUST_ACCOUNT_ID_ATTRIBUTE4           ,
 CUST_ACCT_SITE_ID_ATTRIBUTE4         ,
 ATTRIBUTE5                           ,
 ORG_ID_ATTRIBUTE5                    ,
 PARTY_ID_ATTRIBUTE5                  ,
 PARTY_SITE_ID_ATTRIBUTE5             ,
 CUST_ACCOUNT_ID_ATTRIBUTE5           ,
 CUST_ACCT_SITE_ID_ATTRIBUTE5         )
SELECT
'&1',
hcasa.org_id  org_id_source,
hp.party_id   party_id_source,
hps.party_site_id party_site_id_source,
hca.cust_account_id  cust_account_id_source,
hcasa.cust_acct_site_id cust_acct_site_id_source,
sap_tools_ar.account_number(hcasa.cust_acct_site_id) account_number_source,
sap_tools_ar.solde_site ( hcasa.cust_acct_site_id) solde_source,
sap_tools_ar.derniere_ecriture_site ( hcasa.cust_acct_site_id) derniere_ecriture_site_source,
sap_tools_ar.site_a_desactiver  (hcasa.cust_acct_site_id),
sap_tools_ar.bill_to  (hcasa.cust_acct_site_id),
-- sap_tools_ar.cle_comptable_site  (hcasa.cust_acct_site_id),
sap_tools_ar.bp_grouping_site(hcasa.cust_acct_site_id) groupe_source , --  decode(hca.attribute3,'GRP','ZGR1','Z001') ,
hcasa.attribute4 attribute4,
sap_tools_ar.decompose_org_id (hcasa.attribute4) org_id_attribute4, 
sap_tools_ar.decompose_party_id (hcasa.attribute4) party_id_attribute4,
sap_tools_ar.decompose_party_site_id (hcasa.attribute4) party_site_id_attribute4,
sap_tools_ar.decompose_cust_account_id (hcasa.attribute4 ) cust_account_id_attribute4,
sap_tools_ar.decompose_cust_acct_site_id (hcasa.attribute4 ) cust_acct_site_id_attribute4,
hcasa.attribute5 attribute5,
sap_tools_ar.decompose_org_id (hcasa.attribute5,hcasa.org_id) org_id_attribute5, 
sap_tools_ar.decompose_party_id (hcasa.attribute5,hcasa.org_id) party_id_attribute5,
sap_tools_ar.decompose_party_site_id (hcasa.attribute5,hcasa.org_id) party_site_id_attribute5,
sap_tools_ar.decompose_cust_account_id (hcasa.attribute5,hcasa.org_id ) cust_account_id_attribute5,
sap_tools_ar.decompose_cust_acct_site_id (hcasa.attribute5,hcasa.org_id ) cust_acct_site_id_attribute5
FROM apps.HZ_PARTIES hp,
  apps.hz_party_sites hps,
  apps.HZ_CUST_ACCOUNTS hca,
  apps.hz_cust_acct_sites_all hcasa,
  hz_locations loc
WHERE 1=1
and hp.party_id = hca.party_id
and hca.cust_account_id = hcasa.cust_account_id
and hps.party_site_id = hcasa.party_site_id
AND hps.LOCATION_ID   = loc.LOCATION_ID
and hcasa.org_id  in ( select org_id from sap_glob_perimetre where lot = '&1')
;


update sap_ar
set eligible = 'N';


update sap_ar
set eligible = 'Y'
where ( ( solde_source != 0) 
        or
      (derniere_ecriture_site_source >= to_date('&2','DD/MM/YYYY') and site_facturation='Y' and nvl(site_a_desactiver,'N') = 'N' )
     )
;

prompt ne garder que ZGR1 ou pas
update sap_ar
set eligible = decode ( '&3','ALL',eligible , 'N')
where 
 -- ( 
      -- ( groupe_source != 'ZGR1' and nvl('&3','x') = 'ZGR1')     -- filtre sur le groupe
                                               -- or
      -- ( groupe_source = 'ZGR1' and nvl('&3','x') != 'ZGR1')     -- filtre sur le groupe
    -- )
      not 
          (
            ( groupe_source = 'ZGR1' and nvl('&3','x') = 'ZGR1')     -- filtre sur le groupe
                            or
            ( groupe_source != 'ZGR1' and nvl('&3','x') = 'NOZGR1')     -- filtre sur le groupe
                            or
            (  nvl('&3','x') = 'ALL')     -- filtre sur le groupe
          )
;


-- update sap_ar
-- set eligible ='O'
-- where eligible = 'N'
-- and account_number_source in ( select attribute4 from sap_ar
                        -- where  eligible ='Y')
-- /






















commit;
