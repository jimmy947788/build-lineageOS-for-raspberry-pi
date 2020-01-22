### 下載 LineageOS 程式碼
1. **安裝Repo工具**
    ```bash
    #建立bin目錄存放Repo
    $ mkdir ~/bin
    $ export PATH=~/bin:$PATH
    #下載Repo工具
    $ curl https://storage.googleapis.com/git-repo-downloads/repo > ~/bin/repo
    $ chmod a+x ~/bin/repo
    ```
    > Repo 是google用來管理複合式程式碼的工具，一套Android裡面包含很多不同的專案構成
2. **初始化Repo client端**
    ```bash
    # 建立程式碼目錄
    $ mkdir ~/lineageOS
    $ cd ~/lineageOS
    ```
    > ~/lineageOS 是我的主要程式碼工作目錄，你們可以自己定義
    ```bash
    # 設定git名稱和信箱
    $ git config --global user.name "Your Name"
    $ git config --global user.email "you@example.com"
    # 在目前目錄初始化一個client端，指定repository分支lineage-15.1
    $ repo init -u git://github.com/LineageOS/android.git -b lineage-15.1
    ```
    > LineageOS的所有分支 [all branches](https://github.com/LineageOS/android/branches/all)
    
3. **下載程式碼**
   ```bash
   # 同步遠端程式碼到client端
   $ repo sync -j32 #-j32:是指用32條執行緒下載
   ```
   > 開始下載 repository 大約 66G

4. **下載raspberry pi 3需要的額外專案** \
    repo init 會在程式碼工作目錄下建立一個.repo目錄，.repo目錄下manifest.xml這個檔案就是.repo/manifests/[default.xml](../manifests/default.xml)的連結，內容就包含了建構lineageOS必要用到的專案清單。\
    這裡需要額外定義一個[manifest_brcm_rpi3.xml](../manifests/manifest_brcm_rpi3.xml)來列出額外要下載的專案。
   ```bash
   $ mkdir .repo/local_manifests #Repo 1.9.1 has a new feature. 
   $ wget https://raw.githubusercontent.com/02047788a/build-lineageOS-rpi3/master/manifests/manifest_brcm_rpi3.xml -O .repo/local_manifests/manifest_brcm_rpi3.xml
   $ repo sync -j32 --force-sync
   ```
   > Repo 1.9.1 開始要把新增的manifest_brcm_rpi3.xml放到指定目錄.repo/local_manifests下面。
5. **建立一個新的分支** *(用這個分支開發)*
   ```bash
   # 分支名稱:lineageOS-rpi3
   # --all 新分支包含所有的專案
   $ repo start lineageOS-rpi3 --all
   ```
#### Repo 常用指令
```bash
$ repo abandon <BRANCH_NAME> #刪除分支
$ repo branches #列出分支 
$ repo start <BRANCH_NAME> [<PROJECT_LIST>] #新增分支 [專案]
$ repo checkout <BRANCH_NAME> #切換分支 
```

#### 自動下載腳本
```bash
# 下載腳本到程式碼目錄
$ wget https://raw.githubusercontent.com/02047788a/build-lineageOS-rpi3/master/scripts/sync-lineageos-code.sh -O ~/sync-lineageos-code.sh
$ ./sync-lineageos-code.sh
# 提示輸入 lineageOS 程式碼目錄
# 提示輸入 lineageOS branch
# 提示輸入 git global user.name
# 提示輸入 git global user.email
```

#### 參考文件
 - [LineageOS 維基百科](https://zh.wikipedia.org/wiki/LineageOS)
 - [LineageOS 官方網頁](https://www.lineageos.org/)
 - [LineageOS 官方維基](https://wiki.lineageos.org/)
 - [LineageOS Github](https://github.com/LineageOS/)
 - [LineageOS-rpi Github](https://github.com/lineage-rpi)
 - [Raspberry Pi 3 Model B+ 規格](https://www.raspberrypi.com.tw/10684/55/)

 - [Repo 命令参考资料](https://source.android.google.cn/setup/using-repo.html)
 - [Android Local Manifests机制的使用实践](https://duanqz.github.io/2016-04-15-Android-Local-Manifests-Practice)