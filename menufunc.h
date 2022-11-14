
###############################################################################
# Get User_config
function getuserconfig() {

    echo "Checking user config for general block"
    MODEL="$(jq -r -e '.general.model' $userconfigfile)"
    SN="$(jq -r -e '.extra_cmdline.sn' $userconfigfile)"
    MACADDR1="$(jq -r -e '.extra_cmdline.mac1' $userconfigfile)"
    MACADDR2="$(jq -r -e '.extra_cmdline.mac2' $userconfigfile)"

}

function checkmachine() {

    if grep -q ^flags.*\ hypervisor\  /proc/cpuinfo; then
        MACHINE="VIRTUAL"
        HYPERVISOR=$(dmesg | grep -i "Hypervisor detected" | awk '{print $5}')
        echo "Machine is $MACHINE Hypervisor=$HYPERVISOR"
    fi

}

function usbidentify() {

    checkmachine

    if [ "$MACHINE" = "VIRTUAL" ] && [ "$HYPERVISOR" = "VMware" ]; then
        echo "Running on VMware, no need to set USB VID and PID, you should SATA shim instead"
        exit 0
    fi

    if [ "$MACHINE" = "VIRTUAL" ] && [ "$HYPERVISOR" = "QEMU" ]; then
        echo "Running on QEMU, If you are using USB shim, VID 0x46f4 and PID 0x0001 should work for you"
        vendorid="0x46f4"
        productid="0x0001"
        echo "Vendor ID : $vendorid Product ID : $productid"

        echo "Should i update the user_config.json with these values ? [Yy/Nn]"
        read answer
        if [ -n "$answer" ] && [ "$answer" = "Y" ] || [ "$answer" = "y" ]; then
            sed -i "/\"pid\": \"/c\    \"pid\": \"$productid\"," user_config.json
            sed -i "/\"vid\": \"/c\    \"vid\": \"$vendorid\"," user_config.json
        else
            echo "OK remember to update manually by editing user_config.json file"
        fi
        exit 0
    fi

    loaderdisk=$(mount | grep -i optional | grep cde | awk -F / '{print $3}' | uniq | cut -c 1-3)

    lsusb -v 2>&1 | grep -B 33 -A 1 SCSI >/tmp/lsusb.out

    usblist=$(grep -B 33 -A 1 SCSI /tmp/lsusb.out)
    vendorid=$(grep -B 33 -A 1 SCSI /tmp/lsusb.out | grep -i idVendor | awk '{print $2}')
    productid=$(grep -B 33 -A 1 SCSI /tmp/lsusb.out | grep -i idProduct | awk '{print $2}')

    if [ $(echo $vendorid | wc -w) -gt 1 ]; then
        echo "Found more than one USB disk devices, please select which one is your loader on"
        usbvendor=$(for item in $vendorid; do grep $item /tmp/lsusb.out | awk '{print $3}'; done)
        select usbdev in $usbvendor; do
            vendorid=$(grep -B 10 -A 10 $usbdev /tmp/lsusb.out | grep idVendor | grep $usbdev | awk '{print $2}')
            productid=$(grep -B 10 -A 10 $usbdev /tmp/lsusb.out | grep -A 1 idVendor | grep idProduct | awk '{print $2}')
            echo "Selected Device : $usbdev , with VendorID: $vendorid and ProductID: $productid"
            break
        done
    else
        usbdevice="$(grep iManufacturer /tmp/lsusb.out | awk '{print $3}') $(grep iProduct /tmp/lsusb.out | awk '{print $3}') SerialNumber: $(grep iSerial /tmp/lsusb.out | awk '{print $3}')"
    fi

    if [ -n "$usbdevice" ] && [ -n "$vendorid" ] && [ -n "$productid" ]; then
        echo "Found $usbdevice"
        echo "Vendor ID : $vendorid Product ID : $productid"

        echo "Should i update the user_config.json with these values ? [Yy/Nn]"
        read answer
        if [ -n "$answer" ] && [ "$answer" = "Y" ] || [ "$answer" = "y" ]; then
            #  sed -i "/\"pid\": \"/c\    \"pid\": \"$productid\"," user_config.json
            json="$(jq --arg var "$productid" '.extra_cmdline.pid = $var' user_config.json)" && echo -E "${json}" | jq . >user_config.json
            #  sed -i "/\"vid\": \"/c\    \"vid\": \"$vendorid\"," user_config.json
            json="$(jq --arg var "$vendorid" '.extra_cmdline.vid = $var' user_config.json)" && echo -E "${json}" | jq . >user_config.json
        else
            echo "OK remember to update manually by editing user_config.json file"
        fi
    else
        echo "Sorry, no usb disk could be identified"
        rm /tmp/lsusb.out
    fi
}

