/********************************
	File name: databuff.c
	Create on: June 10, 2009 JXW
	Description: Buffer the recent 1s' data to mn via HA.When the mn handover to a new GW, HA send the buffered data to mn.
	Last modified: June 10, 2009 JXW
********************************/
#include <net/sock.h>
#include <linux/sched.h>
#include <linux/kernel.h>	/* printk() */
#include <linux/slab.h>		/* kmalloc() */
#include <linux/errno.h>	/* error codes */
#include <linux/types.h>	/* size_t */
#include <linux/interrupt.h>	/* mark_bh */
#include <linux/netdevice.h>	/* struct device, and other headers */
#include <linux/etherdevice.h>	/* eth_type_trans */
#include <linux/ip.h>		/* struct iphdr */
#include <linux/ipv6.h>		/* struct ipv6hdr */
#include <linux/tcp.h>		/* struct tcphdr */
#include <linux/skbuff.h>
#include <linux/socket.h>
#include<asm/uaccess.h>
#include <linux/init.h>
#include <linux/module.h>
#include<linux/kmod.h>
#include <linux/list.h>
#include <linux/jiffies.h>
#undef __KERNEL__//for 29
#include <linux/netfilter.h>
#include <linux/netfilter_ipv6.h>
#include <linux/netfilter_ipv4.h>
#define __KERNEL__//for 29
#include <linux/time.h>
#include <linux/netlink.h>
#include <linux/delay.h>
#include <asm/param.h>
#include <linux/in.h>
#include "imp2.h"

//#include <linux/gfp.h>

#define MAX_MN_COUNT	1000
/************  begin for 29  ******************/
#ifndef NIP6
#define NIP6(addr) \
        ntohs((addr).s6_addr16[0]), \
        ntohs((addr).s6_addr16[1]), \
        ntohs((addr).s6_addr16[2]), \
        ntohs((addr).s6_addr16[3]), \
        ntohs((addr).s6_addr16[4]), \
        ntohs((addr).s6_addr16[5]), \
        ntohs((addr).s6_addr16[6]), \
        ntohs((addr).s6_addr16[7])
#endif
/************   end  for 29  ******************/

struct packet_list
{
  struct sk_buff *skb;
  int (*okfn) (struct sk_buff *);
  unsigned long ariv_jiffies;
  struct packet_list *next;
};

struct mn_list
{
  struct in6_addr hoa;
  struct in_addr hoav4;
  struct in6_addr coa;
  int FORWARD_INSTANT;
  struct packet_list *packets_head;
  struct packet_list *packets_tail;
} MN_LIST[MAX_MN_COUNT];
int mncount = 0;
int
add_mnlist (struct in6_addr hoa, struct in_addr hoav4, struct in6_addr coa)
{
  if (mncount > MAX_MN_COUNT)
    return -1;
  MN_LIST[mncount].hoa = hoa;
  MN_LIST[mncount].hoav4 = hoav4;
  MN_LIST[mncount].coa = coa;
  MN_LIST[mncount].FORWARD_INSTANT = 1;
  mncount++;
  return 1;
}

void
send_buffered_data (int mnindex)
{
  struct packet_list *temp_packet_list;
  MN_LIST[mnindex].FORWARD_INSTANT = 0;
  printk ("%s:%d\n", __FUNCTION__, __LINE__);
  //删除过期数据包
  while (MN_LIST[mnindex].packets_head != NULL)
    if (time_before
	(MN_LIST[mnindex].packets_head->ariv_jiffies, jiffies - HZ))
      {
	temp_packet_list = MN_LIST[mnindex].packets_head;
	MN_LIST[mnindex].packets_head = MN_LIST[mnindex].packets_head->next;
	kfree_skb (temp_packet_list->skb);
	kfree (temp_packet_list);
      }
    else
      break;
  while (MN_LIST[mnindex].packets_head != NULL)
    {
      //printk("databuf is sending data\n");
      temp_packet_list = MN_LIST[mnindex].packets_head;
      MN_LIST[mnindex].packets_head = MN_LIST[mnindex].packets_head->next;
      temp_packet_list->okfn (temp_packet_list->skb);
      kfree (temp_packet_list);
    }
  MN_LIST[mnindex].FORWARD_INSTANT = 1;
}

