#!/bin/bash

#   parametres

#    1     Fichier  sans le .ctl
#    2     fichier de data


# export NLS_LANG=American_America.UTF8

do_sql ()
{

sqlplus -s $SAP_CONNECT <<-EOF

@${1}

EOF


}

datafilename=$SAP_DATA/$2
ctlfilename=$SAP_BIN/A_$1
logfilename=$SAP_LOG/$2.log
badlogname=$SAP_LOG/$2.bad

if [ -f $datafilename ]
then
    echo "Le fichier existe"
else
    echo "Le fichier n'existe pas"
    exit 9
fi

if [ $# = 0 ]
then
    echo "Il n'y a pas de paramètres"
fi


rm -f $badlogname
rm -f $logfilename

sqlldr $SAP_CONNECT control=$ctlfilename data=$datafilename errors=1000 log=$logfilename bad=$badlogname

result=$?


cat $logfilename

if [[ $result -eq 0 ]] 
then
echo ''

filerun=$SAP_SQL/r_$1.sql

if [ -f $filerun ]
then
do_sql $filerun
fi



else
echo 'Data load failed..'
fi

if [ -f $badlogname ]
then
    echo "Le fichier $badlogname  existe"
    echo 'Data load failed...'
    exit 8
fi

exit $result

