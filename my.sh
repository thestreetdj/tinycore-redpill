#!/usr/bin/env bash

# my.sh (Batch Shell Script for rploader.sh)                 
# Made by Peter Suh

##### INCLUDES #########################################################################################################
source myfunc.h # my.sh / myv.sh common use 
########################################################################################################################

mshellgz="my.sh.gz"
mshtarfile="https://raw.githubusercontent.com/PeterSuh-Q3/tinycore-redpill/main/my.sh.gz"

# ==============================================================================          
# Color Function                                                                          
# ==============================================================================          
cecho () {                                                                                
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

function checkmachine() {

    if grep -q ^flags.*\ hypervisor\  /proc/cpuinfo; then
        MACHINE="VIRTUAL"
        HYPERVISOR=$(dmesg | grep -i "Hypervisor detected" | awk '{print $5}')
        echo "Machine is $MACHINE Hypervisor=$HYPERVISOR"
    else
        MACHINE="NON-VIRTUAL"
    fi

}

if [ $(cat /home/tc/.xsession | grep menu.sh | wc -l) -gt 0 ]; then
    cat /home/tc/.xsession
else
    echo "insert autorun script in /home/tc/.xsession"
    echo "aterm -bg black -fg green -title \"TinyCore RedPill Menu\" -e /home/tc/menu.sh &" >> .xsession   
fi

checkinternet
getlatestmshell

if [ $# -lt 1 ]; then
    showhelp 
    exit 99
fi

getvars "$1"

#echo "$TARGET_REVISION"                                                      
#echo "$MSHELL_ONLY_MODEL"                                                        
#echo "$TARGET_PLATFORM"                                            
#echo "$SYNOMODEL"                                      
#echo "$sha256"
#echo "$FRIEND_MODE_YN"

echo "Multi-argument input variable assignment mapping"
jumkey="N"
postupdate="N"
userdts="N"
noclean="N"
noconfig="N"
manual="N"
poco="N"
realmac="N"
frmyv="N"
friend_mode="N"

if [ $FRIEND_MODE_YN == "Y" ]; then
    friend_mode="Y"
fi

    while [[ "$#" > 0 ]] ; do

        case $1 in
        jumkey)
            jumkey="Y"
            ;;

        poco)
            poco="Y"
            ;;

        postupdate)
            postupdate="Y"
            ;;
            
        userdts)
            userdts="Y"
            ;;

        noclean)
            noclean="Y"
            ;;

        noconfig)
            noconfig="Y"
            ;;

        manual)
            manual="Y"
            ;;
        realmac)
            realmac="Y"
            ;;
        frmyv)
            frmyv="Y"
            ;;

        *)
            if [ $1 = "FS2500F" ]; then                                       
                echo                                                          
            elif [ $1 = "FS2500" ]; then                                      
                echo                                                          
            else                                                              
                if [ "$(echo $1 | sed 's/J//g')" != "$MODEL" ] && [ "$(echo $1 | sed 's/F//g')" != "$MODEL" ] ; then
                    echo "Syntax error, not valid arguments or not enough options"
                    exit 0                                                        
                fi                                                                
            fi          
            ;;

        esac
        shift
    done

#echo $jumkey
#echo $postupdate
#echo $userdts
#echo $noclean
#echo $noconfig
#echo $manual
#echo $realmac
#echo $frmyv
#echo $friend_mode

if [ $jumkey == "Y" ] ; then 
    cecho p "The jumpkey option is deprecated, shell exit..."          
    exit 0
elif [ $poco == "Y" ] ; then 
    cecho p "The poco option is deprecated, shell exit..."
    exit 0
fi

if [ $noconfig == "Y" ] && [ $realmac == "Y" ] ; then 
    cecho p "The noconfig option and the realmac option cannot be used together, shell exit..."
    exit 0
fi

if [ $TARGET_REVISION == "42218" ] ; then
    if [ $postupdate == "Y" ] ; then  
        cecho g "postupdate is not allowed on jun mode."                                                                                              
        exit 0                                                                                                                                       
    fi    
fi                                                                                                                                               

echo

tcrppart="$(mount | grep -i optional | grep cde | awk -F / '{print $3}' | uniq | cut -c 1-3)3"
echo
echo tcrppart is $tcrppart                                                  
echo
if [ ! -d "/mnt/${tcrppart}/auxfiles" ]; then
    cecho g "making directory  /mnt/${tcrppart}/auxfiles"  
    mkdir /mnt/${tcrppart}/auxfiles 
