#!/bin/bash

# Set DateTime
timezone="UTC"
ntpserver="pool.ntp.org"
if [ "$(which ntpclient)_" == "_" ]; then
    tce-load -iw ntpclient 2>&1 >/dev/null
fi    
export TZ="${timezone}"
echo "Synchronizing dateTime with ntp server $ntpserver ......"
sudo ntpclient -s -h ${ntpserver} 2>&1 >/dev/null
echo
echo "DateTime synchronization complete!!!"

while [ -z "$GATEWAY_INTERFACE" ]; do
    clear
    echo -e "----------------------user_config.json extra_cmdline-----------------------"
    jq '.extra_cmdline' /home/tc/user_config.json
    echo "Press ctrl-c to exit"
    sleep 2
done
