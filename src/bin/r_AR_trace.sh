echo "Creation du fichier des traces " | tee -a $LOGDATA
echo | tee -a $LOGDATA


x=$(echo $NLS_LANG | cut -d. -f2)

fic=$SAP_OUT/${TWO_TASK}_${LOT}_${ORG_ID}_SAP_ERRORS_${x}.csv

echo "Creation du fichier des traces $fic " | tee -a $LOGDATA

sqlplus -s $SAP_CONNECT <<-EOF

set lines 3000
set trim on
set trims on
set echo off
set termout off
set feedback off
set pages 0
set verify off
spool ${fic}

select 'lot' ||';' ||  'org_id' ||';' || 'TABLE_NAME' ||';' || 'CLE1' ||';' || 'LIBELLE' ||';' || 'GROUPESEARCH' ||';' || 'DATEC' ||';' from dual;
select '"' || lot ||'";"' ||  org_id ||'";"' || TABLE_NAME ||'";="' || CLE1 ||'";"' || LIBELLE ||'";"' || GROUPESEARCH ||'";"' || DATEC ||'";' from sap_errors 
where lot = '$1';

spool off

EOF


fic=$SAP_OUT/${TWO_TASK}_${LOT}_${ORG_ID}_SAP_TR_RESULT_${x}.csv
echo "Creation du fichier des traces $fic " | tee -a $LOGDATA

sqlplus -s $SAP_CONNECT <<-EOF

set lines 3000
set trim on
set trims on
set echo off
set termout off
set feedback off
set pages 0
set verify off
spool ${fic}

select 
 '"' || 'TABLE_NAME'   || '";"' ||
 'PK1_ORIGINE'    || '";"' ||
 'PK1_DESCRIPTION'    || '";"' ||
 'PK2_ORIGINE'           || '";"' ||
 'PK2_DESCRIPTION'          || '";"' ||
 'COLUMN_NAME'       || '";"' ||
 'COLUMN_VALUE'         || '";"' ||
 'COLUMN_VALUE_TRANSCO'    || '";"' ||
 'COMMENTAIRE'       || '";"' ||
 'TYPE_ERROR'        || '";"' ||
 'LOT'              || '";"' ||
 'ORG_ID'           || '";"' ||
 'DATEC' || '";'        
 from dual ;
select 
 '="' || TABLE_NAME   || '";="' ||
 PK1_ORIGINE    || '";="' ||
 PK1_DESCRIPTION    || '";="' ||
 PK2_ORIGINE           || '";="' ||
 PK2_DESCRIPTION          || '";="' ||
 COLUMN_NAME       || '";="' ||
 COLUMN_VALUE         || '";="' ||
 COLUMN_VALUE_TRANSCO    || '";="' ||
 COMMENTAIRE       || '";="' ||
 TYPE_ERROR        || '";="' ||
 LOT              || '";="' ||
 ORG_ID           || '";="' ||
 DATEC || '";'        
 from sap_tr_result 
where lot = '$1'
/

spool off

EOF


fic=$SAP_OUT/${TWO_TASK}_${LOT}_${ORG_ID}_SAP_TR_RESULT_ERROR_${x}.csv
echo "Creation du fichier des traces $fic " | tee -a $LOGDATA

sqlplus -s $SAP_CONNECT <<-EOF

set lines 3000
set trim on
set trims on
set echo off
set termout off
set feedback off
set pages 0
set verify off
spool ${fic}
select '"' || 'table_name' || '";"' ||  'column_name' || '";="' || 'column_value' || '";="' || 'column_value_transco' || '";"' || 'Nbre' || '";'    from dual;
select table_name || '";"' ||  column_name || '";="' || column_value || '";="' || column_value_transco || '";"' || count(*)  from sap_tr_result
where lot = '$1'
and TYPE_ERROR = 'ERROR'
group by table_name , column_name , column_value , column_value_transco 
order by column_name,table_name;

spool off

EOF



