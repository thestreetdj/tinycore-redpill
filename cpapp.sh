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
    if [ $app = "Docker" ]; then
        for cont in $(docker ps -q); do
            echo "Stopping Docker Container $cont"
            docker stop $cont 
        done
    fi    
    synopkg stop $app
    sleep 3

done

for app in $(ls /volume$1/\@appstore); do

#    if [ $app = "Docker" ]; then
#        echo "=>coping docker folder..."
#        rsync -av /volume$1/\@docker /volume$2/\@docker
#    fi

    echo
    echo "Copying $app from volume$1 to volume$2"    
    echo "=>copying appstore for $app"
    cp -r /volume$1/\@appstore/$app /volume$2/\@appstore/.
    echo "=>copying apphome for $app"
    cp -r /volume$1/\@apphome/$app /volume$2/\@apphome/.
    echo "=>copying apptemp for $app"
    cp -r /volume$1/\@apptemp/$app /volume$2/\@apptemp/.
    echo "=>copying appdata for $app"
    cp -r /volume$1/\@appdata/$app /volume$2/\@appdata/.
    echo "=>copying appconf for $app"
    cp -r /volume$1/\@appconf/$app /volume$2/\@appconf/.
    
    echo
    cd /var/packages/$app/
    echo "=== Link Before ==="
    ls -list target home tmp var etc
    ln -s /volume$2/\@appconf/$app etc
    ln -s /volume$2/\@apphome/$app home
    ln -s /volume$2/\@appstore/$app target
    ln -s /volume$2/\@apptemp/$app tmp
    ln -s /volume$2/\@appdata/$app var
    
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
