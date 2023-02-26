#!/usr/bin/env bash

##### INCLUDES #####################################################################################################
#source /home/tc/menufunc.h
#####################################################################################################

# Get actual IP

TMP_PATH=/tmp
LOG_FILE="${TMP_PATH}/log.txt"
USER_CONFIG_FILE="/home/tc/user_config.json"

MODEL="$(jq -r -e '.general.model' $USER_CONFIG_FILE)"
BUILD="42962"
SN="$(jq -r -e '.extra_cmdline.sn' $USER_CONFIG_FILE)"
MACADDR1="$(jq -r -e '.extra_cmdline.mac1' $USER_CONFIG_FILE)"
NETNUM="1"

LAYOUT="$(jq -r -e '.general.layout' $USER_CONFIG_FILE)"
KEYMAP="$(jq -r -e '.general.keymap' $USER_CONFIG_FILE)"

###############################################################################
# check VM or baremetal
function checkmachine() {

    if grep -q ^flags.*\ hypervisor\  /proc/cpuinfo; then
        MACHINE="VIRTUAL"
        HYPERVISOR=$(dmesg | grep -i "Hypervisor detected" | awk '{print $5}')
        echo "Machine is $MACHINE Hypervisor=$HYPERVISOR"
    fi
    
    if [ $(lspci -nn | grep -ie "\[0107\]" | wc -l) -gt 0 ]; then
        echo "Found SAS HBAs, We need to block DT Models"
        HBADETECT="ON"
    else
        HBADETECT="OFF"    
    fi    

}

###############################################################################
# check Intel or AMD
function checkcpu() {

    if [ $(lscpu |grep Intel |wc -l) -gt 0 ]; then
        CPU="INTEL"
	codename=`bash -c "$(curl "https://raw.githubusercontent.com/FOXBI/xpenlib/master/cpu_info.sh")" |grep Generation | cut -c 18-`	
    else	
        CPU="AMD"    
	codename=""
    fi

    threads="$(lscpu |grep CPU\(s\): | awk '{print $2}')"
    
    if [ $(lscpu |grep movbe |wc -l) -gt 0 ]; then    
        AFTERHASWELL="ON"
    else
        AFTERHASWELL="OFF"
    fi
    
    if [ "$MACHINE" = "VIRTUAL" ] && [ "$HYPERVISOR" = "KVM" ]; then
        AFTERHASWELL="ON"    
    fi

}

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
# Delete field from json config file
function DeleteConfigKey() {

    block="$1"
    field="$2"

    if [ -n "$1 " ] && [ -n "$2" ]; then
        jsonfile=$(jq "del(.$block.$field)" $USER_CONFIG_FILE)
        echo $jsonfile | jq . >$USER_CONFIG_FILE
    else
        echo "No values to remove"
    fi

}



###############################################################################
# Mounts backtitle dynamically
function backtitle() {
  BACKTITLE="TCRP 0.9.4.0"
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
    BACKTITLE+=" (no MAC1)"
  fi
  if [ -n "${MACADDR2}" ]; then
    BACKTITLE+=" ${MACADDR2}"
  else
    BACKTITLE+=" (no MAC2)"
  fi
  if [ -n "${MACADDR3}" ]; then
    BACKTITLE+=" ${MACADDR3}"
  else
    BACKTITLE+=" (no MAC3)"
  fi
  if [ -n "${MACADDR4}" ]; then
    BACKTITLE+=" ${MACADDR4}"
  else
    BACKTITLE+=" (no MAC4)"
  fi
  if [ -n "${KEYMAP}" ]; then
    BACKTITLE+=" (${LAYOUT}/${KEYMAP})"
  else
    BACKTITLE+=" (qwerty/us)"
  fi
  echo ${BACKTITLE}
}

