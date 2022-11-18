#!/usr/bin/env bash

##### INCLUDES #####################################################################################################
#source /home/tc/menufunc.h
#####################################################################################################

function checkmachine() {

    if grep -q ^flags.*\ hypervisor\  /proc/cpuinfo; then
        MACHINE="VIRTUAL"
        HYPERVISOR=$(dmesg | grep -i "Hypervisor detected" | awk '{print $5}')
        echo "Machine is $MACHINE Hypervisor=$HYPERVISOR"
    fi

}

checkmachine

# interval for loading somthing...
if [ "$MACHINE" = "VIRTUAL" ]; then
    sleep 1
else
    sleep 3
fi

[[ "$(which dialog)_" == "_" ]] && tce-load -wi dialog

[[ "$(which kmaps)_" == "_" ]] && tce-load -wi kmaps

# Get actual IP
IP="$(ifconfig | grep -i "inet " | grep -v "127.0.0.1" | awk '{print $2}')"

# Dirty flag
DIRTY=0

TMP_PATH=/tmp
LOG_FILE="${TMP_PATH}/log.txt"
USER_CONFIG_FILE="/home/tc/user_config.json"

MODEL="$(jq -r -e '.general.model' $USER_CONFIG_FILE)"
BUILD="42962"
SN="$(jq -r -e '.extra_cmdline.sn' $USER_CONFIG_FILE)"
MACADDR1="$(jq -r -e '.extra_cmdline.mac1' $USER_CONFIG_FILE)"
NETNUM="1"
if [ $(ifconfig | grep eth1 | wc -l) -gt 0 ]; then
  MACADDR2="$(jq -r -e '.extra_cmdline.mac2' $USER_CONFIG_FILE)"
  NETNUM="2"
fi

LAYOUT="$(jq -r -e '.general.layout' $USER_CONFIG_FILE)"
KEYMAP="$(jq -r -e '.general.keymap' $USER_CONFIG_FILE)"

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
# Mounts backtitle dynamically
function backtitle() {
  BACKTITLE="TCRP 0.9.3.0"
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
  if [ "$NETNUM"="2" ]; then
    if [ "${MACADDR2}" = "null" ]; then
      BACKTITLE+=" (no MACADDR2)"  
    else
      BACKTITLE+=" ${MACADDR2}"
    fi
  fi  
    if [ -n "${KEYMAP}" ]; then
    BACKTITLE+=" (${LAYOUT}/${KEYMAP})"
  else
    BACKTITLE+=" (qwerty/us)"
  fi
  echo ${BACKTITLE}
}

