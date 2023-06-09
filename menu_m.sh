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
# Update : Add Support DSM 7.2-64570 Official Version
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
    if [ "${1}" = "DS918+" ] || [ "${1}" = "DS918+F" ]; then        
        TARGET_PLATFORM="ds918p"
        ORIGIN_PLATFORM="apollolake"
        SYNOMODEL="ds918p_$TARGET_REVISION"                                                                                                                    
        sha256="9905e145f3bd88fcc938b00882be10281861867e5165ae98aefa37be0d5d34b5"
        SUVP="-1"
    elif [ "${1}" = "DS3615xs" ] || [ "${1}" = "DS3615xsF" ]; then                                                                                                                     
        TARGET_PLATFORM="ds3615xs"
        ORIGIN_PLATFORM="bromolow"
        SYNOMODEL="ds3615xs_$TARGET_REVISION"                                                                                                                  
        sha256="f01a17d73e2594b0b31f134bfe023dccc0bb9389a462f9918080573134093023"
        SUVP="-1"
    elif [ "${1}" = "DS3617xs" ] || [ "${1}" = "DS3617xsF" ]; then                                                                                                                     
        TARGET_PLATFORM="ds3617xs"
        ORIGIN_PLATFORM="broadwell"
        SYNOMODEL="ds3617xs_$TARGET_REVISION"                                                                                                                  
        sha256="1b72bb24dc9d10d3784298e6df9d79a8f8c3555087e0de12f3359ce373f4e7c9"
        SUVP="-1"
    elif [ "${1}" = "DS3622xs+" ] || [ "${1}" = "DS3622xs+F" ]; then
        TARGET_PLATFORM="ds3622xsp"
        ORIGIN_PLATFORM="broadwellnk"
        SYNOMODEL="ds3622xsp_$TARGET_REVISION"
        sha256="775933e32a9e04700fc10a155f5a26c0878c3cdec18b6ec6b1d5a4110e83d428"
        SUVP="-1"
    elif [ "${1}" = "DS1621+" ] || [ "${1}" = "DS1621+F" ]; then
        TARGET_PLATFORM="ds1621p"
        ORIGIN_PLATFORM="v1000"
        SYNOMODEL="ds1621p_$TARGET_REVISION"                                                                                                                   
        sha256="41a4b80ef58f3ff5ee924329ff59bd4ac0abb7676561847a84e98bc6bb225003"
        SUVP="-1"
    elif [ "${1}" = "DVA3221" ] || [ "${1}" = "DVA3221F" ]; then                                                                                                                      
        TARGET_PLATFORM="dva3221"
        ORIGIN_PLATFORM="denverton"
        SYNOMODEL="dva3221_$TARGET_REVISION"                                                                                                                   
        sha256="7bd2fe270bc665cc859142b7c6462fe8137f047c4fbe2f87ed3d03c30c514766"
        SUVP="-1"        
    elif [ "${1}" = "DVA1622" ] || [ "${1}" = "DVA1622F" ]; then
        TARGET_PLATFORM="dva1622"
        ORIGIN_PLATFORM="geminilake"
        SYNOMODEL="dva1622_$TARGET_REVISION"                                                                                                                   
        sha256="ebebc3f1de22b789b386f1d52fbe0be3fcca23f83e0d34ed9c24e794701b4c3d"
        SUVP="-1"        
    elif [ "${1}" = "DS920+" ] || [ "${1}" = "DS920+F" ]; then
        TARGET_PLATFORM="ds920p"
        ORIGIN_PLATFORM="geminilake"
        SYNOMODEL="ds920p_$TARGET_REVISION"                                                                                                                    
        sha256="f58c15d4d83699884c30e4a4b04b1d2e0db19c477923d920327a897a73c741b6"
        SUVP="-1"
    elif [ "${1}" = "DS923+" ] || [ "${1}" = "DS923+F" ]; then
        TARGET_PLATFORM="ds923p"
        ORIGIN_PLATFORM="r1000"
        SYNOMODEL="ds923p_$TARGET_REVISION"                                                                                                                    
        sha256="8fe1232e26661dd9e6db2a8e132bd8869b23b2887d77d298cd8e0b7cb2f9e2d6"
        SUVP="-5"
    elif [ "${1}" = "DS723+" ] || [ "${1}" = "DS723+F" ]; then
        TARGET_PLATFORM="ds723p"
        ORIGIN_PLATFORM="r1000"
        SYNOMODEL="ds723p_$TARGET_REVISION"                                                                                                                    
        sha256="633a626f3dc31338eb41ca929d8f9927a7a63f646067372d02ac045aa768560f"
        SUVP="-5"

# JOT / FRIEND MODE NEW MODEL SUCCESS
    elif [ "${1}" = "DS2422+" ] || [ "${1}" = "DS2422+F" ] ; then
        TARGET_PLATFORM="ds2422p"
        ORIGIN_PLATFORM="v1000"
        SYNOMODEL="ds2422p_$TARGET_REVISION"                                                                                                                   
        sha256="69f02c4636ff2593e5feb393e13ed82791fa6457d61874368a0b6f93ee11f164"
        SUVP="-1"
    elif [ "${1}" = "DS1621xs+" ] || [ "${1}" = "DS1621xs+F" ]; then
        TARGET_PLATFORM="ds1621xsp"
        ORIGIN_PLATFORM="broadwellnk"        
        SYNOMODEL="ds1621xsp_$TARGET_REVISION"
        sha256="d2272ab531f0f68f8008106dd75b4e303c71db8d95093d186a22c1cf2d970402"
        SUVP="-1"
    elif [ "${1}" = "RS4021xs+" ] || [ "${1}" = "RS4021xs+F" ]; then
        TARGET_PLATFORM="rs4021xsp"
        ORIGIN_PLATFORM="broadwellnk"        
        SYNOMODEL="rs4021xsp_$TARGET_REVISION"
        sha256="e2ddf670e54fe6b2b52b19125430dc82394df2722afd4f62128b95a63459ee3d"
        SUVP="-5"
    elif [ "${1}" = "SA3600" ] || [ "${1}" = "SA3600F" ]; then
        TARGET_PLATFORM="sa3600"
        ORIGIN_PLATFORM="broadwellnk"        
        SYNOMODEL="sa3600_$TARGET_REVISION"
        sha256="d4d6fcd5bb3b3c005f2fb199af90cb7f62162d9112127d06ebf5973aa645e0f8"
    elif [ "${1}" = "SA6400" ] || [ "${1}" = "SA6400F" ]; then
        TARGET_PLATFORM="sa6400"
        ORIGIN_PLATFORM="epyc7002"        
        SYNOMODEL="sa6400_$TARGET_REVISION"
        sha256="83fc408380ebb1381224261de6220b873d7b62a99e715557509ae9553f618a71"
    elif [ "${1}" = "DVA3219" ] || [ "${1}" = "DVA3219F" ]; then
        TARGET_PLATFORM="dva3219"
        ORIGIN_PLATFORM="denverton"        
        SYNOMODEL="dva3219_$TARGET_REVISION"                                                                                                                   
        sha256="9f8c6095235df2e2caebadf846f11e4244af6f1aada9a7dd5c2c60543f944aac"
        SUVP="-1"
    elif [ "${1}" = "FS2500" ] || [ "${1}" = "FS2500F" ]; then
        TARGET_PLATFORM="fs2500"
        ORIGIN_PLATFORM="v1000"        
        SYNOMODEL="fs2500_$TARGET_REVISION"                                                                                                                    
        sha256="e74ff783b5ca6fbdec1a0eb950b366b74b27c0288fb72baaf86db8a31d68b985"
        SUVP="-1"
    elif [ "${1}" = "RS3618xs" ] || [ "${1}" = "RS3618xsF" ]; then                                                                                                                     
        TARGET_PLATFORM="rs3618xs"
        ORIGIN_PLATFORM="broadwell"
        SYNOMODEL="rs3618xs_$TARGET_REVISION"                                                                                                                  
        sha256="2851af89ca0ec287ff47ab265412b67c4fba5848cedb51486a8f6ed2baca3062"
        SUVP="-1"
    elif [ "${1}" = "DS1019+" ] || [ "${1}" = "DS1019+F" ]; then        
        TARGET_PLATFORM="ds1019p"
        ORIGIN_PLATFORM="apollolake"
        SYNOMODEL="ds1019p_$TARGET_REVISION"                                                                                                                    
        sha256="af2268388df9434679205ffd782ae5c17cd81d733cdcd94b13fc894748ffe321"
        SUVP="-1"
    elif [ "${1}" = "DS1520+" ] || [ "${1}" = "DS1520+F" ]; then
        TARGET_PLATFORM="ds1520p"
        ORIGIN_PLATFORM="geminilake"        
        SYNOMODEL="ds1520p_$TARGET_REVISION"                                                                                                                    
        sha256="edcacbab10b77e2a6862d31173f5369c6e3c1720b8f0ec4fd41786609017c39b"
        SUVP="-1"
        
    elif [ "${1}" = "DS720+" ] || [ "${1}" = "DS720+F" ]; then
        TARGET_PLATFORM="ds720p"
        ORIGIN_PLATFORM="geminilake"
        SYNOMODEL="ds720p_$TARGET_REVISION"                                                                                                                    
        sha256="914641e4885d0a465a46c35e3c271ca5e8cf7f1564591110c762c3ab11d0f202"
        SUVP="-1"
    elif [ "${1}" = "RS1221+" ] || [ "${1}" = "RS1221+F" ]; then
        TARGET_PLATFORM="rs1221p"
        ORIGIN_PLATFORM="v1000"        
        SYNOMODEL="rs1221p_$TARGET_REVISION"                                                                                                                    
        sha256="8a06aea176eb5f227675c1b75acd02875c2e0a2d3f4e227e87dc85b663bdbe33"
        SUVP="-1"
    elif [ "${1}" = "RS1619xs+" ] || [ "${1}" = "RS1619xs+F" ]; then
        TARGET_PLATFORM="rs1619xsp"
        ORIGIN_PLATFORM="broadwellnk"        
        SYNOMODEL="rs1619xsp_$TARGET_REVISION"
        sha256="4cd9b66fcf56d8d8cedd1435267a18c0b1cb7894462bdaf4db1bd9bb8f1ac0e1"
        SUVP="-1"
    elif [ "${1}" = "RS3621xs+" ] || [ "${1}" = "RS3621xs+F" ]; then
        TARGET_PLATFORM="rs3621xsp"
        ORIGIN_PLATFORM="broadwellnk"        
        SYNOMODEL="rs3621xsp_$TARGET_REVISION"
        sha256="8cd926bb3becd30d61d93770c050f102c294e96cab208d4a4f0ffa4f50006067"
        SUVP="-5"
    elif [ "${1}" = "SA3400" ] || [ "${1}" = "SA3400F" ]; then
        TARGET_PLATFORM="sa3400"
        ORIGIN_PLATFORM="broadwellnk"        
        SYNOMODEL="sa3400_$TARGET_REVISION"
        sha256="df1e1d2d32113419a5d5a0ba0213a35dc3ac6ad462ebe885ccf86a06c057fe1c"
        SUVP="-1"
        
