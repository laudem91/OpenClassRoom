set pages 0
set lines 255

prompt recherche des objets utilisés par les packages SAP%

spool import_synonym.sq2

 select  distinct 'create or replace synonym SAP.' || referenced_name ||' for APPS.' ||   referenced_name || ';' from ALL_DEPENDENCIES
  where name like 'SAP_T%'
  and REFERENCED_OWNER = 'APPS'
  and referenced_type in ('VIEW','SYNONYM');


spool off
