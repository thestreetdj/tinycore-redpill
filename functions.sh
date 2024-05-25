#!/usr/bin/env bash

set -u

gitdomain="raw.githubusercontent.com"

mshellgz="my.sh.gz"
mshtarfile="https://raw.githubusercontent.com/PeterSuh-Q3/tinycore-redpill/master/my.sh.gz"

USER_CONFIG_FILE="/home/tc/user_config.json"

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
# 2023.06.17
# Update : Added ds1821+ (v1000)
# 2023.06.18
# Update : Added ds1823xs+ (v1000), ds620slim (apollokale), ds1819+ (denverton)
# 2023.06.20
# Update : Add Support DSM 7.2-64570-1 Official Version
# 2023.07.07
# Update : Fix Bug for userdts option
# 2023.08.24 (M-SHELL for TCRP, v0.9.5.0 release)
# Update : Add storage panel size selection menu
# 2023.08.29
# Update : Added a function to store loader.img for DSM 7.2 for 7.2 automatic loader build of 7.0.1, 7.1.1
# 2023.09.26
# Update : Add Support DSM 7.2.1-69057 Official Version
# 2023.09.30
# Update : Fixed locale selection issue, modified some menu guidance text
# 2023.10.01
# Update : Add "Show SATA(s) # ports and drives" menu
# 2023.10.07
# Update : Add "Burn Anither TCRP Bootloader to USB or SSD" menu
# 2023.10.09
# Update : Add "Clone TCRP Bootloader to USB or SSD" menu
# 2023.10.17
# Update : Add "Show error log of running loader" menu
# 2023.10.18 v0.9.6.0
# Update : Improved extension processing speed (local copy instead of remote curl download)
# 2023.10.22 v0.9.7.0
# Update : Improved build processing speed (removed pat file download process)
# 2023.10.24 v0.9.7.1
# Update : Back to DSM Pat Handle Method
# 2023.10.27 v1.0.0.0
# Update : Kernel patch process improvements    
# 2023.11.04 
# Update : Added DS1522+ (r1000), DS220+ (geminilake), DS2419+ (denverton), DS423+ (geminilake), DS718+ (apollolake), RS2423+ (v1000)
# 2023.11.28
# Update : Turn off thread limits when displaying models (Thanks alirz1)
# 2023.12.01
# Update : Separate tcrp-addons and tcrp-modules repo processing methods
# 2023.12.02
# Update : Add offline loader build function
# 2023.12.18 v1.0.1.0
# Update : Upgrade from Tinycore version 12.0 (kernel 5.10.3) to 14.0 (kernel 6.1.2) to improve compatibility with the latest devices.
# 2023.12.31        
# Added SataPortMap/DiskIdxMap prevent initialization menu for virtual machines  
# 2024.02.03
# Created a menu to select the mac-spoof add-on and a submenu for additional features.
# 2024.02.06
# update corepure64.gz for tc user ttyS0 serial console works
# 2024.02.08
# Add Apollolake DS218+
# 2024.02.22 v1.0.2.0
# Remove restrictions on use of DT-based models when using HBA (apply mpt3sas blacklist instead)
# 2024.03.06 v1.0.2.2
# Recycle initrd-dsm instead of custom.gz (extract /exts)
# 2024.03.13 v1.0.2.3 
# Added RedPill bootloader hard disk porting function
# 2024.03.15
# Added RedPill bootloader hard disk porting function supporting 1 SHR Type DISK
# 2024.03.18
# Added RedPill bootloader hard disk porting function supporting All SHR & RAID Type DISK
# 2024.03.22 v1.0.2.4 
# Added NVMe bootloader support
# 2024.03.23
# Fixed bug where both modules disappear when switching between ddsml and eudev (Causes NIC unresponsiveness)
# 2024.03.24    
# Added missing mmc partition search function
# 2024.04.01 v1.0.2.5
# Provides menu option to disable i915 module loading to prevent console blackout in ApolloLake (DS918+), GeminiLake (DS920+), and Epyc7002 (SA6400)
# 2024.04.09 v1.0.2.6
# Added multilingual support languages (locales) (Arabic, Hindi, Hungarian, Indonesian, Turkish)
# 2024.04.09 v1.0.2.7
# dbgutils Addon Add/Delete selection menu
# 2024.04.14
# sortnetif Addon Add/Delete selection menu
# 2024.05.08 v1.0.2.8
# Added multilingual support languages (locales) (Amharic-Ethiopian, Thai)
# 2024.05.13
# Menu configuration for adding nvmesystem addon
    
