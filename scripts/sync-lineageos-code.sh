#!/bin/bash

add_path_env(){
    NEW_PATH=$1
    if grep -Fxq "export PATH=\$PATH:$NEW_PATH" $PROFILE_PATH
    then
        echo "$NEW_PATH already in PATH environment variable !"
    else
        echo "export PATH=\$PATH:$NEW_PATH" >> $PROFILE_PATH
        source $PROFILE_PATH
        echo "add $NEW_PATH in PATH environment variable !"
    fi
}

add_lineageOS_folder_env(){
    NEW_PATH=$1
    if grep -Fxq "export LINEAGEOS_DIR=$NEW_PATH" $PROFILE_PATH
    then
        echo "environment variable LINEAGEOS_DIR already exites, values is $LINEAGEOS_DIR"
    else
        echo "export LINEAGEOS_DIR=$NEW_PATH" >> $PROFILE_PATH
        source $PROFILE_PATH
        echo "environment variable LINEAGEOS_DIR not exites, add with values $LINEAGEOS_DIR"
    fi
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
# 指定lineageOS程式碼目錄
# ===========================================================
PROMPT_MSG="Please entry lineageOS checkout folder"
DEFAULT_VAL="$HOME/lineageOS"
read_var_frm_input "${PROMPT_MSG}" "${DEFAULT_VAL}"
LINEAGEOS_DIR=$USER_INPUT
echo "lineageOS checkout forder is $LINEAGEOS_DIR" 
add_lineageOS_folder_env $LINEAGEOS_DIR

# 指定lineageOS 分支版本
# ===========================================================
PROMPT_MSG="Please entry checkout lineageOS branch"
DEFAULT_VAL="lineage-15.1"
read_var_frm_input "${PROMPT_MSG}" "${DEFAULT_VAL}"
GIT_BRANCH=$USER_INPUT
echo "lineageOS branch is $GIT_BRANCH"

# 設定 git global user.name
# ===========================================================
PROMPT_MSG="Please entry your git global user.name"
DEFAULT_VAL="Your Name"
read_var_frm_input "${PROMPT_MSG}" "${DEFAULT_VAL}"
GIT_USERNAME=$USER_INPUT
echo "git global user.name=$GIT_USERNAME" 

# 設定 git global user.email
# ===========================================================
PROMPT_MSG="Please entry your git global user.email"
DEFAULT_VAL="you@example.com"
read_var_frm_input "${PROMPT_MSG}" "${DEFAULT_VAL}"
GIT_USEREMAIL=$USER_INPUT
echo "git global user.email=$GIT_USEREMAIL"


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
if [ ! -d $LINEAGEOS_DIR ] 
then
    mkdir $LINEAGEOS_DIR
fi

# 進入lineageOS程式碼目錄
# ===========================================================
cd $LINEAGEOS_DIR
echo "Current path is $LINEAGEOS_DIR"


# 設定 git global user.name
# ===========================================================
if [ -z $(git config --global user.name) ] 
then
    git config --global user.name "$GIT_USER_NAME"        
fi
echo "your git global user.name is $(git config --global user.name)"

# 設定 git global user.email
# ===========================================================
if [ -z $(git config --global user.email) ] 
then
    git config --global user.email "$GIT_USER_EMAIL"
fi
echo "your git global user.email is $(git config --global user.email)"

# 初始化repository的分支
# ===========================================================
repo init -u git://github.com/LineageOS/android.git -b $GIT_BRANCH

# 加入raspberry pi額外專案
# ===========================================================
mkdir $LINEAGEOS_DIR/.repo/local_manifests
wget https://raw.githubusercontent.com/02047788a/build-lineageOS-rpi3/master/manifests/manifest_brcm_rpi.xml -O $LINEAGEOS_DIR/.repo/local_manifests/manifest_brcm_rpi.xml


# 開始下載程式碼
# ===========================================================
repo sync -j32