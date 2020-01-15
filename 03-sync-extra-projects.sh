#!/bin/bash
source common.sh
source config.sh

show_banner "Sync extra projects"
set_environment_variable
show_config

MANIFETS=$1
if [ -z "$MANIFETS" ]
then
    MANIFETS="manifest_brcm_rpi3"
fi

print_title "Step1. copy manifest to source code repo"
#curl --create-dirs -L -o .repo/local_manifests/manifest_brcm_rpi3.xml -O -L https://raw.githubusercontent.com/lineage-rpi/android_local_manifest/$lineageVersion/manifest_brcm_rpi3.xml
print_info "copy $MANIFETS.xml to $lineageOSFolder/.repo/local_manifests/"
cp ./local_manifests/$MANIFETS.xml $lineageOSFolder/.repo/local_manifests/$MANIFETS.xml

print_title "Step2. Downloading extra projects"
cd $lineageOSFolder
print_info "now -> $PWD"
repo sync -j32

