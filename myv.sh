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
# Update : Add DVA1622 jun mode (Testing)
# 2022.07.07
# Update : Add DS1520+ jun mode
# 2022.07.08
# Update : Add FS2500 jun mode
# 2022.07.10

##### INCLUDES #########################################################################################################
. include/common.sh # my.sh / myv.sh common use 
########################################################################################################################
                                                                                        
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
                        export IEXT=`echo "${IRRAY[$i]}" | sed 's/\\\ln//g' | sed 's/\\\lt//g' | awk '{print $2}'`
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

checkinternet
getlatestmshell

if [ $# -lt 1 ]; then
    showhelp
    exit 99
fi

echo 

TARGET_REVISION="42661"

MSHELL_ONLY_MODEL="N"

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
    elif [ "$1" = "DS1520+" ]; then
        echo "Synology model DS1520+ jot mode not supported by m shell"
        exit 0	
    elif [ "$1" = "DF2500" ]; then
        echo "Synology model FS2500 jot mode not supported by m shell"
        exit 0  
	
	
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
        echo "Synology model DVA1622 jun mode not supported by m shell"
        exit 0      
    elif [ "$1" = "DS920+J" ]; then                                                                                                                      
        TARGET_REVISION="42218"
        TARGET_PLATFORM="geminilake"                                                                                                                       
        SYNOMODEL="ds920p_$TARGET_REVISION"
    elif [ "$1" = "DS1520+J" ]; then
        TARGET_REVISION="42218"
        TARGET_PLATFORM="ds1520p"
        SYNOMODEL="ds1520p_$TARGET_REVISION"         
	MSHELL_ONLY_MODEL="Y"
    elif [ "$1" = "FS2500J" ]; then
        TARGET_REVISION="42218"
        TARGET_PLATFORM="fs2500"
        SYNOMODEL="fs2500_$TARGET_REVISION"                                                                                                                    
        MSHELL_ONLY_MODEL="Y"	
    else                                                                                                     
        echo "Synology model not supported by TCRP."                                                         
        exit 0                                                                                               
    fi  


if [ $SYNOMODEL == "ds2422p_42661" ] ; then
	curl --location --progress-bar "https://github.com/PeterSuh-Q3/tinycore-redpill/raw/main/custom_config.json" -O
	curl --location --progress-bar "https://github.com/PeterSuh-Q3/tinycore-redpill/raw/main/rpext-index.json" -O
elif [ $SYNOMODEL == "dva1622_42661" ] ; then
        curl --location --progress-bar "https://github.com/pocopico/tinycore-redpill/raw/develop/custom_config.json" -O
        curl --location --progress-bar "https://github.com/pocopico/tinycore-redpill/raw/develop/rpext-index.json" -O
elif [ $MSHELL_ONLY_MODEL == "Y" ] ; then
	curl --location --progress-bar "https://github.com/PeterSuh-Q3/tinycore-redpill/raw/main/custom_config_jun.json" -O
	curl --location --progress-bar "https://github.com/PeterSuh-Q3/tinycore-redpill/raw/main/rpext-index.json" -O
else
        curl --location --progress-bar "https://github.com/pocopico/tinycore-redpill/raw/main/custom_config.json" -O
        curl --location --progress-bar "https://github.com/pocopico/tinycore-redpill/raw/main/rpext-index.json" -O  
fi

cecho y "Adding Ext in progress..."                                                                                                                                     
                                                                                                                                                                        
EXDRIVER_FN

if [ ! -f my.sh ]; then
    echo "my.sh file not found, trying to download"
    curl --location "https://github.com/PeterSuh-Q3/tinycore-redpill/raw/main/my.sh.gz" --output my.sh.gz
    tar -zxvf my.sh.gz
fi


cecho g "Call my.sh now..."
./my.sh $@ frmyv

exit 0
