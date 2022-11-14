
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


###############################################################################
# Validate a serial number for a model
# 1 - Model
# 2 - Serial number to test
# Returns 1 if serial number is valid
function validateSerial() {
  PREFIX=`readModelArray "${1}" "serial.prefix"`
  MIDDLE=`readModelKey "${1}" "serial.middle"`
  S=${2:0:4}
  P=${2:4:3}
  L=${#2}
  if [ ${L} -ne 13 ]; then
    echo 0
    return
  fi
  echo ${PREFIX} | grep -q ${S}
  if [ $? -eq 1 ]; then
    echo 0
    return
  fi
  if [ "${MIDDLE}" != "${P}" ]; then
    echo 0
    return
  fi
  echo 1
}
