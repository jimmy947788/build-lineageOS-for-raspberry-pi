#!/bin/bash
source common.sh
source config.sh

show_banner "Download lineageOS source Code"
set_environment_variable
show_config

print_title "Step1. Installing Repo"
create_folder $homeBinFolder
if [ ! -f "$homeBinFolder/repo" ] 
then
    print_warn "not found google Repo..."
    print_info "download google Repo begin..."
    curl https://storage.googleapis.com/git-repo-downloads/repo > "$homeBinFolder/repo"
    print_info "download google Repo end..."
    print_info "chahge repo file mode."
    chmod a+x "$homeBinFolder/repo"
else
    print_info "source code already exists..."
fi


print_title "Step2. Init lineageOS Repo"
create_folder $lineageOSFolder
cd $lineageOSFolder
print_info "now -> $PWD"
if [ ! -d ".repo" ]; 
then
    git config --global user.name "Jimmy Wu"
    git config --global user.email "jimmy.wu@daedalus.com.tw"
    repo init -u git://github.com/LineageOS/android.git -b $lineageVersion
fi

print_title "Step3. Downloading manifest for rpi3"
curl --create-dirs -L -o .repo/local_manifests/manifest_brcm_rpi3.xml -O -L https://raw.githubusercontent.com/lineage-rpi/android_local_manifest/$lineageVersion/manifest_brcm_rpi3.xml

print_title "Step4. Downloading the Android source tree"
repo sync -j32 #--force-sync external/swiftshader