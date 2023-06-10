#!/usr/bin/env bash
set -u

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
# Update : Add dtc mode for known as non-dtc model
# 2022.06.25
# Update : Add dtc model DS2422+ (v1000) support
# 2022.06.27
# Update : remove jumkey, poco oprtions
# 2022.06.30
# Update : Add DS2422+ jot mode
# 2022.07.02
# Update : Add DVA1622 jun mode (Testing)
# 2022.07.07
# Update : Add DS1520+ jun mode
# 2022.07.08
# Update : Add FS2500 jun mode
# 2022.07.10
# Update : function headers for my.sh and myv.shUse common function headers for my.sh and myv.sh
# 2022.07.11
# Update : Add REALMAC Option
# 2022.07.15
# Update : Add DS1621xs+ jun mode
# 2022.07.19
# Update : Add DS1621xs+ jot mode, Add RS4021xs+
# 2022.07.20
# Update : Add DVA3219 jot mode (Release 22.07.25)
# 2022.07.21
# Update : Active rploader.sh satamap for non dtc model
# 2022.07.27
# Update : Add Re-Install DSM menuentry
# 2022.08.03
# Update : Apply fabio's redpill.ko
# 2022.08.04
# Update : Add Userdts Options
# 2022.08.06
# Update : Release FS2500 Jot / Jun Mode
# 2022.08.12
# Update : Add RS3618xs Jot / Jun Mode
# 2022.08.14
# Update : Add RS3413xs+ Jot / Jun Mode
# 2022.08.16
# Update : Added support for DSM 7.1.1-42962
# 2022.09.13
# Update : Add DS1019+ Jot / Jun Mode
# 2022.09.14
# Update : Release DS1520+ jot mode
# 2022.09.14
# Update : Release DVA3219 jun mode
# 2022.09.14
# Update : Sataportmap,DiskIdxMap to blank for VM with noconfig option
# 2022.09.14
# Update : Release TCRP FRIEND mode
# 2022.09.25
# Update : Change to stable redpill kernel ( DS1621xs+, DVA3221, RS3618xs )
# 2022.09.26
# Update : Synchronization according to the TCRP Platform naming convention
# 2022.10.22
# Update : Dropped support for TCRP Jot's Mod /Jun's Mod.
# 2022.11.11
# Update : Deploy menu.sh
# 2022.11.14
# Update : Added autoupdate script, Added Keymap function to menu.sh for multilingual keybaord support
# 2022.11.17
# Update : Added dual mac address make function to menu.sh
# 2022.11.18
# Update : Added ds923+ (r1000)
# 2022.11.25
# Update : Added gitee conversion function when github connection is not possible
# 2022.12.03
# Update : Added quad mac address make function to menu.sh
# 2022.12.04
# Update : Added independent JOT mode build menu to menu.sh
# 2022.12.06
# Correct serial number for DS1520+,DS923+, by Orphee
# 2022.12.13
# Update : Added ds723+ (r1000)
# 2023.01.15
# Update : Add buildable model limit per CPU max threads to menu.sh, add description of features and restrictions for each model
# 2023.01.28
# Update : DT-based model restriction function added to ./menu.sh
# 2023.01.30
# Update : Separation and addition to menu_m.sh for real-time reflection after menu.sh update
# 2023.01.30
# Update : 7.0.1-42218 friend correspondence for DS918+,DS920+,DS1019+, DS1520+ transcoding
# 2023.02.19
# Update : Inspection of FMA3 command support (Haswell or higher) and model restriction function added to menu.sh
# 2023.02.22
# Update :  menu.sh Added new function DDSML / EUDEV selection
#           DDSML ( Detected Device Static Module Loading with modprobe / insmod command )
#           EUDEV (Enhanced Userspace Device with eudev deamon)
# 2023.03.01
# Update : Added erase data disk function to menu.sh
# 2023.03.04
# Update : Increased build processing speed by using RAMDISK & pigz(multithreaded compression) when processing encrypted DSM PAT file decryption
# 2023.03.10
# Update : Improved TCRP loader build process
# 2023.03.14
# Update : Automatic handling of grub.cfg disable_mtrr_trim=1 to unlock AMD Platform 3.5GB RAM limitation
# 2023.03.17
# Update : AMD CPU FRIEND mode menu usage restriction release (except HP N36L/N40L/N54L)
# 2023.03.18
# Update : TCRP FRIEND / JOT menu selection method improvement
# 2023.03.21
# Update : Multilingual menu support started (Korean, Chinese, Japanese, Russian, French, German, Spanish, Brazilian, Italian supported)
# 2023.03.25
# Update : Add language selection menu
# 2023.03.29
# Update : Merging DDSML and EUDEV into one, Improved nic recognition speed by improving realtek firmware omission
# 2023.04.04
# Update : DSM Smallupdateversion Path Management
# 2023.04.15
# Update : Keymap now actually works. (Thanks Orphée)
# 2023.04.29
# Update : Add Postupdate boot entry to Grub Boot for Jot Postupdate to utilize FRIEND's Ramdisk Update
# 2023.05.01
# Update : Add Support DSM 7.2-64551 RC
# 2023.05.02
# Update : Added sa6400 (epyc7002)
# 2023.05.06
# Update : Add 5 models DS720+,RS1221+,RS1619xs+,RS3621xs+,SA3400
# 2023.05.08
# Update : 7.0.1-42218 menu open for all models
# 2023.05.12
# Update : Add Support DSM 7.2-64561 Official Version
# 2023.05.23
# Update : Add Getty Console to DSM 7.2
# 2023.05.26
# Update : Added ds916+ (braswell), 7.2.0 Jot Menu Creation for HP PCs
# 2023.06.03
# Update : Add Support DSM 7.2-64570 Official Version
# 2023.06.09

