#!/usr/bin/env bash

##### INCLUDES #####################################################################################################
#source /home/tc/menufunc.h
#####################################################################################################

TMP_PATH=/tmp
LOG_FILE="${TMP_PATH}/log.txt"
USER_CONFIG_FILE="/home/tc/user_config.json"

MODEL=$(jq -r -e '.general.model' "$USER_CONFIG_FILE")
BUILD=$(jq -r -e '.general.version' "$USER_CONFIG_FILE" | cut -c 7-)
SN=$(jq -r -e '.extra_cmdline.sn' "$USER_CONFIG_FILE")
MACADDR1=$(jq -r -e '.extra_cmdline.mac1' "$USER_CONFIG_FILE")
NETNUM="1"

LAYOUT=$(jq -r -e '.general.layout' "$USER_CONFIG_FILE")
KEYMAP=$(jq -r -e '.general.keymap' "$USER_CONFIG_FILE")

DMPM=$(jq -r -e '.general.devmod' "$USER_CONFIG_FILE")
LDRMODE=$(jq -r -e '.general.loadermode' "$USER_CONFIG_FILE")

### Messages Contents
## US
MSGUS00="Device-Tree[DT] Base Models & HBAs do not require SataPortMap,DiskIdxMap\nDT models do not support HBAs\n"
MSGUS01="Choose a Dev Mod handling method, EUDEV/DDSML"
MSGUS02="Choose a Synology Model"
MSGUS03="Choose a Synology Serial Number"
MSGUS04="Choose a mac address"
MSGUS05="Build the [TCRP JOT Mode] loader"
MSGUS06="Choose a loader Mode Current "
MSGUS07="Build the [TCRP ${LDRMODE} 7.1.1-42962] loader"
MSGUS08="Build the [TCRP FRIEND 7.0.1-42218] loader"
MSGUS09="Post Update for [TCRP JOT Mod]"
MSGUS10="Edit user config file manually"
MSGUS11="Choose a keymap"
MSGUS12="Erase Data DISK"
MSGUS13="Backup TCRP"
MSGUS14="Reboot"
MSGUS15="Exit"
MSGUS16="Max 24 Threads, any x86-64"
MSGUS17="Max 8 Threads, Haswell or later,iGPU Transcoding"
MSGUS18="HBA displays incorrect disk S/N"
MSGUS19="(DT,AMD Ryzen)"
MSGUS20="Max ? Threads, any x86-64"
MSGUS21="Have a camera license"
MSGUS22="Max 16 Threads, any x86-64"
MSGUS23="Max 16 Threads, Haswell or later"
MSGUS24="Nvidia GTX1650"
MSGUS25="Nvidia GTX1050Ti"
MSGUS26="EUDEV (enhanced user-space device)"
MSGUS27="DDSML (Detected Device Static Module Loading)"
MSGUS28="FRIEND (most recently stabilized)"
MSGUS29="JOT (The old way before friend)"
MSGUS30="Generate a random serial number"
MSGUS31="Enter a serial number"
MSGUS32="Get a real mac address"
MSGUS33="Generate a random mac address"
MSGUS34="Enter a mac address"
MSGUS35="press any key to continue..."
MSGUS36="Synology serial number not set. Check user_config.json again. Abort the loader build !!!!!!"
MSGUS37="The first MAC address is not set. Check user_config.json again. Abort the loader build !!!!!!"
MSGUS38="The netif_num and the number of mac addresses do not match. Check user_config.json again. Abort the loader build !!!!!!"
MSGUS39=""
MSGUS40=""

