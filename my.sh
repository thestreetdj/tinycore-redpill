#!/bin/bash

# my.sh (Batch Shell Script for rploader.sh)                 
# Made by Peter Suh
# 2022.04.18                      
# Update add 42661 U1 NanoPacked 
# 2022.04.28
# Update : add noconfig, noclean, manual options
# 2022.04.30
# Update : add noconfig, noclean, manual combinatione options
# 2022.05.06   
# Update : add pat file sha256 check                         
# 2022.05.07      
# Update : Added dtc compilation function for user custom.dts file
# 2022.05.15
# Update : add jumkey's jun mode
# 2022.05.24
# Update : apply jumkey's dyn dtc upx
# 2022.05.25
# Update : apply jumkey's dyn dtc upx for option
# 2022.06.01
# Update : add rd.gz patch for 42661 U2
# 2022.06.03
# Update : Fixed Jun mode build option incorrectly applied
# 2022.06.06
# Update : Add jumkey's Jun mode (use jumkey repo)
# 2022.06.11
# Update : Adjunst Option Operation
# 2022.06.13
# Update : Add manual option for jun mode
# 2022.06.16

mshellgz="my.sh.gz"
mshtarfile="https://raw.githubusercontent.com/PeterSuh-Q3/tinycore-redpill/main/my.sh.gz"

# Function cecho                                                                                        
# Made by FOXBI                                                                                                               
# 2022.04.14                                                                                                                  
# ==============================================================================          
# Color Function                                                                          
# ==============================================================================          
cecho () {                                                                                
    if [ -n "$3" ]                                                                                                            
    then                                                                                  
        case "$3" in                                                                                 
            black  | bk) bgcolor="40";;                                                              
            red    |  r) bgcolor="41";;                                                              
            green  |  g) bgcolor="42";;                                                                 
            yellow |  y) bgcolor="43";;                                             
            blue   |  b) bgcolor="44";;                                             
            purple |  p) bgcolor="45";;                                                   
            cyan   |  c) bgcolor="46";;                                             
            gray   | gr) bgcolor="47";;                                             
        esac                                                                        
    else                                                                            
        bgcolor="0"                                                                 
    fi                                                                              
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


function checkinternet() {

    echo -n "Checking Internet Access -> "
    nslookup github.com 2>&1 >/dev/null
    if [ $? -eq 0 ]; then
        echo "OK"
    else
        cecho g "Error: No internet found, or github is not accessible"
        exit 99
    fi

}

function getlatestmshell() {

    echo -n "Checking if a newer mshell version exists on the repo -> "

    if [ ! -f $mshellgz ]; then
        curl -s --location "$mshtarfile" --output $mshellgz
    fi

    curl -s --location "$mshtarfile" --output latest.mshell.gz

    CURRENTSHA="$(sha256sum $mshellgz | awk '{print $1}')"
    REPOSHA="$(sha256sum latest.mshell.gz | awk '{print $1}')"

    if [ "${CURRENTSHA}" != "${REPOSHA}" ]; then
        echo -n "There is a newer version of m shell script on the repo should we use that ? [yY/nN]"
        read confirmation
        if [ "$confirmation" = "y" ] || [ "$confirmation" = "Y" ]; then
            echo "OK, updating, please re-run after updating"
            cp -f /home/tc/latest.mshell.gz /home/tc/$mshellgz
            rm -f /home/tc/latest.mshell.gz
            tar -zxvf $mshellgz
            echo "Updating m shell with latest updates"
            exit
        else
            rm -f /home/tc/latest.mshell.gz
            return
        fi
    else
        echo "Version is current"
        rm -f /home/tc/latest.mshell.gz
    fi

}


function macgen() {

    mac2="$(generateMacAddress $1)"

    cecho y "Mac2 Address for Model $1 : $mac2 "

    macaddress2=$(echo $mac2 | sed -s 's/://g')

    sed -i "/\"extra_cmdline\": {/c\  \"extra_cmdline\": {\"mac2\": \"$macaddress2\",\"netif_num\": \"2\", "  user_config.json

    echo "After changing user_config.json"      
    cat user_config.json

}

function generateMacAddress() {
    printf '00:11:32:%02X:%02X:%02X' $((RANDOM % 256)) $((RANDOM % 256)) $((RANDOM % 256))

}

function showhelp() {
    cat <<EOF
$(basename ${0})

----------------------------------------------------------------------------------------
Usage: ${0} <Synology Model Name> <Options>

Options: postupdate, jumkey, noconfig, noclean, manual

- postupdate : Option to patch the restore loop after applying DSM 7.1.0-42661 Update 2, no additional build required.

- jumkey  : Option to apply jumkey's dynamic automatic dtc patch extension files (contrary to pocopico's static dtc patch).  

