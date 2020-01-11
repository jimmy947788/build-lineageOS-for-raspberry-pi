#!/bin/bash
source common.sh
source config.sh

show_banner "Build ImageMagick"
set_environment_variable
show_config

CLEAN=$1
if [ $CLEAN == "clean" ]
then
    print_info "clean build file."
    cd $imageMagickFolder
    make clean

    print_info "remove build artifacts."
    cd $imageMagickBuildFolder
    echo "rm -rf bin etc include lib share"
    rm -rf bin etc include lib share
else
    print_title "Step1. clone ImageMagick source code"
    create_folder $imageMagickFolder

    print_info "change to source code folder..."
    cd $imageMagickFolder
    print_info "now -> $PWD"

    if [ -d .git ]; 
    then
        print_info "source code already exists..."
    else
        print_warn "not found source code..."
        print_info "git clone source begin..."
        git clone https://github.com/ImageMagick/ImageMagick.git .
        print_info "git clone source end..."
    fi

    print_title "Step2. build ImageMagick source code"
    print_info "config build script."
    ./configure --prefix=$imageMagickBuildFolder

    print_info "build ImageMagic source code."
    make -j12

    print_info "output ImageMagic artifacts."
    make install
fi