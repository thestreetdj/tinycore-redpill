#!/bin/bash

    loaderdisk=$(mount | grep -i optional | grep cde | awk -F / '{print $3}' | uniq | cut -c 1-3)
echo
    if [ -d localdiskp1 ]; then
        sudo mount /dev/${loaderdisk}1 localdiskp1
        echo "Mounting /dev/${loaderdisk}1 to localdiskp1 "
    else
        mkdir localdiskp1
        sudo mount /dev/${loaderdisk}1 localdiskp1
        echo "Mounting /dev/${loaderdisk}1 to localdiskp1 "
    fi
echo
    if [ $(mount | grep -i localdiskp1 | wc -l) -eq 1 ] ; then
        echo "grub boot partition mounted normally." 
    else
        echo "ERROR: Failed to mount correctly all required partitions"
        exit 0   
    fi
echo
    echo "Entries in Localdisk bootloader : "
    echo "======================================================================="
    grep menuentry localdiskp1/boot/grub/grub.cfg

#echo "$1"
echo
    if [ "$1" = "1" ]; then
        echo "Setting default boot entry to USB"                                                                                                                             
        sudo sed -i "/set default=/cset default=\"0\"" localdiskp1/boot/grub/grub.cfg
    elif [ "$1" = "2" ]; then
        echo "Setting default boot entry to SATA"
        sudo sed -i "/set default=/cset default=\"1\"" localdiskp1/boot/grub/grub.cfg
    elif [ "$1" = "3" ]; then
        echo "Setting default boot entry to Tiny Core Image Build"                                                                                                                             
        sudo sed -i "/set default=/cset default=\"2\"" localdiskp1/boot/grub/grub.cfg
    fi
echo
#    cat localdiskp1/boot/grub/grub.cfg

    sudo umount localdiskp1

exit 0