## KR
MSGKR00="Device-Tree[DT]모델과 HBA는 SataPortMap,DiskIdxMap 설정이 필요없습니다.\nDT모델은 HBA를 지원하지 않습니다.\n"
MSGKR01="커널모듈 처리방법 선택 EUDEV/DDSML"
MSGKR02="Synology 모델 선택"
MSGKR03="Synology S/N 선택"
MSGKR04="선택 Mac 주소 "
MSGKR05="[TCRP JOT Mode] 로더 빌드"
MSGKR06="로더모드 선택 현재"
MSGKR07="[TCRP ${LDRMODE} 7.1.1-42962] 로더 빌드"
MSGKR08="[TCRP FRIEND 7.0.1-42218] 로더 빌드"
MSGKR09="[TCRP JOT 모드]용 Post 업데이트"
MSGKR10="user_config.json 파일 편집"
MSGKR11="다국어 자판 지원용 키맵 선택"
MSGKR12="디스크 데이터 지우기"
MSGKR13="TCRP 백업"
MSGKR14="재부팅"
MSGKR15="종료"
MSGKR16="최대 24 스레드 지원, 인텔 x86-64"
MSGKR17="최대 8 스레드 지원, 인텔 4세대 하스웰 이후부터 지원,iGPU H/W 트랜스코딩"
MSGKR18="HBA 사용시 잘못된 디스크 S/N이 표시됨"
MSGKR19="(DT,AMD 라이젠)"
MSGKR20="최대 ? 스레드 지원, 인텔 x86-64"
MSGKR21="카메라 라이센스 있음"
MSGKR22="최대 16 스레드 지원, 인텔 x86-64"
MSGKR23="최대 16 스레드 지원, 인텔 4세대 하스웰 이후부터 지원"
MSGKR24="Nvidia GTX1650 H/W 가속지원"
MSGKR25="Nvidia GTX1050Ti H/W 가속지원"
MSGKR26="EUDEV (향상된 사용자 공간 장치)"
MSGKR27="DDSML (감지된 장치 정적 모듈 로드)"
MSGKR28="FRIEND (가장 최근에 안정화된 로더모드)"
MSGKR29="JOT (FRIEND 보다 옛날 로더모드)"
MSGKR30="시놀로지 랜덤 S/N 생성"
MSGKR31="시놀로지 S/N을 입력하세요"
MSGKR32="실제 MAC 주소 가져오기"
MSGKR33="랜덤 MAC 주소 생성"
MSGKR34="시놀로지 MAC 주소를 입력하세요"
MSGKR35="계속하려면 아무 키나 누르십시오..."
MSGKR36="Synology 일련 번호가 설정되지 않았습니다. user_config.json을 다시 확인하십시오. 로더 빌드를 중단합니다!!!!!!"
MSGKR37="첫 번째 MAC 주소가 설정되지 않았습니다. user_config.json을 다시 확인하십시오. 로더 빌드를 중단합니다!!!!!!"
MSGKR38="netif_num과 mac 주소 갯수가 일치하지 않습니다. user_config.json을 다시 확인하십시오. 로더 빌드를 중단합니다!!!!!!"
MSGKR39=""
MSGKR40=""


