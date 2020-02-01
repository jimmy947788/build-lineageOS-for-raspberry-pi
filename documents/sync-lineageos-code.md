### 下載 LineageOS 程式碼
1. **安裝Repo工具**
    ```bash
    #建立bin目錄存放Repo
    $ mkdir ~/bin
    $ export PATH=~/bin:$PATH
    #下載Repo工具
    $ curl https://storage.googleapis.com/git-repo-downloads/repo > ~/bin/repo
    $ chmod a+x ~/bin/repo
    ```
    > Repo 是google用來管理複合式程式碼的工具，一套Android裡面包含很多不同的專案構成
2. **初始化Repo client端**
    ```bash
    # 建立程式碼目錄
    $ mkdir ~/lineageOS
    $ cd ~/lineageOS
    ```
    > ~/lineageOS 是我的主要程式碼工作目錄，你們可以自己定義
    ```bash
    # 設定git名稱和信箱
    $ git config --global user.name "Your Name"
    $ git config --global user.email "you@example.com"
    # 在目前目錄初始化一個client端，指定repository分支lineage-15.1
    $ repo init -u git://github.com/LineageOS/android.git -b lineage-15.1
    ```
    > LineageOS 的所有分支請參閱 [github branches](https://github.com/LineageOS/android/branches/all)
    
3. **下載raspberry pi需要的額外專案** \
   repo init 會在程式碼工作目錄下建立一個.repo目錄，.repo目錄下manifest.xml這個檔案就是.repo/manifests/[default.xml](../manifests/default.xml)的連結，內容就包含了建構lineageOS必要用到的專案清單。\
   這裡需要額外定義一個要編譯Raspberry Pi 的額外要下載的manifests.xml。\
   [LineageOS-rpi](https://github.com/lineage-rpi)目前只有提供到RPI3的[manifest_brcm_rpi3.xml](https://github.com/lineage-rpi/android_local_manifest/blob/lineage-15.1/manifest_brcm_rpi3.xml)。\
   我這提供了調整好了可以編譯RPI4的[manifest_brcm_rpi4.xml](https://github.com/02047788a/build-lineageOS-for-raspberry-pi/blob/master/manifests/manifest_brcm_rpi4.xml)
   ```bash
   $ mkdir .repo/local_manifests #Repo 1.9.1 has a new feature. 
   $ wget https://raw.githubusercontent.com/02047788a/build-lineageOS-rpi3/master/manifests/manifest_brcm_rpi3.xml -O .repo/local_manifests/manifest_brcm_rpi3.xml
   ```
   > Repo 1.9.1 開始要把新增的manifest_brcm_rpi3.xml放到指定目錄.repo/local_manifests下面。
4. **下載程式碼** \
   這裡注意一下 repository 大約 66G，加上編譯產出檔案還有ccache最好準備100G的SSD硬碟空間
   ```bash
   $ repo sync -j32 #-j32:是指用32條執行緒下載
   ```
   > -j32:是指用32條執行緒下載

#### Repo 常用指令
```bash
$ repo abandon <BRANCH_NAME> #刪除分支
$ repo branches #列出分支 
$ repo start <BRANCH_NAME> [<PROJECT_LIST>] #新增分支 [專案]
$ repo checkout <BRANCH_NAME> #切換分支 
$ repo forall -vc "git reset --hard" #還原變更
```
> Repo 命令参考资料 https://source.android.google.cn/setup/using-repo.html

#### 參考文件
 - [LineageOS 維基百科](https://zh.wikipedia.org/wiki/LineageOS)
 - [LineageOS 官方網頁](https://www.lineageos.org/)
 - [LineageOS 官方維基](https://wiki.lineageos.org/)
 - [LineageOS Github](https://github.com/LineageOS/)
 - [LineageOS-rpi Github](https://github.com/lineage-rpi)
 - [LineageOS branches](https://github.com/LineageOS/android/branches/all)
 - [Raspberry Pi 規格 (維基百科)](https://en.wikipedia.org/wiki/Raspberry_Pi#Specifications)
 - [Android Local Manifests机制的使用实践](https://duanqz.github.io/2016-04-15-Android-Local-Manifests-Practice)