# JOT MODE NEW MODEL TESTTING                
    elif [ "${1}" = "RS3413xs+" ] || [ "${1}" = "RS3413xs+F" ]; then
        echo "Synology model ${1} jot mode not supported by m shell, Testing..."        
        exit 0        
            
        TARGET_PLATFORM="rs3413xsp"
        ORIGIN_PLATFORM="bromolow"        
        SYNOMODEL="rs3413xsp_$TARGET_REVISION"
        sha256="de2425d55667a1c67763aeea1155bc6e336fb419148bb70f1ae1243d914d34ff"

#DSM 7.2 RC
    elif [ "${1}" = "DS1019+K" ]; then        
        TARGET_REVISION="64551"
        TARGET_PLATFORM="ds1019p"
        ORIGIN_PLATFORM="apollolake"
        SYNOMODEL="ds1019p_$TARGET_REVISION"                                                                                                                    
        sha256="41d300ce3ca7482dd610aa0b540ea2a27896cc1d62ea8edd594ba19bd2a23a1d"
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
ucode=$(jq -r -e '.general.ucode' "$USER_CONFIG_FILE")

### Messages Contents
## US
MSGUS00="Device-Tree[DT] Base Models & HBAs do not require SataPortMap,DiskIdxMap. DT models do not support HBAs\n"
MSGUS01="Choose a Dev Mod handling method, DDSML/EUDEV"
MSGUS02="Choose a Synology Model"
MSGUS03="Choose a Synology Serial Number"
MSGUS04="Choose a mac address"
MSGUS05="Build the [TCRP 7.1.1 JOT Mode] loader"
MSGUS06="Choose a loader Mode Current "
MSGUS07="Build the [TCRP 7.1.1-42962] loader"
MSGUS08="Build the [TCRP 7.0.1-42218] loader (FRIEND)"
MSGUS09="Build the [TCRP 7.2.0-64570] loader"
MSGUS10="Edit user config file manually"
MSGUS11="Choose a keymap"
MSGUS12="Erase Data DISK"
MSGUS13="Backup TCRP"
MSGUS14="Reboot"
MSGUS15="Exit"
MSGUS16="Max 24 Threads, any x86-64"
MSGUS17="Max 8 Threads, Haswell or later,iGPU Transcoding"
MSGUS18="HBA displays incorrect disk S/N"
MSGUS19="Build the [TCRP 7.2.0 JOT Mode] loader"
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
MSGUS39="Choose a lageuage"
MSGUS40="DDSML+EUDEV"

## RU
MSGRU00="Базовые модели и HBAs Device-Tree [DT] не требуют SataPortMap, DiskIdxMap. DT модели не поддерживают HBAs\n"
MSGRU01="Выберите метод обработки Dev Mod, DDSML/EUDEV"
MSGRU02="Выберите модель Synology"
MSGRU03="Выберите серийный номер Synology"
MSGRU04="Выберите MAC-адрес"
MSGRU05="Соберите загрузчик [TCRP 7.1.1 JOT Mode]"
MSGRU06="Выберите текущий режим загрузчика"
MSGRU07="Соберите загрузчик [TCRP 7.1.1-42962]"
MSGRU08="Соберите загрузчик [TCRP 7.0.1-42218] (FRIEND)"
MSGRU09="Соберите загрузчик [TCRP 7.2.0-64570]"
MSGRU10="Отредактируйте файл конфигурации пользователя вручную"
MSGRU11="Выберите раскладку клавиатуры"
MSGRU12="Стереть данные с диска"
MSGRU13="Резервное копирование TCRP"
MSGRU14="Перезагрузить"
MSGRU15="Выход"
MSGRU16="Максимум 24 потока, любой x86-64"
MSGRU17="Максимум 8 потоков, Haswell или более поздний, iGPU транскодирование"
MSGRU18="HBA отображает неправильный серийный номер диска"
MSGRU19="Соберите загрузчик [TCRP 7.2.0 JOT Mode]"
MSGRU20="Максимум ? Потоки, любой x86-64"
MSGRU21="Есть ли лицензия на камеру"
MSGRU22="Максимум 16 потоков, любой x86-64"
MSGRU23="Максимум 16 потоков, Haswell или более поздний"
MSGRU24="Nvidia GTX1650"
MSGRU25="Nvidia GTX1050Ti"
MSGRU26="EUDEV (усовершенствованное устройство пользовательского пространства)"
MSGRU27="DDSML (Загрузка статического модуля обнаруженного устройства)"
MSGRU28="FRIEND (недавно стабилизированный)"
MSGRU29="JOT (Старый способ до friend)"
MSGRU30="Сгенерировать случайный серийный номер"
MSGRU31="Введите серийный номер"
MSGRU32="Получить реальный MAC-адрес"
MSGRU33="Сгенерировать случайный MAC-адрес"
MSGRU34="Введите MAC-адрес"
MSGRU35="нажмите любую клавишу для продолжения ..."
MSGRU36="Серийный номер Synology не задан. Проверьте файл user_config.json еще раз. Остановка построения загрузчика !!!!"
MSGRU37="Первый MAC-адрес не задан. Проверьте файл user_config.json еще раз. Остановка построения загрузчика !!!!!!"
MSGRU38="Количество интерфейсов (netif_num) и количество MAC-адресов не совпадают. Проверьте файл user_config.json еще раз. Остановка построения загрузчика !!!!!!"
MSGRU39="Выберите язык"
MSGRU40="DDSML+EUDEV"

## FR
MSGFR00="Les modèles de base et les HBAs de l'arbre de périphériques [DT] ne nécessitent pas de SataPortMap, DiskIdxMap. Les modèles DT ne prennent pas en charge les HBAs\n"
MSGFR01="Choisissez une méthode de gestion des modèles de périphérique, DDSML/EUDEV"
MSGFR02="Choisissez un modèle Synology"
MSGFR03="Choisissez un numéro de série Synology"
MSGFR04="Choisissez une adresse MAC"
MSGFR05="Construisez le chargeur [TCRP 7.1.1 JOT Mode]"
MSGFR06="Choisissez un mode de chargeur actuel"
MSGFR07="Construisez le chargeur [TCRP 7.1.1-42962]"
MSGFR08="Construisez le chargeur [TCRP 7.0.1-42218] (FRIEND)"
MSGFR09="Construisez le chargeur [TCRP 7.2.0-64570]"
MSGFR10="Modifier manuellement le fichier de configuration de l'utilisateur"
MSGFR11="Choisissez une disposition de clavier"
MSGFR12="Effacer le disque de données"
MSGFR13="Sauvegarde TCRP"
MSGFR14="Redémarrer"
MSGFR15="Sortie"
MSGFR16="Max 24 Threads, n'importe quel x86-64"
MSGFR17="Max 8 Threads, Haswell ou plus tard, transcodage iGPU"
MSGFR18="L'HBA affiche un S/N de disque incorrect"
MSGFR19="Construisez le chargeur [TCRP 7.2.0 JOT Mode]"
MSGFR20="Max ? Threads, n'importe quel x86-64"
MSGFR21="Avoir une licence de caméra"
MSGFR22="Max 16 Threads, n'importe quel x86-64"
MSGFR23="Max 16 Threads, Haswell ou plus tard"
MSGFR24="Nvidia GTX1650"
MSGFR25="Nvidia GTX1050Ti"
MSGFR26="EUDEV (périphérique d'espace utilisateur amélioré)"
MSGFR27="DDSML (Chargement de module statique de périphérique détecté)"
MSGFR28="FRIEND (le plus récemment stabilisé)"
MSGFR29="JOT (l'ancienne méthode avant friend)"
MSGFR30="Générer un numéro de série aléatoire"
MSGFR31="Entrez un numéro de série"
MSGFR32="Obtenir une véritable adresse MAC"
MSGFR33="Générer une adresse MAC aléatoire"
MSGFR34="Entrez une adresse MAC"
MSGFR35="appuyez sur n'importe quelle touche pour continuer..."
MSGFR36="Le numéro de série Synology n'est pas défini. Vérifiez à nouveau user_config.json. Abandonner la construction du chargeur !!!!!!"
MSGFR37="La première adresse MAC n'est pas définie. Vérifiez à nouveau user_config.json. Abandonner la construction du chargeur !!!!!!"
MSGFR38="Le netif_num et le nombre d'adresses MAC ne correspondent pas. Vérifiez à nouveau user_config.json. Abandonner la construction du chargeur !!!!!!"
MSGFR39="Choisissez une langue"
MSGFR40="DDSML+EUDEV"

