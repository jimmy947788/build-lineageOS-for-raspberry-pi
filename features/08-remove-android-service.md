## 移除不需要的服務

### PrintManagerService
```java
//AOSP修改檔案: frameworks\base\services\java\com\android\server\SystemServer.java

            //註解調不要啟動
            /*
            if (mPackageManager.hasSystemFeature(PackageManager.FEATURE_PRINTING)) {
                traceBeginAndSlog("StartPrintManager");
                mSystemServiceManager.startService(PRINT_MANAGER_SERVICE_CLASS);
                traceEnd();
            }
            */
```


### 相關檔案
- *註冊服務* frameworks\base\core\java\android\app\SystemServiceRegistry.java
- *啟動服務*frameworks\base\services\java\com\android\server\SystemServer.java

#### 參考
- [Android系统启动（四）-SystemServer篇](https://www.jianshu.com/p/c6f464457f4c)