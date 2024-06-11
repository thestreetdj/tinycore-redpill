#!/usr/bin/env bash

set -u # Unbound variable errors are not allowed

##### INCLUDES #####################################################################################################
. /home/tc/functions.sh
. /home/tc/i18n.h
#####################################################################################################

# Function to be called on Ctrl+C or ESC
function ctrl_c() {
  echo ", Ctrl+C key pressed. Press Enter to return menu..."
}

function readanswer() {
    while true; do
        read answ
        case $answ in
            [Yy]* ) answer="$answ"; break;;
            [Nn]* ) answer="$answ"; break;;
            * ) echo "Please answer yY/nN.";;
        esac
    done
}
 
function restart() {
    echo "A reboot is required. Press any key to reboot..."
    read answer
    clear
    sudo reboot
}

function restartx() {
    echo "X window needs to be restarted. Press any key to restart x window..."
    read answer
    clear
    { kill $(cat /tmp/.X${DISPLAY:1:1}-lock) ; sleep 2 >/dev/tty0 ; startx >/dev/tty0 ; } &
}

function installtcz() {
  tczpack="${1}"
  cd /mnt/${tcrppart}/cde/optional
  sudo curl -kLO# http://tinycorelinux.net/12.x/x86_64/tcz/${tczpack}
  sudo md5sum ${tczpack} > ${tczpack}.md5.txt
  echo "${tczpack}" >> /mnt/${tcrppart}/cde/onboot.lst
  cd ~
}

function restoresession() {
    lastsessiondir="/mnt/${tcrppart}/lastsession"
    if [ -d $lastsessiondir ]; then
        echo "Found last user session, restoring session..."
    if [ -d $lastsessiondir ] && [ -f ${lastsessiondir}/user_config.json ]; then
        echo "Copying last stored user_config.json"
        cp -f ${lastsessiondir}/user_config.json /home/tc
    fi
    else
        echo "There is no last session stored!!!"
    fi
}

function update_tinycore() {
  echo "check update for tinycore 14.0..."
  cd /mnt/${tcrppart}
  md5_corepure64=$(sudo md5sum corepure64.gz | awk '{print $1}')
  md5_vmlinuz64=$(sudo md5sum vmlinuz64 | awk '{print $1}')
  if [ ${md5_corepure64} != "f33c4560e3909a7784c0e83ce424ff5c" ] || [ ${md5_vmlinuz64} != "04cb17bbf7fbca9aaaa2e1356a936d7c" ]; then
      echo "current tinycore version is not 14.0, update tinycore linux to 14.0..."
      sudo curl -kL# https://raw.githubusercontent.com/PeterSuh-Q3/tinycore-redpill/master/tinycore_14.0/corepure64.gz -o corepure64.gz_copy
      sudo curl -kL# https://raw.githubusercontent.com/PeterSuh-Q3/tinycore-redpill/master/tinycore_14.0/vmlinuz64 -o vmlinuz64_copy
      md5_corepure64=$(sudo md5sum corepure64.gz_copy | awk '{print $1}')
      md5_vmlinuz64=$(sudo md5sum vmlinuz64_copy | awk '{print $1}')
      if [ ${md5_corepure64} = "f33c4560e3909a7784c0e83ce424ff5c" ] && [ ${md5_vmlinuz64} = "04cb17bbf7fbca9aaaa2e1356a936d7c" ]; then
      echo "tinycore 14.0 md5 check is OK! ( corepure64.gz / vmlinuz64 ) "
        sudo mv corepure64.gz_copy corepure64.gz
    sudo mv vmlinuz64_copy vmlinuz64
          sudo curl -kL#  https://raw.githubusercontent.com/PeterSuh-Q3/tinycore-redpill/master/tinycore_14.0/etc/shadow -o /etc/shadow
        echo "/etc/shadow" >> /opt/.filetool.lst
    cd ~
    echo 'Y'|rploader backup
        restart
      fi
  fi
  cd ~
}

if [ -f /home/tc/my.sh ]; then
  rm /home/tc/my.sh
fi
if [ -f /home/tc/myv.sh ]; then
  rm /home/tc/myv.sh
fi

# Prevent SataPortMap/DiskIdxMap initialization 2023.12.31
prevent_init="OFF"

# Trap Ctrl+C (SIGINT) signals and call ctrl_c function
trap ctrl_c INT

VERSION=v`cat /home/tc/functions.sh | grep rploaderver= | cut -d\" -f2`

getloaderdisk
if [ -z "${loaderdisk}" ]; then
    echo "Not Supported Loader BUS Type, program Exit!!!"
    exit 99
fi
getBus "${loaderdisk}"

[ "${BUS}" = "nvme" ] && loaderdisk="${loaderdisk}p"
[ "${BUS}" = "mmc"  ] && loaderdisk="${loaderdisk}p"

tcrppart="${loaderdisk}3"

# update tinycore 14.0 2023.12.18
update_tinycore

# restore user_config.json file from /mnt/sd#/lastsession directory 2023.10.21
#restoresession

TMP_PATH=/tmp
LOG_FILE="${TMP_PATH}/log.txt"
USER_CONFIG_FILE="/home/tc/user_config.json"

MODEL=$(jq -r -e '.general.model' "$USER_CONFIG_FILE")
BUILD=$(jq -r -e '.general.version' "$USER_CONFIG_FILE")
SN=$(jq -r -e '.extra_cmdline.sn' "$USER_CONFIG_FILE")
MACADDR1=$(jq -r -e '.extra_cmdline.mac1' "$USER_CONFIG_FILE")
MACADDR2="$(jq -r -e '.extra_cmdline.mac2' $USER_CONFIG_FILE)"
MACADDR3="$(jq -r -e '.extra_cmdline.mac3' $USER_CONFIG_FILE)"
MACADDR4="$(jq -r -e '.extra_cmdline.mac4' $USER_CONFIG_FILE)"
NETNUM="1"

LAYOUT=$(jq -r -e '.general.layout' "$USER_CONFIG_FILE")
KEYMAP=$(jq -r -e '.general.keymap' "$USER_CONFIG_FILE")

DMPM=$(jq -r -e '.general.devmod' "$USER_CONFIG_FILE")
LDRMODE=$(jq -r -e '.general.loadermode' "$USER_CONFIG_FILE")
DISABLEI915=$(jq -r -e '.general.disablei915' "$USER_CONFIG_FILE")
ucode=$(jq -r -e '.general.ucode' "$USER_CONFIG_FILE")
lcode=$(echo $ucode | cut -c 4-)
BLOCK_EUDEV="N"

# for test gettext
#path_i="/usr/local/share/locale/ko_KR/LC_MESSAGES"
#sudo mkdir -p "${path_i}"
#cat "tcrp.po"
#msgfmt "tcrp.po" -o "tcrp.mo"
#sudo cp -vf "tcrp.mo" "${path_i}/tcrp.mo"


###############################################################################
# Mounts backtitle dynamically
function backtitle() {
  BACKTITLE="TCRP-mshell ${VERSION}"
  BACKTITLE+=" ${DMPM}"
  BACKTITLE+=" ${ucode}"
  BACKTITLE+=" ${LDRMODE}"
  [ -n "${MODEL}" ] && BACKTITLE+=" ${MODEL}" || BACKTITLE+=" (no model)"
  [ -n "${BUILD}" ] && BACKTITLE+=" ${BUILD}" || BACKTITLE+=" (no build)"
  [ -n "${SN}" ] && BACKTITLE+=" ${SN}" || BACKTITLE+=" (no SN)"
  [ -n "${IP}" ] && BACKTITLE+=" ${IP}" || BACKTITLE+=" (no IP)"
  [ ! -n "${MACADDR1}" ] && BACKTITLE+=" (no MAC1)" || BACKTITLE+=" ${MACADDR1}"
  [ ! -n "${MACADDR2}" ] && BACKTITLE+=" (no MAC2)" || BACKTITLE+=" ${MACADDR2}"
  [ ! -n "${MACADDR3}" ] && BACKTITLE+=" (no MAC3)" || BACKTITLE+=" ${MACADDR3}"
  [ ! -n "${MACADDR4}" ] && BACKTITLE+=" (no MAC4)" || BACKTITLE+=" ${MACADDR4}"  
  [ -n "${KEYMAP}" ] && BACKTITLE+=" (${LAYOUT}/${KEYMAP})" || BACKTITLE+=" (qwerty/us)"
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

        lsusb -v 2>&1 | grep -B 33 -A 1 SCSI >/tmp/lsusb.out

        usblist=$(grep -B 33 -A 1 SCSI /tmp/lsusb.out)
        vendorid=$(grep -B 33 -A 1 SCSI /tmp/lsusb.out | grep -i idVendor | awk '{print $2}')
        productid=$(grep -B 33 -A 1 SCSI /tmp/lsusb.out | grep -i idProduct | awk '{print $2}')

        if [ $(echo $vendorid | wc -w) -gt 1 ]; then
            echo "Found more than one USB disk devices."
        echo "Please leave it to the FRIEND kernel." 
            echo "Automatically obtains the VID/PID of the required bootloader USB."
        rm /tmp/lsusb.out
        else
            usbdevice="$(grep iManufacturer /tmp/lsusb.out | awk '{print $3}') $(grep iProduct /tmp/lsusb.out | awk '{print $3}') SerialNumber: $(grep iSerial /tmp/lsusb.out | awk '{print $3}')"
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
    fi      
}

###############################################################################
# Shows available between DDSML and EUDEV
function seleudev() {
  checkforsas
  eval "MSG27=\"\${MSG${tz}27}\""
  eval "MSG26=\"\${MSG${tz}26}\""
  eval "MSG40=\"\${MSG${tz}40}\""

  if [ "${MODEL}" = "SA6400" ]; then
    while true; do
      dialog --clear --backtitle "`backtitle`" \
    --menu "Choose a option" 0 0 0 \
    e "${MSG26}" \
    f "${MSG40}" \
    2>${TMP_PATH}/resp
      [ $? -ne 0 ] && return
      resp=$(<${TMP_PATH}/resp)
      [ -z "${resp}" ] && return
      if [ "${resp}" = "e" ]; then
        DMPM="EUDEV"
        break
      elif [ "${resp}" = "f" ]; then
        DMPM="DDSML+EUDEV"
        break
      fi
    done
  else
    if [ ${BLOCK_EUDEV} = "Y" ]; then
      while true; do
    dialog --clear --backtitle "`backtitle`" \
      --menu "Choose a option" 0 0 0 \
      d "${MSG27}" \
      f "${MSG40}" \
      2>${TMP_PATH}/resp
    [ $? -ne 0 ] && return
    resp=$(<${TMP_PATH}/resp)
    [ -z "${resp}" ] && return
    if [ "${resp}" = "d" ]; then
      DMPM="DDSML"
      break
    elif [ "${resp}" = "f" ]; then
      DMPM="DDSML+EUDEV"
      break
    fi
      done
    else
      while true; do
        dialog --clear --backtitle "`backtitle`" \
          --menu "Choose a option" 0 0 0 \
      d "${MSG27}" \
      e "${MSG26}" \
      f "${MSG40}" \
      2>${TMP_PATH}/resp
    [ $? -ne 0 ] && return
    resp=$(<${TMP_PATH}/resp)
    [ -z "${resp}" ] && return
    if [ "${resp}" = "d" ]; then
      DMPM="DDSML"
      break
    elif [ "${resp}" = "e" ]; then
      DMPM="EUDEV"
      break
    elif [ "${resp}" = "f" ]; then
      DMPM="DDSML+EUDEV"
      break
    fi
      done
    fi
  fi 

  curl -kL# https://raw.githubusercontent.com/PeterSuh-Q3/redpill-load/master/bundled-exts.json -o /home/tc/redpill-load/bundled-exts.json
  sudo rm -rf /home/tc/redpill-load/custom/extensions/ddsml
  sudo rm -rf /home/tc/redpill-load/custom/extensions/eudev
  writeConfigKey "general" "devmod" "${DMPM}"

}


###############################################################################
# Shows available between FRIEND and JOT
function selectldrmode() {
  eval "MSG28=\"\${MSG${tz}28}\""
  eval "MSG29=\"\${MSG${tz}29}\""  
  while true; do
    dialog --clear --backtitle "`backtitle`" \
      --menu "Choose a option" 0 0 0 \
      f "${MSG28}" \
      j "${MSG29}" \
    2>${TMP_PATH}/resp
    [ $? -ne 0 ] && return
    resp=$(<${TMP_PATH}/resp)
    [ -z "${resp}" ] && return
    if [ "${resp}" = "f" ]; then
      LDRMODE="FRIEND"
      break
    elif [ "${resp}" = "j" ]; then
      LDRMODE="JOT"
      break
    fi
  done

  writeConfigKey "general" "loadermode" "${LDRMODE}"

}

