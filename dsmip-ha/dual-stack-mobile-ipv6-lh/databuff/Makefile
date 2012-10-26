#obj-m:=route_cache.o
obj-m:=databuff.o

KERNELBUILD:=/lib/modules/`uname -r`/build



default:
	make -C $(KERNELBUILD) M=$(shell pwd) modules

clean:
	rm -rf *.o *.ko *.mod *.mod.c .tmp_versions
