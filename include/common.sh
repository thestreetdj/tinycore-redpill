#!/usr/bin/env bash
set -uo pipefail

function showhelp() {
    cat <<EOF
$(basename ${0})

----------------------------------------------------------------------------------------
Usage: ${0} <Synology Model Name> <Options>

Options: postupdate, noconfig, noclean, manual

- postupdate : Option to patch the restore loop after applying DSM 7.1.0-42661 Update 2, no additional build required.

- noconfig: SKIP automatic detection change processing such as SN/Mac/Vid/Pid/SataPortMap of user_config.json file.

- noclean: SKIP the 💊   RedPill LKM/LOAD directory without clearing it with the Clean command. 
           However, delete the Cache directory and loader.img.

- manual: Options for manual extension processing and manual dtc processing in build action (skipping extension auto detection)

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
./$(basename ${0}) DS1520+ (Not Suppoted)
./$(basename ${0}) FS2500 (Not Suppoted)

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
./$(basename ${0}) FS2500J

EOF

}


function getvars()
{

    TARGET_REVISION="42661"

    MSHELL_ONLY_MODEL="N"

    if [ "${1}" = "DS918+" ]; then        
        TARGET_PLATFORM="apollolake"                                                                                                                           
        SYNOMODEL="ds918p_$TARGET_REVISION"                                                                                                                    
        sha256="4e8a9d82a8a1fde5af9a934391080b7bf6b91811d9583acb73b90fb6577e22d7"                                                                              
    elif [ "${1}" = "DS3615xs" ]; then                                                                                                                     
        TARGET_PLATFORM="bromolow"                                                                                                                             
        SYNOMODEL="ds3615xs_$TARGET_REVISION"                                                                                                                  
        sha256="1e95d8c63981bcf42ea2eaedfbc7acc4248ff16d129344453b7479953f9ad145"                                                                              
    elif [ "${1}" = "DS3617xs" ]; then                                                                                                                     
        TARGET_PLATFORM="broadwell"                                                                                                                            
        SYNOMODEL="ds3617xs_$TARGET_REVISION"                                                                                                                  
        sha256="0a5a243109098587569ab4153923f30025419740fb07d0ea856b06917247ab5c"                                                                              
    elif [ "${1}" = "DS3622xs+" ]; then
        TARGET_PLATFORM="broadwellnk"
        SYNOMODEL="ds3622xsp_$TARGET_REVISION"
        sha256="53d0a4f1667288b6e890c4fdc48422557ff26ea8a2caede0955c5f45b560cccd"                                                                              
    elif [ "${1}" = "DS1621+" ]; then
        TARGET_PLATFORM="v1000"                                                                                                                                
        SYNOMODEL="ds1621p_$TARGET_REVISION"                                                                                                                   
        sha256="381077302a89398a9fb5ec516217578d6f33b0219fe95135e80fd93cddbf88c4"                                                                              
    elif [ "${1}" = "DS2422+" ] ; then
        TARGET_PLATFORM="ds2422p"                                                                                                                                
        SYNOMODEL="ds2422p_$TARGET_REVISION"                                                                                                                   
        sha256="c38fee0470c592b679ab52a64eac76b2a3912fb2e6aba65a65abb5aa05a98d4c"    
    elif [ "${1}" = "DVA3221" ]; then                                                                                                                      
        TARGET_PLATFORM="denverton"                                                                                                                            
        SYNOMODEL="dva3221_$TARGET_REVISION"                                                                                                                   
        sha256="ed3207db40b7bac4d96411378558193b7747ebe88f0fc9c26c59c0b5c688c359"                                                                              
    elif [ "${1}" = "DVA1622" ]; then                                                                                                                      
        TARGET_PLATFORM="dva1622"                                                                                                                            
        SYNOMODEL="dva1622_$TARGET_REVISION"                                                                                                                   
        sha256="f1484cf302627072ca393293cd73e61dc9e09d479ef028b216eae7c12f7b7825"                                                                              
    elif [ "${1}" = "DS920+" ]; then
        TARGET_PLATFORM="geminilake"                                                                                                                           
        SYNOMODEL="ds920p_$TARGET_REVISION"                                                                                                                    
        sha256="8076950fdad2ca58ea9b91a12584b9262830fe627794a0c4fc5861f819095261"                                                                              
    elif [ "${1}" = "DS1520+" ]; then
        echo "Synology model DS1520+ jot mode not supported by m shell"
        exit 0        
    elif [ "${1}" = "DF2500" ]; then
        echo "Synology model FS2500 jot mode not supported by m shell"
        exit 0        


    elif [ "${1}" = "DS918+J" ]; then                                                                                                                      
        TARGET_REVISION="42218"                                                                                                                                
        TARGET_PLATFORM="apollolake"                                                                                                                       
        SYNOMODEL="ds918p_$TARGET_REVISION"                                                                                                                    
        sha256="a403809ab2cd476c944fdfa18cae2c2833e4af36230fa63f0cdee31a92bebba2"                                                                              
    elif [ "${1}" = "DS3615xsJ" ]; then         
        TARGET_REVISION="42218"               
        TARGET_PLATFORM="bromolow"            
        SYNOMODEL="ds3615xs_$TARGET_REVISION"                                   
        sha256="dddd26891815ddca02d0d53c1d42e8b39058b398a4cc7b49b80c99f851cf0ef7"                             
    elif [ "${1}" = "DS3617xsJ" ]; then                                           
        TARGET_REVISION="42218"               
        TARGET_PLATFORM="broadwell"           
        SYNOMODEL="ds3617xs_$TARGET_REVISION" 
        sha256="d65ee4ed5971e38f6cdab00e1548183435b53ba49a5dca7eaed6f56be939dcd2"                             
    elif [ "${1}" = "DS3622xs+J" ]; then        
        TARGET_REVISION="42218"               
        TARGET_PLATFORM="broadwellnk"         
        SYNOMODEL="ds3622xsp_$TARGET_REVISION"
        sha256="f38329b8cdc5824a8f01fb1e377d3b1b6bd23da365142a01e2158beff5b8a424"                                                                
    elif [ "${1}" = "DS1621+J" ]; then                                             
        TARGET_REVISION="42218"                                                  
        TARGET_PLATFORM="v1000"                                                  
        SYNOMODEL="ds1621p_$TARGET_REVISION"                                     
        sha256="19f56827ba8bf0397d42cd1d6f83c447f092c2c1bbb70d8a2ad3fbd427e866df"                                                                
    elif [ "${1}" = "DS2422+J" ]; then                                             
        TARGET_REVISION="42218"                                                  
        TARGET_PLATFORM="ds2422p"                                                  
        SYNOMODEL="ds2422p_$TARGET_REVISION"                                     
        sha256="415c54934d483a2557500bc3a2e74588a0cec1266e1f0d9a82a7d3aace002471"                                                                
    elif [ "${1}" = "DVA3221J" ]; then                                             
        TARGET_REVISION="42218"                                                  
        TARGET_PLATFORM="denverton"                                              
        SYNOMODEL="dva3221_$TARGET_REVISION"                                     
        sha256="01f101d7b310c857e54b0177068fb7250ff722dc9fa2472b1a48607ba40897ee"  
    elif [ "${1}" = "DVA1622J" ]; then
        echo "Synology model DVA1622 jun mode not supported by m shell"
        exit 0        
    elif [ "${1}" = "DS920+J" ]; then                                                                                                                      
        TARGET_REVISION="42218"
        TARGET_PLATFORM="geminilake"                                                                                                                       
        SYNOMODEL="ds920p_$TARGET_REVISION"                                                                                                                    
        sha256="fe2a4648f76adeb65c3230632503ea36bbac64ee88b459eb9bfb5f3b8c8cebb3"
    elif [ "${1}" = "DS1520+J" ]; then
        TARGET_REVISION="42218"
        TARGET_PLATFORM="ds1520p"
        SYNOMODEL="ds1520p_$TARGET_REVISION"                                                                                                                    
        sha256="06947c58f25bd591f7fa3c58ad9473777481bdd7a049b42d1cb585ca01b053ee"
        MSHELL_ONLY_MODEL="Y"
    elif [ "${1}" = "FS2500J" ]; then
        TARGET_REVISION="42218"
        TARGET_PLATFORM="fs2500"
        SYNOMODEL="fs2500_$TARGET_REVISION"                                                                                                                    
        sha256="4d060be8afec548fdb042bc8095524f10ff200033cab74df37ae07f3de5eaa69"
        MSHELL_ONLY_MODEL="Y"
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

    cecho y "MODEL is $MODEL"

    #Options map to variable
    jumkey="N"
    postupdate="N"
    noclean="N"
    noconfig="N"
    manual="N"
    poco="N"
    frmyv="N"

    while [ "${2}" != "" ]; do
    #    echo ${2}

        case ${2} in

        jumkey)
            jumkey="Y"
            ;;

        poco)
            poco="Y"
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
        frmyv)
            frmyv="Y"
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
    #echo $frmyv

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

