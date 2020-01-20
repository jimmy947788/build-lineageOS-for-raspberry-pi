### 不要載入動態桌布


```java
    //AOSP修改檔案: frameworks/base/services/core/java/com/android/server/wallpaper/WallpaperManagerService.java
    
    boolean bindWallpaperComponentLocked(ComponentName componentName, boolean force,
            boolean fromUser, WallpaperData wallpaper, IRemoteCallback reply) {
        if (DEBUG_LIVE) {
            Slog.v(TAG, "bindWallpaperComponentLocked: componentName=" + componentName);
        }

        // rpi3 don't use WallpaperComponent"
        Slog.v(TAG, "rpi3 don't use WallpaperComponent");
        return false;
    }
```