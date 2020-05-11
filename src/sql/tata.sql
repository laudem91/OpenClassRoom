delete sap_ar_sd;


insert into SAP_AR_SD ( 
org_id,
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
select org_id ,
a.customer_number  ,  -- KUNNR
sap_tools_ar.org_id_to_sap_company( a.org_id) , -- VKORG
decode (a.bp_grouping ,'GRP', '90','10'),  -- VTWEG
'01' , --SPART
(select b.CURRENCY_CODE from hr_operating_units a , gl_sets_of_books b
where b.set_of_books_id = a.set_of_books_id
and organization_id = &1) ,  -- WAERS
'1' , -- KALKS
'01' , -- VSBED
sap_tools_ar.org_id_to_sap_company( a.org_id) ,  -- VWERK
'X' ,  -- BOKRE
'X' ,  -- PRFRE
'ZTERM',
'KTGRD',
(select attribute20 from hz_cust_acct_sites_all  b
 where b.cust_acct_site_id = a.cust_acct_site_id )   --- KVGR1
from sap_ar_gd a
where org_id = &1
and bp_grouping != 'BPEE'
;

