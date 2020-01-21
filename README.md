# 用LineageOS編譯Android系統 
客製化 Android ROM 的公司 Cyanogen 旗下產品CyanogenMod（常簡稱為「CM」）是一個基於Android行動裝置平台的開放程式碼系統，它在2016年12月Cyanogen公司突然宣布停止開發並關閉專案基礎設施後復刻而生。LineageOS於2016年12月24日正式啟動，其原始碼存放於[GitHub](https://github.com/LineageOS)。

+ **開發環境(Host)**
    - Ubuntu 18.04
    - 安裝開發套件
    
    ```bash
    $ sudo apt-get update
    $ sudo apt-get install bc bison build-essential ccache curl flex g++-multilib gcc-multilib git gnupg gperf lib32ncurses5-dev lib32readline-dev lib32z1-dev libesd0-dev liblz4-tool libncurses5-dev libsdl1.2-dev libssl-dev libwxgtk3.0-dev libxml2 libxml2-utils lzop pngcrush rsync schedtool squashfs-tools xsltproc zip zlib1g-dev python-mako imagemagick openjdk-8-jdk gcc-arm-linux-gnueabihf
    ```
    - OpenJDK version 1.8.0_232 
    ```bash
    # 安裝
    $ sudo apt-get update 
    $ sudo apt-get install openjdk-8-jdk
    # 如果你電腦有很多版本JAVA，設定要用哪一個版本的java
    $ sudo update-alternatives --config java
    ```
    

+ **運行環境(Target)**
    - **Model:** Raspberry Pi Model 3B V1.2 
    - **SoC:** BCM2837B0
    - **CPU:** ARM Cortex-A53 (64Bit)
    - **記憶體:** 1GB LPDDR2（和 GPU 共享）



### 下載 LineageOS 程式碼  

#### 參考文件
[LineageOS-1.5 (Android 8)](https://konstakang.com/devices/rpi3/LineageOS15.1/)
