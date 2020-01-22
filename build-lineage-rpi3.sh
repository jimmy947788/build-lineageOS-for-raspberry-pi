#!/bin/bash

BUILD_IMG=$1
if [ -z "$BUILD_IMG" ]
then
    BUILD_IMG="ALL"
fi
OUT_DIR="$PWD/out"
RPI3_OUT_DIR="$OUT_DIR/target/product/rpi3"

if [[ "$BUILD_IMG" =~ ^(kernel|ramdisk|systemimage|vendorimage|ALL)$ ]]
then
    echo "build $BUILD_IMG image."
    if [ "$BUILD_IMG" == "ALL" ]
    then
        BUILD_IMG="kernel ramdisk systemimage vendorimage" 
    fi
else
    echo "unknow image name $BUILD_IMG ."
    echo "please check you want build image is (kernel|ramdisk|systemimage|vendorimage|ALL)."
    exit 1
fi

export USE_CCACHE=1
export CCACHE_DIR=$HOME/.ccache
ccache -M 50G

JACK_ADMIN_PATH="prebuilts/sdk/tools/jack-admin"
export JACK_SERVER_VM_ARGUMENTS="-Dfile.encoding=UTF-8 -XX:+TieredCompilation -Xmx4g"
$JACK_ADMIN_PATH kill-server && $JACK_ADMIN_PATH start-server

source build/envsetup.sh
lunch lineage_rpi3-userdebug
make -j12 $BUILD_IMG

echo "remove old lineage-15.1-rpi3.img...."
rm -f device/brcm/rpi3/lineage-15.1-*-rpi3.img
rm -f $RPI3_OUT_DIR/lineage-15.1-*-rpi3.img

echo "build new lineage-15.1-rpi3.img..."
cd device/brcm/rpi3/
sudo sh mkimg.sh
DATE=`date +%Y%m%d`
IMGNAME="lineage-15.1-$DATE-rpi3.img"
mv "$IMGNAME" "$RPI3_OUT_DIR/$IMGNAME"
echo "new image file is here: "
echo "    $RPI3_OUT_DIR/$IMGNAME"