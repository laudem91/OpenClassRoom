
for i in $(cat $SAP_BIN/A_AR_param.txt)
do

a=$(echo $i | cut -d":" -f1)
b=$(echo $i | cut -d":" -f2)

FIC=$SAP_OUT/${TWO_TASK}_${LOT}_${ORG_ID}_${a}_${b}.csv

echo "Creation du fichier $FIC" | tee -a $LOGDATA
echo | tee -a $LOGDATA


$SAP_BIN/r_CC_spoolone.sh $a  $FIC "where" "lot='$LOT'"


done


