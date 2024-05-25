#!/usr/bin/env bash

gitdomain="raw.githubusercontent.com"

mshellgz="my.sh.gz"
mshtarfile="https://raw.githubusercontent.com/PeterSuh-Q3/tinycore-redpill/master/my.sh.gz"

USER_CONFIG_FILE="/home/tc/user_config.json"

# ==============================================================================          
# Color Function                                                                          
# ==============================================================================          
function cecho () {                                                                                
#    if [ -n "$3" ]                                                                                                            
#    then                                                                                  
#        case "$3" in                                                                                 
#            black  | bk) bgcolor="40";;                                                              
#            red    |  r) bgcolor="41";;                                                              
#            green  |  g) bgcolor="42";;                                                                 
#            yellow |  y) bgcolor="43";;                                             
#            blue   |  b) bgcolor="44";;                                             
#            purple |  p) bgcolor="45";;                                                   
#            cyan   |  c) bgcolor="46";;                                             
#            gray   | gr) bgcolor="47";;                                             
#        esac                                                                        
#    else                                                                            
        bgcolor="0"                                                                 
#    fi                                                                              
    code="\033["                                                                    
    case "$1" in                                                                    
        black  | bk) color="${code}${bgcolor};30m";;                                
        red    |  r) color="${code}${bgcolor};31m";;                                
        green  |  g) color="${code}${bgcolor};32m";;                                
        yellow |  y) color="${code}${bgcolor};33m";;                                
        blue   |  b) color="${code}${bgcolor};34m";;                                
        purple |  p) color="${code}${bgcolor};35m";;                                
        cyan   |  c) color="${code}${bgcolor};36m";;                                
        gray   | gr) color="${code}${bgcolor};37m";;                                
    esac                                                                            
                                                                                                                                                                    
    text="$color$2${code}0m"                                                                                                                                        
    echo -e "$text"                                                                                                                                                 
}   

###############################################################################
# git clone redpill-load
function gitdownload() {

    git config --global http.sslVerify false   

    if [ -d "/home/tc/redpill-load" ]; then
        cecho y "Loader sources already downloaded, pulling latest !!!"
        cd /home/tc/redpill-load
        git pull
        if [ $? -ne 0 ]; then
           cd /home/tc    
           /home/tc/rploader.sh clean 
           git clone -b master --single-branch https://github.com/PeterSuh-Q3/redpill-load.git
           #git clone -b master --single-branch https://giteas.duckdns.org/PeterSuh-Q3/redpill-load.git
        fi   
        cd /home/tc
    else
        git clone -b master --single-branch https://github.com/PeterSuh-Q3/redpill-load.git
        #git clone -b master --single-branch https://giteas.duckdns.org/PeterSuh-Q3/redpill-load.git
    fi

}

function _pat_process() {

  PATURL="${URL}"
  PAT_FILE="${SYNOMODEL}.pat"
  PAT_PATH="${patfile}"
  #mirrors=("global.synologydownload.com" "global.download.synology.com" "cndl.synology.cn")
  mirrors=("global.synologydownload.com" "global.download.synology.com")

  SPACELEFT=$(df --block-size=1 | awk '/'${loaderdisk}'3/{print $4}') # Check disk space left

  fastest=$(_get_fastest "${mirrors[@]}")
  echo "fastest = " "${fastest}"
  mirror="$(echo ${PATURL} | sed 's|^http[s]*://\([^/]*\).*|\1|')"
  echo "mirror = " "${mirror}"
  if echo "${mirrors[@]}" | grep -wq "${mirror}" && [ "${mirror}" != "${fastest}" ]; then
      echo "Based on the current network situation, switch to ${fastest} mirror to downloading."
      PATURL="$(echo ${PATURL} | sed "s/${mirror}/${fastest}/")"
  fi

  # Discover remote file size
  FILESIZE=$(curl -k -sLI "${PATURL}" | grep -i Content-Length | awk '{print$2}')

  FILESIZE_FORMATTED=$(printf "%'d" "${FILESIZE}")
  SPACELEFT_FORMATTED=$(printf "%'d" "${SPACELEFT}")
  FILESIZE_MB=$((FILESIZE / 1024 / 1024))
  SPACELEFT_MB=$((SPACELEFT / 1024 / 1024))    

  echo "FILESIZE  = ${FILESIZE_FORMATTED} bytes (${FILESIZE_MB} MB)"
  echo "SPACELEFT = ${SPACELEFT_FORMATTED} bytes (${SPACELEFT_MB} MB)"

  if [ 0${FILESIZE} -ge 0${SPACELEFT} ]; then
      # No disk space to download, change it to RAMDISK
      echo "No adequate space on ${local_cache} to download file into cache folder, clean up PAT file now ....."
      sudo sh -c "rm -vf $(ls -t ${local_cache}/*.pat | head -n 1)"
  fi

  echo "PATURL = " "${PATURL}"
  STATUS=$(curl -k -w "%{http_code}" -L "${PATURL}" -o "${PAT_PATH}" --progress-bar)
  if [ $? -ne 0 -o ${STATUS} -ne 200 ]; then
      rm -f "${PAT_PATH}"
      echo "Check internet or cache disk space.\nError: ${STATUS}"
      exit 99
  fi

}

