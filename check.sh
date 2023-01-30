#!/bin/bash

while true; do
  if [ $(ifconfig | grep -i "inet " | grep -v "127.0.0.1" | wc -l) -gt 0 ]; then
    /home/tc/my.sh update
    break
  fi
  sleep 1
  echo "Waiting for internet activation in check.sh !!!"
done

/home/tc/menu.sh
exit 0
