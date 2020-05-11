


prompt remise à niveau de la table SAP_TR_COMPTES_GENE_MULTI

set serveroutput on size 1000000

declare
old_compte_source varchar2(80);
begin
for c1 in ( select rowid monrowid , cpte_source , cpte_cible from sap_tr_comptes_gene_multi
            order by noline)
loop

if c1.cpte_source is null
then
update sap_tr_comptes_gene_multi
set cpte_source = old_compte_source
where rowid = c1.monrowid;
dbms_output.put_line('Remise a niveau de '|| old_compte_source || ' vers ' || c1.cpte_cible);
else
old_compte_source := c1.cpte_source;
end if;
end loop;
end;
/


prompt Flagage du compte defaut si plusieurs fois le meme compte

declare
begin
for c1 in ( SELECT cpte_source , CPTE_CIBLE , noline
    ,DENSE_RANK() OVER   
    (PARTITION BY cpte_source ORDER BY noline) AS Rank  
FROM sap_tr_comptes_gene_multi)
loop
update sap_tr_comptes_gene_multi
set ordre = c1.rank
where noline = c1.noline;

end loop;
end;
/

prompt passage de compte_gene_multi vers compte_gene

delete sap_tr_comptes_gene;

insert into sap_tr_comptes_gene ( cpte_source , CPTE_SOURCE_DESC , cpte_cible , cpte_cible_desc)
select cpte_source , CPTE_SOURCE_DESC , cpte_cible , cpte_cible_desc
from sap_tr_comptes_gene_multi
where ordre = 1;









commit;
