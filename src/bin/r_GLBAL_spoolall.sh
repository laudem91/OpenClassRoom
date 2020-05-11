
for i in $(cat $SAP_BIN/A_GLBAL_param.txt)
do

a=$(echo $i | cut -d":" -f1)
b=$(echo $i | cut -d":" -f2)
c=$(echo $i | cut -d":" -f3)

FIC=$SAP_OUT/${TWO_TASK}_${LOT}_${ORG_ID}_${a}_${b}.${c}

echo "Creation du fichier $FIC" | tee -a $LOGDATA
echo | tee -a $LOGDATA


$SAP_BIN/r_CC_spoolone.sh $a  $FIC "where" "lot='$LOT'" "and"  "org_id=$ORG_ID"


done


