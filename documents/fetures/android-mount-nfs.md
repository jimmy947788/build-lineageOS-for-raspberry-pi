## Android掛載NFS磁碟

### 1. HOST開啟NFS資料夾
#### 加入要開放的資料夾和權限
```bash
$ sudo vim /etc/exports
#加入下面這行
/mnt/nfs-rpi *(rw,sync,no_root_squash,no_subtree_check)
```
#### 重載NFS
```bash
$ sudo exportfs -r
```
#### 檢查NFS
```bash
$ showmount -e
```
### 2. kernel打開NFS
預設android的kernel沒有打開NFS服務，所以要打開NFS功能重新編譯。
#### 修改kernel的compile config
```bash
#路徑: kernel/brcm/rpi4/arch/arm/configs/lineageos_rpi4_defconfig
CONFIG_NFS_FS=y
CONFIG_NFS_V4=y
CONFIG_NFS_V4_1=y
CONFIG_NFS_V4_2=y
CONFIG_ROOT_NFS=y
```


### 3. android掛載NFS
```bash
# busybox mount -t nfs -o nolock {SERVER_IP}:/mnt/nfs-rpi /data/nfs-rpi //默認選擇vers=3
# busybox mount -t nfs -o nolock,vers=2 {SERVER_IP}:/mnt/nfs-rpi /data/nfs-rpi
or #默認vers=3
# busybox mount -t nfs -o nolock,vers=3 {SERVER_IP}:/mnt/nfs-rpi /data/nfs-rpi
or
# busybox mount -t nfs -o nolock,vers=4 {SERVER_IP}:/mnt/nfs-rpi /data/nfs-rpi

# busybox umount /data/nfs //卸載
```
> 必須用busybox的mount，linux和android的mount還是有區別的