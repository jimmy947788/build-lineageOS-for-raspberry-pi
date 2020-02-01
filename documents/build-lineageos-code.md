### 編譯 LineageOS 程式碼
1. **設定compile cache**
    ```bash
    $ export USE_CCACHE=1
    $ export CCACHE_DIR=$HOME/.ccache
    $ ccache -M 50G
    ```
2. **給編譯時期更多記憶體**
    ```bash
    $ export PATH=~/lineageOS/prebuilts/sdk/tools:$PATH
    $ export JACK_SERVER_VM_ARGUMENTS="-Dfile.encoding=UTF-8 -XX:+TieredCompilation -Xmx4g"
    $ jack-admin kill-server && jack-admin start-server
    ```
3. **打上RPI3補丁**
   1. rpi3: modify generic keyboard layout
   ```bash
   $ cd ~/lineageOS
   $ curl --create-dirs -L -o patches/frameworks_base/0001-rpi3-modify-generic-keyboard-layout.patch -O -L https://raw.githubusercontent.com/lineage-rpi/android_local_manifest/lineage-15.1/patches/frameworks_base/0001-rpi3-modify-generic-keyboard-layout.patch
   $ cd ~/lineageOS/frameworks/base
   $ git am ~/lineageOS/patches/frameworks_base/0001-rpi3-modify-generic-keyboard-layout.patch
   ```
   2. disable adb authentication by default
   ```bash
   $ cd ~/lineageOS
   $ curl --create-dirs -L -o patches/vendor_lineage/0001-disable-adb-authentication-by-default.patch -O -L https://raw.githubusercontent.com/lineage-rpi/android_local_manifest/lineage-15.1/patches/vendor_lineage/0001-disable-adb-authentication-by-default.patch
   $ cd ~/lineageOS/vendor/lineage
   $ git am ~/lineageOS/patches/vendor_lineage/0001-disable-adb-authentication-by-default.patch
   ```

4. **載入編譯環境變數**
    ```bash
    $ source build/envsetup.sh
    $ lunch lineage_rpi3-userdebug
    ```
    > 如果無法載入Device發生找不到，需要新增Device參考官方新增說明[連結](https://source.android.com/setup/develop/new-device#build-a-product)
    - BUILDTYPE [參考](https://source.android.com/setup/build/building#choose-a-target)
       - eng：工程版本 
       - user：发行版本
       - userdebug：部分调试版本

5. **編譯全部專案**
    ```bash
    $ make -j12 kernel ramdisk systemimage vendorimage
    ```
6. **打包可以燒錄的映像檔**
    ```bash
    $ cd ~/lineageOS/device/brcm/rpi3/
    $ sudo ./mkimg.sh
    ```
7. **燒錄映像到SD卡**
    ```bash
    $ sudo dd if=lineage-15.1-{date}-rpi3.img of=/dev/sdX status=progress bs=4M
    ```
    > /dev/sdX 是你SD卡的路徑，注意要改阿!!!

#### 參考文件
- [編譯版本 Using build variants](https://source.android.com/setup/develop/new-device#build-variants)