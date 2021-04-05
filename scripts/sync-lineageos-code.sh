#!/bin/bash

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
    echo "export $ENV_KEY=$ENV_VAL"
}

BIN_DIR=$HOME/bin
REPO_PATH=$BIN_DIR/repo
PROFILE_PATH=$HOME/.profile

read_var_frm_input(){
    local MESSAGE="$1"
    local DEFAULT="$2"
    printf "$MESSAGE (default: $DEFAULT):"
    IFS= read -r USER_INPUT
    if [ -z "${USER_INPUT}" ] 
    then
        USER_INPUT=$DEFAULT
    fi
    #echo $USER_INPUT
}

source $PROFILE_PATH
MOD=$1
if [[ "$MOD" = "init" ]]
then
    # 指定lineageOS程式碼目錄
    # ===========================================================
    if [[ -z $LINEAGE_SRC ]]
    then
        LINEAGE_SRC="$HOME/lineageOS"
    fi
    PROMPT_MSG="Please entry lineageOS checkout folder:"
    read_var_frm_input "${PROMPT_MSG}" "${LINEAGE_SRC}"
    LINEAGE_SRC=$USER_INPUT
    echo "lineageOS checkout forder is $LINEAGE_SRC" 
    write_env "LINEAGE_SRC" $LINEAGE_SRC

    # 指定lineageOS 分支版本
    # ===========================================================
    if [[ -z $LINEAGE_BRANCH ]]
    then
        LINEAGE_BRANCH="lineage-15.1"
    fi
    PROMPT_MSG="Please entry checkout lineageOS branch:"
    read_var_frm_input "${PROMPT_MSG}" "${LINEAGE_BRANCH}"
    LINEAGE_BRANCH=$USER_INPUT
    echo "lineageOS branch is $LINEAGE_BRANCH"
    write_env "LINEAGE_BRANCH" $LINEAGE_BRANCH

    # 指定lineageOS 分支版本
    # ===========================================================
    if [[ -z $DEVICE_NAME ]]
    then
        DEVICE_NAME="rpi3"
    fi
    PROMPT_MSG="Please entry build device name (ex:rpi3,rpi4)"
    read_var_frm_input "${PROMPT_MSG}" "${DEVICE_NAME}"
    DEVICE_NAME=$USER_INPUT
    #echo "build device name is $DEVICE_NAME"
    write_env "DEVICE_NAME" $DEVICE_NAME

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
    else
        echo "git global user.name=$GIT_USER_NAME" 
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
    else
        echo "git global user.email=$GIT_USER_EMAIL" 
    fi


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

    # 建立lineageOS程式碼目錄
    # ===========================================================
    [ -d $LINEAGE_SRC ] && rm -rf $LINEAGE_SRC
    mkdir $LINEAGE_SRC

    # 進入lineageOS程式碼目錄
    # ===========================================================
    cd $LINEAGE_SRC
    echo "entery to lineage source path : $LINEAGE_SRC"

    # 初始化repository的分支
    # ===========================================================
    echo "init LineageOS repository for $LINEAGE_BRANCH"
    repo init -u git://github.com/LineageOS/android.git -b $LINEAGE_BRANCH 

    # 下載lineage manifests額外專案檔案
    # ===========================================================
    if [ ! -z "$DEVICE_NAME" ]
    then
        src="/home/jimmywu/Developer/Projects/build-lineageOS-for-raspberry-pi/manifests/manifest_brcm_rpi4_lineage18.1.xml"
        des="$LINEAGE_SRC/.repo/local_manifests/manifest_brcm_$DEVICE_NAME.xml"
        mkdir -p .repo/local_manifests
        cp $src $des
        #GITHUB_MANIFESTS_CONTENT="https://raw.githubusercontent.com/02047788a/build-lineageOS-rpi3/master/manifests"
        #echo "get $INEAGE_BRANCH manifests for $DEVICE_NAME"
        #curl --create-dirs -L -o .repo/local_manifests/manifest_brcm_$DEVICE_NAME.xml -O -L $GITHUB_MANIFESTS_CONTENT/manifest_brcm_$DEVICE_NAME.xml
    fi


    # 開始下載程式碼
    # ===========================================================
    repo sync -j$(nproc --all) #使用CPU最大thread數來下載
else
    if [[ "$MOD" = "clean" ]]
    then
        echo "$MOD"
    fi
fi
