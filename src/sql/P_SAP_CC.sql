create or replace function SAP_LOT return varchar2
as
x varchar2(200);
x1 varchar2(200);
begin
DBMS_APPLICATION_INFO.READ_CLIENT_INFO ( x );
select substr(x,1,instr(x,':') -1 ) 
into x1
from dual;
return x1;
end;
/

create or replace function SAP_ORG_ID return number
as
x varchar2(200);
x1 varchar2(200);
begin
DBMS_APPLICATION_INFO.READ_CLIENT_INFO ( x );
select substr(x,instr(x,':') +1 ) 
into x1
from dual;
return to_number(x1);
end;
/


create or replace package SAP_TOOLS_CC
as

function cst(  p_table in varchar2,p_column in varchar2) return varchar2;

function soc_to_org_id ( p_soc in varchar2) return number;

end SAP_TOOLS_CC;
/

show error


create or replace package body SAP_TOOLS_CC
as


function soc_to_org_id ( p_soc in varchar2 ) return number
is
x number;
begin
select organization_id 
into x
from HR_OPERATING_UNITS
where substr(name,7,3) = p_soc;

return x;

end;


function cst(   p_cst in varchar2) return varchar2
is
begin

return 'CST';

end;

function cst(  p_table in varchar2,p_column in varchar2) return varchar2
is
cur SAP_CC_CST%rowtype;
retour varchar2(80);
begin

begin
select * 
into cur
from sap_cc_cst
where table_name = upper(p_table)
and column_name = upper(p_column);

if cur.valchar is not null then retour := cur.valchar;
 elsif cur.valnum is not null then retour := to_char(cur.valnum);
   elsif cur.valdate is not null then retour := to_char(cur.valdate) ;
     else retour := 'CST null';
end if;

exception
when no_data_found then retour:='CST INCONNU';
end;

return retour;
end;

end SAP_TOOLS_CC;
/


show error

