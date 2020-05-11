delete sap_ar_sp;


declare

begin

for c1 in (
select a.org_id org_id,
customer_number kunnr ,
sap_tools_ar.org_id_to_sap_company(a.org_id) vkorg,
decode (a.bp_grouping ,'GRP', '90','10') vtweg,
'01' spart,
b.parnr parnr ,
'DUMMY' parvw,
a.customer_number kunn2,
a.bp_grouping bp_grouping
from sap_ar_gd a , sap_ar_cp b
where b.kunnr = a.CUSTOMER_NUMBER
and bp_grouping  != 'BPEE'
and a.org_id = &1)
loop

if c1.bp_grouping = 'Z001'
 then
  insert into sap_ar_sp( org_id , KUNNR, VKORG, VTWEG, SPART, PARNR, PARVW, KUNN2) 
          values ( c1.org_id , c1.KUNNR, c1.VKORG, c1.VTWEG, c1.SPART, c1.PARNR, 'DO', c1.KUNN2) ;
  insert into sap_ar_sp( org_id , KUNNR, VKORG, VTWEG, SPART, PARNR, PARVW, KUNN2) 
          values ( c1.org_id , c1.KUNNR, c1.VKORG, c1.VTWEG, c1.SPART, c1.PARNR, 'RC', c1.KUNN2) ;
  insert into sap_ar_sp( org_id , KUNNR, VKORG, VTWEG, SPART, PARNR, PARVW, KUNN2) 
          values ( c1.org_id , c1.KUNNR, c1.VKORG, c1.VTWEG, c1.SPART, c1.PARNR, 'PY', c1.KUNN2) ;
  insert into sap_ar_sp( org_id , KUNNR, VKORG, VTWEG, SPART, PARNR, PARVW, KUNN2) 
          values ( c1.org_id , c1.KUNNR, c1.VKORG, c1.VTWEG, c1.SPART, c1.PARNR, 'DF', null) ;
 elsif c1.bp_grouping = 'ZGRP'
      then
       insert into sap_ar_sp( org_id , KUNNR, VKORG, VTWEG, SPART, PARNR, PARVW, KUNN2)
          values ( c1.org_id , c1.KUNNR, c1.VKORG, c1.VTWEG, c1.SPART, c1.PARNR, null , null) ;
      else
       null;
end if;

end loop;

end;
/

commit;