function usbidentify() {

    checkmachine

    if [ "$MACHINE" = "VIRTUAL" ] && [ "$HYPERVISOR" = "VMware" ]; then
        echo "Running on VMware, no need to set USB VID and PID, you should SATA shim instead"
    elif [ "$MACHINE" = "VIRTUAL" ] && [ "$HYPERVISOR" = "QEMU" ]; then
        echo "Running on QEMU, If you are using USB shim, VID 0x46f4 and PID 0x0001 should work for you"
        vendorid="0x46f4"
        productid="0x0001"
        echo "Vendor ID : $vendorid Product ID : $productid"
        json="$(jq --arg var "$productid" '.extra_cmdline.pid = $var' user_config.json)" && echo -E "${json}" | jq . >user_config.json
        json="$(jq --arg var "$vendorid" '.extra_cmdline.vid = $var' user_config.json)" && echo -E "${json}" | jq . >user_config.json
    else	    
    
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
    	    json="$(jq --arg var "$productid" '.extra_cmdline.pid = $var' user_config.json)" && echo -E "${json}" | jq . >user_config.json
	    json="$(jq --arg var "$vendorid" '.extra_cmdline.vid = $var' user_config.json)" && echo -E "${json}" | jq . >user_config.json
        else
	    echo "Sorry, no usb disk could be identified"
	    rm /tmp/lsusb.out
        fi
    fi	    
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
        else
          break
        fi
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
function macMenu1() {
  while true; do
    dialog --clear --backtitle "`backtitle`" \
      --menu "Choose a option" 0 0 0 \
      d "Generate a random mac address" \
      c "Get a real mac address" \
      m "Enter a mac address" \
    2>${TMP_PATH}/resp
    [ $? -ne 0 ] && return
    resp=$(<${TMP_PATH}/resp)
    [ -z "${resp}" ] && return
    if [ "${resp}" = "d" ]; then
      MACADDR=`./macgen.sh "randommac" "eth0"`
      break
    elif [ "${resp}" = "c" ]; then
      MACADDR=`./macgen.sh "realmac" "eth0"`
      break
    elif [ "${resp}" = "m" ]; then
      while true; do
        dialog --backtitle "`backtitle`" \
          --inputbox "Please enter a mac address " 0 0 "" \
          2>${TMP_PATH}/resp
        [ $? -ne 0 ] && return
        MACADDR=`cat ${TMP_PATH}/resp`
        if [ -z "${MACADDR}" ]; then
          return
        else
          break
        fi
      done
      break
    fi
  done
  MACADDR1="${MACADDR}"
  DIRTY=1
}

###############################################################################
# Shows menu to generate randomly or to get realmac
function macMenu2() {
  while true; do
    dialog --clear --backtitle "`backtitle`" \
      --menu "Choose a option" 0 0 0 \
      d "Generate a random mac address" \
      c "Get a real mac address" \
      m "Enter a mac address" \      
    2>${TMP_PATH}/resp
    [ $? -ne 0 ] && return
    resp=$(<${TMP_PATH}/resp)
    [ -z "${resp}" ] && return
    if [ "${resp}" = "d" ]; then
      MACADDR=`./macgen.sh "randommac" "eth1"` 
      break
    elif [ "${resp}" = "c" ]; then
      MACADDR=`./macgen.sh "realmac" "eth1"`
      break
    elif [ "${resp}" = "m" ]; then
      while true; do
        dialog --backtitle "`backtitle`" \
          --inputbox "Please enter a mac address " 0 0 "" \
          2>${TMP_PATH}/resp
        [ $? -ne 0 ] && return
        MACADDR=`cat ${TMP_PATH}/resp`
        if [ -z "${MACADDR}" ]; then
          return
        else
          break
        fi
      done
      break
    fi
  done
  MACADDR2="${MACADDR}"
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
  if [ $(ifconfig | grep eth1 | wc -l) -gt 0 ]; then
    MACADDR2="$(jq -r -e '.extra_cmdline.mac2' $USER_CONFIG_FILE)"
  fi

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
      if [ $(ifconfig | grep eth1 | wc -l) -gt 0 ]; then
        writeConfigKey "extra_cmdline" "mac2" "${MACADDR2}"
        writeConfigKey "extra_cmdline" "netif_num" "${NETNUM}"        
      fi
  fi
# && dialog --backtitle "`backtitle`" --title "Alert" \
#    --yesno "Config changed, would you like to rebuild the loader?" 0 0
#  if [ $? -eq 0 ]; then
#    make || return
#  fi

  ./my.sh "${MODEL}"F noconfig #>"${LOG_FILE}" 2>&1
  if [ $? -ne 0 ]; then
    dialog --backtitle "`backtitle`" --title "Error loader building" 0 0 #--textbox "${LOG_FILE}" 0 0    
    return 1
  fi

  echo "Ready!"
  sleep 3
  DIRTY=0
  return 0
}

###############################################################################
# Shows available keymaps to user choose one
function keymapMenu() {
  dialog --backtitle "`backtitle`" --default-item "${LAYOUT}" --no-items \
    --menu "Choose a layout" 0 0 0 "azerty" "colemak" \
    "dvorak" "fgGIod" "olpc" "qwerty" "qwertz" \
    2>${TMP_PATH}/resp
  [ $? -ne 0 ] && return
  LAYOUT="`<${TMP_PATH}/resp`"
  OPTIONS=""
  while read KM; do
    OPTIONS+="${KM::-5} "
  done < <(cd /usr/share/kmap/${LAYOUT}; ls *.kmap)
  dialog --backtitle "`backtitle`" --no-items --default-item "${KEYMAP}" \
    --menu "Choice a keymap" 0 0 0 ${OPTIONS} \
    2>/tmp/resp
  [ $? -ne 0 ] && return
  resp=`cat /tmp/resp 2>/dev/null`
  [ -z "${resp}" ] && return
  KEYMAP=${resp}
  writeConfigKey "general" "layout" "${LAYOUT}"
  writeConfigKey "general" "keymap" "${KEYMAP}"
  loadkmap < /usr/share/kmap/${LAYOUT}/${KEYMAP}.kmap
  cd ~
}

function backup() {
    echo "y"|./rploader.sh backup
}

function reboot() {
    clean
    sudo reboot
    break
}

# Main loop
if [ "${KEYMAP}" = "null" ]; then
    LAYOUT="qwerty"
    KEYMAP="us"
    writeConfigKey "general" "layout" "${LAYOUT}"
    writeConfigKey "general" "keymap" "${KEYMAP}"
fi
loadkmap < /usr/share/kmap/${LAYOUT}/${KEYMAP}.kmap
NEXT="m"
while true; do
  echo "m \"Choose a model\""                          > "${TMP_PATH}/menu"
  if [ -n "${MODEL}" ]; then
    echo "s \"Choose a serial number\""               >> "${TMP_PATH}/menu"
    echo "a \"Choose a mac address 1\""               >> "${TMP_PATH}/menu"
    if [ $(ifconfig | grep eth1 | wc -l) -gt 0 ]; then
      echo "f \"Choose a mac address 2\""               >> "${TMP_PATH}/menu"
    fi  
    echo "d \"Build the loader\""                     >> "${TMP_PATH}/menu"
  fi
  echo "u \"Edit user config file manually\""         >> "${TMP_PATH}/menu"
  echo "k \"Choose a keymap\""                       >> "${TMP_PATH}/menu"
  echo "b \"Backup TCRP\"" 			      >> "${TMP_PATH}/menu"  
  echo "r \"Reboot\"" 				      >> "${TMP_PATH}/menu"
  echo "e \"Exit\""                                   >> "${TMP_PATH}/menu"
  dialog --clear --default-item ${NEXT} --backtitle "`backtitle`" --colors \
    --menu "Choose the option" 0 0 0 --file "${TMP_PATH}/menu" \
    2>${TMP_PATH}/resp
  [ $? -ne 0 ] && break
  case `<"${TMP_PATH}/resp"` in
    m) modelMenu; 	NEXT="s" ;;
    s) serialMenu; 	NEXT="a" ;;
    a) macMenu1; 	NEXT="d" ;;
    f) macMenu2; 	NEXT="d" ;;
    d) make; 		NEXT="r" ;;
    u) editUserConfig; 	NEXT="d" ;;
    k) keymapMenu ;;
    c) dialog --backtitle "`backtitle`" --title "Cleaning" --aspect 18 \
      --prgbox "rm -rfv \"${CACHE_PATH}/dl\"" 0 0 ;;
    b) backup ;;      
    r) reboot ;;
    e) break ;;
  esac
done
clear
echo -e "Call \033[1;32m./menu.sh\033[0m to return to menu"
