#!/bin/bash

################################################################################
# Help                                                                         #
################################################################################
Help()
{
    # Display Help
    echo -e "build LineageOS helper."
    echo
    echo -e "Syntax: scriptTemplate [-g|h|v|V]"
    echo -e "options:"
    echo -e "[-h|--help]     Print this Help."
    echo -e "[-i|--init]     initialize worker envvierment."
    echo -e "[-s|--sync]     synchronize repository"
    echo -e "[-b|--build]    Build source code"
    echo -e "[-d|--device]   build source code by device"
    echo -e "\tcurrent device support rpi3,rpi4"
    echo -e "[-m|--moule]    build source code by module"
    echo -e "\tmodule has (kernel|ramdisk|systemimage|vendorimage)"
    echo -e "\tno support this argument was build all modules"
    echo
    echo "example:"
    echo -e "\t./lineageos.bash --init"
    echo -e "\t./lineageos.bash --sync"
    echo -e "\t./lineageos.bash --build --device=rpi4"
    echo -e "\t./lineageos.bash --build --device=rpi4 --module=kernel ramdisk systemimage vendorimage"
}


add_path_env(){
    NEW_PATH=$1
    if grep -Fxq "export PATH=\$PATH:$NEW_PATH" $PROFILE_PATH
    then
        echo "$NEW_PATH already in PATH environment variable !"
    else
        echo "export PATH=\$PATH:$NEW_PATH" >> $PROFILE_PATH
        echo "add $NEW_PATH in PATH environment variable !"
    fi
    source $PROFILE_PATH
}

write_env(){
    local ENV_KEY=$1
    local ENV_VAL=$2
    #echo "${ENV_VAL////\\/}"
    sed -i "/export $ENV_KEY=/d" $PROFILE_PATH
    echo "export $ENV_KEY=$ENV_VAL" >> $PROFILE_PATH
    #echo "export $ENV_KEY=$ENV_VAL"
    source $PROFILE_PATH
}

read_var_frm_input(){
    local MESSAGE="$1"
    local DEFAULT="$2"
    printf "$MESSAGE 【 default: $DEFAULT 】:"
    IFS= read -r USER_INPUT
    if [ -z "${USER_INPUT}" ] 
    then
        USER_INPUT=$DEFAULT
    fi
    #echo $USER_INPUT
}

init_env(){
    # 指定lineageOS程式碼目錄
    # ===========================================================
    if [[ -z $LINEAGE_WORKER ]]
    then
        LINEAGE_WORKER="$HOME/lineageOS"
    fi
    PROMPT_MSG="Please entry lineageOS worker folder"
    read_var_frm_input "${PROMPT_MSG}" "${LINEAGE_WORKER}"
    LINEAGE_WORKER=$USER_INPUT
    write_env "LINEAGE_WORKER" $LINEAGE_WORKER

    # 指定lineageOS 分支版本
    # ===========================================================
    if [[ -z $LINEAGE_BRANCH ]]
    then
        LINEAGE_BRANCH="lineage-16.1"
    fi
    PROMPT_MSG="Please entry checkout lineageOS branch"
    read_var_frm_input "${PROMPT_MSG}" "${LINEAGE_BRANCH}"
    LINEAGE_BRANCH=$USER_INPUT
    write_env "LINEAGE_BRANCH" $LINEAGE_BRANCH

    # 設定 git global user.name
    # ===========================================================
    GIT_USER_NAME=$(git config --global user.name)
    if [[ -z $GIT_USER_NAME ]] 
    then 
        PROMPT_MSG="Please entry your git global user.name"
        DEFAULT_VAL="Your Name"
        read_var_frm_input "${PROMPT_MSG}" "${DEFAULT_VAL}"
        GIT_USER_NAME=$USER_INPUT
        git config --global user.name "$GIT_USER_NAME" 
    #else
    #    echo "git global user.name=$GIT_USER_NAME" 
    fi

    # 設定 git global user.email
    # ===========================================================
    GIT_USER_EMAIL=$(git config --global user.email)
    if [[ -z $GIT_USER_EMAIL ]] 
    then 
        PROMPT_MSG="Please entry your git global user.email"
        DEFAULT_VAL="Your email"
        read_var_frm_input "${PROMPT_MSG}" "${DEFAULT_VAL}"
        GIT_USER_EMAIL=$USER_INPUT
        git config --global user.email "$GIT_USER_EMAIL" 
    #else
    #    echo "git global user.email=$GIT_USER_EMAIL" 
    fi

    echo ""
    echo ""
    echo -e "lineageOS checkout worker is \033[1m$LINEAGE_WORKER\033[0m" 
    echo -e "lineageOS branch is \033[1m$LINEAGE_BRANCH\033[0m"

    # 建立lineageOS程式碼目錄
    # ===========================================================
    #[ -d $LINEAGE_WORKER ] && rm -rf $LINEAGE_WORKER
    [ ! -d $LINEAGE_WORKER ] && mkdir $LINEAGE_WORKER

    install_build_packges

    turnOn_caching_to_speedup_build   

    install_platform_tools

    install_repo_command
}

#https://wiki.lineageos.org/devices/bacon/build#install-the-platform-tools
install_platform_tools(){
    source $PROFILE_PATH
    echo "Install the platform-tools"
    
    if [[ ! -d $HOME/platform-tools ]]
    then
        wget https://dl.google.com/android/repository/platform-tools-latest-linux.zip -O platform-tools-latest-linux.zip
        unzip platform-tools-latest-linux.zip -d $HOME/platform-tools
    fi 

    serarch_result=$(grep -rnw "$HOME/.profile" -e "# add Android SDK platform tools to path")
    if [[ -z "$serarch_result" ]]
    then
        echo ""  >> $PROFILE_PATH
        echo ""  >> $PROFILE_PATH
        echo "# add Android SDK platform tools to path"  >> $PROFILE_PATH
        echo "if [ -d \"\$HOME/platform-tools\" ] ; then"  >> $PROFILE_PATH
        echo "    PATH=\"\$HOME/platform-tools:\$PATH\""  >> $PROFILE_PATH
        echo "fi" >> $PROFILE_PATH
        source $PROFILE_PATH
    fi
}