function showlastupdate() {
    cat <<EOF

# Update : Release TCRP FRIEND mode
# 2022.09.25

# Update :  menu.sh Added new function DDSML / EUDEV selection
#           DDSML ( Detected Device Static Module Loading with modprobe / insmod command )
#           EUDEV (Enhanced Userspace Device with eudev deamon)
# 2023.03.01

# Update : AMD CPU FRIEND mode menu usage restriction release (except HP N36L/N40L/N54L)
# 2023.03.18

# Update : Multilingual menu support started (Korean, Chinese, Japanese, Russian, French, German, Spanish, Brazilian, Italian supported)
# 2023.03.25

# Update : Keymap now actually works. (Thanks Orphée)
# 2023.04.29

# Update : Add Postupdate boot entry to Grub Boot for Jot Postupdate to utilize FRIEND's Ramdisk Update
# 2023.05.01

# Update : Add Support DSM 7.2-64570 Official Version
# 2023.05.23

# Update : Add Getty Console to DSM 7.2
# 2023.05.26

# Update : Added ds916+ (braswell), 7.2.0 Jot Menu Creation for HP PCs
# 2023.06.03

# Update : Add Support DSM 7.2-64570 Official Version
# 2023.06.09

EOF
}

function showhelp() {
    cat <<EOF
$(basename ${0})

----------------------------------------------------------------------------------------
Usage: ${0} <Synology Model Name> <Options>

Options: update, postupdate, noconfig, noclean, manual, realmac, userdts

- update : Option to handle updates to the m shell.

- postupdate : Option to patch the restore loop after applying DSM 7.1.0-42661 after Update 2, no additional build required.

- noconfig: SKIP automatic detection change processing such as SN/Mac/Vid/Pid/SataPortMap of user_config.json file.

- noclean: SKIP the 💊   RedPill LKM/LOAD directory without clearing it with the Clean command. 
           However, delete the Cache directory and loader.img.

- manual: Options for manual extension processing and manual dtc processing in build action (skipping extension auto detection).

- realmac : Option to use the NIC's real mac address instead of creating a virtual one.

- userdts : Option to use the user-defined platform.dts file instead of auto-discovery mapping with dtcpatch.


Please type Synology Model Name after ./$(basename ${0})

- for friend mode

./$(basename ${0}) DS918+G
./$(basename ${0}) DS3617xsG
./$(basename ${0}) DS3615xsG
./$(basename ${0}) DS3622xs+G                                                                                                   
./$(basename ${0}) DVA3221G
./$(basename ${0}) DS920+G                                                                                                      
./$(basename ${0}) DS1621+G 
./$(basename ${0}) DS2422+G  
./$(basename ${0}) DVA1622G
./$(basename ${0}) DS1520+G
./$(basename ${0}) FS2500G
./$(basename ${0}) DS1621xs+G
./$(basename ${0}) RS4021xs+G 
./$(basename ${0}) DVA3219G
./$(basename ${0}) RS3618xsG
./$(basename ${0}) DS1019+G
./$(basename ${0}) DS923+G
./$(basename ${0}) DS723+G
./$(basename ${0}) SA6400G
./$(basename ${0}) DS720+G
./$(basename ${0}) RS1221+G
./$(basename ${0}) RS1619xs+G
./$(basename ${0}) RS3621xs+G
./$(basename ${0}) SA6400G
./$(basename ${0}) DS916+G

ex) Except for postupdate and userdts that must be used alone, the rest of the options can be used in combination. 

