prompt  Transcodage de APFAC

set serveroutput on size 1000000

begin

-- transco au niveau lot et org_id
for c1 in ( select lot , org_id  
            from sap_glob_perimetre
            where lot = '&1'
            and org_id = &&2
            order by org_id )

loop
null;

sap_apfactransco.transco_code_tva_apfac_voi(c1.lot , c1.org_id );
sap_apfactransco.transco_code_term_apfac_voi(c1.lot , c1.org_id );
sap_apfactransco.transco_pay_method_apfac_voi(c1.lot , c1.org_id );
sap_apfactransco.transco_house_bank_apfac(c1.lot , c1.org_id );
sap_apfactransco.transco_hktid_apfac(c1.lot , c1.org_id );
sap_apfactransco.transco_compte_gene_apfac_ti(c1.lot , c1.org_id );
sap_apfactransco.transco_code_tva_apfac_ti(c1.lot , c1.org_id );
end loop;

end;
/

commit;


