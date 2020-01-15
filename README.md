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

1. Raspberry Pi 3 (mdoel B)
2. ARMv7l 架構 bcm2837rifbg
3. LineageOS-1.5 (Android 8) [參考](https://konstakang.com/devices/rpi3/LineageOS15.1/)

## 01. 建制 ImageMagic

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

## build LineageOS source code

編譯出 zImage system.img ramdisk.img vendor.img

- **zImage** 這是 linux kernel 程式碼提供的版本為 4.14.66-v7
- **system.img** 這是 Android 系統資料 裏面會用到到檔案&應用程式&函數庫
- **ramdisk.img** 這是 Android 的 root filesystem
- **vendor.img** 這是 OEM 廠商私有的映像檔，主要包含和硬體相關的程式及函式庫，以及硬體啟動時所需的設定檔

```bash
$> ./03-build-lineageOS.sh
```

### linux kernel compile config

> kernel/brcm/rpi3/arch/arm/configs/LineageOS_rpi3_defconfig

### 設定國家和時區

```bash
# 修改檔案: device/brcm/rip3/system.prop
# 加入設定國家和時區
persist.sys.language=zh
persist.sys.country=TW
persist.sys.localevar=
persist.sys.timezone=Asia/Taipei
ro.product.locale.language=zh
ro.product.locale.region=CN
```

### 啟用 root 權限

#### 1.修改 ro.adb.secure 和 ro.secure 属性

```bash
# 修改檔案: build/core/main.mk

# Target is secure in user builds.
ADDITIONAL_DEFAULT_PROPERTIES += ro.secure=0 #改成0
ADDITIONAL_DEFAULT_PROPERTIES += security.perf_harden=1

ifeq ($(user_variant),user)
    ADDITIONAL_DEFAULT_PROPERTIES += ro.adb.secure=0 #改成0
endif

ifeq ($(user_variant),userdebug)
    # Pick up some extra useful tools
    tags_to_install += debug
else
    # Disable debugging in plain user builds.
    #enable_target_debugging := #註解掉
endif
```

#### 2.修改 selinux

```cpp
// 修改檔案: system/core/init/init.cpp

/*
static selinux_enforcing_status selinux_status_from_cmdline() {
    ...
*/
static bool selinux_is_enforcing(void)
{
    return false; #新增
}
```

#### 3.修改 adb 模块的 android.mk 文件

```bash
# 修改檔案: system/core/adb/Android.mk

#LOCAL_CFLAGS += -DALLOW_ADBD_NO_AUTH=$(if $(filter userdebug eng,$(TARGET_BUILD_VARIANT)),1,0)
LOCAL_CFLAGS += -DALLOW_ADBD_NO_AUTH=$(if $(filter user userdebug eng,$(TARGET_BUILD_VARIANT)),1,0

#ifneq (,$(filter userdebug eng,$(TARGET_BUILD_VARIANT)))
ifneq (,$(filter user userdebug eng,$(TARGET_BUILD_VARIANT)))
```

#### 4.啟動圖形加速

```bash
# 修改檔案:  device/brcm/rpi3/boot/config.txt
# Graphics acceleration
#dtoverlay=vc4-fkms-v3d,cma-256
dtoverlay=vc4-kms-v3d,cma-256
mask_gpu_interrupt0=0x400
avoid_warnings=2
```

#### 4.關閉動態桌布

```xml
<!--修改檔案: frameworks/base/core/res/res/values/config.xml  -->
<!-- True if WallpaperService is enabled -->
<bool name="config_enableWallpaperService">false</bool>
```

```java
//修改檔案: frameworks/base/packages/SystemUI/src/com/android/systemui/statusbar/phone/StatusBarWindowManager.java
private void applyKeyguardFlags(State state) {
    /*
    if (state.keyguardShowing) {
        mLpChanged.privateFlags |= WindowManager.LayoutParams.PRIVATE_FLAG_KEYGUARD;
    } else {
        mLpChanged.privateFlags &= ~WindowManager.LayoutParams.PRIVATE_FLAG_KEYGUARD;
    }

    if (state.keyguardShowing && !state.backdropShowing && !state.dozing) {
        mLpChanged.flags |= WindowManager.LayoutParams.FLAG_SHOW_WALLPAPER;
    } else {
        mLpChanged.flags &= ~WindowManager.LayoutParams.FLAG_SHOW_WALLPAPER;
    }*/
    // we don't need keyguard display
    mLpChanged.flags &= ~WindowManager.LayoutParams.FLAG_SHOW_WALLPAPER;
    mLpChanged.privateFlags &= ~WindowManager.LayoutParams.PRIVATE_FLAG_KEYGUARD;
}
```

### 低内存终止守护进程 (lmkd)

> [!CAUTION] 不推荐修改

#### 1.使用用户空间 lmkd

```bash
# 修改檔案: kernel/brcm/rpi3/arch/arm/configs/LineageOS_rpi3_defconfig
CONFIG_ANDROID_LOW_MEMORY_KILLER=n
CONFIG_MEMCG=y
CONFIG_MEMCG_SWAP=y
CONFIG_PSI=y
```

#### 2.配置 lmkd

```bash
# 修改檔案: device/brcm/rpi3/rpi3.mk
#配置 lmkd
PRODUCT_PROPERTY_OVERRIDES += \
    ro.lmk.low=1001 \
    ro.lmk.medium=800 \
    ro.lmk.critical=0 \
    ro.lmk.critical_upgrade=false \
    ro.lmk.upgrade_pressure=100 \
    ro.lmk.downgrade_pressure=100 \
    ro.lmk.kill_heaviest_task=true \
    ro.lmk.use_psi=true
```

> 參考: https://source.android.google.cn/devices/tech/perf/lmkd?hl=zh-cn
