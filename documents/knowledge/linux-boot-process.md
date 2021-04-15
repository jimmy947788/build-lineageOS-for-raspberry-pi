## 開機啟動流程

Raspberry Pi 是使用GPU來做bootloader，和其他Embedded板子用CPU來做bootloader不一樣。\
![Boot process](/documents/images/zo803Hq.png) 
> 官方的firmware專案就包含[bootloader](https://github.com/raspberrypi/firmware/tree/master/boot)

#### PowerOn
1. BCM2835 SoC 通電啟動 
2. CPU(ARM core), SDRAM並未啟動
3. VideoCore GPU 啟動。
4. VideoCore GPU 上的RISC core來負責bootloader運作。
5. 進入 bootloader stage 1 。

#### bootloader stage 1 (GPU負責)
1. 掛載 SD 記憶卡上的 FAT32的boot磁碟分區。
2. 載入 bootcode.bin (導加載程序) 到 GPU L2 Cache 。
3. GPU 從 L2 Cache 執行 bootcode.bin 。
4. 開始進入bootloader stage 2 流程。
> 樹梅派4之後把bootcode.bin 已經移到 EEPROM 裡面不靠檔案了[參考](https://www.raspberrypi.org/documentation/hardware/raspberrypi/booteeprom.md)

#### bootloader stage 2 (bootcode.bin負責)
1. 啟動SDRAM
2. 從SD記憶卡上的 FAT32的boot磁碟分區，載入start*.elf 到 VideoCore GPU 開機  [註2](https://github.com/02047788a/build-lineageOS-for-raspberry-pi/blob/master/documents/knowledge/linux-boot-process.md#%E5%82%99%E8%A8%BB) 
   - start4.elf, start4x.elf, start4cd.elf, and start4db.elf 是樹梅派4的[firmware](https://www.raspberrypi.org/documentation/configuration/boot_folder.md)
3. 載入fixup*.dat用於配置GPU和CPU之間的SDRAM分區,重新整理GPU和CPU的記憶體因為接下來要準備轉移給CPU去運作系統了。
(也配置zImage要使用的空間)


#### bootloader stage 3 (start*.elf 負責)
1. 載入config.txt設定檔，把config.txt當作BIOS初始化硬體的參數[參考](https://www.raspberrypi.org/documentation/configuration/config-txt/)
2. 載入cmdline.txt要把參數傳遞给kernel [參考](https://www.raspberrypi.org/documentation/configuration/cmdline-txt.md)
3. 載入zImage(linux kernel)
4. 啟動 ARM core CPU
5. 進入linux kernel

#### linux kernel
1. kernel 透過 cmdline.txt的參數initrd提供的位址去抓取ramdisk.img
2. kernel 掛載基本檔案系統預備提供給Android使用
3. kernel 掛載完成檔案系統後就會先執行init這隻程式(kernel\brcm\rpi*\init\main.c)

#### 備註
1. bootcode.bin 是引導加載程序( Stage 2 的流程內容程式) 這部份流程都寫在BCM2835無法修改，bootcode.bin 也不開放程式碼。
2. start.elf 是基礎 firmware，start_x.elf 包含 camera 驅動程式和編/解碼器 firmware，start_db.elf 是硬體debug 用的 firmware，start_cd.elf 是簡化版本不含支援編/解碼器和3D加速功能的硬件模組。

#### 參考
- [Raspberry Pi Releases BCM2835 Datasheet for ARM Peripherals](https://www.cnx-software.com/2012/02/07/raspberry-pi-releases-bcm2835-datasheet-for-arm-peripherals/) 
- [Boot sequence](https://www.raspberrypi.org/documentation/hardware/raspberrypi/bootmodes/bootflow.md)
- [git raspberrypi firmware](https://github.com/raspberrypi/firmware)
- [BARE METAL RASPBERRY PI 3B+: NETWORK BOOT](https://metebalci.com/blog/bare-metal-rpi3-network-boot/)
- [The boot folder](https://www.raspberrypi.org/documentation/configuration/boot_folder.md)
- [buildRoot study - 建立自己的作業系統](https://www.cntofu.com/book/46/raspberry_pi/buildroot_study_-_jian_li_zi_ji_de_zuo_ye_xi_tong.md)
- [The Kernel Command Line](https://www.raspberrypi.org/documentation/configuration/cmdline-txt.md)
- [config.txt] (https://www.raspberrypi.org/documentation/configuration/config-txt/)
- [Hardware boot] (https://rxos.readthedocs.io/en/develop/how_it_works/boot.html#hardware-boot)