#!/bin/sh
echo "Proceed with remote upgrade of the loader of TCRP-mshell."
[ ! -d /mnt/p1 ] &&  mkdir /mnt/p1 || exit 99
[ ! -d /mnt/p2 ] &&  mkdir /mnt/p2 || exit 99
[ ! -d /mnt/p3 ] &&  mkdir /mnt/p3 || exit 99

cd /dev/
mount -t vfat synoboot1 /mnt/p1
mount -t vfat synoboot2 /mnt/p2
mount -t vfat synoboot3 /mnt/p3

tar -zxvf /volume1/homes/admin/remote.pack.tgz -C /mnt

cd /mnt
umount /mnt/p1
umount /mnt/p2
umount /mnt/p3
