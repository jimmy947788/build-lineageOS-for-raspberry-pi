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

### **操作說明文件**
- [下載 LineageOS 程式碼](./documents/sync-lineageos-code.md)
- [編譯 LineageOS 程式碼](./documents/build-lineageos-code.md)
- 打上RPI3補丁

### **Android客製化修改**
- 修改預設系統設定
- 不要安裝預設Apps
- 預設啟動root權限
- 略過開機設定精靈
- 停用動態桌布
- 低記憶體設備啟用ZRAM
- 低記憶體設備啟用LMDK
- 變更螢幕尺寸大小
