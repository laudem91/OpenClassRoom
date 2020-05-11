
#  p1 = LOT   
#  p2 = ORG_ID
#  p3 = periode debut
#  p4 = numero periode debut
#  p5 = periode fin
#  p6 = numero periode fin
#  p7 = compte debut
#  p8 = compte fin


cd $SAP_BIN

export LOGDATA=$SAP_OUT/${TWO_TASK}_$1_$2_$$.log
export ORG_ID=$2
export LOT=$1

echo "Extraction balance de $7 a $8  pour LOT=$LOT ORG_ID=$2 de $3 $4  a $5 $6 et compte de $7 a $8"
echo

echo "Log du traitement :  $LOGDATA"

r_GLBAL_extract.sh $1 $2 $LOGDATA $3 $4 $5 $6 $7 $8

r_GLBAL_spoolall.sh

echo "Extraction balance de $7 a $8  pour LOT=$LOT ORG_ID=$2 de $3 $4  a $5 $6 et compte de $7 a $8"
echo

echo "Log du traitement :  $LOGDATA"