###############################################################################
# identify usb's pid vid
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

  if [ "$HBADETECT" = "ON" ]; then
	  if [ $threads -gt 16 ]; then

	  dialog --backtitle "`backtitle`" --default-item "${MODEL}" --no-items \
	    --menu "Choose a model\n[8 threads limit models]\nDS918+,DS920+,DS1019+,DS1520+,DVA1622\n[SAS HBA CONTROLLER DETECT]\nDT-based models are limited" 0 0 0 "DS3622xs+" "DS1621xs+" "RS4021xs+" \
			"DS3617xs" "RS3618xs" \
	    2>${TMP_PATH}/resp

	  elif [ $threads -gt 8 ]; then

	      if [ "${CPU}" == "INTEL" ] && [ "${AFTERHASWELL}" == "OFF" ]; then
		  dialog --backtitle "`backtitle`" --default-item "${MODEL}" --no-items \
		    --menu "Choose a model\n[8 threads limit models]\nDS918+,DS920+,DS1019+,DS1520+,DVA1622\n[SAS HBA CONTROLLER DETECT]\nDT-based models are limited" 0 0 0 "DS3622xs+" "DS1621xs+" "RS4021xs+" \
				"DS3615xs" "DS3617xs" "RS3618xs" \
		    2>${TMP_PATH}/resp
	      else  
		  dialog --backtitle "`backtitle`" --default-item "${MODEL}" --no-items \
		    --menu "Choose a model\n[8 threads limit models]\nDS918+,DS920+,DS1019+,DS1520+,DVA1622\n[SAS HBA CONTROLLER DETECT]\nDT-based models are limited" 0 0 0 "DS3622xs+" "DS1621xs+" "RS4021xs+" \
				"DS3615xs" "DS3617xs" "RS3618xs" "DVA3221" "DVA3219" \
		    2>${TMP_PATH}/resp
              fi
	  else
	  
	      if [ "${CPU}" == "INTEL" ] && [ "${AFTERHASWELL}" == "OFF" ]; then
		  dialog --backtitle "`backtitle`" --default-item "${MODEL}" --no-items \
		    --menu "Choose a model\n[8 threads limit models]\nDS918+,DS920+,DS1019+,DS1520+,DVA1622\n[SAS HBA CONTROLLER DETECT]\nDT-based models are limited" 0 0 0 "DS3622xs+" "DS1621xs+" "RS4021xs+" \
				"DS3615xs" "DS3617xs" "RS3618xs" \
		    2>${TMP_PATH}/resp
	      else
		  dialog --backtitle "`backtitle`" --default-item "${MODEL}" --no-items \
		    --menu "Choose a model\n[8 threads limit models]\nDS918+,DS920+,DS1019+,DS1520+,DVA1622\n[SAS HBA CONTROLLER DETECT]\nDT-based models are limited" 0 0 0 "DS3622xs+" "DS1621xs+" "RS4021xs+" "DS918+" "DS1019+" \
				"DS3615xs" "DS3617xs" "RS3618xs" "DVA3221" "DVA3219" \
		    2>${TMP_PATH}/resp
              fi
	  fi
  else
	  if [ $threads -gt 16 ]; then

	  dialog --backtitle "`backtitle`" --default-item "${MODEL}" --no-items \
	    --menu "Choose a model\n[8 threads limit models]\nDS918+,DS920+,DS1019+,DS1520+,DVA1622" 0 0 0 "DS3622xs+" "DS1621xs+" "RS4021xs+" \
			"DS3617xs" "RS3618xs" \
	    2>${TMP_PATH}/resp

	  elif [ $threads -gt 8 ]; then

	      if [ "${CPU}" == "INTEL" ] && [ "${AFTERHASWELL}" == "OFF" ]; then
		  dialog --backtitle "`backtitle`" --default-item "${MODEL}" --no-items \
		    --menu "Choose a model\n[8 threads limit models]\nDS918+,DS920+,DS1019+,DS1520+,DVA1622" 0 0 0 "DS3622xs+" "DS1621xs+" "RS4021xs+" \
				"DS923+" "DS723+" "DS1621+" "DS2422+" "FS2500" \
				"DS3615xs" "DS3617xs" "RS3618xs" \
		    2>${TMP_PATH}/resp
	      else
		  dialog --backtitle "`backtitle`" --default-item "${MODEL}" --no-items \
		    --menu "Choose a model\n[8 threads limit models]\nDS918+,DS920+,DS1019+,DS1520+,DVA1622" 0 0 0 "DS3622xs+" "DS1621xs+" "RS4021xs+" \
				"DS923+" "DS723+" "DS1621+" "DS2422+" "FS2500" \
				"DS3615xs" "DS3617xs" "RS3618xs" "DVA3221" "DVA3219" \
		    2>${TMP_PATH}/resp
	      fi
	  else

	      if [ "${CPU}" == "INTEL" ] && [ "${AFTERHASWELL}" == "OFF" ]; then
		  dialog --backtitle "`backtitle`" --default-item "${MODEL}" --no-items \
		    --menu "Choose a model\n[8 threads limit models]\nDS918+,DS920+,DS1019+,DS1520+,DVA1622" 0 0 0 "DS3622xs+" "DS1621xs+" "RS4021xs+" \
				"DS923+" "DS723+" "DS1621+" "DS2422+" "FS2500" \
				"DS3615xs" "DS3617xs" "RS3618xs" \
		    2>${TMP_PATH}/resp
	      else
		  dialog --backtitle "`backtitle`" --default-item "${MODEL}" --no-items \
		    --menu "Choose a model\n[8 threads limit models]\nDS918+,DS920+,DS1019+,DS1520+,DVA1622" 0 0 0 "DS3622xs+" "DS1621xs+" "RS4021xs+" "DS918+" "DS1019+" \
				"DS923+" "DS723+" "DS920+" "DS1520+" "DVA1622" "DS1621+" "DS2422+" "FS2500" \
				"DS3615xs" "DS3617xs" "RS3618xs" "DVA3221" "DVA3219" \
		    2>${TMP_PATH}/resp
	      fi
	  fi
  fi	  

  [ $? -ne 0 ] && return
  MODEL="`<${TMP_PATH}/resp`"
  writeConfigKey "general" "model" "${MODEL}"
  setSuggest
}

