## 開機啟動流程

#### PowerOn
1. BCM2835 SoC 通電啟動 
2. CPU(ARM core),SDRAM並未啟動
3. GPU啟動
4. 執行bootloader stage 1

#### bootloader stage 1 (GPU)
1. 讀取SD卡FAT32的boot磁碟分區bootcode.bin載入到L2 Cache 
2. 執行bootcode.bin
> 這部份流程都寫在BCM2835無法修改

#### bootloader stage 2 (bootcode.bin)
1. 啟動SDRAM
2. 讀SD卡中FAT32第1分區start.elf並且執行
>  bootcode.bin (bootloader stage 2)

#### bootloader stage 3 (start.elf)
1. 讀取設定檔[config.txt ](https://www.raspberrypi.org/documentation/configuration/config-txt/)初始化硬體參數
2. 讀取fixup.dat用於配置GPU和CPU之間的SDRAM分區,並且依照fixup.dat內的設定載入zImage(linux kernel)
3. 執行zImage(linux kernel)kernel透過cmdline.txt傳遞给內核的引數
4. 啟動 ARM core
> start.elf (GPU firmware) 


![asd](/documents/images/zo803Hq.png)
#### 參考
1. [Raspberry Pi Releases BCM2835 Datasheet for ARM Peripherals](https://www.cnx-software.com/2012/02/07/raspberry-pi-releases-bcm2835-datasheet-for-arm-peripherals/) 
2. [Boot sequence](https://www.raspberrypi.org/documentation/hardware/raspberrypi/bootmodes/bootflow.md)
3. [git raspberrypi firmware](https://github.com/raspberrypi/firmware)
4. [BARE METAL RASPBERRY PI 3B+: NETWORK BOOT](https://metebalci.com/blog/bare-metal-rpi3-network-boot/)
5. [The boot folder](https://www.raspberrypi.org/documentation/configuration/boot_folder.md)