int
in_mnlistv6 (struct in6_addr hoa)
{
  int i;
  for (i = 0; i < mncount; i++)
    if (memcmp (&hoa, &MN_LIST[i].hoa, sizeof (struct in6_addr)) == 0)
      return i;
  return -1;
}

int
in_mnlistv4 (struct in_addr hoa)
{
  int i;
  for (i = 0; i < mncount; i++)
    if (memcmp (&hoa, &MN_LIST[i].hoav4, sizeof (struct in_addr)) == 0)
      return i;
  return -1;
}

void
buffer_data (int mnindex, struct sk_buff *skb, int (*okfn) (struct sk_buff *))
{
  struct packet_list *temp_packet_list;
  //删除过期数据包
  while (MN_LIST[mnindex].packets_head != NULL)
    if (time_before
	(MN_LIST[mnindex].packets_head->ariv_jiffies, jiffies - HZ))
      {
	temp_packet_list = MN_LIST[mnindex].packets_head;
	MN_LIST[mnindex].packets_head = MN_LIST[mnindex].packets_head->next;
	kfree_skb (temp_packet_list->skb);
	kfree (temp_packet_list);
      }
    else
      break;
  if (MN_LIST[mnindex].packets_head == NULL)
    MN_LIST[mnindex].packets_tail = NULL;
  //缓存数据包
  if (MN_LIST[mnindex].packets_tail == NULL)
    {
      MN_LIST[mnindex].packets_tail =
	(struct packet_list *) kmalloc (sizeof (struct packet_list),
					GFP_ATOMIC);
      MN_LIST[mnindex].packets_head = MN_LIST[mnindex].packets_tail;
      if (MN_LIST[mnindex].packets_tail == NULL)
	{
	  printk ("%s:%d:kmalloc failed!\n", __FUNCTION__, __LINE__);
	  return;
	}
    }
  else
    {
      MN_LIST[mnindex].packets_tail->next =
	(struct packet_list *) kmalloc (sizeof (struct packet_list),
					GFP_ATOMIC);
      if (MN_LIST[mnindex].packets_tail->next == NULL)
	{
	  printk ("%s:%d:kmalloc failed!\n", __FUNCTION__, __LINE__);
	  return;
	}
      MN_LIST[mnindex].packets_tail = MN_LIST[mnindex].packets_tail->next;
    }
  MN_LIST[mnindex].packets_tail->skb = skb_copy (skb, GFP_ATOMIC);
  MN_LIST[mnindex].packets_tail->okfn = okfn;
  MN_LIST[mnindex].packets_tail->ariv_jiffies = jiffies;
  MN_LIST[mnindex].packets_tail->next = NULL;
}

//our hook function, every packet passes through our computer will go into it
unsigned int
hook_funcv6 (unsigned int hooknum,
	     struct sk_buff *skb,
	     const struct net_device *in,
	     const struct net_device *out, int (*okfn) (struct sk_buff *))
{
  int mnindex;
  //printk("%s %d:%04x:%04x:%04x:%04x:%04x:%04x:%04x:%04x\n",__FUNCTION__,__LINE__, NIP6(ipv6_hdr(skb)->daddr));
  if ((mnindex = in_mnlistv6 ((ipv6_hdr (skb))->daddr)) >= 0)	//?????????? 
    {
      //printk ("This packet should be buffered!\n");
      buffer_data (mnindex, skb, okfn);
      if (MN_LIST[mnindex].FORWARD_INSTANT == 1)
	return NF_ACCEPT;
      else			//FORWARD_INSTANT==0
	return NF_DROP;
    }
  return NF_ACCEPT;
}

unsigned int
hook_funcv4 (unsigned int hooknum,
	     struct sk_buff *skb,
	     const struct net_device *in,
	     const struct net_device *out, int (*okfn) (struct sk_buff *))
{
  int mnindex;
  //printk("%s %d:%s\n",__FUNCTION__,__LINE__, inet_ntoa(ip_hdr(skb)->daddr));
  if ((mnindex = in_mnlistv4 (*(struct in_addr *) &(ip_hdr (skb)->daddr))) >= 0)	//?????????? 
    {
      //      printk ("This packet should be buffered!\n");
      buffer_data (mnindex, skb, okfn);
      if (MN_LIST[mnindex].FORWARD_INSTANT == 1)
	return NF_ACCEPT;
      else			//FORWARD_INSTANT==0
	return NF_DROP;
    }
  return NF_ACCEPT;
}

