#!/bin/bash

# myv.sh (Batch Shell Script for rploader.sh)                 
# Made by Peter Suh
# 2022.04.18                      

##### INCLUDES #########################################################################################################
source myfunc.h # my.sh / myv.sh common use 
########################################################################################################################
                                                                                        
mshellgz="myv.sh.gz"
mshtarfile="https://raw.githubusercontent.com/PeterSuh-Q3/tinycore-redpill/main/myv.sh.gz"


checkinternet
getlatestmshell

if [ $# -lt 1 ]; then
    showhelp
    exit 99
fi

getvars "$1"

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