function showlastupdate() {
    cat <<EOF

# 2023.12.02
# Update : Add offline loader build function

# 2023.12.18 v1.0.1.0
# Update : Upgrade from Tinycore version 12.0 (kernel 5.10.3) to 14.0 (kernel 6.1.2) to improve compatibility with the latest devices.

# 2024.03.15
# Added RedPill bootloader hard disk porting function supporting 1 SHR Type DISK

# 2024.03.18
# Added RedPill bootloader hard disk porting function supporting All SHR & RAID Type DISK        

# 2024.03.22 v1.0.2.4 
# Added NVMe bootloader support

# 2024.04.01 v1.0.2.5
# Provides menu option to disable i915 module loading to prevent console blackout in ApolloLake (DS918+), GeminiLake (DS920+), and Epyc7002 (SA6400)

# 2024.04.09 v1.0.2.6
# Added multilingual support languages (locales) (Arabic, Hindi, Hungarian, Indonesian, Turkish)
    
# 2024.04.09 v1.0.2.7
# dbgutils Addon Add/Delete selection menu

# 2024.04.14
# sortnetif Addon Add/Delete selection menu

# 2024.05.08 v1.0.2.8
# Added multilingual support languages (locales) (Amharic-Ethiopian, Thai)

# 2024.05.13
# Menu configuration for adding nvmesystem addon
    
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

./$(basename ${0}) DS918+-7.2.1-69057
./$(basename ${0}) DS3617xs-7.2.1-69057
./$(basename ${0}) DS3615xs-7.2.1-69057
./$(basename ${0}) DS3622xs+-7.2.1-69057
./$(basename ${0}) DVA3221-7.2.1-69057
./$(basename ${0}) DS920+-7.2.1-69057
./$(basename ${0}) DS1621+-7.2.1-69057
./$(basename ${0}) DS2422+-7.2.1-69057
./$(basename ${0}) DVA1622-7.2.1-69057
./$(basename ${0}) DS1520+-7.2.1-69057
./$(basename ${0}) FS2500-7.2.1-69057
./$(basename ${0}) DS1621xs+-7.2.1-69057
./$(basename ${0}) RS4021xs+-7.2.1-69057 
./$(basename ${0}) DVA3219-7.2.1-69057
./$(basename ${0}) RS3618xs-7.2.1-69057
./$(basename ${0}) DS1019+-7.2.1-69057
./$(basename ${0}) DS923+-7.2.1-69057
./$(basename ${0}) DS723+-7.2.1-69057
./$(basename ${0}) SA6400-7.2.1-69057
./$(basename ${0}) DS720+-7.2.1-69057
./$(basename ${0}) RS1221+-7.2.1-69057
./$(basename ${0}) RS2423+-7.2.1-69057
./$(basename ${0}) RS1619xs+-7.2.1-69057
./$(basename ${0}) RS3621xs+-7.2.1-69057
./$(basename ${0}) SA6400-7.2.1-69057
./$(basename ${0}) DS916+-7.2.1-69057
./$(basename ${0}) DS1821+-7.2.1-69057
./$(basename ${0}) DS1819+-7.2.1-69057
./$(basename ${0}) DS1823xs+-7.2.1-69057
./$(basename ${0}) DS620slim+-7.2.1-69057

ex) Except for postupdate and userdts that must be used alone, the rest of the options can be used in combination. 

- When you want to build the loader while maintaining the already set SN/Mac/Vid/Pid/SataPortMap
./my DS3622xs+H noconfig

- When you want to build the loader while maintaining the already set SN/Mac/Vid/Pid/SataPortMap and without deleting the downloaded DSM pat file.
./my DS3622xs+H noconfig noclean

- When you want to build the loader while using the real MAC address of the NIC, with extended auto-detection disabled
./my DS3622xs+H realmac manual

EOF

}

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

