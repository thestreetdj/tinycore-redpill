#!/bin/bash

# Set DateTime
timezone="UTC"
ntpserver="pool.ntp.org"
if [ "$(which ntpclient)_" == "_" ]; then
    tce-load -iw ntpclient 2>&1 >/dev/null
fi    
export TZ="${timezone}"
echo "Set DateTime Sync with $ntpserver"
sudo ntpclient -s -h ${ntpserver} 2>&1 >/dev/null
echo "DateTime synchronization complete!!!"
