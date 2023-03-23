#!/bin/bash

# Set DateTime
timezone="UTC"

while true; do
  if [ $(ifconfig | grep -i "inet " | grep -v "127.0.0.1" | wc -l) -gt 0 ]; then
    break
  fi
  sleep 1
  echo "Waiting for internet activation!!!"
done

#Get Timezone
tz=$(curl -s ipinfo.io | grep timezone | awk '{print $2}' | sed 's/,//')
if [ $(echo $tz | grep Seoul | wc -l ) -gt 0 ]; then
    ntpserver="ntp.kriss.re.kr"
else
    ntpserver="pool.ntp.org"
fi

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
    echo "----------------------user_config.json extra_cmdline-----------------------"
    jq '.extra_cmdline' /home/tc/user_config.json
    echo "Press ctrl-c to exit"
    sleep 2
done
