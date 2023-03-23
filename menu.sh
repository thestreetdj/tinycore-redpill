#!/bin/bash

function gitdownload() {

    git config --global http.sslVerify false    
    if [ -d /home/tc/redpill-load ]; then
        echo "Loader sources already downloaded, pulling latest"
        cd /home/tc/redpill-load
        git pull
        [ $? -ne 0 ] && ./rploader.sh clean && git clone -b master "https://github.com/PeterSuh-Q3/redpill-load.git"
        cd /home/tc
    else
        git clone -b master "https://github.com/PeterSuh-Q3/redpill-load.git"        
    fi

}

while true; do
  if [ $(ifconfig | grep -i "inet " | grep -v "127.0.0.1" | wc -l) -gt 0 ]; then
    /home/tc/my.sh update
    break
  fi
  sleep 1
  echo "Waiting for internet activation in menu.sh !!!"
done

gitdownload

#Get Timezone for Korean Langugae
tcrppart="$(mount | grep -i optional | grep cde | awk -F / '{print $3}' | uniq | cut -c 1-3)3"
tz=$(curl -s  ipinfo.io | grep timezone | awk '{print $2}' | sed 's/,//')
if [ $(echo $tz | grep Seoul | wc -l ) -gt 0 ]; then

  if [ $(cat /mnt/${tcrppart}/cde/onboot.lst|grep getlocale | wc -w) -eq 0 ]; then
    sudo curl --insecure -L "https://github.com/PeterSuh-Q3/tinycore-redpill/raw/main/tce/optional/glibc_apps.tcz" --output /mnt/${tcrppart}/cde/optional/glibc_apps.tcz
    sudo curl --insecure -L "https://github.com/PeterSuh-Q3/tinycore-redpill/raw/main/tce/optional/glibc_apps.tcz.md5.txt" --output /mnt/${tcrppart}/cde/optional/glibc_apps.tcz.md5.txt

    sudo curl --insecure -L "https://github.com/PeterSuh-Q3/tinycore-redpill/raw/main/tce/optional/glibc_gconv.tcz" --output /mnt/${tcrppart}/cde/optional/glibc_gconv.tcz
    sudo curl --insecure -L "https://github.com/PeterSuh-Q3/tinycore-redpill/raw/main/tce/optional/glibc_gconv.tcz.md5.txt" --output /mnt/${tcrppart}/cde/optional/glibc_gconv.tcz.md5.txt

    sudo curl --insecure -L "https://github.com/PeterSuh-Q3/tinycore-redpill/raw/main/tce/optional/glibc_i18n_locale.tcz" --output /mnt/${tcrppart}/cde/optional/glibc_i18n_locale.tcz
    sudo curl --insecure -L "https://github.com/PeterSuh-Q3/tinycore-redpill/raw/main/tce/optional/glibc_i18n_locale.tcz.md5.txt" --output /mnt/${tcrppart}/cde/optional/glibc_i18n_locale.tcz.md5.txt

    sudo curl --insecure -L "https://github.com/PeterSuh-Q3/tinycore-redpill/raw/main/tce/optional/libzstd.tcz" --output /mnt/${tcrppart}/cde/optional/libzstd.tcz
    sudo curl --insecure -L "https://github.com/PeterSuh-Q3/tinycore-redpill/raw/main/tce/optional/libzstd.tcz.md5.txt" --output /mnt/${tcrppart}/cde/optional/libzstd.tcz.md5.txt

    sudo curl --insecure -L "https://github.com/PeterSuh-Q3/tinycore-redpill/raw/main/tce/optional/squashfs-tools.tcz" --output /mnt/${tcrppart}/cde/optional/squashfs-tools.tcz
    sudo curl --insecure -L "https://github.com/PeterSuh-Q3/tinycore-redpill/raw/main/tce/optional/squashfs-tools.tcz.dep" --output /mnt/${tcrppart}/cde/optional/squashfs-tools.tcz.dep
    sudo curl --insecure -L "https://github.com/PeterSuh-Q3/tinycore-redpill/raw/main/tce/optional/squashfs-tools.tcz.md5.txt" --output /mnt/${tcrppart}/cde/optional/squashfs-tools.tcz.md5.txt

    sudo curl --insecure -L "https://github.com/PeterSuh-Q3/tinycore-redpill/raw/main/tce/optional/getlocale.tcz" --output /mnt/${tcrppart}/cde/optional/getlocale.tcz
    sudo curl --insecure -L "https://github.com/PeterSuh-Q3/tinycore-redpill/raw/main/tce/optional/getlocale.tcz.dep" --output /mnt/${tcrppart}/cde/optional/getlocale.tcz.dep
    sudo curl --insecure -L "https://github.com/PeterSuh-Q3/tinycore-redpill/raw/main/tce/optional/getlocale.tcz.md5.txt" --output /mnt/${tcrppart}/cde/optional/getlocale.tcz.md5.txt

    sudo curl --insecure -L "https://github.com/PeterSuh-Q3/tinycore-redpill/raw/main/tce/optional/mylocale.tcz" --output /mnt/${tcrppart}/cde/optional/mylocale.tcz
    sudo curl --insecure -L "https://github.com/PeterSuh-Q3/tinycore-redpill/raw/main/tce/optional/mylocale.tcz.dep" --output /mnt/${tcrppart}/cde/optional/mylocale.tcz.dep
    sudo curl --insecure -L "https://github.com/PeterSuh-Q3/tinycore-redpill/raw/main/tce/optional/mylocale.tcz.md5.txt" --output /mnt/${tcrppart}/cde/optional/mylocale.tcz.md5.txt
    if [ $? -eq 0 ]; then
      echo "Download getlocale.tcz OK !!!"
      sudo echo "glibc_apps.tcz" >> /mnt/${tcrppart}/cde/onboot.lst
      sudo echo "glibc_gconv.tcz" >> /mnt/${tcrppart}/cde/onboot.lst
      sudo echo "glibc_i18n_locale.tcz" >> /mnt/${tcrppart}/cde/onboot.lst
      sudo echo "libzstd.tcz" >> /mnt/${tcrppart}/cde/onboot.lst
      sudo echo "squashfs-tools.tcz" >> /mnt/${tcrppart}/cde/onboot.lst
      sudo echo "getlocale.tcz" >> /mnt/${tcrppart}/cde/onboot.lst
      sudo echo "mylocale.tcz" >> /mnt/${tcrppart}/cde/onboot.lst
    else
      echo "Download mylocale.tcz FAILE Backup locale C!!!"
      tz="DoNotUseKorean"
    fi
  fi
  sudo mkdir /usr/lib/locale && sudo localedef -c -i ko_KR -f UTF-8 ko_KR.UTF-8
  export LANG=ko_KR.utf8
  export LC_ALL=ko_KR.utf8
  
fi

/home/tc/menu_m.sh
exit 0
