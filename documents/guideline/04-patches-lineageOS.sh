#!/bin/bash
source common.sh
source config.sh

show_banner "patchs lineageOS"
set_environment_variable
show_config

print_title "Step1. patch lineageOS"
patchesFolder="$PWD"
print_info "01 patch modify generic keyboard layout"
cd $lineageOSFolder/frameworks/base
git am $patchesFolder/patches/frameworks_base/0001-rpi3-modify-generic-keyboard-layout.patch 
print_info "02 patch disable adb authentication by default"
cd $lineageOSFolder/vendor/lineage
git am $patchesFolder/patches/vendor_lineage/0001-disable-adb-authentication-by-default.patch