## DE
MSGDE00="Gerätebaum[DT] Basismodelle und HBAs benötigen kein SataPortMap,DiskIdxMap. DT-Modelle unterstützen keine HBAs\n"
MSGDE01="Wählen Sie eine Methode zur Verwaltung von Dev-Mods, DDSML/EUDEV"
MSGDE02="Wählen Sie ein Synology-Modell"
MSGDE03="Wählen Sie eine Synology-Seriennummer"
MSGDE04="Wählen Sie eine MAC-Adresse"
MSGDE05="Erstellen Sie den [TCRP 7.1.1 JOT-Modus] Loader"
MSGDE06="Wählen Sie einen Loader-Modus Current"
MSGDE07="Erstellen Sie den [TCRP 7.1.1-42962] Loader"
MSGDE08="Erstellen Sie den [TCRP 7.0.1-42218] Loader (FRIEND)"
MSGDE09="Erstellen Sie den [TCRP 7.2.0-64570] Loader"
MSGDE10="Bearbeiten Sie die Benutzerkonfigurationsdatei manuell"
MSGDE11="Wählen Sie eine Tastenkarte"
MSGDE12="Löschen Sie die Datendiskette"
MSGDE13="Backup TCRP"
MSGDE14="Neu starten"
MSGDE15="Beenden"
MSGDE16="Max. 24 Threads, beliebiges x86-64"
MSGDE17="Max. 8 Threads, Haswell oder höher, iGPU-Transcodierung"
MSGDE18="HBA zeigt falsche Festplattenseriennummer an"
MSGDE19="Erstellen Sie den [TCRP 7.2.0 JOT-Modus] Loader"
MSGDE20="Max. ? Threads, beliebiges x86-64"
MSGDE21="Haben Sie eine Kamera-Lizenz"
MSGDE22="Max. 16 Threads, beliebiges x86-64"
MSGDE23="Max. 16 Threads, Haswell oder höher"
MSGDE24="Nvidia GTX1650"
MSGDE25="Nvidia GTX1050Ti"
MSGDE26="EUDEV (verbessertes Benutzerraumgerät)"
MSGDE27="DDSML (Erkannte Gerätestatische Modulladung)"
MSGDE28="FRIEND (zuletzt stabilisiert)"
MSGDE29="JOT (Der alte Weg vor Freund)"
MSGDE30="Erstellen Sie eine zufällige Seriennummer"
MSGDE31="Geben Sie eine Seriennummer ein"
MSGDE32="Holen Sie sich eine echte MAC-Adresse"
MSGDE33="Erstellen Sie eine zufällige MAC-Adresse"
MSGDE34="Geben Sie eine MAC-Adresse ein"
MSGDE35="Drücken Sie eine beliebige Taste, um fortzufahren..."
MSGDE36="Synology-Seriennummer nicht festgelegt. Überprüfen Sie user_config.json erneut. Loader-Build abbrechen !!!!!!"
MSGDE37="Die erste MAC-Adresse ist nicht festgelegt. Überprüfen Sie user_config.json erneut. Loader-Build abbrechen !!!!!!"
MSGDE38="Die netif_num und die Anzahl der MAC-Adressen stimmen nicht überein. Überprüfen Sie user_config.json erneut. Loader-Build abbrechen !!!!!!"
MSGDE39="Wählen Sie eine Sprache"
MSGDE40="DDSML+EUDEV"

## ES
MSGES00="Los modelos base y HBAs de Device-Tree[DT] no requieren SataPortMap, DiskIdxMap. Los modelos DT no admiten HBAs\n"
MSGES01="Elija un método de manejo de Mod Dev, DDSML/EUDEV"
MSGES02="Elija un modelo de Synology"
MSGES03="Elija un número de serie de Synology"
MSGES04="Elija una dirección MAC"
MSGES05="Construir el cargador [TCRP 7.1.1 JOT Mode]"
MSGES06="Elija un modo de cargador Actual"
MSGES07="Construir el cargador [TCRP 7.1.1-42962]"
MSGES08="Construir el cargador [TCRP 7.0.1-42218] (FRIEND)"
MSGES09="Construir el cargador [TCRP 7.2.0-64570]"
MSGES10="Editar manualmente el archivo de configuración del usuario"
MSGES11="Elija un mapa de teclas"
MSGES12="Borrar disco de datos"
MSGES13="Copia de seguridad de TCRP"
MSGES14="Reiniciar"
MSGES15="Salir"
MSGES16="Máx. 24 hilos, cualquier x86-64"
MSGES17="Máx. 8 hilos, Haswell o posterior, transcodificación de iGPU"
MSGES18="HBA muestra el S/N incorrecto del disco"
MSGES19="Construir el cargador [TCRP 7.2.0 JOT Mode]"
MSGES20="Máx. ? hilos, cualquier x86-64"
MSGES21="Tener una licencia de cámara"
MSGES22="Máx. 16 hilos, cualquier x86-64"
MSGES23="Máx. 16 hilos, Haswell o posterior"
MSGES24="Nvidia GTX1650"
MSGES25="Nvidia GTX1050Ti"
MSGES26="EUDEV (dispositivo de espacio de usuario mejorado)"
MSGES27="DDSML (Carga de módulo estático de dispositivo detectado)"
MSGES28="FRIEND (estabilizado más recientemente)"
MSGES29="JOT (La forma antigua antes de friend)"
MSGES30="Generar un número de serie aleatorio"
MSGES31="Ingrese un número de serie"
MSGES32="Obtener una dirección MAC real"
MSGES33="Generar una dirección MAC aleatoria"
MSGES34="Ingrese una dirección MAC"
MSGES35="Presione cualquier tecla para continuar..."
MSGES36="Número de serie de Synology no establecido. Revise user_config.json nuevamente. ¡¡¡¡Abortar la construcción del cargador!!!!"
MSGES37="La primera dirección MAC no está establecida. Revise user_config.json nuevamente. ¡¡¡¡Abortar la construcción del cargador!!!!"
MSGES38="El número de netif_num y direcciones MAC no coinciden. Revise user_config.json nuevamente. ¡¡¡¡Abortar la construcción del cargador!!!!"
MSGES39="Elige un idioma"
MSGES40="DDSML+EUDEV"

## BR
MSGBR00="Modelos Base e HBAs do Device-Tree[DT] não requerem SataPortMap, DiskIdxMap. Modelos DT não suportam HBAs\n"
MSGBR01="Escolha um método de manipulação de Dev Mod, DDSML/EUDEV"
MSGBR02="Escolha um modelo Synology"
MSGBR03="Escolha um número de série Synology"
MSGBR04="Escolha um endereço MAC"
MSGBR05="Construa o loader [TCRP 7.1.1 JOT Mode]"
MSGBR06="Escolha o modo de loader Atual"
MSGBR07="Construa o loader [TCRP 7.1.1-42962]"
MSGBR08="Construa o loader [TCRP 7.0.1-42218] (FRIEND)"
MSGBR09="Construa o loader [TCRP 7.2.0-64570]"
MSGBR10="Edite manualmente o arquivo de configuração do usuário"
MSGBR11="Escolha um mapa de teclado"
MSGBR12="Apague o DISK de dados"
MSGBR13="Backup TCRP"
MSGBR14="Reinicie"
MSGBR15="Sair"
MSGBR16="Máximo de 24 Threads, qualquer x86-64"
MSGBR17="Máximo de 8 Threads, Haswell ou posterior, transcoding de iGPU"
MSGBR18="HBA exibe S/N de disco incorreto"
MSGBR19="Construa o loader [TCRP 7.2.0 JOT Mode]"
MSGBR20="Máximo de ? Threads, qualquer x86-64"
MSGBR21="Ter uma licença de câmera"
MSGBR22="Máximo de 16 Threads, qualquer x86-64"
MSGBR23="Máximo de 16 Threads, Haswell ou posterior"
MSGBR24="Nvidia GTX1650"
MSGBR25="Nvidia GTX1050Ti"
MSGBR26="EUDEV (dispositivo de usuário aprimorado)"
MSGBR27="DDSML (Carregamento de Módulo Estático de Dispositivo Detectado)"
MSGBR28="FRIEND (mais recentemente estabilizado)"
MSGBR29="JOT (O antigo método antes de friend)"
MSGBR30="Gerar um número de série aleatório"
MSGBR31="Digite um número de série"
MSGBR32="Obter um endereço MAC real"
MSGBR33="Gerar um endereço MAC aleatório"
MSGBR34="Digite um endereço MAC"
MSGBR35="pressione qualquer tecla para continuar..."
MSGBR36="Número de série Synology não definido. Verifique o user_config.json novamente. Abortar a construção do loader!!!!!!"
MSGBR37="O primeiro endereço MAC não está definido. Verifique o user_config.json novamente. Abortar a construção do loader!!!!!!"
MSGBR38="O netif_num e o número de endereços MAC não correspondem. Verifique o user_config.json novamente. Abortar a construção do loader!!!!!!"
MSGBR39="Olá! Posso ajudá-lo em Português"
MSGBR40="DDSML+EUDEV"