- When you want to build the loader while maintaining the already set SN/Mac/Vid/Pid/SataPortMap
./my.sh DS3622xs+ noconfig

- When you want to build the loader while maintaining the already set SN/Mac/Vid/Pid/SataPortMap and without deleting the downloaded DSM pat file.
./my.sh DS3622xs+ noconfig noclean

- When you want to build the loader while using the real MAC address of the NIC, with extended auto-detection disabled
./my.sh DS3622xs+ realmac manual

EOF

}

function getvars()
{

    TARGET_REVISION="42962"
    SUVP=""
    ORIGIN_PLATFORM=""

# JOT / FRIEND MODE
    if [ "${1}" = "DS918+F" ]; then        
        SUVP="-1"
    elif [ "${1}" = "DS3615xsF" ]; then                                                                                                                     
        SUVP="-1"
    elif [ "${1}" = "DS3617xsF" ]; then                                                                                                                     
        SUVP="-1"
    elif [ "${1}" = "DS3622xs+F" ]; then
        SUVP="-1"
    elif [ "${1}" = "DS1621+F" ]; then
        SUVP="-1"
    elif [ "${1}" = "DVA3221F" ]; then                                                                                                                      
        SUVP="-1"        
    elif [ "${1}" = "DVA1622F" ]; then
        SUVP="-1"        
    elif [ "${1}" = "DS920+F" ]; then
        SUVP="-1"
    elif [ "${1}" = "DS923+F" ]; then
        SUVP="-5"
    elif [ "${1}" = "DS723+F" ]; then
        SUVP="-5"
# JOT / FRIEND MODE NEW MODEL SUCCESS
    elif [ "${1}" = "DS2422+F" ] ; then
        SUVP="-1"
    elif [ "${1}" = "DS1621xs+F" ]; then
        SUVP="-1"
    elif [ "${1}" = "RS4021xs+F" ]; then
        SUVP="-5"
    elif [ "${1}" = "SA3600F" ]; then
        SUVP="-1"    
    elif [ "${1}" = "SA6400F" ]; then
        SUVP="-1"    
    elif [ "${1}" = "DVA3219F" ]; then
        SUVP="-1"
    elif [ "${1}" = "FS2500F" ]; then
        SUVP="-1"
    elif [ "${1}" = "RS3618xsF" ]; then                                                                                                                     
        SUVP="-1"
    elif [ "${1}" = "DS1019+F" ]; then        
        SUVP="-1"
    elif [ "${1}" = "DS1520+F" ]; then
        SUVP="-1"
    elif [ "${1}" = "DS720+F" ]; then
        SUVP="-1"
    elif [ "${1}" = "RS1221+F" ]; then
        SUVP="-1"
    elif [ "${1}" = "RS1619xs+F" ]; then
        SUVP="-1"
    elif [ "${1}" = "RS3621xs+F" ]; then
        SUVP="-5"
    elif [ "${1}" = "SA3400F" ]; then
        SUVP="-1"
# JOT MODE NEW MODEL TESTTING                
    elif [ "${1}" = "RS3413xs+" ] || [ "${1}" = "RS3413xs+F" ]; then
        echo "Synology model ${1} jot mode not supported by m shell, Testing..."        
        exit 0        
        
#JUN MODE
    elif [ "${1}" = "DS918+J" ]; then           
        TARGET_REVISION="42218"
    elif [ "${1}" = "DS3615xsJ" ]; then
        TARGET_REVISION="42218"               
    elif [ "${1}" = "DS3617xsJ" ]; then
        TARGET_REVISION="42218"               
    elif [ "${1}" = "DS3622xs+J" ]; then
        TARGET_REVISION="42218"               
    elif [ "${1}" = "DS1621+J" ]; then
        TARGET_REVISION="42218"                                                  
    elif [ "${1}" = "DVA3221J" ]; then
        TARGET_REVISION="42218"                                                  
    elif [ "${1}" = "DS920+J" ]; then
        TARGET_REVISION="42218"
    elif [ "${1}" = "DS2422+J" ]; then
        TARGET_REVISION="42218"                                                  
# JUN MODE NEW MODEL SUCCESS
    elif [ "${1}" = "DS1520+J" ]; then
        TARGET_REVISION="42218"
    elif [ "${1}" = "DS1621xs+J" ]; then
        TARGET_REVISION="42218"               
    elif [ "${1}" = "FS2500J" ]; then
        TARGET_REVISION="42218"
    elif [ "${1}" = "RS4021xs+J" ]; then
        TARGET_REVISION="42218"               
    elif [ "${1}" = "RS3618xsJ" ]; then                                                                                                                     
        TARGET_REVISION="42218"        
    elif [ "${1}" = "DS1019+J" ]; then
        TARGET_REVISION="42218"                                                                                                                                
    elif [ "${1}" = "DVA3219J" ]; then
        TARGET_REVISION="42218"                                                  

# JUN MODE NEW MODEL TESTTING
#    elif [ "${1}" = "RS3413xs+J" ]; then
#        echo "Synology model ${1} jun mode not supported by m shell, Testing..."
#        exit 0        
#        
#        TARGET_REVISION="42218"        
#        TARGET_PLATFORM="rs3413xsp"
#        ORIGIN_PLATFORM="bromolow"        
#        SYNOMODEL="rs3413xsp_$TARGET_REVISION"
#        sha256="9796536979407817ca96aef07aaabb3f03252a8e54df0f64ff7caf3c737f0da9"        
#    elif [ "${1}" = "DVA1622J" ]; then
#        KVER="Y"    
#        echo "Synology model ${1} jun mode not supported by m shell"
#        exit 0     
        
#DSM 7.2 Official
    elif [ "${1}" = "DS1019+G" ]; then        
        TARGET_REVISION="64570"
    elif [ "${1}" = "DS1520+G" ]; then
        TARGET_REVISION="64570"
    elif [ "${1}" = "DS1621+G" ]; then
        TARGET_REVISION="64570"
    elif [ "${1}" = "DS1621xs+G" ]; then
        TARGET_REVISION="64570"
    elif [ "${1}" = "DS2422+G" ] ; then
        TARGET_REVISION="64570"
    elif [ "${1}" = "DS3617xsG" ]; then                                                                                                                     
        TARGET_REVISION="64570"    
    elif [ "${1}" = "DS3622xs+G" ]; then
        TARGET_REVISION="64570"    
    elif [ "${1}" = "DS720+G" ]; then
        TARGET_REVISION="64570"
    elif [ "${1}" = "DS723+G" ]; then
        TARGET_REVISION="64570"    
    elif [ "${1}" = "DS916+G" ]; then           
        TARGET_REVISION="64570"
    elif [ "${1}" = "DS918+G" ]; then           
        TARGET_REVISION="64570"
    elif [ "${1}" = "DS920+G" ]; then
        TARGET_REVISION="64570"    
    elif [ "${1}" = "DS923+G" ]; then
        TARGET_REVISION="64570"    
    elif [ "${1}" = "DVA1622G" ]; then
        TARGET_REVISION="64570"    
    elif [ "${1}" = "DVA3219G" ]; then
        TARGET_REVISION="64570"
    elif [ "${1}" = "DVA3221G" ]; then                                                                                                                      
        TARGET_REVISION="64570"    
    elif [ "${1}" = "FS2500G" ]; then
        TARGET_REVISION="64570"
    elif [ "${1}" = "RS1221+G" ]; then
        TARGET_REVISION="64570"
    elif [ "${1}" = "RS3618xsG" ]; then                                                                                                                     
        TARGET_REVISION="64570"
    elif [ "${1}" = "RS3621xs+G" ]; then
        TARGET_REVISION="64570"
    elif [ "${1}" = "RS4021xs+G" ]; then
        TARGET_REVISION="64570"
    elif [ "${1}" = "SA6400G" ]; then
        TARGET_REVISION="64561"        
    else                                                                                                     
        echo "Synology model not supported by TCRP."                                                         
        exit 0                                                                                               
    fi    

    tem="${1}"

    if [ "$TARGET_REVISION" == "42218" ]; then
        MODEL="$(echo $tem | sed 's/J//g')"
        TARGET_VERSION="7.0.1"
        KVER="4.4.180"
    elif [ "$TARGET_REVISION" == "64551" ]; then
        MODEL="$(echo $tem | sed 's/K//g')"
        TARGET_VERSION="7.2"
        KVER="4.4.302"        
    elif [ "$TARGET_REVISION" == "64570" ]; then
        MODEL="$(echo $tem | sed 's/G//g')"
        TARGET_VERSION="7.2"
        KVER="4.4.302"        
    elif [ "$TARGET_REVISION" == "42962" ]; then
        if [ $tem = "FS2500F" ]; then
            MODEL="FS2500"
        elif [ $tem = "FS2500" ]; then    
            MODEL="FS2500"
        else
            if [ $(echo $tem | grep F | wc -l) -gt 0 ]; then
                MODEL="$(echo $tem | sed 's/F//g')"
            else
                MODEL=$tem
            fi
        fi    
        TARGET_VERSION="7.1.1"
        KVER="4.4.180"                
    else
        echo "Synology model revesion not supported by TCRP."                                                         
        exit 0                                                                                               
    fi

    echo "MODEL is $MODEL"
    TARGET_PLATFORM=$(echo "$MODEL" | sed 's/DS/ds/' | sed 's/RS/rs/' | sed 's/+/p/' | sed 's/DVA/dva/' | sed 's/FS/fs/' | sed 's/SA/sa/' )
    SYNOMODEL="${TARGET_PLATFORM}_${TARGET_REVISION}"

    if [ "${MODEL}" = "DS918+" ]||[ "${MODEL}" = "DS1019+" ]; then
        ORIGIN_PLATFORM="apollolake"
    elif [ "${MODEL}" = "DS3615xs" ]; then
        ORIGIN_PLATFORM="bromolow"
    elif [ "${MODEL}" = "DS3617xs" ]||[ "${MODEL}" = "RS3618xs" ]; then
        ORIGIN_PLATFORM="broadwell"
    elif [ "${MODEL}" = "DS3622xs+" ]||[ "${MODEL}" = "DS1621xs+" ]||[ "${MODEL}" = "RS4021xs+" ]||[ "${MODEL}" = "SA3400" ]||[ "${MODEL}" = "RS1619xs+" ]||[ "${MODEL}" = "RS3621xs+" ]; then
        ORIGIN_PLATFORM="broadwellnk"
    elif [ "${MODEL}" = "DVA3221" ]||[ "${MODEL}" = "DVA3219" ]; then
        ORIGIN_PLATFORM="denverton"
    elif [ "${MODEL}" = "DVA1622" ]||[ "${MODEL}" = "DS920+" ]||[ "${MODEL}" = "DS1520+" ]||[ "${MODEL}" = "DS720+" ]; then
        ORIGIN_PLATFORM="geminilake"
    elif [ "${MODEL}" = "DS923+" ]||[ "${MODEL}" = "DS723+" ]; then
        ORIGIN_PLATFORM="r1000"
    elif [ "${MODEL}" = "DS1621+" ]||[ "${MODEL}" = "DS2422+" ]||[ "${MODEL}" = "FS2500" ]||[ "${MODEL}" = "RS1221+" ]; then
        ORIGIN_PLATFORM="v1000"
    elif [ "${MODEL}" = "SA6400" ]; then
        ORIGIN_PLATFORM="epyc7002"        
    fi
    
    if [ "${MODEL}" = "SA6400" ]; then    
        KVER="5.10.55"
    elif [ "${MODEL}" = "DS3615xs" ]||[ "${MODEL}" = "DS916+" ]; then
        KVER="3.10.108"        
    fi    
        
}