###############################################################################
# Shows available dsm verwsion 
function selectversion () {

while true; do
  cmd=(dialog --clear --backtitle "`backtitle`" --menu "Choose an option" 0 0 0)
  if [ "${MODEL}" != "DS3615xs" ]; then
    options=("a" "7.2.1-69057" "b" "7.2.0-64570" "c" "7.1.1-42962")
  else  
    options=("c" "7.1.1-42962")
  fi 
  case $MODEL in
    DS923+ | DS723+ | DS1823+ | DVA1622 | DS1522+ | DS423+ | RS2423+ )
      ;;
    * )
      options+=("d" "7.0.1-42218")
      ;;
  esac    

  for ((i=0; i<${#options[@]}; i+=2)); do
    cmd+=("${options[i]}" "${options[i+1]}")
  done

  "${cmd[@]}" 2>${TMP_PATH}/resp
  [ $? -ne 0 ] && return
  resp=$(<${TMP_PATH}/resp)
  [ -z "${resp}" ] && return

  case $resp in
    "a") BUILD="7.2.1-69057"; break;;
    "b") BUILD="7.2.0-64570"; break;;
    "c") BUILD="7.1.1-42962"; break;;
    "d") BUILD="7.0.1-42218"; break;;
    *) echo "Invalid option";;
  esac
done

  writeConfigKey "general" "version" "${BUILD}"

}

###############################################################################
# Shows available models to user choose one
function modelMenu() {

  M_GRP1="SA6400 DS3622xs+ DS1621xs+ RS3621xs+ RS4021xs+ DS3617xs RS3618xs" #RS1619xs+
  M_GRP2="DS3615xs"
  M_GRP3="DVA3221 DVA3219 DS1819+ DS2419+"
  M_GRP4="DS218+ DS918+ DS1019+ DS620slim DS718+"
  M_GRP5="DS923+ DS723+ DS1522+"
  M_GRP6="DS1621+ DS1821+ DS1823xs+ DS2422+ FS2500 RS1221+ RS2423+"
  M_GRP7="DS220+ DS423+ DS720+ DS920+ DS1520+ DVA1622"
  
RESTRICT=1
while true; do
  echo "" > "${TMP_PATH}/mdl"
  
#  if [ "$HBADETECT" = "ON" ]; then
#      if [ "${AFTERHASWELL}" == "OFF" ]; then
#        echo "${M_GRP1}" | tr ' ' '\n' >> "${TMP_PATH}/mdl"
#        echo "${M_GRP2}" | tr ' ' '\n' >> "${TMP_PATH}/mdl"    
#      else
#        echo "${M_GRP1}" | tr ' ' '\n' >> "${TMP_PATH}/mdl"
#        echo "${M_GRP2}" | tr ' ' '\n' >> "${TMP_PATH}/mdl"
#        echo "${M_GRP4}" | tr ' ' '\n' >> "${TMP_PATH}/mdl"    
#        echo "${M_GRP3}" | tr ' ' '\n' >> "${TMP_PATH}/mdl"
#      fi
#  else
      if [ "${AFTERHASWELL}" == "OFF" ]; then
        echo "${M_GRP1}" | tr ' ' '\n' >> "${TMP_PATH}/mdl"
        echo "${M_GRP2}" | tr ' ' '\n' >> "${TMP_PATH}/mdl"    
        echo "${M_GRP5}" | tr ' ' '\n' >> "${TMP_PATH}/mdl"
        echo "${M_GRP6}" | tr ' ' '\n' >> "${TMP_PATH}/mdl"    
      else
        echo "${M_GRP1}" | tr ' ' '\n' >> "${TMP_PATH}/mdl"
        echo "${M_GRP2}" | tr ' ' '\n' >> "${TMP_PATH}/mdl"
        echo "${M_GRP4}" | tr ' ' '\n' >> "${TMP_PATH}/mdl"
        echo "${M_GRP5}" | tr ' ' '\n' >> "${TMP_PATH}/mdl"
        echo "${M_GRP7}" | tr ' ' '\n' >> "${TMP_PATH}/mdl"        
        echo "${M_GRP6}" | tr ' ' '\n' >> "${TMP_PATH}/mdl"    
        echo "${M_GRP3}" | tr ' ' '\n' >> "${TMP_PATH}/mdl"
    RESTRICT=0
      fi
#  fi      
  
  if [ ${RESTRICT} -eq 1 ]; then
        echo "Release-model-restriction" >> "${TMP_PATH}/mdl"
  else  
        echo "" > "${TMP_PATH}/mdl"
        echo "${M_GRP1}" | tr ' ' '\n' >> "${TMP_PATH}/mdl"
        echo "${M_GRP2}" | tr ' ' '\n' >> "${TMP_PATH}/mdl"
        echo "${M_GRP4}" | tr ' ' '\n' >> "${TMP_PATH}/mdl"
        echo "${M_GRP5}" | tr ' ' '\n' >> "${TMP_PATH}/mdl"
        echo "${M_GRP7}" | tr ' ' '\n' >> "${TMP_PATH}/mdl"        
        echo "${M_GRP6}" | tr ' ' '\n' >> "${TMP_PATH}/mdl"    
        echo "${M_GRP3}" | tr ' ' '\n' >> "${TMP_PATH}/mdl"
  fi
  
  echo "" > "${TMP_PATH}/mdl_final"
  line_number=2
  model_list=$(tail -n +$line_number "${TMP_PATH}/mdl")
  while read -r model; do
    suggestion=$(setSuggest $model)
    echo "$model \"\Zb$suggestion\Zn\"" >> "${TMP_PATH}/mdl_final"
  done <<< "$model_list"
  
  dialog --backtitle "`backtitle`" --default-item "${MODEL}" --colors \
    --menu "Choose a model\n" 0 0 0 \
    --file "${TMP_PATH}/mdl_final" 2>${TMP_PATH}/resp
  [ $? -ne 0 ] && return
  resp=$(<${TMP_PATH}/resp)
  [ -z "${resp}" ] && return  
  
  if [ "${resp}" = "Release-model-restriction" ]; then
    RESTRICT=0
    continue
  fi
  break
done
    
  MODEL="`<${TMP_PATH}/resp`"
  writeConfigKey "general" "model" "${MODEL}"
  setSuggest $MODEL

  if [ "${MODEL}" = "DS3615xs" ]; then
      BUILD="7.1.1-42962"
      writeConfigKey "general" "version" "${BUILD}"
  fi    
  if [ "${MODEL}" = "DS923+" ] || [ "${MODEL}" = "DS723+" ] || [ "${MODEL}" = "DS1823+" ] || [ "${MODEL}" = "DVA1622" ]; then
      BUILD="7.2.1-69057"
      writeConfigKey "general" "version" "${BUILD}"
  fi

  if [ "${MODEL}" = "SA6400" ]; then
    if [ "$HBADETECT" = "ON" ]; then
    DMPM="DDSML+EUDEV"
    else
        DMPM="EUDEV"
    fi 
  else
    DMPM="DDSML"
  fi
  writeConfigKey "general" "devmod" "${DMPM}"
  
}

# Set Describe model-specific requirements or suggested hardware
function setSuggest() {

  case $1 in
    DS620slim)   platform="apollolake";bay="TOWER_6_Bay";mcpu="Intel Celeron J3355";eval "desc=\"[${MODEL}]:${platform},${bay},${mcpu}, \${MSG${tz}17}\"";;  
    DS1019+)     platform="apollolake";bay="TOWER_5_Bay";mcpu="Intel Celeron J3455";eval "desc=\"[${MODEL}]:${platform},${bay},${mcpu}, \${MSG${tz}17}\"";;
    DS1520+)     platform="geminilake(DT)";bay="TOWER_5_Bay";mcpu="Intel Celeron J4125";eval "desc=\"[${MODEL}]:${platform},${bay},${mcpu}, \${MSG${tz}17}\"";;    
    DS1522+)     platform="r1000(DT)";bay="TOWER_5_Bay";mcpu="AMD Ryzen R1600";eval "desc=\"[${MODEL}]:${platform},${bay},${mcpu}, \${MSG${tz}20}\"";;    
    DS1621+)     platform="v1000(DT)";bay="TOWER_6_Bay";mcpu="AMD Ryzen V1500B";eval "desc=\"[${MODEL}]:${platform},${bay},${mcpu}, \${MSG${tz}22}\"";;    
    DS1821+)     platform="v1000(DT)";bay="TOWER_8_Bay";mcpu="AMD Ryzen V1500B";eval "desc=\"[${MODEL}]:${platform},${bay},${mcpu}, \${MSG${tz}22}\"";;
    DS1823xs+)   platform="v1000(DT)";bay="TOWER_8_Bay";mcpu="AMD Ryzen V1780B";eval "desc=\"[${MODEL}]:${platform},${bay},${mcpu}, \${MSG${tz}22}\"";;            
    DS1621xs+)   platform="broadwellnk";bay="TOWER_6_Bay";mcpu="Intel Xeon D-1527";eval "desc=\"[${MODEL}]:${platform},${bay},${mcpu}, \${MSG${tz}16}\"";;
    DS218+)      platform="apollolake";bay="TOWER_2_Bay";mcpu="Intel Celeron J3355";eval "desc=\"[${MODEL}]:${platform},${bay},${mcpu}, \${MSG${tz}17}\"";;      
    DS220+)      platform="geminilake(DT)";bay="TOWER_2_Bay";mcpu="Intel Celeron J4125";eval "desc=\"[${MODEL}]:${platform},${bay},${mcpu}, \${MSG${tz}17}\"";;
    DS2422+)     platform="v1000(DT)";bay="TOWER_12_Bay";mcpu="AMD Ryzen V1500B";eval "desc=\"[${MODEL}]:${platform},${bay},${mcpu}, \${MSG${tz}22}\"";;    
    DS3615xs)    platform="bromolow";bay="TOWER_12_Bay";mcpu="Intel Core i3-4130";eval "desc=\"[${MODEL}]:${platform},${bay},${mcpu}, \${MSG${tz}22}\"";;    
    DS3617xs)    platform="broadwell";bay="TOWER_12_Bay";mcpu="Intel Xeon D-1527";eval "desc=\"[${MODEL}]:${platform},${bay},${mcpu}, \${MSG${tz}16}\"";;    
    DS3622xs+)   platform="broadwellnk";bay="TOWER_12_Bay";mcpu="Intel Xeon D-1531";eval "desc=\"[${MODEL}]:${platform},${bay},${mcpu}, \${MSG${tz}16}\"";;
    DS423+)      platform="geminilake(DT)";bay="TOWER_4_Bay";mcpu="Intel Celeron J4125";eval "desc=\"[${MODEL}]:${platform},${bay},${mcpu}, \${MSG${tz}17}\"";;
    DS718+)      platform="apollolake";bay="TOWER_2_Bay";mcpu="Intel Celeron J3455";eval "desc=\"[${MODEL}]:${platform},${bay},${mcpu}, \${MSG${tz}17}\"";;        
    DS720+)      platform="geminilake(DT)";bay="TOWER_2_Bay";mcpu="Intel Celeron J4125";eval "desc=\"[${MODEL}]:${platform},${bay},${mcpu}, \${MSG${tz}17}\"";;
    DS723+)      platform="r1000(DT)";bay="TOWER_2_Bay";mcpu="AMD Ryzen R1600";eval "desc=\"[${MODEL}]:${platform},${bay},${mcpu}, \${MSG${tz}20}\"";;
    DS918+)      platform="apollolake";bay="TOWER_4_Bay";mcpu="Intel Celeron J3455";eval "desc=\"[${MODEL}]:${platform},${bay},${mcpu}, \${MSG${tz}17}\"";;    
    DS920+)      platform="geminilake(DT)";bay="TOWER_4_Bay";mcpu="Intel Celeron J4125";eval "desc=\"[${MODEL}]:${platform},${bay},${mcpu}, \${MSG${tz}17}\"";;
    DS923+)      platform="r1000(DT)";bay="TOWER_4_Bay";mcpu="AMD Ryzen R1600";eval "desc=\"[${MODEL}]:${platform},${bay},${mcpu}, \${MSG${tz}20}\"";;
    DVA1622)     platform="geminilake(DT)";bay="TOWER_2_Bay";mcpu="Intel Celeron J4125";eval "desc=\"[${MODEL}]:${platform},${bay},${mcpu}, \${MSG${tz}17}, \${MSG${tz}21}\"";;
    DS1819+)     platform="denverton";bay="TOWER_8_Bay";mcpu="Intel Atom C3538";eval "desc=\"[${MODEL}]:${platform},${bay},${mcpu}, \${MSG${tz}23}, \${MSG${tz}25}, \${MSG${tz}21}\"";;
    DS2419+)     platform="denverton";bay="TOWER_12_Bay";mcpu="Intel Atom C3538";eval "desc=\"[${MODEL}]:${platform},${bay},${mcpu}, \${MSG${tz}23}, \${MSG${tz}25}, \${MSG${tz}21}\"";;    
    DVA3219)     platform="denverton";bay="TOWER_4_Bay";mcpu="Intel Atom C3538";eval "desc=\"[${MODEL}]:${platform},${bay},${mcpu}, \${MSG${tz}23}, \${MSG${tz}25}, \${MSG${tz}21}\"";;    
    DVA3221)     platform="denverton";bay="TOWER_4_Bay";mcpu="Intel Atom C3538";eval "desc=\"[${MODEL}]:${platform},${bay},${mcpu}, \${MSG${tz}23}, \${MSG${tz}24}, \${MSG${tz}21}\"";;    
    FS2500)      platform="v1000(DT)";bay="RACK_12_Bay_2";mcpu="AMD Ryzen V1780B";eval "desc=\"[${MODEL}]:${platform},${bay},${mcpu}, \${MSG${tz}22}\"";;
    RS1221+)     platform="v1000(DT)";bay="RACK_8_Bay";mcpu="AMD Ryzen V1500B";eval "desc=\"[${MODEL}]:${platform},${bay},${mcpu}, \${MSG${tz}22}\"";;    
    RS2423+)     platform="v1000(DT)";bay="RACK_12_Bay";mcpu="AMD Ryzen V1500B";eval "desc=\"[${MODEL}]:${platform},${bay},${mcpu}, \${MSG${tz}22}\"";;        
    RS3618xs)    platform="broadwell";bay="RACK_12_Bay";mcpu="Intel Xeon D-1521";eval "desc=\"[${MODEL}]:${platform},${bay},${mcpu}, \${MSG${tz}16}\"";;
    RS3621xs+)   platform="broadwellnk";bay="RACK_12_Bay";mcpu="Intel Xeon D-1541";eval "desc=\"[${MODEL}]:${platform},${bay},${mcpu}, \${MSG${tz}16}\"";;    
    RS4021xs+)   platform="broadwellnk";bay="RACK_16_Bay";mcpu="Intel Xeon D-1541";eval "desc=\"[${MODEL}]:${platform},${bay},${mcpu}, \${MSG${tz}16}\"";;
    #RS1619xs+)   platform="broadwellnk";bay="RACK_16_Bay";mcpu="Intel Xeon D-1541";eval "desc=\"[${MODEL}]:${platform},${bay},${mcpu}, \${MSG${tz}16}\"";;
    SA6400)      platform="epyc7002(DT)";bay="RACK_12_Bay";mcpu="AMD EPYC 7272";eval "desc=\"[${MODEL}]:${platform},${bay},${mcpu} \"";;
  esac

  if [ $(echo ${platform} | grep "(DT)" | wc -l) -gt 0 ]; then
    eval "MSG00=\"\${MSG${tz}00}\""
  else
    MSG00="\n"
  fi  
  
  result="${MSG00}${desc}"
  echo "${platform} : ${bay} : ${mcpu}"
}

