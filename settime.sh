#!/bin/bash

timezone="UTC"
ntpserver="pool.ntp.org"

echo "Downloading ntpclient to assist"
tce-load -iw ntpclient 2>&1 >/dev/null
export TZ="${timezone}"
sudo ntpclient -s -h ${ntpserver} 2>&1 >/dev/null
echo "Current time after communicating with NTP server ${ntpserver} :  $(date) "
