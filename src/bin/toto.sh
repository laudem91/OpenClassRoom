
set -x

for i in $(cat $SAP_BIN/A_AR_param.txt)
do

a=$(echo $i | cut -d":" -f1)
b=$(echo $i | cut -d":" -f2)

done


