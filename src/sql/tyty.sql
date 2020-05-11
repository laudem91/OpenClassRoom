SELECT
hcasa.org_id,
sap_tools_ar.solde_site ( hcasa.cust_acct_site_id),
sap_tools_ar.derniere_ecriture_site ( hcasa.cust_acct_site_id),
sap_tools_ar.account_number(hcasa.cust_acct_site_id),
sap_tools_ar.bp_grouping_site(hcasa.cust_acct_site_id) , --  decode(hca.attribute3,'GRP','ZGRP','Z001') ,
hcasa.attribute4,
hcasa.attribute5,
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
and hcasa.org_id  in ( select org_id from sap_glob_perimetre whete lot = 'LOT1')
;


