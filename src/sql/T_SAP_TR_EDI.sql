create table sap_tr_edi
( edi_source varchar2(80) , 
  edi_cible  varchar2(80) , 
  edi_cible_desc  varchar2(200) );


create unique index i_sap_tr_edi_uk1 on sap_tr_edi ( upper(edi_source));


