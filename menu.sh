#!/usr/bin/env bash

##### INCLUDES #####################################################################################################
source /home/tc/menufunc.h
#####################################################################################################

[[ "$(which dialog)_" == "_" ]] && tce-load -wi dialog

# Get actual IP
IP="$(ifconfig | grep -i "inet " | grep -v "127.0.0.1" | awk '{print $2}')"

USER_CONFIG_FILE="/home/tc/user_config.json"
TMP_PATH=/tmp
MODEL="$(jq -r -e '.general.model' $USER_CONFIG_FILE)"
BUILD="42962"
SN="$(jq -r -e '.extra_cmdline.sn' $USER_CONFIG_FILE)"
MACADDR1="$(jq -r -e '.extra_cmdline.mac1' $USER_CONFIG_FILE)"

###############################################################################
# Write to json config file
function writeConfigKey() {

    block="$1"
    field="$2"
    value="$3"

    if [ -n "$1 " ] && [ -n "$2" ]; then
        jsonfile=$(jq ".$block+={\"$field\":\"$value\"}" $USER_CONFIG_FILE)
        echo $jsonfile | jq . >$USER_CONFIG_FILE
    else
        echo "No values to update"
    fi

}

###############################################################################
# Read key value from json config file
# 1 - Path of key
# Return Value
function readConfigKey() {
  RESULT="$(jq -r -e '.$1' $USER_CONFIG_FILE)"
  [ "${RESULT}" == "null" ] && echo "" || echo ${RESULT}
}


