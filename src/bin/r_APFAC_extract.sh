
echo "Extraction des données dans les tables temporaires" | tee -a $LOGDATA
echo |tee -a $LOGDATA


sqlplus -s $SAP_CONNECT <<-EOF

spool $3

@$SAP_SQL/r_APFAC_initlot $1 $2

@$SAP_SQL/r_APFAC_insert $1 $2

@$SAP_SQL/r_APFAC_transco $1 $2

spool off

EOF




