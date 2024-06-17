#!/usr/bin/env ash
#
# Copyright (C) 2022 Ing <https://github.com/wjz304>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#

tce-load -wi ethtool

sudo -i

  echo "this is sortnetif..."
#  echo "extract usr.tgz to /usr/ "
#  tar xvfz /exts/sortnetif/usr.tgz -C /
#  chmod +x /usr/bin/awk /usr/bin/tr /usr/bin/sort /usr/bin/sed /usr/bin/ethtool

ETHLIST=""
ETHX=$(ls /sys/class/net/ 2>/dev/null | grep eth) # real network cards list
for ETH in ${ETHX}; do
  MAC="$(cat /sys/class/net/${ETH}/address 2>/dev/null | sed 's/://g' | tr '[:upper:]' '[:lower:]')"
  BUS=$(ethtool -i ${ETH} 2>/dev/null | grep bus-info | awk '{print $2}')
  ETHLIST="${ETHLIST}${BUS} ${MAC} ${ETH}\n"
done

ETHLIST="$(echo -e "${ETHLIST}" | sort)"
ETHLIST="$(echo -e "${ETHLIST}" | grep -v '^$')"

echo -e "${ETHLIST}" >/tmp/ethlist
cat /tmp/ethlist

# sort
IDX=0
while true; do
  cat /tmp/ethlist
  [ ${IDX} -ge $(wc -l </tmp/ethlist) ] && break
  ETH=$(cat /tmp/ethlist | sed -n "$((${IDX} + 1))p" | awk '{print $3}')
  echo "ETH: ${ETH}"
  if [ -n "${ETH}" ] && [ ! "${ETH}" = "eth${IDX}" ]; then
    echo "change ${ETH} <=> eth${IDX}"
    ifconfig eth${IDX} down
    ifconfig ${ETH} down
    sleep 1
    echo "SUBSYSTEM==\"net\", ACTION==\"add\", DRIVERS==\"?*\", ATTR{address}==\"$(cat /sys/class/net/${ETH}/address)\", NAME=\"eth${IDX}\"" >> /etc/udev/rules.d/70-persistent-net.rules
    echo "SUBSYSTEM==\"net\", ACTION==\"add\", DRIVERS==\"?*\", ATTR{address}==\"$(cat /sys/class/net/eth${IDX}/address)\", NAME=\"${ETH}\"" >> /etc/udev/rules.d/70-persistent-net.rules
    sleep 1
    ifconfig eth${IDX} up
    ifconfig ${ETH} up
    sleep 1
    sed -i "s/eth${IDX}/tmp/" /tmp/ethlist
    sed -i "s/${ETH}/eth${IDX}/" /tmp/ethlist
    sed -i "s/tmp/${ETH}/" /tmp/ethlist
    sleep 1
  fi
  IDX=$((${IDX} + 1))
done

rm -f /tmp/ethlist

exit
