## 開機啟動流程

### bootloader
Raspberry Pi的啟動順序基本上是這樣的：

第1階段啟動位於片上ROM中.在L2快取中載入第2階段

第二階段是 bootcode.bin .啟用S​​DRAM並載入Stage 3

第3階段是 loader.bin .它知道 .elf   格式和載入 start.elf start.elf   載入 kernel.img .然後它還讀取 config.txt ， cmdline.txt   和 bcm2835.dtb 如果dtb檔案存在，則会在 0×100中載入   &安培; kernel @ 0×8000 如果是 disable_commandline_tags   設置它載入內核@ 0×0 否則它会載入kernel @ 0×8000   並將ATAGS放在 0×100 kernel.img   然後在ARM上執行。

Everything is run on the GPU until kernel.img   載入到ARM。

我發現這个圖非常有用：

![asd](/documents/images/004.png)
![asd](/documents/images/BCM2835-Memory-Map-Large.png)

#### 參考
[Raspberry Pi Releases BCM2835 Datasheet for ARM Peripherals](https://www.cnx-software.com/2012/02/07/raspberry-pi-releases-bcm2835-datasheet-for-arm-peripherals/) 