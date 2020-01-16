### 預設wifi連線密碼

#### 建立連線資訊
```bash
# AOSP修改檔案: device\brcm\rpi3\prebuilt\vendor\etc\wifi\wpa_supplicant.conf

#內容如下
disable_scan_offload=1
wowlan_triggers=any
p2p_disabled=1
filter_rssi=-75
no_ctrl_interface=

network={
    ssid="WIFI名稱"
    psk="密碼"
    key_mgmt=WPA-PSK
    priority=2
}
```
#### 生成於Android的檔案系統裡
檔案路徑: /vendor/etc/wifi/wpa_supplicant.conf

#### 透過init.rpi3.rc啟動

```bash
service wpa_supplicant /vendor/bin/hw/wpa_supplicant \
    -iwlan0 -Dnl80211 -c/data/misc/wifi/wpa_supplicant.conf \
    -I/vendor/etc/wifi/wpa_supplicant_overlay.conf \
    -O/data/misc/wifi/sockets \
    -e/data/misc/wifi/entropy.bin -g@android:wpa_wlan0
    class main
    socket wpa_wlan0 dgram 660 wifi wifi
    disabled
    oneshot 
```
