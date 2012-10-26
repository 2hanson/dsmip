obj-m:=udpencap.o
module-objs:=udpencap.o
KERNELDIR =/lib/modules/$(shell uname -r)/build
PWD :=$(shell pwd)


all:
	make mn
	make ha
	make udpencap
	make tunnels
	make ctrl

ctrl:   mn-ctrl.c
	gcc mn-ctrl.c -o ctrl 

mn:	arp.h  common.h  dhcp.h icmp.h  mn-xfrm.h  rtnl.h  tunlctl.h mn.c
	gcc mn.c -o mn 

ha:     dhcp.h common.h icmp.h  ha-xfrm.h  rtnl.h  tunlctl.h ha.c
	gcc ha.c -o ha

clean:
	rm *.o mn ha *~ *ko

tunnels:
	cp tnls/ip6tnl/ip6_tunnel.ko . 
	cp tnls/ipip/ipip.ko .
	cp tnls/sit/sit.ko .

udpencap:
	$(MAKE) -C $(KERNELDIR) M=$(PWD) modules
	rm modules.order
	rm Module.symvers
	rm -rf .tmp_versions
	rm udpencap.mod.o udpencap.mod.c udpencap.o