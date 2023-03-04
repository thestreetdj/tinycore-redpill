#!/bin/bash

# Set DateTime
timezone="UTC"
ntpserver="pool.ntp.org"
if [ "$(which ntpclient)_" == "_" ]; then
    tce-load -iw ntpclient 2>&1 >/dev/null
fi    
export TZ="${timezone}"
sudo ntpclient -s -h ${ntpserver} 2>&1 >/dev/null