###############################################################################
# check VM or baremetal
function checkmachine() {

    if grep -q ^flags.*\ hypervisor\  /proc/cpuinfo; then
        MACHINE="VIRTUAL"
        HYPERVISOR=$(dmesg | grep -i "Hypervisor detected" | awk '{print $5}')
        echo "Machine is $MACHINE Hypervisor=$HYPERVISOR"
    fi
    
    if [ $(lspci -nn | grep -ie "\[0107\]" | wc -l) -gt 0 ]; then
        echo "Found SAS HBAs, Restrict use of DT Models."
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
    else
        if [ $(awk -F':' '/^model name/ {print $2}' /proc/cpuinfo | uniq | sed -e 's/^[ \t]*//' | grep -e N36L -e N40L -e N54L | wc -l) -gt 0 ]; then
	    CPU="HP"
            LDRMODE="JOT"
            writeConfigKey "general" "loadermode" "${LDRMODE}"          
	else
            CPU="AMD"
        fi	    
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
  BACKTITLE="TCRP 0.9.4.0-1"
  BACKTITLE+=" ${DMPM}"
  BACKTITLE+=" ${LDRMODE}"
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
# Shows available between EUDEV and DDSML
function seleudev() {
  eval "MSG26=\"\${MSG${tz}26}\""
  eval "MSG27=\"\${MSG${tz}27}\""  
  while true; do
    dialog --clear --backtitle "`backtitle`" \
      --menu "Choose a option" 0 0 0 \
      e "${MSG26}" \
      d "${MSG27}" \
    2>${TMP_PATH}/resp
    [ $? -ne 0 ] && return
    resp=$(<${TMP_PATH}/resp)
    [ -z "${resp}" ] && return
    if [ "${resp}" = "e" ]; then
      DMPM="EUDEV"
      break
    elif [ "${resp}" = "d" ]; then
      DMPM="DDSML"
      break
    fi
  done

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
# Shows available models to user choose one
function modelMenu() {

  M_GRP1="DS3622xs+ DS1621xs+ RS4021xs+ DS3617xs RS3618xs"
  M_GRP2="DS3615xs"
  M_GRP3="DVA3221 DVA3219"
  M_GRP4="DS918+ DS1019+"
  M_GRP5="DS923+ DS723+"
  M_GRP6="DS1621+ DS2422+ FS2500"
  M_GRP7="DS920+ DS1520+ DVA1622"
  
RESTRICT=1
while true; do
  echo "" > "${TMP_PATH}/mdl"
  
  if [ "$HBADETECT" = "ON" ]; then
    if [ $threads -gt 16 ]; then
      echo "${M_GRP1}" >> "${TMP_PATH}/mdl"
    elif [ $threads -gt 8 ]; then
      if [ "${AFTERHASWELL}" == "OFF" ]; then
        echo "${M_GRP1}" >> "${TMP_PATH}/mdl"
        echo "${M_GRP2}" >> "${TMP_PATH}/mdl"
      else  
        echo "${M_GRP1}" >> "${TMP_PATH}/mdl"
        echo "${M_GRP2}" >> "${TMP_PATH}/mdl"
        echo "${M_GRP3}" >> "${TMP_PATH}/mdl"
      fi
    else
      if [ "${AFTERHASWELL}" == "OFF" ]; then
        echo "${M_GRP1}" >> "${TMP_PATH}/mdl"
        echo "${M_GRP2}" >> "${TMP_PATH}/mdl"	
      else
        echo "${M_GRP1}" >> "${TMP_PATH}/mdl"
        echo "${M_GRP2}" >> "${TMP_PATH}/mdl"
        echo "${M_GRP4}" >> "${TMP_PATH}/mdl"	
        echo "${M_GRP3}" >> "${TMP_PATH}/mdl"
      fi
    fi
  else
    if [ $threads -gt 16 ]; then
      echo "${M_GRP1}" >> "${TMP_PATH}/mdl"
    elif [ $threads -gt 8 ]; then
      if [ "${AFTERHASWELL}" == "OFF" ]; then
        echo "${M_GRP1}" >> "${TMP_PATH}/mdl"
        echo "${M_GRP2}" >> "${TMP_PATH}/mdl"	
        echo "${M_GRP5}" >> "${TMP_PATH}/mdl"
        echo "${M_GRP6}" >> "${TMP_PATH}/mdl"	
      else
        echo "${M_GRP1}" >> "${TMP_PATH}/mdl"
        echo "${M_GRP2}" >> "${TMP_PATH}/mdl"	
        echo "${M_GRP5}" >> "${TMP_PATH}/mdl"
        echo "${M_GRP6}" >> "${TMP_PATH}/mdl"	
        echo "${M_GRP3}" >> "${TMP_PATH}/mdl"
      fi
    else
      if [ "${AFTERHASWELL}" == "OFF" ]; then
        echo "${M_GRP1}" >> "${TMP_PATH}/mdl"
        echo "${M_GRP2}" >> "${TMP_PATH}/mdl"	
        echo "${M_GRP5}" >> "${TMP_PATH}/mdl"
        echo "${M_GRP6}" >> "${TMP_PATH}/mdl"	
      else
        echo "${M_GRP1}" >> "${TMP_PATH}/mdl"
        echo "${M_GRP2}" >> "${TMP_PATH}/mdl"
        echo "${M_GRP4}" >> "${TMP_PATH}/mdl"
        echo "${M_GRP5}" >> "${TMP_PATH}/mdl"
        echo "${M_GRP7}" >> "${TMP_PATH}/mdl"		
        echo "${M_GRP6}" >> "${TMP_PATH}/mdl"	
        echo "${M_GRP3}" >> "${TMP_PATH}/mdl"
	RESTRICT=0
      fi
    fi
  fi	  
  
  if [ ${RESTRICT} -eq 1 ]; then
        echo "Release-model-restriction" >> "${TMP_PATH}/mdl"
  else  
        echo "" > "${TMP_PATH}/mdl"
        echo "${M_GRP1}" >> "${TMP_PATH}/mdl"
        echo "${M_GRP2}" >> "${TMP_PATH}/mdl"
        echo "${M_GRP4}" >> "${TMP_PATH}/mdl"
        echo "${M_GRP5}" >> "${TMP_PATH}/mdl"
        echo "${M_GRP7}" >> "${TMP_PATH}/mdl"		
        echo "${M_GRP6}" >> "${TMP_PATH}/mdl"	
        echo "${M_GRP3}" >> "${TMP_PATH}/mdl"
  fi
  
  dialog --backtitle "`backtitle`" --default-item "${MODEL}" --no-items \
    --menu "Choose a model\n" 0 0 0 \
    --file "${TMP_PATH}/mdl" 2>${TMP_PATH}/resp
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
  setSuggest
}

# Set Describe model-specific requirements or suggested hardware
function setSuggest() {

  line="-------------------------------------------------------\n"
  case $MODEL in
    DS3622xs+)   platform="broadwellnk";eval "desc=\"[${MODEL}]:${platform}, \${MSG${tz}16}\"";;
    DS1621xs+)   platform="broadwellnk";eval "desc=\"[${MODEL}]:${platform}, \${MSG${tz}16}\"";;
    RS4021xs+)   platform="broadwellnk";eval "desc=\"[${MODEL}]:${platform}, \${MSG${tz}16}\"";;
    DS918+)      platform="apollolake";eval "desc=\"[${MODEL}]:${platform}, \${MSG${tz}17}, \${MSG${tz}18}\"";;
    DS1019+)     platform="apollolake";eval "desc=\"[${MODEL}]:${platform}, \${MSG${tz}17}, \${MSG${tz}18}\"";;
    DS923+)      platform="r1000";eval "desc=\"[${MODEL}]:${platform}\${MSG${tz}19}, \${MSG${tz}20}\"";;
    DS723+)      platform="r1000";eval "desc=\"[${MODEL}]:${platform}\${MSG${tz}19}, \${MSG${tz}20}\"";;
    DS920+)      platform="geminilake";eval "desc=\"[${MODEL}]:${platform}(DT), \${MSG${tz}17}\"";;
    DS1520+)     platform="geminilake";eval "desc=\"[${MODEL}]:${platform}(DT), \${MSG${tz}17}\"";;
    DVA1622)     platform="geminilake";eval "desc=\"[${MODEL}]:${platform}(DT), \${MSG${tz}17}, \${MSG${tz}21}\"";;
    DS1621+)     platform="v1000";eval "desc=\"[${MODEL}]:${platform}\${MSG${tz}19}, \${MSG${tz}22}\"";;
    DS2422+)     platform="v1000";eval "desc=\"[${MODEL}]:${platform}\${MSG${tz}19}, \${MSG${tz}22}\"";;
    FS2500)      platform="v1000";eval "desc=\"[${MODEL}]:${platform}\${MSG${tz}19}, \${MSG${tz}22}\"";;
    DS3615xs)    platform="bromolow";eval "desc=\"[${MODEL}]:${platform}, \${MSG${tz}22}\"";;
    DS3617xs)    platform="broadwell";eval "desc=\"[${MODEL}]:${platform}, \${MSG${tz}16}\"";;
    RS3618xs)    platform="broadwell";eval "desc=\"[${MODEL}]:${platform}, \${MSG${tz}16}\"";;
    DVA3221)     platform="denverton";eval "desc=\"[${MODEL}]:${platform}, \${MSG${tz}23}, \${MSG${tz}24}, \${MSG${tz}21}\"";;
    DVA3219)     platform="denverton";eval "desc=\"[${MODEL}]:${platform}, \${MSG${tz}23}, \${MSG${tz}25}, \${MSG${tz}21}\"";;
  esac

  result="${line}${desc}" 

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
  echo "press any key to continue..."
  read answer
  return 0
}