static struct sock *nlfd;

static void
kernel_receive (struct sk_buff *__skb)
{
  int mnindex;
  struct sk_buff *skb;
  struct nlmsghdr *nlh;
  struct msg_to_kernel message;
  u32 pid = 0;

  //printk ("kernel_receive begin!\n");
  skb = skb_get (__skb);

  if (skb->len >= NLMSG_SPACE (0))
    {
      nlh = nlmsg_hdr (skb);
      memcpy (&message, NLMSG_DATA (nlh), sizeof (message));
      kfree_skb (skb);

      pid = nlh->nlmsg_pid;	//pid of sending process
      printk ("net_link: pid is %d\n", pid);
      printk ("hoa=%04x:%04x:%04x:%04x:%04x:%04x:%04x:%04x\n",
	      NIP6 (message.hoa));
      {
	char hoav4s[16];
	my_inet_ntoa (hoav4s, message.hoav4);
	printk ("hoav4=%s\n", hoav4s);
      }
      printk ("coa=%04x:%04x:%04x:%04x:%04x:%04x:%04x:%04x\n",
	      NIP6 (message.coa));
      if ((mnindex = in_mnlistv6 (message.hoa)) >= 0)
	{
	  if (memcmp
	      (&MN_LIST[mnindex].coa, &message.coa,
	       sizeof (struct in6_addr)) != 0)
	    {
	      MN_LIST[mnindex].coa = message.coa;
	      send_buffered_data (mnindex);
	    }
	}
      else
	add_mnlist (message.hoa, message.hoav4, message.coa);

    }
  printk ("kernel_receive end!\n");
  return;
}

/* 用于注册我们的函数的数据结构 */
static struct nf_hook_ops nfhov6;
static struct nf_hook_ops nfhov4;
static int __init
databuff_init (void)
{
  int ret = 1, i;
  for (i = 0; i < MAX_MN_COUNT; i++)
    MN_LIST[i].packets_head = MN_LIST[i].packets_tail = NULL;

  printk ("init module databuff.ko!\n");
  //初始化netlink套接口
  printk ("init netlink!");
  nlfd =
    netlink_kernel_create (&init_net, NL_IMP2, 0, kernel_receive, NULL,
			   THIS_MODULE);

  if (!nlfd)
    {
      printk ("can not create a netlink socket\n");
      return -1;
    }
  printk ("NL_IMP2=%d\n", NL_IMP2);

  /* 填充我们的hook数据结构 */
  nfhov6.hook = hook_funcv6;	/* 处理函数 */
  nfhov4.hook = hook_funcv4;	/* 处理函数 */
  nfhov6.owner = THIS_MODULE;
  nfhov4.owner = THIS_MODULE;
  //nfho.hooknum  = NF_IP6_PRE_ROUTING; /* 使用IPv6的第一个hook */
  nfhov6.hooknum = NF_IP6_POST_ROUTING;	/* 使用IPv6的第一个hook */
  nfhov4.hooknum = NF_IP_POST_ROUTING;	/* 使用IPv6的第一个hook */
  nfhov6.pf = PF_INET6;		//this line has something wrong?
  nfhov4.pf = PF_INET;		//this line has something wrong?
  nfhov6.priority = NF_IP6_PRI_FIRST;	/* 让我们的函数首先执行 */
  nfhov4.priority = NF_IP_PRI_FIRST;	/* 让我们的函数首先执行 */
  ret = nf_register_hook (&nfhov6);
  if (ret == 0)
    {
      printk ("nf_register_hook v6 is ok!\n");
    }
  ret = nf_register_hook (&nfhov4);
  if (ret == 0)
    {
      printk ("nf_register_hook v4 is ok!\n");
    }
  return ret;
}

static void __exit
databuff_exit (void)
{
  printk ("exit module databuff.ko!\n");
  nf_unregister_hook (&nfhov6);
  nf_unregister_hook (&nfhov4);
  printk ("exit netlink!\n");
  sock_release (nlfd->sk_socket);
  return;
}

module_init (databuff_init);
module_exit (databuff_exit);

MODULE_AUTHOR ("JXW");
MODULE_DESCRIPTION ("A Buffer Packet Module");
MODULE_LICENSE ("GPL");
