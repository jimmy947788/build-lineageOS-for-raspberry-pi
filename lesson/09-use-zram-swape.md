### use zrame swape

#### 複寫系統low_ramg屬性
```bash
#AOSP修改檔案:device\brcm\rpi3\rpi3.mk
PRODUCT_PROPERTY_OVERRIDES += ro.config.low_ram=true
```

#### 修改kernel編譯config
```bash
#AOSP修改檔案:kernel\brcm\rpi3\arch\arm\configs\lineageos_rpi3_defconfig
CONFIG_SWAP=y  
CONFIG_CGROUP_MEM_RES_CTLR=y  
CONFIG_CGROUP_MEM_RES_CTLR_SWAP=y  
CONFIG_ZRAM=y  
CONFIG_ZSMALLOC=y 
CONFIG_ZSMALLOC_STAT=y
```

#### 新增zram磁區
```bash
#AOSP修改檔案:device\brcm\rpi3\ramdisk\fstab.rpi3
#加入下面這行
/dev/block/zram0                  none         swap    defaults                                            zramsize=779784192
```

#### 開機掛載啟動zram磁區
```bash
#AOSP修改檔案:device\brcm\rpi3\ramdisk\init.rpi3.rc
on fs
    mount_all /fstab.rpi3
    swapon_all /fstab.rpi3

    # Swapping 1 page at a time is ok
    write /proc/sys/vm/page-cluster 0
    write /proc/sys/vm/swappiness 100
```

lmkd 和 memcg
https://blog.csdn.net/pillarbuaa/article/details/79207036