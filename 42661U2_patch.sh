#!/bin/bash
#
# Temp fix for update2

loaderdisk="$(mount | grep -i optional | grep cde | awk -F / '{print $3}' | uniq | cut -c 1-3)"

cd /home/tc

mkdir /home/tc/ramdisk

sudo mount /dev/${loaderdisk}1
sudo mount /dev/${loaderdisk}2

cd ramdisk

unlzma -c /mnt/${loaderdisk}2/rd.gz | cpio -idm

cat /mnt/${loaderdisk}1/rd.gz | cpio -idm

find . 2>/dev/null | cpio -o -H newc -R root:root | xz -9 --format=lzma >../rd.gz

cd ..

# add fake sign
dd if=/dev/zero of=rd.gz bs=68 count=1 conv=notrunc oflag=append

sudo cp -f rd.gz /mnt/${loaderdisk}1/rd.gz

rm -rf ramdisk

echo "Done"

###################################################
