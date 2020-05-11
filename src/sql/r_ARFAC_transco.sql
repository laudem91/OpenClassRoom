prompt  Transcodage de AR

set serveroutput on size 1000000

begin

-- transco au niveau lot et org_id
for c1 in ( select lot , org_id  
            from sap_glob_perimetre
            where lot = '&&1'
            and org_id = &&2
            order by org_id )

loop
sap_artransco.transco_house_bank_arfac(c1.lot , c1.org_id );
sap_artransco.transco_hktid_arfac(c1.lot , c1.org_id );
sap_artransco.transco_code_term_arfac (c1.lot , c1.org_id );
sap_artransco.transco_code_tva_arfac_coi (c1.lot , c1.org_id );
sap_artransco.transco_compte_gene_arfac_ti  (c1.lot , c1.org_id );
sap_artransco.transco_code_tva_arfac_ti (c1.lot , c1.org_id );
sap_artransco.transco_payment_method_coi (c1.lot , c1.org_id );
end loop;


end;
/

commit;
