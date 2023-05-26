#!/bin/bash

while [ -z "$GATEWAY_INTERFACE" ]; do
    clear
    if [ -f /home/tc/buildstatus ]; then
      echo "----------------------------Loader Build Staus-----------------------------"
      echo " Stage        Status         Message"
      echo "---------------------------------------------------------------------------"      
      cat /home/tc/buildstatus
    else
      echo "----------------------user_config.json extra_cmdline-----------------------"
      jq '.extra_cmdline' /home/tc/user_config.json
    fi
    echo "Press ctrl-c to exit"
    sleep 1
done
