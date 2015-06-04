#!/bin/bash

DEFCONFIG_FILE=$1

if [ -z "$DEFCONFIG_FILE" ]; then
	echo "Need defconfig file(j1v-perf_defconfig)!"
	exit -1
fi

if [ ! -e arch/arm/configs/$DEFCONFIG_FILE ]; then
	echo "No such file : arch/arm/configs/$DEFCONFIG_FILE"
	exit -1
fi

# make .config
env KCONFIG_NOTIMESTAMP=true \
make ARCH=arm CROSS_COMPILE=arm-eabi- ${DEFCONFIG_FILE}

# run menuconfig
env KCONFIG_NOTIMESTAMP=true \
make menuconfig ARCH=arm

make savedefconfig ARCH=arm
# copy .config to defconfig
mv defconfig arch/arm/configs/${DEFCONFIG_FILE}
# clean kernel object
make mrproper

#
#	1) F240S
#	  b) make ARCH=arm CROSS_COMPILE=../prebuilts/gcc/linux-x86/arm/arm-eabi-4.8/bin/arm-eabi- gksk_bcm-perf_defconfig zImage -j4
	
#	2) F240K
#	 b) make ARCH=arm CROSS_COMPILE=../prebuilts/gcc/linux-x86/arm/arm-eabi-4.8/bin/arm-eabi- gkkt_bcm-perf_defconfig zImage -j4
	 
#	3) F240L
#	 b) make ARCH=arm CROSS_COMPILE=../prebuilts/gcc/linux-x86/arm/arm-eabi-4.8/bin/arm-eabi- gku_bcm-perf_defconfig zImage -j4
	
#	* "-j4" : The number, 4, is the number of multiple jobs to be in
