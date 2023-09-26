for model in `cat models`
do 
echo "modify custom_config.json on $model"
value=`grep $model ./kernel-bs-fb-patch-for-all/files-chksum | grep os.sha256|awk '{print $1}'`
id=$(echo "$model" | sed 's/DS/ds/' | sed 's/RS/rs/' | sed 's/+/p/' | sed 's/DVA/dva/' | sed 's/FS/fs/' | sed 's/SA/sa/' )"-7.2.1-69057"
echo "id = $id"

jsonfile=$(jq --arg id "$id" --arg value "$value" '
  .build_configs |= map(
    if (.id == $id) then
      .downloads.os |= (
        if has("sha256") then
          .sha256 = $value
        else
          . + { "sha256": $value }
        end
      )
    else
      .
    end
  )
' ./custom_config.json)

echo $jsonfile | jq . > ./custom_config.json

done 
