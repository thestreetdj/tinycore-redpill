#!/bin/bash

function gitclone() {
    git clone -b master --single-branch https://github.com/PeterSuh-Q3/redpill-load.git
    if [ $? -ne 0 ]; then
        git clone -b master --single-branch https://giteas.duckdns.org/PeterSuh-Q3/redpill-load.git
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

while true; do
  if [ $(ifconfig | grep -i "inet " | grep -v "127.0.0.1" | wc -l) -gt 0 ]; then
    /home/tc/my update
    break
  fi
  sleep 1
  echo "Waiting for internet activation in menu.sh !!!"
done

gitdownload

/home/tc/menu_m.sh
exit 0
