### 更改螢幕大小

```bash
adb shell wm size 720x1280
```

```java
try {
    Runtime runtime = Runtime.getRuntime();
    runtime.exec("wm size 720x1280");
    Slog.d(TAG, "change screen size to 720x1280.");
}
catch (Exception e1) {
    Slog.e(TAG, "change screen size error.");
} 
```