- noconfig: SKIP automatic detection change processing such as SN/Mac/Vid/Pid/SataPortMap of user_config.json file.

- noclean: SKIP the 💊   RedPill LKM/LOAD directory without clearing it with the Clean command. 
           However, delete the Cache directory and loader.img.

- manual: Options for manual extension processing and manual dtc processing in build action (skipping extension auto detection)

Please type Synology Model Name after ./$(basename ${0})

./$(basename ${0}) DS918+
./$(basename ${0}) DS3617xs
./$(basename ${0}) DS3615xs
./$(basename ${0}) DS3622xs+
./$(basename ${0}) DVA3221
./$(basename ${0}) DS920+
./$(basename ${0}) DS1621+

- for jun mode

./$(basename ${0}) DS918+J                                                                                                      
./$(basename ${0}) DS3617xsJ                                                                                                    
./$(basename ${0}) DS3615xsJ                                                                                                    
./$(basename ${0}) DS3622xs+J                                                                                                   
./$(basename ${0}) DVA3221J                                                                                                     
./$(basename ${0}) DS920+J                                                                                                      
./$(basename ${0}) DS1621+J  

EOF

}

checkinternet
getlatestmshell

if [ $# -lt 1 ]; then
    showhelp 
    exit 99
fi

echo 

TARGET_REVISION="42661"


    if [ "$1" = "DS918+" ]; then        
        TARGET_PLATFORM="apollolake"                                                                                                                           
        SYNOMODEL="ds918p_$TARGET_REVISION"                                                                                                                    
        sha256="4e8a9d82a8a1fde5af9a934391080b7bf6b91811d9583acb73b90fb6577e22d7"                                                                              
    elif [ "$1" = "DS3615xs" ]; then                                                                                                                     
        TARGET_PLATFORM="bromolow"                                                                                                                             
        SYNOMODEL="ds3615xs_$TARGET_REVISION"                                                                                                                  
        sha256="1e95d8c63981bcf42ea2eaedfbc7acc4248ff16d129344453b7479953f9ad145"                                                                              
    elif [ "$1" = "DS3617xs" ]; then                                                                                                                     
        TARGET_PLATFORM="broadwell"                                                                                                                            
        SYNOMODEL="ds3617xs_$TARGET_REVISION"                                                                                                                  
        sha256="0a5a243109098587569ab4153923f30025419740fb07d0ea856b06917247ab5c"                                                                              
    elif [ "$1" = "DS3622xs+" ]; then                                                                                                                    
        TARGET_PLATFORM="broadwellnk"                                                                                                                          
        SYNOMODEL="ds3622xsp_$TARGET_REVISION"                                                                                                                 
        sha256="53d0a4f1667288b6e890c4fdc48422557ff26ea8a2caede0955c5f45b560cccd"                                                                              
    elif [ "$1" = "DS1621+" ]; then                                                                                                                      
        TARGET_PLATFORM="v1000"                                                                                                                                
        SYNOMODEL="ds1621p_$TARGET_REVISION"                                                                                                                   
        sha256="381077302a89398a9fb5ec516217578d6f33b0219fe95135e80fd93cddbf88c4"                                                                              
#        dtbfile="ds1621p"                                                                                                                                     
    elif [ "$1" = "DVA3221" ]; then                                                                                                                      
        TARGET_PLATFORM="denverton"                                                                                                                            
        SYNOMODEL="dva3221_$TARGET_REVISION"                                                                                                                   
        sha256="ed3207db40b7bac4d96411378558193b7747ebe88f0fc9c26c59c0b5c688c359"                                                                              
    elif [ "$1" = "DS920+" ]; then                                                                                                                       
        TARGET_PLATFORM="geminilake"                                                                                                                           
        SYNOMODEL="ds920p_$TARGET_REVISION"                                                                                                                    
        sha256="8076950fdad2ca58ea9b91a12584b9262830fe627794a0c4fc5861f819095261"                                                                              
#        dtbfile="ds920p"                                                                                                                                      
                                                                                                                                                               
    elif [ "$1" = "DS918+J" ]; then                                                                                                                      
        TARGET_REVISION="42218"                                                                                                                                
        TARGET_PLATFORM="apollolake"                                                                                                                       
        SYNOMODEL="ds918p_$TARGET_REVISION"                                                                                                                    
        sha256="a403809ab2cd476c944fdfa18cae2c2833e4af36230fa63f0cdee31a92bebba2"                                                                              
    elif [ "$1" = "DS3615xsJ" ]; then         
        TARGET_REVISION="42218"               
        TARGET_PLATFORM="bromolow"            
        SYNOMODEL="ds3615xs_$TARGET_REVISION"                                   
        sha256="dddd26891815ddca02d0d53c1d42e8b39058b398a4cc7b49b80c99f851cf0ef7"                             
    elif [ "$1" = "DS3617xsJ" ]; then                                           
        TARGET_REVISION="42218"               
        TARGET_PLATFORM="broadwell"           
        SYNOMODEL="ds3617xs_$TARGET_REVISION" 
        sha256="d65ee4ed5971e38f6cdab00e1548183435b53ba49a5dca7eaed6f56be939dcd2"                             
    elif [ "$1" = "DS3622xs+J" ]; then        
        TARGET_REVISION="42218"               
        TARGET_PLATFORM="broadwellnk"         
        SYNOMODEL="ds3622xsp_$TARGET_REVISION"
        sha256="f38329b8cdc5824a8f01fb1e377d3b1b6bd23da365142a01e2158beff5b8a424"                                                                
    elif [ "$1" = "DS1621+J" ]; then                                             
        TARGET_REVISION="42218"                                                  
        TARGET_PLATFORM="v1000"                                                  
        SYNOMODEL="ds1621p_$TARGET_REVISION"                                     
        sha256="19f56827ba8bf0397d42cd1d6f83c447f092c2c1bbb70d8a2ad3fbd427e866df"                                                                
    elif [ "$1" = "DVA3221J" ]; then                                             
        TARGET_REVISION="42218"                                                  
        TARGET_PLATFORM="denverton"                                              
        SYNOMODEL="dva3221_$TARGET_REVISION"                                     
        sha256="01f101d7b310c857e54b0177068fb7250ff722dc9fa2472b1a48607ba40897ee"  
    elif [ "$1" = "DS920+J" ]; then                                                                                                                      
        TARGET_REVISION="42218"
        TARGET_PLATFORM="geminilake"                                                                                                                       
        SYNOMODEL="ds920p_$TARGET_REVISION"                                                                                                                    
        sha256="fe2a4648f76adeb65c3230632503ea36bbac64ee88b459eb9bfb5f3b8c8cebb3"     
    else                                                                                                     
        echo "Synology model not supported by TCRP."                                                         
        exit 0                                                                                               
    fi    

tem="$1"

if [ $TARGET_REVISION == "42218" ] ; then
    MODEL="$(echo $tem | sed 's/J//g')"
else
    MODEL=$tem
fi


cecho y "MODEL is $MODEL"

#Options map to variable
jumkey="N"
postupdate="N"
noclean="N"
noconfig="N"
manual="N"

while [ "$2" != "" ]; do
#    echo $2

        case $2 in

        jumkey)
            jumkey="Y"
            ;;

        postupdate)
            postupdate="Y"
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

        *)
            echo "Syntax error, not valid arguments or not enough options"
            exit 0
            ;;

        esac

    shift 
