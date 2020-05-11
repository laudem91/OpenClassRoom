delete sap_ar_tc;



declare
begin

for c1 in (
select hcasa.org_id org_id,
sap_tools_ar.account_number( hcasa.cust_acct_site_id) kunnr,
(select c.vat_country_code  from hr_operating_units a , gl_sets_of_books b , financials_system_params_all c
where b.set_of_books_id = a.set_of_books_id
and b.SET_OF_BOOKS_ID = c.SET_OF_BOOKS_ID
and organization_id  = &1  ) aland ,
'MWST' tatyp ,
'1' taxkd 
from hz_cust_acct_sites_all hcasa , hz_cust_accounts hca , hz_party_sites hps
where hca.CUST_ACCOUNT_ID = hcasa.CUST_ACCOUNT_ID
and hps.party_site_id = hcasa.party_site_id
and hcasa.org_id = &1
and sap_tools_ar.account_number( hcasa.cust_acct_site_id) in ( select Customer_Number from sap_ar_gd where bp_grouping != 'BPEE' )
)
loop



insert into sap_ar_tc  ( ORG_ID , KUNNR  , ALAND  , TATYP , TAXKD )
values (c1.ORG_ID , c1.KUNNR  , c1.ALAND  , 'FTX1' , '1' ); 

insert into sap_ar_tc  ( ORG_ID , KUNNR  , ALAND  , TATYP , TAXKD )
values (c1.ORG_ID , c1.KUNNR  , c1.ALAND  , 'LCFR' , '0' ); 

end loop;
end;
/

select count(*) from sap_ar_tc;

commit;

