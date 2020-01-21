### low ram lmkd

#### 複寫系統low_ram屬性
```bash
#AOSP修改檔案:device\brcm\rpi3\rpi3.mk
# raspberry pi3 1G RAM low ram
PRODUCT_PROPERTY_OVERRIDES += ro.lmk.use_minfree_levels=true
```

#### 修改kernel編譯config
```bash
#AOSP修改檔案:kernel\brcm\rpi3\arch\arm\configs\lineageos_rpi3_defconfig
CONFIG_ANDROID_LOW_MEMORY_KILLER=n
CONFIG_ANDROID_LOW_MEMORY_KILLER_AUTODETECT_OOM_ADJ_VALUES=n
CONFIG_MEMCG=y
CONFIG_MEMCG_SWAP=y
```


#### 參考
- [Android P使能用户态LMK说明](http://tjtech.me/how-to-enable-userspace-lmk-under-android-p.html)