

#  parametre

#  1 : lot
#  2 : spool sql
#  3 : date extraction
#  4 : ZGR1 ALL ou AUTRE

echo "Extraction des données dans les tables temporaires" | tee -a $LOGDATA
echo |tee -a $LOGDATA


sqlplus -s $SAP_CONNECT <<-EOF

spool $2


execute DBMS_APPLICATION_INFO.SET_CLIENT_INFO ('$1:189');

@$SAP_SQL/r_AR_initlot $1

@$SAP_SQL/r_AR_pre_insert $1 $3 $4

@$SAP_SQL/r_AR_insert $1 

@$SAP_SQL/r_AR_transco $1  

-- execute DBMS_APPLICATION_INFO.SET_CLIENT_INFO ('$1:5726');

-- @$SAP_SQL/r_AR_insert 5726 $3 $4

spool off

EOF




