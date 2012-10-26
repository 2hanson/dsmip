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
	{ 0x39e4f3ef, "register_pernet_gen_device" },
	{ 0x4f8dc8a5, "xfrm4_tunnel_register" },
	{ 0xa3b0526e, "icmp_send" },
	{ 0x71ebd44d, "netif_rx" },
	{ 0xaab6b1de, "ipv6_chk_prefix" },
	{ 0x33bc5f97, "__secpath_destroy" },
	{ 0xafc9f6bd, "__pskb_pull_tail" },
	{ 0xa7fe9ab1, "ip_local_out" },
	{ 0xd0842782, "__ip_select_ident" },
	{ 0xd83791bc, "nf_conntrack_destroy" },
	{ 0xc7b762c3, "skb_push" },
	{ 0xfceb54e1, "sock_wfree" },
	{ 0xbfa0280, "kfree_skb" },
	{ 0x471aa3ab, "skb_realloc_headroom" },
	{ 0x9da5f17, "icmpv6_send" },
	{ 0xb72397d5, "printk" },
	{ 0xf6ebc03b, "net_ratelimit" },
	{ 0xd542439, "__ipv6_addr_type" },
	{ 0xb2fd5ceb, "__put_user_4" },
	{ 0x12da5bb2, "__kmalloc" },
	{ 0x2da418b5, "copy_to_user" },
	{ 0x7738e333, "netdev_state_change" },
	{ 0x7dceceac, "capable" },
	{ 0xf2a644fb, "copy_from_user" },
	{ 0x9d258f, "_write_lock" },
	{ 0x7d11c268, "jiffies" },
	{ 0x1a75caa3, "_read_lock" },
	{ 0xe4855bb8, "register_netdevice" },
	{ 0x2f7973b8, "dev_alloc_name" },
	{ 0x349cba85, "strchr" },
	{ 0x3c2c5af5, "sprintf" },
	{ 0x73e20c1c, "strlcpy" },
	{ 0xfcbb3eec, "__dev_get_by_index" },
	{ 0x82d037eb, "dst_release" },
	{ 0x3d632efb, "ip_route_output_key" },
	{ 0xd42b7232, "_write_unlock_bh" },
	{ 0xa2a1e5c9, "_write_lock_bh" },
	{ 0xb6dbdc2a, "register_netdev" },
	{ 0xe914e41e, "strcpy" },
	{ 0xe935ea6f, "init_net" },
	{ 0xd15e62f7, "alloc_netdev_mq" },
	{ 0xc397856c, "net_assign_generic" },
	{ 0x6dcedb09, "kmem_cache_alloc" },
	{ 0x5113d3a4, "malloc_sizes" },
	{ 0x37a0cba, "kfree" },
	{ 0x6e720ff2, "rtnl_unlock" },
	{ 0x655191a7, "unregister_netdevice" },
	{ 0xc7a4fbed, "rtnl_lock" },
	{ 0x94d507ae, "unregister_pernet_gen_device" },
	{ 0xe7b97e0e, "xfrm4_tunnel_deregister" },
	{ 0xc579b4c5, "free_netdev" },
};

static const char __module_depends[]
__used
__attribute__((section(".modinfo"))) =
"depends=tunnel4,ipv6";

