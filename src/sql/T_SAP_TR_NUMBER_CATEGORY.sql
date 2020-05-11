create table sap_tr_number_category
( tr_category varchar2(80) , 
  name  varchar2(80) , 
  vat  number );


create unique index i_sap_tr_nu_cat_uk1 on sap_tr_number_category ( upper(tr_category));