fi
if [ ! -h /home/tc/custom-module ]; then
    cecho y "making link /home/tc/custom-module"  
    sudo ln -s /mnt/${tcrppart}/auxfiles /home/tc/custom-module 
fi

echo

if [ $MODEL == "DS918+" ]||[ $MODEL == "DS3617xs" ]||[ $MODEL == "DS2422+" ]||[ $MODEL == "RS4021xs+" ]||[ $MODEL == "DS1621xs+" ]||[ $MODEL == "RS3618xs" ]; then
    cecho y "Downloading fabio's ${ORIGIN_PLATFORM} 4.4.180 redpill.ko ..."
    sudo curl --location --progress-bar "https://github.com/fbelavenuto/redpill-lkm/raw/master/output/rp-$ORIGIN_PLATFORM-4.4.180-prod.ko.gz" --output /home/tc/custom-module/rp-$ORIGIN_PLATFORM-4.4.180-prod.ko.gz
    gunzip /home/tc/custom-module/rp-$ORIGIN_PLATFORM-4.4.180-prod.ko.gz
    sudo mv /home/tc/custom-module/rp-$ORIGIN_PLATFORM-4.4.180-prod.ko /home/tc/custom-module/redpill.ko
elif [ $MODEL == "DS3615xs" ]; then
    cecho y "Downloading fabio's ${ORIGIN_PLATFORM} 3.10.108 redpill.ko ..."
    sudo curl --location --progress-bar "https://github.com/fbelavenuto/redpill-lkm/raw/master/output/rp-$ORIGIN_PLATFORM-3.10.108-prod.ko.gz" --output /home/tc/custom-module/rp-$ORIGIN_PLATFORM-3.10.108-prod.ko.gz
    gunzip /home/tc/custom-module/rp-$ORIGIN_PLATFORM-3.10.108-prod.ko.gz
    sudo mv /home/tc/custom-module/rp-$ORIGIN_PLATFORM-3.10.108-prod.ko /home/tc/custom-module/redpill.ko
elif [ $MODEL == "DS3622xs+" ]||[ $MODEL == "DS920+" ]||[ $MODEL == "DVA1622" ]||[ $MODEL == "DS1621+" ]||[ $MODEL == "DVA3221" ]; then
    cecho y "Downloading pocopico's ${ORIGIN_PLATFORM} 4.4.180 redpill.ko ..."
    sudo curl --location --progress-bar "https://github.com/PeterSuh-Q3/rp-ext/raw/main/redpill/releases/redpill-4.4.180plus-$ORIGIN_PLATFORM.tgz" --output /home/tc/custom-module/redpill.ko.tgz
    sudo tar -zxvf /home/tc/custom-module/redpill.ko.tgz -C /home/tc/custom-module/
elif [ $MODEL == "DVA3219" ]; then
    cecho y "Downloading peter's ${ORIGIN_PLATFORM} 4.4.180 ${MODEL} redpill.ko ..."
    sudo curl --location --progress-bar "https://github.com/PeterSuh-Q3/redpill-load/raw/master/ext/rp-lkm/redpill-linux-dva3219-v4.4.180+.ko" --output /home/tc/custom-module/redpill.ko
else
    cecho y "Downloading peter's ${ORIGIN_PLATFORM} 4.4.180 redpill.ko ..."
    sudo curl --location --progress-bar "https://github.com/PeterSuh-Q3/redpill-load/raw/master/ext/rp-lkm/redpill-linux-v4.4.180+.ko" --output /home/tc/custom-module/redpill.ko
fi

echo
cecho y "TARGET_PLATFORM is $TARGET_PLATFORM"
cecho r "ORIGIN_PLATFORM is $ORIGIN_PLATFORM"
cecho p "TARGET_REVISION is $TARGET_REVISION"
cecho g "SYNOMODEL is $SYNOMODEL"  

#fullupgrade="Y"

cecho y "If fullupgrade is required, please handle it separately."

cecho g "Downloading Peter Suh's custom configuration files.................."

curl --location --progress-bar "https://github.com/PeterSuh-Q3/tinycore-redpill/raw/main/custom_config.json" -O
curl --location --progress-bar "https://github.com/PeterSuh-Q3/tinycore-redpill/raw/main/custom_config_jun.json" -O
curl --location --progress-bar "https://github.com/PeterSuh-Q3/tinycore-redpill/raw/main/rploader.sh" -O
curl --location --progress-bar "https://github.com/PeterSuh-Q3/rp-ext/raw/main/rpext-index.json" -O  