function getvarsmshell()
{
    
    SUVP=""
    ORIGIN_PLATFORM=""

    tem="${1}"

    MODEL="$(echo ${tem} |cut -d '-' -f 1)"
    TARGET_REVISION="$(echo ${tem} |cut -d '-' -f 3)"    
    if [ "$TARGET_REVISION" == "64570" ]; then
      TARGET_VERSION="$(echo ${tem} |cut -d '-' -f 2 | cut -c 1-3)"
    else
      TARGET_VERSION="$(echo ${tem} |cut -d '-' -f 2)"
    fi

    #echo "MODEL is $MODEL"
    TARGET_PLATFORM=$(echo "$MODEL" | sed 's/DS/ds/' | sed 's/RS/rs/' | sed 's/+/p/' | sed 's/DVA/dva/' | sed 's/FS/fs/' | sed 's/SA/sa/' )
    SYNOMODEL="${TARGET_PLATFORM}_${TARGET_REVISION}"
    
    MODELS="DS3615xs DS218+ DS1019+ DS620slim DS1520+ DS1522+ DS220+ DS2419+ DS423+ DS718+ DS1621+ DS1821+ DS1823xs+ DS1621xs+ DS2422+ DS3617xs DS3622xs+ DS720+ DS723+ DS918+ DS920+ DS923+ DS1819+ DVA3219 DVA3221 DVA1622 FS2500 RS1221+ RS1619xs+ RS2423+ RS3413xs+ RS3618xs RS3621xs+ RS4021xs+ SA3410 SA3610 SA6400"
    if [ $(echo ${MODELS} | grep ${MODEL} | wc -l ) -eq 0 ]; then
        echo "This synology model not supported by TCRP."
        exit 0
    fi
    
    if [ "$TARGET_REVISION" == "42218" ]; then
        KVER="4.4.180"
        SUVP="" 
    elif [ "$TARGET_REVISION" == "42962" ]; then
        KVER="4.4.180"
        MODELS6="DS423+ DS723+ DS923+ DS1823xs+ RS3621xs+ RS4021xs+ RS3618xs SA6400"
        if [ $(echo ${MODELS6} | grep ${MODEL} | wc -l ) -gt 0 ]; then
           SUVP="-6"
        else
           SUVP="-1"
        fi
    elif [ "$TARGET_REVISION" == "64570" ]; then
        KVER="4.4.302"
        SUVP="-1" 
    elif [ "$TARGET_REVISION" == "69057" ]; then
        KVER="4.4.302"
        SUVP=""
        if [ "${MODEL}" = "DS218+" ]; then
          SUVP="-1"
        fi
    else
        echo "Synology model revision not supported by TCRP."
        exit 0
    fi

    case ${MODEL} in
    DS218+ | DS718+ | DS918+ | DS1019+ | DS620slim )
        ORIGIN_PLATFORM="apollolake"
        ;;
    DS3615xs | RS3413xs+ )
        ORIGIN_PLATFORM="bromolow"
        KVER="3.10.108"
        ;;
    DS3617xs | RS3618xs )
        ORIGIN_PLATFORM="broadwell"
        ;;
    DS3622xs+ | DS1621xs+ | SA3400 | SA3600 | RS1619xs+ | RS3621xs+ | RS4021xs+ )
        ORIGIN_PLATFORM="broadwellnk"
        ;;
    SA3410 | SA3610 )
        ORIGIN_PLATFORM="broadwellnkv2"
        ;;
    DVA3221 | DVA3219 | DS1819+ | DS2419+ )
        ORIGIN_PLATFORM="denverton"
        ;;
    DVA1622 | DS220+ | DS423+ | DS920+ | DS1520+ | DS720+ )
        ORIGIN_PLATFORM="geminilake"
        ;;
    DS923+ | DS723+ | DS1522+ )
        ORIGIN_PLATFORM="r1000"
        ;;
    DS1621+ | DS1821+ | DS1823xs+ | DS2422+ | FS2500 | RS1221+ | RS2423+ )
        ORIGIN_PLATFORM="v1000"
        ;;
    SA6400 )
        ORIGIN_PLATFORM="epyc7002"
        KVER="5.10.55"
        ;;
    esac

    case ${MODEL} in
    DS1019+)
        permanent="PDN"
        serialstart="1780 1790 1860 1980"
        suffix="numeric"
        ;;
    DS1520+)
        permanent="TRR"
        serialstart="2270"
        suffix="alpha"
        ;;    
    DS1522+)
        permanent="TRR"
        serialstart="2270"
        suffix="alpha"
        ;;
    DS1621+)
        permanent="S7R"
        serialstart="2080"
        suffix="alpha"
        ;;
    DS1621xs+)
        permanent="S7R"
        serialstart="2080"
        suffix="alpha"
        ;;
    DS1819+)
        permanent="RFR"
        serialstart="1930 1940"
        suffix="alpha"
        ;;
    DS1821+)
        permanent="S7R"
        serialstart="2080"
        suffix="alpha"
        ;;
    DS1823xs+)
        permanent="V5R"
        serialstart="22B0"
        suffix="alpha"
        ;;
    DS220+)
        permanent="XXX"
        serialstart="0000"
        suffix="alpha"
        ;;
    DS2419+)
        permanent="QZA"
        serialstart="1880"
        suffix="alpha"
        ;;
    DS2422+)
        permanent="S7R"
        serialstart="2080"
        suffix="alpha"
        ;;
    DS3615xs)
        permanent="LWN"
        serialstart="1130 1230 1330 1430"
        suffix="numeric"
        ;;
    DS3617xs)
        permanent="ODN"
        serialstart="1130 1230 1330 1430"
        suffix="numeric"
        ;;
    DS3622xs+)
        permanent="SQR"
        serialstart="2030 2040 20C0 2150"
        suffix="alpha"
        ;;
    DS423+)
        permanent="VKR"
        serialstart="22A0"
        suffix="alpha"
        ;;
    DS218+)
        permanent="PDN"
        serialstart="1780 1790 1860 1980"
        suffix="numeric"
        ;;
    DS620slim)
        permanent="PDN"
        serialstart="1780 1790 1860 1980"
        suffix="numeric"
        ;;
    DS718+)
        permanent="PEN"
        serialstart="1930"
        suffix="numeric"
        ;;
    DS720+)
        permanent="SBR"
        serialstart="2030 2040 20C0 2150"
        suffix="alpha"
        ;;
    DS723+)
        permanent="TQR"
        serialstart="2270"
        suffix="alpha"
        ;;
    DS916+)
        permanent="NZN"
        serialstart="1130 1230 1330 1430"
        suffix="numeric"
        ;;
    DS918+)
        permanent="PDN"
        serialstart="1780 1790 1860 1980"
        suffix="numeric"
        ;;
    DS920+)
        permanent="SBR"
        serialstart="2030 2040 20C0 2150"
        suffix="alpha"
        ;;
    DS923+)
        permanent="TQR"
        serialstart="2270"
        suffix="alpha"
        ;;
    DVA1622)
        permanent="UBR"
        serialstart="2030 2040 20C0 2150"
        suffix="alpha"
        ;;
    DVA3219)
        permanent="RFR"
        serialstart="1930 1940"
        suffix="alpha"
        ;;
    DVA3221)
        permanent="SJR"
        serialstart="2030 2040 20C0 2150"
        suffix="alpha"
        ;;
    FS2500)
        permanent="PSN"
        serialstart="1960"
        suffix="numeric"
        ;;
    FS6400)
        permanent="PSN"
        serialstart="1960"
        suffix="numeric"
        ;;
    RS1221+)
        permanent="RWR"
        serialstart="20B0"
        suffix="alpha"
        ;;
    RS2423+)
        permanent="XXX"
        serialstart="0000"
        suffix="alpha"
        ;;
    RS1619xs+)
        permanent="QPR"
        serialstart="1920"
        suffix="alpha"
        ;;
    RS3413xs+)
        permanent="S7R"
        serialstart="2080"
        suffix="alpha"
        ;;
    RS3618xs)
        permanent="ODN"
        serialstart="1130 1230 1330 1430"
        suffix="numeric"
        ;;
    RS3621xs+)
        permanent="SZR"
        serialstart="20A0"
        suffix="alpha"
        ;;
    RS4021xs+)
        permanent="T2R"
        serialstart="2250"
        suffix="alpha"
        ;;
    SA3400)
        permanent="RJR"
        serialstart="1920"
        suffix="alpha"
        ;;
    SA3600)
        permanent="RJR"
        serialstart="1920"
        suffix="alpha"
        ;;
    SA6400)
        permanent="TQR"
        serialstart="2270"
        suffix="alpha"
        ;;
    *)
        permanent="XXX"
        serialstart="0000"
        suffix="alpha"
        ;;        
    esac        
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

