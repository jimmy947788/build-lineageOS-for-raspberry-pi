## Android啟動流程

### 啟動桌面luancher
```java
//AOSP修改檔案:frameworks\base\services\core\java\com\android\server\am\ActivityManagerService.java
public void systemReady(final Runnable goingCallback, TimingsTraceLog traceLog) {
    /*
        something code
    */
    startHomeActivityLocked(currentUserId, "systemReady");
```

#### 參考
- [Android 8.1 开机流程分析（1）](https://blog.csdn.net/qq_19923217/article/details/81240302)
- [Android 8.1 开机流程分析（2）](https://blog.csdn.net/qq_19923217/article/details/82014989)
- [从源码角度看Android系统Launcher在开机时的启动过程](https://blog.csdn.net/salmon_zhang/article/details/93639941)
- [adb获取Android系统属性数据来源](https://blog.csdn.net/haixia_12/article/details/40857721)