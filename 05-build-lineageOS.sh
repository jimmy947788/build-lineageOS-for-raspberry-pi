#!/bin/bash
source common.sh
source config.sh

show_banner "Build lineageOS"
set_environment_variable
show_config


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
lunch $buildTarget-$buildType
make -j$useBuildCore kernel ramdisk systemimage vendorimage