done

#echo $jumkey
#echo $postupdate
#echo $noclean
#echo $noconfig
#echo $manual

#   cecho y "Cleaning lkm and load directory ..." 
#   ./rploader.sh clean  

if [ $TARGET_REVISION == "42218" ] ; then  
   if [ $postupdate == "Y" ] ; then                                                                                                                
                                                                                                                                                    
      cecho g "postupdate is not allowed on jun mode."                                                                                              
      exit 99                                                                                                                                       
                                                                                                                                                    
   fi                                                                                                                                               
else
   if [ $postupdate == "Y" ] ; then
      if [ $# -gt 2 ]; then
          cecho g "Additional options are not allowed on postupdate."
          exit 99                                                                                                                                 
      fi       
      cecho y "Postupdate for 42661 update 2 in progress..."  

      ./rploader.sh postupdate ${TARGET_PLATFORM}-7.1.0-${TARGET_REVISION}
      echo                                                                                                                                        
      cecho y "Backup in progress..."                                                                                                             
      echo                                                                                                                                        
      echo "y"|./rploader.sh backup    
      exit 0

   fi
fi

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

#dtc
#    if [ ! -d /lib64 ]; then
#        [ ! -h /lib64 ] && sudo ln -s /lib /lib64
#    fi
#
#    dtcbin="https://raw.githubusercontent.com/pocopico/tinycore-redpill/main/dtc"
#
#    echo "Downloading dtc binary"
#    curl --location --progress-bar "$dtcbin" -O
#    chmod 700 dtc
#
#    if [ -f /home/tc/custom-module/${dtbfile}.dts ]; then                                                    
#        cecho r "Fould locally cached dts file"                                                              
#        cecho y "Converting dts file : ${dtbfile}.dts to dtb file : >${dtbfile}.dtb "                        
#        ./dtc -q -I dts -O dtb /home/tc/custom-module/${dtbfile}.dts >/home/tc/custom-module/${dtbfile}.dtb  
#    fi 

echo
cecho y "TARGET_PLATFORM is $TARGET_PLATFORM"
cecho g "SYNOMODEL is $SYNOMODEL"  

if [ "$MODEL" == "DS920+" ] || [ "$MODEL" == "DS1621+" ] ; then                                                                                                         

    if [ $jumkey == "Y" ] ; then 
    	cecho p "jumkey's dynamic auto dtc patch ext file pre-downloading in progress..."  
    	curl --location --progress-bar "https://github.com/PeterSuh-Q3/tinycore-redpill/raw/main/custom_config_jun.json" --output custom_config_jun.json
    	curl --location --progress-bar "https://github.com/PeterSuh-Q3/tinycore-redpill/raw/main/rploader.sh" --output rploader.sh
    fi

else

    if [ $jumkey == "Y" ]; then                                     
        echo "This Synology model not supported jumkey dynamic dtc patch in TCRP."    
        exit 0                                                        
    fi  

    if [ $TARGET_REVISION == "42218" ] && [ $manual == "Y" ]; then                                                                                        
        curl --location --progress-bar "https://github.com/PeterSuh-Q3/tinycore-redpill/raw/main/rploader.sh" --output rploader.sh                                                                                                                                         
    fi 

fi


if [ $jumkey != "Y" ] && [ $TARGET_REVISION != "42218" ] && [ $manual != "Y" ]  ; then  
    echo "y"|./rploader.sh update                                                                                                                       
    echo "n"|./rploader.sh fullupgrade                                                                                            

    if [ $noconfig == "Y" ] ; then
        cecho y "Automatically restore your own user_config.json by noconfig option..."   
        cp -f /home/tc/old/user_config.json.* ./user_config.json 
    else
    	cecho y "Do you want to restore your own user_config.json from old directory ?  [Yy/Nn]"                                                            
   	read answer                                                                                                                                         
    	if [ -n "$answer" ] && [ "$answer" = "Y" ] || [ "$answer" = "y" ] ; then                                                                            
            cp -f /home/tc/old/user_config.json.* ./user_config.json                                                                                        
    	else                                                                                                                                                
            echo "OK Remember that the new user_config.json file is used and your own user_config.json is deleted. "                                        
    	fi
    fi   
fi

if [ $noconfig == "Y" ] ; then                            
    cecho r "SN Gen/Mac Gen/Vid/Pid/SataPortMap detection skipped!!"                                         
else 
    cecho c "Before changing user_config.json" 
    cat user_config.json

    echo "y"|./rploader.sh serialgen $MODEL

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

    if [ "$MODEL" == "DS920+" ] || [ "$MODEL" == "DS1621+" ] ; then                                                             
    	cecho p "Device Tree usage model does not need SataPortMap setting...." 
    else
    	./rploader.sh satamap
    fi
fi


echo
echo
cecho p "DSM PAT file pre-downloading in progress..."
if [ $TARGET_REVISION == "42218" ]; then
    URL="https://global.download.synology.com/download/DSM/release/7.0.1/42218/DSM_${MODEL}_$TARGET_REVISION.pat"
else
    URL="https://global.download.synology.com/download/DSM/release/7.1/42661-1/DSM_${MODEL}_$TARGET_REVISION.pat"  
fi

cecho y "$URL"

patfile="/mnt/${tcrppart}/auxfiles/${SYNOMODEL}.pat"                                         
                                                                                             
    if [ -f ${patfile} ]; then                                                               
        cecho r "Found locally cached pat file ${SYNOMODEL}.pat in /mnt/${tcrppart}/auxfiles"
        cecho b "Downloadng Skipped!!!"                                                     
    else                                                                                    
        curl -o ${patfile} $URL                                                             
                                                                                            
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

if [ $manual == "Y" ]; then    
    cecho r "Loader Manual Building in progress..." 

    if [ $TARGET_REVISION == "42218" ] ; then
#        cecho y "Manual option is not allowed in jun mode build, It is built with the static option!!!  "  
        ./rploader.sh build ${TARGET_PLATFORM}-7.0.1-42218-JUN junmanual                                                                  
    else
        echo "n"|./rploader.sh build ${TARGET_PLATFORM}-7.1.0-${TARGET_REVISION} manual   
    fi
else                                                                                                                           

    if [ $TARGET_REVISION == "42218" ] ; then
        ./rploader.sh build ${TARGET_PLATFORM}-7.0.1-42218-JUN jun                                                                        
    else
        echo "n"|./rploader.sh build ${TARGET_PLATFORM}-7.1.0-${TARGET_REVISION}     
    fi
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
else                                                                                                         
    ./rploader.sh clean                                                                                  
    rm -f /mnt/${tcrppart}/auxfiles/*.pat                                                                    
fi 

rm -f /home/tc/custom-module                                                                                                                                             
echo "y"|./rploader.sh backup                                                                                                                                         
                                          

exit 0