## IT
MSGIT00="I modelli di base e gli HBA di Device-Tree [DT] non richiedono SataPortMap, DiskIdxMap. I modelli DT non supportano gli HBA\n"
MSGIT01="Scegli un metodo di gestione del Mod Dev, DDSML/EUDEV"
MSGIT02="Scegli un modello Synology"
MSGIT03="Scegli un numero di serie Synology"
MSGIT04="Scegli un indirizzo MAC"
MSGIT05="Costruisci il caricatore [TCRP 7.1.1 JOT Mode]"
MSGIT06="Scegli una modalità di caricatore corrente"
MSGIT07="Costruisci il caricatore [TCRP 7.1.1-42962]"
MSGIT08="Costruisci il caricatore [TCRP 7.0.1-42218] (FRIEND)"
MSGIT09="Costruisci il caricatore [TCRP 7.2.0-64570]"
MSGIT10="Modifica manualmente il file di configurazione dell'utente"
MSGIT11="Scegli una mappatura dei tasti"
MSGIT12="Cancella il disco dati"
MSGIT13="Backup TCRP"
MSGIT14="Riavvia"
MSGIT15="Esci"
MSGIT16="Max 24 Thread, qualsiasi x86-64"
MSGIT17="Max 8 Thread, Haswell o successivi, trascodifica iGPU"
MSGIT18="HBA visualizza il numero di serie del disco in modo errato"
MSGIT19="Costruisci il caricatore [TCRP 7.2.0 JOT Mode]"
MSGIT20="Max ? Thread, qualsiasi x86-64"
MSGIT21="Hai una licenza per la telecamera"
MSGIT22="Max 16 Thread, qualsiasi x86-64"
MSGIT23="Max 16 Thread, Haswell o successivi"
MSGIT24="Nvidia GTX1650"
MSGIT25="Nvidia GTX1050Ti"
MSGIT26="EUDEV (dispositivo a spazio utente migliorato)"
MSGIT27="DDSML (Caricamento statico del modulo dispositivo rilevato)"
MSGIT28="FRIEND (più recentemente stabilizzato)"
MSGIT29="JOT (il vecchio modo prima di FRIEND)"
MSGIT30="Genera un numero di serie casuale"
MSGIT31="Inserisci un numero di serie"
MSGIT32="Ottieni un vero indirizzo MAC"
MSGIT33="Genera un indirizzo MAC casuale"
MSGIT34="Inserisci un indirizzo MAC"
MSGIT35="premere un tasto per continuare..."
MSGIT36="Numero di serie Synology non impostato. Controlla di nuovo user_config.json. Abortire la costruzione del caricatore !!!!!!"
MSGIT37="Il primo indirizzo MAC non è impostato. Controlla di nuovo user_config.json. Abortire la costruzione del caricatore !!!!!!"
MSGIT38="Il numero di netif e il numero di indirizzi MAC non corrispondono. Controlla di nuovo user_config.json. Abortire la costruzione del caricatore !!!!!!"
MSGIT39="Scegli una lingua"
MSGIT40="DDSML+EUDEV"

## KR
MSGKR00="Device-Tree[DT]모델과 HBA는 SataPortMap,DiskIdxMap 설정이 필요없습니다. DT모델은 HBA를 지원하지 않습니다.\n"
MSGKR01="커널모듈 처리방법 선택 DDSML/EUDEV"
MSGKR02="Synology 모델 선택"
MSGKR03="Synology S/N 선택"
MSGKR04="선택 Mac 주소 "
MSGKR05="[TCRP 7.1.1 JOT Mode] 로더 빌드"
MSGKR06="로더모드 선택 현재"
MSGKR07="[TCRP 7.1.1-42962] 로더 빌드"
MSGKR08="[TCRP 7.0.1-42218] 로더 빌드 (FRIEND)"
MSGKR09="[TCRP 7.2.0-64570] 로더 빌드"
MSGKR10="user_config.json 파일 편집"
MSGKR11="다국어 자판 지원용 키맵 선택"
MSGKR12="데이터 디스크 지우기"
MSGKR13="TCRP 백업"
MSGKR14="재부팅"
MSGKR15="종료"
MSGKR16="최대 24 스레드 지원, 인텔 x86-64"
MSGKR17="최대 8 스레드 지원, 인텔 4세대 하스웰 이후부터 지원,iGPU H/W 트랜스코딩"
MSGKR18="HBA 사용시 잘못된 디스크 S/N이 표시됨"
MSGKR19="[TCRP 7.2.0 JOT Mode] 로더 빌드"
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
MSGKR39="언어를 선택하세요(Choose a lageuage)"
MSGKR40="DDSML+EUDEV"

## CN
MSGCN00="设备树[DT]基本型号和HBA不需要SataPortMap、DiskIdxMap. DT模型不支持HBA\n"
MSGCN01="选择Dev Mod处理方法，DDSML/EUDEV"
MSGCN02="选择一个Synology型号"
MSGCN03="选择一个Synology序列号"
MSGCN04="选择一个mac地址"
MSGCN05="构建[TCRP 7.1.1 JOT模式]加载器"
MSGCN06="选择加载器模式 Current"
MSGCN07="构建[TCRP 7.1.1-42962]加载器"
MSGCN08="构建[TCRP 7.0.1-42218]加载器 (FRIEND)"
MSGCN09="构建[TCRP 7.2.0-64570]加载器"
MSGCN10="手动编辑用户配置文件"
MSGCN11="选择一个键盘映射"
MSGCN12="擦除数据磁盘"
MSGCN13="备份TCRP"
MSGCN14="重新启动"
MSGCN15="退出"
MSGCN16="最大24线程，任何x86-64"
MSGCN17="最大8线程，Haswell或更高版本，iGPU转码"
MSGCN18="HBA显示不正确的磁盘S/N"
MSGCN19="构建[TCRP 7.2.0 JOT模式]加载器"
MSGCN20="最大？线程，任何x86-64"
MSGCN21="拥有摄像机许可证"
MSGCN22="最大16线程，任何x86-64"
MSGCN23="最大16线程，Haswell或更高版本"
MSGCN24="Nvidia GTX1650"
MSGCN25="Nvidia GTX1050Ti"
MSGCN26="EUDEV（增强的用户空间设备）"
MSGCN27="DDSML（检测到的设备静态模块加载）"
MSGCN28="FRIEND（最近稳定）"
MSGCN29="JOT（在friend之前的旧方式）"
MSGCN30="生成一个随机序列号"
MSGCN31="输入序列号"
MSGCN32="获取真实的mac地址"
MSGCN33="生成一个随机的mac地址"
MSGCN34="输入mac地址"
MSGCN35="按任意键继续..."
MSGCN36="未设置Synology序列号。请再次检查user_config.json。终止加载器构建!!!!!!"
MSGCN37="未设置第一个MAC地址。请再次检查user_config.json。终止加载器构建!!!!!!"
MSGCN38="netif_num和mac地址数量不匹配。请再次检查user_config.json。终止加载器构建!!!!!!"
MSGCN39="选择语言"
MSGCN40="DDSML+EUDEV"

