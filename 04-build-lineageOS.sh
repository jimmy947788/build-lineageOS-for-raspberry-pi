#!/bin/bash
source common.sh
source config.sh

show_banner "Build lineageOS"
set_environment_variable
show_config

print_title "Step1. patch lineageOS"
cd $workerFolder
patchesFolder="$workerFolder/android_local_manifest"
if [ ! -d $patchesFolder ] 
then
    git clone https://github.com/lineage-rpi/android_local_manifest.git
fi
print_info "patch -> modify generic keyboard layout"
cd $lineageOSFolder/frameworks/base
git am $patchesFolder/patches/frameworks_base/0001-rpi3-modify-generic-keyboard-layout.patch 
print_info "patch -> disable adb authentication by default"
cd $lineageOSFolder/vendor/lineage
git am $patchesFolder/patches/vendor_lineage/0001-disable-adb-authentication-by-default.patch

print_title "Step2. set compiler cache"
export USE_CCACHE=1
print_info "USE_CCACHE=$USE_CCACHE"
export CCACHE_DIR=$HOME/.ccache
print_info "CCACHE_DIR=$CCACHE_DIR"
ccache -M 50G

print_title "Step3. set more memory for compiler."
jackAdminPath="$lineageOSFolder/prebuilts/sdk/tools/jack-admin"
export JACK_SERVER_VM_ARGUMENTS="-Dfile.encoding=UTF-8 -XX:+TieredCompilation -Xmx4g"
print_info "JACK_SERVER_VM_ARGUMENTS=$JACK_SERVER_VM_ARGUMENTS"
$jackAdminPath kill-server && $jackAdminPath start-server

print_title "Step4. compiler android lineageOS"
cd $lineageOSFolder
print_info "now -> $PWD"
make clean
source build/envsetup.sh
lunch lineage_rpi3-$buildType
make -j$useBuildCore kernel ramdisk systemimage vendorimage