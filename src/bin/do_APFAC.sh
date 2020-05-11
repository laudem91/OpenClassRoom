

#  p1 = LOT
#  p2 = ORG_ID
#  p3 = date limite extraction  : non utilise

cd $SAP_BIN

export LOGDATA=$SAP_OUT/${TWO_TASK}_$1_$2_$$.log
export ORG_ID=$2
export LOT=$1

echo "Extraction des Facture fournisseurs pour l'ORG_ID=$2 "
echo

echo "Log du traitement :  $LOGDATA"

r_APFAC_extract.sh $1 $2 $LOGDATA $3

r_APFAC_spoolall.sh

echo "Extraction des Facture fournisseurs pour LOT=$LOT ORG_ID=$2 "
echo

echo "Log du traitement :  $LOGDATA"




