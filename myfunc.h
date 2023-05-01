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


function showlastupdate() {
    cat <<EOF

# Update : Release TCRP FRIEND mode
# 2022.09.25

# Update : Inspection of FMA3 command support (Haswell or higher) and model restriction function added to menu.sh
# 2023.02.22

# Update :  menu.sh Added new function DDSML / EUDEV selection
#           DDSML ( Detected Device Static Module Loading with modprobe / insmod command )
#           EUDEV (Enhanced Userspace Device with eudev deamon)
# 2023.03.01

# Update : Improved TCRP loader build process
# 2023.03.14

# Update : AMD CPU FRIEND mode menu usage restriction release (except HP N36L/N40L/N54L)
# 2023.03.18

# Update : Multilingual menu support started (Korean, Chinese, Japanese, Russian, French, German, Spanish, Brazilian, Italian supported)
# 2023.03.25

# Update : Keymap now actually works. (Thanks Orphée)
# 2023.04.29

# Update : Add Postupdate boot entry to Grub Boot for Jot Postupdate to utilize FRIEND's Ramdisk Update
# 2023.05.01

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

./$(basename ${0}) DS918+F
./$(basename ${0}) DS3617xsF                                                                                                    
./$(basename ${0}) DS3615xsF
./$(basename ${0}) DS3622xs+F                                                                                                   
./$(basename ${0}) DVA3221F                                                                                                     
./$(basename ${0}) DS920+F                                                                                                      
./$(basename ${0}) DS1621+F 
./$(basename ${0}) DS2422+F  
./$(basename ${0}) DVA1622F
./$(basename ${0}) DS1520+F
./$(basename ${0}) FS2500F
./$(basename ${0}) DS1621xs+F
./$(basename ${0}) RS4021xs+F 
./$(basename ${0}) DVA3219F
./$(basename ${0}) RS3618xsF
./$(basename ${0}) RS3413xs+F (Not Suppoted, Testing...)
./$(basename ${0}) DS1019+F
./$(basename ${0}) DS923+F
./$(basename ${0}) DS723+F

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
    MSHELL_ONLY_MODEL="N"
    DTC_BASE_MODEL="N"
    ORIGIN_PLATFORM=""

# JOT / FRIEND MODE
    if [ "${1}" = "DS918+" ] || [ "${1}" = "DS918+F" ]; then        
        DTC_BASE_MODEL="N"
        TARGET_PLATFORM="ds918p"
        ORIGIN_PLATFORM="apollolake"
        SYNOMODEL="ds918p_$TARGET_REVISION"                                                                                                                    
        sha256="9905e145f3bd88fcc938b00882be10281861867e5165ae98aefa37be0d5d34b5"
        SUVP="-1"
    elif [ "${1}" = "DS3615xs" ] || [ "${1}" = "DS3615xsF" ]; then                                                                                                                     
        DTC_BASE_MODEL="N"    
        TARGET_PLATFORM="ds3615xs"
        ORIGIN_PLATFORM="bromolow"
        SYNOMODEL="ds3615xs_$TARGET_REVISION"                                                                                                                  
        sha256="f01a17d73e2594b0b31f134bfe023dccc0bb9389a462f9918080573134093023"
        SUVP="-1"
    elif [ "${1}" = "DS3617xs" ] || [ "${1}" = "DS3617xsF" ]; then                                                                                                                     
        DTC_BASE_MODEL="N"    
        TARGET_PLATFORM="ds3617xs"
        ORIGIN_PLATFORM="broadwell"
        SYNOMODEL="ds3617xs_$TARGET_REVISION"                                                                                                                  
        sha256="1b72bb24dc9d10d3784298e6df9d79a8f8c3555087e0de12f3359ce373f4e7c9"
        SUVP="-1"
    elif [ "${1}" = "DS3622xs+" ] || [ "${1}" = "DS3622xs+F" ]; then
        DTC_BASE_MODEL="N"    
        TARGET_PLATFORM="ds3622xsp"
        ORIGIN_PLATFORM="broadwellnk"
        SYNOMODEL="ds3622xsp_$TARGET_REVISION"
        sha256="775933e32a9e04700fc10a155f5a26c0878c3cdec18b6ec6b1d5a4110e83d428"
        SUVP="-1"
    elif [ "${1}" = "DS1621+" ] || [ "${1}" = "DS1621+F" ]; then
        DTC_BASE_MODEL="Y"    
        TARGET_PLATFORM="ds1621p"
        ORIGIN_PLATFORM="v1000"
        SYNOMODEL="ds1621p_$TARGET_REVISION"                                                                                                                   
        sha256="41a4b80ef58f3ff5ee924329ff59bd4ac0abb7676561847a84e98bc6bb225003"
        SUVP="-1"
    elif [ "${1}" = "DVA3221" ] || [ "${1}" = "DVA3221F" ]; then                                                                                                                      
        DTC_BASE_MODEL="N"    
        TARGET_PLATFORM="dva3221"
        ORIGIN_PLATFORM="denverton"
        SYNOMODEL="dva3221_$TARGET_REVISION"                                                                                                                   
        sha256="7bd2fe270bc665cc859142b7c6462fe8137f047c4fbe2f87ed3d03c30c514766"
        SUVP="-1"        
    elif [ "${1}" = "DVA1622" ] || [ "${1}" = "DVA1622F" ]; then
        DTC_BASE_MODEL="Y"    
        TARGET_PLATFORM="dva1622"
        ORIGIN_PLATFORM="geminilake"
        SYNOMODEL="dva1622_$TARGET_REVISION"                                                                                                                   
        sha256="ebebc3f1de22b789b386f1d52fbe0be3fcca23f83e0d34ed9c24e794701b4c3d"
        SUVP="-1"        
    elif [ "${1}" = "DS920+" ] || [ "${1}" = "DS920+F" ]; then
        DTC_BASE_MODEL="Y"    
        TARGET_PLATFORM="ds920p"
        ORIGIN_PLATFORM="geminilake"
        SYNOMODEL="ds920p_$TARGET_REVISION"                                                                                                                    
        sha256="f58c15d4d83699884c30e4a4b04b1d2e0db19c477923d920327a897a73c741b6"
        SUVP="-1"
    elif [ "${1}" = "DS923+" ] || [ "${1}" = "DS923+F" ]; then
        DTC_BASE_MODEL="Y"    
        TARGET_PLATFORM="ds923p"
        ORIGIN_PLATFORM="r1000"
        SYNOMODEL="ds923p_$TARGET_REVISION"                                                                                                                    
        sha256="8fe1232e26661dd9e6db2a8e132bd8869b23b2887d77d298cd8e0b7cb2f9e2d6"
        SUVP="-5"
    elif [ "${1}" = "DS723+" ] || [ "${1}" = "DS723+F" ]; then
        DTC_BASE_MODEL="Y"    
        TARGET_PLATFORM="ds723p"
        ORIGIN_PLATFORM="r1000"
        SYNOMODEL="ds723p_$TARGET_REVISION"                                                                                                                    
        sha256="633a626f3dc31338eb41ca929d8f9927a7a63f646067372d02ac045aa768560f"
        SUVP="-5"

# JOT / FRIEND MODE NEW MODEL SUCCESS
    elif [ "${1}" = "DS2422+" ] || [ "${1}" = "DS2422+F" ] ; then
        DTC_BASE_MODEL="Y"    
        MSHELL_ONLY_MODEL="Y"                
        TARGET_PLATFORM="ds2422p"
        ORIGIN_PLATFORM="v1000"
        SYNOMODEL="ds2422p_$TARGET_REVISION"                                                                                                                   
        sha256="69f02c4636ff2593e5feb393e13ed82791fa6457d61874368a0b6f93ee11f164"
        SUVP="-1"
    elif [ "${1}" = "DS1621xs+" ] || [ "${1}" = "DS1621xs+F" ]; then
        DTC_BASE_MODEL="N"    
        MSHELL_ONLY_MODEL="Y"    
        TARGET_PLATFORM="ds1621xsp"
        ORIGIN_PLATFORM="broadwellnk"        
        SYNOMODEL="ds1621xsp_$TARGET_REVISION"
        sha256="d2272ab531f0f68f8008106dd75b4e303c71db8d95093d186a22c1cf2d970402"
        SUVP="-1"
    elif [ "${1}" = "RS4021xs+" ] || [ "${1}" = "RS4021xs+F" ]; then
        DTC_BASE_MODEL="N"    
        MSHELL_ONLY_MODEL="Y"    
        TARGET_PLATFORM="rs4021xsp"
        ORIGIN_PLATFORM="broadwellnk"        
        SYNOMODEL="rs4021xsp_$TARGET_REVISION"
        sha256="e2ddf670e54fe6b2b52b19125430dc82394df2722afd4f62128b95a63459ee3d"
        SUVP="-5"
    elif [ "${1}" = "SA3600" ] || [ "${1}" = "SA3600F" ]; then
        DTC_BASE_MODEL="N"
        MSHELL_ONLY_MODEL="Y"    
        TARGET_PLATFORM="sa3600"
        ORIGIN_PLATFORM="broadwellnk"        
        SYNOMODEL="sa3600_$TARGET_REVISION"
        sha256="d4d6fcd5bb3b3c005f2fb199af90cb7f62162d9112127d06ebf5973aa645e0f8"
    elif [ "${1}" = "DVA3219" ] || [ "${1}" = "DVA3219F" ]; then
        DTC_BASE_MODEL="N"    
        MSHELL_ONLY_MODEL="Y"    
        TARGET_PLATFORM="dva3219"
        ORIGIN_PLATFORM="denverton"        
        SYNOMODEL="dva3219_$TARGET_REVISION"                                                                                                                   
        sha256="9f8c6095235df2e2caebadf846f11e4244af6f1aada9a7dd5c2c60543f944aac"
        SUVP="-1"
    elif [ "${1}" = "FS2500" ] || [ "${1}" = "FS2500F" ]; then
        DTC_BASE_MODEL="Y"    
        MSHELL_ONLY_MODEL="Y"    
        TARGET_PLATFORM="fs2500"
        ORIGIN_PLATFORM="v1000"        
        SYNOMODEL="fs2500_$TARGET_REVISION"                                                                                                                    
        sha256="e74ff783b5ca6fbdec1a0eb950b366b74b27c0288fb72baaf86db8a31d68b985"
        SUVP="-1"
    elif [ "${1}" = "RS3618xs" ] || [ "${1}" = "RS3618xsF" ]; then                                                                                                                     
        DTC_BASE_MODEL="N"    
        MSHELL_ONLY_MODEL="Y"        
        TARGET_PLATFORM="rs3618xs"
        ORIGIN_PLATFORM="broadwell"
        SYNOMODEL="rs3618xs_$TARGET_REVISION"                                                                                                                  
        sha256="2851af89ca0ec287ff47ab265412b67c4fba5848cedb51486a8f6ed2baca3062"
        SUVP="-1"
    elif [ "${1}" = "DS1019+" ] || [ "${1}" = "DS1019+F" ]; then        
        DTC_BASE_MODEL="N"
        TARGET_PLATFORM="ds1019p"
        ORIGIN_PLATFORM="apollolake"
        SYNOMODEL="ds1019p_$TARGET_REVISION"                                                                                                                    
        sha256="af2268388df9434679205ffd782ae5c17cd81d733cdcd94b13fc894748ffe321"
        SUVP="-1"
    elif [ "${1}" = "DS1520+" ] || [ "${1}" = "DS1520+F" ]; then
        DTC_BASE_MODEL="Y"    
        MSHELL_ONLY_MODEL="Y"    
        TARGET_PLATFORM="ds1520p"
        ORIGIN_PLATFORM="geminilake"        
        SYNOMODEL="ds1520p_$TARGET_REVISION"                                                                                                                    
        sha256="edcacbab10b77e2a6862d31173f5369c6e3c1720b8f0ec4fd41786609017c39b"
        SUVP="-1"
        
# JOT MODE NEW MODEL TESTTING                
    elif [ "${1}" = "RS3413xs+" ] || [ "${1}" = "RS3413xs+F" ]; then
        echo "Synology model ${1} jot mode not supported by m shell, Testing..."        
        exit 0        
    
        DTC_BASE_MODEL="N"    
        MSHELL_ONLY_MODEL="Y"    
        TARGET_PLATFORM="rs3413xsp"
        ORIGIN_PLATFORM="bromolow"        
        SYNOMODEL="rs3413xsp_$TARGET_REVISION"
        sha256="de2425d55667a1c67763aeea1155bc6e336fb419148bb70f1ae1243d914d34ff"

#DSM 7.2
    elif [ "${1}" = "DS918+K" ]; then           
        DTC_BASE_MODEL="N"    
        TARGET_REVISION="64551"                                                                                                                                
        TARGET_PLATFORM="ds918p"
        ORIGIN_PLATFORM="apollolake"
        SYNOMODEL="ds918p_$TARGET_REVISION"                                                                                                                    
        sha256="13b7d6dfb371bbf9b75ffbefbad07d514e42aaeefb868796bf0990ce26744a83"                                                                              

#JUN MODE
    elif [ "${1}" = "DS918+J" ]; then           
        DTC_BASE_MODEL="N"    
        TARGET_REVISION="42218"
        TARGET_PLATFORM="ds918p"
        ORIGIN_PLATFORM="apollolake"
        SYNOMODEL="ds918p_$TARGET_REVISION"                                                                                                                    
        sha256="a662d11999c266dfa86c54f7ba01045c6644c191124195a22d056d618790dffe"                                                                              
#    elif [ "${1}" = "DS3615xsJ" ]; then
#        DTC_BASE_MODEL="N"    
#        TARGET_REVISION="42218"               
#        TARGET_PLATFORM="ds3615xs"
#        ORIGIN_PLATFORM="bromolow"
#        SYNOMODEL="ds3615xs_$TARGET_REVISION"                                   
#        sha256="dddd26891815ddca02d0d53c1d42e8b39058b398a4cc7b49b80c99f851cf0ef7"                             
#    elif [ "${1}" = "DS3617xsJ" ]; then
#        DTC_BASE_MODEL="N"    
#        TARGET_REVISION="42218"               
#        TARGET_PLATFORM="ds3617xs"
#        ORIGIN_PLATFORM="broadwell"
#        SYNOMODEL="ds3617xs_$TARGET_REVISION" 
#        sha256="d65ee4ed5971e38f6cdab00e1548183435b53ba49a5dca7eaed6f56be939dcd2"
#    elif [ "${1}" = "DS3622xs+J" ]; then
#        DTC_BASE_MODEL="N"    
#        TARGET_REVISION="42218"               
#        TARGET_PLATFORM="ds3622xsp"
#        ORIGIN_PLATFORM="broadwellnk"
#        SYNOMODEL="ds3622xsp_$TARGET_REVISION"
#        sha256="f38329b8cdc5824a8f01fb1e377d3b1b6bd23da365142a01e2158beff5b8a424"
#    elif [ "${1}" = "DS1621+J" ]; then
#        DTC_BASE_MODEL="Y"    
#        TARGET_REVISION="42218"                                                  
#        TARGET_PLATFORM="ds1621p"
#        ORIGIN_PLATFORM="v1000"
#        SYNOMODEL="ds1621p_$TARGET_REVISION"                                     
#        sha256="19f56827ba8bf0397d42cd1d6f83c447f092c2c1bbb70d8a2ad3fbd427e866df"
#    elif [ "${1}" = "DVA3221J" ]; then
#        DTC_BASE_MODEL="N"    
#        TARGET_REVISION="42218"                                                  
#        TARGET_PLATFORM="dva3221"
#        ORIGIN_PLATFORM="denverton"
#        SYNOMODEL="dva3221_$TARGET_REVISION"                                     
#        sha256="01f101d7b310c857e54b0177068fb7250ff722dc9fa2472b1a48607ba40897ee"
    elif [ "${1}" = "DS920+J" ]; then
        DTC_BASE_MODEL="Y"    
        TARGET_REVISION="42218"
        TARGET_PLATFORM="ds920p"
        ORIGIN_PLATFORM="geminilake"
        SYNOMODEL="ds920p_$TARGET_REVISION"                                                                                                                    
        sha256="b9b77846e0983f50496276bec6bcdfcfadd4c1f9f0db8ed2ca5766f131ddf97f"
#    elif [ "${1}" = "DS2422+J" ]; then
#        DTC_BASE_MODEL="Y"    
#        TARGET_REVISION="42218"                                                  
#        TARGET_PLATFORM="ds2422p"
#        ORIGIN_PLATFORM="v1000"        
#        SYNOMODEL="ds2422p_$TARGET_REVISION"                                     
#        sha256="415c54934d483a2557500bc3a2e74588a0cec1266e1f0d9a82a7d3aace002471"
        
# JUN MODE NEW MODEL SUCCESS
    elif [ "${1}" = "DS1520+J" ]; then
        DTC_BASE_MODEL="Y"    
        MSHELL_ONLY_MODEL="Y"    
        TARGET_REVISION="42218"
        TARGET_PLATFORM="ds1520p"
        ORIGIN_PLATFORM="geminilake"        
        SYNOMODEL="ds1520p_$TARGET_REVISION"                                                                                                                    
        sha256="b8864e2becd8ce5a6083db993564c8c0b982df8300a006b56695a0495a670aa3"
#    elif [ "${1}" = "DS1621xs+J" ]; then
#        DTC_BASE_MODEL="N"    
#        MSHELL_ONLY_MODEL="Y"    
#        TARGET_REVISION="42218"               
#        TARGET_PLATFORM="ds1621xsp"
#        ORIGIN_PLATFORM="broadwellnk"        
#        SYNOMODEL="ds1621xsp_$TARGET_REVISION"
#        sha256="5db4e5943d246b1a2414942ae19267adc94d2a6ab167ba3e2fc10b42aefded23"
#    elif [ "${1}" = "FS2500J" ]; then
#        DTC_BASE_MODEL="Y"    
#        MSHELL_ONLY_MODEL="Y"    
#        TARGET_REVISION="42218"
#        TARGET_PLATFORM="fs2500"
#        ORIGIN_PLATFORM="v1000"        
#        SYNOMODEL="fs2500_$TARGET_REVISION"                                                                                                                    
#        sha256="4d060be8afec548fdb042bc8095524f10ff200033cab74df37ae07f3de5eaa69"
#    elif [ "${1}" = "RS4021xs+J" ]; then
#        DTC_BASE_MODEL="N"    
#        MSHELL_ONLY_MODEL="Y"    
#        TARGET_REVISION="42218"               
#        TARGET_PLATFORM="rs4021xsp"
#        ORIGIN_PLATFORM="broadwellnk"        
#        SYNOMODEL="rs4021xsp_$TARGET_REVISION"
#        sha256="7afca3970ac7324d7431c1484d4249939bedd4c18ac34187f894c43119edf3a1"
#    elif [ "${1}" = "RS3618xsJ" ]; then                                                                                                                     
#        DTC_BASE_MODEL="N"    
#        MSHELL_ONLY_MODEL="Y"
#        TARGET_REVISION="42218"        
#        TARGET_PLATFORM="rs3618xs"
#        ORIGIN_PLATFORM="broadwell"
#        SYNOMODEL="rs3618xs_$TARGET_REVISION"                                                                                                                  
#        sha256="2b7623a6781fe10e0eface1665d41dfe2e5adb033b26e50e27c3449aee5fe4b0"
    elif [ "${1}" = "DS1019+J" ]; then
        DTC_BASE_MODEL="N"
        MSHELL_ONLY_MODEL="Y"        
        TARGET_REVISION="42218"                                                                                                                                
        TARGET_PLATFORM="ds1019p"
        ORIGIN_PLATFORM="apollolake"
        SYNOMODEL="ds1019p_$TARGET_REVISION"                                                                                                                    
        sha256="e782ad4ce5e0505e7981a5a3fa7ca986a4575240f645ec2c64f92def1774556f"         
#    elif [ "${1}" = "DVA3219J" ]; then
#        DTC_BASE_MODEL="N"    
#        MSHELL_ONLY_MODEL="Y"    
#        TARGET_REVISION="42218"                                                  
#        TARGET_PLATFORM="dva3219"
#        ORIGIN_PLATFORM="denverton"        
#        SYNOMODEL="dva3219_$TARGET_REVISION"                                     
#        sha256="3557df23ff6af9bbb0cf46872ba2fc09c344eb303a38e8283dbc9a46e5eae979"

# JUN MODE NEW MODEL TESTTING
#    elif [ "${1}" = "RS3413xs+J" ]; then
#        echo "Synology model ${1} jun mode not supported by m shell, Testing..."
#        exit 0        
#        
#        DTC_BASE_MODEL="N"    
#        MSHELL_ONLY_MODEL="Y"    
#        TARGET_REVISION="42218"        
#        TARGET_PLATFORM="rs3413xsp"
#        ORIGIN_PLATFORM="bromolow"        
#        SYNOMODEL="rs3413xsp_$TARGET_REVISION"
#        sha256="9796536979407817ca96aef07aaabb3f03252a8e54df0f64ff7caf3c737f0da9"        
#    elif [ "${1}" = "DVA1622J" ]; then
#        DTC_BASE_MODEL="Y"    
#        echo "Synology model ${1} jun mode not supported by m shell"
#        exit 0        
    else                                                                                                     
        echo "Synology model not supported by TCRP."                                                         
        exit 0                                                                                               
    fi    

    tem="${1}"

    if [ $TARGET_REVISION == "42218" ] ; then
        MODEL="$(echo $tem | sed 's/J//g')"
        TARGET_VERSION="7.0.1"
    elif [ $TARGET_REVISION == "64551" ] ; then    
        MODEL="$(echo $tem | sed 's/K//g')"
        TARGET_VERSION="7.2"
    else
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
    fi

    echo "MODEL is $MODEL"

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
        curl --insecure -s --location "$mshtarfile" --output $mshellgz
    fi

    curl --insecure -s --location "$mshtarfile" --output latest.mshell.gz

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