# ==============================================================================          
# Color Function                                                                          
# ==============================================================================          
cecho () {                                                                                
    if [ -n "${3}" ]                                                                                                            
    then                                                                                  
        case "${3}" in                                                                                 
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
    case "${1}" in                                                                    
        black  | bk) color="${code}${bgcolor};30m";;                                
        red    |  r) color="${code}${bgcolor};31m";;                                
        green  |  g) color="${code}${bgcolor};32m";;                                
        yellow |  y) color="${code}${bgcolor};33m";;                                
        blue   |  b) color="${code}${bgcolor};34m";;                                
        purple |  p) color="${code}${bgcolor};35m";;                                
        cyan   |  c) color="${code}${bgcolor};36m";;                                
        gray   | gr) color="${code}${bgcolor};37m";;                                
    esac                                                                            
                                                                                                                                                                    
    text="$color${2}${code}0m"                                                                                                                                        
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
echo
    mac2="$(generateMacAddress ${1})"

    cecho y "Mac2 Address for Model ${1} : $mac2 "

    macaddress2=$(echo $mac2 | sed -s 's/://g')

    sed -i "/\"extra_cmdline\": {/c\  \"extra_cmdline\": {\"mac2\": \"$macaddress2\",\"netif_num\": \"2\", "  user_config.json

    echo "After changing user_config.json"      
    cat user_config.json

}

