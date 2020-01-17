## 移除不需要的服務

### PrintManagerService
```java
AOSP修改檔案: frameworks\base\services\java\com\android\server\SystemServer.java

            //註解調不要啟動
            /*
            if (mPackageManager.hasSystemFeature(PackageManager.FEATURE_PRINTING)) {
                traceBeginAndSlog("StartPrintManager");
                mSystemServiceManager.startService(PRINT_MANAGER_SERVICE_CLASS);
                traceEnd();
            }
            */
```



frameworks\base\services\java\com\android\server\SystemServer.java
frameworks\base\core\java\android\app\SystemServiceRegistry.java