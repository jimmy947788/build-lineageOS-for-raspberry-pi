# 用LineageOS編譯Android系統 
[Cyanogen](https://en.wikipedia.org/wiki/Cyanogen)是一間客製化 Android ROM 的公司，旗下產品[CyanogenMod](https://zh.wikipedia.org/wiki/CyanogenMod)（常簡稱為「CM」）是一個基於Android行動裝置平台的開放程式碼系統，它在2016年12月Cyanogen公司突然宣布停止開發並關閉專案基礎設施。LineageOS於2016年12月24日正式啟動就是復刻CyanogenMod，其原始碼存放於[GitHub](https://github.com/LineageOS)。
  
### **開發環境(Host)**
1. 作業系統使用 Ubuntu 18.04
2. 安裝開發套件
    ```bash
    $ sudo apt-get update
    $ sudo apt-get install bc bison build-essential ccache curl flex g++-multilib gcc-multilib git gnupg gperf lib32ncurses5-dev lib32readline-dev lib32z1-dev libesd0-dev liblz4-tool libncurses5-dev libsdl1.2-dev libssl-dev libwxgtk3.0-dev libxml2 libxml2-utils lzop pngcrush rsync schedtool squashfs-tools xsltproc zip zlib1g-dev python-mako imagemagick openjdk-8-jdk gcc-arm-linux-gnueabihf
    ```           
3. OpenJDK version 1.8.0_232 
    ```bash
    # 安裝
    $ sudo apt-get update 
    $ sudo apt-get install openjdk-8-jdk
    # 如果你電腦已經有安裝很多版本JDK，這裡指定要用哪一個版本的JDK
    $ sudo update-alternatives --config java
    ```
    

### **運行環境(Target)**
- **Model:** Raspberry Pi Model 3B V1.2 
- **SoC:** Broadcom BCM2837
- **CPU:** ARM Cortex-A53 (64Bit)
- **記憶體:** 1GB LPDDR2（和 GPU 共享）
- **OS:** lineage 15.1 (Android 8.1.0) \
<img src="./documents/images/introduction-to-rpi-15-638.jpg" alt="Raspberry Pi 3 Block Diagram" width="400px"/>

### 下載 LineageOS 程式碼
1. **安裝Repo工具**
    ```bash
    #建立bin目錄存放Repo
    $ mkdir ~/bin
    $ PATH=~/bin:$PATH
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
    > repo init 會在~/lineageOS目錄下建立一個.repo/目錄，.repo/目錄下manifest.xml這個檔案就是[.repo/manifests/default.xml](manifests/default.xml)的連結，內容就包含了建構lineageOS所要用到的專案清單。
3. **下載程式碼**
   ```bash
   # 同步遠端程式碼到client端
   $ repo sync -j32 #-j32:是指用32條執行緒下載
   ```
   > 開始下載 repository 大約 66G

4. **下載raspberry pi 3需要的專案**
   ```bash
   $ mkdir .repo/local_manifests #Repo 1.9.1 has a new feature. 
   $ wget https://raw.githubusercontent.com/02047788a/build-lineageOS-rpi3/master/manifests/manifest_brcm_rpi3.xml -O .repo/local_manifests/manifest_brcm_rpi3.xml
   $ repo sync -j32 --force-sync
   ```
   > Repo 1.9.1 開始要把新增的[manifest_brcm_rpi3.xml](manifests/manifest_brcm_rpi3.xml)放到.repo/local_manifests資料夾下面
5. **建立一個新的分支** *(用這個分支開發)*
   ```bash
   # 分支名稱:lineageOS-rpi3
   # --all 新分支包含所有的專案
   $ repo start lineageOS-rpi3 --all
   ```
6. **Repo 常用指令**
    ```bash
    $ repo abandon <BRANCH_NAME> #刪除分支
    $ repo branches #列出分支 
    $ repo start <BRANCH_NAME> [<PROJECT_LIST>] #新增分支 [專案]
    $ repo checkout <BRANCH_NAME> #切換分支 
    ```
    #### 參考文件
    - [LineageOS 維基百科](https://zh.wikipedia.org/wiki/LineageOS)
    - [LineageOS 官方網頁](https://www.lineageos.org/)
    - [LineageOS 官方維基](https://wiki.lineageos.org/)
    - [LineageOS Github](https://github.com/LineageOS/)
    - [Raspberry Pi 3 Model B+ 規格](https://www.raspberrypi.com.tw/10684/55/)
    - [LineageOS的所有分支](https://github.com/LineageOS/android/branches/all)
    - [Repo 命令参考资料](https://source.android.google.cn/setup/using-repo.html)
    - [Android Local Manifests机制的使用实践](https://duanqz.github.io/2016-04-15-Android-Local-Manifests-Practice)

### 編譯 LineageOS 程式碼
1. **設定compile cache**
    ```bash
    $ export USE_CCACHE=1
    $ export CCACHE_DIR=$HOME/.ccache
    $ ccache -M 50G
    ```
2. **給編譯時期更多記憶體**
    ```bash
    $ PATH=~/lineageOS/prebuilts/sdk/tools:$PATH
    $ export JACK_SERVER_VM_ARGUMENTS="-Dfile.encoding=UTF-8 -XX:+TieredCompilation -Xmx4g"
    $ jack-admin kill-server && jack-admin start-server
    ```
3. **載入編譯環境變數**
    ```bash
    $ source build/envsetup.sh
    $ lunch lineage_rpi3-userdebug
    ```
    > eng：工程版本, user：发行版本, userdebug：部分调试版本

4. **編譯全部專案**
    ```bash
    $ make -j12 kernel ramdisk systemimage vendorimage
    ```
5. **打包可以燒錄的映像檔**
    ```bash
    $ cd ~/lineageOS/device/brcm/rpi3/
    $ sudo ./mkimg.sh
    ```
6. **自動編譯腳本**
    ```bash
    # 下載腳本到程式碼目錄
    $ wget https://raw.githubusercontent.com/02047788a/build-lineageOS-rpi3/master/build-lineage-rpi3.sh -O ~/lineageOS/build-lineage-rpi3.sh
    $ sudo ./build-lineage-rpi3.sh #編譯全部映像kernel ramdisk systemimage vendorimage
    $ sudo ./build-lineage-rpi3.sh kernel #單獨編譯linux kernel
    $ sudo ./build-lineage-rpi3.sh ramdisk #單獨編譯ramdisk
    $ sudo ./build-lineage-rpi3.sh systemimage #單獨編譯systemimage
    $ sudo ./build-lineage-rpi3.sh vendorimage #單獨編譯vendorimage
    ```
    可燒錄映像最後輸出
    ~/lineageOS/out/target/product/rpi3/lineage-15.1-{date}-rpi3.img
7. **燒錄映像到SD卡**
    ```bash
    $ sudo dd if=lineage-15.1-{date}-rpi3.img of=/dev/sdX status=progress bs=4M
    ```

#### 參考文件
- [編譯版本 Using build variants](https://source.android.com/setup/develop/new-device#build-variants)