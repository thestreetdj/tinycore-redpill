#!/bin/bash

set -u # Unbound variable errors are not allowed

##### INCLUDES ######################################################################################
. /home/tc/functions.sh
#####################################################################################################

function gitclone() {
    git clone -b master --single-branch --depth=1 https://github.com/PeterSuh-Q3/redpill-load.git
    if [ $? -ne 0 ]; then
        git clone -b master --single-branch --depth=1 https://gitea.com/PeterSuh-Q3/redpill-load.git
    fi    
}

function gitdownload() {

    cd /home/tc
    git config --global http.sslVerify false    
    if [ -d /home/tc/redpill-load ]; then
        echo "Loader sources already downloaded, pulling latest"
        cd /home/tc/redpill-load
        git pull
        if [ $? -ne 0 ]; then
           cd /home/tc
           ./rploader.sh clean
           gitclone    
        fi   
        cd /home/tc
    else
        gitclone
    fi
    
}

loaderdisk=""
for edisk in $(sudo fdisk -l | grep "Disk /dev/sd" | awk '{print $2}' | sed 's/://' ); do
    if [ $(sudo fdisk -l | grep "83 Linux" | grep ${edisk} | wc -l ) -eq 3 ]; then
        echo "Found Bootloader Disk ${edisk}"
        loaderdisk="$(blkid | grep ${edisk} | grep "6234-C863" | cut -c 1-8 | awk -F\/ '{print $3}')"    
    fi    
done
if [ -z "${loaderdisk}" ]; then
    for edisk in $(sudo fdisk -l | grep -e "Disk /dev/nvme" -e "Disk /dev/mmc" | awk '{print $2}' | sed 's/://' ); do
        if [ $(sudo fdisk -l | grep "83 Linux" | grep ${edisk} | wc -l ) -eq 3 ]; then
            loaderdisk="$(blkid | grep ${edisk} | grep "6234-C863" | cut -c 1-12 | awk -F\/ '{print $3}')"    
        fi    
    done
fi

if [ -z "${loaderdisk}" ]; then
    echo "Not Supported Loader BUS Type, program Exit!!!"
    exit 99
fi

getBus "${loaderdisk}" 

[ "${BUS}" = "nvme" ] && loaderdisk="${loaderdisk}p"
[ "${BUS}" = "mmc"  ] && loaderdisk="${loaderdisk}p"

tcrppart="${loaderdisk}3"

if [ -d /mnt/${tcrppart}/redpill-load/ ] && [ -d /mnt/${tcrppart}/tcrp-addons/ ] && [ -d /mnt/${tcrppart}/tcrp-modules/ ]; then
    echo "Repositories for offline loader building have been confirmed. Copy the repositories to the required location..."
    echo "Press any key to continue..."    
    read answer
    cp -rf /mnt/${tcrppart}/redpill-load/ ~/
    mv -f /mnt/${tcrppart}/tcrp-addons/ /dev/shm/
    mv -f /mnt/${tcrppart}/tcrp-modules/ /dev/shm/
    echo "Go directly to the menu. Press any key to continue..."
    read answer
else
    while true; do
      if [ $(ifconfig | grep -i "inet " | grep -v "127.0.0.1" | wc -l) -gt 0 ]; then
        getlatestmshell "noask"
        break
      fi
      sleep 1
      echo "Waiting for internet activation in menu.sh !!!"
    done
    gitdownload
fi

if [ -z "${1-}" ]; then
  [ -f /tmp/test_mode ] && rm /tmp/test_mode
else
  touch /tmp/test_mode
fi

/home/tc/menu_m.sh
exit 0
