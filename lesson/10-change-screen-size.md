### 更改螢幕大小

```bash
adb shell wm size 720x1280
```

```java
//AOSP修改檔案: frameworks\base\services\core\java\com\android\server\am\ActivityManagerService.java

final void finishBooting() {
        synchronized (this) {
            if (!mBootAnimationComplete) {
                mCallFinishBooting = true;
                return;
            }
            mCallFinishBooting = false;
        }
        
        //加入以下這段
        try {
            Runtime runtime = Runtime.getRuntime();
            runtime.exec("wm size 720x1280");
            Slog.d(TAG, "change screen size to 720x1280.");
        }
        catch (Exception e1) {
            Slog.e(TAG, "change screen size error.");
        } 
}
```