# Set Describe model-specific requirements or suggested hardware
function setSuggest() {

  line="-------------------------------------------------\n"
   
  case $MODEL in
    DS3622xs+)   platform="broadwellnk";desc="[${MODEL}]:${platform}, Max 24 Threads, any x86-64";;
    DS1621xs+)   platform="broadwellnk";desc="[${MODEL}]:${platform}, Max 24 Threads, any x86-64";;
    RS4021xs+)   platform="broadwellnk";desc="[${MODEL}]:${platform}, Max 24 Threads, any x86-64";;
    DS918+)      platform="apollolake";desc="[${MODEL}]:${platform}, Max 8 Threads, Haswell or later,iGPU Transcoding, HBA displays incorrect disk S/N";;
    DS1019+)     platform="apollolake";desc="[${MODEL}]:${platform}, Max 8 Threads, Haswell or later,iGPU Transcoding, HBA displays incorrect disk S/N";;
    DS923+)      platform="r1000";desc="[${MODEL}]:${platform}(DT,AMD Ryzen), Max ? Threads, any x86-64";;
    DS723+)      platform="r1000";desc="[${MODEL}]:${platform}(DT,AMD Ryzen), Max ? Threads, any x86-64";;
    DS920+)      platform="geminilake";desc="[${MODEL}]:${platform}(DT), Max 8 Threads,Haswell or later, iGPU Transcoding";;
    DS1520+)     platform="geminilake";desc="[${MODEL}]:${platform}(DT), Max 8 Threads,Haswell or later, iGPU Transcoding";;
    DVA1622)     platform="geminilake";desc="[${MODEL}]:${platform}(DT), Max 8 Threads,Haswell or later, iGPU Transcoding, Have a camera license";;
    DS1621+)     platform="v1000";desc="[${MODEL}]:${platform}(DT,AMD Ryzen), Max 16 Threads, any x86-64";;
    DS2422+)     platform="v1000";desc="[${MODEL}]:${platform}(DT,AMD Ryzen), Max 16 Threads, any x86-64";;
    FS2500)      platform="v1000";desc="[${MODEL}]:${platform}(DT,AMD Ryzen), Max 16 Threads, any x86-64";;
    DS3615xs)    platform="bromolow";desc="[${MODEL}]:${platform}, Max 16 Threads, any x86-64";;
    DS3617xs)    platform="broadwell";desc="[${MODEL}]:${platform}, Max 24 Threads, any x86-64";;
    RS3618xs)    platform="broadwell";desc="[${MODEL}]:${platform}, Max 24 Threads, any x86-64";;
    DVA3221)     platform="denverton";desc="[${MODEL}]:${platform}, Max 16 Threads, Haswell or later, Nvidia GTX1650, Have a camera license";;
    DVA3219)     platform="denverton";desc="[${MODEL}]:${platform}, Max 16 Threads, Haswell or later, Nvidia GTX1050Ti, Have a camera license";;
  esac

  result="${line}${desc}" 

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
  writeConfigKey "extra_cmdline" "sn" "${SN}"
}

