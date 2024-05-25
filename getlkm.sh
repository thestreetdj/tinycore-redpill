tcrppart="$(mount | grep -i optional | grep cde | awk -F / '{print $3}' | uniq | cut -c 1-3)3"
local_cache="/mnt/${tcrppart}/auxfiles"

curl -kL https://raw.githubusercontent.com/PeterSuh-Q3/redpill-lkm/master/rp-lkms.zip -o /tmp/rp-lkms.zip
unzip /tmp/rp-lkms.zip        rp-${1}-${2}-prod.ko.gz -d /tmp >/dev/null 2>&1
gunzip -f /tmp/rp-${1}-${2}-prod.ko.gz >/dev/null 2>&1
cp -vf /tmp/rp-${1}-${2}-prod.ko ${local_cache}/redpill.ko