###############################################################################
# Mounts backtitle dynamically
function backtitle() {
  BACKTITLE="TCRP 0.9.2.9"
  if [ -n "${MODEL}" ]; then
    BACKTITLE+=" ${MODEL}"
  else
    BACKTITLE+=" (no model)"
  fi
  if [ -n "${BUILD}" ]; then
    BACKTITLE+=" ${BUILD}"
  else
    BACKTITLE+=" (no build)"
  fi
  if [ -n "${SN}" ]; then
    BACKTITLE+=" ${SN}"
  else
    BACKTITLE+=" (no SN)"
  fi
  if [ -n "${IP}" ]; then
    BACKTITLE+=" ${IP}"
  else
    BACKTITLE+=" (no IP)"
  fi
  if [ -n "${MACADDR1}" ]; then
    BACKTITLE+=" ${MACADDR1}"
  else
    BACKTITLE+=" (no MACADDR1)"
  fi
  echo ${BACKTITLE}
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
  PREFIX=`readModelArray "$1" "serial.prefix"`
  MIDDLE=`readModelKey "$1" "serial.middle"`
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

###############################################################################
# Shows available models to user choose one
function modelMenu() {
  dialog --backtitle "`backtitle`" --default-item "${MODEL}" --no-items \
    --menu "Choose a model" 0 0 0 "DS3622xs+" "DS1621xs+" "RS4021xs+" "DS1019+" "DS918+" \
		"DS920+" "DS1520+" "DS1621+" "DS2422+" "FS2500" \
		"DS3617xs" "RS3618xs" "DVA1622" "DVA3221" "DVA3219" "DS3615xs" \
    2>${TMP_PATH}/resp
  [ $? -ne 0 ] && return
  MODEL="`<${TMP_PATH}/resp`"
}

###############################################################################
# Shows menu to user type one or generate randomly
function serialMenu() {
  while true; do
    dialog --clear --backtitle "`backtitle`" \
      --menu "Choose a option" 0 0 0 \
      a "Generate a random serial number" \
      m "Enter a serial number" \
    2>${TMP_PATH}/resp
    [ $? -ne 0 ] && return
    resp=$(<${TMP_PATH}/resp)
    [ -z "${resp}" ] && return
    if [ "${resp}" = "m" ]; then
      while true; do
        dialog --backtitle "`backtitle`" \
          --inputbox "Please enter a serial number " 0 0 "" \
          2>${TMP_PATH}/resp
        [ $? -ne 0 ] && return
        SERIAL=`cat ${TMP_PATH}/resp`
        if [ -z "${SERIAL}" ]; then
          return
        elif [ `validateSerial ${MODEL} ${SERIAL}` -eq 1 ]; then
          break
        fi
        dialog --backtitle "`backtitle`" --title "Alert" \
          --yesno "Invalid serial, continue?" 0 0
        [ $? -eq 0 ] && break
      done
      break
    elif [ "${resp}" = "a" ]; then
      SERIAL=`./sngen.sh "${MODEL}"`
      break
    fi
  done
  SN="${SERIAL}"
  DIRTY=1
}

###############################################################################
# Shows menu to generate randomly or to get realmac
function macMenu() {
  while true; do
    dialog --clear --backtitle "`backtitle`" \
      --menu "Choose a option" 0 0 0 \
      d "Generate a random mac address" \
      c "Get a real mac address" \
    2>${TMP_PATH}/resp
    [ $? -ne 0 ] && return
    resp=$(<${TMP_PATH}/resp)
    [ -z "${resp}" ] && return
    if [ "${resp}" = "d" ]; then
      MACADDR=`./macgen.sh "randommac"`
      break
    elif [ "${resp}" = "c" ]; then
      MACADDR=`./macgen.sh "realmac"`
      break
    fi
  done
  MACADDR1="${MACADDR}"
  DIRTY=1
}

###############################################################################
# Permits user edit the user config
function editUserConfig() {
  while true; do
    dialog --backtitle "`backtitle`" --title "Edit with caution" \
      --editbox "${USER_CONFIG_FILE}" 0 0 2>"${TMP_PATH}/userconfig"
    [ $? -ne 0 ] && return
    mv "${TMP_PATH}/userconfig" "${USER_CONFIG_FILE}"
    [ $? -eq 0 ] && break
    dialog --backtitle "`backtitle`" --title "Invalid JSON format" --msgbox "${ERRORS}" 0 0
  done

  MODEL="$(jq -r -e '.general.model' $USER_CONFIG_FILE)"
  BUILD="42962"
  SN="$(jq -r -e '.extra_cmdline.sn' $USER_CONFIG_FILE)"
  MACADDR1="$(jq -r -e '.extra_cmdline.mac1' $USER_CONFIG_FILE)"
  MACADDR2="$(jq -r -e '.extra_cmdline.mac2' $USER_CONFIG_FILE)"

}

###############################################################################
# Where the magic happens!
function make() {
  usbidentify
  clear

  if [ ${DIRTY} -eq 1 ]; then
      writeConfigKey "general" "model" "${MODEL}"
      writeConfigKey "extra_cmdline" "sn"   "${SN}"
      writeConfigKey "extra_cmdline" "mac1" "${MACADDR1}"
  fi
# && dialog --backtitle "`backtitle`" --title "Alert" \
#    --yesno "Config changed, would you like to rebuild the loader?" 0 0
#  if [ $? -eq 0 ]; then
#    make || return
#  fi

  ./my.sh "${MODEL}"F noconfig
  if [ $? -ne 0 ]; then
    dialog --backtitle "`backtitle`" --title "Error" --aspect 18 \
      --msgbox "Ramdisk not patched:\n`<"${LOG_FILE}"`" 0 0
    return 1
  fi

  echo "Ready!"
  sleep 3
  DIRTY=0
  return 0
}

function reboot() {
    clean
    sudo reboot
    break
}

# Main loop
NEXT="m"
while true; do
  echo "m \"Choose a model\""                          > "${TMP_PATH}/menu"
  if [ -n "${MODEL}" ]; then
    echo "s \"Choose a serial number\""               >> "${TMP_PATH}/menu"
    echo "a \"Choose a mac address\""                 >> "${TMP_PATH}/menu"
    echo "d \"Build the loader\""                     >> "${TMP_PATH}/menu"
  fi
  echo "u \"Edit user config file manually\""         >> "${TMP_PATH}/menu"
  echo "r \"Reboot\"" 				      >> "${TMP_PATH}/menu"
  echo "e \"Exit\""                                   >> "${TMP_PATH}/menu"
  dialog --clear --default-item ${NEXT} --backtitle "`backtitle`" --colors \
    --menu "Choose the option" 0 0 0 --file "${TMP_PATH}/menu" \
    2>${TMP_PATH}/resp
  [ $? -ne 0 ] && break
  case `<"${TMP_PATH}/resp"` in
    m) modelMenu; 	NEXT="s" ;;
    s) serialMenu; 	NEXT="a" ;;
    a) macMenu; 	NEXT="d" ;;
    d) make; 		NEXT="e" ;;
    u) editUserConfig; 	NEXT="d" ;;
    c) dialog --backtitle "`backtitle`" --title "Cleaning" --aspect 18 \
      --prgbox "rm -rfv \"${CACHE_PATH}/dl\"" 0 0 ;;
    r) reboot ;;
    e) break ;;
  esac
done
clear
echo -e "Call \033[1;32mmenu.sh\033[0m to return to menu"
