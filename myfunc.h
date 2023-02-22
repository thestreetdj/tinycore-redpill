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

showlastupdate() {
    cat <<EOF

# Update : Release TCRP FRIEND mode
# 2022.09.25

# Update : Deploy menu.sh
# 2022.11.14

# Update : Added ds923+ (r1000)
# 2022.11.25

# Update : Added ds723+ (r1000)
# 2023.01.15

# Update : 7.0.1-42218 friend correspondence for DS918+,DS920+,DS1019+, DS1520+ transcoding
# 2023.02.19

# Update : Inspection of FMA3 command support (Haswell or higher) and model restriction function added to menu.sh
# 2023.02.22

There is a new distribution of menu.sh that looks like an APRL-style menu.
Run ./menu.sh to use the menu.

EOF
}

showhelp() {
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

getvars()
{

    TARGET_REVISION="42962"
    MSHELL_ONLY_MODEL="N"
    DTC_BASE_MODEL="N"
    ORIGIN_PLATFORM=""

# JOT MODE
    if [ "${1}" = "DS918+" ] || [ "${1}" = "DS918+F" ]; then        
        DTC_BASE_MODEL="N"
        TARGET_PLATFORM="ds918p"
        ORIGIN_PLATFORM="apollolake"
        SYNOMODEL="ds918p_$TARGET_REVISION"                                                                                                                    
        sha256="c1ffb1b48301fbcf1ccffae00062e95c8b5b18d50a70c3fbb79ea12a38a39bb7"
    elif [ "${1}" = "DS3615xs" ] || [ "${1}" = "DS3615xsF" ]; then                                                                                                                     
        DTC_BASE_MODEL="N"    
        TARGET_PLATFORM="ds3615xs"
        ORIGIN_PLATFORM="bromolow"
        SYNOMODEL="ds3615xs_$TARGET_REVISION"                                                                                                                  
        sha256="b79c129354c203b7340010573d16b2d6ebc6a676c946579a959c891a70b8bcfc"
    elif [ "${1}" = "DS3617xs" ] || [ "${1}" = "DS3617xsF" ]; then                                                                                                                     
        DTC_BASE_MODEL="N"    
        TARGET_PLATFORM="ds3617xs"
        ORIGIN_PLATFORM="broadwell"
        SYNOMODEL="ds3617xs_$TARGET_REVISION"                                                                                                                  
        sha256="2a556206201df10245dbcf4cf0366b2f32cb318cd705fbdd74412303d85e7267"
    elif [ "${1}" = "DS3622xs+" ] || [ "${1}" = "DS3622xs+F" ]; then
        DTC_BASE_MODEL="N"    
        TARGET_PLATFORM="ds3622xsp"
        ORIGIN_PLATFORM="broadwellnk"
        SYNOMODEL="ds3622xsp_$TARGET_REVISION"
        sha256="b48aadaba7ff561b7d55aa9ed75f1f2f4c49c0c2f73ece4020f3ffd08f6bbfd0"
    elif [ "${1}" = "DS1621+" ] || [ "${1}" = "DS1621+F" ]; then
        DTC_BASE_MODEL="Y"    
        TARGET_PLATFORM="ds1621p"
        ORIGIN_PLATFORM="v1000"
        SYNOMODEL="ds1621p_$TARGET_REVISION"                                                                                                                   
        sha256="bd88dfdf1eccdf7fefcdac67e11929818ae3aea938fd13286c1ac7b5aaa3964f"
    elif [ "${1}" = "DVA3221" ] || [ "${1}" = "DVA3221F" ]; then                                                                                                                      
        DTC_BASE_MODEL="N"    
        TARGET_PLATFORM="dva3221"
        ORIGIN_PLATFORM="denverton"
        SYNOMODEL="dva3221_$TARGET_REVISION"                                                                                                                   
        sha256="d83044ff12c9ed81c5e7f5ba4b23b68d96c9a40c29a6a9e5c53ad807d1e27ed2"
    elif [ "${1}" = "DVA1622" ] || [ "${1}" = "DVA1622F" ]; then
        DTC_BASE_MODEL="Y"    
        TARGET_PLATFORM="dva1622"
        ORIGIN_PLATFORM="geminilake"
        SYNOMODEL="dva1622_$TARGET_REVISION"                                                                                                                   
        sha256="9106f6bcc52b4bc2b4ce82748788ca353ddecf8b7552e7c6fb477eb4eca42e67"
    elif [ "${1}" = "DS920+" ] || [ "${1}" = "DS920+F" ]; then
        DTC_BASE_MODEL="Y"    
        TARGET_PLATFORM="ds920p"
        ORIGIN_PLATFORM="geminilake"
        SYNOMODEL="ds920p_$TARGET_REVISION"                                                                                                                    
        sha256="90b1bd215b85eb366b3d3b6bef6bb6bef657dd0caba032dae556717b58e44c06"
    elif [ "${1}" = "DS923+" ] || [ "${1}" = "DS923+F" ]; then
        DTC_BASE_MODEL="Y"    
        TARGET_PLATFORM="ds923p"
        ORIGIN_PLATFORM="r1000"
        SYNOMODEL="ds923p_$TARGET_REVISION"                                                                                                                    
        sha256="e33b47df446ce0bd99c5613767c9dba977915e25acfb5ccb9f5650b14459458f"
    elif [ "${1}" = "DS723+" ] || [ "${1}" = "DS723+F" ]; then
        DTC_BASE_MODEL="Y"    
        TARGET_PLATFORM="ds723p"
        ORIGIN_PLATFORM="r1000"
        SYNOMODEL="ds723p_$TARGET_REVISION"                                                                                                                    
        sha256="e5a96f3b6c8e0535eea5fd585eb5aeca7f445f6fc976628875dc64b2cbb66180"

# JOT MODE NEW MODEL SUCCESS
    elif [ "${1}" = "DS2422+" ] || [ "${1}" = "DS2422+F" ] ; then
        DTC_BASE_MODEL="Y"    
        MSHELL_ONLY_MODEL="Y"                
        TARGET_PLATFORM="ds2422p"
        ORIGIN_PLATFORM="v1000"
        SYNOMODEL="ds2422p_$TARGET_REVISION"                                                                                                                   
        sha256="a887cc3f06e2b51d34f682a1a812637486aeefbef57c309414f69c3e5514edef"
    elif [ "${1}" = "DS1621xs+" ] || [ "${1}" = "DS1621xs+F" ]; then
        DTC_BASE_MODEL="N"    
        MSHELL_ONLY_MODEL="Y"    
        TARGET_PLATFORM="ds1621xsp"
        ORIGIN_PLATFORM="broadwellnk"        
        SYNOMODEL="ds1621xsp_$TARGET_REVISION"
        sha256="199d70693a7eb3a4ff69100bb2634c8b97b115f828bd1f6403d2832cce4e7052"
    elif [ "${1}" = "RS4021xs+" ] || [ "${1}" = "RS4021xs+F" ]; then
        DTC_BASE_MODEL="N"    
        MSHELL_ONLY_MODEL="Y"    
        TARGET_PLATFORM="rs4021xsp"
        ORIGIN_PLATFORM="broadwellnk"        
        SYNOMODEL="rs4021xsp_$TARGET_REVISION"
        sha256="fd848be9336d8b5cc9b514e71d447c7612d0f542d373eef61a6d427430daa931"
    elif [ "${1}" = "DVA3219" ] || [ "${1}" = "DVA3219F" ]; then
        DTC_BASE_MODEL="N"    
        MSHELL_ONLY_MODEL="Y"    
        TARGET_PLATFORM="dva3219"
        ORIGIN_PLATFORM="denverton"        
        SYNOMODEL="dva3219_$TARGET_REVISION"                                                                                                                   
        sha256="f03395fd9db108d2c5a684b6ba9b4fadc6b1ab05c4e227d401572c01ec4b3dca"                                                                              
    elif [ "${1}" = "FS2500" ] || [ "${1}" = "FS2500F" ]; then
        DTC_BASE_MODEL="Y"    
        MSHELL_ONLY_MODEL="Y"    
        TARGET_PLATFORM="fs2500"
        ORIGIN_PLATFORM="v1000"        
        SYNOMODEL="fs2500_$TARGET_REVISION"                                                                                                                    
        sha256="1adc272ba9f308866dc69a8f550d4511966a1156c553f925be167815046a5ab4"
    elif [ "${1}" = "RS3618xs" ] || [ "${1}" = "RS3618xsF" ]; then                                                                                                                     
        DTC_BASE_MODEL="N"    
        MSHELL_ONLY_MODEL="Y"        
        TARGET_PLATFORM="rs3618xs"
        ORIGIN_PLATFORM="broadwell"
        SYNOMODEL="rs3618xs_$TARGET_REVISION"                                                                                                                  
        sha256="da1851fbaed8cf99537f323539f2f56df81f84c87d430b57e1e7174858834508"
    elif [ "${1}" = "DS1019+" ] || [ "${1}" = "DS1019+F" ]; then        
        DTC_BASE_MODEL="N"
        TARGET_PLATFORM="ds1019p"
        ORIGIN_PLATFORM="apollolake"
        SYNOMODEL="ds1019p_$TARGET_REVISION"                                                                                                                    
        sha256="91bb367f501a3d86988211b7e35f68809a8f967e6e4e54ff31ed89bd50a66cc9"        
    elif [ "${1}" = "DS1520+" ] || [ "${1}" = "DS1520+F" ]; then
        DTC_BASE_MODEL="Y"    
        MSHELL_ONLY_MODEL="Y"    
        TARGET_PLATFORM="ds1520p"
        ORIGIN_PLATFORM="geminilake"        
        SYNOMODEL="ds1520p_$TARGET_REVISION"                                                                                                                    
        sha256="f19d2ac39fae564797c148929b8fe7c9740ac3a74099bf573b68df8fe0228cb3"
        
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
READ_YN () { # ${1}:question ${2}:default                                                                                         
   read -n1 -p "${1}" Y_N                                                                                                       
    case "$Y_N" in                                                                                                            
    y) Y_N="y"                                                                                                                
         echo -e "\n" ;;                                                                                                      
    n) Y_N="n"                                                                                                                
         echo -e "\n" ;;                                                                                                      
    q) echo -e "\n"                                                                                                           
       exit 0 ;;                                                                                                              
    *) echo -e "\n" ;;                                                                                                        
    esac                                                                                                                      
}                                                                                         

getlatestmshell() {

    echo -n "Checking if a newer mshell version exists on the repo -> "

    if [ ! -f $mshellgz ]; then
        curl -s --location "$mshtarfile" --output $mshellgz
    fi

    curl -s --location "$mshtarfile" --output latest.mshell.gz

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

generateMacAddress() {
    printf '00:11:32:%02X:%02X:%02X' $((RANDOM % 256)) $((RANDOM % 256)) $((RANDOM % 256))

}
