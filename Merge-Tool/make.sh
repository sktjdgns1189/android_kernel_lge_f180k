####
#### BOOTIMG MAKE SCRIPT!
#### 4.4 DTB Way
####
rm boot.img
rm ramdisk-new.gz
cd ramdisk
chmod 644 *.rc
chmod 750 charger
chmod 750 init*
chmod 640 fstab*
chmod 644 default.prop
chmod 771 data
chmod 755 dev
chmod 755 lib
chmod 755 lib/modules
chmod 644 lib/modules/*
chmod 755 proc
chmod 750 sbin
chmod 750 sbin/*
chmod 755 sys
chmod 755 system
find . | cpio -o -H newc -O ../ramdisk-new
cd ..
gzip ramdisk-new
#./mkboot . ./boot.img
mkbootimg --kernel zImage --ramdisk ramdisk-new.gz --base 0x80200000 --pagesize 2048 --ramdiskaddr 0x82200000 --cmdline "vmalloc=600M console=null lpj=67677 user_debug=31 msm_rtb.filter=0x0 ehci-hcd.park=3 coresight-etm.boot_enable=0 androidboot.hardware=geehrc" -o boot.img