# Set Storage Panel Size
function storagepanel() {

  BAYSIZE="${bay}"
  dialog --backtitle "`backtitle`" --default-item "${BAYSIZE}" --no-items \
    --menu "Choose a Panel Size" 0 0 0 "TOWER_1_Bay" "TOWER_2_Bay" "TOWER_4_Bay" "TOWER_4_Bay_J" \
        "TOWER_4_Bay_S" "TOWER_5_Bay" "TOWER_6_Bay" "TOWER_8_Bay" "TOWER_12_Bay" \
        "RACK_2_Bay" "RACK_4_Bay" "RACK_8_Bay" "RACK_10_Bay" \
                "RACK_12_Bay" "RACK_12_Bay_2" "RACK_16_Bay" "RACK_20_Bay" "RACK_24_Bay" "RACK_60_Bay" \
    2>${TMP_PATH}/resp
  [ $? -ne 0 ] && return
  resp=$(<${TMP_PATH}/resp)
  [ -z "${resp}" ] && return 

  BAYSIZE="`<${TMP_PATH}/resp`"
  writeConfigKey "general" "bay" "${BAYSIZE}"
  bay="${BAYSIZE}"
  
}

###############################################################################
# Shows menu to user type one or generate randomly
function serialMenu() {
  eval "MSG30=\"\${MSG${tz}30}\""
  eval "MSG31=\"\${MSG${tz}31}\""  
  while true; do
    dialog --clear --backtitle "`backtitle`" \
      --menu "Choose a option" 0 0 0 \
      a "${MSG30}" \
      m "${MSG31}" \
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
      SERIAL=`./sngen.sh "${MODEL}"-"${BUILD}"`
      break
    fi
  done
  SN="${SERIAL}"
  writeConfigKey "extra_cmdline" "sn" "${SN}"
}

###############################################################################
# Shows menu to generate randomly or to get realmac
function macMenu() {
  eval "MSG32=\"\${MSG${tz}32}\""
  eval "MSG33=\"\${MSG${tz}33}\""
  eval "MSG34=\"\${MSG${tz}34}\""  
  while true; do
    dialog --clear --backtitle "`backtitle`" \
      --menu "Choose a option" 0 0 0 \
      c "${MSG32}" \
      d "${MSG33}" \
      m "${MSG34}" \
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

function prevent() {

    prevent_init="ON"
    echo "Enable SataPortMap/DiskIdxMap initialization protection"
    echo "press any key to continue..."
    read answer
  
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
  SN="$(jq -r -e '.extra_cmdline.sn' $USER_CONFIG_FILE)"
  MACADDR1="$(jq -r -e '.extra_cmdline.mac1' $USER_CONFIG_FILE)"
  MACADDR2="$(jq -r -e '.extra_cmdline.mac2' $USER_CONFIG_FILE)"
  MACADDR3="$(jq -r -e '.extra_cmdline.mac3' $USER_CONFIG_FILE)"
  MACADDR4="$(jq -r -e '.extra_cmdline.mac4' $USER_CONFIG_FILE)"
  NETNUM"=$(jq -r -e '.extra_cmdline.netif_num' $USER_CONFIG_FILE)"
}

###############################################################################
# view linuxrc.syno.log file with textbox
function viewerrorlog() {

  if [ -f "/mnt/${loaderdisk}1/logs/jr/linuxrc.syno.log" ]; then

    while true; do
      dialog --backtitle "`backtitle`" --title "View linuxrc.syno.log file" \
        --textbox "/mnt/${loaderdisk}1/logs/jr/linuxrc.syno.log" 0 0 
      [ $? -eq 0 ] && break
    done
    
  else

    echo "/mnt/${loaderdisk}1/logs/jr/linuxrc.syno.log file not found!"
    echo "press any key to continue..."
    read answer
  
  fi

  return 0
}

function checkUserConfig() {

  if [ ! -n "${SN}" ]; then
    eval "echo \${MSG${tz}36}"
    eval "echo \${MSG${tz}35}"
    read answer
    return 1     
  fi
  
  if [ ! -n "${MACADDR1}" ]; then
    eval "echo \${MSG${tz}37}"
    eval "echo \${MSG${tz}35}"
    read answer
    return 1     
  fi

  netif_num=$(jq -r -e '.extra_cmdline.netif_num' $USER_CONFIG_FILE)
  netif_num_cnt=$(cat $USER_CONFIG_FILE | grep \"mac | wc -l)
                    
  if [ $netif_num != $netif_num_cnt ]; then
    echo "netif_num = ${netif_num}"
    echo "number of mac addresses = ${netif_num_cnt}"       
    eval "echo \${MSG${tz}38}"
    eval "echo \${MSG${tz}35}"
    read answer
    return 1     
  fi  

  if [ "$netif_num" == "2" ]; then
    if [ "$MACADDR1" == "$MACADDR2" ]; then
      echo "mac1 and mac2 cannot be set identically"
      read answer    
      return 1
    fi
  elif [ "$netif_num" == "3" ]; then
    if [ "$MACADDR1" == "$MACADDR2" ]||[ "$MACADDR1" == "$MACADDR3" ]||[ "$MACADDR2" == "$MACADDR3" ]; then
      echo "mac1, mac2 and mac3 cannot have the same value"
      read answer    
      return 1
    fi
  elif [ "$netif_num" == "4" ]; then
    if [ "$MACADDR1" == "$MACADDR2" ]||[ "$MACADDR1" == "$MACADDR3" ]||[ "$MACADDR1" == "$MACADDR4" ]||[ "$MACADDR2" == "$MACADDR3" ]||[ "$MACADDR2" == "$MACADDR4" ]||[ "$MACADDR3" == "$MACADDR4" ]; then
      echo "mac1, mac2, mac3 and mac4 cannot have the same value"
      read answer    
      return 1
    fi
  fi

}

###############################################################################
# Where the magic happens!
function make() {

  checkUserConfig 
  if [ $? -ne 0 ]; then
    dialog --backtitle "`backtitle`" --title "Error loader building" 0 0 #--textbox "${LOG_FILE}" 0 0      
    return 1  
  fi

  usbidentify
  clear

  if [ "${prevent_init}" = "OFF" ]; then
    my "${MODEL}"-"${BUILD}" noconfig "${1}" | tee "/home/tc/zlastbuild.log"
  else
    my "${MODEL}"-"${BUILD}" noconfig "${1}" prevent_init | tee "/home/tc/zlastbuild.log"
  fi 

  if  [ -f /home/tc/custom-module/redpill.ko ]; then
    echo "Removing redpill.ko ..."
    rm -rf /home/tc/custom-module/redpill.ko
  fi

  if [ $? -ne 0 ]; then
    dialog --backtitle "`backtitle`" --title "Error loader building" 0 0 #--textbox "${LOG_FILE}" 0 0    
    return 1
  fi

st "finishloader" "Loader build status" "Finished building the loader"  
  echo "Ready!"
  echo "press any key to continue..."
  read answer
  rm -f /home/tc/buildstatus  
  return 0
}

###############################################################################
# Post Update for jot mode 
function postupdate() {
  my "${MODEL}" postupdate | tee "/home/tc/zpostupdate.log"
  echo "press any key to continue..."
  read answer
  return 0
}

function writexsession() {

  echo "Inject urxvt menu.sh into /home/tc/.xsession."

  sed -i "/locale/d" .xsession
  sed -i "/utf8/d" .xsession
  sed -i "/UTF-8/d" .xsession
  sed -i "/aterm/d" .xsession
  sed -i "/urxvt/d" .xsession

  echo "export LANG=${ucode}.UTF-8" >> .xsession
  echo "export LC_ALL=${ucode}.UTF-8" >> .xsession
  echo "[ ! -d /usr/lib/locale ] && sudo mkdir /usr/lib/locale &" >> .xsession
  echo "sudo localedef -c -i ${ucode} -f UTF-8 ${ucode}.UTF-8" >> .xsession
  echo "sudo localedef -f UTF-8 -i ${ucode} ${ucode}.UTF-8" >> .xsession

  echo "urxvt -geometry 78x32+10+0 -fg orange -title \"TCRP-mshell urxvt Menu\" -e /home/tc/menu.sh &" >> .xsession  
  sed -i "/rploader/d" .xsession
  echo "aterm -geometry 78x32+525+0 -fg yellow -title \"TCRP Monitor\" -e /home/tc/monitor.sh &" >> .xsession
  echo "aterm -geometry 78x25+10+430 -title \"TCRP Build Status\" -e /home/tc/ntp.sh &" >> .xsession
  echo "aterm -geometry 78x25+525+430 -fg green -title \"TCRP Extra Terminal\" &" >> .xsession
}

###############################################################################
# Shows available language to user choose one
function langMenu() {

  dialog --backtitle "`backtitle`" --default-item "${LAYOUT}" --no-items \
    --menu "Choose a language" 0 0 0 "English" "한국어" "日本語" "中文" "Русский" \
    "Français" "Deutsch" "Español" "Italiano" "brasileiro" \
    "Magyar" "bahasa_Indonesia" "Türkçe" "हिंदी" "عربي" \
    "አማርኛ" "ไทย" \
    2>${TMP_PATH}/resp
    
  [ $? -ne 0 ] && return
  resp=$(<${TMP_PATH}/resp)
  [ -z "${resp}" ] && return  
  
  case `<"${TMP_PATH}/resp"` in
    English) tz="US"; ucode="en_US";;
    한국어) tz="KR"; ucode="ko_KR";;
    日本語) tz="JP"; ucode="ja_JP";;
    中文) tz="CN"; ucode="zh_CN";;
    Русский) tz="RU"; ucode="ru_RU";;
    Français) tz="FR"; ucode="fr_FR";;
    Deutsch) tz="DE"; ucode="de_DE";;
    Español) tz="ES"; ucode="es_ES";;
    Italiano) tz="IT"; ucode="it_IT";;
    brasileiro) tz="BR"; ucode="pt_BR";;
    Magyar) tz="HU"; ucode="hu_HU";;
    bahasa_Indonesia) tz="ID"; ucode="id_ID";;
    Türkçe) tz="TR"; ucode="tr_TR";;
    हिंदी) tz="IN"; ucode="hi_IN";;
    عربي) tz="EG"; ucode="ar_EG";;
    አማርኛ) tz="ET"; ucode="am_ET";;
    ไทย) tz="TH"; ucode="th_TH";;
  esac

  export LANG=${ucode}.UTF-8
  export LC_ALL=${ucode}.UTF-8
  set -o allexport
  
  [ ! -d /usr/lib/locale ] && sudo mkdir /usr/lib/locale
  sudo localedef -c -i ${ucode} -f UTF-8 ${ucode}.UTF-8
  sudo localedef -f UTF-8 -i ${ucode} ${ucode}.UTF-8
  
  writeConfigKey "general" "ucode" "${ucode}"  
  writexsession

  tz="US"
  load_us
  
  setSuggest $MODEL
  
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
  sed -i "/loadkmap/d" /opt/bootsync.sh
  echo "loadkmap < /usr/share/kmap/${LAYOUT}/${KEYMAP}.kmap &" >> /opt/bootsync.sh
  echo 'Y'|rploader backup
  
  echo
  echo "Since the keymap has been changed,"
  restart
}