if [ $TARGET_REVISION == "42218" ] ; then
    echo
    cecho y "This is TCRP jumkey's jun mode"

else
    echo
    if [ $friend_mode == "Y" ] ; then    
        cecho y "This is TCRP friend mode"
    else    
        cecho y "This is TCRP original jot mode"
    fi
    
fi   

dtbfile=""     

if [ "${TARGET_PLATFORM}" = "v1000" ]; then
    dtbfile="ds1621p"
elif [ "${TARGET_PLATFORM}" = "geminilake" ]; then
    dtbfile="ds920p"
elif [ "${TARGET_PLATFORM}" = "dva1622" ]; then
    dtbfile="dva1622"
elif [ "${TARGET_PLATFORM}" = "ds2422p" ]; then
    dtbfile="ds2422p"
elif [ "${TARGET_PLATFORM}" = "ds1520p" ]; then
    dtbfile="ds1520p"
else
    echo "${TARGET_PLATFORM} does not require model.dtc patching "    
fi

if [ -f /home/tc/custom-module/${dtbfile}.dts ] ; then
    sed -i "s/dtbpatch/redpill-dtb-static/g" custom_config.json
    sed -i "s/dtbpatch/redpill-dtb-static/g" custom_config_jun.json
fi

if [ $postupdate == "Y" ] ; then
    cecho y "Postupdate in progress..."  
    sudo ./rploader.sh postupdate ${TARGET_PLATFORM}-7.1.1-${TARGET_REVISION}

    echo                                                                                                                                        
    cecho y "Backup in progress..."
    echo                                                                                                                                        
    echo "y"|./rploader.sh backup    
    exit 0
fi

if [ $userdts == "Y" ] ; then
    
    cecho y "user-define dts file make in progress..."  
    echo
    
    cecho g "copy and paste user dts contents here, press any key to continue..."      
    read answer
    sudo vi /home/tc/custom-module/$dtbfile.dts

    cecho p "press any key to continue..."
    read answer

    echo                                                                                                                                        
    cecho y "Backup in progress..."
    echo                                                                                                                                        
    echo "y"|./rploader.sh backup    
    exit 0
fi

if [ -d "/home/tc/redpill-load" ] && [ $frmyv == "N" ] ; then
    cecho y "Cleaning lkm and load directory ..." 
#    cecho y "Do you want to clean redpill-load / lkm directory ? ( !!! Causion !!!, if you added ext from myv.sh, answer n )  [Yy/Nn]"
#    read answer                                                                                                                                         
#    if [ -n "$answer" ] && [ "$answer" = "Y" ] || [ "$answer" = "y" ] ; then                                                                            
       ./rploader.sh clean
#    fi
fi

echo

if [ $noconfig == "Y" ] ; then                            
    cecho r "SN Gen/Mac Gen/Vid/Pid/SataPortMap detection skipped!!"
    
    if [ $DTC_BASE_MODEL == "Y" ] ; then
        cecho p "Device Tree based model does not need SataPortMap setting...."     
    else
        checkmachine

        if [ "$MACHINE" = "VIRTUAL" ]; then
            cecho p "Sataportmap,DiskIdxMap to blank for VIRTUAL MACHINE"
            json="$(jq --arg var "" '.extra_cmdline.SataPortMap = $var' user_config.json)" && echo -E "${json}" | jq . >user_config.json
            json="$(jq --arg var "" '.extra_cmdline.DiskIdxMap = $var' user_config.json)" && echo -E "${json}" | jq . >user_config.json        
            cat user_config.json
        fi
        
    fi    
else 
    cecho c "Before changing user_config.json" 
    cat user_config.json

    if [ $realmac == "Y" ] ; then 
        echo "y"|./rploader.sh serialgen $MODEL realmac
    else
        echo "y"|./rploader.sh serialgen $MODEL
    fi

    #check nic count
    let nicport=0                                                                                                                                                 
    lspci -n | while read line; do                                                                                                                  
        class="$(echo $line | cut -c 9-12)"                                                                                                          
                                                                                                                                                     
        #echo "Class : $class"                                                                             
        case $class in                                                                                                                               
        0200)   
            let nicport=$nicport+1                                                                                                                                     
            #echo "Found Ethernet Interface port count: $nicport "       
            if [ $nicport -eq 2 ]; then
               cecho g "Two or more Ethernet Interface was detected!! $nicport "
               cecho g "Add mac2 automatically."
               macgen $MODEL
            fi                                                     
      
            ;;                                                                                                                                       
        esac                                                                                                                                         
    done 

    echo "y"|./rploader.sh identifyusb

    if  [ $DTC_BASE_MODEL == "Y" ] ; then
        cecho p "Device Tree based model does not need SataPortMap setting...."     
    else
        ./rploader.sh satamap    
        cat user_config.json        
    fi
