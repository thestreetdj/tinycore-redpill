#!/bin/bash

while [ -z "$GATEWAY_INTERFACE" ]; do
    clear
    if [ -f /home/tc/buildstatus ]; then
      echo -e "\e[35m-------------------M-Shell for TCRP 💊 Loader Build Staus------------------\e[0m"
      echo -e "\e[33mStage\e[0m	\e[37mStatus\e[0m	Message"
      echo -e "\e[35m---------------------------------------------------------------------------\e[0m"      
      cat /home/tc/buildstatus
    else
      echo -e "\e[35m----------------------user_config.json extra_cmdline-----------------------\e[0m"
      jq '.extra_cmdline' /home/tc/user_config.json
    fi
    echo "Press ctrl-c to exit"
    sleep 1
done