#https://wiki.lineageos.org/devices/bacon/build#install-the-build-packages
install_build_packges(){
    OS_VERSION=$(lsb_release -a | grep "Release" | awk '{print $2}')
    echo $OS_VERSION
    sudo apt install bc bison build-essential ccache curl flex g++-multilib gcc-multilib git gnupg gperf imagemagick lib32ncurses5-dev lib32readline-dev lib32z1-dev liblz4-tool libncurses5 libncurses5-dev libsdl1.2-dev libssl-dev libxml2 libxml2-utils lzop pngcrush rsync schedtool squashfs-tools xsltproc zip zlib1g-dev
    if [[ $OS_VERSION < 20.04 ]]
    then
        sudo apt install libwxgtk3.0-dev
    fi
}

#https://wiki.lineageos.org/devices/bacon/build#turn-on-caching-to-speed-up-build
turnOn_caching_to_speedup_build(){
    source $PROFILE_PATH
    write_env "USE_CCACHE" 1
    write_env "CCACHE_EXEC" "/usr/bin/ccache"
    write_env "CCACHE_DIR" "$HOME/.ccache"
    ccache -M 50G
    ccache -o compression=true
}

install_repo_command(){
    source $PROFILE_PATH
    # 下載Repo程式碼管理工具
    # ===========================================================
    if [ ! -d $BIN_DIR ] 
    then
        mkdir $BIN_DIR
        add_path_env $BIN_DIR
        curl https://storage.googleapis.com/git-repo-downloads/repo > $REPO_PATH
        chmod a+x $REPO_PATH
    else
        echo "folder already exits. $BIN_DIR"
    fi
    
    serarch_result=$(grep -rnw "$HOME/.profile" -e "# set PATH so it includes user's private bin if it exists")
    if [[ -z "$serarch_result" ]]
    then
        echo ""  >> $PROFILE_PATH
        echo ""  >> $PROFILE_PATH
        echo "# set PATH so it includes user's private bin if it exists"  >> $PROFILE_PATH
        echo "if [ -d \"\$HOME/bin\" ] ; then"  >> $PROFILE_PATH
        echo "    PATH=\"\$HOME/bin:\$PATH\""  >> $PROFILE_PATH
        echo "fi" >> $PROFILE_PATH
        source $PROFILE_PATH
    fi
}

sync_lineage(){
    # 進入lineageOS程式碼目錄
    # ===========================================================
    cd $LINEAGE_WORKER
    echo "entery to lineage source path : $LINEAGE_WORKER"

    # 初始化repository的分支
    # ===========================================================
    echo "init LineageOS repository for $LINEAGE_BRANCH"
    repo init -u git://github.com/LineageOS/android.git -b $LINEAGE_BRANCH 

    # 下載lineage manifests額外專案檔案
    # ===========================================================
    echo "get manifest_brcm.xml for $LINEAGE_BRANCH"
    MANIFESTS_CONTENT="https://raw.githubusercontent.com/02047788a/android_local_manifest/$LINEAGE_BRANCH/manifest_brcm.xml"
    mkdir -p "$LINEAGE_WORKER/.repo/local_manifests/"
    curl --create-dirs -L -o "$LINEAGE_WORKER/.repo/local_manifests/manifest_brcm.xml" -O -L $MANIFESTS_CONTENT

    # 開始下載程式碼
    # ===========================================================
    repo sync -j$(nproc --all) #使用CPU最大thread數來下載
}

build_lineage(){
    echo "lineage_$DEVICE-userdebug"
    cd $LINEAGE_WORKER
    source build/envsetup.sh
    lunch lineage_$DEVICE-userdebug
    make -j$(nproc --all) $MODULE
}


BIN_DIR=$HOME/bin
REPO_PATH=$BIN_DIR/repo
PROFILE_PATH=$HOME/.profile
#echo "PROFILE_PATH=$PROFILE_PATH"
source $PROFILE_PATH

DEFAULT=NO  
for i in "$@"  
do  
case $1 in  
    -h|--help)  
    Help    
    ;; 
    -i|--init)    
    ARG_INIT="y"
    ;;
    -s|--sync)
    ARG_SYNC="y"
    ;;
    -b|--build)  
    ARG_BUILD="y"
    shift  
    ;;  
    -d=*|--device=*)  
    DEVICE="${i#*=}"  
    shift  
    ;;
    -m=*|--module=*)  
    MODULE="${i#*=}"  
    shift  
    ;;
    --default)  
    Help  
    shift  
    ;;  
    *)  
    # Unknown option  
    ;;  
esac  
done  

if [[ ! -z $ARG_INIT ]];
then 
    init_env
    exit 0
fi

if [[ ! -z $ARG_SYNC ]];
then 
    sync_lineage
    exit 0
fi

if [[ ! -z $ARG_BUILD ]]; 
then  
    if [[ -z $DEVICE ]];
    then
        echo "must be support device name, example:"
        echo -e "\t./lineageos.bash --build --device=rpi4"
        exit 22 #Invalid argument
    fi 

    if [[ -z $MODULE ]]; 
    then 
        MODULE="kernel ramdisk systemimage vendorimage"
    fi
    build_lineage
    exit 0
fi

if [ -z $ARG_INIT ] && [ -z $ARG_BUILD ] && [ -z $ARG_BUILD ]
then
    Help
fi