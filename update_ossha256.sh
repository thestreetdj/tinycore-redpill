for model in `cat models`
do 
echo "modify custom_config.json on $model"
value=`grep $model ./kernel-bs-fb-patch-for-all/files-chksum | grep os.sha256|awk '{print $1}'`
id=$(echo "$model" | sed 's/DS/ds/' | sed 's/RS/rs/' | sed 's/+/p/' | sed 's/DVA/dva/' | sed 's/FS/fs/' | sed 's/SA/sa/' "-7.2.0-64570")
echo "id = $id"
done 
