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


checkinternet
getlatestmshell

if [ $# -lt 1 ]; then
    showhelp
    exit 99
fi

getvars

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
