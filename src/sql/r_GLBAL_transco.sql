prompt  Transcodage de GLBAL

set serveroutput on size 1000000

begin

-- transco au niveau lot et org_id
for c1 in ( select lot , org_id  
            from sap_glob_perimetre
            where lot = '&1'
            order by org_id )

loop
sap_artransco.transco_compte_gene_glbal(c1.lot , c1.org_id );
end loop;

end;
/

commit;
