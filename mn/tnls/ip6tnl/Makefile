obj-m:=ip6_tunnel.o
module-objs:=ip6_tunnel.o
KERNELDIR =/lib/modules/$(shell uname -r)/build
PWD :=$(shell pwd)
default:
	$(MAKE) -C $(KERNELDIR) M=$(PWD) modules