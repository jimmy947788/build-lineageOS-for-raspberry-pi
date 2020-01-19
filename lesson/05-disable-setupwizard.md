### 開機不要執行設定精靈

```java
// AOSP修改檔案:frameworks\base\services\core\java\com\android\server\am\ActivityManagerService.java

//Settings.Secure.USER_SETUP_COMPLETE = 0啟動設定精靈
public void systemReady(final Runnable goingCallback, TimingsTraceLog traceLog) {           
            // Start up initial activity.
            mBooting = true;
            // Enable home activity for system user, so that the system can always boot. We don't
            // do this when the system user is not setup since the setup wizard should be the one
            // to handle home activity in this case.
            /*
            if (UserManager.isSplitSystemUser() &&
                    Settings.Secure.getInt(mContext.getContentResolver(),
                         Settings.Secure.USER_SETUP_COMPLETE, 0) != 0) {
                ComponentName cName = new ComponentName(mContext, SystemUserHomeActivity.class);
                try {
                    AppGlobals.getPackageManager().setComponentEnabledSetting(cName,
                            PackageManager.COMPONENT_ENABLED_STATE_ENABLED, 0,
                            UserHandle.USER_SYSTEM);
                } catch (RemoteException e) {
                    throw e.rethrowAsRuntimeException();
                }
            }
            */
            Settings.Secure.putInt(mContext.getContentResolver(), Settings.Secure.USER_SETUP_COMPLETE, 1);
            Settings.Secure.putInt(mContext.getContentResolver(), Settings.Global.DEVICE_PROVISIONED, 1);
            // 重點在這裡,啟動桌面也就是launcher
            startHomeActivityLocked(currentUserId, "systemReady");
```


https://blog.csdn.net/zhuawalibai/article/details/80221370