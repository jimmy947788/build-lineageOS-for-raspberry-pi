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

dd if=$workerFolder/$IMGNAME of=/dev/sde status=progress bs=4M