function serialgen() {

    [ ! -z "$GATEWAY_INTERFACE" ] && shift 0 || shift 1

    if [ "$1" = "DS3615xs" ] || [ "$1" = "DS3617xs" ] || [ "$1" = "DS916+" ] || [ "$1" = "DS918+" ] || [ "$1" = "DS1019+" ] || [ "$1" = "DS920+" ] || [ "$1" = "DS3622xs+" ] || [ "$1" = "FS6400" ] || [ "$1" = "DVA3219" ] || [ "$1" = "DVA3221" ] || [ "$1" = "DS1621+" ] || [ "$1" = "DS1621xs+" ] || [ "$1" = "RS4021xs+" ] || [ "$1" = "DS2422+" ] || [ "$1" = "DS1520+" ] || [ "$1" = "FS2500" ] || [ "$1" = "RS3618xs" ] || [ "$1" = "RS3413xs+" ] ; then
        serial="$(generateSerial $1)"
        echo "Serial Number for Model = $serial"

        if [ -z "$GATEWAY_INTERFACE" ]; then
            echo "Should i update the user_config.json with these values ? [Yy/Nn]"
            read answer
        else
            answer="y"
        fi

        if [ -n "$answer" ] && [ "$answer" = "Y" ] || [ "$answer" = "y" ]; then
            json="$(jq --arg var "$serial" '.extra_cmdline.sn = $var' user_config.json)" && echo -E "${json}" | jq . >user_config.json
            echo "$serial"
        else
            echo "OK remember to update manually by editing user_config.json file"
        fi
    else
        echo "Error : $1 is not an available model for serial number generation. "
        echo "Available Models : DS3615xs DS3617xs DS916+ DS918+ DS1019+ DS920+ DS3622xs+ FS6400 DVA3219 DVA3221 DS1621+ DS1621xs+ RS4021xs+ DS2422+ DS1520+ FS2500 RS3618xs RS3413xs+"
    fi

    if [ ! -z $2 ]; then
        macgen $2
    fi

}

function macgen() {

    [ ! -z "$GATEWAY_INTERFACE" ] && shift 0 || shift 1

    [ "$1" == "realmac" ] && let keepmac=1 || let keepmac=0

        mac="$(generateMacAddress)"
        realmac=$(ifconfig eth0 | head -1 | awk '{print $NF}')

        echo "Mac Address = $mac "
        [ $keepmac -eq 1 ] && echo "Real Mac Address : $realmac"
        [ $keepmac -eq 1 ] && echo "Notice : realmac option is requested, real mac will be used"

        if [ -z "$GATEWAY_INTERFACE" ]; then
            echo "Should i update the user_config.json with these values ? [Yy/Nn]"
            read answer
        else
            answer="y"
        fi

        if [ -n "$answer" ] && [ "$answer" = "Y" ] || [ "$answer" = "y" ]; then

            if [ $keepmac -eq 1 ]; then
                macaddress=$(echo $realmac | sed -s 's/://g')
            else
                macaddress=$(echo $mac | sed -s 's/://g')
            fi

            json="$(jq --arg var "$macaddress" '.extra_cmdline.mac1 = $var' user_config.json)" && echo -E "${json}" | jq . >user_config.json
            echo "$macaddress"
        else
            echo "OK remember to update manually by editing user_config.json file"
        fi

}


function beginArray() {

    case $1 in
    DS3615xs)
        permanent="LWN"
        serialstart="1130 1230 1330 1430"
        ;;
    DS3617xs)
        permanent="ODN"
        serialstart="1130 1230 1330 1430"
        ;;
    DS916+)
        permanent="NZN"
        serialstart="1130 1230 1330 1430"
        ;;
    DS918+)
        permanent="PDN"
        serialstart="1780 1790 1860 1980"
        ;;
    DS1019+)
        permanent="PDN"
        serialstart="1780 1790 1860 1980"
        ;;
    DS920+)
        permanent="SBR"
        serialstart="2030 2040 20C0 2150"
        ;;
    DS1520+)
        permanent="SBR"
        serialstart="2030 2040 20C0 2150"
        ;;    
    DS3622xs+)
        permanent="SQR"
        serialstart="2030 2040 20C0 2150"
        ;;
    DS1621xs+)
        permanent="S7R"
        serialstart="2080"
        ;;
    RS4021xs+)
        permanent="S7R"
        serialstart="2080"
        ;;
    DS1621+)
        permanent="S7R"
        serialstart="2080"
        ;;
    DS2422+)
        permanent="S7R"
        serialstart="2080"
        ;;
    FS2500)
        permanent="PSN"
        serialstart="1960"
        ;;
    FS6400)
        permanent="PSN"
        serialstart="1960"
        ;;
    DVA3219)
        permanent="RFR"
        serialstart="1930 1940"
        ;;
    DVA3221)
        permanent="SJR"
        serialstart="2030 2040 20C0 2150"
        ;;
    RS3618xs)
        permanent="ODN"
        serialstart="1130 1230 1330 1430"
        ;;
    RS3413xs+)
        permanent="S7R"
        serialstart="2080"
        ;;
    esac

}

function random() {

    printf "%06d" $(($RANDOM % 30000 + 1))

}
function randomhex() {
    val=$(($RANDOM % 255 + 1))
    echo "obase=16; $val" | bc
}

function generateRandomLetter() {
    for i in a b c d e f g h j k l m n p q r s t v w x y z; do
        echo $i
    done | sort -R | tail -1
}