fi

echo
echo
DN_MODEL="$(echo $MODEL | sed 's/+/%2B/g')"
echo "DN_MODEL is $DN_MODEL"

cecho p "DSM PAT file pre-downloading in progress..."
if [ $TARGET_REVISION == "42218" ]; then
    URL="https://global.download.synology.com/download/DSM/release/7.0.1/42218/DSM_${DN_MODEL}_$TARGET_REVISION.pat"
else
    URL="https://global.download.synology.com/download/DSM/release/7.1.1/42962/DSM_${DN_MODEL}_$TARGET_REVISION.pat"  
fi

cecho y "$URL"

patfile="/mnt/${tcrppart}/auxfiles/${SYNOMODEL}.pat"                                         
                                                                                             
    if [ -f ${patfile} ]; then                                                               
        cecho r "Found locally cached pat file ${SYNOMODEL}.pat in /mnt/${tcrppart}/auxfiles"
        cecho b "Downloadng Skipped!!!"                                                     
    else                                                                                    
        STATUS=`curl --insecure -w "%{http_code}" -L "${URL}" -o ${patfile} --progress-bar`
        if [ $? -ne 0 -o ${STATUS} -ne 200 ]; then
           echo  "Check internet or cache disk space"
           exit 99
        fi

        os_sha256=$(sha256sum ${patfile} | awk '{print $1}')                                
        cecho y "Pat file  sha256sum is : $os_sha256"                                       

        verifyid="${sha256}"                                                                
        cecho p "verifyid  sha256sum is : $verifyid"                                        

        if [ "$os_sha256" == "$verifyid" ]; then                                            
            cecho y "pat file sha256sum is OK ! "                                           
        else                                                                                
            cecho y "os sha256 verify FAILED, check ${patfile}  "                           
            exit 99                                                                         
        fi                                                                                  
    fi

echo
cecho g "Loader Building in progress..."
echo

if [ $manual == "Y" ] && [ $friend_mode == "N" ]; then    
    cecho r "Loader Manual Building in progress..." 

    if [ $TARGET_REVISION == "42218" ] ; then
#        cecho y "Manual option is not allowed in jun mode build, It is built with the static option!!!  "  
        ./rploader.sh build ${TARGET_PLATFORM}-7.0.1-42218-JUN junmanual                                                                  
    else
        echo "n"|./rploader.sh build ${TARGET_PLATFORM}-7.1.1-${TARGET_REVISION} manual   
    fi
else                                                                                                                           

    if [ $TARGET_REVISION == "42218" ] ; then
        ./rploader.sh build ${TARGET_PLATFORM}-7.0.1-42218-JUN jun                                                                        
    else
        if [ $friend_mode == "Y" ] ; then    
            echo "n"|./rploader.sh build ${TARGET_PLATFORM}-7.1.1-${TARGET_REVISION} withfriend
        else
            echo "n"|./rploader.sh build ${TARGET_PLATFORM}-7.1.1-${TARGET_REVISION}
        fi
    fi
fi 

if  [ -f /home/tc/custom-module/redpill.ko ] ; then  
    cecho y "Removing redpill.ko ..."
    rm -rf /home/tc/custom-module/redpill.ko
fi

echo                                                                                                                                                                           
cecho y "Backup in progress..."                                                                                                                                                
echo
                                                                                                                                                                           
rm -rf /home/tc/old                                                                                                                                                       
rm -rf /home/tc/oldpat.tar.gz                                                                                                                                             

if [ $noclean == "Y" ]  ; then                            
    cecho r "Cleaning redpill-load directory and pat files in auxfiles directory skipped!!!"                 
    rm -f /home/tc/redpill-load/cache/*
    rm -f /home/tc/redpill-load/loader.img                                                                   
    rm -rf /home/tc/redpill-load/.git
else                                                                                                         
    ./rploader.sh clean                                                                                  
    rm -f /mnt/${tcrppart}/auxfiles/*.pat                                                                    
fi 

rm -f /home/tc/custom-module                                                                                                                                             
echo "y"|./rploader.sh backup                                                                                                                                         

exit 0
