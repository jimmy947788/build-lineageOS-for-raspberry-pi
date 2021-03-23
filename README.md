# Compile Android system with LineageOS
[Cyanogen](https://en.wikipedia.org/wiki/Cyanogen) is a company that customizes Android ROM, its product [CyanogenMod](https://zh.wikipedia.org/wiki/CyanogenMod)( Often referred to as "CM") is an open code system based on the Android mobile device platform. In December 2016, Cyanogen suddenly announced that it would stop development and close the project infrastructure. LineageOS was officially launched on December 24, 2016 to re-enact CyanogenMod, and its source code is stored in [GitHub](https://github.com/LineageOS)。
  
### **Development Environment (Host)**
1. The operating system uses Ubuntu 18.04
2. Install the development kit
    ```bash
    $ sudo apt-get update
    $ sudo apt-get install bc bison build-essential ccache curl flex g++-multilib gcc-multilib git gnupg gperf lib32ncurses5-dev lib32readline-dev lib32z1-dev libesd0-dev liblz4-tool libncurses5-dev libsdl1.2-dev libssl-dev libwxgtk3.0-dev libxml2 libxml2-utils lzop pngcrush rsync schedtool squashfs-tools xsltproc zip zlib1g-dev python-mako imagemagick openjdk-8-jdk gcc-arm-linux-gnueabihf
    ```           
3. OpenJDK version 1.8.0_232 
    ```bash
    # installation
    $ sudo apt-get update 
    $ sudo apt-get install openjdk-8-jdk
    # If your computer has installed many versions of JDK, specify which version of JDK to use here
    $ sudo update-alternatives --config java
    ```
4. It is recommended to use SSD hard disk (download and compile will wait until death)
   -Lineage 15.1 code machine plus compile output file about 70G
   -Lineage 16.0 code machine plus compile output file about 140G

### **Operating environment(Target)**
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

### **Operating Instructions**
+ [How to download LineageOS code](documents/guideline/sync-lineageos-code.md)
  - branch: lineage-15.1, Device name: rpi3
  - branch: lineage-16.0, Device name: rpi4
  ```bash
  #Automated download script
  $ wget https://raw.githubusercontent.com/02047788a/build-lineageOS-rpi3/master/scripts/sync-lineageos-code.sh -O sync-lineageos-code.sh
  # Execute script input prompt
  # Please entry lineageOS checkout folder : (Download catalog)
  # Please entry checkout lineageOS branch : (Designated branch)
  # Please entry build device name(ex:,rpi3,rpi4) : (Compile module)
  ```
  > All input variables exist~/.profile inside (**$LINEAGE_SRC, $LINEAGE_BRANCH, $DEVICE_NAME**)

+ [How to compile LineageOS code](documents/guideline/build-lineageos-code.md)
    ```bash
    # Download the script to the code directory
    $ wget https://raw.githubusercontent.com/02047788a/build-lineageOS-rpi3/master/scripts/build-lineageos-code.sh -O build-lineageos-code.sh
    $ sudo ./build-lineageos-code.sh #Compile all images kernel ramdisk systemimage vendorimage
    ```
    > Installable after compilation image path: \$LINEAGE_SRC/out/target/product/rpi4/*lineage-16.0-20200201-rpi4.img**
+ Burn image to SD card
    ```bash
    $ sudo dd if=lineage-16.0-20200201-rpi4.img of=/dev/sdX status=progress bs=4M
    ```
    > /dev/sdX Is the path of your SD card，Pay attention to change!!!

### **AndroidCustomized modification**
- [Android system enables root permission in Production version](documents/fetures/adb-auth-not-required-and-enable-root.md)
- [Android mount NFS](documents/fetures/android-mount-nfs.md)

### **Related projects**
- [android_local_manifest](https://github.com/lineage-rpi/android_local_manifest) : lineage-rpi Provided description items
- [android_device_brcm_rpi3](https://github.com/lineage-rpi/android_device_brcm_rpi3) : Android for RPI3 Related hardware firmware settings
- [android_device_brcm_rpi4](https://github.com/02047788a/android_device_brcm_rpi4) : Android for RPI4 Related hardware firmware settings
- [android_kernel_brcm_rpi3](https://github.com/lineage-rpi/android_kernel_brcm_rpi3) : Android for RPI3 Linux core used
- [android_kernel_brcm_rpi4](https://github.com/lineage-rpi/android_kernel_brcm_rpi4) : Android for RPI4 Linux core used
- [proprietary_vendor_brcm](https://github.com/lineage-rpi/proprietary_vendor_brcm) : RPI3/4 of framware  

### **Reference**
- [ARM Cortex-A series(A53, A57, A73, etc.) processor performance classification and comparison](https://blog.csdn.net/weixin_42229404/article/details/80865138)


### 我想找類似的工作不知道有沒有台北的工作機會???
- linkedin [連結](https://www.linkedin.com/in/daedalus1/)
- YT教學 嵌入式系統 [連結](https://www.youtube.com/playlist?list=PLwy0WTzBokTPlLXfSy9exZkYoh5GDUv82)
- YT教學 嵌入式驅動 [連結](https://www.youtube.com/playlist?list=PLwy0WTzBokTOB_8kEfzuVhTznK7q-GbVq)

> 我也懂挖礦上一份工作是用linux整合客製化一套挖礦系統OS，我也親自破解claymopre & phinexminer的 
