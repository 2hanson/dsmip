#######################################################################################
#  Udpencap Kernel Module makefile.
#
#    This makefile is invoked by the master makefile in the linux kernel, the linux kernel
#    source must be initially compiled.  The top level make will invoke the main linux kernel
#    makefile which will subsequently pick up this makefile.
#
#######################################################################################


REV ?= 2

# ATHENV
ifeq ($(ATH_ANDROID_ENV),yes)
EXTRA_CFLAGS += -D__linux__ -Wno-error
endif
# ATHENV

#EXTRA_CFLAGS += -I$(ATH_SRC_BASE)/include
#EXTRA_CFLAGS += -I$(ATH_SRC_BASE)/../include
# TBDXXX....handle include/AR6002
#EXTRA_CFLAGS += -I$(ATH_SRC_BASE)/../include/AR6002
#EXTRA_CFLAGS += -I$(ATH_SRC_BASE)/wlan/include
#EXTRA_CFLAGS += -I$(ATH_SRC_BASE)/os/linux/include
#EXTRA_CFLAGS += -I$(ATH_SRC_BASE)/os/
#EXTRA_CFLAGS += -I$(ATH_SRC_BASE)/bmi/include

#EXTRA_CFLAGS += -DLINUX -DDEBUG -D__KERNEL__ \
#                -DTCMD -DSEND_EVENT_TO_APP -DUSER_KEYS \
#                -DNO_SYNC_FLUSH -DWAPI_ENABLE #\
#                -DMULTIPLE_FRAMES_PER_INTERRUPT -DAR6000REV$(REV) \
#                -DBLOCK_TX_PATH_FLAG \

# ATHENV

# ATHENV

ifeq ($(ATH_HTC_RAW_INT_ENV),yes)
  EXTRA_CFLAGS += -DHTC_RAW_INTERFACE
endif

ifneq ($(ATH_OS_SUB_TYPE),linux_2_4)
# linux 2.6 and higher kernel module build settings
EXTRA_CFLAGS += -DKERNEL_2_6
obj-m += udpencap.o
#-include $(ATH_SRC_BASE)/hif/$(ATH_HIF_TYPE)/Makefile
#udpencap-objs += udpencap.o
	 

# ATHENV

endif

ifeq ($(ATH_OS_SUB_TYPE),linux_2_4)
# linux 2.4 kernel module build settings
EXTRA_CFLAGS += -DKERNEL_2_4

O_TARGET := udpencap.o

obj-m += udpencap.o
              
#include $(ATH_LINUXPATH)/Rules.make
endif
