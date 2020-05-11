create table sap_tr_comptes_gene 
( cpte_source varchar2(80) , 
  cpte_source_desc  varchar2(200) , 
  cpte_cible  varchar2(80) , 
  cpte_cible_desc  varchar2(200) );


create unique index i_sap_tr_comptes_gene_uk1 on sap_tr_comptes_gene ( cpte_source);


