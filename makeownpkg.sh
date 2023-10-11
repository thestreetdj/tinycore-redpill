#!/bin/sh

tcrppart="$(mount | grep -i optional | grep cde | awk -F / '{print $3}' | uniq | cut -c 1-3)3"

if [ "$(which mksquashfs)_" == "_" ]; then
  tce-load -wi squashfs-tools.tcz
fi

if [ ! -d pkg/usr/local/tce.installed ]; then
  mkdir -p pkg/usr/local/tce.installed
fi 

if [ $# -lt 1 ]; then
  echo "There is no new package name : ex) ./makeownpkg.sh newpkgname dependpkg1 dependpkg2 dependpkg3 dependpkg4 dependpkg5"
  exit 0
fi

if [ $# -lt 2 ]; then
  echo "There is no dependency package name : ex) ./makeownpkg.sh newpkgname dependpkg1 dependpkg2 dependpkg3 dependpkg4 dependpkg5"
  exit 0
fi

echo "packing n making my own package..."
mksquashfs pkg ${1}.tcz -noappend
sudo cp -f ${1}.tcz /mnt/${tcrppart}/cde/optional
grep -q "${1}.tcz" /mnt/${tcrppart}/cde/onboot.lst || echo "${1}.tcz" >> /mnt/${tcrppart}/cde/onboot.lst

echo -n "" > /mnt/${tcrppart}/cde/optional/${1}.tcz.dep
if [ $# -gt 1 ]; then
  echo "Create a dependency file for my own package... ${2}.tcz"
  echo "${2}.tcz" >> /mnt/${tcrppart}/cde/optional/${1}.tcz.dep
fi
if [ $# -gt 2 ]; then
  echo "Create a dependency file for my own package... ${3}.tcz"
  echo "${3}.tcz" >> /mnt/${tcrppart}/cde/optional/${1}.tcz.dep
fi
if [ $# -gt 3 ]; then
  echo "Create a dependency file for my own package... ${4}.tcz"
  echo "${4}.tcz" >> /mnt/${tcrppart}/cde/optional/${1}.tcz.dep
fi
if [ $# -gt 4 ]; then
  echo "Create a dependency file for my own package... ${5}.tcz"
  echo "${5}.tcz" >> /mnt/${tcrppart}/cde/optional/${1}.tcz.dep
fi
if [ $# -gt 5 ]; then
  echo "Create a dependency file for my own package... ${6}.tcz"
  echo "${6}.tcz" >> /mnt/${tcrppart}/cde/optional/${1}.tcz.dep
fi
