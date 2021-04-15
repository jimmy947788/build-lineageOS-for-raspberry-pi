## 開機啟動流程

Raspberry Pi 是使用GPU來做bootloader，和其他Embedded板子用CPU來做bootloader不一樣。本身bootloader是不開放程式碼的。\
![Boot process of Rapsberry Pi 3 Model B](/documents/images/rpi3b-boot-sequence.png) 
> 官方的firmware專案就包含[bootloader](https://github.com/raspberrypi/firmware/tree/master/boot)

#### PowerOn
1. BCM2835 SoC 通電啟動 
2. CPU(ARM core), SDRAM並未啟動
3. 啟動GPU上的RISC core來負責bootloader運作
4. 跳到bootloader stage 1

#### bootloader stage 1 (GPU)
1. 讀取SD卡FAT32的boot磁碟分區。
2. 載入 bootcode.bin 到 GPU L2 Cache。
3. GPU 從 L2 Cache 執行 bootcode.bin 。
4. 開始進入bootloader stage 2 流程。
> 樹梅派4之後把bootcode.bin 已經移到 EEPROM 裡面不靠檔案了[參考](https://www.raspberrypi.org/documentation/hardware/raspberrypi/booteeprom.md)

#### bootloader stage 2 (bootcode.bin)
1. 啟動SDRAM
2. 讀取SD卡FAT32的boot磁碟分區
3. 載入start*.elf並且執行
>  start4.elf, start4x.elf, start4cd.elf, and start4db.elf 是樹梅派4的firmware [參考](https://www.raspberrypi.org/documentation/configuration/boot_folder.md)

#### bootloader stage 3 (start.elf)
1. 載入fixup.dat用於配置GPU和CPU之間的SDRAM分區,重新整理GPU和CPU的記憶體因為接下來要準備轉移給CPU去運作系統了。
(也配置zImage要使用的空間)
2. 載入config.txt設定檔，把config.txt當作BIOS初始化硬體的參數[參考](https://www.raspberrypi.org/documentation/configuration/config-txt/)
3. 載入cmdline.txt要把參數傳遞给kernel
4. 載入zImage(linux kernel)
5. 啟動 ARM core CPU
6. 進入linux kernel
> start.elf (GPU firmware) 

#### linux kernel
1. kernel 透過 cmdline.txt的參數initrd提供的位址去抓取ramdisk.img
2. kernel 掛載基本檔案系統預備提供給Android使用
3. kernel 掛載完成檔案系統後就會先執行init這隻程式(kernel\brcm\rpi3\init\main.c)






#### 註
1. bootcode.bin 是引導加載程序( Stage 2 的流程內容程式) 
2. bootloader stage 1 這部份流程都寫在BCM2835無法修改，bootcode.bin[link](https://github.com/raspberrypi/firmware/tree/master/boot) 也不開放程式碼。
3. start.elf 是基礎 firmware，start_x.elf 包含 camera 驅動程式和編/解碼器 firmware，start_db.elf 是硬體debug 用的 firmware，start_cd.elf 是簡化版本不含支援編/解碼器和3D加速功能的硬件模組。

![asd](/documents/images/zo803Hq.png)
#### 參考
- [Raspberry Pi Releases BCM2835 Datasheet for ARM Peripherals](https://www.cnx-software.com/2012/02/07/raspberry-pi-releases-bcm2835-datasheet-for-arm-peripherals/) 
- [Boot sequence](https://www.raspberrypi.org/documentation/hardware/raspberrypi/bootmodes/bootflow.md)
- [git raspberrypi firmware](https://github.com/raspberrypi/firmware)
- [BARE METAL RASPBERRY PI 3B+: NETWORK BOOT](https://metebalci.com/blog/bare-metal-rpi3-network-boot/)
- [The boot folder](https://www.raspberrypi.org/documentation/configuration/boot_folder.md)
- [buildRoot study - 建立自己的作業系統](https://www.cntofu.com/book/46/raspberry_pi/buildroot_study_-_jian_li_zi_ji_de_zuo_ye_xi_tong.md)