###############################################################################
# Post Update for jot mode 
function postupdate() {
  ./my.sh "${MODEL}" postupdate | tee "/home/tc/zpostupdate.log"
  echo "press any key to continue..."
  read answer
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

function erasedisk() {
  ./edisk.sh
  echo "press any key to continue..."
  read answer
  return 0
}

function backup() {
  echo "y"|./rploader.sh backup
  echo "press any key to continue..."
  read answer
  return 0
}

function reboot() {
    clear
    sudo reboot
    break
}

# Main loop
sed -i "s/screen_color = (CYAN,GREEN,ON)/screen_color = (CYAN,BLUE,ON)/g" .dialogrc
echo "insert aterm menu.sh in /home/tc/.xsession"
sed -i "/aterm/d" .xsession
sed -i "/urxvt/d" .xsession
echo "aterm -geometry 78x32+10+0 -fg yellow -title \"TCRP Monitor\" -e /home/tc/rploader.sh monitor &" >> .xsession
echo "urxvt -geometry 78x32+525+0 -title \"M Shell for TCRP Menu\" -e /home/tc/menu.sh &" >> .xsession
echo "aterm -geometry 78x25+10+430 -fg orange -title \"TCRP NTP Sync\" -e /home/tc/ntp.sh &" >> .xsession
echo "aterm -geometry 78x25+525+430 -fg green -title \"TCRP Extra Terminal\" &" >> .xsession

if [ "${KEYMAP}" = "null" ]; then
    LAYOUT="qwerty"
    KEYMAP="us"
    writeConfigKey "general" "layout" "${LAYOUT}"
    writeConfigKey "general" "keymap" "${KEYMAP}"
fi

if [ "${DMPM}" = "null" ]; then
    DMPM="EUDEV"
    writeConfigKey "general" "devmod" "${DMPM}"          
fi

if [ "${LDRMODE}" = "null" ]; then
    LDRMODE="FRIEND"
    writeConfigKey "general" "loadermode" "${LDRMODE}"          
fi

# Get actual IP
IP="$(ifconfig | grep -i "inet " | grep -v "127.0.0.1" | awk '{print $2}' | cut -c 6- )"

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

tcrppart="$(mount | grep -i optional | grep cde | awk -F / '{print $3}' | uniq | cut -c 1-3)3"
if [ $tcrppart == "mmc3" ]; then
    tcrppart="mmcblk0p3"
fi    

#Get Timezone for Korean Langugae
tz=$(curl -s  ipinfo.io | grep country | awk '{print $2}' | cut -c 2-3 )
if [ -n "$SSH_TTY" ] && [ "$tz" == "KR" ]; then

  if [ $(cat /mnt/${tcrppart}/cde/onboot.lst|grep glibc_apps | wc -w) -eq 0 ]; then
    tce-load -wi glibc_apps
    tce-load -wi glibc_i18n_locale
    tce-load -wi unifont
    tce-load -wi rxvt
    if [ $? -eq 0 ]; then
      echo "Download glibc_apps.tcz and glibc_i18n_locale.tcz OK, Permanent installation progress !!!"
      sudo cp -f /tmp/tce/optional/* /mnt/${tcrppart}/cde/optional
      sudo echo "glibc_apps.tcz" >> /mnt/${tcrppart}/cde/onboot.lst
      sudo echo "glibc_i18n_locale.tcz" >> /mnt/${tcrppart}/cde/onboot.lst
      sudo echo "unifont.tcz" >> /mnt/${tcrppart}/cde/onboot.lst
      sudo echo "rxvt.tcz" >> /mnt/${tcrppart}/cde/onboot.lst
  else
      echo "Download glibc_apps.tcz, glibc_i18n_locale.tcz FAIL !!!"
      tz="DoNotUseKorean"
    fi
  fi
  [ ! -d /usr/lib/locale ] && sudo mkdir /usr/lib/locale
  sudo localedef -c -i ko_KR -f UTF-8 ko_KR.UTF-8
  export LANG=ko_KR.utf8
  export LC_ALL=ko_KR.utf8

else
  tz="US"
fi

# Download dialog
if [ "$(which dialog)_" == "_" ]; then
    sudo curl --insecure -L "https://raw.githubusercontent.com/PeterSuh-Q3/tinycore-redpill/master/tce/optional/dialog.tcz" --output /mnt/${tcrppart}/cde/optional/dialog.tcz
    sudo curl --insecure -L "https://raw.githubusercontent.com/PeterSuh-Q3/tinycore-redpill/master/tce/optional/dialog.tcz.dep" --output /mnt/${tcrppart}/cde/optional/dialog.tcz.dep
    sudo curl --insecure -L "https://raw.githubusercontent.com/PeterSuh-Q3/tinycore-redpill/master/tce/optional/dialog.tcz.md5.txt" --output /mnt/${tcrppart}/cde/optional/dialog.tcz.md5.txt
    tce-load -i dialog
    if [ $? -eq 0 ]; then
        echo "Download dialog OK !!!"
    else
        tce-load -iw dialog
    fi
    sudo echo "dialog.tcz" >> /mnt/${tcrppart}/cde/onboot.lst
fi

# Download kmaps
if [ $(cat /mnt/${tcrppart}/cde/onboot.lst|grep kmaps | wc -w) -eq 0 ]; then
    sudo curl --insecure -L "https://raw.githubusercontent.com/PeterSuh-Q3/tinycore-redpill/master/tce/optional/kmaps.tcz" --output /mnt/${tcrppart}/cde/optional/kmaps.tcz
    sudo curl --insecure -L "https://raw.githubusercontent.com/PeterSuh-Q3/tinycore-redpill/master/tce/optional/kmaps.tcz.md5.txt" --output /mnt/${tcrppart}/cde/optional/kmaps.tcz.md5.txt
    tce-load -i kmaps
    if [ $? -eq 0 ]; then
        echo "Download kmaps OK !!!"
    else
        tce-load -iw kmaps
    fi
    sudo echo "kmaps.tcz" >> /mnt/${tcrppart}/cde/onboot.lst
fi
loadkmap < /usr/share/kmap/${LAYOUT}/${KEYMAP}.kmap

NEXT="m"
setSuggest

# Until urxtv is available, Korean menu is used only on remote terminals.
while true; do
  eval "echo \"c \\\"\${MSG${tz}01}\\\"\""               > "${TMP_PATH}/menu" 
  eval "echo \"m \\\"\${MSG${tz}02}\\\"\""               >> "${TMP_PATH}/menu"
  if [ -n "${MODEL}" ]; then
    eval "echo \"s \\\"\${MSG${tz}03}\\\"\""             >> "${TMP_PATH}/menu"
    eval "echo \"a \\\"\${MSG${tz}04} 1\\\"\""           >> "${TMP_PATH}/menu"
    if [ $(ifconfig | grep eth1 | wc -l) -gt 0 ]; then
      eval "echo \"f \\\"\${MSG${tz}04} 2\\\"\""         >> "${TMP_PATH}/menu"
    fi  
    if [ $(ifconfig | grep eth2 | wc -l) -gt 0 ]; then
      eval "echo \"g \\\"\${MSG${tz}04} 3\\\"\""         >> "${TMP_PATH}/menu"
    fi  
    if [ $(ifconfig | grep eth3 | wc -l) -gt 0 ]; then
      eval "echo \"h \\\"\${MSG${tz}04} 4\\\"\""         >> "${TMP_PATH}/menu"
    fi
    if [ "${CPU}" == "HP" ]; then
      eval "echo \"j \\\"\${MSG${tz}05}\\\"\""           >> "${TMP_PATH}/menu"       
    else 
      eval "echo \"z \\\"\${MSG${tz}06} (${LDRMODE})\\\"\""   >> "${TMP_PATH}/menu"
      eval "echo \"d \\\"\${MSG${tz}07}\\\"\""                >> "${TMP_PATH}/menu"
      if [ "${MODEL}" == "DS918+" ]||[ "${MODEL}" == "DS1019+" ]||[ "${MODEL}" == "DS920+" ]||[ "${MODEL}" == "DS1520+" ]; then        
        eval "echo \"o \\\"\${MSG${tz}08}\\\"\""         >> "${TMP_PATH}/menu"
      fi	
    fi
    if [ "${LDRMODE}" == "JOT" ]; then
      eval "echo \"p \\\"\${MSG${tz}09}\\\"\""           >> "${TMP_PATH}/menu"   
    fi
  fi
  eval "echo \"u \\\"\${MSG${tz}10}\\\"\""               >> "${TMP_PATH}/menu"
  eval "echo \"k \\\"\${MSG${tz}11}\\\"\""               >> "${TMP_PATH}/menu"
  eval "echo \"i \\\"\${MSG${tz}12}\\\"\""               >> "${TMP_PATH}/menu"
  eval "echo \"b \\\"\${MSG${tz}13}\\\"\""               >> "${TMP_PATH}/menu"  
  eval "echo \"r \\\"\${MSG${tz}14}\\\"\""               >> "${TMP_PATH}/menu"
  eval "echo \"e \\\"\${MSG${tz}15}\\\"\""               >> "${TMP_PATH}/menu"
  eval "MSG00=\"\${MSG${tz}00}\""
  dialog --clear --default-item ${NEXT} --backtitle "`backtitle`" --colors \
    --menu "${MSG00}${result}" 0 0 0 --file "${TMP_PATH}/menu" \
    2>${TMP_PATH}/resp
  [ $? -ne 0 ] && break
  case `<"${TMP_PATH}/resp"` in
    c) seleudev;        NEXT="m" ;;  
    m) modelMenu;       NEXT="s" ;;
    s) serialMenu;      NEXT="a" ;;
    a) macMenu "eth0"
        if [ $(ifconfig | grep eth1 | wc -l) -gt 0 ]; then
            NEXT="f" 
	else
            NEXT="z" 	
	fi
        ;;
    f) macMenu "eth1"
        if [ $(ifconfig | grep eth2 | wc -l) -gt 0 ]; then
            NEXT="g" 
	else
            NEXT="z" 	
	fi
        ;;
    g) macMenu "eth2"
        if [ $(ifconfig | grep eth3 | wc -l) -gt 0 ]; then
            NEXT="h" 
	else
            NEXT="z" 	
	fi
        ;;
    h) macMenu "eth3";    NEXT="z" ;;    
    z) selectldrmode ;    NEXT="d" ;;
    d) BUILD="42962"
       if [ "${LDRMODE}" == "FRIEND" ]; then
         make
       else
         make "jot"
       fi
       NEXT="r" ;;
    j) BUILD="42962"; make "jot";      NEXT="r" ;;    
    p) postupdate ;                    NEXT="r" ;;
    o) BUILD="42218"; make "jun";      NEXT="r" ;;
    u) editUserConfig;                 NEXT="d" ;;
    k) keymapMenu ;;
    i) erasedisk ;;          
    b) backup ;;      
    r) reboot ;;
    e) break ;;
  esac
done

clear
echo -e "Call \033[1;32m./menu.sh\033[0m to return to menu"