function generateRandomValue() {
    for i in 0 1 2 3 4 5 6 7 8 9 a b c d e f g h j k l m n p q r s t v w x y z; do
        echo $i
    done | sort -R | tail -1
}

function toupper() {
    echo $1 | tr '[:lower:]' '[:upper:]'
}

function generateMacAddress() {
    #toupper "Mac Address: 00:11:32:$(randomhex):$(randomhex):$(randomhex)"
    printf '00:11:32:%02X:%02X:%02X' $((RANDOM % 256)) $((RANDOM % 256)) $((RANDOM % 256))

}

function generateSerial() {

    beginArray $1

    case $1 in

    DS3615xs)
        serialnum="$(echo "$serialstart" | tr ' ' '\n' | sort -R | tail -1)$permanent"$(random)
        ;;
    DS3617xs)
        serialnum="$(echo "$serialstart" | tr ' ' '\n' | sort -R | tail -1)$permanent"$(random)
        ;;
    DS916+)
        serialnum="$(echo "$serialstart" | tr ' ' '\n' | sort -R | tail -1)$permanent"$(random)
        ;;
    DS918+)
        serialnum="$(echo "$serialstart" | tr ' ' '\n' | sort -R | tail -1)$permanent"$(random)
        ;;
    DS1019+)
        serialnum="$(echo "$serialstart" | tr ' ' '\n' | sort -R | tail -1)$permanent"$(random)
        ;;
    FS2500)
        serialnum="$(echo "$serialstart" | tr ' ' '\n' | sort -R | tail -1)$permanent"$(random)
        ;;
    FS6400)
        serialnum="$(echo "$serialstart" | tr ' ' '\n' | sort -R | tail -1)$permanent"$(random)
        ;;
    DS920+)
        serialnum=$(toupper "$(echo "$serialstart" | tr ' ' '\n' | sort -R | tail -1)$permanent"$(generateRandomLetter)$(generateRandomValue)$(generateRandomValue)$(generateRandomValue)$(generateRandomValue)$(generateRandomLetter))
        ;;
    DS1520+)
        serialnum=$(toupper "$(echo "$serialstart" | tr ' ' '\n' | sort -R | tail -1)$permanent"$(generateRandomLetter)$(generateRandomValue)$(generateRandomValue)$(generateRandomValue)$(generateRandomValue)$(generateRandomLetter))
        ;;
    DS3622xs+)
        serialnum=$(toupper "$(echo "$serialstart" | tr ' ' '\n' | sort -R | tail -1)$permanent"$(generateRandomLetter)$(generateRandomValue)$(generateRandomValue)$(generateRandomValue)$(generateRandomValue)$(generateRandomLetter))
        ;;
    DS1621xs+)
        serialnum=$(toupper "$(echo "$serialstart" | tr ' ' '\n' | sort -R | tail -1)$permanent"$(generateRandomLetter)$(generateRandomValue)$(generateRandomValue)$(generateRandomValue)$(generateRandomValue)$(generateRandomLetter))
        ;;
    RS4021xs+)
        serialnum=$(toupper "$(echo "$serialstart" | tr ' ' '\n' | sort -R | tail -1)$permanent"$(generateRandomLetter)$(generateRandomValue)$(generateRandomValue)$(generateRandomValue)$(generateRandomValue)$(generateRandomLetter))
        ;;
    DS1621+)
        serialnum=$(toupper "$(echo "$serialstart" | tr ' ' '\n' | sort -R | tail -1)$permanent"$(generateRandomLetter)$(generateRandomValue)$(generateRandomValue)$(generateRandomValue)$(generateRandomValue)$(generateRandomLetter))
        ;;
    DS2422+)
        serialnum=$(toupper "$(echo "$serialstart" | tr ' ' '\n' | sort -R | tail -1)$permanent"$(generateRandomLetter)$(generateRandomValue)$(generateRandomValue)$(generateRandomValue)$(generateRandomValue)$(generateRandomLetter))
        ;;
    DVA3219)
        serialnum=$(toupper "$(echo "$serialstart" | tr ' ' '\n' | sort -R | tail -1)$permanent"$(generateRandomLetter)$(generateRandomValue)$(generateRandomValue)$(generateRandomValue)$(generateRandomValue)$(generateRandomLetter))
        ;;
    DVA3221)
        serialnum=$(toupper "$(echo "$serialstart" | tr ' ' '\n' | sort -R | tail -1)$permanent"$(generateRandomLetter)$(generateRandomValue)$(generateRandomValue)$(generateRandomValue)$(generateRandomValue)$(generateRandomLetter))
        ;;
    RS3618xs)
        serialnum="$(echo "$serialstart" | tr ' ' '\n' | sort -R | tail -1)$permanent"$(random)
        ;;
    RS3413xs+)
        serialnum=$(toupper "$(echo "$serialstart" | tr ' ' '\n' | sort -R | tail -1)$permanent"$(generateRandomLetter)$(generateRandomValue)$(generateRandomValue)$(generateRandomValue)$(generateRandomValue)$(generateRandomLetter))
        ;;
    esac

    echo $serialnum

}
