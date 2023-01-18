function generateMacAddress() {
    #toupper "Mac Address: 00:11:32:$(randomhex):$(randomhex):$(randomhex)"
    if [ "${3}" = "DS923+" ] || [ "${3}" = "DS1522xs+" ] || [ "${3}" = "RS4021xs+" ]; then
        # DS1522xs+ and DS923+ Mac starts with 90:09:d0
        printf '90:09:d0:%02X:%02X:%02X' $((RANDOM % 256)) $((RANDOM % 256)) $((RANDOM % 256))
    else
        printf '00:11:32:%02X:%02X:%02X' $((RANDOM % 256)) $((RANDOM % 256)) $((RANDOM % 256))
    fi    

}

[ "${1}" == "realmac" ] && let keepmac=1 || let keepmac=0

    mac="$(generateMacAddress)"
    realmac=$(ifconfig ${2} | head -1 | awk '{print $NF}')

    #echo "Mac Address = $mac "
    #[ $keepmac -eq 1 ] && echo "Real Mac Address : $realmac"
    #[ $keepmac -eq 1 ] && echo "Notice : realmac option is requested, real mac will be used"

if [ $keepmac -eq 1 ]; then
    macaddress=$(echo $realmac | sed -s 's/://g')
else
    macaddress=$(echo $mac | sed -s 's/://g')
fi

echo "$macaddress"
