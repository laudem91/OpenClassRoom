create table sap_tr_house_bank
( company_code varchar2(80) , 
  module_oap varchar2(80),
  house_bank  varchar2(80) 
 );


create unique index i_sap_tr_house_bank_uk1 on sap_tr_house_bank ( company_code,module_oap);


