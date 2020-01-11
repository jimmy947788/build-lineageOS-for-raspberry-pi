#!/bin/bash

print_title () {
    echo ""
    printf "\E[1;32;49m$1\E[0m\n"
}

print_info () {
    printf "\E[0;32;49m[INFO]\E[0m $1\n"
}

print_warn () {
    printf "\E[0;33;49m[WARN]\E[0m $1\n"
}

print_variable() {
    padding_formate="%-20s"
    printf "\E[0;36;49m$padding_formate = \E[0m" "$1"
    printf "\E[0;37;49m$2\E[0m\n"
}

create_folder()
{
    if [ ! -d $1 ] 
    then
        print_info "create foilder $1"
        mkdir $1
    else
        print_info "folder already exits. $1"
    fi
}

print_space(){
    length=$1
    printf ' %.0s' $(seq 1 $length)
}

show_banner(){
    script_name=$1
    script_name_len=${#script_name}
    banner_width=80
    banner_width_char="$(printf '=%.0s' $(seq 1 $banner_width))"
    
    printf "\E[1;96;49m"
    # line 1
    printf "%s\n" $banner_width_char
    # line 2
    line2_space_len=$(expr $banner_width - 2)
    printf "=%s=\n" "$(print_space $line2_space_len)"

    # line 3
    space_len=$((banner_width-script_name_len-2))
    left_space_len=$((space_len / 2))
    padding_left="$(print_space $left_space_len)"
    padding_right="$(print_space $left_space_len)"
    script_name_total_len=$((2 + left_space_len + script_name_len + left_space_len + 2))
    if [ $script_name_total_len -gt $banner_width ]
    then
        padding_left="$(print_space $(expr $left_space_len - 1))"
    fi
    printf "=%s %s %s=\n" "$padding_left" "$script_name" "$padding_right"

    # line 4
    line2_space_len=$(expr $banner_width - 2)
    printf "=%s=\n" "$(print_space $line2_space_len)"

    # line 5
    printf "%s\n" $banner_width_char
    printf "\E[0m\n"
}

set_environment_variable(){
    print_title "set environment variable"
    export "JAVA_HOME=$lineageOSFolder/prebuilts/jdk/jdk8/linux-x86"
    export "PATH=$PATH:$JAVA_HOME/bin:$imageMagickBuildFolder/bin:$homeBinFolder"
    export "CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar"
    echo "JAVA_HOME=$JAVA_HOME"
    echo "PATH=$PATH"
    echo "CLASSPATH=$CLASSPATH"
}


show_config(){
    print_variable "workerFolder" $workerFolder
    print_variable "imageMagickFolder" $imageMagickFolder
    print_variable "imageMagickBuildFolder" $imageMagickBuildFolder
    print_variable "homeBinFolder" $homeBinFolder
    print_variable "lineageOSFolder" $lineageOSFolder
    print_variable "lineageVersion" $lineageVersion
    print_variable "useBuildCore" $useBuildCore
    print_variable "buildType" $buildType
}