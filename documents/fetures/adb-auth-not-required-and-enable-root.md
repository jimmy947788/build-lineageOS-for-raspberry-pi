## Android系統在Production版本啟用root權限

#### 1. Disable production check
```cpp
// Path: $LINEAGE_SRC/system/core/adb/services.cpp
void restart_root_service(int fd, void *cookie) {
    if (getuid() == 0) {
        WriteFdExactly(fd, "adbd is already running as root\n");
        adb_close(fd);
    } else {

        //TODO: Stop this checked
        /*
        if (!__android_log_is_debuggable()) {
            WriteFdExactly(fd, "adbd cannot run as root in production builds\n");
            adb_close(fd);
            return;
        }
        */

        int root_access = android::base::GetIntProperty("persist.sys.root_access", 0);
        std::string build_type = android::base::GetProperty("ro.build.type", "");

        if (build_type != "eng" && (root_access & 2) != 2) {
            WriteFdExactly(fd, "root access is disabled by system setting - "
                    "enable in Settings -> System -> Developer options\n");
            adb_close(fd);
            return;
        }

        android::base::SetProperty("lineage.service.adb.root", "1");
        WriteFdExactly(fd, "restarting adbd as root\n");
        adb_close(fd);
    }
}
```
#### 2. don't drop privileges 
```cpp
// Path: $LINEAGE_SRC/system/core/adb/daemon/main.cpp
static bool should_drop_privileges() {
    //TODO: add this checked
    std::string prop1 = android::base::GetProperty("lineage.service.adb.root", "");
    if(prop1 == "1")
        return false;
    
    /* 
        *  orinage code 
        */
}
```
####  3. auth not required
```cpp
// Path: $LINEAGE_SRC/system/core/adb/daemon/main.cpp
static bool adbd_main() {
    /* 
     *  orinage code 
     */
    
    // TODO: stop this check
    /*
    if (ALLOW_ADBD_NO_AUTH && !android::base::GetBoolProperty("ro.adb.secure", false)) {
        auth_required = false;
    }
    */
    // TODO: always don't auth required
    auth_required = false;  

    /* 
     *  orinage code 
     */
}
```
#### 4. stop Selinux enforcing 
##### for Lineage 16.0 
```
// Path: $LINEAGE_SRC/system/core/init/selinux.cpp
// TODO: remark this function
/*
EnforcingStatus StatusFromCmdline() {
    EnforcingStatus status = SELINUX_ENFORCING;

    import_kernel_cmdline(false,
                        [&](const std::string& key, const std::string& value, bool in_qemu) {
                            if (key == "androidboot.selinux" && value == "permissive") {
                                status = SELINUX_PERMISSIVE;
                            }
                        });

    return status;
}
*/

//TODO: always return false
bool IsEnforcing() {
    return false;
}
```

##### for Lineage 15.1
```cpp
// Path: system/core/init/init.cpp
/*
static selinux_enforcing_status selinux_status_from_cmdline() {
    ...
*/
static bool selinux_is_enforcing(void)
{
    return false; #新增
}
```

#### 6. add lineage.service.adb.root property 
```bash
# Path: $LINEAGE_SRC/device/brcm/rpi4/system.prop
# others
lineage.service.adb.root=1
```

### 參考資料
- [Android系统打开user版本的root权限](https://blog.csdn.net/qq_33487044/article/details/85076001)
