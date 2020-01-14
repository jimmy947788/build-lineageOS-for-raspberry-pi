# build-lineageOS-rpi3
## Build ImageMagic
```bash
$> ./01_build-ImageMagick.sh
```

## sync lineageOS source code
```bash
$> ./02_sync-android-rpi3.sh
```

## build lineageOS source code
```bash
$> ./03_build-android-rpi3.sh
```

### 移除預設APP
#### 1. 定義編譯模組remove_unused_module
```bash
# 修改檔案: device/brcm/rpi3/Android.mk

#加入下面區段
include $(CLEAR_VARS)
LOCAL_MODULE := remove_unused_module
LOCAL_MODULE_TAGS := optional

LOCAL_MODULE_CLASS := FAKE
LOCAL_MODULE_SUFFIX := $(COMMON_ANDROID_PACKAGE_SUFFIX)

#要移除的APP
LOCAL_OVERRIDES_PACKAGES += \
   Contacts \
   Email \
   DeskClock \
   Calendar \
   CalendarProvider \
   Contacts \
   Email \
   vr \
   Telecom \
   TeleService \
   PrintSpooler \
   PrintRecommendationService \
   PicoTts \
   MmsService \
   AudioFX \
   ExactCalculator \
   Camera2 \
   Gallery2 \
   Recorder \
   Eleven

include $(BUILD_SYSTEM)/base_rules.mk

$(LOCAL_BUILT_MODULE):
	$(hide) echo "Fake: $@"
	$(hide) mkdir -p $(dir $@)
	$(hide) touch $@

PACKAGES.$(LOCAL_MODULE).OVERRIDES := $(strip $(LOCAL_OVERRIDES_PACKAGES))
```
#### 2. 加入編譯模組remove_unused_module
```bash
# 修改檔案: device/brcm/rip3/rpi3.mk
#加入remove_unused_module
PRODUCT_PACKAGES += remove_unused_module
```
> Android.mk 裡面的變數LOCAL_OVERRIDES_PACKAGES 就是要移除的APPS

### linux kernel compile config
> kernel/brcm/rpi3/arch/arm/configs/lineageos_rpi3_defconfig


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

### 啟用root權限
#### 1.修改ro.adb.secure和ro.secure属性
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

#### 2.修改selinux
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

#### 3.修改adb模块的android.mk文件
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
# 修改檔案: kernel/brcm/rpi3/arch/arm/configs/lineageos_rpi3_defconfig
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