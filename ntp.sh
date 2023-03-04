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
echo
echo "press any key to continue..."                                                                                                   
read answer
exit 0
