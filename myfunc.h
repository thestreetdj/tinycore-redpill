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
    
function showlastupdate() {
    cat <<EOF

# 2023.06.18
# Update : Added ds1823xs+ (v1000), ds620slim (apollokale), ds1819+ (denverton)

# 2023.08.24 (M-SHELL for TCRP, v0.9.5.0 release)
# Update : Add storage panel size selection menu

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
    
# 2023.10.27 v1.0.0.0 
# Update : Kernel patch process improvements

# 2023.11.04 
# Update : Added DS1522+ (r1000), DS220+ (geminilake), DS2419+ (denverton), DS423+ (geminilake), DS718+ (apollolake), RS2423+ (v1000)
    
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

function getvarsmshell()
{
    
    SUVP=""
    ORIGIN_PLATFORM=""
    TARGET_REVISION=""

    tem="${1}"

#7.0.1-42218
    MODELS="DS3615xsJ DS1019+J DS620slimJ DS1520+J DS1522+J DS220+J DS2419+J DS423+J DS718+J DS1621+J DS1821+J DS1621xs+J DS2422+J DS3617xsJ DS3622xs+J DS720+J DS723+J DS918+J DS920+J DS923+J DS1819+J DVA3219J DVA3221J FS2500J RS1221+J RS1619xs+J RS2423+J RS3413xs+J RS3618xsJ RS3621xs+J RS4021xs+J SA3410J SA3610J SA6400J"
    if [ $(echo ${MODELS} | grep ${tem} | wc -l ) -gt 0 ]; then
       TARGET_REVISION="42218"
    fi
    
#7.1.1-42962
    MODELS="DS3615xsF DS1019+F DS1522+F DS220+F DS2419+F DS718+F DS1520+F DS1621+F DS1821+F DS1621xs+F DS2422+F DS3617xsF DS3622xs+F DS720+F DS918+F DS620slimF DS920+F DVA1622F DS1819+F DVA3219F DVA3221F FS2500F RS1221+F RS1619xs+F RS2423+F RS3413xs+F SA3410F SA3610F"
    if [ $(echo ${MODELS} | grep ${tem} | wc -l ) -gt 0 ]; then
       TARGET_REVISION="42962"
       SUVP="-1"
    fi
    MODELS="DS423+F DS723+F DS923+F DS1823xs+F RS3621xs+F RS4021xs+F RS3618xsF SA6400F"
    if [ $(echo ${MODELS} | grep ${tem} | wc -l ) -gt 0 ]; then
       TARGET_REVISION="42962"
       SUVP="-6"
    fi
        
#7.2.0-64570 Official
    MODELS="DS1019+G DS620slimG DS1520+G DS1522+G DS220+G DS2419+G DS423+G DS718+G DS1621+G DS1821+G DS1823xs+G DS1621xs+G DS2422+G DS3617xsG DS3622xs+G DS720+G DS723+G DS918+G DS920+G DS923+G DVA1622G DS1819+G DVA3219G DVA3221G FS2500G RS1221+G RS1619xs+G RS2423+G RS3413xs+G RS3618xsG RS3621xs+G RS4021xs+G SA3410G SA3610G SA6400G"
    if [ $(echo ${MODELS} | grep ${tem} | wc -l ) -gt 0 ]; then
       TARGET_REVISION="64570"
       SUVP="-1" 
    fi

#7.2.1-69057 Official
    MODELS="DS1019+H DS620slimH DS1520+H DS1522+H DS220+H DS2419+H DS423+H DS718+H DS1621+H DS1821+H DS1823xs+H DS1621xs+H DS2422+H DS3617xsH DS3622xs+H DS720+H DS723+H DS918+H DS920+H DS923+H DVA1622H DS1819+H DVA3219H DVA3221H FS2500H RS1221+H RS1619xs+H RS2423+H RS3413xs+H RS3618xsH RS3621xs+H RS4021xs+H SA3410H SA3610H SA6400H"
    if [ $(echo ${MODELS} | grep ${tem} | wc -l ) -gt 0 ]; then
       TARGET_REVISION="69057"
    fi
        
    if [ "$TARGET_REVISION" == "42218" ]; then
        MODEL="$(echo $tem | sed 's/J//g')"
        TARGET_VERSION="7.0.1"
        KVER="4.4.180"
    elif [ "$TARGET_REVISION" == "42962" ]; then
        if [ $tem = "FS2500F" ]; then
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
    elif [ "$TARGET_REVISION" == "64570" ]; then
        MODEL="$(echo $tem | sed 's/G//g')"
        TARGET_VERSION="7.2"
        KVER="4.4.302"
    elif [ "$TARGET_REVISION" == "69057" ]; then
        MODEL="$(echo $tem | sed 's/H//g')"
        TARGET_VERSION="7.2.1"
        KVER="4.4.302"
    else
        echo "Synology model revision not supported by TCRP."
        exit 0                                                                                               
    fi

    #echo "MODEL is $MODEL"
    TARGET_PLATFORM=$(echo "$MODEL" | sed 's/DS/ds/' | sed 's/RS/rs/' | sed 's/+/p/' | sed 's/DVA/dva/' | sed 's/FS/fs/' | sed 's/SA/sa/' )
    SYNOMODEL="${TARGET_PLATFORM}_${TARGET_REVISION}"

    case ${MODEL} in
    DS718+ | DS918+ | DS1019+ | DS620slim )
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
