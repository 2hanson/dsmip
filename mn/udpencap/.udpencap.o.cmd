cmd_/home/3240/external/dual-stack-mobile-ipv6-lh/udpencap/udpencap.o := arm-eabi-gcc -Wp,-MD,/home/3240/external/dual-stack-mobile-ipv6-lh/udpencap/.udpencap.o.d  -nostdinc -isystem /home/3240/prebuilt/linux-x86/toolchain/arm-eabi-4.2.1/bin/../lib/gcc/arm-eabi/4.2.1/include -Iinclude -Iinclude2 -I/home/3240/kernel/include -I/home/3240/kernel/arch/arm/include -include include/linux/autoconf.h   -I/home/3240/external/dual-stack-mobile-ipv6-lh/udpencap -D__KERNEL__ -mlittle-endian   -I/home/3240/kernel/arch/arm/mach-msm/include -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common -Werror-implicit-function-declaration -Os -marm -fno-omit-frame-pointer -mapcs -mno-sched-prolog -mabi=aapcs-linux -mno-thumb-interwork -D__LINUX_ARM_ARCH__=7 -march=armv5t -Wa,-march=armv7a -msoft-float -Uarm -fno-stack-protector -fno-omit-frame-pointer -fno-optimize-sibling-calls -g -Wdeclaration-after-statement -Wno-pointer-sign -fwrapv -DKERNEL_2_6 -DMODULE -D"KBUILD_STR(s)=\#s" -D"KBUILD_BASENAME=KBUILD_STR(udpencap)"  -D"KBUILD_MODNAME=KBUILD_STR(udpencap)"  -c -o /home/3240/external/dual-stack-mobile-ipv6-lh/udpencap/udpencap.o /home/3240/external/dual-stack-mobile-ipv6-lh/udpencap/udpencap.c

