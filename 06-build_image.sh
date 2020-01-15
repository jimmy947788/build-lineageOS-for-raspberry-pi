#!/bin/bash
source common.sh
source config.sh

rm -rf $workerFolder/*.img
cd $lineageOSFolder/device/brcm/rpi3/
rm -rf *.img
#print_info "now -> $PWD"
sh mkimg.sh

DATE=`date +%Y%m%d`
IMGNAME=$lineageVersion-$DATE-rpi3.img
mv $IMGNAME $workerFolder/$IMGNAME

DEVICE_PATH="/dev/sde"
read -p "Are sure SDCard is $DEVICE_PATH ? (y/n)" confirm
if [ "$confirm" = "n" ]
then
    read -p "please keyin device (/dev/sdX)" confirm DEVICE_PATH
fi

dd if=$workerFolder/$IMGNAME of=$DEVICE_PATH status=progress bs=4M