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

# 其實式把這些APP編譯輸出fake_packages資料夾，就不會打包到
$(LOCAL_BUILT_MODULE):
	$(hide) echo "Fake: $@"
	$(hide) mkdir -p $(dir $@)
	$(hide) touch $@

PACKAGES.$(LOCAL_MODULE).OVERRIDES := $(strip $(LOCAL_OVERRIDES_PACKAGES))
```

#### 2. 加入編譯模組remove_unused_module
```bash
# 修改檔案: device/brcm/rip3/rpi3.mk
# 加入remove_unused_module
PRODUCT_PACKAGES += remove_unused_module
```
> Android.mk 裡面的變數 LOCAL_OVERRIDES_PACKAGES 就是要移除的APPS
