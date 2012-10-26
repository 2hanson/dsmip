cmd_/home/3240/external/dual-stack-mobile-ipv6-lh/udpencap/udpencap.mod.o := arm-eabi-gcc -Wp,-MD,/home/3240/external/dual-stack-mobile-ipv6-lh/udpencap/.udpencap.mod.o.d  -nostdinc -isystem /home/3240/prebuilt/linux-x86/toolchain/arm-eabi-4.2.1/bin/../lib/gcc/arm-eabi/4.2.1/include -Iinclude -Iinclude2 -I/home/3240/kernel/include -I/home/3240/kernel/arch/arm/include -include include/linux/autoconf.h   -I/home/3240/external/dual-stack-mobile-ipv6-lh/udpencap -D__KERNEL__ -mlittle-endian   -I/home/3240/kernel/arch/arm/mach-msm/include -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common -Werror-implicit-function-declaration -Os -marm -fno-omit-frame-pointer -mapcs -mno-sched-prolog -mabi=aapcs-linux -mno-thumb-interwork -D__LINUX_ARM_ARCH__=7 -march=armv5t -Wa,-march=armv7a -msoft-float -Uarm -fno-stack-protector -fno-omit-frame-pointer -fno-optimize-sibling-calls -g -Wdeclaration-after-statement -Wno-pointer-sign -fwrapv -DKERNEL_2_6  -D"KBUILD_STR(s)=\#s" -D"KBUILD_BASENAME=KBUILD_STR(udpencap.mod)"  -D"KBUILD_MODNAME=KBUILD_STR(udpencap)"  -DMODULE -c -o /home/3240/external/dual-stack-mobile-ipv6-lh/udpencap/udpencap.mod.o /home/3240/external/dual-stack-mobile-ipv6-lh/udpencap/udpencap.mod.c

deps_/home/3240/external/dual-stack-mobile-ipv6-lh/udpencap/udpencap.mod.o := \
  /home/3240/external/dual-stack-mobile-ipv6-lh/udpencap/udpencap.mod.c \
    $(wildcard include/config/module/unload.h) \
  /home/3240/kernel/include/linux/module.h \
    $(wildcard include/config/modules.h) \
    $(wildcard include/config/modversions.h) \
    $(wildcard include/config/unused/symbols.h) \
    $(wildcard include/config/generic/bug.h) \
    $(wildcard include/config/kallsyms.h) \
    $(wildcard include/config/markers.h) \
    $(wildcard include/config/tracepoints.h) \
    $(wildcard include/config/smp.h) \
    $(wildcard include/config/sysfs.h) \
  /home/3240/kernel/include/linux/list.h \
    $(wildcard include/config/debug/list.h) \
  /home/3240/kernel/include/linux/stddef.h \
  /home/3240/kernel/include/linux/compiler.h \
    $(wildcard include/config/trace/branch/profiling.h) \
    $(wildcard include/config/profile/all/branches.h) \
    $(wildcard include/config/enable/must/check.h) \
    $(wildcard include/config/enable/warn/deprecated.h) \
  /home/3240/kernel/include/linux/compiler-gcc.h \
    $(wildcard include/config/arch/supports/optimized/inlining.h) \
    $(wildcard include/config/optimize/inlining.h) \
  /home/3240/kernel/include/linux/compiler-gcc4.h \
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
  /home/3240/kernel/arch/arm/include/asm/errno.h \
  /home/3240/kernel/include/asm-generic/errno.h \
  /home/3240/kernel/include/asm-generic/errno-base.h \
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
  /home/3240/kernel/include/linux/vermagic.h \
  include/linux/utsrelease.h \

/home/3240/external/dual-stack-mobile-ipv6-lh/udpencap/udpencap.mod.o: $(deps_/home/3240/external/dual-stack-mobile-ipv6-lh/udpencap/udpencap.mod.o)

$(deps_/home/3240/external/dual-stack-mobile-ipv6-lh/udpencap/udpencap.mod.o):
