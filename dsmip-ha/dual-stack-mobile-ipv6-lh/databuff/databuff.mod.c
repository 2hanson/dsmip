#include <linux/module.h>
#include <linux/vermagic.h>
#include <linux/compiler.h>

MODULE_INFO(vermagic, VERMAGIC_STRING);

struct module __this_module
__attribute__((section(".gnu.linkonce.this_module"))) = {
 .name = KBUILD_MODNAME,
 .init = init_module,
#ifdef CONFIG_MODULE_UNLOAD
 .exit = cleanup_module,
#endif
 .arch = MODULE_ARCH_INIT,
};

static const struct modversion_info ____versions[]
__used
__attribute__((section("__versions"))) = {
	{ 0x748ac4fd, "struct_module" },
	{ 0x701d0ebd, "snprintf" },
	{ 0xff431f72, "skb_copy" },
	{ 0x6dcedb09, "kmem_cache_alloc" },
	{ 0x5113d3a4, "malloc_sizes" },
	{ 0x37a0cba, "kfree" },
	{ 0xbfa0280, "kfree_skb" },
	{ 0x7d11c268, "jiffies" },
	{ 0x5152e605, "memcmp" },
	{ 0x3de75058, "nf_register_hook" },
	{ 0x3a7e83d, "netlink_kernel_create" },
	{ 0xe935ea6f, "init_net" },
	{ 0x5619c10b, "sock_release" },
	{ 0x194ac894, "nf_unregister_hook" },
	{ 0xb72397d5, "printk" },
};

static const char __module_depends[]
__used
__attribute__((section(".modinfo"))) =
"depends=";

