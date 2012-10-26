LOCAL_PATH:= $(call my-dir)
include $(CLEAR_VARS)

export  ATH_SRC_BASE=$(LOCAL_PATH)
export  ATH_BUILD_TYPE=QUALCOMM_ARM_NATIVEMMC
export  ATH_BUS_TYPE=sdio
export  ATH_OS_SUB_TYPE=linux_2_6
export  ATH_LINUXPATH=$(TARGET_OUT_INTERMEDIATES)/KERNEL_OBJ
export  ATH_ARCH_CPU_TYPE=arm
export  ATH_BUS_SUBTYPE=linux_sdio
#export  ATH_ANDROID_ENV=yes
#export  ATH_EEPROM_FILE_USED=no
#export  ATH_SOFTMAC_USED=no
#export  ATH_SAVE_EEPROM_TO_FILE=yes
 
ATH_HIF_TYPE:=sdio
#ATH_SRC_BASE:= ../external/athwlan/olca/host
ATH_SRC_BASE:= /home/3240/external/dual-stack-mobile-ipv6-lh

#mod_cleanup := $(TARGET_OUT_INTERMEDIATES)/external/athwlan/olca/dummy

#$(mod_cleanup) :
#rm $(TARGET_OUT_INTERMEDIATES)/external/athwlan/olca -rf
#mkdir -p $(TARGET_OUT_INTERMEDIATES)/system/wifi 
#mkdir -p $(TARGET_OUT)/wifi 

mod_file := $(TARGET_OUT)/wifi/udpencap.ko
$(mod_file) : $(mod_cleanup) $(TARGET_PREBUILT_KERNEL) #acp
	$(MAKE) ARCH=arm CROSS_COMPILE=arm-eabi- -C $(ATH_LINUXPATH) ATH_HIF_TYPE=$(ATH_HIF_TYPE) SUBDIRS=$(ATH_SRC_BASE)/udpencap modules
#	$(ACP) $(TARGET_OUT_INTERMEDIATES)/external/athwlan/olca/host/os/linux/udpencap.ko $(TARGET_OUT)/wifi/

ALL_PREBUILT += $(mod_file)


#include $(LOCAL_PATH)/tools/Android.mk

