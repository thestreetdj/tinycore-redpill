#!/bin/bash


if [ $(uname -a | grep "synology" | wc -l) -gt 0 ]; then
    SYNO="Y"
else
    SYNO="N"
fi

#echo "$SYNO"

if [ "$SYNO" == "Y" ]; then
    loaderdisk="synoboot"    
else
    loaderdisk=$(mount | grep -i optional | grep cde | awk -F / '{print $3}' | uniq | cut -c 1-3)
fi

echo

    if [ ! -d /mnt/localdiskp1 ]; then
        mkdir -p /mnt/localdiskp1
    fi

    cd /dev                                                 
    sudo mount ${loaderdisk}1 /mnt/localdiskp1              
    echo "Mounting /dev/${loaderdisk}1 to /mnt/localdiskp1 "

echo

    if [ $(mount | grep -i /mnt/localdiskp1 | wc -l) -eq 1 ] ; then
        echo "grub boot partition mounted normally." 
    else
        echo "ERROR: Failed to mount correctly all required partitions"
        exit 0   
    fi

echo

    echo "Entries in Localdisk bootloader : "
    echo "======================================================================="
    grep menuentry /mnt/localdiskp1/boot/grub/grub.cfg

#echo "$1"
echo

    if [ "$1" = "1" ]; then
        echo "Setting default boot entry to USB"                                                                                                                             
        sudo sed -i "/set default=/cset default=\"0\"" /mnt/localdiskp1/boot/grub/grub.cfg
    elif [ "$1" = "2" ]; then
        echo "Setting default boot entry to SATA"
        sudo sed -i "/set default=/cset default=\"1\"" /mnt/localdiskp1/boot/grub/grub.cfg
    elif [ "$1" = "3" ]; then
        echo "Setting default boot entry to Tiny Core Image Build"                                                                                                                             
        sudo sed -i "/set default=/cset default=\"2\"" /mnt/localdiskp1/boot/grub/grub.cfg
    fi

echo

#    cat localdiskp1/boot/grub/grub.cfg

    sudo umount /mnt/localdiskp1

if [ "$SYNO" == "N" ]; then
    cd /home/tc
fi

exit 0