###############################################################################
# Shows menu to generate randomly or to get realmac
function macMenu() {
  while true; do
    dialog --clear --backtitle "`backtitle`" \
      --menu "Choose a option" 0 0 0 \
      c "Get a real mac address" \
      d "Generate a random mac address" \
      m "Enter a mac address" \
    2>${TMP_PATH}/resp
    [ $? -ne 0 ] && return
    resp=$(<${TMP_PATH}/resp)
    [ -z "${resp}" ] && return
    if [ "${resp}" = "d" ]; then
      MACADDR=`./macgen.sh "randommac" $1 ${MODEL}`
      break
    elif [ "${resp}" = "c" ]; then
      MACADDR=`./macgen.sh "realmac" $1 ${MODEL}`
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
  
  if [ "$1" = "eth0" ]; then
      MACADDR1="${MACADDR}"
      writeConfigKey "extra_cmdline" "mac1" "${MACADDR1}"
  fi
  
  if [ "$1" = "eth1" ]; then
      MACADDR2="${MACADDR}"
      writeConfigKey "extra_cmdline" "mac2" "${MACADDR2}"
      writeConfigKey "extra_cmdline" "netif_num" "2"
  fi
  
  if [ "$1" = "eth2" ]; then
      MACADDR3="${MACADDR}"
      writeConfigKey "extra_cmdline" "mac3" "${MACADDR3}"
      writeConfigKey "extra_cmdline" "netif_num" "3"
  fi

  if [ "$1" = "eth3" ]; then
      MACADDR4="${MACADDR}"
      writeConfigKey "extra_cmdline" "mac4" "${MACADDR4}"
      writeConfigKey "extra_cmdline" "netif_num" "4"
  fi

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
  MACADDR3="$(jq -r -e '.extra_cmdline.mac3' $USER_CONFIG_FILE)"
  MACADDR4="$(jq -r -e '.extra_cmdline.mac4' $USER_CONFIG_FILE)"
  NETNUM"=$(jq -r -e '.extra_cmdline.netif_num' $USER_CONFIG_FILE)"
}

###############################################################################
# Where the magic happens!
function make() {
  usbidentify
  clear

  if [ "$1" = "jun" ]; then
      ./my.sh "${MODEL}"J noconfig | tee "/home/tc/zlastbuild.log"    
  else
      ./my.sh "${MODEL}"F noconfig $1 | tee "/home/tc/zlastbuild.log"  
  fi

  if [ $? -ne 0 ]; then
    dialog --backtitle "`backtitle`" --title "Error loader building" 0 0 #--textbox "${LOG_FILE}" 0 0    
    return 1
  fi

  echo "Ready!"
  sleep 3

  return 0
}

