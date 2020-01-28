#!/bin/bash

write_env(){
    local ENV_KEY=$1
    local ENV_VAL=$2
    #echo "${ENV_VAL////\\/}"
    sed -i "/export $ENV_KEY=/d" $PROFILE_PATH
    echo "export $ENV_KEY=$ENV_VAL" >> $PROFILE_PATH
}

DEVICE_NAME="rpi3"
PROFILE_PATH=$HOME/.profile

source $PROFILE_PATH
echo "Entry LineageOS source code folder: $LINEAGE_SRC"
cd $LINEAGE_SRC

BUILD_IMG=$1
if [ -z "$BUILD_IMG" ]
then
    BUILD_IMG="ALL"
fi

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

echo "set compiler cache enable."
write_env "USE_CCACHE" 1
write_env "CCACHE_DIR" "$HOME/.ccache"
ccache -M 50G

echo "set compiler use memory ."
write_env "JACK_ADMIN_PATH" "$LINEAGE_SRC/prebuilts/sdk/tools/jack-admin"
write_env "JACK_SERVER_VM_ARGUMENTS" "\"-Dfile.encoding=UTF-8 -XX:+TieredCompilation -Xmx4g\""
$JACK_ADMIN_PATH kill-server && $JACK_ADMIN_PATH start-server

source build/envsetup.sh
lunch lineage_$DEVICE_NAME-userdebug
make -j12 $BUILD_IMG

echo "remove old $LINEAGE_BRANCH-$DEVICE_NAME.img...."
rm -f $LINEAGE_SRC/device/brcm/$DEVICE_NAME/$LINEAGE_BRANCH-*-$DEVICE_NAME.img
rm -f $LINEAGE_SRC/out/target/product/$DEVICE_NAME/$LINEAGE_BRANCH-*-$DEVICE_NAME.img

echo "build new $LINEAGE_BRANCH-$DEVICE_NAME.img..."
cd $LINEAGE_SRC/device/brcm/$DEVICE_NAME/
sudo sh mkimg.sh
DATE=`date +%Y%m%d`
IMGNAME="$LINEAGE_BRANCH-$DATE-$DEVICE_NAME.img"
mv "$IMGNAME" "$LINEAGE_SRC/out/target/product/$DEVICE_NAME/$IMGNAME"
echo "new image file is here: "
echo "    $LINEAGE_SRC/out/target/product/$DEVICE_NAME/$IMGNAME"