# Function READ_YN, cecho                                                                                        
# Made by FOXBI
# 2022.04.14                                                                                                                  
#                                                                                                                             
# ==============================================================================                                              
# Y or N Function                                                                                                             
# ==============================================================================                                              
function READ_YN () { # ${1}:question ${2}:default                                                                                         
    while true; do
        read -n1 -p "${1}" Y_N                                                                                                       
        case "$Y_N" in                                                                                                            
            [Yy]* ) Y_N="y"                                                                                                                
                 echo -e "\n"; break ;;                                                                                                      
            [Nn]* ) Y_N="n"                                                                                                                
                 echo -e "\n"; break ;;                                                                                                      
            *) echo -e "Please answer in Y / y or N / n.\n" ;;                                                                                                        
        esac                                                                                                                      
    done        
}                                                                                         

function getlatestmshell() {

    echo -n "Checking if a newer mshell version exists on the repo -> "

    if [ ! -f $mshellgz ]; then
        curl -ksL "$mshtarfile" -o $mshellgz
    fi

    curl -ksL "$mshtarfile" -o latest.mshell.gz

    CURRENTSHA="$(sha256sum $mshellgz | awk '{print $1}')"
    REPOSHA="$(sha256sum latest.mshell.gz | awk '{print $1}')"

    if [ "${CURRENTSHA}" != "${REPOSHA}" ]; then
    
        if [ "${1}" = "noask" ]; then
            confirmation="y"
        else
            echo -n "There is a newer version of m shell script on the repo should we use that ? [yY/nN]"
            read confirmation
        fi
    
        if [ "$confirmation" = "y" ] || [ "$confirmation" = "Y" ]; then
            echo "OK, updating, please re-run after updating"
            cp -f /home/tc/latest.mshell.gz /home/tc/$mshellgz
            rm -f /home/tc/latest.mshell.gz
            tar -zxvf $mshellgz
            echo "Updating m shell with latest updates"
            source myfunc.h
            showlastupdate
            echo "y"|./rploader.sh backup
            echo "press any key to continue..."                                                                                                   
            read answer            
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

macgen() {
echo

    if [ "$realmac" == 'Y' ] ; then
        mac2=$(ifconfig eth1 | head -1 | awk '{print $NF}')
        echo "Real Mac2 Address : $mac2"
        echo "Notice : realmac option is requested, real mac2 will be used"
    else
        mac2="$(generateMacAddress ${1})"
    fi

    cecho y "Mac2 Address for Model ${1} : $mac2 "

    macaddress2=$(echo $mac2 | sed -s 's/://g')

    if [ $(cat user_config.json | grep "mac2" | wc -l) -gt 0 ]; then
        bf_mac2="$(cat user_config.json | grep "mac2" | cut -d ':' -f 2 | cut -d '"' -f 2)"
        cecho y "The Mac2 address : $bf_mac2 already exists. Change an existing value."
        json="$(jq --arg var "$macaddress2" '.extra_cmdline.mac2 = $var' user_config.json)" && echo -E "${json}" | jq . >user_config.json
#        sed -i "/mac2/s/'$bf_mac2'/'$macaddress2'/g" user_config.json
    else
        sed -i "/\"extra_cmdline\": {/c\  \"extra_cmdline\": {\"mac2\": \"$macaddress2\",\"netif_num\": \"2\", "  user_config.json
    fi

    echo "After changing user_config.json"      
    cat user_config.json

}

function generateMacAddress() {
    printf '00:11:32:%02X:%02X:%02X' $((RANDOM % 256)) $((RANDOM % 256)) $((RANDOM % 256))

}
