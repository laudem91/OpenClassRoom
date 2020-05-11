do_AR.sh LD2 31122016 ALL


for i in $(cat lot2_org.txt)
do

echo $i

do_ARFAC.sh LD2 $i 31122017 

done


for i in $(cat lot2_org.txt)
do

echo $i

do_APFAC.sh LD2 $i 31122017 

done


for i in $(cat lot2_org.txt)
do

echo $i

do_GLBAL.sh LD2 $i 2019 01 2019 99 1 599999999999

done


#do_ARFAC.sh LOT1 189 31122018 
#do_ARFAC.sh LOT1 5726 31122018 
#do_APFAC.sh LOT1 189 31122018 
#do_APFAC.sh LOT1 5726 31122018 
#do_GLBAL.sh LOT1 189 2019 01 2019 99
#do_GLBAL.sh LOT1 5726 2019 01 2019 99




