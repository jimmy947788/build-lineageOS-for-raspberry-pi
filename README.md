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
4. 建議使用SSD硬碟(下載和編譯會等到死)
   - lineage 15.1 程式碼機加上編譯後產出檔案約 70G
   - lineage 16.0 程式碼機加上編譯後產出檔案約 140G

### **運行環境(Target)**
- **Model:** Raspberry Pi 3 Model B+
  - **SoC:** Broadcom BCM2837
  - **CPU:** ARM Cortex-A53 (64Bit)
  - **RAM:** 1GB 
  - **OS:** lineage 15.1 (Android 8.1.0) \
  <img src="./documents/images/introduction-to-rpi-15-638.jpg" alt="Raspberry Pi 3 Block Diagram" width="400px"/>
- **Model:** Raspberry Pi 4 Model B 
  - **SoC:** Broadcom BCM2711
  - **CPU:** ARM Cortex-A72 (64Bit)
  - **RAM:** 4GB
  - **OS:** lineage 16.1 (Android 9)

### **操作說明文件**
+ [如何下載LineageOS程式碼](./documents/sync-lineageos-code.md)
  - branch: lineage-15.1, Device name: rpi3
  - branch: lineage-16.0, Device name: rpi4
  ```bash
  #自動化下載腳本
  $ wget https://raw.githubusercontent.com/02047788a/build-lineageOS-rpi3/master/scripts/sync-lineageos-code.sh -O sync-lineageos-code.sh
  # 執行腳本輸入提示
  # Please entry lineageOS checkout folder : (下載目錄)
  # Please entry checkout lineageOS branch : (指定分支)
  # Please entry build device name(ex:,rpi3,rpi4) : (編譯模組)
  ```
  > 輸入的變數都存在~/.profile 裡面 (**$LINEAGE_SRC, $LINEAGE_BRANCH, $DEVICE_NAME**)

+ [如何編譯LineageOS程式碼](./documents/build-lineageos-code.md)
    ```bash
    # 下載腳本到程式碼目錄
    $ wget https://raw.githubusercontent.com/02047788a/build-lineageOS-rpi3/master/scripts/build-lineageos-code.sh -O build-lineageos-code.sh
    $ sudo ./build-lineageos-code.sh #編譯全部映像kernel ramdisk systemimage vendorimage
    ```
    > 編譯後產生可安裝的image路徑: \$LINEAGE_SRC/out/target/product/rpi4/*lineage-16.0-20200201-rpi4.img**
+ 燒錄映像到SD卡
    ```bash
    $ sudo dd if=lineage-16.0-20200201-rpi4.img of=/dev/sdX status=progress bs=4M
    ```
    > /dev/sdX 是你SD卡的路徑，注意要改阿!!!

### **Android客製化修改**
- [修改預設系統設定](features/01-modify-android-property.md)
- [不要安裝預設Apps](features/02-dont-install-default-apps.md)
- [預設啟動root權限](features/03-default-enable-roots.md)
- [略過開機設定精靈](features/05-disable-setupwizard.md)
- [停用動態桌布](features/07-disable-wallpaper-service.md)
- [低記憶體設備啟用ZRAM](features/09-low-ram-use-zram.md)
- [低記憶體設備啟用LMDK](features/10-low-ram-use-lmkd.md)
- [變更螢幕尺寸大小](features/11-change-screen-size.md)

### **相關專案**
- [android_local_manifest](https://github.com/lineage-rpi/android_local_manifest) : lineage-rpi提供的說明專案
- [android_device_brcm_rpi3](https://github.com/lineage-rpi/android_device_brcm_rpi3) : Android for RPI3相關硬體韌體設定
- [android_device_brcm_rpi4](https://github.com/02047788a/android_device_brcm_rpi4) : Android for RPI4相關硬體韌體設定
- [android_kernel_brcm_rpi3](https://github.com/lineage-rpi/android_kernel_brcm_rpi3) : Android for RPI3用的的linux核心
- [android_kernel_brcm_rpi4](https://github.com/lineage-rpi/android_kernel_brcm_rpi4) : Android for RPI4用的的linux核心
- [proprietary_vendor_brcm](https://github.com/lineage-rpi/proprietary_vendor_brcm) : RPI3/4 的 framware  

### **參考資料**
- [ARM Cortex-A系列（A53、A57、A73等）处理器性能分类与对比](https://blog.csdn.net/weixin_42229404/article/details/80865138)
