#!/bin/bash -e

echo
echo "=== shahinrtm ==="
echo "=== https://github.com/shahinrtm ==="
echo "=== MikroTik CHR Latest 7.x Installer"
echo
sleep 3
LATEST="$(curl -fsSL https://upgrade.mikrotik.com/routeros/NEWESTa7.stable | awk '{print $1}')"
DL_URL="https://download.mikrotik.com/routeros/${LATEST}/chr-${LATEST}.img.zip"
echo "Latest version : ${LATEST}"
echo "Download URL   : ${DL_URL}"
wget ${DL_URL} -O chr.img.zip  && \
gunzip -c chr.img.zip > chr.img  && \
STORAGE=`lsblk | grep disk | cut -d ' ' -f 1 | head -n 1` && \
echo STORAGE is $STORAGE && \
ETH=`ip route show default | sed -n 's/.* dev \([^\ ]*\) .*/\1/p'` && \
echo ETH is $ETH && \
ADDRESS=`ip addr show $ETH | grep global | cut -d' ' -f 6 | head -n 1` && \
echo ADDRESS is $ADDRESS && \
GATEWAY=`ip route list | grep default | cut -d' ' -f 3` && \
echo GATEWAY is $GATEWAY && \
sleep 5 && \
dd if=chr.img of=/dev/$STORAGE bs=4M oflag=sync && \
echo "Ok, reboot" && \
echo 1 > /proc/sys/kernel/sysrq && \
echo b > /proc/sysrq-trigger && \