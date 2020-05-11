create table sap_CC_CST
( table_name varchar2(30) ,
  column_name varchar2(30) ,
  valchar varchar2(80),
  valnum  number,
  valdate date );

create unique index i_sap_CC_CST_U1 on sap_CC_CST (table_name , column_name );