#function add_addon() {
    #jsonfile=$(jq ". |= .+ {\"${1}\": \"https://raw.githubusercontent.com/PeterSuh-Q3/tcrp-addons/master/${1}/rpext-index.json\"}" ~/redpill-load/bundled-exts.json) && echo $jsonfile | jq . > ~/redpill-load/bundled-exts.json	
#}

function my() {

  loaderdisk=""
  for edisk in $(sudo fdisk -l | grep "Disk /dev/sd" | awk '{print $2}' | sed 's/://' ); do
      if [ $(sudo fdisk -l | grep "83 Linux" | grep ${edisk} | wc -l ) -eq 3 ]; then
          loaderdisk="$(blkid | grep ${edisk} | grep "6234-C863" | cut -c 1-8 | awk -F\/ '{print $3}')"    
      fi    
  done
  
  if [ -z "${loaderdisk}" ]; then
      for edisk in $(sudo fdisk -l | grep -e "Disk /dev/nvme" -e "Disk /dev/mmc" | awk '{print $2}' | sed 's/://' ); do
          if [ $(sudo fdisk -l | grep "83 Linux" | grep ${edisk} | wc -l ) -eq 3 ]; then
              loaderdisk="$(blkid | grep ${edisk} | grep "6234-C863" | cut -c 1-12 | awk -F\/ '{print $3}')"    
          fi    
      done
  fi
  
  if [ -z "${loaderdisk}" ]; then
      echo "Not Supported Loader BUS Type, program Exit!!!"
      exit 99
  fi
  
  getBus "${loaderdisk}" 
  
  [ "${BUS}" = "nvme" ] && loaderdisk="${loaderdisk}p"
  [ "${BUS}" = "mmc"  ] && loaderdisk="${loaderdisk}p"
  
  tcrppart="${loaderdisk}3"
  
  if [ -d /mnt/${tcrppart}/redpill-load/ ]; then
      offline="YES"
  else
      offline="NO"
      checkinternet
      if [ "$gitdomain" = "raw.githubusercontent.com" ]; then
          if [ $# -lt 1 ]; then
              getlatestmshell "ask"
          else
              if [ "$1" = "update" ]; then 
                  getlatestmshell "noask"
                  exit 0
              else
                  getlatestmshell "noask"
              fi
          fi
      fi
      gitdownload
  fi
  
  if [ $# -lt 1 ]; then
      showhelp 
      exit 99
  fi
  
  getvarsmshell "$1"
  
  #echo "$TARGET_REVISION"                                                      
  #echo "$TARGET_PLATFORM"                                            
  #echo "$SYNOMODEL"                                      
  
  postupdate="N"
  userdts="N"
  noconfig="N"
  frmyv="N"
  jot="N"
  makeimg="N"
  prevent_init="N"
  
  shift
      while [[ "$#" > 0 ]] ; do
  
          case $1 in
          postupdate)
              postupdate="Y"
              ;;
              
          userdts)
              userdts="Y"
              ;;
  
          noconfig)
              noconfig="Y"
              ;;
           
          frmyv)
              frmyv="Y"
              ;;
              
          jot)
              jot="Y"
              ;;
  
          fri)
              jot="N"
              ;;
              
          makeimg)
              makeimg="Y"
              ;;
  
          prevent_init)
              prevent_init="Y"
              ;;
  
          *)
              echo "Syntax error, not valid arguments or not enough options"
              exit 0
              ;;
  
          esac
          shift
      done
  
  #echo $postupdate
  #echo $userdts
  #echo $noconfig
  #echo $frmyv
  #echo "makeimg = $makeimg"
  
  echo
  
  if [ "$tcrppart" = "mmc3" ]; then
      tcrppart="mmcblk0p3"
  fi
  
  echo
  echo "loaderdisk is" "${loaderdisk}"
  echo
  
  if [ ! -d "/mnt/${tcrppart}/auxfiles" ]; then
      cecho g "making directory  /mnt/${tcrppart}/auxfiles"  
      mkdir /mnt/${tcrppart}/auxfiles 
  fi
  if [ ! -h /home/tc/custom-module ]; then
      cecho y "making link /home/tc/custom-module"  
      sudo ln -s /mnt/${tcrppart}/auxfiles /home/tc/custom-module 
  fi
  
  local_cache="/mnt/${tcrppart}/auxfiles"
  
  #if [ -d ${local_cache/extractor /} ] && [ -f ${local_cache}/extractor/scemd ]; then
  #    echo "Found extractor locally cached"
  #else
  #    cecho g "making directory  /mnt/${tcrppart}/auxfiles/extractor"  
  #    mkdir /mnt/${tcrppart}/auxfiles/extractor
  #    sudo curl --insecure -L --progress-bar "https://$gitdomain/PeterSuh-Q3/tinycore-redpill/master/extractor.gz" --output /mnt/${tcrppart}/auxfiles/extractor/extractor.gz
  #    sudo tar -zxvf /mnt/${tcrppart}/auxfiles/extractor/extractor.gz -C /mnt/${tcrppart}/auxfiles/extractor
  #fi
  
  echo
  cecho y "TARGET_PLATFORM is $TARGET_PLATFORM"
  cecho r "ORIGIN_PLATFORM is $ORIGIN_PLATFORM"
  cecho c "TARGET_VERSION is $TARGET_VERSION"
  cecho p "TARGET_REVISION is $TARGET_REVISION"
  cecho y "SUVP is $SUVP"
  cecho g "SYNOMODEL is $SYNOMODEL"  
  cecho c "KERNEL VERSION is $KVER"  
  
  st "buildstatus" "Building started" "Model :$MODEL-$TARGET_VERSION-$TARGET_REVISION"
  
  #fullupgrade="Y"
  
  cecho y "If fullupgrade is required, please handle it separately."
  
  cecho g "Downloading Peter Suh's custom configuration files.................."
  
  writeConfigKey "general" "kver" "${KVER}"
  
  DMPM="$(jq -r -e '.general.devmod' $USER_CONFIG_FILE)"
  if [ "${DMPM}" = "null" ]; then
      DMPM="DDSML"
      writeConfigKey "general" "devmod" "${DMPM}"
  fi
  cecho y "Device Module Processing Method is ${DMPM}"
  
  [ $(cat ~/redpill-load/bundled-exts.json | jq 'has("mac-spoof")') = true ] && spoof=true || spoof=false
  [ $(cat ~/redpill-load/bundled-exts.json | jq 'has("nvmesystem")') = true ] && nvmes=true || nvmes=false
  [ $(cat ~/redpill-load/bundled-exts.json | jq 'has("dbgutils")') = true ] && dbgutils=true || dbgutils=false
  [ $(cat ~/redpill-load/bundled-exts.json | jq 'has("sortnetif")') = true ] && sortnetif=true || sortnetif=false
  
  echo  "download original bundled-exts.json file..."
  curl -skL# https://raw.githubusercontent.com/PeterSuh-Q3/redpill-load/master/bundled-exts.json -o /home/tc/redpill-load/bundled-exts.json
  
  if [ "${DMPM}" = "DDSML" ]; then
      jsonfile=$(jq 'del(.eudev)' /home/tc/redpill-load/bundled-exts.json) && echo $jsonfile | jq . > /home/tc/redpill-load/bundled-exts.json
  elif [ "${DMPM}" = "EUDEV" ]; then
      jsonfile=$(jq 'del(.ddsml)' /home/tc/redpill-load/bundled-exts.json) && echo $jsonfile | jq . > /home/tc/redpill-load/bundled-exts.json
  elif [ "${DMPM}" = "DDSML+EUDEV" ]; then
      cecho p "It uses both ddsml and eudev from /home/tc/redpill-load/bundled-exts.json file"
  else
      cecho p "Device Module Processing Method is Undefined, Program Exit!!!!!!!!"
      exit 0
  fi
  
  #[ "$spoof" = true ] && add_addon "mac-spoof" 
  #[ "$nvmes" = true ] && add_addon "nvmesystem" 
  #[ "$dbgutils" = true ] && add_addon "dbgutils" 
  #[ "$sortnetif" = true ] && add_addon "sortnetif" 
  
  if [ "${offline}" = "NO" ]; then
      curl -skLO# https://$gitdomain/PeterSuh-Q3/tinycore-redpill/master/custom_config.json
      curl -skLO# https://$gitdomain/PeterSuh-Q3/tinycore-redpill/master/rploader.sh                                
      #curl -skL# https://$gitdomain/PeterSuh-Q3/tinycore-redpill/master/rploader_t.sh -o rploader.sh
  fi
  
  echo
  if [ "$jot" = "N" ]; then    
  cecho y "This is TCRP friend mode"
  else    
  cecho y "This is TCRP original jot mode"
  fi
  
  if [ -f /home/tc/custom-module/${TARGET_PLATFORM}.dts ]; then
      sed -i "s/dtbpatch/redpill-dtb-static/g" custom_config.json
      sed -i "s/dtbpatch/redpill-dtb-static/g" custom_config_jun.json
  fi
  
  if [ "$postupdate" = "Y" ]; then
      cecho y "Postupdate in progress..."  
      sudo ./rploader.sh postupdate ${TARGET_PLATFORM}-7.1.1-${TARGET_REVISION}
  
      echo                                                                                                                                        
      cecho y "Backup in progress..."
      echo                                                                                                                                        
      echo "y"|./rploader.sh backup    
      exit 0
  fi
  
  if [ "$userdts" = "Y" ]; then
      
      cecho y "user-define dts file make in progress..."  
      echo
      
      cecho g "copy and paste user dts contents here, press any key to continue..."      
      read answer
      sudo vi /home/tc/custom-module/${TARGET_PLATFORM}.dts
  
      cecho p "press any key to continue..."
      read answer
  
      echo                                                                                                                                        
      cecho y "Backup in progress..."
      echo                                                                                                                                        
      echo "y"|./rploader.sh backup    
      exit 0
  fi
  
  echo
  
  if [ "$noconfig" = "Y" ]; then                            
      cecho r "SN Gen/Mac Gen/Vid/Pid/SataPortMap detection skipped!!"
      checkmachine
      if [ "$MACHINE" = "VIRTUAL" ] && [ "${prevent_init}" = "N" ]; then
          cecho p "Sataportmap,DiskIdxMap to blank for VIRTUAL MACHINE"
          json="$(jq --arg var "" '.extra_cmdline.SataPortMap = $var' user_config.json)" && echo -E "${json}" | jq . >user_config.json
          json="$(jq --arg var "" '.extra_cmdline.DiskIdxMap = $var' user_config.json)" && echo -E "${json}" | jq . >user_config.json        
          cat user_config.json
      fi
  else 
      cecho c "Before changing user_config.json" 
      cat user_config.json
      echo "y"|./rploader.sh identifyusb
  
      if [ "$ORIGIN_PLATFORM" = "v1000" ]||[ "$ORIGIN_PLATFORM" = "r1000" ]||[ "$ORIGIN_PLATFORM" = "geminilake" ]; then
          cecho p "Device Tree based model does not need SataPortMap setting...."     
      else    
          ./rploader.sh satamap    
      fi    
      cecho y "After changing user_config.json"     
      cat user_config.json        
  fi
  
  echo
  echo
  DN_MODEL="$(echo $MODEL | sed 's/+/%2B/g')"
  echo "DN_MODEL is $DN_MODEL"
  
  cecho p "DSM PAT file pre-downloading in progress..."
  URL="https://global.synologydownload.com/download/DSM/release/${TARGET_VERSION}/${TARGET_REVISION}${SUVP}/DSM_${DN_MODEL}_${TARGET_REVISION}.pat"
  cecho y "$URL"
  patfile="/mnt/${tcrppart}/auxfiles/${SYNOMODEL}.pat"                                         
  
  if [ "$TARGET_VERSION" = "7.2" ]; then
      TARGET_VERSION="7.2.0"
  fi
  
  #if [ "$ORIGIN_PLATFORM" = "apollolake" ]||[ "$ORIGIN_PLATFORM" = "geminilake" ]; then
  #   jsonfile=$(jq 'del(.drivedatabase)' /home/tc/redpill-load/bundled-exts.json) && echo $jsonfile | jq . > /home/tc/redpill-load/bundled-exts.json
  #   sudo rm -rf /home/tc/redpill-load/custom/extensions/drivedatabase
  #   jsonfile=$(jq 'del(.reboottotcrp)' /home/tc/redpill-load/bundled-exts.json) && echo $jsonfile | jq . > /home/tc/redpill-load/bundled-exts.json
  #   sudo rm -rf /home/tc/redpill-load/custom/extensions/reboottotcrp
  #fi   
          
  if [ -f ${patfile} ]; then
      cecho r "Found locally cached pat file ${SYNOMODEL}.pat in /mnt/${tcrppart}/auxfiles"
      cecho b "Downloadng Skipped!!!"
  st "download pat" "Found pat    " "Found ${SYNOMODEL}.pat"
  else
  
  st "download pat" "Downloading pat  " "${SYNOMODEL}.pat"        
  
      if [ 1 = 0 ]; then
        STATUS=`curl --insecure -w "%{http_code}" -L "${URL}" -o ${patfile} --progress-bar`
        if [ $? -ne 0 -o ${STATUS} -ne 200 ]; then
          echo  "Check internet or cache disk space"
          exit 99
        fi
      else
        [ "${offline}" = "NO" ] && _pat_process    
      fi
  
      os_sha256=$(sha256sum ${patfile} | awk '{print $1}')                                
      cecho y "Pat file  sha256sum is : $os_sha256"                                       
  
      #verifyid="${sha256}"
      id="${TARGET_PLATFORM}-${TARGET_VERSION}-${TARGET_REVISION}"
      platform_selected=$(jq -s '.[0].build_configs=(.[1].build_configs + .[0].build_configs | unique_by(.id)) | .[0]' custom_config.json | jq ".build_configs[] | select(.id==\"${id}\")")
      verifyid="$(echo $platform_selected | jq -r -e '.downloads .os .sha256')"
      cecho p "verifyid  sha256sum is : $verifyid"                                        
  
      if [ "$os_sha256" = "$verifyid" ]; then                                            
          cecho y "pat file sha256sum is OK ! "                                           
      else                                                                                
          cecho y "os sha256 verify FAILED, check ${patfile}  "                           
          exit 99                                                                         
      fi
  fi
  
  echo
  cecho g "Loader Building in progress..."
  echo
  
  if [ "$frmyv" = "Y" ]; then
      parmfrmyv="frmyv"
  else
      if [ "$makeimg" = "Y" ]; then
          parmfrmyv="makeimg"
      else
          parmfrmyv=""
      fi
  fi
  
  if [ "$MODEL" = "SA6400" ]; then
      cecho g "Remove Exts for SA6400 (thethorgroup.boot-wait) ..."
      jsonfile=$(jq 'del(.["thethorgroup.boot-wait"])' /home/tc/redpill-load/bundled-exts.json) && echo $jsonfile | jq . > /home/tc/redpill-load/bundled-exts.json
      sudo rm -rf /home/tc/redpill-load/custom/extensions/thethorgroup.boot-wait
  
      cecho g "Remove Exts for SA6400 (automount) ..."
      jsonfile=$(jq 'del(.["automount"])' /home/tc/redpill-load/bundled-exts.json) && echo $jsonfile | jq . > /home/tc/redpill-load/bundled-exts.json
      sudo rm -rf /home/tc/redpill-load/custom/extensions/automount
  fi
  
  if [ "$jot" = "N" ]; then
      echo "n"|./rploader.sh build ${TARGET_PLATFORM}-${TARGET_VERSION}-${TARGET_REVISION} withfriend ${parmfrmyv}
  else
      echo "n"|./rploader.sh build ${TARGET_PLATFORM}-${TARGET_VERSION}-${TARGET_REVISION} static ${parmfrmyv}
  fi
  
  if [ $? -ne 0 ]; then
      cecho r "An error occurred while building the loader!!! Clean the redpill-load directory!!! "
      ./rploader.sh clean
  else
      [ "$MACHINE" != "VIRTUAL" ] && sleep 2
      echo "y"|./rploader.sh backup
  fi
fi

###############################################################################
# get bus of disk
# 1 - device path
function getBus() {
  BUS=""
  # usb/ata(sata/ide)/scsi
  [ -z "${BUS}" ] && BUS=$(udevadm info --query property --name "${1}" 2>/dev/null | grep ID_BUS | cut -d= -f2 | sed 's/ata/sata/')
  # usb/sata(sata/ide)/nvme
  [ -z "${BUS}" ] && BUS=$(lsblk -dpno KNAME,TRAN 2>/dev/null | grep "${1} " | awk '{print $2}') #Spaces are intentional
  # usb/scsi(sata/ide)/virtio(scsi/virtio)/mmc/nvme
  [ -z "${BUS}" ] && BUS=$(lsblk -dpno KNAME,SUBSYSTEMS 2>/dev/null | grep "${1} " | cut -d: -f2) #Spaces are intentional
  echo "${BUS}"
}