deps_/home/3240/external/dual-stack-mobile-ipv6-lh/udpencap/udpencap.o := \
  /home/3240/external/dual-stack-mobile-ipv6-lh/udpencap/udpencap.c \
    $(wildcard include/config/inet/xfrm/udp/encap/natt.h) \
  /home/3240/kernel/include/linux/err.h \
  /home/3240/kernel/include/linux/compiler.h \
    $(wildcard include/config/trace/branch/profiling.h) \
    $(wildcard include/config/profile/all/branches.h) \
    $(wildcard include/config/enable/must/check.h) \
    $(wildcard include/config/enable/warn/deprecated.h) \
  /home/3240/kernel/include/linux/compiler-gcc.h \
    $(wildcard include/config/arch/supports/optimized/inlining.h) \
    $(wildcard include/config/optimize/inlining.h) \
  /home/3240/kernel/include/linux/compiler-gcc4.h \
  /home/3240/kernel/arch/arm/include/asm/errno.h \
  /home/3240/kernel/include/asm-generic/errno.h \
  /home/3240/kernel/include/asm-generic/errno-base.h \
  /home/3240/kernel/include/linux/module.h \
    $(wildcard include/config/modules.h) \
    $(wildcard include/config/modversions.h) \
    $(wildcard include/config/unused/symbols.h) \
    $(wildcard include/config/generic/bug.h) \
    $(wildcard include/config/kallsyms.h) \
    $(wildcard include/config/markers.h) \
    $(wildcard include/config/tracepoints.h) \
    $(wildcard include/config/module/unload.h) \
    $(wildcard include/config/smp.h) \
    $(wildcard include/config/sysfs.h) \
  /home/3240/kernel/include/linux/list.h \
    $(wildcard include/config/debug/list.h) \
  /home/3240/kernel/include/linux/stddef.h \
  /home/3240/kernel/include/linux/poison.h \
  /home/3240/kernel/include/linux/prefetch.h \
  /home/3240/kernel/include/linux/types.h \
    $(wildcard include/config/uid16.h) \
    $(wildcard include/config/lbd.h) \
    $(wildcard include/config/phys/addr/t/64bit.h) \
    $(wildcard include/config/64bit.h) \
  /home/3240/kernel/include/linux/posix_types.h \
  /home/3240/kernel/arch/arm/include/asm/posix_types.h \
  /home/3240/kernel/arch/arm/include/asm/types.h \
  /home/3240/kernel/include/asm-generic/int-ll64.h \
  /home/3240/kernel/arch/arm/include/asm/processor.h \
    $(wildcard include/config/mmu.h) \
  /home/3240/kernel/arch/arm/include/asm/ptrace.h \
    $(wildcard include/config/arm/thumb.h) \
  /home/3240/kernel/arch/arm/include/asm/hwcap.h \
  /home/3240/kernel/arch/arm/include/asm/cache.h \
  /home/3240/kernel/arch/arm/include/asm/system.h \
    $(wildcard include/config/cpu/xsc3.h) \
    $(wildcard include/config/cpu/sa1100.h) \
    $(wildcard include/config/cpu/sa110.h) \
  /home/3240/kernel/arch/arm/include/asm/memory.h \
    $(wildcard include/config/page/offset.h) \
    $(wildcard include/config/dram/size.h) \
    $(wildcard include/config/dram/base.h) \
    $(wildcard include/config/zone/dma.h) \
    $(wildcard include/config/discontigmem.h) \
    $(wildcard include/config/sparsemem.h) \
  /home/3240/kernel/include/linux/const.h \
  /home/3240/kernel/arch/arm/mach-msm/include/mach/memory.h \
    $(wildcard include/config/msm/stacked/memory.h) \
    $(wildcard include/config/arch/msm/scorpion.h) \
    $(wildcard include/config/arch/msm/arm11.h) \
    $(wildcard include/config/cache/l2x0.h) \
  /home/3240/kernel/arch/arm/include/asm/sizes.h \
  /home/3240/kernel/include/asm-generic/memory_model.h \
    $(wildcard include/config/flatmem.h) \
    $(wildcard include/config/sparsemem/vmemmap.h) \
  /home/3240/kernel/include/linux/linkage.h \
  /home/3240/kernel/arch/arm/include/asm/linkage.h \
  /home/3240/kernel/include/linux/irqflags.h \
    $(wildcard include/config/trace/irqflags.h) \
    $(wildcard include/config/irqsoff/tracer.h) \
    $(wildcard include/config/preempt/tracer.h) \
    $(wildcard include/config/trace/irqflags/support.h) \
    $(wildcard include/config/x86.h) \
  /home/3240/kernel/include/linux/typecheck.h \
  /home/3240/kernel/arch/arm/include/asm/irqflags.h \
  /home/3240/kernel/include/asm-generic/cmpxchg-local.h \
  /home/3240/kernel/include/asm-generic/cmpxchg.h \
  /home/3240/kernel/include/linux/stat.h \
  /home/3240/kernel/arch/arm/include/asm/stat.h \
  /home/3240/kernel/include/linux/time.h \
  /home/3240/kernel/include/linux/cache.h \
    $(wildcard include/config/arch/has/cache/line/size.h) \
  /home/3240/kernel/include/linux/kernel.h \
    $(wildcard include/config/preempt/voluntary.h) \
    $(wildcard include/config/debug/spinlock/sleep.h) \
    $(wildcard include/config/prove/locking.h) \
    $(wildcard include/config/printk.h) \
    $(wildcard include/config/dynamic/printk/debug.h) \
    $(wildcard include/config/numa.h) \
    $(wildcard include/config/ftrace/mcount/record.h) \
  /home/3240/prebuilt/linux-x86/toolchain/arm-eabi-4.2.1/bin/../lib/gcc/arm-eabi/4.2.1/include/stdarg.h \
  /home/3240/kernel/include/linux/bitops.h \
    $(wildcard include/config/generic/find/first/bit.h) \
    $(wildcard include/config/generic/find/last/bit.h) \
    $(wildcard include/config/generic/find/next/bit.h) \
  /home/3240/kernel/arch/arm/include/asm/bitops.h \
  /home/3240/kernel/include/asm-generic/bitops/non-atomic.h \
  /home/3240/kernel/include/asm-generic/bitops/fls64.h \
  /home/3240/kernel/include/asm-generic/bitops/sched.h \
  /home/3240/kernel/include/asm-generic/bitops/hweight.h \
  /home/3240/kernel/include/asm-generic/bitops/lock.h \
  /home/3240/kernel/include/linux/log2.h \
    $(wildcard include/config/arch/has/ilog2/u32.h) \
    $(wildcard include/config/arch/has/ilog2/u64.h) \
  /home/3240/kernel/include/linux/ratelimit.h \
  /home/3240/kernel/include/linux/param.h \
  /home/3240/kernel/arch/arm/include/asm/param.h \
    $(wildcard include/config/hz.h) \
  /home/3240/kernel/include/linux/dynamic_printk.h \
  /home/3240/kernel/arch/arm/include/asm/byteorder.h \
  /home/3240/kernel/include/linux/byteorder/little_endian.h \
  /home/3240/kernel/include/linux/swab.h \
  /home/3240/kernel/arch/arm/include/asm/swab.h \
  /home/3240/kernel/include/linux/byteorder/generic.h \
  /home/3240/kernel/arch/arm/include/asm/bug.h \
    $(wildcard include/config/bug.h) \
    $(wildcard include/config/debug/bugverbose.h) \
  /home/3240/kernel/include/asm-generic/bug.h \
    $(wildcard include/config/generic/bug/relative/pointers.h) \
  /home/3240/kernel/include/linux/seqlock.h \
  /home/3240/kernel/include/linux/spinlock.h \
    $(wildcard include/config/debug/spinlock.h) \
    $(wildcard include/config/generic/lockbreak.h) \
    $(wildcard include/config/preempt.h) \
    $(wildcard include/config/debug/lock/alloc.h) \
  /home/3240/kernel/include/linux/preempt.h \
    $(wildcard include/config/debug/preempt.h) \
    $(wildcard include/config/preempt/notifiers.h) \
  /home/3240/kernel/include/linux/thread_info.h \
    $(wildcard include/config/compat.h) \
  /home/3240/kernel/arch/arm/include/asm/thread_info.h \
    $(wildcard include/config/arm/thumbee.h) \
  /home/3240/kernel/arch/arm/include/asm/fpstate.h \
    $(wildcard include/config/vfpv3.h) \
    $(wildcard include/config/iwmmxt.h) \
  /home/3240/kernel/arch/arm/include/asm/domain.h \
    $(wildcard include/config/io/36.h) \
    $(wildcard include/config/emulate/domain/manager/v7.h) \
  /home/3240/kernel/include/linux/stringify.h \
  /home/3240/kernel/include/linux/bottom_half.h \
  /home/3240/kernel/include/linux/spinlock_types.h \
  /home/3240/kernel/include/linux/spinlock_types_up.h \
  /home/3240/kernel/include/linux/lockdep.h \
    $(wildcard include/config/lockdep.h) \
    $(wildcard include/config/lock/stat.h) \
    $(wildcard include/config/generic/hardirqs.h) \
  /home/3240/kernel/include/linux/debug_locks.h \
    $(wildcard include/config/debug/locking/api/selftests.h) \
  /home/3240/kernel/include/linux/stacktrace.h \
    $(wildcard include/config/stacktrace.h) \
    $(wildcard include/config/user/stacktrace/support.h) \
  /home/3240/kernel/include/linux/spinlock_up.h \
  /home/3240/kernel/include/linux/spinlock_api_smp.h \
  /home/3240/kernel/arch/arm/include/asm/atomic.h \
  /home/3240/kernel/include/asm-generic/atomic.h \
  /home/3240/kernel/include/linux/math64.h \
  /home/3240/kernel/arch/arm/include/asm/div64.h \
  /home/3240/kernel/include/linux/kmod.h \
  /home/3240/kernel/include/linux/gfp.h \
    $(wildcard include/config/zone/dma32.h) \
    $(wildcard include/config/highmem.h) \
  /home/3240/kernel/include/linux/mmzone.h \
    $(wildcard include/config/force/max/zoneorder.h) \
    $(wildcard include/config/unevictable/lru.h) \
    $(wildcard include/config/memory/hotplug.h) \
    $(wildcard include/config/arch/populates/node/map.h) \
    $(wildcard include/config/flat/node/mem/map.h) \
    $(wildcard include/config/cgroup/mem/res/ctlr.h) \
    $(wildcard include/config/have/memory/present.h) \
    $(wildcard include/config/need/node/memmap/size.h) \
    $(wildcard include/config/need/multiple/nodes.h) \
    $(wildcard include/config/have/arch/early/pfn/to/nid.h) \
    $(wildcard include/config/sparsemem/extreme.h) \
    $(wildcard include/config/nodes/span/other/nodes.h) \
    $(wildcard include/config/holes/in/zone.h) \
  /home/3240/kernel/include/linux/wait.h \
  /home/3240/kernel/arch/arm/include/asm/current.h \
  /home/3240/kernel/include/linux/threads.h \
    $(wildcard include/config/nr/cpus.h) \
    $(wildcard include/config/base/small.h) \
  /home/3240/kernel/include/linux/numa.h \
    $(wildcard include/config/nodes/shift.h) \
  /home/3240/kernel/include/linux/init.h \
    $(wildcard include/config/hotplug.h) \
  /home/3240/kernel/include/linux/nodemask.h \
  /home/3240/kernel/include/linux/bitmap.h \
  /home/3240/kernel/include/linux/string.h \
  /home/3240/kernel/arch/arm/include/asm/string.h \
  /home/3240/kernel/include/linux/pageblock-flags.h \
    $(wildcard include/config/hugetlb/page.h) \
    $(wildcard include/config/hugetlb/page/size/variable.h) \
  include/linux/bounds.h \
  /home/3240/kernel/arch/arm/include/asm/page.h \
    $(wildcard include/config/cpu/copy/v3.h) \
    $(wildcard include/config/cpu/copy/v4wt.h) \
    $(wildcard include/config/cpu/copy/v4wb.h) \
    $(wildcard include/config/cpu/copy/feroceon.h) \
    $(wildcard include/config/cpu/xscale.h) \
    $(wildcard include/config/cpu/copy/v6.h) \
    $(wildcard include/config/aeabi.h) \
  /home/3240/kernel/arch/arm/include/asm/glue.h \
    $(wildcard include/config/cpu/arm610.h) \
    $(wildcard include/config/cpu/arm710.h) \
    $(wildcard include/config/cpu/abrt/lv4t.h) \
    $(wildcard include/config/cpu/abrt/ev4.h) \
    $(wildcard include/config/cpu/abrt/ev4t.h) \
    $(wildcard include/config/cpu/abrt/ev5tj.h) \
    $(wildcard include/config/cpu/abrt/ev5t.h) \
    $(wildcard include/config/cpu/abrt/ev6.h) \
    $(wildcard include/config/cpu/abrt/ev7.h) \
    $(wildcard include/config/cpu/pabrt/ifar.h) \
    $(wildcard include/config/cpu/pabrt/noifar.h) \
  /home/3240/kernel/include/asm-generic/page.h \
  /home/3240/kernel/include/linux/memory_hotplug.h \
    $(wildcard include/config/have/arch/nodedata/extension.h) \
    $(wildcard include/config/memory/hotremove.h) \
  /home/3240/kernel/include/linux/notifier.h \
  /home/3240/kernel/include/linux/errno.h \
  /home/3240/kernel/include/linux/mutex.h \
    $(wildcard include/config/debug/mutexes.h) \
  /home/3240/kernel/include/linux/mutex-debug.h \
  /home/3240/kernel/include/linux/rwsem.h \
    $(wildcard include/config/rwsem/generic/spinlock.h) \
  /home/3240/kernel/include/linux/rwsem-spinlock.h \
  /home/3240/kernel/include/linux/srcu.h \
  /home/3240/kernel/include/linux/topology.h \
    $(wildcard include/config/sched/smt.h) \
    $(wildcard include/config/sched/mc.h) \
  /home/3240/kernel/include/linux/cpumask.h \
    $(wildcard include/config/disable/obsolete/cpumask/functions.h) \
    $(wildcard include/config/hotplug/cpu.h) \
    $(wildcard include/config/cpumask/offstack.h) \
    $(wildcard include/config/debug/per/cpu/maps.h) \
  /home/3240/kernel/include/linux/smp.h \
    $(wildcard include/config/use/generic/smp/helpers.h) \
  /home/3240/kernel/arch/arm/include/asm/topology.h \
  /home/3240/kernel/include/asm-generic/topology.h \
  /home/3240/kernel/include/linux/elf.h \
  /home/3240/kernel/include/linux/elf-em.h \
  /home/3240/kernel/arch/arm/include/asm/elf.h \
  /home/3240/kernel/arch/arm/include/asm/user.h \
  /home/3240/kernel/include/linux/kobject.h \
  /home/3240/kernel/include/linux/sysfs.h \
  /home/3240/kernel/include/linux/kref.h \
  /home/3240/kernel/include/linux/moduleparam.h \
    $(wildcard include/config/alpha.h) \
    $(wildcard include/config/ia64.h) \
    $(wildcard include/config/ppc64.h) \
  /home/3240/kernel/include/linux/marker.h \
  /home/3240/kernel/include/linux/tracepoint.h \
  /home/3240/kernel/include/linux/rcupdate.h \
    $(wildcard include/config/classic/rcu.h) \
    $(wildcard include/config/tree/rcu.h) \
    $(wildcard include/config/preempt/rcu.h) \
  /home/3240/kernel/include/linux/percpu.h \
  /home/3240/kernel/include/linux/slab.h \
    $(wildcard include/config/slab/debug.h) \
    $(wildcard include/config/debug/objects.h) \
    $(wildcard include/config/slub.h) \
    $(wildcard include/config/slob.h) \
    $(wildcard include/config/debug/slab.h) \
  /home/3240/kernel/include/linux/slab_def.h \
  /home/3240/kernel/include/linux/kmalloc_sizes.h \
  /home/3240/kernel/arch/arm/include/asm/percpu.h \
  /home/3240/kernel/include/asm-generic/percpu.h \
    $(wildcard include/config/have/setup/per/cpu/area.h) \
  /home/3240/kernel/include/linux/completion.h \
  /home/3240/kernel/include/linux/rcuclassic.h \
    $(wildcard include/config/rcu/cpu/stall/detector.h) \
  /home/3240/kernel/arch/arm/include/asm/local.h \
  /home/3240/kernel/include/asm-generic/local.h \
  /home/3240/kernel/arch/arm/include/asm/module.h \
  include/linux/version.h \
  /home/3240/kernel/include/net/ip.h \
    $(wildcard include/config/inet.h) \
    $(wildcard include/config/ipv6.h) \
    $(wildcard include/config/proc/fs.h) \
  /home/3240/kernel/include/linux/ip.h \
  /home/3240/kernel/include/linux/skbuff.h \
    $(wildcard include/config/nf/conntrack.h) \
    $(wildcard include/config/bridge/netfilter.h) \
    $(wildcard include/config/has/dma.h) \
    $(wildcard include/config/xfrm.h) \
    $(wildcard include/config/net/sched.h) \
    $(wildcard include/config/net/cls/act.h) \
    $(wildcard include/config/ipv6/ndisc/nodetype.h) \
    $(wildcard include/config/mac80211.h) \
    $(wildcard include/config/net/dma.h) \
    $(wildcard include/config/network/secmark.h) \
  /home/3240/kernel/include/linux/net.h \
    $(wildcard include/config/sysctl.h) \
  /home/3240/kernel/include/linux/socket.h \
  /home/3240/kernel/arch/arm/include/asm/socket.h \
  /home/3240/kernel/arch/arm/include/asm/sockios.h \
  /home/3240/kernel/include/linux/sockios.h \
  /home/3240/kernel/include/linux/uio.h \
  /home/3240/kernel/include/linux/random.h \
  /home/3240/kernel/include/linux/ioctl.h \
  /home/3240/kernel/arch/arm/include/asm/ioctl.h \
  /home/3240/kernel/include/asm-generic/ioctl.h \
  /home/3240/kernel/include/linux/irqnr.h \
  /home/3240/kernel/include/linux/fcntl.h \
  /home/3240/kernel/arch/arm/include/asm/fcntl.h \
  /home/3240/kernel/include/asm-generic/fcntl.h \
  /home/3240/kernel/include/linux/sysctl.h \
  /home/3240/kernel/include/linux/textsearch.h \
  /home/3240/kernel/include/net/checksum.h \
  /home/3240/kernel/arch/arm/include/asm/uaccess.h \
  /home/3240/kernel/arch/arm/include/asm/checksum.h \
  /home/3240/kernel/include/linux/in6.h \
  /home/3240/kernel/include/linux/dmaengine.h \
    $(wildcard include/config/dma/engine.h) \
  /home/3240/kernel/include/linux/device.h \
    $(wildcard include/config/debug/devres.h) \
  /home/3240/kernel/include/linux/ioport.h \
  /home/3240/kernel/include/linux/klist.h \
  /home/3240/kernel/include/linux/pm.h \
    $(wildcard include/config/pm/sleep.h) \
  /home/3240/kernel/include/linux/semaphore.h \
  /home/3240/kernel/arch/arm/include/asm/device.h \
    $(wildcard include/config/dmabounce.h) \
  /home/3240/kernel/include/linux/pm_wakeup.h \
    $(wildcard include/config/pm.h) \
  /home/3240/kernel/include/linux/dma-mapping.h \
    $(wildcard include/config/have/dma/attrs.h) \
  /home/3240/kernel/arch/arm/include/asm/dma-mapping.h \
  /home/3240/kernel/include/linux/mm_types.h \
    $(wildcard include/config/split/ptlock/cpus.h) \
    $(wildcard include/config/mm/owner.h) \
    $(wildcard include/config/mmu/notifier.h) \
  /home/3240/kernel/include/linux/auxvec.h \
  /home/3240/kernel/arch/arm/include/asm/auxvec.h \
  /home/3240/kernel/include/linux/prio_tree.h \
  /home/3240/kernel/include/linux/rbtree.h \
  /home/3240/kernel/arch/arm/include/asm/mmu.h \
    $(wildcard include/config/cpu/has/asid.h) \
  /home/3240/kernel/include/linux/scatterlist.h \
    $(wildcard include/config/debug/sg.h) \
  /home/3240/kernel/arch/arm/include/asm/scatterlist.h \
  /home/3240/kernel/include/linux/mm.h \
    $(wildcard include/config/stack/growsup.h) \
    $(wildcard include/config/swap.h) \
    $(wildcard include/config/shmem.h) \
    $(wildcard include/config/debug/pagealloc.h) \
    $(wildcard include/config/hibernation.h) \
  /home/3240/kernel/include/linux/mmdebug.h \
    $(wildcard include/config/debug/vm.h) \
    $(wildcard include/config/debug/virtual.h) \
  /home/3240/kernel/arch/arm/include/asm/pgtable.h \
  /home/3240/kernel/include/asm-generic/4level-fixup.h \
  /home/3240/kernel/arch/arm/include/asm/proc-fns.h \
    $(wildcard include/config/cpu/32.h) \
    $(wildcard include/config/cpu/arm7tdmi.h) \
    $(wildcard include/config/cpu/arm720t.h) \
    $(wildcard include/config/cpu/arm740t.h) \
    $(wildcard include/config/cpu/arm9tdmi.h) \
    $(wildcard include/config/cpu/arm920t.h) \
    $(wildcard include/config/cpu/arm922t.h) \
    $(wildcard include/config/cpu/arm925t.h) \
    $(wildcard include/config/cpu/arm926t.h) \
    $(wildcard include/config/cpu/arm940t.h) \
    $(wildcard include/config/cpu/arm946e.h) \
    $(wildcard include/config/cpu/arm1020.h) \
    $(wildcard include/config/cpu/arm1020e.h) \
    $(wildcard include/config/cpu/arm1022.h) \
    $(wildcard include/config/cpu/arm1026.h) \
    $(wildcard include/config/cpu/feroceon.h) \
    $(wildcard include/config/cpu/v6.h) \
    $(wildcard include/config/cpu/v7.h) \
  /home/3240/kernel/arch/arm/include/asm/cpu-single.h \
  /home/3240/kernel/arch/arm/mach-msm/include/mach/vmalloc.h \
    $(wildcard include/config/vmsplit/2g.h) \
  /home/3240/kernel/arch/arm/include/asm/pgtable-hwdef.h \
  /home/3240/kernel/include/asm-generic/pgtable.h \
  /home/3240/kernel/include/linux/page-flags.h \
    $(wildcard include/config/pageflags/extended.h) \
    $(wildcard include/config/ia64/uncached/allocator.h) \
    $(wildcard include/config/s390.h) \
  /home/3240/kernel/include/linux/vmstat.h \
    $(wildcard include/config/vm/event/counters.h) \
  /home/3240/kernel/arch/arm/include/asm/io.h \
  /home/3240/kernel/arch/arm/mach-msm/include/mach/io.h \
  /home/3240/kernel/include/asm-generic/dma-coherent.h \
    $(wildcard include/config/have/generic/dma/coherent.h) \
  /home/3240/kernel/include/linux/hrtimer.h \
    $(wildcard include/config/timer/stats.h) \
    $(wildcard include/config/high/res/timers.h) \
    $(wildcard include/config/debug/objects/timers.h) \
  /home/3240/kernel/include/linux/ktime.h \
    $(wildcard include/config/ktime/scalar.h) \
  /home/3240/kernel/include/linux/jiffies.h \
  /home/3240/kernel/include/linux/timex.h \
    $(wildcard include/config/no/hz.h) \
  /home/3240/kernel/arch/arm/include/asm/timex.h \
  /home/3240/kernel/arch/arm/mach-msm/include/mach/timex.h \
  /home/3240/kernel/include/linux/in.h \
  /home/3240/kernel/include/net/inet_sock.h \
  /home/3240/kernel/include/linux/jhash.h \
  /home/3240/kernel/include/net/flow.h \
  /home/3240/kernel/include/net/sock.h \
    $(wildcard include/config/net/ns.h) \
    $(wildcard include/config/security.h) \
  /home/3240/kernel/include/linux/list_nulls.h \
  /home/3240/kernel/include/linux/timer.h \
  /home/3240/kernel/include/linux/debugobjects.h \
    $(wildcard include/config/debug/objects/free.h) \
  /home/3240/kernel/include/linux/netdevice.h \
    $(wildcard include/config/dcb.h) \
    $(wildcard include/config/wlan/80211.h) \
    $(wildcard include/config/ax25.h) \
    $(wildcard include/config/mac80211/mesh.h) \
    $(wildcard include/config/tr.h) \
    $(wildcard include/config/net/ipip.h) \
    $(wildcard include/config/net/ipgre.h) \
    $(wildcard include/config/ipv6/sit.h) \
    $(wildcard include/config/ipv6/tunnel.h) \
    $(wildcard include/config/netpoll.h) \
    $(wildcard include/config/net/poll/controller.h) \
    $(wildcard include/config/wireless/ext.h) \
    $(wildcard include/config/net/dsa.h) \
    $(wildcard include/config/compat/net/dev/ops.h) \
    $(wildcard include/config/net/dsa/tag/dsa.h) \
    $(wildcard include/config/net/dsa/tag/trailer.h) \
    $(wildcard include/config/netpoll/trap.h) \
  /home/3240/kernel/include/linux/if.h \
  /home/3240/kernel/include/linux/hdlc/ioctl.h \
  /home/3240/kernel/include/linux/if_ether.h \
  /home/3240/kernel/include/linux/if_packet.h \
  /home/3240/kernel/include/linux/delay.h \
  /home/3240/kernel/arch/arm/include/asm/delay.h \
  /home/3240/kernel/include/linux/workqueue.h \
  /home/3240/kernel/include/net/net_namespace.h \
    $(wildcard include/config/ip/dccp.h) \
    $(wildcard include/config/netfilter.h) \
    $(wildcard include/config/net.h) \
  /home/3240/kernel/include/net/netns/core.h \
  /home/3240/kernel/include/net/netns/mib.h \
    $(wildcard include/config/xfrm/statistics.h) \
  /home/3240/kernel/include/net/snmp.h \
  /home/3240/kernel/include/linux/snmp.h \
  /home/3240/kernel/include/net/netns/unix.h \
  /home/3240/kernel/include/net/netns/packet.h \
  /home/3240/kernel/include/net/netns/ipv4.h \
    $(wildcard include/config/ip/multiple/tables.h) \
  /home/3240/kernel/include/net/inet_frag.h \
  /home/3240/kernel/include/net/netns/ipv6.h \
    $(wildcard include/config/ipv6/multiple/tables.h) \
    $(wildcard include/config/ipv6/mroute.h) \
    $(wildcard include/config/ipv6/pimsm/v2.h) \
  /home/3240/kernel/include/net/netns/dccp.h \
  /home/3240/kernel/include/net/netns/x_tables.h \
  /home/3240/kernel/include/linux/netfilter.h \
    $(wildcard include/config/netfilter/debug.h) \
    $(wildcard include/config/nf/nat/needed.h) \
  /home/3240/kernel/include/linux/proc_fs.h \
    $(wildcard include/config/proc/devicetree.h) \
    $(wildcard include/config/proc/kcore.h) \
  /home/3240/kernel/include/linux/fs.h \
    $(wildcard include/config/dnotify.h) \
    $(wildcard include/config/quota.h) \
    $(wildcard include/config/inotify.h) \
    $(wildcard include/config/epoll.h) \
    $(wildcard include/config/debug/writecount.h) \
    $(wildcard include/config/file/locking.h) \
    $(wildcard include/config/auditsyscall.h) \
    $(wildcard include/config/block.h) \
    $(wildcard include/config/fs/xip.h) \
    $(wildcard include/config/migration.h) \
  /home/3240/kernel/include/linux/limits.h \
  /home/3240/kernel/include/linux/kdev_t.h \
  /home/3240/kernel/include/linux/dcache.h \
  /home/3240/kernel/include/linux/rculist.h \
  /home/3240/kernel/include/linux/path.h \
  /home/3240/kernel/include/linux/radix-tree.h \
  /home/3240/kernel/include/linux/pid.h \
  /home/3240/kernel/include/linux/capability.h \
    $(wildcard include/config/security/file/capabilities.h) \
  /home/3240/kernel/include/linux/fiemap.h \
  /home/3240/kernel/include/linux/quota.h \
  /home/3240/kernel/include/linux/dqblk_xfs.h \
  /home/3240/kernel/include/linux/dqblk_v1.h \
  /home/3240/kernel/include/linux/dqblk_v2.h \
  /home/3240/kernel/include/linux/dqblk_qtree.h \
  /home/3240/kernel/include/linux/nfs_fs_i.h \
  /home/3240/kernel/include/linux/nfs.h \
  /home/3240/kernel/include/linux/sunrpc/msg_prot.h \
  /home/3240/kernel/include/linux/magic.h \
  /home/3240/kernel/include/net/netns/conntrack.h \
    $(wildcard include/config/nf/conntrack/events.h) \
  /home/3240/kernel/include/net/netns/xfrm.h \
  /home/3240/kernel/include/linux/xfrm.h \
  /home/3240/kernel/include/linux/seq_file_net.h \
  /home/3240/kernel/include/linux/seq_file.h \
  /home/3240/kernel/include/net/dsa.h \
  /home/3240/kernel/include/linux/interrupt.h \
    $(wildcard include/config/generic/irq/probe.h) \
  /home/3240/kernel/include/linux/irqreturn.h \
  /home/3240/kernel/include/linux/hardirq.h \
    $(wildcard include/config/virt/cpu/accounting.h) \
  /home/3240/kernel/include/linux/smp_lock.h \
    $(wildcard include/config/lock/kernel.h) \
  /home/3240/kernel/include/linux/sched.h \
    $(wildcard include/config/sched/debug.h) \
    $(wildcard include/config/detect/softlockup.h) \
    $(wildcard include/config/core/dump/default/elf/headers.h) \
    $(wildcard include/config/bsd/process/acct.h) \
    $(wildcard include/config/taskstats.h) \
    $(wildcard include/config/audit.h) \
    $(wildcard include/config/inotify/user.h) \
    $(wildcard include/config/posix/mqueue.h) \
    $(wildcard include/config/keys.h) \
    $(wildcard include/config/user/sched.h) \
    $(wildcard include/config/schedstats.h) \
    $(wildcard include/config/task/delay/acct.h) \
    $(wildcard include/config/fair/group/sched.h) \
    $(wildcard include/config/rt/group/sched.h) \
    $(wildcard include/config/blk/dev/io/trace.h) \
    $(wildcard include/config/cc/stackprotector.h) \
    $(wildcard include/config/x86/ptrace/bts.h) \
    $(wildcard include/config/sysvipc.h) \
    $(wildcard include/config/rt/mutexes.h) \
    $(wildcard include/config/task/xacct.h) \
    $(wildcard include/config/cpusets.h) \
    $(wildcard include/config/cgroups.h) \
    $(wildcard include/config/futex.h) \
    $(wildcard include/config/fault/injection.h) \
    $(wildcard include/config/latencytop.h) \
    $(wildcard include/config/function/graph/tracer.h) \
    $(wildcard include/config/tracing.h) \
    $(wildcard include/config/have/unstable/sched/clock.h) \
    $(wildcard include/config/preempt/bkl.h) \
    $(wildcard include/config/group/sched.h) \
  /home/3240/kernel/arch/arm/include/asm/cputime.h \
  /home/3240/kernel/include/asm-generic/cputime.h \
  /home/3240/kernel/include/linux/sem.h \
  /home/3240/kernel/include/linux/ipc.h \
  /home/3240/kernel/arch/arm/include/asm/ipcbuf.h \
  /home/3240/kernel/arch/arm/include/asm/sembuf.h \
  /home/3240/kernel/include/linux/signal.h \
  /home/3240/kernel/arch/arm/include/asm/signal.h \
  /home/3240/kernel/include/asm-generic/signal.h \
  /home/3240/kernel/arch/arm/include/asm/sigcontext.h \
  /home/3240/kernel/arch/arm/include/asm/siginfo.h \
  /home/3240/kernel/include/asm-generic/siginfo.h \
  /home/3240/kernel/include/linux/fs_struct.h \
  /home/3240/kernel/include/linux/proportions.h \
  /home/3240/kernel/include/linux/percpu_counter.h \
  /home/3240/kernel/include/linux/seccomp.h \
    $(wildcard include/config/seccomp.h) \
  /home/3240/kernel/include/linux/rtmutex.h \
    $(wildcard include/config/debug/rt/mutexes.h) \
  /home/3240/kernel/include/linux/plist.h \
    $(wildcard include/config/debug/pi/list.h) \
  /home/3240/kernel/include/linux/resource.h \
  /home/3240/kernel/arch/arm/include/asm/resource.h \
  /home/3240/kernel/include/asm-generic/resource.h \
  /home/3240/kernel/include/linux/task_io_accounting.h \
    $(wildcard include/config/task/io/accounting.h) \
  /home/3240/kernel/include/linux/latencytop.h \
  /home/3240/kernel/include/linux/cred.h \
  /home/3240/kernel/include/linux/key.h \
  /home/3240/kernel/include/linux/aio.h \
    $(wildcard include/config/aio.h) \
  /home/3240/kernel/include/linux/aio_abi.h \
  /home/3240/kernel/include/linux/ftrace_irq.h \
    $(wildcard include/config/dynamic/ftrace.h) \
  /home/3240/kernel/arch/arm/include/asm/hardirq.h \
  /home/3240/kernel/arch/arm/include/asm/irq.h \
  /home/3240/kernel/arch/arm/mach-msm/include/mach/irqs.h \
    $(wildcard include/config/arch/msm7x30.h) \
    $(wildcard include/config/arch/qsd8x50.h) \
  /home/3240/kernel/arch/arm/mach-msm/include/mach/irqs-8xxx.h \
  /home/3240/kernel/arch/arm/mach-msm/include/mach/sirc.h \
  /home/3240/kernel/arch/arm/mach-msm/include/mach/msm_iomap.h \
    $(wildcard include/config/msm/debug/uart.h) \
  /home/3240/kernel/include/linux/irq_cpustat.h \
  /home/3240/kernel/include/linux/security.h \
    $(wildcard include/config/security/path.h) \
    $(wildcard include/config/security/network.h) \
    $(wildcard include/config/security/network/xfrm.h) \
    $(wildcard include/config/securityfs.h) \
  /home/3240/kernel/include/linux/binfmts.h \
  /home/3240/kernel/include/linux/shm.h \
  /home/3240/kernel/arch/arm/include/asm/shmparam.h \
  /home/3240/kernel/arch/arm/include/asm/shmbuf.h \
  /home/3240/kernel/include/linux/msg.h \
  /home/3240/kernel/arch/arm/include/asm/msgbuf.h \
  /home/3240/kernel/include/linux/filter.h \
  /home/3240/kernel/include/linux/rculist_nulls.h \
  /home/3240/kernel/include/net/dst.h \
    $(wildcard include/config/net/cls/route.h) \
  /home/3240/kernel/include/linux/rtnetlink.h \
  /home/3240/kernel/include/linux/netlink.h \
  /home/3240/kernel/include/linux/if_link.h \
  /home/3240/kernel/include/linux/if_addr.h \
  /home/3240/kernel/include/linux/neighbour.h \
  /home/3240/kernel/include/net/neighbour.h \
  /home/3240/kernel/include/net/rtnetlink.h \
  /home/3240/kernel/include/net/netlink.h \
  /home/3240/kernel/include/net/request_sock.h \
  /home/3240/kernel/include/linux/bug.h \
  /home/3240/kernel/include/net/netns/hash.h \
  /home/3240/kernel/include/net/xfrm.h \
    $(wildcard include/config/xfrm/sub/policy.h) \
    $(wildcard include/config/xfrm/migrate.h) \
  /home/3240/kernel/include/linux/pfkeyv2.h \
  /home/3240/kernel/include/linux/ipsec.h \
  /home/3240/kernel/include/linux/audit.h \
    $(wildcard include/config/change.h) \
  /home/3240/kernel/include/net/route.h \
  /home/3240/kernel/include/net/inetpeer.h \
  /home/3240/kernel/include/linux/in_route.h \
  /home/3240/kernel/include/linux/route.h \
  /home/3240/kernel/include/net/ipv6.h \
  /home/3240/kernel/include/linux/ipv6.h \
    $(wildcard include/config/ipv6/privacy.h) \
    $(wildcard include/config/ipv6/router/pref.h) \
    $(wildcard include/config/ipv6/route/info.h) \
    $(wildcard include/config/ipv6/optimistic/dad.h) \
    $(wildcard include/config/ipv6/mip6.h) \
    $(wildcard include/config/ipv6/subtrees.h) \
  /home/3240/kernel/include/linux/icmpv6.h \
  /home/3240/kernel/include/linux/tcp.h \
    $(wildcard include/config/tcp/md5sig.h) \
  /home/3240/kernel/include/net/inet_connection_sock.h \
  /home/3240/kernel/include/linux/poll.h \
  /home/3240/kernel/arch/arm/include/asm/poll.h \
  /home/3240/kernel/include/asm-generic/poll.h \
  /home/3240/kernel/include/net/inet_timewait_sock.h \
  /home/3240/kernel/include/net/tcp_states.h \
  /home/3240/kernel/include/net/timewait_sock.h \
  /home/3240/kernel/include/linux/udp.h \
  /home/3240/kernel/include/net/if_inet6.h \
  /home/3240/kernel/include/net/ndisc.h \
  /home/3240/kernel/include/net/ip6_fib.h \
  /home/3240/kernel/include/linux/ipv6_route.h \
  /home/3240/kernel/include/net/icmp.h \
  /home/3240/kernel/include/linux/icmp.h \
  /home/3240/kernel/include/net/protocol.h \
  /home/3240/kernel/include/net/udp.h \
  /home/3240/kernel/include/net/inet_ecn.h \
  /home/3240/kernel/include/net/dsfield.h \
  /home/3240/kernel/include/linux/netfilter_ipv4.h \

/home/3240/external/dual-stack-mobile-ipv6-lh/udpencap/udpencap.o: $(deps_/home/3240/external/dual-stack-mobile-ipv6-lh/udpencap/udpencap.o)

$(deps_/home/3240/external/dual-stack-mobile-ipv6-lh/udpencap/udpencap.o):
