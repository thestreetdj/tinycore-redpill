#!/bin/bash

echo "Prepare Make Direcrtory for volume$2"

[ ! -d /volume$2/\@appstore/ ] && mkdir /volume$2/\@appstore/
[ ! -d /volume$2/\@apphome/ ] && mkdir /volume$2/\@apphome/
[ ! -d /volume$2/\@apptemp/ ] && mkdir /volume$2/\@apptemp/
[ ! -d /volume$2/\@appdata/ ] && mkdir /volume$2/\@appdata/
[ ! -d /volume$2/\@appconf/ ] && mkdir /volume$2/\@appconf/
echo

for app in $(ls /volume$1/\@appstore); do

    echo
    echo "Stopping Package $app"
    synopkg stop $app
    sleep 3

done

for app in $(ls /volume$1/\@appstore); do

    echo
    echo "Moving $app from volume$1 to volume$2"    
    echo "=>moving appstore for $app"
    mv /volume$1/\@appstore/$app /volume$2/\@appstore/.
    echo "=>moving apphome for $app"
    mv /volume$1/\@apphome/$app /volume$2/\@apphome/.
    echo "=>moving apptemp for $app"
    mv /volume$1/\@apptemp/$app /volume$2/\@apptemp/.
    echo "=>moving appdata for $app"
    mv /volume$1/\@appdata/$app /volume$2/\@appdata/.
    echo "=>moving appconf for $app"
    mv /volume$1/\@appconf/$app /volume$2/\@appconf/.
    
    echo
    cd /var/packages/$app/
    echo "=== Link Before ==="
    ls -list target home tmp var etc
    rm -f etc;ln -s /volume$2/\@appconf/$app etc
    rm -f home;ln -s /volume$2/\@apphome/$app home
    rm -f target;ln -s /volume$2/\@appstore/$app target
    rm -f tmp;ln -s /volume$2/\@apptemp/$app tmp
    rm -f var;ln -s /volume$2/\@appdata/$app var
    
    echo
    echo "Starting Package $app"
    synopkg start $app
    sleep 3
    
    echo
    echo "=== Link After ==="
    ls -list target home tmp var etc
    
    echo
    echo "=== Left ==="
    ls /volume$1/\@appstore

    echo
    echo "======================================================="

done

echo "=== DONE ==="