###############################################################################
# Post Update for jot mode 
function postupdate() {
  ./my.sh "${MODEL}" postupdate | tee "/home/tc/zpostupdate.log"
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
sed -i "s/screen_color = (CYAN,GREEN,ON)/screen_color = (CYAN,BLUE,ON)/g" .dialogrc
echo "insert aterm menu.sh in /home/tc/.xsession"
sed -i "/aterm/d" .xsession
echo "aterm -geometry 78x32+10+0 -fg yellow -title \"TCRP Monitor\" -e /home/tc/rploader.sh monitor &" >> .xsession
echo "aterm -geometry 78x32+525+0 -title \"M Shell for TCRP Menu\" -e /home/tc/menu.sh &" >> .xsession
echo "aterm -geometry 78x25+10+430 -fg green -title \"TCRP Extra Terminal\" &" >> .xsession

if [ "${KEYMAP}" = "null" ]; then
    LAYOUT="qwerty"
    KEYMAP="us"
    writeConfigKey "general" "layout" "${LAYOUT}"
    writeConfigKey "general" "keymap" "${KEYMAP}"
fi

IP="$(ifconfig | grep -i "inet " | grep -v "127.0.0.1" | awk '{print $2}')"

if [ $(ifconfig | grep eth1 | wc -l) -gt 0 ]; then
  MACADDR2="$(jq -r -e '.extra_cmdline.mac2' $USER_CONFIG_FILE)"
  NETNUM="2"
fi  
if [ $(ifconfig | grep eth2 | wc -l) -gt 0 ]; then
  MACADDR3="$(jq -r -e '.extra_cmdline.mac3' $USER_CONFIG_FILE)"
  NETNUM="3"
fi  
if [ $(ifconfig | grep eth3 | wc -l) -gt 0 ]; then
  MACADDR4="$(jq -r -e '.extra_cmdline.mac4' $USER_CONFIG_FILE)"
  NETNUM="4"
fi  

CURNETNUM="$(jq -r -e '.extra_cmdline.netif_num' $USER_CONFIG_FILE)"
if [ $CURNETNUM != $NETNUM ]; then
  if [ $NETNUM == "3" ]; then 
    DeleteConfigKey "extra_cmdline" "mac4"
  fi  
  if [ $NETNUM == "2" ]; then 
    DeleteConfigKey "extra_cmdline" "mac4"  
    DeleteConfigKey "extra_cmdline" "mac3"
  fi  
  if [ $NETNUM == "1" ]; then
    DeleteConfigKey "extra_cmdline" "mac4"  
    DeleteConfigKey "extra_cmdline" "mac3"
    DeleteConfigKey "extra_cmdline" "mac2"    
  fi  
  writeConfigKey "extra_cmdline" "netif_num" "$NETNUM"
fi

checkmachine
checkcpu

if [ ! -n "$(which dialog)" ] && [ ! -n "$(which kmaps)" ]; then
    tce-load -wi dialog
    tce-load -wi kmaps

    tcrppart="$(mount | grep -i optional | grep cde | awk -F / '{print $3}' | uniq | cut -c 1-3)3"
    if [ $tcrppart == "mmc3" ]; then
        tcrppart="mmcblk0p3"
    fi    
    sudo curl -L "https://github.com/PeterSuh-Q3/tinycore-redpill/raw/main/tce/optional/dialog.tcz" --output /mnt/${tcrppart}/cde/optional/dialog.tcz
    sudo curl -L "https://github.com/PeterSuh-Q3/tinycore-redpill/raw/main/tce/optional/dialog.tcz.dep" --output /mnt/${tcrppart}/cde/optional/dialog.tcz.dep
    sudo curl -L "https://github.com/PeterSuh-Q3/tinycore-redpill/raw/main/tce/optional/dialog.tcz.md5.txt" --output /mnt/${tcrppart}/cde/optional/dialog.tcz.md5.txt
    sudo curl -L "https://github.com/PeterSuh-Q3/tinycore-redpill/raw/main/tce/optional/kmaps.tcz" --output /mnt/${tcrppart}/cde/optional/kmaps.tcz
    sudo curl -L "https://github.com/PeterSuh-Q3/tinycore-redpill/raw/main/tce/optional/kmaps.tcz.md5.txt" --output /mnt/${tcrppart}/cde/optional/kmaps.tcz.md5.txt

    sudo echo "dialog.tcz" >> /mnt/${tcrppart}/cde/onboot.lst
    sudo echo "kmaps.tcz" >> /mnt/${tcrppart}/cde/onboot.lst
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
    if [ $(ifconfig | grep eth2 | wc -l) -gt 0 ]; then
      echo "g \"Choose a mac address 3\""               >> "${TMP_PATH}/menu"
    fi  
    if [ $(ifconfig | grep eth3 | wc -l) -gt 0 ]; then
      echo "h \"Choose a mac address 4\""               >> "${TMP_PATH}/menu"
    fi
    if [ "${CPU}" == "INTEL" ]; then
      echo "d \"Build the [TCRP FRIEND] loader\""         >> "${TMP_PATH}/menu"    
    else
      if [ "${platform}" == "r1000" ]||[ "${platform}" == "v1000" ]; then    
        echo "d \"Build the [TCRP FRIEND] loader\""         >> "${TMP_PATH}/menu"          
      fi
    fi
    echo "j \"Build the [TCRP JOT Mod] loader\""            >> "${TMP_PATH}/menu"   
    echo "p \"Post Update for [TCRP JOT Mod]\""             >> "${TMP_PATH}/menu"   
    if [ "${MODEL}" == "DS918+" ]||[ "${MODEL}" == "DS1019+" ]||[ "${MODEL}" == "DS920+" ]||[ "${MODEL}" == "DS1520+" ]; then        
    	echo "o \"Build the [TCRP FRIEND 7.0.1-42218] loader\""  >> "${TMP_PATH}/menu"    
    fi	
  fi
  echo "u \"Edit user config file manually\""         >> "${TMP_PATH}/menu"
  echo "k \"Choose a keymap\""                       >> "${TMP_PATH}/menu"
  echo "b \"Backup TCRP\""                            >> "${TMP_PATH}/menu"  
  echo "r \"Reboot\""                                 >> "${TMP_PATH}/menu"
  echo "e \"Exit\""                                   >> "${TMP_PATH}/menu"
  dialog --clear --default-item ${NEXT} --backtitle "`backtitle`" --colors \
    --menu "Choose the option [ CPU Code Name : ${codename} ]\nDevice-Tree[DT] Base Models & HBAs do not require SataPortMap,DiskIdxMap\nDT models do not support HBAs\n${result}" 0 0 0 --file "${TMP_PATH}/menu" \
    2>${TMP_PATH}/resp
  [ $? -ne 0 ] && break
  case `<"${TMP_PATH}/resp"` in
    m) modelMenu;       NEXT="s" ;;
    s) serialMenu;      NEXT="a" ;;
    a) macMenu "eth0";  NEXT="d" ;;
    f) macMenu "eth1";  NEXT="g" ;;
    g) macMenu "eth2";  NEXT="h" ;;
    h) macMenu "eth3";  NEXT="d" ;;    
    d) make ;             NEXT="r" ;;
    j) make "jot";        NEXT="r" ;;  
    p) postupdate ;       NEXT="r" ;;
    o) make "jun";      NEXT="r" ;;
    u) editUserConfig;  NEXT="d" ;;
    k) keymapMenu ;;
    b) backup ;;      
    r) reboot ;;
    e) break ;;
  esac
done
clear
echo -e "Call \033[1;32m./menu.sh\033[0m to return to menu"