function erasedisk() {
  ./edisk.sh
  echo "press any key to continue..."
  read answer
  return 0
}

function backup() {

  echo "Cleaning redpill-load/cache directory for backup!"
  if [ -d /home/tc/old ]; then
    rm -rf /home/tc/old
  fi
  if [ -f /home/tc/oldpat.tar.gz ]; then
    rm -f /home/tc/oldpat.tar.gz
  fi  
  if [ -d /home/tc/redpill-load/cache ]; then
    rm -f /home/tc/redpill-load/cache/*
  fi  
  if [ -f /home/tc/custom-module ]; then
    rm -f /home/tc/custom-module
  fi

  echo "y"|rploader backup
  echo "press any key to continue..."
  read answer
  return 0
}

function burnloader() {

  tcrpdev=/dev/$(mount | grep -i optional | grep cde | awk -F / '{print $3}' | uniq | cut -c 1-3)
  listusb=()
  listusb+=( $(lsblk -o PATH,ROTA,TRAN | grep '/dev/sd' | grep -v ${tcrpdev} | grep -E '(1 usb|0 sata)' | awk '{print $1}' ) )

  if [ ${#listusb[@]} -eq 0 ]; then 
    echo "No Available USB or SSD, press any key continue..."
    read answer                       
    return 0   
  fi

  dialog --backtitle "`backtitle`" --no-items --colors \
    --menu "Choose a USB Stick or SSD for New Loader\n\Z1(Caution!) In the case of SSD, be sure to check whether it is a cache or data disk.\Zn" 0 0 0 "${listusb[@]}" \
    2>${TMP_PATH}/resp
  [ $? -ne 0 ] && return
  resp=$(<${TMP_PATH}/resp)
  [ -z "${resp}" ] && return 

  loaderdev="`<${TMP_PATH}/resp`"

  #leftshm=$(df --block-size=1 | grep /dev/shm | awk '{print $4}')
  #if [ 0${leftshm} -gt 02147483648 ]; then
    imgversion="${VERSION}"
  #else 
  #  imgversion="v1.0.1.0"
  #fi

  echo "Downloading TCRP-mshell ${imgversion} img file..."  
  if [ -f /tmp/tinycore-redpill.${imgversion}.m-shell.img ]; then
    echo "TCRP-mshell ${imgversion} img file already exists. Skip download..."  
  else
    curl -kL# https://github.com/PeterSuh-Q3/tinycore-redpill/releases/download/${imgversion}/tinycore-redpill.${imgversion}.m-shell.img.gz -o /tmp/tinycore-redpill.${imgversion}.m-shell.img.gz
    gunzip /tmp/tinycore-redpill.${imgversion}.m-shell.img.gz
  fi

  echo "Please wait a moment. Burning ${imgversion} image is in progress..."  
  sudo dd if=/tmp/tinycore-redpill.${imgversion}.m-shell.img of=${loaderdev} status=progress bs=4M
  echo "Burning Image ${imgversion} completed, press any key to continue..."
  read answer
  return 0
}

function showsata () {
      MSG=""
      NUMPORTS=0
      [ $(lspci -d ::106 | wc -l) -gt 0 ] && MSG+="\nATA:\n"
      for PCI in $(lspci -d ::106 | awk '{print $1}'); do
        NAME=$(lspci -s "${PCI}" | sed "s/\ .*://")
        MSG+="\Zb${NAME}\Zn\nPorts: "
        PORTS=$(ls -l /sys/class/scsi_host | grep "${PCI}" | awk -F'/' '{print $NF}' | sed 's/host//' | sort -n)
        for P in ${PORTS}; do
      # Skip for Unused Port
          if [ "$(dmesg | grep 'SATA link down' | grep ata$((${P} + 1)): | wc -l)" -eq 0 ]; then          
          DUMMY="$([ "$(cat /sys/class/scsi_host/host${P}/ahci_port_cmd)" = "0" ] && echo 1 || echo 2)"
        if [ "$(cat /sys/class/scsi_host/host${P}/ahci_port_cmd)" = "0" ]; then
          MSG+="\Z1$(printf "%02d" ${P})\Zn "
        else
              if lsscsi -b | grep -v - | grep -q "\[${P}:"; then
            MSG+="\Z2$(printf "%02d" ${P})\Zn "
              else
                MSG+="$(printf "%02d" ${P}) "
              fi
        fi  
          fi
          NUMPORTS=$((${NUMPORTS} + 1))
        done
        MSG+="\n"
      done
      [ $(lspci -d ::107 | wc -l) -gt 0 ] && MSG+="\nLSI:\n"
      for PCI in $(lspci -d ::107 | awk '{print $1}'); do
        NAME=$(lspci -s "${PCI}" | sed "s/\ .*://")
        PORT=$(ls -l /sys/class/scsi_host | grep "${PCI}" | awk -F'/' '{print $NF}' | sed 's/host//' | sort -n)
        PORTNUM=$(lsscsi -b | grep -v - | grep "\[${PORT}:" | wc -l)
        MSG+="\Zb${NAME}\Zn\nNumber: ${PORTNUM}\n"
        NUMPORTS=$((${NUMPORTS} + ${PORTNUM}))
      done
      [ $(ls -l /sys/class/scsi_host | grep usb | wc -l) -gt 0 ] && MSG+="\nUSB:\n"
      for PCI in $(lspci -d ::c03 | awk '{print $1}'); do
        NAME=$(lspci -s "${PCI}" | sed "s/\ .*://")
        PORT=$(ls -l /sys/class/scsi_host | grep "${PCI}" | awk -F'/' '{print $NF}' | sed 's/host//' | sort -n)
        PORTNUM=$(lsscsi -b | grep -v - | grep "\[${PORT}:" | wc -l)
        [ ${PORTNUM} -eq 0 ] && continue
        MSG+="\Zb${NAME}\Zn\nNumber: ${PORTNUM}\n"
        NUMPORTS=$((${NUMPORTS} + ${PORTNUM}))
      done
      [ $(lspci -d ::108 | wc -l) -gt 0 ] && MSG+="\nNVME:\n"
      for PCI in $(lspci -d ::108 | awk '{print $1}'); do
        NAME=$(lspci -s "${PCI}" | sed "s/\ .*://")
        PORT=$(ls -l /sys/class/nvme | grep "${PCI}" | awk -F'/' '{print $NF}' | sed 's/nvme//' | sort -n)
        PORTNUM=$(lsscsi -b | grep -v - | grep "\[N:${PORT}:" | wc -l)
        MSG+="\Zb${NAME}\Zn\nNumber: ${PORTNUM}\n"
        NUMPORTS=$((${NUMPORTS} + ${PORTNUM}))
      done
      MSG+="\n"
      MSG+="$(printf "\nTotal of ports: %s\n")" "${NUMPORTS}"
      MSG+="\nPorts with color \Z1red\Zn as DUMMY, color \Z2\Zbgreen\Zn has drive connected."
      dialog --backtitle "$(backtitle)" --colors --title "Show SATA(s) # ports and drives" \
        --msgbox "${MSG}" 0 0
}

function cloneloader() {

  tcrpdev=/dev/$(mount | grep -i optional | grep cde | awk -F / '{print $3}' | uniq | cut -c 1-3)
  listusb=()
  listusb+=( $(lsblk -o PATH,ROTA,TRAN | grep '/dev/sd' | grep -v ${tcrpdev} | grep -E '(1 usb|0 sata)' | awk '{print $1}' ) )

  if [ ${#listusb[@]} -eq 0 ]; then 
    echo "No Available USB or SSD, press any key continue..."
    read answer                       
    return 0   
  fi

  dialog --backtitle "`backtitle`" --no-items --colors \
    --menu "Choose a USB Stick or SSD for Clone Loader\n\Z1(Caution!) In the case of SSD, be sure to check whether it is a cache or data disk.\Zn" 0 0 0 "${listusb[@]}" \
    2>${TMP_PATH}/resp
  [ $? -ne 0 ] && return
  resp=$(<${TMP_PATH}/resp)
  [ -z "${resp}" ] && return 

  loaderdev="`<${TMP_PATH}/resp`"

  echo "Backup Current TCRP-mshell loader to img file..."  
  sudo dd if=${tcrpdev}1 of=${TMP_PATH}/tinycore-redpill.backup_p1.img status=progress bs=4M
  sudo dd if=${tcrpdev}2 of=${TMP_PATH}/tinycore-redpill.backup_p2.img status=progress bs=4M
  sudo dd if=${tcrpdev}3 of=${TMP_PATH}/tinycore-redpill.backup_p3.img status=progress bs=4M
  
  echo "Please wait a moment. Cloning is in progress..."  
  sudo dd if=${TMP_PATH}/tinycore-redpill.backup_p1.img of=${loaderdev}1 status=progress bs=4M
  sudo dd if=${TMP_PATH}/tinycore-redpill.backup_p2.img of=${loaderdev}2 status=progress bs=4M
  sudo dd if=${TMP_PATH}/tinycore-redpill.backup_p3.img of=${loaderdev}3 status=progress bs=4M
  
  echo "Cloning completed, press any key to continue..."
  read answer
  return 0
}

function tcrpfriendentry_hdd() {
    
    cat <<EOF
menuentry 'Tiny Core Friend ${MODEL} ${BUILD} Update 0 ${DMPM}' {
        savedefault
    set root=(hd0,msdos${1})
        echo Loading Linux...
        linux /bzImage-friend loglevel=3 waitusb=5 vga=791 net.ifnames=0 biosdevname=0 console=ttyS0,115200n8
        echo Loading initramfs...
        initrd /initrd-friend
        echo Booting TinyCore Friend
}
EOF

}

function add-addon() {

  [ "${1}" = "mac-spoof" ] && echo -n "(Warning) Enabling mac-spoof may compromise San Manager and VMM. Do you still want to add it? [yY/nN] : "
  [ "${1}" = "nvmesystem" ] && echo -n "Would you like to add nvmesystem? [yY/nN] : "
  [ "${1}" = "dbgutils" ] && echo -n "Would you like to add dbgutils for error analysis? [yY/nN] : "
  [ "${1}" = "sortnetif" ] && echo -n "Would you like to add sortnetif? [yY/nN] : "
  
  readanswer    
  if [ "${answer}" = "Y" ] || [ "${answer}" = "y" ]; then    
    jsonfile=$(jq ". |= .+ {\"${1}\": \"https://raw.githubusercontent.com/PeterSuh-Q3/tcrp-addons/master/${1}/rpext-index.json\"}" ~/redpill-load/bundled-exts.json) && echo $jsonfile | jq . > ~/redpill-load/bundled-exts.json    
  fi
}

function del-addon() {
  jsonfile=$(jq "del(.[\"${1}\"])" ~/redpill-load/bundled-exts.json) && echo $jsonfile | jq . > ~/redpill-load/bundled-exts.json
}


function returnto() {
    echo "${1}"
    read answer
    cd ~
}

function spacechk() {
  # Discover file size
  SPACEUSED=$(df --block-size=1 | awk '/'${1}'/{print $3}') # Check disk space used
  SPACELEFT=$(df --block-size=1 | awk '/'${2}'/{print $4}') # Check disk space left

  SPACEUSED_FORMATTED=$(printf "%'d" "${SPACEUSED}")
  SPACELEFT_FORMATTED=$(printf "%'d" "${SPACELEFT}")
  SPACEUSED_MB=$((SPACEUSED / 1024 / 1024))
  SPACELEFT_MB=$((SPACELEFT / 1024 / 1024))    

  echo "SPACEUSED = ${SPACEUSED_FORMATTED} bytes (${SPACEUSED_MB} MB)"
  echo "SPACELEFT = ${SPACELEFT_FORMATTED} bytes (${SPACELEFT_MB} MB)"
}

function wr_part1() {

    mdisk=$(echo "${edisk}" | sed 's/dev/mnt/')
    [ ! -d "${mdisk}${1}" ] && sudo mkdir "${mdisk}${1}"
      while true; do
        sleep 1
        echo "Mounting ${edisk}${1} ..."
        sudo mount "${edisk}${1}" "${mdisk}${1}"
        [ $( mount | grep "${edisk}${1}" | wc -l ) -gt 0 ] && break
    done
    sudo rm -rf "${mdisk}${1}"/*

    diskid=$(echo "${edisk}" | sed 's#/dev/##')
    spacechk "${loaderdisk}1" "${diskid}${1}"
    FILESIZE1=$(ls -l /mnt/${loaderdisk}3/bzImage-friend | awk '{print$5}')
    FILESIZE2=$(ls -l /mnt/${loaderdisk}3/initrd-friend | awk '{print$5}')
    
    a_num=$(echo $FILESIZE1 | bc)
    b_num=$(echo $FILESIZE2 | bc)
    c_num=$(echo $SPACEUSED | bc)
    t_num=$(($a_num + $b_num + $c_num))
    
    TOTALUSED=$(echo $t_num)
    TOTALUSED_FORMATTED=$(printf "%'d" "${TOTALUSED}")
    TOTALUSED_MB=$((TOTALUSED / 1024 / 1024))
    echo "TOTALUSED = ${TOTALUSED_FORMATTED} bytes (${TOTALUSED_MB} MB)"

    ZIMAGESIZE=""
    if [ 0${TOTALUSED} -ge 0${SPACELEFT} ]; then
        ZIMAGESIZE=$(ls -l /mnt/${loaderdisk}1/zImage | awk '{print$5}')
        z_num=$(echo $ZIMAGESIZE | bc)
        t_num=$(($t_num - $z_num))

        TOTALUSED=$(echo $t_num)
        TOTALUSED_FORMATTED=$(printf "%'d" "${TOTALUSED}")
        TOTALUSED_MB=$((TOTALUSED / 1024 / 1024))
        echo "FIXED TOTALUSED = ${TOTALUSED_FORMATTED} bytes (${TOTALUSED_MB} MB)"
        [ 0${TOTALUSED} -ge 0${SPACELEFT} ] && sudo umount "${mdisk}${1}" && returnto "Source Partition is too big ${TOTALUSED}, Space left ${SPACELEFT} !!!. Stop processing!!! " && false
    fi

    if [ -z ${ZIMAGESIZE} ]; then
        cd /mnt/${loaderdisk}1 && sudo find . | sudo cpio -pdm "${mdisk}${1}" 2>/dev/null
    else
        cd /mnt/${loaderdisk}1 && sudo find . -not -name "zImage" | sudo cpio -pdm "${mdisk}${1}" 2>/dev/null
    fi

    echo "Modifying grub.cfg for new loader boot..."
    sudo sed -i '61,$d' "${mdisk}${1}"/boot/grub/grub.cfg
    tcrpfriendentry_hdd ${1} | sudo tee --append "${mdisk}${1}"/boot/grub/grub.cfg

    sudo cp -vf /mnt/${loaderdisk}3/bzImage-friend  "${mdisk}${1}"
    sudo cp -vf /mnt/${loaderdisk}3/initrd-friend  "${mdisk}${1}"

    sudo mkdir -p /usr/local/share/locale
    sudo grub-install --target=x86_64-efi --boot-directory="${mdisk}${1}"/boot --efi-directory="${mdisk}${1}" --removable
    [ $? -ne 0 ] && returnto "excute grub-install ${mdisk}${1} failed. Stop processing!!! " && false
    sudo grub-install --target=i386-pc --boot-directory="${mdisk}${1}"/boot "${edisk}"
    [ $? -ne 0 ] && returnto "excute grub-install ${mdisk}${1} failed. Stop processing!!! " && false
    true
}

function wr_part2() {

    mdisk=$(echo "${edisk}" | sed 's/dev/mnt/')
    [ ! -d "${mdisk}${1}" ] && sudo mkdir "${mdisk}${1}"
    while true; do
        sleep 1
        echo "Mounting ${edisk}${1} ..."
        sudo mount "${edisk}${1}" "${mdisk}${1}"
        [ $( mount | grep "${edisk}${1}" | wc -l ) -gt 0 ] && break
    done
    sudo rm -rf "${mdisk}${1}"/*
        
    spacechk "${loaderdisk}2" "${diskid}${1}"
    [ 0${SPACEUSED} -ge 0${SPACELEFT} ] && sudo umount "${mdisk}${1}" && returnto "Source Partition is too big ${SPACEUSED}, Space left ${SPACELEFT} !!!. Stop processing!!! " && false
  
    cd /mnt/${loaderdisk}2 && sudo find . | sudo cpio -pdm "${mdisk}${1}" 2>/dev/null
    true
}

function wr_part3() {

    mdisk=$(echo "${edisk}" | sed 's/dev/mnt/')

    [ ! -d "${mdisk}${1}" ] && sudo mkdir "${mdisk}${1}"
    while true; do
        sleep 1
        echo "Mounting ${edisk}${1} ..."
        sudo mount "${edisk}${1}" "${mdisk}${1}"
        [ $( mount | grep "${edisk}${1}" | wc -l ) -gt 0 ] && break
    done
    sudo rm -rf "${mdisk}${1}"/*

    diskid=$(echo "${edisk}" | sed 's#/dev/##')
    spacechk "${loaderdisk}3" "${diskid}${1}"
    FILESIZE1=$(ls -l /mnt/${loaderdisk}3/zImage-dsm | awk '{print$5}')
    FILESIZE2=$(ls -l /mnt/${loaderdisk}3/initrd-dsm | awk '{print$5}')
    
    a_num=$(echo $FILESIZE1 | bc)
    b_num=$(echo $FILESIZE2 | bc)
    t_num=$(($a_num + $b_num + 20000 ))
    TOTALUSED=$(echo $t_num)

    TOTALUSED_FORMATTED=$(printf "%'d" "${TOTALUSED}")
    TOTALUSED_MB=$((TOTALUSED / 1024 / 1024))
    echo "TOTALUSED = ${TOTALUSED_FORMATTED} bytes (${TOTALUSED_MB} MB)"
    
    [ 0${TOTALUSED} -ge 0${SPACELEFT} ] && sudo umount "${mdisk}${1}" && returnto "Source Partition is too big ${TOTALUSED}, Space left ${SPACELEFT} !!!. Stop processing!!! " && false

    cd /mnt/${loaderdisk}3 && find . -name "*dsm*" -o -name "*user_config*" | sudo cpio -pdm "${mdisk}${1}" 2>/dev/null
    true
}

function prepare_grub() {

    tce-load -i grub2-multi 
    if [ $? -eq 0 ]; then
        echo "Install grub2-multi OK !!!"
    else
        tce-load -iw grub2-multi
        [ $? -ne 0 ] && returnto "Install grub2-multi failed. Stop processing!!! " && false
    fi
    #sudo echo "grub2-multi.tcz" >> /mnt/${tcrppart}/cde/onboot.lst

    true
}

function prepare_img() {

    echo "Downloading tempelete disk image to ${imgpath}..."
    imgpath="/dev/shm/boot-image-to-hdd.img"  
    if [ -f ${imgpath} ]; then
        echo "Image file ${imgpath} Already Exist..."
     else
        sudo curl -kL# https://github.com/PeterSuh-Q3/rp-ext/releases/download/temp/boot-image-to-hdd.img.gz -o "${imgpath}.gz"
        [ $? -ne 0 ] && returnto "Download failed. Stop processing!!! ${imgpath}" && false
        echo "Unpacking image ${imgpath}..."
        sudo gunzip -f "${imgpath}.gz"
    fi

     if [ -z "$(losetup | grep -i ${imgpath})" ]; then
        if [ ! -n "$(losetup -j ${imgpath} | awk '{print $1}' | sed -e 's/://')" ]; then
            echo -n "Setting up ${imgpath} loop -> "
            sudo losetup -fP ${imgpath}
            [ $? -ne 0 ] && returnto "Mount loop device for ${imgpath} failed. Stop processing!!! " && false
        else
            echo -n "Loop device exists..."
        fi
    fi
    loopdev=$(losetup -j ${imgpath} | awk '{print $1}' | sed -e 's/://')
    echo "$loopdev"
 
    true
}

function get_disk_type_cnt() {

    RAID_CNT="$(sudo fdisk -l | grep "fd Linux raid autodetect" | grep ${1} | wc -l )"
    DOS_CNT="$(sudo fdisk -l | grep "83 Linux" | grep ${1} | wc -l )"
    W95_CNT="$(sudo fdisk -l | grep "W95 Ext" | grep ${1} | wc -l )" 
    EXT_CNT="$(sudo fdisk -l | grep "Extended" | grep ${1} | wc -l )" 
    # for FIXED Linux RAID
    RAID_FIX_CNT="$(sudo fdisk -l | grep "Linux RAID" | grep ${1} | wc -l )"
    RAID_FIX_P5_SD_CNT="$(sudo fdisk -l | grep "Linux RAID" | grep ${1}5 | wc -l )"
    RAID_FIX_P5_SATA_CNT="$(sudo fdisk -l | grep "Linux RAID" | grep ${1}p5 | wc -l )"
    RAID_FIX_P5_CNT=`expr ${RAID_FIX_P5_SD_CNT} + ${RAID_FIX_P5_SATA_CNT}`
    if [ ${RAID_FIX_CNT} -eq 3 ] && [ ${RAID_FIX_P5_CNT} -eq 1 ]; then
        RAID_CNT="3"
        W95_CNT="1"
    fi
    if [ "${2}" = "Y" ]; then
        echo "RAID_CNT=${RAID_CNT}"
        echo "DOS_CNT=${DOS_CNT}"
        echo "W95_CNT=${W95_CNT}"
        echo "EXT_CNT=${EXT_CNT}"
    fi    
             
}

function inject_loader() {

  if [ ! -f /mnt/${loaderdisk}3/bzImage-friend ] || [ ! -f /mnt/${loaderdisk}3/initrd-friend ] || [ ! -f /mnt/${loaderdisk}3/zImage-dsm ] || [ ! -f /mnt/${loaderdisk}3/initrd-dsm ] || [ ! -f /mnt/${loaderdisk}3/user_config.json ] || [ ! $(grep -i "Tiny Core Friend" /mnt/${loaderdisk}1/boot/grub/grub.cfg | wc -l) -eq 1 ]; then
    returnto "The loader has not been built yet. Start with the build.... Stop processing!!! " && return
  fi

  plat=$(cat /mnt/${loaderdisk}1/GRUB_VER | grep PLATFORM | cut -d "=" -f2 | tr '[:upper:]' '[:lower:]' | sed 's/"//g')
  [ "${plat}" = "epyc7002" ] &&    returnto "Epyc7002 like SA6400 is not supported... Stop processing!!! " && return

  #[ "$MACHINE" = "VIRTUAL" ] &&    returnto "Virtual system environment is not supported. Two or more BASIC type hard disks are required on bare metal. (SSD not possible)... Stop processing!!! " && return

  IDX=0
  for edisk in $(sudo fdisk -l | grep "Disk /dev/sd" | awk '{print $2}' | sed 's/://' ); do
      get_disk_type_cnt "${edisk}" "N"
      if [ "${RAID_CNT}" -eq 3 ] && [ "${DOS_CNT}" -eq 0 ] && [ "${W95_CNT}" -eq 0 ]; then
          echo "This is BASIC or JBOD Type Hard Disk. $edisk"
          IDX=$((${IDX} + 1))
      fi
  done

  SHR=0
  for edisk in $(sudo fdisk -l | grep "Disk /dev/sd" | awk '{print $2}' | sed 's/://' ); do
      get_disk_type_cnt "${edisk}" "N"
      if [ "${RAID_CNT}" -eq 3 ] && [ "${DOS_CNT}" -eq 0 ] && [ "${W95_CNT}" -eq 1 ]; then
          echo "This is SHR Type Hard Disk. $edisk"
          SHR=$((${SHR} + 1))
      fi
  done

  IDX_EX=0
  for edisk in $(sudo fdisk -l | grep "Disk /dev/sd" | awk '{print $2}' | sed 's/://' ); do
      get_disk_type_cnt "${edisk}" "N"
      if [ "${RAID_CNT}" -eq 3 ] && [ "${DOS_CNT}" -eq 2 ] && [ "${W95_CNT}" -eq 0 ]; then
          echo "This is BASIC Type Hard Disk and Has synoboot1 and synoboot2 Boot Partition  $edisk"
          IDX_EX=$((${IDX_EX} + 1))
      fi
  done
  for edisk in $(sudo fdisk -l | grep "Disk /dev/sd" | awk '{print $2}' | sed 's/://' ); do
      get_disk_type_cnt "${edisk}" "N"
      if [ "${RAID_CNT}" -eq 3 ] && [ "${DOS_CNT}" -eq 1 ] && [ "${W95_CNT}" -eq 0 ]; then
            if [ $(blkid | grep ${edisk} | grep "6234-C863" | wc -l ) -eq 1 ]; then
              echo "This is BASIC Type Hard Disk and Has synoboot3 Boot Partition $edisk"
              IDX_EX=$((${IDX_EX} + 1))
            fi    
      fi
  done

  SHR_EX=0
  for edisk in $(sudo fdisk -l | grep "Disk /dev/sd" | awk '{print $2}' | sed 's/://' ); do
      get_disk_type_cnt "${edisk}" "N"
      if [ "${RAID_CNT}" -eq 3 ] && [ "${DOS_CNT}" -eq 2 ] && [ "${W95_CNT}" -eq 1 ]; then
          echo "This is SHR Type Hard Disk and Has synoboot1 and synoboot2 Boot Partition $edisk"
          SHR_EX=$((${SHR_EX} + 1))
      fi
  done
  for edisk in $(sudo fdisk -l | grep "Disk /dev/sd" | awk '{print $2}' | sed 's/://' ); do
      get_disk_type_cnt "${edisk}" "N"
      if [ "${RAID_CNT}" -eq 3 ] && [ "${DOS_CNT}" -eq 1 ] && [ "${W95_CNT}" -eq 1 ]; then
            if [ $(blkid | grep ${edisk} | grep "6234-C863" | wc -l ) -eq 1 ]; then
              echo "This is SHR Type Hard Disk and Has synoboot3 Boot Partition $edisk"
              SHR_EX=$((${SHR_EX} + 1))
          fi
      fi
  done

  do_ex_first=""    
  if [ ${IDX_EX} -eq 2 ] || [ `expr ${IDX_EX} + ${SHR_EX}` -eq 2 ]; then
    echo "There is at least one BASIC or SHR type disk each with an injected bootloader...OK"
    do_ex_first="Y"
  elif [ ${IDX} -eq 2 ] || [ `expr ${IDX} + ${SHR}` -gt 1 ]; then
    echo "There is at least one disk of type BASIC or SHR...OK"
    if [ -z "${do_ex_first}" ]; then
      do_ex_first="N"
    fi
  #elif [ ${IDX_EX} -eq 0 ] && [ ${SHR_EX} -gt 1 ]; then 
  else
      echo "IDX = ${IDX}, SHR = ${SHR}, IDX_EX = ${IDX_EX}, SHR_EX=${SHR_EX}"
      returnto "There is not enough Type Disk. Function Exit now!!! Press any key to continue..." && return  
  fi

  echo "do_ex_first = ${do_ex_first}"
  
# [ ${IDX} -gt 1 ] BASIC more than 2 
# [ ${IDX} -gt 0 && ${SHR} -gt 0 ] BASIC more than 1 && SHR more than 1
# [ ${IDX} -eq 0 && ${SHR} -gt 2 ] BASIC 0 && SHR more than 3
echo -n "(Warning) Do you want to port the bootloader to Syno disk? [yY/nN] : "
readanswer
if [ "${answer}" = "Y" ] || [ "${answer}" = "y" ]; then
    tce-load -i bc
    if [ $? -eq 0 ]; then
        echo "Install bc OK !!!"
    else
        tce-load -iw bc
        [ $? -ne 0 ] && returnto "Install grub2-multi failed. Stop processing!!! " && return
    fi
    tce-load -i dosfstools
    if [ $? -eq 0 ]; then
        echo "Install dosfstools OK !!!"
    else
        tce-load -iw dosfstools
        [ $? -ne 0 ] && returnto "Install dosfstools failed. Stop processing!!! " && false
    fi

    if [ "${do_ex_first}" = "N" ]; then
        if [ ${IDX} -eq 2 ] || [ `expr ${IDX} + ${SHR}` -gt 1 ]; then
            echo "New bootloader injection (including fdisk partition creation)..."

            BOOTMAKE=""
              SYNOP3MAKE=""
            for edisk in $(sudo fdisk -l | grep "Disk /dev/sd" | awk '{print $2}' | sed 's/://' ); do
         
                model=$(lsblk -o PATH,MODEL | grep $edisk | head -1)
                get_disk_type_cnt "${edisk}" "Y"
                
                if [ "${DOS_CNT}" -eq 3 ]; then
                    echo "Skip this disk as it is a loader disk. $model"
                    continue
                elif [ -z "${BOOTMAKE}" ] && [ "${RAID_CNT}" -eq 3 ] && [ "${DOS_CNT}" -eq 0 ]; then

                    prepare_grub
                    [ $? -ne 0 ] && return

                    if [ "${W95_CNT}" -eq 1 ]; then
                        # SHR OR RAID can make primary partition
                        echo "Create primary and logical partitions on 1st disk. ${model}"
                        last_sector="20979712"
                    
                        # +127M
                        echo "Create partitions on 1st disks... $edisk"
                        echo -e "n\n\n$last_sector\n+127M\nw\n" | sudo fdisk "${edisk}"
                        [ $? -ne 0 ] && returnto "make primary partition on ${edisk} failed. Stop processing!!! " && return
                        sleep 1
      
                        echo -e "a\n4\nw" | sudo fdisk "${edisk}"
                        [ $? -ne 0 ] && returnto "activate partition on ${edisk} failed. Stop processing!!! " && return
                        sleep 1
                      
                        last_sector="$(sudo fdisk -l "${edisk}" | grep "${edisk}5" | awk '{print $3}')"
                        last_sector=$((${last_sector} + 1))
                        echo "1st disk's part 6 last sector is $last_sector"
                        
                        # +26M
                        echo -e "n\n$last_sector\n+26M\nw\n" | sudo fdisk "${edisk}"
                        [ $? -ne 0 ] && returnto "make logical partition on ${edisk} failed. Stop processing!!! " && return
                        sleep 1
 
                        sudo mkfs.vfat -F16 "${edisk}4"
                        synop1=${edisk}4 
                        wr_part1 "4"
                        [ $? -ne 0 ] && return
     
                    else
                        if [ "${EXT_CNT}" -eq 0 ]; then
                            # BASIC OR JBOD can make extend partition
                            echo "Create extended and logical partitions on 1st disk. ${model}"
                            last_sector="20979712"
                            echo "1st disk's last sector is $last_sector"
                            echo -e "n\ne\n$last_sector\n\n\nw" | sudo fdisk "${edisk}"
                            [ $? -ne 0 ] && returnto "make extend partition on ${edisk} failed. Stop processing!!! " && return
                            sleep 2
                        fi
     
                        # +98M
                        echo "Create partitions on 1st disks... $edisk"
                        echo -e "n\n\n+98M\nw\n" | sudo fdisk "${edisk}"
                        [ $? -ne 0 ] && returnto "make logical partition on ${edisk} failed. Stop processing!!! " && return
                        sleep 1
      
                        echo -e "a\n5\nw" | sudo fdisk "${edisk}"
                        [ $? -ne 0 ] && returnto "activate partition on ${edisk} failed. Stop processing!!! " && return
                        sleep 1
       
                        # +26M
                        echo -e "n\n\n+26M\nw\n" | sudo fdisk "${edisk}"
                        [ $? -ne 0 ] && returnto "make logical partition on ${edisk} failed. Stop processing!!! " && return
                        sleep 1
 
                        sudo mkfs.vfat -F16 "${edisk}5"
                        synop1=${edisk}5
                        wr_part1 "5"
                        [ $? -ne 0 ] && return

                    fi 
                    sudo mkfs.vfat -F16 "${edisk}6"
                    synop2=${edisk}6    
                    wr_part2 "6"
                    [ $? -ne 0 ] && return

                    BOOTMAKE="YES"
                    continue

                elif [ -z "${SYNOP3MAKE}" ] && [ "${RAID_CNT}" -gt 2 ] && [ "${DOS_CNT}" -eq 0 ]; then

                     if [ $(blkid | grep "6234-C863" | wc -l) -eq 1 ]; then
                          # + 128M
                        echo "Create partitions on 2nd disks... $edisk"
                        last_sector="20979712"
                         echo "2nd disk's last sector is $last_sector"
                           echo -e "n\np\n$last_sector\n\n\nw" | sudo fdisk "${edisk}"
                        [ $? -ne 0 ] && returnto "make extend partition on ${edisk} failed. Stop processing!!! " && return
                        
                        # + 127M logical
                        #echo -e "n\n\n\nw\n" | sudo fdisk "${edisk}"
                        #[ $? -ne 0 ] && returnto "make logical partition on ${edisk} failed. Stop processing!!! " && return
    
                        sleep 1
    
                        #prepare_img
                        sudo mkfs.vfat -i 6234C863 -F16 "${edisk}4"
                        [ $? -ne 0 ] && return
       
                        #sudo dd if="${loopdev}p3" of="${edisk}4"
    
                        wr_part3 "4"
                        [ $? -ne 0 ] && return
    
                        synop3=${edisk}4
                    else
                        echo "The synoboot3 was already made!!!"
                        continue
                       fi
                    SYNOP3MAKE="YES"
                    continue
           
                else
                    echo "The conditions for adding a fat partition are not met (3 rd, 0 83). $model"
                    continue
                fi
            done
        fi
    elif [ "${do_ex_first}" = "Y" ]; then
        if [ ${IDX_EX} -eq 2 ] || [ `expr ${IDX_EX} + ${SHR_EX}` -eq 2 ]; then
            echo "Reinject bootloader (into existing partition)..."
            for edisk in $(sudo fdisk -l | grep "Disk /dev/sd" | awk '{print $2}' | sed 's/://' ); do
         
                model=$(lsblk -o PATH,MODEL | grep $edisk | head -1)
                get_disk_type_cnt "${edisk}" "Y"
                
                echo
                if [ "${DOS_CNT}" -eq 3 ]; then
                    echo "Skip this disk as it is a loader disk. $model"
                    continue
                elif [ "${RAID_CNT}" -eq 3 ] && [ "${DOS_CNT}" -eq 2 ]; then

                    prepare_grub
                    [ $? -ne 0 ] && return
                    if [ "${W95_CNT}" -eq 1 ]; then
                        synop1=${edisk}4                    
                        wr_part1 "4"
                    else 
                        synop1=${edisk}5
                        wr_part1 "5"
                    fi

                       synop2=${edisk}6                 
                    wr_part2 "6"
                    [ $? -ne 0 ] && return
                    continue
              
                elif [ "${RAID_CNT}" -gt 2 ] && [ "${DOS_CNT}" -eq 1 ]; then
                
                      if [ $(blkid | grep ${edisk} | grep "6234-C863" | wc -l ) -eq 1 ]; then

                        #prepare_img
                        #[ $? -ne 0 ] && return
                   
                        wr_part3 "4"
                        [ $? -ne 0 ] && return
    
                        synop3=${edisk}4
                    fi
                    continue
                fi
            done
        fi
    fi 
    #sudo losetup -d ${loopdev}
    #[ -z "$(losetup | grep -i ${imgpath})" ] && echo "boot-image-to-hdd.img losetup OK !!!"
    sync
    echo "unmount synoboot partitions...${synop1}, ${synop2}, ${synop3}"
    sudo umount ${synop1} && sudo umount ${synop2} && sudo umount ${synop3}
    returnto "The entire process of injecting the boot loader into the disk has been completed! Press any key to continue..." && return
fi

}

function packing_loader() {

    echo "Would you like to pack your loader for a remote TCRP? [Yy/Nn] "
    readanswer
    if [ -n "$answer" ] && [ "$answer" = "Y" ] || [ "$answer" = "y" ]; then
        mkdir -p /dev/shm/p1
        mkdir -p /dev/shm/p2
        mkdir -p /dev/shm/p3
        cp -vf /mnt/${loaderdisk}1/GRUB_VER /mnt/${loaderdisk}1/zImage /dev/shm/p1
        cp -vf /mnt/${loaderdisk}2/GRUB_VER /mnt/${loaderdisk}2/zImage /mnt/${loaderdisk}2/rd.gz /mnt/${loaderdisk}2/grub_cksum.syno /dev/shm/p2
        cp -vf /mnt/${loaderdisk}3/custom.gz /mnt/${loaderdisk}3/initrd-dsm /mnt/${loaderdisk}3/rd.gz /mnt/${loaderdisk}3/zImage-dsm /mnt/${loaderdisk}3/user_config.json /dev/shm/p3
        tar -zcvf /home/tc/remote.updatepack.${MODEL}-${BUILD}.tgz -C /dev/shm ./p1 ./p2 ./p3
    else
        echo "OK, the package has been canceled."
    fi    
    returnto "The entire process of packing the boot loader has been completed! Press any key to continue..." && return    

}

function satadom_edit() {
    sed -i "s/synoboot_satadom=[^ ]*/synoboot_satadom=${1}/g" /home/tc/user_config.json
    sudo sed -i "s/synoboot_satadom=[^ ]*/synoboot_satadom=${1}/g" /mnt/${tcrppart}/user_config.json
}

