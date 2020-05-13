
prompt remise à niveau de la table HZ_CUST_ACCT_SITES_ALL pour les siret duns attribute4 et attribute5

set serveroutput on size 1000000

declare
old_compte_source varchar2(80);
x number := 0;
tot number:= 0;
begin
for c1 in ( select client,site,soc,siret,duns,cuf4,cuf5 from sap_tr_ar_cuf
            )
loop
 
tot := tot + 1;

update HZ_CUST_ACCT_SITES_ALL
set attribute4=c1.cuf4,
attribute5= c1.cuf5,
attribute3=c1.siret,
attribute12=c1.duns
where org_id = SAP_TOOLS_CC.soc_to_org_id(c1.soc)
and cust_account_id = ( select cust_account_id from hz_cust_accounts where account_number = c1.client) 
and party_site_id = ( select party_site_id from hz_party_sites where party_site_number  = c1.site ) ;
x := x + sql%rowcount;
end loop;

dbms_output.put_line ( x || ' lignes updatées sur ' || tot || ' lignes lues');
end;
/


