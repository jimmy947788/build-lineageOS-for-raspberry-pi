#!/bin/bash
workerFolder="/usr/developer/android-lineage-rpi"
imageMagickFolder="$workerFolder/ImageMagick"
imageMagickBuildFolder="$imageMagickFolder/build"
homeBinFolder="$HOME/bin"
lineageOSFolder="$workerFolder/lineageOS"
lineageVersion="lineage-15.1"
useBuildCore=12
buildTarget="lineage_rpi3"
buildType="userdebug" #user,userdebug,eng   #https://source.android.com/setup/build/building#choose-a-target