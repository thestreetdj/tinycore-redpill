#!/bin/bash

function gitdownload() {

    git config --global http.sslVerify false    
    if [ -d /home/tc/redpill-load ]; then
        echo "Loader sources already downloaded, pulling latest"
        cd /home/tc/redpill-load
        git pull
        [ $? -ne 0 ] && ./rploader.sh clean && git clone -b master "https://github.com/PeterSuh-Q3/redpill-load.git"
        cd /home/tc
    else
        git clone -b master "https://github.com/PeterSuh-Q3/redpill-load.git"        
    fi

}

while true; do
  if [ $(ifconfig | grep -i "inet " | grep -v "127.0.0.1" | wc -l) -gt 0 ]; then
    /home/tc/my.sh update
    break
  fi
  sleep 1
  echo "Waiting for internet activation in menu.sh !!!"
done

gitdownload

/home/tc/menu_m.sh
exit 0