function additional() {

  [ $(cat ~/redpill-load/bundled-exts.json | jq 'has("nvmesystem")') = true ] && nvmes="Remove" || nvmes="Add"
  [ $(cat ~/redpill-load/bundled-exts.json | jq 'has("mac-spoof")') = true ] && spoof="Remove" || spoof="Add"
  [ $(cat ~/redpill-load/bundled-exts.json | jq 'has("dbgutils")') = true ] && dbgutils="Remove" || dbgutils="Add"
  [ $(cat ~/redpill-load/bundled-exts.json | jq 'has("sortnetif")') = true ] && sortnetif="Remove" || sortnetif="Add"  

  [ $(cat /home/tc/user_config.json | grep "synoboot_satadom=2" | wc -l) -eq 1 ] && DOMKIND="Native" || DOMKIND="Fake"
  [ "${DISABLEI915}" = "ON" ] && DISPLAYI915="OFF" || DISPLAYI915="ON"

  eval "MSG50=\"\${MSG${tz}50}\""
  eval "MSG51=\"\${MSG${tz}51}\""
  eval "MSG52=\"\${MSG${tz}52}\""
  eval "MSG53=\"\${MSG${tz}53}\""
  eval "MSG54=\"\${MSG${tz}54}\""
  eval "MSG55=\"\${MSG${tz}55}\""
  eval "MSG12=\"\${MSG${tz}12}\""

  while true; do
    eval "echo \"a \\\"${spoof} ${MSG50}\\\"\"" > "${TMP_PATH}/menua"
    eval "echo \"w \\\"${nvmes} nvmesystem Addon\\\"\"" >> "${TMP_PATH}/menua"
    eval "echo \"y \\\"${dbgutils} dbgutils Addon\\\"\"" >> "${TMP_PATH}/menua"
    eval "echo \"x \\\"${sortnetif} sortnetif Addon\\\"\"" >> "${TMP_PATH}/menua"
    [ "${BUS}" != "usb" ] && eval "echo \"j \\\"Active ${DOMKIND} Satadom Option\\\"\"" >> "${TMP_PATH}/menua"
    eval "echo \"z \\\"Disable i915 module ${DISPLAYI915}\\\"\"" >> "${TMP_PATH}/menua"
    eval "echo \"b \\\"${MSG51}\\\"\"" >> "${TMP_PATH}/menua"
    eval "echo \"c \\\"${MSG52}\\\"\"" >> "${TMP_PATH}/menua"
    eval "echo \"d \\\"${MSG53}\\\"\"" >> "${TMP_PATH}/menua"
    eval "echo \"e \\\"${MSG54}\\\"\"" >> "${TMP_PATH}/menua"
    eval "echo \"f \\\"${MSG55}\\\"\"" >> "${TMP_PATH}/menua"
    eval "echo \"g \\\"${MSG12}\\\"\"" >> "${TMP_PATH}/menua"
    eval "echo \"h \\\"Inject Bootloader to Syno DISK\\\"\"" >> "${TMP_PATH}/menua"
    eval "echo \"i \\\"Packing loader file for remote update\\\"\"" >> "${TMP_PATH}/menua"
    dialog --clear --backtitle "`backtitle`" --colors \
      --menu "Choose a option" 0 0 0 --file "${TMP_PATH}/menua" \
    2>${TMP_PATH}/resp
    [ $? -ne 0 ] && return
    resp=$(<${TMP_PATH}/resp)
    [ -z "${resp}" ] && return
    if [ "${resp}" = "a" ]; then
      [ "${spoof}" = "Add" ] && add-addon "mac-spoof" || del-addon "mac-spoof"
      [ $(cat ~/redpill-load/bundled-exts.json | jq 'has("mac-spoof")') = true ] && spoof="Remove" || spoof="Add"
    elif [ "${resp}" = "w" ]; then
      [ "${nvmes}" = "Add" ] && add-addon "nvmesystem" || del-addon "nvmesystem"
      [ $(cat ~/redpill-load/bundled-exts.json | jq 'has("nvmesystem")') = true ] && nvmes="Remove" || nvmes="Add"      
    elif [ "${resp}" = "y" ]; then 
      [ "${dbgutils}" = "Add" ] && add-addon "dbgutils" || del-addon "dbgutils"
        [ $(cat ~/redpill-load/bundled-exts.json | jq 'has("dbgutils")') = true ] && dbgutils="Remove" || dbgutils="Add"
    elif [ "${resp}" = "x" ]; then 
      [ "${sortnetif}" = "Add" ] && add-addon "sortnetif" || del-addon "sortnetif"
        [ $(cat ~/redpill-load/bundled-exts.json | jq 'has("sortnetif")') = true ] && sortnetif="Remove" || sortnetif="Add"
    elif [ "${resp}" = "j" ]; then 
      if [ "${DOMKIND}" == "Native" ]; then
        satadom_edit 1
        DOMKIND="Fake"
      else
        satadom_edit 2
        DOMKIND="Native"
      fi   
    elif [ "${resp}" = "z" ]; then
      if [ ${platform} = "geminilake(DT)" ] || [ ${platform} = "epyc7002(DT)" ] || [ ${platform} = "apollolake" ]; then
        #[ "$MACHINE" = "VIRTUAL" ] && echo "VIRTUAL Machine is not supported..." && read answer && continue
        writeConfigKey "general" "disablei915" "${DISPLAYI915}"
        DISABLEI915=$(jq -r -e '.general.disablei915' "$USER_CONFIG_FILE")
        [ "${DISABLEI915}" = "ON" ] && DISPLAYI915="OFF" || DISPLAYI915="ON"
      else    
        echo "This platform is not supported..." && read answer && continue
      fi 
    elif [ "${resp}" = "b" ]; then
      prevent
    elif [ "${resp}" = "c" ]; then
      showsata
    elif [ "${resp}" = "d" ]; then
      viewerrorlog
    elif [ "${resp}" = "e" ]; then
      burnloader
    elif [ "${resp}" = "f" ]; then
      cloneloader
    elif [ "${resp}" = "g" ]; then
      erasedisk
    elif [ "${resp}" = "h" ]; then
      inject_loader
    elif [ "${resp}" = "i" ]; then
      packing_loader
    fi
  done
}

