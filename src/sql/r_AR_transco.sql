prompt  Transcodage de AR

set serveroutput on size 1000000

begin

sap_artransco.transco_konzs  ( '&1' );

-- transco au niveau lot et org_id
for c1 in ( select lot , org_id  
            from sap_glob_perimetre
            where lot = '&1'
            order by org_id )

loop
sap_artransco.transco_house_bank(c1.lot , c1.org_id );
sap_artransco.transco_compte_gene(c1.lot , c1.org_id );
sap_artransco.transco_agent(c1.lot , c1.org_id );
sap_artransco.transco_edi(c1.lot , c1.org_id );
sap_artransco.transco_code_term_sd_ar  (c1.lot , c1.org_id );
sap_artransco.transco_code_term_cd_ar  (c1.lot , c1.org_id );
sap_artransco.transco_ktgrd  (c1.lot , c1.org_id );
end loop;

end;
/

commit;
