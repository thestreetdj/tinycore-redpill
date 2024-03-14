#!/bin/bash

function gitclone() {
    git clone -b master --single-branch https://github.com/PeterSuh-Q3/redpill-load.git
    if [ $? -ne 0 ]; then
        git clone -b master --single-branch https://gitea.com/PeterSuh-Q3/redpill-load.git
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

for edisk in $(fdisk -l | grep "Disk /dev/sd" | awk '{print $2}' | sed 's/://' ); do
    if [ $(fdisk -l | grep "83 Linux" | grep ${edisk} | wc -l ) -eq 3 ]; then
        echo "Found Bootloader Disk ${edisk}"
        loaderdisk="$(blkid | grep ${edisk} | grep "6234-C863" | cut -c 1-8 | awk -F\/ '{print $3}')"    
    fi    
done
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
        /home/tc/my update
        break
      fi
      sleep 1
      echo "Waiting for internet activation in menu.sh !!!"
    done
    gitdownload
fi

/home/tc/menu_m.sh
exit 0