## JP
MSGJP00="Device-Tree[DT]ベースモデルとHBAsは、SataPortMap、DiskIdxMapが必要ありません. DTモデルはHBAsをサポートしていません\n"
MSGJP01="Dev Mod処理方法を選択してください、EUDEV / DDSML"
MSGJP02="Synologyモデルを選択してください"
MSGJP03="Synologyシリアル番号を選択してください"
MSGJP04="MACアドレスを選択してください"
MSGJP05="[TCRP 7.1.1 JOT Mode]ローダーをビルドする"
MSGJP06="現在のローダーモードを選択してください"
MSGJP07="[TCRP 7.1.1-42962]ローダーをビルドする"
MSGJP08="[TCRP 7.0.1-42218]ローダーをビルドする（FRIEND）"
MSGJP09="[TCRP 7.2.0-64570]ローダーをビルドする"
MSGJP10="ユーザー設定ファイルを手動で編集する"
MSGJP11="キーマップを選択してください"
MSGJP12="データDISKを消去する"
MSGJP13="TCRPをバックアップする"
MSGJP14="再起動"
MSGJP15="終了"
MSGJP16="最大24スレッド、任意のx86-64"
MSGJP17="Haswell以降、iGPUトランスコーディングを備えた最大8スレッド"
MSGJP18="HBAは間違ったディスクS / Nを表示します"
MSGJP19="[TCRP 7.2.0 JOT Mode]ローダーをビルドする"
MSGJP20="最大？スレッド、任意のx86-64"
MSGJP21="カメラライセンスを持っています"
MSGJP22="最大16スレッド、任意のx86-64"
MSGJP23="Haswell以降、最大16スレッド"
MSGJP24="Nvidia GTX1650"
MSGJP25="Nvidia GTX1050Ti"
MSGJP26="EUDEV（拡張ユーザースペースデバイス）"
MSGJP27="DDSML（検出されたデバイス静的モジュールローディング）"
MSGJP28="FRIEND（最近安定化されました）"
MSGJP29="JOT（フレンドよりも古い方法）"
MSGJP30="ランダムなシリアル番号を生成する"
MSGJP31="シリアル番号を入力してください"
MSGJP32="実際のMACアドレスを取得する"
MSGJP33="ランダムなMACアドレスを生成する"
MSGJP34="MACアドレスを入力してください"
MSGJP35="続行するには任意のキーを押してください..."
MSGJP36="Synologyのシリアル番号が設定されていません。user_config.jsonを再度確認してください。ローダービルドを中止します！！！！"
MSGJP37="最初のMACアドレスが設定されていません。user_config.jsonを再度確認してください。ローダービルドを中止します！！！！"
MSGJP38="netif_numとMACアドレスの数が一致しません。user_config.jsonを再度確認してください。ローダービルドを中止します！！！！"
MSGJP39="言語を選択してください"
MSGJP40="DDSML+EUDEV"

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
  BACKTITLE="TCRP 0.9.4.3-1"
  BACKTITLE+=" ${DMPM}"
  BACKTITLE+=" ${ucode}"
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
# Shows available between DDSML and EUDEV
function seleudev() {
  eval "MSG27=\"\${MSG${tz}27}\""
  eval "MSG26=\"\${MSG${tz}26}\""
  eval "MSG40=\"\${MSG${tz}40}\""
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

  curl -kL https://raw.githubusercontent.com/PeterSuh-Q3/redpill-load/master/bundled-exts.json -o /home/tc/redpill-load/bundled-exts.json
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
# Shows available models to user choose one
function modelMenu() {

  M_GRP1="DS3622xs+ DS1621xs+ RS3621xs+ RS4021xs+ DS3617xs RS3618xs"
  M_GRP2="DS3615xs"
  M_GRP3="DVA3221 DVA3219"
  M_GRP4="DS918+ DS1019+"
  M_GRP5="DS923+ DS723+ SA6400"
  M_GRP6="DS1621+ DS2422+ FS2500 RS1221+"
  M_GRP7="DS720+ DS920+ DS1520+ DVA1622"
  
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
    DS1019+)     platform="apollolake";eval "desc=\"[${MODEL}]:${platform}, Intel Celeron J3455, \${MSG${tz}17}, \${MSG${tz}18}\"";;
    DS1520+)     platform="geminilake";eval "desc=\"[${MODEL}]:${platform}(DT), Intel Celeron J4125, \${MSG${tz}17}\"";;    
    DS1621+)     platform="v1000";eval "desc=\"[${MODEL}]:${platform}(DT), AMD Ryzen V1500B, \${MSG${tz}22}\"";;    
    DS1621xs+)   platform="broadwellnk";eval "desc=\"[${MODEL}]:${platform}, Intel Xeon D-1527, \${MSG${tz}16}\"";;
    DS2422+)     platform="v1000";eval "desc=\"[${MODEL}]:${platform}(DT), AMD Ryzen V1500B, \${MSG${tz}22}\"";;    
    DS3615xs)    platform="bromolow";eval "desc=\"[${MODEL}]:${platform}, Intel Core i3-4130, \${MSG${tz}22}\"";;    
    DS3617xs)    platform="broadwell";eval "desc=\"[${MODEL}]:${platform}, Intel Xeon D-1527, \${MSG${tz}16}\"";;    
    DS3622xs+)   platform="broadwellnk";eval "desc=\"[${MODEL}]:${platform}, Intel Xeon D-1531, \${MSG${tz}16}\"";;
    DS720+)      platform="geminilake";eval "desc=\"[${MODEL}]:${platform}(DT), Intel Celeron J4125, \${MSG${tz}17}\"";;        
    DS723+)      platform="r1000";eval "desc=\"[${MODEL}]:${platform}(DT), AMD Ryzen R1600, \${MSG${tz}20}\"";;
    DS918+)      platform="apollolake";eval "desc=\"[${MODEL}]:${platform}, Intel Celeron J3455, \${MSG${tz}17}, \${MSG${tz}18}\"";;    
    DS920+)      platform="geminilake";eval "desc=\"[${MODEL}]:${platform}(DT), Intel Celeron J4125, \${MSG${tz}17}\"";;
    DS923+)      platform="r1000";eval "desc=\"[${MODEL}]:${platform}(DT) AMD Ryzen R1600, \${MSG${tz}20}\"";;
    DVA1622)     platform="geminilake";eval "desc=\"[${MODEL}]:${platform}(DT), Intel Celeron J4125, \${MSG${tz}17}, \${MSG${tz}21}\"";;
    DVA3219)     platform="denverton";eval "desc=\"[${MODEL}]:${platform}, Intel Atom C3538, \${MSG${tz}23}, \${MSG${tz}25}, \${MSG${tz}21}\"";;    
    DVA3221)     platform="denverton";eval "desc=\"[${MODEL}]:${platform}, Intel Atom C3538, \${MSG${tz}23}, \${MSG${tz}24}, \${MSG${tz}21}\"";;    
    FS2500)      platform="v1000";eval "desc=\"[${MODEL}]:${platform}(DT), AMD Ryzen V1780B, \${MSG${tz}22}\"";;
    RS1221+)     platform="v1000";eval "desc=\"[${MODEL}]:${platform}(DT), AMD Ryzen V1500B, \${MSG${tz}22}\"";;    
    RS3618xs)    platform="broadwell";eval "desc=\"[${MODEL}]:${platform}, Intel Xeon D-1521, \${MSG${tz}16}\"";;
    RS3621xs+)   platform="broadwellnk";eval "desc=\"[${MODEL}]:${platform}, Intel Xeon D-1541, \${MSG${tz}16}\"";;    
    RS4021xs+)   platform="broadwellnk";eval "desc=\"[${MODEL}]:${platform}, Intel Xeon D-1541, \${MSG${tz}16}\"";;
    SA6400)      platform="epyc7002";eval "desc=\"[${MODEL}]:${platform}(DT), AMD EPYC 7272 \"";;
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

  if [ "$1" = "jun" ]; then
      ./my.sh "${MODEL}"J noconfig | tee "/home/tc/zlastbuild.log"    
  elif [ "$1" = "of" ]; then
      ./my.sh "${MODEL}"G noconfig | tee "/home/tc/zlastbuild.log"    
  elif [ "$1" = "ofjot" ]; then
      ./my.sh "${MODEL}"G noconfig "jot" | tee "/home/tc/zlastbuild.log"    
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
  rm -f /home/tc/buildstatus  
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

function writexsession() {

  echo "insert aterm menu.sh in /home/tc/.xsession"

  sed -i "/locale/d" .xsession
  sed -i "/utf8/d" .xsession
  sed -i "/UTF-8/d" .xsession
  sed -i "/aterm/d" .xsession
  sed -i "/urxvt/d" .xsession

  if [ "${ucode}" != "en_US" ]; then
    echo "export LANG=${ucode}.UTF-8" >> .xsession
    echo "export LC_ALL=${ucode}.UTF-8" >> .xsession
    echo "[ ! -d /usr/lib/locale ] && sudo mkdir /usr/lib/locale &" >> .xsession
    echo "sudo localedef -c -i ${ucode} -f UTF-8 ${ucode}.UTF-8" >> .xsession
    echo "sudo localedef -f UTF-8 -i ${ucode} ${ucode}.UTF-8" >> .xsession
  fi
  echo "urxvt -geometry 78x32+10+0 -fg orange -title \"M Shell for TCRP Menu\" -e /home/tc/menu.sh &" >> .xsession  
  echo "aterm -geometry 78x32+525+0 -fg yellow -title \"TCRP Monitor\" -e /home/tc/rploader.sh monitor &" >> .xsession
  echo "aterm -geometry 78x25+10+430 -title \"TCRP Build Status\" -e /home/tc/ntp.sh &" >> .xsession
  echo "aterm -geometry 78x25+525+430 -fg green -title \"TCRP Extra Terminal\" &" >> .xsession
}

###############################################################################
# Shows available language to user choose one
function langMenu() {

  dialog --backtitle "`backtitle`" --default-item "${LAYOUT}" --no-items \
    --menu "Choose a language" 0 0 0 "English" "한국어" "日本語" "中文" "Русский" \
    "Français" "Deutsch" "Español" "Italiano" "brasileiro" \
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
  esac

  export LANG=${ucode}.UTF-8
  export LC_ALL=${ucode}.UTF-8
  [ ! -d /usr/lib/locale ] && sudo mkdir /usr/lib/locale
  sudo localedef -c -i ${ucode} -f UTF-8 ${ucode}.UTF-8
  sudo localedef -f UTF-8 -i ${ucode} ${ucode}.UTF-8
  
  writeConfigKey "general" "ucode" "${ucode}"  
  writexsession
  
  setSuggest
  
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
  echo 'Y'|./rploader.sh backup
  
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
  echo "y"|./rploader.sh backup
  echo "press any key to continue..."
  read answer
  return 0
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

# Main loop
tcrppart="$(mount | grep -i optional | grep cde | awk -F / '{print $3}' | uniq | cut -c 1-3)3"

#Get Langugae code & country code
if [ "${ucode}" == "null" ]; then
  tz=$(curl -s ipinfo.io | grep country | awk '{print $2}' | cut -c 2-3 )
    
  case "$tz" in
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
    *) tz="US"; ucode="en_US";;
  esac
    
else    
    ucode=$(jq -r -e '.general.ucode' "$USER_CONFIG_FILE")
    [ $? -ne 0 ] && ucode="en_US"
    tz=$(echo $ucode | cut -c 4-)    
fi

echo "tz = ${tz}"
echo "ucode = ${ucode}"

writeConfigKey "general" "ucode" "${ucode}"

#  export country=$tz
#  lang=$(curl -s https://restcountries.com/v2/all | jq -r 'map(select(.alpha2Code == env.country)) | .[0].languages | .[].iso639_1' | head -2)
#  if [ $? -eq 0 ]; then
#    ucode=${lang}_${tz}
#  else
#    tz="US"  
#    ucode="en_US"
#  fi

sed -i "s/screen_color = (CYAN,GREEN,ON)/screen_color = (CYAN,BLUE,ON)/g" ~/.dialogrc

writexsession

