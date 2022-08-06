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


showhelp() {
    cat <<EOF
$(basename ${0})

----------------------------------------------------------------------------------------
Usage: ${0} <Synology Model Name> <Options>

Options: postupdate, noconfig, noclean, manual, realmac, userdts

- postupdate : Option to patch the restore loop after applying DSM 7.1.0-42661 Update 2, no additional build required.

- noconfig: SKIP automatic detection change processing such as SN/Mac/Vid/Pid/SataPortMap of user_config.json file.

- noclean: SKIP the 💊   RedPill LKM/LOAD directory without clearing it with the Clean command. 
           However, delete the Cache directory and loader.img.

- manual: Options for manual extension processing and manual dtc processing in build action (skipping extension auto detection).

- realmac : Option to use the NIC's real address instead of creating a virtual one.

- userdts : Option to use the user-defined platform.dts file instead of auto-discovery mapping with dtcpatch.


Please type Synology Model Name after ./$(basename ${0})

- for jot mode

./$(basename ${0}) DS918+
./$(basename ${0}) DS3617xs
./$(basename ${0}) DS3615xs
./$(basename ${0}) DS3622xs+
./$(basename ${0}) DVA3221
./$(basename ${0}) DS920+
./$(basename ${0}) DS1621+
./$(basename ${0}) DS2422+
./$(basename ${0}) DVA1622
./$(basename ${0}) DS1520+ (Not Suppoted, Testing...)
./$(basename ${0}) FS2500  (Not Suppoted, Testing..., Has DTC issue)
./$(basename ${0}) DS1621xs+
./$(basename ${0}) RS4021xs+
./$(basename ${0}) DVA3219 

- for jun mode

./$(basename ${0}) DS918+J                                                                                                      
./$(basename ${0}) DS3617xsJ                                                                                                    
./$(basename ${0}) DS3615xsJ                                                                                                    
./$(basename ${0}) DS3622xs+J                                                                                                   
./$(basename ${0}) DVA3221J                                                                                                     
./$(basename ${0}) DS920+J                                                                                                      
./$(basename ${0}) DS1621+J 
./$(basename ${0}) DS2422+J  
./$(basename ${0}) DVA1622J (Not Suppoted)
./$(basename ${0}) DS1520+J
./$(basename ${0}) FS2500J  (Not Suppoted, Has DTC issue)
./$(basename ${0}) DS1621xs+J
./$(basename ${0}) RS4021xs+J ((Not Suppoted, Testing...)
./$(basename ${0}) DVA3219J (Not Suppoted, Testing...)

EOF

}

getvars()
{

    TARGET_REVISION="42661"
    MSHELL_ONLY_MODEL="N"
    DTC_BASE_MODEL="N"
    ORIGIN_PLATFORM=""

# JOT MODE
    if [ "${1}" = "DS918+" ]; then        
        DTC_BASE_MODEL="N"
        TARGET_PLATFORM="apollolake"
        ORIGIN_PLATFORM=$TARGET_PLATFORM
        SYNOMODEL="ds918p_$TARGET_REVISION"                                                                                                                    
        sha256="4e8a9d82a8a1fde5af9a934391080b7bf6b91811d9583acb73b90fb6577e22d7"
    elif [ "${1}" = "DS3615xs" ]; then                                                                                                                     
        DTC_BASE_MODEL="N"    
        TARGET_PLATFORM="bromolow"
        ORIGIN_PLATFORM=$TARGET_PLATFORM
        SYNOMODEL="ds3615xs_$TARGET_REVISION"                                                                                                                  
        sha256="1e95d8c63981bcf42ea2eaedfbc7acc4248ff16d129344453b7479953f9ad145"
    elif [ "${1}" = "DS3617xs" ]; then                                                                                                                     
        DTC_BASE_MODEL="N"    
        TARGET_PLATFORM="broadwell"
        ORIGIN_PLATFORM=$TARGET_PLATFORM
        SYNOMODEL="ds3617xs_$TARGET_REVISION"                                                                                                                  
        sha256="0a5a243109098587569ab4153923f30025419740fb07d0ea856b06917247ab5c"
    elif [ "${1}" = "DS3622xs+" ]; then
        DTC_BASE_MODEL="N"    
        TARGET_PLATFORM="broadwellnk"
        ORIGIN_PLATFORM=$TARGET_PLATFORM
        SYNOMODEL="ds3622xsp_$TARGET_REVISION"
        sha256="53d0a4f1667288b6e890c4fdc48422557ff26ea8a2caede0955c5f45b560cccd"
    elif [ "${1}" = "DS1621+" ]; then
        DTC_BASE_MODEL="Y"    
        TARGET_PLATFORM="v1000"
        ORIGIN_PLATFORM=$TARGET_PLATFORM
        SYNOMODEL="ds1621p_$TARGET_REVISION"                                                                                                                   
        sha256="381077302a89398a9fb5ec516217578d6f33b0219fe95135e80fd93cddbf88c4"
    elif [ "${1}" = "DVA3221" ]; then                                                                                                                      
        DTC_BASE_MODEL="N"    
        TARGET_PLATFORM="denverton"
        ORIGIN_PLATFORM=$TARGET_PLATFORM
        SYNOMODEL="dva3221_$TARGET_REVISION"                                                                                                                   
        sha256="ed3207db40b7bac4d96411378558193b7747ebe88f0fc9c26c59c0b5c688c359"
    elif [ "${1}" = "DVA1622" ]; then
        DTC_BASE_MODEL="Y"    
        TARGET_PLATFORM="dva1622"
        ORIGIN_PLATFORM="geminilake"
        SYNOMODEL="dva1622_$TARGET_REVISION"                                                                                                                   
        sha256="f1484cf302627072ca393293cd73e61dc9e09d479ef028b216eae7c12f7b7825"
    elif [ "${1}" = "DS920+" ]; then
        DTC_BASE_MODEL="Y"    
        TARGET_PLATFORM="geminilake"
        ORIGIN_PLATFORM=$TARGET_PLATFORM
        SYNOMODEL="ds920p_$TARGET_REVISION"                                                                                                                    
        sha256="8076950fdad2ca58ea9b91a12584b9262830fe627794a0c4fc5861f819095261"

# JOT MODE NEW MODEL SUCCESS
    elif [ "${1}" = "DS2422+" ] ; then
        DTC_BASE_MODEL="Y"    
        MSHELL_ONLY_MODEL="Y"                
        TARGET_PLATFORM="ds2422p"
        ORIGIN_PLATFORM="v1000"
        SYNOMODEL="ds2422p_$TARGET_REVISION"                                                                                                                   
        sha256="c38fee0470c592b679ab52a64eac76b2a3912fb2e6aba65a65abb5aa05a98d4c"
    elif [ "${1}" = "DS1621xs+" ]; then
        DTC_BASE_MODEL="N"    
        MSHELL_ONLY_MODEL="Y"    
        TARGET_PLATFORM="ds1621xsp"
        ORIGIN_PLATFORM="broadwellnk"        
        SYNOMODEL="ds1621xsp_$TARGET_REVISION"
        sha256="9dba7c728dbeb69f881a515b841ec82b091fda6741fdbf225d94f1af5bb2a2d6"
    elif [ "${1}" = "RS4021xs+" ]; then
        DTC_BASE_MODEL="N"    
        MSHELL_ONLY_MODEL="Y"    
        TARGET_PLATFORM="rs4021xsp"
        ORIGIN_PLATFORM="broadwellnk"        
        SYNOMODEL="rs4021xsp_$TARGET_REVISION"
        sha256="496b64e431dafa34cdebb92da8ac736bf1610fe157f03df7e6d11152d60991f5"
    elif [ "${1}" = "DVA3219" ]; then
        DTC_BASE_MODEL="N"    
        MSHELL_ONLY_MODEL="Y"    
        TARGET_PLATFORM="dva3219"
        ORIGIN_PLATFORM="denverton"        
        SYNOMODEL="dva3219_$TARGET_REVISION"                                                                                                                   
        sha256="01596eaf7310a56b504fde5743262f721dd0be2836e53d2d74386e14f509bec4"                                                                              
        
# JOT MODE NEW MODEL TESTTING                
    elif [ "${1}" = "DS1520+" ]; then
        DTC_BASE_MODEL="Y"    
        MSHELL_ONLY_MODEL="Y"    
        TARGET_PLATFORM="ds1520p"
        ORIGIN_PLATFORM="geminilake"        
        SYNOMODEL="ds1520p_$TARGET_REVISION"                                                                                                                    
        sha256="3a8499c5f72d7241b81781ec741d4019eaa506e6e7a4fd17ce54fb149f6ffae6"
        echo "Synology model ${1} jot mode not supported by m shell, Testing..."        
        exit 0        
    elif [ "${1}" = "DF2500" ]; then
        DTC_BASE_MODEL="Y"    
        MSHELL_ONLY_MODEL="Y"    
        echo "Synology model ${1} jot mode not supported by m shell, Because It has DTC mapping issue"
        exit 0        
        
#JUN MODE
    elif [ "${1}" = "DS918+J" ]; then           
        DTC_BASE_MODEL="N"    
        TARGET_REVISION="42218"                                                                                                                                
        TARGET_PLATFORM="apollolake"
        ORIGIN_PLATFORM=$TARGET_PLATFORM
        SYNOMODEL="ds918p_$TARGET_REVISION"                                                                                                                    
        sha256="a403809ab2cd476c944fdfa18cae2c2833e4af36230fa63f0cdee31a92bebba2"                                                                              
    elif [ "${1}" = "DS3615xsJ" ]; then
        DTC_BASE_MODEL="N"    
        TARGET_REVISION="42218"               
        TARGET_PLATFORM="bromolow"
        ORIGIN_PLATFORM=$TARGET_PLATFORM
        SYNOMODEL="ds3615xs_$TARGET_REVISION"                                   
        sha256="dddd26891815ddca02d0d53c1d42e8b39058b398a4cc7b49b80c99f851cf0ef7"                             
    elif [ "${1}" = "DS3617xsJ" ]; then
        DTC_BASE_MODEL="N"    
        TARGET_REVISION="42218"               
        TARGET_PLATFORM="broadwell"
        ORIGIN_PLATFORM=$TARGET_PLATFORM
        SYNOMODEL="ds3617xs_$TARGET_REVISION" 
        sha256="d65ee4ed5971e38f6cdab00e1548183435b53ba49a5dca7eaed6f56be939dcd2"
    elif [ "${1}" = "DS3622xs+J" ]; then
        DTC_BASE_MODEL="N"    
        TARGET_REVISION="42218"               
        TARGET_PLATFORM="broadwellnk"
        ORIGIN_PLATFORM=$TARGET_PLATFORM
        SYNOMODEL="ds3622xsp_$TARGET_REVISION"
        sha256="f38329b8cdc5824a8f01fb1e377d3b1b6bd23da365142a01e2158beff5b8a424"
    elif [ "${1}" = "DS1621+J" ]; then
        DTC_BASE_MODEL="Y"    
        TARGET_REVISION="42218"                                                  
        TARGET_PLATFORM="v1000"
        ORIGIN_PLATFORM=$TARGET_PLATFORM
        SYNOMODEL="ds1621p_$TARGET_REVISION"                                     
        sha256="19f56827ba8bf0397d42cd1d6f83c447f092c2c1bbb70d8a2ad3fbd427e866df"
    elif [ "${1}" = "DVA3221J" ]; then
        DTC_BASE_MODEL="N"    
        TARGET_REVISION="42218"                                                  
        TARGET_PLATFORM="denverton"
        ORIGIN_PLATFORM=$TARGET_PLATFORM
        SYNOMODEL="dva3221_$TARGET_REVISION"                                     
        sha256="01f101d7b310c857e54b0177068fb7250ff722dc9fa2472b1a48607ba40897ee"
    elif [ "${1}" = "DS920+J" ]; then
        DTC_BASE_MODEL="Y"    
        TARGET_REVISION="42218"
        TARGET_PLATFORM="geminilake"
        ORIGIN_PLATFORM=$TARGET_PLATFORM
        SYNOMODEL="ds920p_$TARGET_REVISION"                                                                                                                    
        sha256="fe2a4648f76adeb65c3230632503ea36bbac64ee88b459eb9bfb5f3b8c8cebb3"
    elif [ "${1}" = "DS2422+J" ]; then
        DTC_BASE_MODEL="Y"    
        TARGET_REVISION="42218"                                                  
        TARGET_PLATFORM="ds2422p"
        ORIGIN_PLATFORM="v1000"        
        SYNOMODEL="ds2422p_$TARGET_REVISION"                                     
        sha256="415c54934d483a2557500bc3a2e74588a0cec1266e1f0d9a82a7d3aace002471"
        
# JUN MODE NEW MODEL SUCCESS
    elif [ "${1}" = "DS1520+J" ]; then
        DTC_BASE_MODEL="Y"    
        MSHELL_ONLY_MODEL="Y"    
        TARGET_REVISION="42218"
        TARGET_PLATFORM="ds1520p"
        ORIGIN_PLATFORM="geminilake"        
        SYNOMODEL="ds1520p_$TARGET_REVISION"                                                                                                                    
        sha256="06947c58f25bd591f7fa3c58ad9473777481bdd7a049b42d1cb585ca01b053ee"
    elif [ "${1}" = "DS1621xs+J" ]; then
        DTC_BASE_MODEL="N"    
        MSHELL_ONLY_MODEL="Y"    
        TARGET_REVISION="42218"               
        TARGET_PLATFORM="ds1621xsp"
        ORIGIN_PLATFORM="broadwellnk"        
        SYNOMODEL="ds1621xsp_$TARGET_REVISION"
        sha256="5db4e5943d246b1a2414942ae19267adc94d2a6ab167ba3e2fc10b42aefded23"
# JUN MODE NEW MODEL TESTTING
    elif [ "${1}" = "DVA1622J" ]; then
        DTC_BASE_MODEL="Y"    
        echo "Synology model ${1} jun mode not supported by m shell"
        exit 0        
    elif [ "${1}" = "FS2500J" ]; then
        DTC_BASE_MODEL="Y"    
        MSHELL_ONLY_MODEL="Y"    
        echo "Synology model ${1} jun mode not supported by m shell, Because It has DTC mapping issue"
        exit 0        
        TARGET_REVISION="42218"
        TARGET_PLATFORM="fs2500"
        ORIGIN_PLATFORM="v1000"        
        SYNOMODEL="fs2500_$TARGET_REVISION"                                                                                                                    
        sha256="4d060be8afec548fdb042bc8095524f10ff200033cab74df37ae07f3de5eaa69"
    elif [ "${1}" = "RS4021xs+J" ]; then
        DTC_BASE_MODEL="N"    
        MSHELL_ONLY_MODEL="Y"    
        echo "Synology model ${1} jot mode not supported by m shell, Testing..."
        exit 0    
        TARGET_REVISION="42218"               
        TARGET_PLATFORM="rs4021xsp"
        ORIGIN_PLATFORM="broadwellnk"        
        SYNOMODEL="rs4021xsp_$TARGET_REVISION"
        sha256="7afca3970ac7324d7431c1484d4249939bedd4c18ac34187f894c43119edf3a1"
    elif [ "${1}" = "DVA3219J" ]; then
        DTC_BASE_MODEL="N"    
        MSHELL_ONLY_MODEL="Y"    
        echo "Synology model ${1} jot mode not supported by m shell, Testing..."
        exit 0    
        TARGET_REVISION="42218"                                                  
        TARGET_PLATFORM="dva3219"
        ORIGIN_PLATFORM="denverton"        
        SYNOMODEL="dva3219_$TARGET_REVISION"                                     
        sha256="3557df23ff6af9bbb0cf46872ba2fc09c344eb303a38e8283dbc9a46e5eae979"
    else                                                                                                     
        echo "Synology model not supported by TCRP."                                                         
        exit 0                                                                                               
    fi    

    tem="${1}"

    if [ $TARGET_REVISION == "42218" ] ; then
        MODEL="$(echo $tem | sed 's/J//g')"
    else
        MODEL=$tem
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

checkinternet() {

    echo -n "Checking Internet Access -> "
    nslookup github.com 2>&1 >/dev/null
    if [ $? -eq 0 ]; then
        echo "OK"
    else
        cecho g "Error: No internet found, or github is not accessible"
        exit 99
    fi

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

