## Android系統在Production不用授權啟用adb root

1. Disable production check \
    Path: $LINEAGE_SRC/system/core/adb/services.cpp
    ```cpp
    //
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
2. don't drop privileges \
    Path: $LINEAGE_SRC/system/core/adb/daemon/main.cpp
    ```cpp
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
3. auth not required \
    Path: $LINEAGE_SRC/system/core/adb/daemon/main.cpp
    ```cpp
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
4. stop Selinux check \
    Path: $LINEAGE_SRC/system/core/init/selinux.cpp
    ```cpp
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
5. add lineage.service.adb.root property \
    Path: $LINEAGE_SRC/device/brcm/rpi4/system.prop
    ```bash
    # others
    lineage.service.adb.root=1
    ```
