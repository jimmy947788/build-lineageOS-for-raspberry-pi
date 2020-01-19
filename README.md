# 針對 raspberry pi 3 編譯 LineageOS

## Host 開發環境

1. Ubuntu 18.04 kernel 5.0.0-37-generic
2. 安裝套件

```bash
sudo apt-get update
sudo apt-get install bc bison build-essential ccache curl flex g++-multilib gcc-multilib git gnupg gperf lib32ncurses5-dev lib32readline-dev lib32z1-dev libesd0-dev liblz4-tool libncurses5-dev libsdl1.2-dev libssl-dev libwxgtk3.0-dev libxml2 libxml2-utils lzop pngcrush rsync schedtool squashfs-tools xsltproc zip zlib1g-dev python-mako imagemagick openjdk-8-jdk gcc-arm-linux-gnueabihf
```

3. OpenJDK version 1.8.0_232

## Target 運行環境

1. Raspberry Pi Model 3B  V1.2 
2. ARMv7l 架構 bcm2837rifbg
3. LineageOS-1.5 (Android 8) [參考](https://konstakang.com/devices/rpi3/LineageOS15.1/)

## 01. ImageMagic

這是一套繪圖軟體，LineageOS 使用它來產生一些動畫效果，在編譯階段會需要用到(但是我個人感覺沒用到)

```bash
$> ./01_build-ImageMagick.sh
```

## 02. 下載官方 LineageOS 程式碼

去 google 的 repo 用 git 下載全套程式碼 _(大約 66 GB)_

```bash
$> ./02-sync-lineageOS.sh
```

> 可以到./config.sh 的**lineageVersion**變數去改下載版本

## 03. 下載 LineageOS 擴充專案

可以定義 manifests.xml 來擴充 lineageOS 所需要的專案/模組
* Raspberry pi3 [manifests.xml](https://github.com/lineage-rpi/android_local_manifest/blob/lineage-15.1/manifest_brcm_rpi3.xml)
* Raspberry pi4 [manifests.xml](https://github.com/csimmonds/a4rpi-local-manifest/blob/pie/default.xml)
```bash
$> ./03-sync-extra-projects.sh
```

> 這裡預設是用[lineage-rpi](https://github.com/lineage-rpi/android_local_manifest)專為 raspberry pi 3 所提供的 manifest_brcm_rpi3.xml

## 05. LineageOS 打上補丁

程式碼補丁必須要再編之前先打上,補丁都放在 patches 資料夾內

- **generic-keyboard-layout** 修改鍵盤layout 
- **disable-adb-authentication** 停用ADB驗證
```bash
$> ./04-patches-lineageOS.sh
```
> 這裡是用[lineage-rpi](https://github.com/lineage-rpi/android_local_manifest)題供的補丁

## 06. 建制 LineageOS 程式碼

編譯產出

- **zImage** 這是 linux kernel 程式碼提供的版本為 4.14.66-v7
- **system.img** 這是 Android 系統資料 裏面會用到到檔案&應用程式&函數庫
- **ramdisk.img** 這是 Android 的 root filesystem
- **vendor.img** 這是 OEM 廠商私有的映像檔，主要包含和硬體相關的程式及函式庫，以及硬體啟動時所需的設定檔

```bash
$> ./06-build-lineageOS.sh
```

## 客製化修改
- [修改Android系統設定](lesson/01-modify-android-property.md)
- [不要安裝內建APPS](lesson/02-dont_install_default_apps.md)
- [預設啟用root權限](lesson/03-default-enable-roots.md)
- [預設wifi連線密碼](lesson/04.default_wifi_setting.md)
- [開機不要執行設定精靈](lesson/05-disable-setupwizard.md) 

## 其他文件
- [BCM2835-ARM-Peripherals](documents/BCM2835-ARM-Peripherals.pdf)
- [linux開機啟動流程](documents/linux-boot-process.md)
- [android開機啟動流程](documents/android-boot-process.md)
