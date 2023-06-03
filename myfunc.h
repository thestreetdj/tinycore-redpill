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
# Update : Added ds916+ (braswell)
# 2023.06.03

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

# Update : Add Support DSM 7.2-64561 Official Version
# 2023.05.23

# Update : Add Getty Console to DSM 7.2
# 2023.05.26

# Update : Added ds916+ (braswell)
# 2023.06.03

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
        TARGET_REVISION="64561"
        TARGET_PLATFORM="ds1019p"
        ORIGIN_PLATFORM="apollolake"
        SYNOMODEL="ds1019p_$TARGET_REVISION"                                                                                                                    
        sha256="08cddab3f256091ec33f6d07ad320ee5c6d2264eab66add071f8119fc389931a"
        
    elif [ "${1}" = "DS1520+G" ]; then
        TARGET_REVISION="64561"
        TARGET_PLATFORM="ds1520p"
        ORIGIN_PLATFORM="geminilake"        
        SYNOMODEL="ds1520p_$TARGET_REVISION"                                                                                                                    
        sha256="49455e77b7c8a05492b08a0558bb13108cf6c628f06eee65b5861c653a8b31af"

    elif [ "${1}" = "DS1621+G" ]; then
        TARGET_REVISION="64561"
        TARGET_PLATFORM="ds1621p"
        ORIGIN_PLATFORM="v1000"
        SYNOMODEL="ds1621p_$TARGET_REVISION"                                                                                                                   
        sha256="21cd3941aab30bf035006fd48242b28f3bb3d487f505cda72fc261d3ddad440e"

    elif [ "${1}" = "DS1621xs+G" ]; then
        TARGET_REVISION="64561"
        TARGET_PLATFORM="ds1621xsp"
        ORIGIN_PLATFORM="broadwellnk"        
        SYNOMODEL="ds1621xsp_$TARGET_REVISION"
        sha256="3084e68333821ea14b3f6a2b4f0efce426359fb07aafb12cc6a48de150455829"

    elif [ "${1}" = "DS2422+G" ] ; then
        TARGET_REVISION="64561"
        TARGET_PLATFORM="ds2422p"
        ORIGIN_PLATFORM="v1000"
        SYNOMODEL="ds2422p_$TARGET_REVISION"                                                                                                                   
        sha256="3d5b4ff6e7d54710cc48914684a6fd0d489a1ab62a8ec7a3e999f057f06bfceb"

    elif [ "${1}" = "DS3617xsG" ]; then                                                                                                                     
        TARGET_REVISION="64561"    
        TARGET_PLATFORM="ds3617xs"
        ORIGIN_PLATFORM="broadwell"
        SYNOMODEL="ds3617xs_$TARGET_REVISION"                                                                                                                  
        sha256="f8ddc1f0218b41ddbe345eaf5eaa4392b3744ab5893eddad799e42b014100158"
        
    elif [ "${1}" = "DS3622xs+G" ]; then
        TARGET_REVISION="64561"    
        TARGET_PLATFORM="ds3622xsp"
        ORIGIN_PLATFORM="broadwellnk"
        SYNOMODEL="ds3622xsp_$TARGET_REVISION"
        sha256="b96f85f058a8f5144f73cbfabf89982868cbfc625d05e65e65d230e2b7f09c47"

    elif [ "${1}" = "DS720+G" ]; then
        TARGET_REVISION="64561"
        TARGET_PLATFORM="ds720p"
        ORIGIN_PLATFORM="geminilake"
        SYNOMODEL="ds720p_$TARGET_REVISION"                                                                                                                    
        sha256="7fbb1e166459f00c6b08258d9913a9fb437470e08c4f8e6f9becc850f93b88ac"

    elif [ "${1}" = "DS723+G" ]; then
        TARGET_REVISION="64561"    
        TARGET_PLATFORM="ds723p"
        ORIGIN_PLATFORM="r1000"
        SYNOMODEL="ds723p_$TARGET_REVISION"                                                                                                                    
        sha256="543b9d6b23cb42b306e62f1e9b286888c66284e25f3505b81c8b25e827e49da3"

    elif [ "${1}" = "DS916+G" ]; then           
        TARGET_REVISION="64561"
        TARGET_PLATFORM="ds916p"
        ORIGIN_PLATFORM="braswell"
        SYNOMODEL="ds916p_$TARGET_REVISION"                                                                                                                    
        sha256="0c4a8e7db8dfce88634b175670ba21b9107e0e5600cdb5154afc5cd77acaca33"      

    elif [ "${1}" = "DS918+G" ]; then           
        TARGET_REVISION="64561"
        TARGET_PLATFORM="ds918p"
        ORIGIN_PLATFORM="apollolake"
        SYNOMODEL="ds918p_$TARGET_REVISION"                                                                                                                    
        sha256="18baccf23ac8f860f96d4accbe0bfc8fd27f60966ff31a5e4a71a452c4c4ec61"      
        
    elif [ "${1}" = "DS920+G" ]; then
        TARGET_REVISION="64561"    
        TARGET_PLATFORM="ds920p"
        ORIGIN_PLATFORM="geminilake"
        SYNOMODEL="ds920p_$TARGET_REVISION"                                                                                                                    
        sha256="047654b35e9f464b367ddbbac280ea355e1548c6e314fe538e5d6b2752e627ad"
        
    elif [ "${1}" = "DS923+G" ]; then
        TARGET_REVISION="64561"    
        TARGET_PLATFORM="ds923p"
        ORIGIN_PLATFORM="r1000"
        SYNOMODEL="ds923p_$TARGET_REVISION"                                                                                                                    
        sha256="3165233b48d1958090ef86d63361f850b8165aae86540915d89f9621f6f17fec"

    elif [ "${1}" = "DVA1622G" ]; then
        TARGET_REVISION="64561"    
        TARGET_PLATFORM="dva1622"
        ORIGIN_PLATFORM="geminilake"
        SYNOMODEL="dva1622_$TARGET_REVISION"                                                                                                                   
        sha256="ae4cc66e95f71e89e458a75784131ec8bccfab1a87eecd70fbdc11b563252021"
                
    elif [ "${1}" = "DVA3219G" ]; then
        TARGET_REVISION="64561"
        TARGET_PLATFORM="dva3219"
        ORIGIN_PLATFORM="denverton"        
        SYNOMODEL="dva3219_$TARGET_REVISION"                                                                                                                   
        sha256="6381b31ff852c487dc5bc093e86887f1155427571b6e2511bc08ae8de031d793"
        
    elif [ "${1}" = "DVA3221G" ]; then                                                                                                                      
        TARGET_REVISION="64561"    
        TARGET_PLATFORM="dva3221"
        ORIGIN_PLATFORM="denverton"
        SYNOMODEL="dva3221_$TARGET_REVISION"                                                                                                                   
        sha256="5990e460da1268fb06037ab99bdf5ea886ca5e7c6d6cf4e31c04e7888b2647d1"
                
    elif [ "${1}" = "FS2500G" ]; then
        TARGET_REVISION="64561"
        TARGET_PLATFORM="fs2500"
        ORIGIN_PLATFORM="v1000"        
        SYNOMODEL="fs2500_$TARGET_REVISION"                                                                                                                    
        sha256="b4b239338c660f35cdd70b0edcfa24967c28d9651382b182307ffa3c305d6897"
    elif [ "${1}" = "RS1221+G" ]; then
        TARGET_REVISION="64561"
        TARGET_PLATFORM="rs1221p"
        ORIGIN_PLATFORM="v1000"        
        SYNOMODEL="rs1221p_$TARGET_REVISION"                                                                                                                    
        sha256="6a6b461dbbb6f96ab90c5972f5e646fac19346917fe482ddc14bfa4f2b41db93"
       
    elif [ "${1}" = "RS3618xsG" ]; then                                                                                                                     
        TARGET_REVISION="64561"
        TARGET_PLATFORM="rs3618xs"
        ORIGIN_PLATFORM="broadwell"
        SYNOMODEL="rs3618xs_$TARGET_REVISION"                                                                                                                  
        sha256="c63091a6eb7b50d759b3ee4fcd641566857fb5c11ed6084ea5d038eb5d575cdb"

    elif [ "${1}" = "RS3621xs+G" ]; then
        TARGET_REVISION="64561"
        TARGET_PLATFORM="rs3621xsp"
        ORIGIN_PLATFORM="broadwellnk"        
        SYNOMODEL="rs3621xsp_$TARGET_REVISION"
        sha256="71c22296d6248730bf88db2778a122b958febacb8ae686adb6610ff8ef520575"
       
    elif [ "${1}" = "RS4021xs+G" ]; then
        TARGET_REVISION="64561"
        TARGET_PLATFORM="rs4021xsp"
        ORIGIN_PLATFORM="broadwellnk"        
        SYNOMODEL="rs4021xsp_$TARGET_REVISION"
        sha256="95a9310ad8ad319dbd0462f7a1ae12d403d6fb2d1e64664857d337356ba10afd"

    elif [ "${1}" = "SA6400G" ]; then
        TARGET_REVISION="64561"        
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
    elif [ "$TARGET_REVISION" == "64561" ]; then
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
