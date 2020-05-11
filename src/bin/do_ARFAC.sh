

#  p1 = LOT 
#  p2 = ORG_ID
#  p3 = date limite extraction  : non utilise


cd $SAP_BIN

export LOGDATA=$SAP_OUT/${TWO_TASK}_$1_$2_$$.log
export LOT=$1
export ORG_ID=$2

echo "Extraction des factures clients pour l'ORG_ID=$1 "
echo

echo "Log du traitement :  $LOGDATA"

r_ARFAC_extract.sh $LOT $ORG_ID $LOGDATA $3

r_ARFAC_spoolall.sh

echo "Extraction des factures clients pour lot=$1  l'ORG_ID=$2 "
echo

echo "Log du traitement :  $LOGDATA"




