#!/bin/bash

echo "Please excute in junior root"

mkdir -p /mnt/localdiskp1
cd /dev
mount synoboot1 /mnt/localdiskp1
sed -i "/set default=/cset default=\"1\"" /mnt/localdiskp1/boot/grub/grub.cfg

echo "Entries in Localdisk bootloader : "
echo "======================================================================="
grep menuentry /mnt/localdiskp1/boot/grub/grub.cfg
    
echo "Setting default boot entry to Tiny Core Image Build"
cat /mnt/localdiskp1/boot/grub/grub.cfg | grep "set default"
