## 開機啟動流程

Raspberry Pi 是使用GPU來做bootloader，和其他Embedded板子用CPU來做bootloader不一樣。本身bootloader是不開放程式碼的。\
![BCM2835-SoC-block-diagram](/documents/images/BCM2835-SoC-block-diagram.png)
> 官方的firmware專案就包含[bootloader](https://github.com/raspberrypi/firmware/tree/master/boot)

#### PowerOn
1. BCM2835 SoC 通電啟動 
2. CPU(ARM core),SDRAM並未啟動
3. 啟動GPU上的RISC core來負責bootloader運作
4. 跳到bootloader stage 1

#### bootloader stage 1 (GPU)
1. 讀取SD卡FAT32的boot磁碟分區
2. 載入bootcode.bin到GPU L2 Cache 並且執行 
2. 跳到bootloader stage 2
> 這部份流程都寫在BCM2835無法修改

#### bootloader stage 2 (bootcode.bin)
1. 啟動SDRAM
2. 讀取SD卡FAT32的boot磁碟分區
3. 載入start.elf並且執行
>  bootcode.bin (bootloader stage 2)

#### bootloader stage 3 (start.elf)
1. 載入fixup.dat用於配置GPU和CPU之間的SDRAM分區,重新整理GPU和CPU的記憶體因為接下來要準備轉移給CPU去運作系統了。(也配置zImage要使用的空間)
2. 載入config.txt設定檔，把config.txt當作BIOS初始化硬體的參數[參考](https://www.raspberrypi.org/documentation/configuration/config-txt/)
3. 載入cmdline.txt要把參數傳遞给kernel
4. 載入zImage(linux kernel)
4. 啟動 ARM core CPU
> start.elf (GPU firmware) 

#### kernel 
1. **kernel_init** kernel\brcm\rpi3\init\main.c

https://blog.csdn.net/qq_19923217/article/details/81240302
https://blog.csdn.net/qq_19923217/article/details/82014989

https://blog.csdn.net/salmon_zhang/article/details/93639941

https://www.cntofu.com/book/46/raspberry_pi/buildroot_study_-_jian_li_zi_ji_de_zuo_ye_xi_tong.md

![asd](/documents/images/zo803Hq.png)
#### 參考
1. [Raspberry Pi Releases BCM2835 Datasheet for ARM Peripherals](https://www.cnx-software.com/2012/02/07/raspberry-pi-releases-bcm2835-datasheet-for-arm-peripherals/) 
2. [Boot sequence](https://www.raspberrypi.org/documentation/hardware/raspberrypi/bootmodes/bootflow.md)
3. [git raspberrypi firmware](https://github.com/raspberrypi/firmware)
4. [BARE METAL RASPBERRY PI 3B+: NETWORK BOOT](https://metebalci.com/blog/bare-metal-rpi3-network-boot/)
5. [The boot folder](https://www.raspberrypi.org/documentation/configuration/boot_folder.md)