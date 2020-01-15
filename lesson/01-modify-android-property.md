## 修改Android系統設定

### build.prop 說明
/system/build.prop 是一个属性文件，在Android系统中.prop文件很重要，记录了系统的设置和改变，类似於/etc中的文件
### 產生流程
1. build/core/Makefile 呼叫 build/tools/buildinfo.sh 產出 build.prop
2. build/core/Makefile 再去追加device/brcm/rip3/system.prop 到 build.prop


```bash
# 修改檔案: device/brcm/rip3/system.prop
# 加入設定國家和時區
persist.sys.language=zh
persist.sys.country=TW
persist.sys.localevar=
persist.sys.timezone=Asia/Taipei
ro.product.locale.language=zh
ro.product.locale.region=TW

ro.product.brand=JIMMY9478	 #机器品牌,随你创造
ro.product.name=JIMMY9478	 #机器名,随你创造
ro.product.device=JIMMY9478	 #设备名,随你创造
```