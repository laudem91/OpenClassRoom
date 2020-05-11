
x=$(echo $NLS_LANG | cut -d. -f2)
fin=$(echo $2 | cut -d. -f2)
debut=$(echo $2 | cut -d. -f1)


fic=${debut}_${x}.${fin}

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

select line from  $1
$3
$4
$5
$6
$7
$8
$9
/

spool off

EOF