function generateMacAddress() {
    printf '00:11:32:%02X:%02X:%02X' $((RANDOM % 256)) $((RANDOM % 256)) $((RANDOM % 256))

}

# Function EXDRIVER_FN
# Made by FOXBI
# 2022.04.14
# ==============================================================================
# Extension Driver Function
# ==============================================================================
function EXDRIVER_FN() {

    # ==============================================================================
    # Clear extension & install extension driver
    # ==============================================================================
    echo
    cecho c "Delete extension file..."
    sudo rm -rf ./redpill-load/custom/extensions/*
    echo
#    cecho c "Update ext-manager..."
#    ./redpill-load/ext-manager.sh update

    echo    
    cecho r "Add to Driver Repository..."
    echo
    READ_YN "Do you want Add Driver? Y/N :  "
    ICHK=$Y_N
    while [ "$ICHK" == "y" ] || [ "$ICHK" == "Y" ]
    do
        ICNT=
        JCNT=
        IRRAY=()
        while read LINE_I;
        do
            ICNT=$(($ICNT + 1))
            JCNT=$(($ICNT%5))
            if [ "$JCNT" -eq "0" ]
            then
                IRRAY+=("$ICNT) $LINE_I\ln");
            else
                IRRAY+=("$ICNT) $LINE_I\lt");
            fi
        done < <(curl --no-progress-meter https://github.com/pocopico/rp-ext | grep "raw.githubusercontent.com" | awk '{print ${2}}' | awk -F= '{print ${2}}' | sed "s/\"//g" | awk -F/ '{print $7}')
            echo ""
            echo -e " ${IRRAY[@]}" | sed 's/\\ln/\n/g' | sed 's/\\lt/\t/g'
            echo ""
            read -n100 -p " -> Select Number Enter (To select multiple, separate them with , ): " I_O
            echo ""
            I_OCHK=`echo $I_O | grep , | wc -l`
            if [ "$I_OCHK" -gt "0" ]
            then
                while read LINE_J;
                do
                    j=$((LINE_J - 1))
                    IEXT=`echo "${IRRAY[$j]}" | sed 's/\\\ln//g' | sed 's/\\\lt//g' | awk '{print ${2}}'`

		    if [ $TARGET_REVISION == "42218" ] ; then
		    	if [ $MSHELL_ONLY_MODEL == "Y" ] ; then
			    ./rploader.sh ext ${TARGET_PLATFORM}-7.0.1-${TARGET_REVISION}-JUN add https://raw.githubusercontent.com/PeterSuh-Q3/rp-ext/master/$IEXT/rpext-index.json
			else
                            ./rploader.sh ext ${TARGET_PLATFORM}-7.0.1-42218-JUN add https://raw.githubusercontent.com/pocopico/rp-ext/master/$IEXT/rpext-index.json    
			fi	
		    else
			if [ $SYNOMODEL == "ds2422p_42661" ] ; then
			    ./rploader.sh ext ${TARGET_PLATFORM}-7.1.0-${TARGET_REVISION} add https://raw.githubusercontent.com/PeterSuh-Q3/rp-ext/master/$IEXT/rpext-index.json
			else
			    ./rploader.sh ext ${TARGET_PLATFORM}-7.1.0-${TARGET_REVISION} add https://raw.githubusercontent.com/pocopico/rp-ext/master/$IEXT/rpext-index.json			
			fi
	    	    fi

                done < <(echo $I_O | tr ',' '\n')
            else
                I_O=$(($I_O - 1))
                for (( i = 0; i < $ICNT; i++)); do
                    if [ "$I_O" == $i ]
                    then
                        export IEXT=`echo "${IRRAY[$i]}" | sed 's/\\\ln//g' | sed 's/\\\lt//g' | awk '{print ${2}}'`
                    fi
                done

                if [ $TARGET_REVISION == "42218" ] ; then                                                                                                                                    
		    	if [ $MSHELL_ONLY_MODEL == "Y" ] ; then
			    ./rploader.sh ext ${TARGET_PLATFORM}-7.0.1-${TARGET_REVISION}-JUN add https://raw.githubusercontent.com/PeterSuh-Q3/rp-ext/master/$IEXT/rpext-index.json
			else
                            ./rploader.sh ext ${TARGET_PLATFORM}-7.0.1-42218-JUN add https://raw.githubusercontent.com/pocopico/rp-ext/master/$IEXT/rpext-index.json    
			fi	
                else                                                                                                                                                                         
			if [ $SYNOMODEL == "ds2422p_42661" ] ; then
			    ./rploader.sh ext ${TARGET_PLATFORM}-7.1.0-${TARGET_REVISION} add https://raw.githubusercontent.com/PeterSuh-Q3/rp-ext/master/$IEXT/rpext-index.json
			else
			    ./rploader.sh ext ${TARGET_PLATFORM}-7.1.0-${TARGET_REVISION} add https://raw.githubusercontent.com/pocopico/rp-ext/master/$IEXT/rpext-index.json			
			fi
                fi   

            fi
        echo
        READ_YN "Do you want add driver? Y/N :  "
        ICHK=$Y_N
    done
}