# Main loop

# add git download 2023.10.18
cd /dev/shm
if [ -d /dev/shm/tcrp-addons ]; then
  echo "tcrp-addons already downloaded!"    
else    
  git clone --depth=1 "https://github.com/PeterSuh-Q3/tcrp-addons.git"
  if [ $? -ne 0 ]; then
    git clone --depth=1 "https://gitea.com/PeterSuh-Q3/tcrp-addons.git"
    git clone --depth=1 "https://gitea.com/PeterSuh-Q3/tcrp-modules.git"
  fi    
fi
#if [ -d /dev/shm/tcrp-modules ]; then
#  echo "tcrp-modules already downloaded!"    
#else    
#  git clone --depth=1 "https://github.com/PeterSuh-Q3/tcrp-modules.git"
#  if [ $? -ne 0 ]; then
#    git clone --depth=1 "https://gitea.com/PeterSuh-Q3/tcrp-modules.git"
#  fi    
#fi
cd /home/tc

#Start Locale Setting process
#Get Langugae code & country code
echo "current ucode = ${ucode}"

country=$(curl -s ipinfo.io | grep country | awk '{print $2}' | cut -c 2-3 )

if [ "${ucode}" == "null" ]; then 
  lcode="${country}"
else
  if [ "${lcode}" != "${country}" ]; then
    echo -n "Country code ${country} has been detected. Do you want to change your locale settings to ${country}? [yY/nN] : "
    readanswer    
    if [ "${answer}" = "Y" ] || [ "${answer}" = "y" ]; then    
      lcode="${country}"
    fi
  fi    
