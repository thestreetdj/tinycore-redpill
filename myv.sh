#!/bin/bash

# myv.sh (Batch Shell Script for rploader.sh)                 
# Made by Peter Suh
# 2022.04.18                      
# Update : add 42661 U1 NanoPacked
# 2022.04.28
# Update : add noconfig, noclean, manual options
# 2022.04.30
# Update : add noconfig, noclean, manual combinatione options
# 2022.05.06   
# Update : add pat file sha256 check                         
# 2022.05.07      
# Update : Added dtc compilation function for user custom dts file
# 2022.05.15
# Update : call connection with my.sh
# 2022.05.25
# Update : Add jumkey's Jun mode
# 2022.06.11
# Update : Add DS2422+ jun mode Support
# 2022.06.28
# Update : Add DS2422+ jot mode Support
# 2022.07.02
                                                                                        
mshellgz="myv.sh.gz"
mshtarfile="https://raw.githubusercontent.com/PeterSuh-Q3/tinycore-redpill/main/myv.sh.gz"

# Function READ_YN, cecho                                                                                        
# Made by FOXBI                                                                                                               
# 2022.04.14                                                                                                                  
#                                                                                                                             
# ==============================================================================                                              
# Y or N Function                                                                                                             
# ==============================================================================                                              
READ_YN () { # $1:question $2:default                                                                                         
   read -n1 -p "$1" Y_N                                                                                                       
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
        done < <(curl --no-progress-meter https://github.com/pocopico/rp-ext | grep "raw.githubusercontent.com" | awk '{print $2}' | awk -F= '{print $2}' | sed "s/\"//g" | awk -F/ '{print $7}')
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
                    IEXT=`echo "${IRRAY[$j]}" | sed 's/\\\ln//g' | sed 's/\\\lt//g' | awk '{print $2}'`

		    if [ $TARGET_REVISION == "42218" ] ; then
                        ./rploader.sh ext ${TARGET_PLATFORM}-7.0.1-42218-JUN add https://raw.githubusercontent.com/pocopico/rp-ext/master/$IEXT/rpext-index.json    
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
                        export IEXT=`echo "${IRRAY[$i]}" | sed 's/\\\ln//g' | sed 's/\\\lt//g' | awk '{print $2}'`
                    fi
                done

                if [ $TARGET_REVISION == "42218" ] ; then                                                                                                                                    
                    ./rploader.sh ext ${TARGET_PLATFORM}-7.0.1-42218-JUN add https://raw.githubusercontent.com/pocopico/rp-ext/master/$IEXT/rpext-index.json                                 
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

function showhelp() {
    cat <<EOF
$(basename ${0})

----------------------------------------------------------------------------------------
Usage: ${0} <Synology Model Name> <Options>

Options: postupdate, noconfig, noclean, manual

- postupdate : Option to patch the restore loop after applying DSM 7.1.0-42661 Update 2, no additional build required.

- noconfig: SKIP automatic detection change processing such as SN/Mac/Vid/Pid/SataPortMap of user_config.json file.

- noclean: SKIP the 💊   RedPill LKM/LOAD directory without clearing it with the Clean now command. 
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
./$(basename ${0}) DS2422+ (7.1.0-42661 Extension not yet supported)
./$(basename ${0}) DVA1622

- for jun mode

./$(basename ${0}) DS918+J                                                                                                      
./$(basename ${0}) DS3617xsJ                                                                                                    
./$(basename ${0}) DS3615xsJ                                                                                                    
./$(basename ${0}) DS3622xs+J                                                                                                   
./$(basename ${0}) DVA3221J                                                                                                     
./$(basename ${0}) DS920+J                                                                                                      
./$(basename ${0}) DS1621+J (Not Suporrted) 
./$(basename ${0}) DS2422+J  
./$(basename ${0}) DVA1622J

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
    elif [ "$1" = "DS3615xs" ]; then                                                                                                                     
        TARGET_PLATFORM="bromolow"                                                                                                                             
        SYNOMODEL="ds3615xs_$TARGET_REVISION"                                                                                                                  
    elif [ "$1" = "DS3617xs" ]; then                                                                                                                     
        TARGET_PLATFORM="broadwell"                                                                                                                            
        SYNOMODEL="ds3617xs_$TARGET_REVISION"                                                                                                                  
    elif [ "$1" = "DS3622xs+" ]; then                                                                                                                    
        TARGET_PLATFORM="broadwellnk"                                                                                                                          
        SYNOMODEL="ds3622xsp_$TARGET_REVISION"                                                                                                                 
    elif [ "$1" = "DS1621+" ]; then                                                                                                                      
        TARGET_PLATFORM="v1000"                                                                                                                                
        SYNOMODEL="ds1621p_$TARGET_REVISION"                                                                                                                   
    elif [ "$1" = "DS2422+" ] ; then
        TARGET_PLATFORM="ds2422p"                                                                                                                                
        SYNOMODEL="ds2422p_$TARGET_REVISION"                                                                                              
    elif [ "$1" = "DVA3221" ]; then                                                                                                                      
        TARGET_PLATFORM="denverton"                                                                                                                            
        SYNOMODEL="dva3221_$TARGET_REVISION"                                                                                                                   
    elif [ "$1" = "DVA1622" ]; then                                                                                                                      
        TARGET_PLATFORM="dva1622"                                                                                                                            
        SYNOMODEL="dva1622_$TARGET_REVISION"
    elif [ "$1" = "DS920+" ]; then                                                                                                                       
        TARGET_PLATFORM="geminilake"                                                                                                                           
        SYNOMODEL="ds920p_$TARGET_REVISION"                                                                                                                    
    elif [ "$1" = "DS918+J" ]; then                                                                                                                      
        TARGET_REVISION="42218"                                                                                                                                
        TARGET_PLATFORM="apollolake"                                                                                                                       
        SYNOMODEL="ds918p_$TARGET_REVISION"                                                                                                                    
    elif [ "$1" = "DS3615xsJ" ]; then         
        TARGET_REVISION="42218"               
        TARGET_PLATFORM="bromolow"            
        SYNOMODEL="ds3615xs_$TARGET_REVISION"                                   
    elif [ "$1" = "DS3617xsJ" ]; then                                           
        TARGET_REVISION="42218"               
        TARGET_PLATFORM="broadwell"           
        SYNOMODEL="ds3617xs_$TARGET_REVISION" 
    elif [ "$1" = "DS3622xs+J" ]; then        
        TARGET_REVISION="42218"               
        TARGET_PLATFORM="broadwellnk"         
        SYNOMODEL="ds3622xsp_$TARGET_REVISION"
    elif [ "$1" = "DS1621+J" ]; then                                             
        TARGET_REVISION="42218"                                                  
        TARGET_PLATFORM="v1000"                                                  
        SYNOMODEL="ds1621p_$TARGET_REVISION"                                     
    elif [ "$1" = "DS2422+J" ]; then                                                                         
        TARGET_REVISION="42218"                                                                              
        TARGET_PLATFORM="v1000"                                                                              
        SYNOMODEL="ds2422p_$TARGET_REVISION"   
    elif [ "$1" = "DVA3221J" ]; then                                             
        TARGET_REVISION="42218"                                                  
        TARGET_PLATFORM="denverton"                                              
        SYNOMODEL="dva3221_$TARGET_REVISION"     
    elif [ "$1" = "DVA1622J" ]; then
        echo "Synology model DVA1622 jun mode not supported by TCRP yet."
        exit 0	
    elif [ "$1" = "DS920+J" ]; then                                                                                                                      
        TARGET_REVISION="42218"
        TARGET_PLATFORM="geminilake"                                                                                                                       
        SYNOMODEL="ds920p_$TARGET_REVISION"                                                                                                                    
    else                                                                                                     
        echo "Synology model not supported by TCRP."                                                         
        exit 0                                                                                               
    fi  

cecho y "Adding Ext in progress..."                                                                                                                                     
                                                                                                                                                                        
EXDRIVER_FN

if [ ! -f my.sh ]; then
    echo "my.sh file not found, trying to download"
    curl --location "https://github.com/PeterSuh-Q3/tinycore-redpill/raw/main/my.sh.gz" --output my.sh.gz
    tar -zxvf my.sh.gz
fi


cecho g "Call my.sh now..."
./my.sh $@

exit 0
