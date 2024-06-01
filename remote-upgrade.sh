#!/bin/sh
echo "Proceed with remote upgrade of the loader of TCRP-mshell."
[ ! -d /mnt/p1 ] &&  mkdir /mnt/p1
[ ! -d /mnt/p2 ] &&  mkdir /mnt/p2
[ ! -d /mnt/p3 ] &&  mkdir /mnt/p3

cd /dev/
mount -t vfat synoboot1 /mnt/p1
mount -t vfat synoboot2 /mnt/p2
mount -t vfat synoboot3 /mnt/p3

tar --no-same-owner --touch -zxvf /volume1/homes/admin/remote.updatepack.*.tgz -C /mnt

cd /mnt
umount /mnt/p1
umount /mnt/p2
umount /mnt/p3
