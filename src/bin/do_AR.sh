

# les parametres

#  1 = LOT
#  2 = Date de derniere ecriture
#  3 = ZGR1 NOZGR1 ALL

cd $SAP_BIN


export LOT=$1
export LOGDATA=$SAP_OUT/${TWO_TASK}_${LOT}_$$.log

export ORG_ID=$LOT

echo "Extraction des données clients pour le lot =$1 et date de derniere ecriture >= $2  filtre=$3"
echo

echo "Log du traitement :  $LOGDATA"

r_AR_extract.sh $LOT $LOGDATA $2 $3

r_AR_spoolall.sh 

echo "Extraction des données clients pour le lot =$1 et date de derniere ecriture >= $2  filtre=$3"
echo

echo "Log du traitement :  $LOGDATA"




