
cd $SAP_HOME

echo "Sauvegarde des repertoires bin et sql de $SAP_HOME"


x=$(date +%Y%m%d-%H%M%S)

nom=SAP-${x}.tar

cd $SAP_HOME

tar -cvf $SAP_HOME/${nom} bin sql tools data

tar -tvf $SAP_HOME/${nom} 


echo
echo
echo "Sauvegarde de $SAP_HOME bin , tolls , data et sql"
echo "dans $nom sous $SAP_HOME"