if [ "${ucode}" != "en_US" ]; then
    if [ $(cat /mnt/${tcrppart}/cde/onboot.lst|grep rxvt | wc -w) -eq 0 ]; then
	tce-load -wi glibc_apps
	tce-load -wi glibc_i18n_locale
	tce-load -wi unifont
	tce-load -wi rxvt
	if [ $? -eq 0 ]; then
	    echo "Download glibc_apps.tcz and glibc_i18n_locale.tcz OK, Permanent installation progress !!!"
	    sudo cp -f /tmp/tce/optional/* /mnt/${tcrppart}/cde/optional
	    sudo echo "" >> /mnt/${tcrppart}/cde/onboot.lst	    
	    sudo echo "glibc_apps.tcz" >> /mnt/${tcrppart}/cde/onboot.lst
	    sudo echo "glibc_i18n_locale.tcz" >> /mnt/${tcrppart}/cde/onboot.lst
	    sudo echo "unifont.tcz" >> /mnt/${tcrppart}/cde/onboot.lst
	    sudo echo "rxvt.tcz" >> /mnt/${tcrppart}/cde/onboot.lst
	    echo 'Y'|./rploader.sh backup

	    echo
	    echo "You have finished installing TC Unicode package and urxvt."
	    restart
	else
	    echo "Download glibc_apps.tcz, glibc_i18n_locale.tcz FAIL !!!"
	fi
    fi
else
    echo "ucode is en_US , ucode is ${ucode}"
fi	

if [ $(cat /mnt/${tcrppart}/cde/onboot.lst|grep rxvt | wc -w) -gt 0 ]; then
# for 2Byte Language
  [ ! -d /usr/lib/locale ] && sudo mkdir /usr/lib/locale
  export LANG=${ucode}.UTF-8
  export LC_ALL=${ucode}.UTF-8
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
  if [ $(cat ~/.Xdefaults|grep "URxvt*encoding: UTF-8" | wc -w) -eq 0 ]; then	
    echo "URxvt*encoding: UTF-8"  >> ~/.Xdefaults
  fi
  if [ $(cat ~/.Xdefaults|grep "URxvt*locale:" | wc -w) -eq 0 ]; then	
    echo "URxvt*locale: ${ucode}.UTF-8"  >> ~/.Xdefaults
  else
    sed -i "/URxvt*locale:/d" ~/.Xdefaults
    echo "URxvt*locale: ${ucode}.UTF-8"  >> ~/.Xdefaults
  fi
fi

locale
if [ $(cat /mnt/${tcrppart}/cde/onboot.lst|grep "kmaps.tczglibc_apps.tcz" | wc -w) -gt 0 ]; then
    sudo sed -i "/kmaps.tczglibc_apps.tcz/d" /mnt/${tcrppart}/cde/onboot.lst	
    sudo echo "glibc_apps.tcz" >> /mnt/${tcrppart}/cde/onboot.lst
    sudo echo "kmaps.tcz" >> /mnt/${tcrppart}/cde/onboot.lst
    echo 'Y'|./rploader.sh backup
    
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

if [ $tcrppart == "mmc3" ]; then
    tcrppart="mmcblk0p3"
fi    

# Download dialog
if [ "$(which dialog)_" == "_" ]; then
    sudo curl -kL https://raw.githubusercontent.com/PeterSuh-Q3/tinycore-redpill/master/tce/optional/dialog.tcz -o /mnt/${tcrppart}/cde/optional/dialog.tcz
    sudo curl -kL https://raw.githubusercontent.com/PeterSuh-Q3/tinycore-redpill/master/tce/optional/dialog.tcz.dep -o /mnt/${tcrppart}/cde/optional/dialog.tcz.dep
    sudo curl -kL https://raw.githubusercontent.com/PeterSuh-Q3/tinycore-redpill/master/tce/optional/dialog.tcz.md5.txt -o /mnt/${tcrppart}/cde/optional/dialog.tcz.md5.txt
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
    sudo curl -kL https://raw.githubusercontent.com/PeterSuh-Q3/tinycore-redpill/master/tce/optional/kmaps.tcz -o /mnt/${tcrppart}/cde/optional/kmaps.tcz
    sudo curl -kL https://raw.githubusercontent.com/PeterSuh-Q3/tinycore-redpill/master/tce/optional/kmaps.tcz.md5.txt -o /mnt/${tcrppart}/cde/optional/kmaps.tcz.md5.txt
    tce-load -i kmaps
    if [ $? -eq 0 ]; then
        echo "Download kmaps OK !!!"
    else
        tce-load -iw kmaps
    fi
    sudo echo "kmaps.tcz" >> /mnt/${tcrppart}/cde/onboot.lst
fi

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
      eval "echo \"n \\\"\${MSG${tz}19}\\\"\""           >> "${TMP_PATH}/menu"      
    else 
      eval "echo \"z \\\"\${MSG${tz}06} (${LDRMODE})\\\"\""   >> "${TMP_PATH}/menu"
      eval "echo \"p \\\"\${MSG${tz}09} (${LDRMODE})\\\"\""   >> "${TMP_PATH}/menu"      
      eval "echo \"d \\\"\${MSG${tz}07} (${LDRMODE})\\\"\""   >> "${TMP_PATH}/menu"
      eval "echo \"o \\\"\${MSG${tz}08}\\\"\""         >> "${TMP_PATH}/menu"
    fi
  fi
  eval "echo \"u \\\"\${MSG${tz}10}\\\"\""               >> "${TMP_PATH}/menu"
  eval "echo \"l \\\"\${MSG${tz}39}\\\"\""               >> "${TMP_PATH}/menu"
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
    z) selectldrmode ;    NEXT="p" ;;
    o) BUILD="42218"; make "jun";      NEXT="r" ;;    
    d) BUILD="42962"
       if [ "${LDRMODE}" == "FRIEND" ]; then
         make
       else
         make "jot"
       fi
       NEXT="r" ;;
    j) BUILD="42962"; make "jot";      NEXT="r" ;;    
    n) BUILD="64570"; make "ofjot";    NEXT="r" ;;    
    p) BUILD="64570"
       if [ "${LDRMODE}" == "FRIEND" ]; then
         make "of"
       else
         make "ofjot"
       fi
       NEXT="r" ;;
    u) editUserConfig;                 NEXT="d" ;;
    l) langMenu ;                      NEXT="m" ;;
    k) keymapMenu ;                    NEXT="m" ;;
    i) erasedisk ;                     NEXT="m" ;;
    b) backup ;                        NEXT="m" ;;
    r) restart ;;
    e) break ;;
  esac
done

clear
echo -e "Call \033[1;32m./menu.sh\033[0m to return to menu"
    elif [ "${1}" = "DS1520+K" ]; then
        TARGET_REVISION="64551"
        TARGET_PLATFORM="ds1520p"
        ORIGIN_PLATFORM="geminilake"        
        SYNOMODEL="ds1520p_$TARGET_REVISION"                                                                                                                    
        sha256="f42ca1bd75e88154623dba5dbbd08bcf8a00936ab178885b24d4d8429b6fb0a4"

    elif [ "${1}" = "DS1621+K" ]; then
        TARGET_REVISION="64551"
        TARGET_PLATFORM="ds1621p"
        ORIGIN_PLATFORM="v1000"
        SYNOMODEL="ds1621p_$TARGET_REVISION"                                                                                                                   
        sha256="c18a720858eecfbab820b03d15f28ab9d21d7c022be289a208735869c5de84fb"

    elif [ "${1}" = "DS1621xs+K" ]; then
        TARGET_REVISION="64551"
        TARGET_PLATFORM="ds1621xsp"
        ORIGIN_PLATFORM="broadwellnk"        
        SYNOMODEL="ds1621xsp_$TARGET_REVISION"
        sha256="3556bd6ca5c1d6cab93bf1c5b011ef461a5b4353ba35c16b061ecf42bed2d492"

    elif [ "${1}" = "DS2422+K" ] ; then
        TARGET_REVISION="64551"
        TARGET_PLATFORM="ds2422p"
        ORIGIN_PLATFORM="v1000"
        SYNOMODEL="ds2422p_$TARGET_REVISION"                                                                                                                   
        sha256="07227bf230bd56ead2905d6e47bedb1a38f341a088d5b2c355db01be54457e7b"

    elif [ "${1}" = "DS3617xsK" ]; then                                                                                                                     
        TARGET_REVISION="64551"    
        TARGET_PLATFORM="ds3617xs"
        ORIGIN_PLATFORM="broadwell"
        SYNOMODEL="ds3617xs_$TARGET_REVISION"                                                                                                                  
        sha256="17785c8dab0cc2faf4c0ac3d6ddca3c38c782fc57586004182ae09e443410db4"
        
    elif [ "${1}" = "DS3622xs+K" ]; then
        TARGET_REVISION="64551"    
        TARGET_PLATFORM="ds3622xsp"
        ORIGIN_PLATFORM="broadwellnk"
        SYNOMODEL="ds3622xsp_$TARGET_REVISION"
        sha256="c20985c298af3906f8199cdb4d8b66a38f80c335496262956a774f81de50fb0a"

    elif [ "${1}" = "DS723+K" ]; then
        TARGET_REVISION="64551"    
        TARGET_PLATFORM="ds723p"
        ORIGIN_PLATFORM="r1000"
        SYNOMODEL="ds723p_$TARGET_REVISION"                                                                                                                    
        sha256="d1262257740f5c2e9c676f4642d772b8e556d7f1ab21b3df2254a12d97a314fd"

    elif [ "${1}" = "DS918+K" ]; then           
        TARGET_REVISION="64551"
        TARGET_PLATFORM="ds918p"
        ORIGIN_PLATFORM="apollolake"
        SYNOMODEL="ds918p_$TARGET_REVISION"                                                                                                                    
        sha256="13b7d6dfb371bbf9b75ffbefbad07d514e42aaeefb868796bf0990ce26744a83"      
        
    elif [ "${1}" = "DS920+K" ]; then
        TARGET_REVISION="64551"    
        TARGET_PLATFORM="ds920p"
        ORIGIN_PLATFORM="geminilake"
        SYNOMODEL="ds920p_$TARGET_REVISION"                                                                                                                    
        sha256="d5dc4f98cfbf9b8b9bf77c607a6f0acd2cc2a4ee0651bf50b12a79e3de74204b"
        
    elif [ "${1}" = "DS923+K" ]; then
        TARGET_REVISION="64551"    
        TARGET_PLATFORM="ds923p"
        ORIGIN_PLATFORM="r1000"
        SYNOMODEL="ds923p_$TARGET_REVISION"                                                                                                                    
        sha256="9e4e1d59c8cf1a8a96f7d2d00fa51a2c9b9a01ad2ec13a72b5bc1d0bd6723ee8"

    elif [ "${1}" = "DVA1622K" ]; then
        TARGET_REVISION="64551"    
        TARGET_PLATFORM="dva1622"
        ORIGIN_PLATFORM="geminilake"
        SYNOMODEL="dva1622_$TARGET_REVISION"                                                                                                                   
        sha256="8dac8f4d94961f602a34b3f6a4e5e14004166485c8f50016a3f9061ae0c126a8"
                
    elif [ "${1}" = "DVA3219K" ]; then
        TARGET_REVISION="64551"
        TARGET_PLATFORM="dva3219"
        ORIGIN_PLATFORM="denverton"        
        SYNOMODEL="dva3219_$TARGET_REVISION"                                                                                                                   
        sha256="d484a2b74ed59703fd6c407fd5898f096675cb97416ec52f0bbb44c3b6c3d02d"
        
    elif [ "${1}" = "DVA3221K" ]; then                                                                                                                      
        TARGET_REVISION="64551"    
        TARGET_PLATFORM="dva3221"
        ORIGIN_PLATFORM="denverton"
        SYNOMODEL="dva3221_$TARGET_REVISION"                                                                                                                   
        sha256="ca3483040c8cabab6774c83b0d09083876ead6a55d1697ece379d674f0c87f80"
                
    elif [ "${1}" = "FS2500K" ]; then
        TARGET_REVISION="64551"
        TARGET_PLATFORM="fs2500"
        ORIGIN_PLATFORM="v1000"        
        SYNOMODEL="fs2500_$TARGET_REVISION"                                                                                                                    
        sha256="a871d5d35ba110c315c5a73a665de2178a620a617ac096beab1d0812b7be8741"
        
    elif [ "${1}" = "RS3618xsK" ]; then                                                                                                                     
        TARGET_REVISION="64551"
        TARGET_PLATFORM="rs3618xs"
        ORIGIN_PLATFORM="broadwell"
        SYNOMODEL="rs3618xs_$TARGET_REVISION"                                                                                                                  
        sha256="63b41dd4940e81c933b3493dd648fcaa750a165b6dbd9fcee96ee87acad4bbab"
        
    elif [ "${1}" = "RS4021xs+K" ]; then
        TARGET_REVISION="64551"
        TARGET_PLATFORM="rs4021xsp"
        ORIGIN_PLATFORM="broadwellnk"        
        SYNOMODEL="rs4021xsp_$TARGET_REVISION"
        sha256="c233ee6e90fd9b4d9c86e8d779f18859becff2d2423516e46b7d9a2a10f6938c"

    elif [ "${1}" = "DS720+K" ]; then
        TARGET_REVISION="64551"
        TARGET_PLATFORM="ds720p"
        ORIGIN_PLATFORM="geminilake"
        SYNOMODEL="ds720p_$TARGET_REVISION"                                                                                                                    
        sha256="65750f46ebb3e829e1d9f27cfcc7f3508ae7efb9c35f8f123533d907bbaa5f8f"

    elif [ "${1}" = "RS1221+K" ]; then
        TARGET_REVISION="64551"
        TARGET_PLATFORM="rs1221p"
        ORIGIN_PLATFORM="v1000"        
        SYNOMODEL="rs1221p_$TARGET_REVISION"                                                                                                                    
        sha256="a3cbff0146eecb0f44f6dad53172986e5e4fdd256be5a00b606eecefd08710a6"

    elif [ "${1}" = "RS3621xs+K" ]; then
        TARGET_REVISION="64551"
        TARGET_PLATFORM="rs3621xsp"
        ORIGIN_PLATFORM="broadwellnk"        
        SYNOMODEL="rs3621xsp_$TARGET_REVISION"
        sha256="d26a3397824f8baea79927924a2033f3d1a034486cfffac26fdd3d690224fa47"

    elif [ "${1}" = "SA6400K" ]; then
        TARGET_REVISION="64551"        
        TARGET_PLATFORM="sa6400"
        ORIGIN_PLATFORM="epyc7002"        
        SYNOMODEL="sa6400_$TARGET_REVISION"
        sha256="1ef25a47a1007382f7a3c6e740427ecaca50efa99e77308f076202fdffdad2cb"
        
#JUN MODE
    elif [ "${1}" = "DS918+J" ]; then           
        TARGET_REVISION="42218"
        TARGET_PLATFORM="ds918p"
        ORIGIN_PLATFORM="apollolake"
        SYNOMODEL="ds918p_$TARGET_REVISION"                                                                                                                    
        sha256="a662d11999c266dfa86c54f7ba01045c6644c191124195a22d056d618790dffe"                                                                              
    elif [ "${1}" = "DS3615xsJ" ]; then
        TARGET_REVISION="42218"               
        TARGET_PLATFORM="ds3615xs"
        ORIGIN_PLATFORM="bromolow"
        SYNOMODEL="ds3615xs_$TARGET_REVISION"                                   
        sha256="ae1aca3b178a00689b93e97cca680b56af3f453174b852e0047496120dee2ee3"                             
    elif [ "${1}" = "DS3617xsJ" ]; then
        TARGET_REVISION="42218"               
        TARGET_PLATFORM="ds3617xs"
        ORIGIN_PLATFORM="broadwell"
        SYNOMODEL="ds3617xs_$TARGET_REVISION" 
        sha256="f7e846e2a22b62613ac5e9d6e154df0213ba4ae64a6556297af627cd1e643e5c"
    elif [ "${1}" = "DS3622xs+J" ]; then
        TARGET_REVISION="42218"               
        TARGET_PLATFORM="ds3622xsp"
        ORIGIN_PLATFORM="broadwellnk"
        SYNOMODEL="ds3622xsp_$TARGET_REVISION"
        sha256="a222d37f369d71042057ccb592f40c7c81e9b988a95d69fa166c7c2a611da99c"
    elif [ "${1}" = "DS1621+J" ]; then
        TARGET_REVISION="42218"                                                  
        TARGET_PLATFORM="ds1621p"
        ORIGIN_PLATFORM="v1000"
        SYNOMODEL="ds1621p_$TARGET_REVISION"                                     
        sha256="396144fdcd94d441b4ad665099395cf24a14606742bee9438745ea30bf12b9ef"
    elif [ "${1}" = "DVA3221J" ]; then
        TARGET_REVISION="42218"                                                  
        TARGET_PLATFORM="dva3221"
        ORIGIN_PLATFORM="denverton"
        SYNOMODEL="dva3221_$TARGET_REVISION"                                     
        sha256="6722c73c51070dde2f542659d7728c497fc846256da2c9cf017177476de0bb09"
    elif [ "${1}" = "DS920+J" ]; then
        TARGET_REVISION="42218"
        TARGET_PLATFORM="ds920p"
        ORIGIN_PLATFORM="geminilake"
        SYNOMODEL="ds920p_$TARGET_REVISION"                                                                                                                    
        sha256="b9b77846e0983f50496276bec6bcdfcfadd4c1f9f0db8ed2ca5766f131ddf97f"
    elif [ "${1}" = "DS2422+J" ]; then
        TARGET_REVISION="42218"                                                  
        TARGET_PLATFORM="ds2422p"
        ORIGIN_PLATFORM="v1000"        
        SYNOMODEL="ds2422p_$TARGET_REVISION"                                     
        sha256="5a6cfbc690facdfaef9fbcc55215eac38c73ca6a85965a910af11cede5e2cd5d"
        
# JUN MODE NEW MODEL SUCCESS
    elif [ "${1}" = "DS1520+J" ]; then
        TARGET_REVISION="42218"
        TARGET_PLATFORM="ds1520p"
        ORIGIN_PLATFORM="geminilake"        
        SYNOMODEL="ds1520p_$TARGET_REVISION"                                                                                                                    
        sha256="b8864e2becd8ce5a6083db993564c8c0b982df8300a006b56695a0495a670aa3"
    elif [ "${1}" = "DS1621xs+J" ]; then
        TARGET_REVISION="42218"               
        TARGET_PLATFORM="ds1621xsp"
        ORIGIN_PLATFORM="broadwellnk"        
        SYNOMODEL="ds1621xsp_$TARGET_REVISION"
        sha256="12bcfd44b4aaa6c3439b1404b7f07760373d816724ef672884d5187f27ccd70f"
    elif [ "${1}" = "FS2500J" ]; then
        TARGET_REVISION="42218"
        TARGET_PLATFORM="fs2500"
        ORIGIN_PLATFORM="v1000"        
        SYNOMODEL="fs2500_$TARGET_REVISION"                                                                                                                    
        sha256="3fbd5defbc0fef0d152494033f3e817c330525b70e356a9e9acd2b72d9806b59"
    elif [ "${1}" = "RS4021xs+J" ]; then
        TARGET_REVISION="42218"               
        TARGET_PLATFORM="rs4021xsp"
        ORIGIN_PLATFORM="broadwellnk"        
        SYNOMODEL="rs4021xsp_$TARGET_REVISION"
        sha256="2a32266b7bcf0b2582b5afd9e39dc444e7cb40eaf4ccfdbfedf4743af821f11c"
    elif [ "${1}" = "RS3618xsJ" ]; then                                                                                                                     
        TARGET_REVISION="42218"        
        TARGET_PLATFORM="rs3618xs"
        ORIGIN_PLATFORM="broadwell"
        SYNOMODEL="rs3618xs_$TARGET_REVISION"                                                                                                                  
        sha256="941886bee9a0929c6bd078c5f2c465d9599721fc885a1e3835d6b60631f419af"
    elif [ "${1}" = "DS1019+J" ]; then
        TARGET_REVISION="42218"                                                                                                                                
        TARGET_PLATFORM="ds1019p"
        ORIGIN_PLATFORM="apollolake"
        SYNOMODEL="ds1019p_$TARGET_REVISION"                                                                                                                    
        sha256="e782ad4ce5e0505e7981a5a3fa7ca986a4575240f645ec2c64f92def1774556f"         
    elif [ "${1}" = "DVA3219J" ]; then
        TARGET_REVISION="42218"                                                  
        TARGET_PLATFORM="dva3219"
        ORIGIN_PLATFORM="denverton"        
        SYNOMODEL="dva3219_$TARGET_REVISION"                                     
        sha256="b3498a20aeb7c7c36deca0f4393172d4db7b51aa4fb87eaace83fe224d935e3b"

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
        TARGET_PLATFORM="ds1019p"
        ORIGIN_PLATFORM="apollolake"
        SYNOMODEL="ds1019p_$TARGET_REVISION"                                                                                                                    
        sha256="08cddab3f256091ec33f6d07ad320ee5c6d2264eab66add071f8119fc389931a"
        
    elif [ "${1}" = "DS1520+G" ]; then
        TARGET_REVISION="64570"
        TARGET_PLATFORM="ds1520p"
        ORIGIN_PLATFORM="geminilake"        
        SYNOMODEL="ds1520p_$TARGET_REVISION"                                                                                                                    
        sha256="49455e77b7c8a05492b08a0558bb13108cf6c628f06eee65b5861c653a8b31af"

    elif [ "${1}" = "DS1621+G" ]; then
        TARGET_REVISION="64570"
        TARGET_PLATFORM="ds1621p"
        ORIGIN_PLATFORM="v1000"
        SYNOMODEL="ds1621p_$TARGET_REVISION"                                                                                                                   
        sha256="21cd3941aab30bf035006fd48242b28f3bb3d487f505cda72fc261d3ddad440e"

    elif [ "${1}" = "DS1621xs+G" ]; then
        TARGET_REVISION="64570"
        TARGET_PLATFORM="ds1621xsp"
        ORIGIN_PLATFORM="broadwellnk"        
        SYNOMODEL="ds1621xsp_$TARGET_REVISION"
        sha256="3084e68333821ea14b3f6a2b4f0efce426359fb07aafb12cc6a48de150455829"

    elif [ "${1}" = "DS2422+G" ] ; then
        TARGET_REVISION="64570"
        TARGET_PLATFORM="ds2422p"
        ORIGIN_PLATFORM="v1000"
        SYNOMODEL="ds2422p_$TARGET_REVISION"                                                                                                                   
        sha256="3d5b4ff6e7d54710cc48914684a6fd0d489a1ab62a8ec7a3e999f057f06bfceb"

    elif [ "${1}" = "DS3617xsG" ]; then                                                                                                                     
        TARGET_REVISION="64570"    
        TARGET_PLATFORM="ds3617xs"
        ORIGIN_PLATFORM="broadwell"
        SYNOMODEL="ds3617xs_$TARGET_REVISION"                                                                                                                  
        sha256="f8ddc1f0218b41ddbe345eaf5eaa4392b3744ab5893eddad799e42b014100158"
        
    elif [ "${1}" = "DS3622xs+G" ]; then
        TARGET_REVISION="64570"    
        TARGET_PLATFORM="ds3622xsp"
        ORIGIN_PLATFORM="broadwellnk"
        SYNOMODEL="ds3622xsp_$TARGET_REVISION"
        sha256="b96f85f058a8f5144f73cbfabf89982868cbfc625d05e65e65d230e2b7f09c47"

    elif [ "${1}" = "DS720+G" ]; then
        TARGET_REVISION="64570"
        TARGET_PLATFORM="ds720p"
        ORIGIN_PLATFORM="geminilake"
        SYNOMODEL="ds720p_$TARGET_REVISION"                                                                                                                    
        sha256="7fbb1e166459f00c6b08258d9913a9fb437470e08c4f8e6f9becc850f93b88ac"

    elif [ "${1}" = "DS723+G" ]; then
        TARGET_REVISION="64570"    
        TARGET_PLATFORM="ds723p"
        ORIGIN_PLATFORM="r1000"
        SYNOMODEL="ds723p_$TARGET_REVISION"                                                                                                                    
        sha256="543b9d6b23cb42b306e62f1e9b286888c66284e25f3505b81c8b25e827e49da3"

    elif [ "${1}" = "DS916+G" ]; then           
        TARGET_REVISION="64570"
        TARGET_PLATFORM="ds916p"
        ORIGIN_PLATFORM="braswell"
        SYNOMODEL="ds916p_$TARGET_REVISION"                                                                                                                    
        sha256="0c4a8e7db8dfce88634b175670ba21b9107e0e5600cdb5154afc5cd77acaca33"      

    elif [ "${1}" = "DS918+G" ]; then           
        TARGET_REVISION="64570"
        TARGET_PLATFORM="ds918p"
        ORIGIN_PLATFORM="apollolake"
        SYNOMODEL="ds918p_$TARGET_REVISION"                                                                                                                    
        sha256="18baccf23ac8f860f96d4accbe0bfc8fd27f60966ff31a5e4a71a452c4c4ec61"      
        
    elif [ "${1}" = "DS920+G" ]; then
        TARGET_REVISION="64570"    
        TARGET_PLATFORM="ds920p"
        ORIGIN_PLATFORM="geminilake"
        SYNOMODEL="ds920p_$TARGET_REVISION"                                                                                                                    
        sha256="047654b35e9f464b367ddbbac280ea355e1548c6e314fe538e5d6b2752e627ad"
        
    elif [ "${1}" = "DS923+G" ]; then
        TARGET_REVISION="64570"    
        TARGET_PLATFORM="ds923p"
        ORIGIN_PLATFORM="r1000"
        SYNOMODEL="ds923p_$TARGET_REVISION"                                                                                                                    
        sha256="3165233b48d1958090ef86d63361f850b8165aae86540915d89f9621f6f17fec"

    elif [ "${1}" = "DVA1622G" ]; then
        TARGET_REVISION="64570"    
        TARGET_PLATFORM="dva1622"
        ORIGIN_PLATFORM="geminilake"
        SYNOMODEL="dva1622_$TARGET_REVISION"                                                                                                                   
        sha256="ae4cc66e95f71e89e458a75784131ec8bccfab1a87eecd70fbdc11b563252021"
                
    elif [ "${1}" = "DVA3219G" ]; then
        TARGET_REVISION="64570"
        TARGET_PLATFORM="dva3219"
        ORIGIN_PLATFORM="denverton"        
        SYNOMODEL="dva3219_$TARGET_REVISION"                                                                                                                   
        sha256="6381b31ff852c487dc5bc093e86887f1155427571b6e2511bc08ae8de031d793"
        
    elif [ "${1}" = "DVA3221G" ]; then                                                                                                                      
        TARGET_REVISION="64570"    
        TARGET_PLATFORM="dva3221"
        ORIGIN_PLATFORM="denverton"
        SYNOMODEL="dva3221_$TARGET_REVISION"                                                                                                                   
        sha256="5990e460da1268fb06037ab99bdf5ea886ca5e7c6d6cf4e31c04e7888b2647d1"
                
    elif [ "${1}" = "FS2500G" ]; then
        TARGET_REVISION="64570"
        TARGET_PLATFORM="fs2500"
        ORIGIN_PLATFORM="v1000"        
        SYNOMODEL="fs2500_$TARGET_REVISION"                                                                                                                    
        sha256="b4b239338c660f35cdd70b0edcfa24967c28d9651382b182307ffa3c305d6897"
    elif [ "${1}" = "RS1221+G" ]; then
        TARGET_REVISION="64570"
        TARGET_PLATFORM="rs1221p"
        ORIGIN_PLATFORM="v1000"        
        SYNOMODEL="rs1221p_$TARGET_REVISION"                                                                                                                    
        sha256="6a6b461dbbb6f96ab90c5972f5e646fac19346917fe482ddc14bfa4f2b41db93"
       
    elif [ "${1}" = "RS3618xsG" ]; then                                                                                                                     
        TARGET_REVISION="64570"
        TARGET_PLATFORM="rs3618xs"
        ORIGIN_PLATFORM="broadwell"
        SYNOMODEL="rs3618xs_$TARGET_REVISION"                                                                                                                  
        sha256="c63091a6eb7b50d759b3ee4fcd641566857fb5c11ed6084ea5d038eb5d575cdb"

    elif [ "${1}" = "RS3621xs+G" ]; then
        TARGET_REVISION="64570"
        TARGET_PLATFORM="rs3621xsp"
        ORIGIN_PLATFORM="broadwellnk"        
        SYNOMODEL="rs3621xsp_$TARGET_REVISION"
        sha256="71c22296d6248730bf88db2778a122b958febacb8ae686adb6610ff8ef520575"
       
    elif [ "${1}" = "RS4021xs+G" ]; then
        TARGET_REVISION="64570"
        TARGET_PLATFORM="rs4021xsp"
        ORIGIN_PLATFORM="broadwellnk"        
        SYNOMODEL="rs4021xsp_$TARGET_REVISION"
        sha256="95a9310ad8ad319dbd0462f7a1ae12d403d6fb2d1e64664857d337356ba10afd"

    elif [ "${1}" = "SA6400G" ]; then
        TARGET_REVISION="64570"        
        TARGET_PLATFORM="sa6400"
        ORIGIN_PLATFORM="epyc7002"        
        SYNOMODEL="sa6400_$TARGET_REVISION"
        sha256="6123f757507edb67c3b03909a30f1c539947af4e1789c6d02b87ace46fddcfdc"
       
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

    if [ "$MODEL" = "SA6400" ]; then    
        KVER="5.10.55"
    elif [ "$MODEL" = "DS3615xs" ]||[ "$MODEL" = "DS916+" ]; then
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
