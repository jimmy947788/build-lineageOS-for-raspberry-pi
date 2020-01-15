### 預設啟用root權限

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
LOCAL_CFLAGS += -DALLOW_ADBD_NO_AUTH=$(if $(filter user userdebug eng,$(TARGET_BUILD_VARIANT)),1,0)

#ifneq (,$(filter userdebug eng,$(TARGET_BUILD_VARIANT)))
ifneq (,$(filter user userdebug eng,$(TARGET_BUILD_VARIANT)))
```