function st() {
echo -e "[$(date '+%T.%3N')]:-------------------------------------------------------------" >> /home/tc/buildstatus
echo -e "\e[35m$1\e[0m	\e[36m$2\e[0m	$3" >> /home/tc/buildstatus
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

function macgen() {
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

function msgalert() {
    echo -e "\033[1;31m$1\033[0m"
}
function msgwarning() {
    echo -e "\033[1;33m$1\033[0m"
}
function msgnormal() {
    echo -e "\033[1;32m$1\033[0m"
} 
function st() {
echo -e "[$(date '+%T.%3N')]:-------------------------------------------------------------" >> /home/tc/buildstatus
echo -e "\e[35m$1\e[0m	\e[36m$2\e[0m	$3" >> /home/tc/buildstatus
}

function readanswer() {
    while true; do
        read answ
        case $answ in
            [Yy]* ) answer="$answ"; break;;
            [Nn]* ) answer="$answ"; break;;
            * ) msgwarning "Please answer yY/nN.";;
        esac
    done
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
    
function checkmachine() {

    if grep -q ^flags.*\ hypervisor\  /proc/cpuinfo; then
        MACHINE="VIRTUAL"
        HYPERVISOR=$(dmesg | grep -i "Hypervisor detected" | awk '{print $5}')
        echo "Machine is $MACHINE Hypervisor=$HYPERVISOR"
    else
        MACHINE="NON-VIRTUAL"
    fi

    if [ $(lspci -nn | grep -ie "\[0107\]" | wc -l) -gt 0 ]; then
        echo "Found SAS HBAs, Restrict use of DT Models."
        HBADETECT="ON"
    else
        HBADETECT="OFF"    
    fi   
    
}