fi

echo "current lcode = ${lcode}"

tz="${lcode}"

case "${lcode}" in
US) ucode="en_US";;
KR) ucode="ko_KR";;
JP) ucode="ja_JP";;
CN) ucode="zh_CN";;
RU) ucode="ru_RU";;
FR) ucode="fr_FR";;
DE) ucode="de_DE";;
ES) ucode="es_ES";;
IT) ucode="it_IT";;
BR) ucode="pt_BR";;
EG) ucode="ar_EG";;
IN) ucode="hi_IN";;
HU) ucode="hu_HU";;
ID) ucode="id_ID";;
TR) ucode="tr_TR";;

*) lcode="US"; ucode="en_US";;
esac
writeConfigKey "general" "ucode" "${ucode}"

sed -i "s/screen_color = (CYAN,GREEN,ON)/screen_color = (CYAN,BLUE,ON)/g" ~/.dialogrc

writexsession

if [ $(cat /mnt/${tcrppart}/cde/onboot.lst|grep gettext | wc -w) -eq 0 ]; then
    tce-load -wi gettext
    if [ $? -eq 0 ]; then
        echo "Download gettext.tcz OK, Permanent installation progress !!!"
        sudo cp -f /tmp/tce/optional/* /mnt/${tcrppart}/cde/optional
        sudo echo "" >> /mnt/${tcrppart}/cde/onboot.lst
        sudo echo "gettext.tcz" >> /mnt/${tcrppart}/cde/onboot.lst
        sudo echo "ncursesw.tcz" >> /mnt/${tcrppart}/cde/onboot.lst
        echo 'Y'|rploader backup
        echo "You have finished installing TC gettext package."
        restart
     fi
fi

#if [ $(cat /mnt/${tcrppart}/cde/onboot.lst|grep dejavu-fonts-ttf | wc -w) -eq 0 ]; then
#    tce-load -wi dejavu-fonts-ttf notosansdevanagari-fonts-ttf setfont
#    if [ $? -eq 0 ]; then
#        echo "Download dejavu-fonts-ttf.tcz, notosansdevanagari-fonts-ttf, setfont OK, Permanent installation progress !!!"
#        sudo cp -f /tmp/tce/optional/* /mnt/${tcrppart}/cde/optional
#        sudo echo "" >> /mnt/${tcrppart}/cde/onboot.lst
#        sudo echo "dejavu-fonts-ttf.tcz" >> /mnt/${tcrppart}/cde/onboot.lst
#        sudo echo "notosansdevanagari-fonts-ttf.tcz" >> /mnt/${tcrppart}/cde/onboot.lst     
#        sudo echo "setfont.tcz" >> /mnt/${tcrppart}/cde/onboot.lst     
#        echo 'Y'|rploader backup
#        echo "You have finished installing TC dejavu-fonts-ttf package."
#        restart
#     fi
#fi

if [ $(cat /mnt/${tcrppart}/cde/onboot.lst|grep rxvt | wc -w) -eq 0 ]; then
    tce-load -wi glibc_apps glibc_i18n_locale unifont rxvt
    if [ $? -eq 0 ]; then
        echo "Download glibc_apps.tcz and glibc_i18n_locale.tcz OK, Permanent installation progress !!!"
        sudo cp -f /tmp/tce/optional/* /mnt/${tcrppart}/cde/optional
        sudo echo "" >> /mnt/${tcrppart}/cde/onboot.lst
        sudo echo "glibc_apps.tcz" >> /mnt/${tcrppart}/cde/onboot.lst
        sudo echo "glibc_i18n_locale.tcz" >> /mnt/${tcrppart}/cde/onboot.lst
        sudo echo "unifont.tcz" >> /mnt/${tcrppart}/cde/onboot.lst
        sudo echo "rxvt.tcz" >> /mnt/${tcrppart}/cde/onboot.lst
        echo 'Y'|rploader backup

        echo
        echo "You have finished installing TC Unicode package and urxvt."
        restart
    else
        echo "Download glibc_apps.tcz, glibc_i18n_locale.tcz FAIL !!!"
    fi
fi

if [ $(cat /mnt/${tcrppart}/cde/onboot.lst|grep rxvt | wc -w) -gt 0 ]; then
# for 2Byte Language
  [ ! -d /usr/lib/locale ] && sudo mkdir /usr/lib/locale
  export LANG=${ucode}.UTF-8
  export LC_ALL=${ucode}.UTF-8
  set -o allexport
  
  sudo localedef -c -i ${ucode} -f UTF-8 ${ucode}.UTF-8
  sudo localedef -f UTF-8 -i ${ucode} ${ucode}.UTF-8

  if [ $(cat ~/.Xdefaults|grep "URxvt.background: black" | wc -w) -eq 0 ]; then
    echo "URxvt.background: black"  >> ~/.Xdefaults
  fi
  if [ $(cat ~/.Xdefaults|grep "URxvt.foreground: white" | wc -w) -eq 0 ]; then    
    echo "URxvt.foreground: white"  >> ~/.Xdefaults
  fi
  if [ $(cat ~/.Xdefaults|grep "URxvt.transparent: true" | wc -w) -eq 0 ]; then    
    echo "URxvt.transparent: true"  >> ~/.Xdefaults
  fi
  if [ $(cat ~/.Xdefaults|grep "URxvt\*encoding: UTF-8" | wc -w) -eq 0 ]; then    
    echo "URxvt*encoding: UTF-8"  >> ~/.Xdefaults
  else
    sed -i "/URxvt\*encoding:/d" ~/.Xdefaults
    echo "URxvt*encoding: UTF-8"  >> ~/.Xdefaults  
  fi
  if [ $(cat ~/.Xdefaults|grep "URxvt\*inputMethod: ibus" | wc -w) -eq 0 ]; then    
    echo "URxvt*inputMethod: ibus"  >> ~/.Xdefaults
  fi
  if [ $(cat ~/.Xdefaults|grep "URxvt\*locale:" | wc -w) -eq 0 ]; then    
    echo "URxvt*locale: ${ucode}.UTF-8"  >> ~/.Xdefaults
  else
    sed -i "/URxvt\*locale:/d" ~/.Xdefaults
    echo "URxvt*locale: ${ucode}.UTF-8"  >> ~/.Xdefaults
  fi
fi

#gettext
[ ! -f /home/tc/lang.tgz ] && curl -kLO# https://raw.githubusercontent.com/PeterSuh-Q3/tinycore-redpill/master/lang.tgz
[ ! -d "/usr/local/share/locale" ] && sudo mkdir -p "/usr/local/share/locale"
sudo tar -xzvf lang.tgz -C /usr/local/share/locale
locale
#End Locale Setting process
export TEXTDOMAINDIR="/usr/local/share/locale"
set -o allexport
tz="US"
load_us

if [ $(cat /mnt/${tcrppart}/cde/onboot.lst|grep "kmaps.tczglibc_apps.tcz" | wc -w) -gt 0 ]; then
    sudo sed -i "/kmaps.tczglibc_apps.tcz/d" /mnt/${tcrppart}/cde/onboot.lst    
    sudo echo "glibc_apps.tcz" >> /mnt/${tcrppart}/cde/onboot.lst
    sudo echo "kmaps.tcz" >> /mnt/${tcrppart}/cde/onboot.lst
    echo 'Y'|rploader backup
    
    echo
    echo "We have finished bug fix for /mnt/${tcrppart}/cde/onboot.lst."
    restart
fi    

if [ "${KEYMAP}" = "null" ]; then
    LAYOUT="qwerty"
    KEYMAP="us"
    writeConfigKey "general" "layout" "${LAYOUT}"
    writeConfigKey "general" "keymap" "${KEYMAP}"
fi

if [ "${DMPM}" = "null" ]; then
    DMPM="DDSML"
    writeConfigKey "general" "devmod" "${DMPM}"          
fi

if [ "${LDRMODE}" = "null" ]; then
    LDRMODE="FRIEND"
    writeConfigKey "general" "loadermode" "${LDRMODE}"          
fi

if [ "${DISABLEI915}" = "null" ]; then
    DISABLEI915="OFF"
    writeConfigKey "general" "disablei915" "${DISABLEI915}"
fi

# Get actual IP
IP="$(ifconfig | grep -i "inet " | grep -v "127.0.0.1" | awk '{print $2}' | cut -c 6- )"

  if [ ! -n "${MACADDR1}" ]; then
    MACADDR1=`./macgen.sh "realmac" "eth0" ${MODEL}`
    writeConfigKey "extra_cmdline" "mac1" "${MACADDR1}"
  fi
if [ $(ifconfig | grep eth1 | wc -l) -gt 0 ]; then
  MACADDR2="$(jq -r -e '.extra_cmdline.mac2' $USER_CONFIG_FILE)"
  NETNUM="2"
  if [ ! -n "${MACADDR2}" ]; then
    MACADDR2=`./macgen.sh "realmac" "eth1" ${MODEL}`
    writeConfigKey "extra_cmdline" "mac2" "${MACADDR2}"
  fi
fi  
if [ $(ifconfig | grep eth2 | wc -l) -gt 0 ]; then
  MACADDR3="$(jq -r -e '.extra_cmdline.mac3' $USER_CONFIG_FILE)"
  NETNUM="3"
  if [ ! -n "${MACADDR3}" ]; then
    MACADDR3=`./macgen.sh "realmac" "eth2" ${MODEL}`
    writeConfigKey "extra_cmdline" "mac3" "${MACADDR3}"
  fi
fi  
if [ $(ifconfig | grep eth3 | wc -l) -gt 0 ]; then
  MACADDR4="$(jq -r -e '.extra_cmdline.mac4' $USER_CONFIG_FILE)"
  NETNUM="4"
  if [ ! -n "${MACADDR4}" ]; then
    MACADDR4=`./macgen.sh "realmac" "eth3" ${MODEL}`
    writeConfigKey "extra_cmdline" "mac4" "${MACADDR4}"
  fi
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

if [ $tcrppart == "mmc3" ]; then
    tcrppart="mmcblk0p3"
fi    

# Download dialog
if [ "$(which dialog)_" == "_" ]; then
    sudo curl -kL# https://raw.githubusercontent.com/PeterSuh-Q3/tinycore-redpill/master/tce/optional/dialog.tcz -o /mnt/${tcrppart}/cde/optional/dialog.tcz
    sudo curl -kL# https://raw.githubusercontent.com/PeterSuh-Q3/tinycore-redpill/master/tce/optional/dialog.tcz.dep -o /mnt/${tcrppart}/cde/optional/dialog.tcz.dep
    sudo curl -kL# https://raw.githubusercontent.com/PeterSuh-Q3/tinycore-redpill/master/tce/optional/dialog.tcz.md5.txt -o /mnt/${tcrppart}/cde/optional/dialog.tcz.md5.txt
    tce-load -i dialog
    if [ $? -eq 0 ]; then
        echo "Install dialog OK !!!"
    else
        tce-load -iw dialog
    fi
    sudo echo "dialog.tcz" >> /mnt/${tcrppart}/cde/onboot.lst
fi

# Download ntpclient
if [ "$(which ntpclient)_" == "_" ]; then
    echo "ntpclient does not exist, install from tinycore"
   tce-load -iw ntpclient 2>&1 >/dev/null
   sudo echo "ntpclient.tcz" >> /mnt/${tcrppart}/cde/onboot.lst
fi

# Download pigz
if [ "$(which pigz)_" == "_" ]; then
    echo "pigz does not exist, bringing over from repo"
    curl -skLO# https://raw.githubusercontent.com/PeterSuh-Q3/tinycore-redpill/master/tools/pigz
    chmod 700 pigz
    sudo mv -vf pigz /usr/local/bin/
fi

# Download dtc
if [ "$(which dtc)_" == "_" ]; then
    echo "dtc dos not exist, Downloading dtc binary"
    curl -skLO# https://raw.githubusercontent.com/PeterSuh-Q3/tinycore-redpill/master/tools/dtc
    chmod 700 dtc
    sudo mv -vf dtc /usr/local/bin/
fi   

# Download bspatch
if [ ! -f /usr/local/bspatch ]; then
    echo "bspatch does not exist, copy from tools"
    chmod 700 ~/tools/bspatch
    sudo cp -vf ~/tools/bspatch /usr/local/bin/
fi

# Download kmaps
if [ $(cat /mnt/${tcrppart}/cde/onboot.lst|grep kmaps | wc -w) -eq 0 ]; then
    sudo curl -kL# https://raw.githubusercontent.com/PeterSuh-Q3/tinycore-redpill/master/tce/optional/kmaps.tcz -o /mnt/${tcrppart}/cde/optional/kmaps.tcz
    sudo curl -kL# https://raw.githubusercontent.com/PeterSuh-Q3/tinycore-redpill/master/tce/optional/kmaps.tcz.md5.txt -o /mnt/${tcrppart}/cde/optional/kmaps.tcz.md5.txt
    tce-load -i kmaps
    if [ $? -eq 0 ]; then
        echo "Install kmaps OK !!!"
    else
        tce-load -iw kmaps
    fi
    sudo echo "kmaps.tcz" >> /mnt/${tcrppart}/cde/onboot.lst
fi

# Download firmware-broadcom_bnx2x
if [ $(cat /mnt/${tcrppart}/cde/onboot.lst|grep firmware-broadcom_bnx2x | wc -w) -eq 0 ]; then
    installtcz "firmware-broadcom_bnx2x.tcz"
    echo "Install firmware-broadcom_bnx2x OK !!!"
    echo "y"|rploader backup
    restart
fi

NEXT="m"
setSuggest $MODEL
bfbay=$(jq -r -e '.general.bay' "$USER_CONFIG_FILE")
if [ -n "${bfbay}" ]; then
  bay=${bfbay}
fi
writeConfigKey "general" "bay" "${bay}"

[ $(lspci -d ::107 | wc -l) -gt 0 ] && tce-load -iw scsi-6.1.2-tinycore64.tcz

# Until urxtv is available, Korean menu is used only on remote terminals.
while true; do
  eval "echo \"c \\\"\${MSG${tz}01}, (${DMPM})\\\"\""     > "${TMP_PATH}/menu" 
  eval "echo \"m \\\"\${MSG${tz}02}, (${MODEL})\\\"\""   >> "${TMP_PATH}/menu"
  if [ -n "${MODEL}" ]; then
    eval "echo \"s \\\"\${MSG${tz}03}\\\"\""             >> "${TMP_PATH}/menu"
    eval "echo \"a \\\"\${MSG${tz}04} 1\\\"\""           >> "${TMP_PATH}/menu"
    [ $(ifconfig | grep eth1 | wc -l) -gt 0 ] && eval "echo \"f \\\"\${MSG${tz}04} 2\\\"\""         >> "${TMP_PATH}/menu"
    [ $(ifconfig | grep eth2 | wc -l) -gt 0 ] && eval "echo \"g \\\"\${MSG${tz}04} 3\\\"\""         >> "${TMP_PATH}/menu"
    [ $(ifconfig | grep eth3 | wc -l) -gt 0 ] && eval "echo \"h \\\"\${MSG${tz}04} 4\\\"\""         >> "${TMP_PATH}/menu"
    [ "${CPU}" != "HP" ] && eval "echo \"z \\\"\${MSG${tz}06} (${LDRMODE})\\\"\""   >> "${TMP_PATH}/menu"
    eval "echo \"j \\\"\${MSG${tz}05} (${BUILD})\\\"\""     >> "${TMP_PATH}/menu"
    eval "echo \"p \\\"\${MSG${tz}18} (${BUILD}, ${LDRMODE})\\\"\""   >> "${TMP_PATH}/menu"      
  fi
  eval "echo \"u \\\"\${MSG${tz}10}\\\"\""               >> "${TMP_PATH}/menu"  
  eval "echo \"q \\\"\${MSG${tz}41} (${bay})\\\"\""      >> "${TMP_PATH}/menu"
  eval "echo \"l \\\"\${MSG${tz}39}\\\"\""               >> "${TMP_PATH}/menu"
  eval "echo \"k \\\"\${MSG${tz}11}\\\"\""               >> "${TMP_PATH}/menu"
  echo "n \"Additional Functions\""  >> "${TMP_PATH}/menu"  
  eval "echo \"b \\\"\${MSG${tz}13}\\\"\""               >> "${TMP_PATH}/menu"
  eval "echo \"r \\\"\${MSG${tz}14}\\\"\""               >> "${TMP_PATH}/menu"
  eval "echo \"e \\\"\${MSG${tz}15}\\\"\""               >> "${TMP_PATH}/menu"
  dialog --clear --default-item ${NEXT} --backtitle "`backtitle`" --colors \
    --menu "${result}" 0 0 0 --file "${TMP_PATH}/menu" \
    2>${TMP_PATH}/resp
  [ $? -ne 0 ] && break
  case `<"${TMP_PATH}/resp"` in
    n) additional;      NEXT="p" ;; 
    c) seleudev;        NEXT="m" ;;  
    m) modelMenu;       NEXT="s" ;;
    s) serialMenu;      NEXT="j" ;;
    a) macMenu "eth0"
    [ $(ifconfig | grep eth1 | wc -l) -gt 0 ] && NEXT="f" || NEXT="z" ;;
    f) macMenu "eth1"
    [ $(ifconfig | grep eth2 | wc -l) -gt 0 ] && NEXT="g" || NEXT="z" ;;
    g) macMenu "eth2"
    [ $(ifconfig | grep eth3 | wc -l) -gt 0 ] && NEXT="h" || NEXT="z" ;;
    h) macMenu "eth3";    NEXT="p" ;; 
    z) selectldrmode ;    NEXT="p" ;;
    j) selectversion ;    NEXT="p" ;; 
    p) [ "${LDRMODE}" == "FRIEND" ] && make "fri" "${prevent_init}" || make "jot" "${prevent_init}"
       NEXT="r" ;;
    u) editUserConfig;    NEXT="p" ;;
    q) storagepanel;      NEXT="p" ;;
    l) langMenu ;;
    k) keymapMenu ;;
    b) backup ;;
    r) restart ;;
    e) sudo poweroff ;;
  esac
done

clear
echo -e "Call \033[1;32m./menu.sh\033[0m to return to menu"
