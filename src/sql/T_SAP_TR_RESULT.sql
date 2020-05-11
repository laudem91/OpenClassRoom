drop table SAP_TR_RESULT;


create table SAP_TR_RESULT
( 
  table_name varchar2(30) not null ,
  pk1_origine varchar2(200) not null  ,
  pk1_description varchar2(200),
  pk2_origine varchar2(200) ,
  pk2_description varchar2(200),
  column_name varchar2(30) not null ,
  column_value varchar2(200),
  column_value_transco varchar2(200) ,
  commentaire varchar2(200),
  type_error varchar2(200) not null  ,
  lot varchar2(30) ,
  org_id number,
  datec date
 );

CREATE OR REPLACE  TRIGGER SAP_TR_RESULT_INS
BEFORE INSERT
   ON SAP_TR_RESULT
    FOR EACH ROW 

DECLARE
   -- variable declarations

BEGIN
:new.DATEC := sysdate;
END;
/