function checkinternet() {

    echo -n "Checking Internet Access -> "
#    nslookup $gitdomain 2>&1 >/dev/null
    curl --insecure -L -s https://raw.githubusercontent.com/about.html -O 2>&1 >/dev/null

    if [ $? -eq 0 ]; then
        echo "OK"
    else
        cecho g "Error: No internet found, or $gitdomain is not accessible"
        
        gitdomain="giteas.duckdns.org"
        cecho p "Try to connect to $gitdomain......"
        nslookup $gitdomain 2>&1 >/dev/null
        if [ $? -eq 0 ]; then
            echo "OK"
        else
            cecho g "Error: No internet found, or $gitdomain is not accessible"
            exit 99
        fi
    fi

}

###############################################################################
# check for Sas module
function checkforsas() {

    sasmods="mpt3sas hpsa mvsas"
    for sasmodule in $sasmods
    do
        echo "Checking existense of $sasmodule"
        for sas in `depmod -n 2>/dev/null |grep -i $sasmodule |grep pci|cut -d":" -f 2 | cut -c 6-9,15-18`
	do
	    if [ `grep -i $sas /proc/bus/pci/devices |wc -l` -gt 0 ] ; then
	        echo "  => $sasmodule, device found, block eudev mode" 
	        BLOCK_EUDEV="Y"
	    fi
	done
    done 
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
# Get fastest url in list
# @ - url list
function _get_fastest() {
  local speedlist=""
  for I in $@; do
    speed=$(ping -c 1 -W 5 ${I} 2>/dev/null | awk '/time=/ {print $7}' | cut -d '=' -f 2)
    speedlist+="${I} ${speed:-999}\n"
  done
  fastest="$(echo -e "${speedlist}" | tr -s '\n' | sort -k2n | head -1 | awk '{print $1}')"
  echo "${fastest}"
}

function chkavail() {

    if [ $(df -h /mnt/${tcrppart} | grep mnt | awk '{print $4}' | grep G | wc -l) -gt 0 ]; then
        avail_str=$(df -h /mnt/${tcrppart} | grep mnt | awk '{print $4}' | sed -e 's/G//g' | cut -c 1-3)
        avail=$(echo "$avail_str 1000" | awk '{print $1 * $2}')
    else
        avail=$(df -h /mnt/${tcrppart} | grep mnt | awk '{print $4}' | sed -e 's/M//g' | cut -c 1-3)
    fi

    avail_num=$(($avail))
    
    echo "Avail space ${avail_num}M on /mnt/${tcrppart}"
}    

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

function add-addon() {
    jsonfile=$(jq ". |= .+ {\"${1}\": \"https://raw.githubusercontent.com/PeterSuh-Q3/tcrp-addons/master/${1}/rpext-index.json\"}" ~/redpill-load/bundled-exts.json) && echo $jsonfile | jq . > ~/redpill-load/bundled-exts.json	
}

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
  
  [ "$spoof" = true ] && add-addon "mac-spoof" 
  [ "$nvmes" = true ] && add-addon "nvmesystem" 
  [ "$dbgutils" = true ] && add-addon "dbgutils" 
  [ "$sortnetif" = true ] && add-addon "sortnetif" 
  
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
}

