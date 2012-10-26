#include <linux/err.h>
#include <linux/module.h>
#include <linux/version.h>
#include <net/ip.h>
#include <net/xfrm.h>
#include <asm/scatterlist.h>
#include <linux/kernel.h>
#include <linux/pfkeyv2.h>
#include <linux/random.h>
#include <net/icmp.h>
#include <net/protocol.h>
#include <net/udp.h>
#include <net/inet_ecn.h>
#include <linux/netfilter.h>
#include <linux/netfilter_ipv4.h>
#include <linux/in.h>

#define UDP_ENCAP_IP_VANILLA 4
#define UDP_ENCAP_TLV 5
#define IPPROTO_UDP_ENCAPSULATION 166
/* TLV as defined in draft-ietf-mext-nemo-v4traversal-01 */
struct tlvhdr
{
  __u8 type;
  __u8 length;/* Note that this is probably too small and will be changed */
  __u16 reserved;
};

enum tlv_type_t
{
  UDP_ENCAP_TLV_IPV4 = 1,
  UDP_ENCAP_TLV_IPV6 = 2,
  UDP_ENCAP_TLV_IPSEC = 3,
  UDP_ENCAP_TLV_GRE = 4
};

/* Compute the type value for TLV from the packet inside.
  - Only IPv4 and IPv6 are supported yet.
  Returns 0 on success, <0 on error.
*/
static int
get_tlv_type_from_packet (__u8 * type, __u8 * packet)
{
  struct iphdr *ip = (struct iphdr *) packet;
  /* There is maybe a better way to find the protocol, in the skb struct for example... */
  switch (ip->version)
    {
    case 4:
      *type = UDP_ENCAP_TLV_IPV4;
      break;

    case 6:
      *type = UDP_ENCAP_TLV_IPV6;
      break;

    default:
      printk (KERN_INFO "Unrecognized packet in %s: %x\n", __FUNCTION__,
	      *packet);
      return -EINVAL;
    }

  return 0;
}


static int
udp_encap_output (struct xfrm_state *x, struct sk_buff *skb)
{
  struct udphdr *uh;
  struct iphdr *top_iph;

  //printk (KERN_INFO "xfrm_type: udp_encap_output entered\n");

  skb_push (skb, -skb_network_offset (skb));

  top_iph = (struct iphdr *) skb->network_header;
  top_iph->tot_len = htons (skb->len);
  /* this is non-NULL only with UDP Encapsulation */
  if (x->encap)
    {
      struct xfrm_encap_tmpl *encap = x->encap;

      uh = (struct udphdr *) (top_iph + 1);
      uh->source = encap->encap_sport;
      uh->dest = encap->encap_dport;
      uh->len = htons (skb->len - top_iph->ihl * 4);
      uh->check = 0;
      if(encap->encap_oa.a4){
	//printk("encap->encap_oa is set\n");
	top_iph->daddr=encap->encap_oa.a4;
      }
      top_iph->protocol = IPPROTO_UDP;

      if (encap->encap_type == UDP_ENCAP_TLV)
	{
	  /* We must also add the TLV header here */
	  struct tlvhdr *tlvh = (struct tlvhdr *) (uh + 1);

	  if (get_tlv_type_from_packet (&tlvh->type, (__u8 *) (tlvh + 1)))
	    return -EINVAL;

	  tlvh->length = skb->len - x->props.header_len;
	  tlvh->reserved = 0;
	}
    }

  ip_send_check (top_iph);

  return 0;
}

static int
udp_encap_input (struct xfrm_state *x, struct sk_buff *skb)
{
  //printk (KERN_INFO "udp_encap_input should not have been called\n");
  return 0;
}

static u32
udp_encap_get_mtu (struct xfrm_state *x, int mtu)
{				/* XXX : check if sizeof(udphdr) is accounted for */
  return mtu + x->props.header_len;
}

static void
udp_encap_proto_err (struct sk_buff *skb, u32 info)
{
  //  printk ("udp_encap error : got an error by udp_encap_err...\n");
}

/* This function will reset some flags on the skb and resubmit as IP packet
 * It is inspired from ipip_rcv
 * Return 0 on success, -1 if packet must be dropped.
 */
static int
resubmit_as_ip (struct sk_buff *skb, struct iphdr *top_iph)
{
  if (!pskb_may_pull (skb, sizeof (struct iphdr)))
    return -1;			/* No space for IP header. */

  secpath_reset (skb);

  skb->protocol = htons (ETH_P_IP);
  skb->pkt_type = PACKET_HOST;

  dst_release (skb->dst);
  skb->dst = NULL;
  nf_reset (skb);

  if (INET_ECN_is_ce (top_iph->tos))
    IP_ECN_set_ce (ip_hdr (skb));

  netif_rx (skb);

  return 0;
}

/* This function will reset some flags on the skb and resubmit as IPv6 packet
 * It is inspired from ipip6_rcv
 * Return 0 on success, -1 if packet must be dropped.
 */
static int
resubmit_as_ipv6 (struct sk_buff *skb, struct iphdr *top_iph)
{
  //  printk("resubmit as ipv6\n");
  if (!pskb_may_pull (skb, sizeof (struct ipv6hdr)))
    return -1;			/* No space for IPv6 header. */

  secpath_reset (skb);

  IPCB (skb)->flags = 0;
  skb->protocol = htons (ETH_P_IPV6);
  skb->pkt_type = PACKET_HOST;

  dst_release (skb->dst);
  skb->dst = NULL;
  nf_reset (skb);

  if (INET_ECN_is_ce (top_iph->tos))
    IP6_ECN_set_ce (ipv6_hdr (skb));

  netif_rx (skb);

  return 0;
}

/* This function tries to find what kind of packet is in the UDP payload.
 * It returns the IPPROTO_* value of the protocol, or -1 on error.
 */
static int
find_inside_proto (struct sk_buff *skb)
{
  struct tlvhdr *tlvh;

  switch (*(int *) skb->cb)
    {
    case UDP_ENCAP_IP_VANILLA:
      if (!pskb_may_pull (skb, sizeof (__u8)))
	return -1;		/* No space for anything. */

      switch (ip_hdr (skb)->version)
	{
	case 4:		/* IP in the UDP vanilla encapsulation */
	  return IPPROTO_IP;

	case 6:		/* IPv6 in the UDP packet */
	  return IPPROTO_IPV6;

	default:
	  printk (KERN_DEBUG
		  "Unexpected UDP content (start with %x), dropped\n",
		  *(int *) ip_hdr (skb));
	}
      break;

    case UDP_ENCAP_TLV:
      if (!pskb_may_pull (skb, sizeof (struct tlvhdr)))
	return -1;		/* No space for TLV header. */

      tlvh = (struct tlvhdr *) skb_network_header (skb);

      /* Eat the TLV header */
      skb_pull (skb, sizeof (struct tlvhdr));
      skb_reset_network_header (skb);

      switch (tlvh->type)
	{
	case UDP_ENCAP_TLV_IPV4:
	  return IPPROTO_IP;

	case UDP_ENCAP_TLV_IPV6:
	  return IPPROTO_IPV6;

	case UDP_ENCAP_TLV_IPSEC:
	  return IPPROTO_ESP;

	case UDP_ENCAP_TLV_GRE:
	  return IPPROTO_GRE;

	default:
	  printk (KERN_DEBUG "Unexpected type in TLV (%d), dropped\n",
		  tlvh->type);
	}
      break;

    default:
      printk (KERN_DEBUG "Unexpected encap_type (%x)\n", *(int *) skb->cb);
    }
  /* Protocol not found */
  return -1;
}

/* Eat the routing headers and ip options of IPv6 packet to find the next protocol */
static int
find_ipv6_payload_type (struct sk_buff *skb, __u8 * next)
{
  struct ipv6hdr *ip6h = ipv6_hdr (skb);
  size_t hdrlen = sizeof (struct ipv6hdr);
  __u8 *p = (__u8 *) (ip6h + 1);

  //printk (KERN_DEBUG "%s:%d - %s ( inspecting packet )\n", __FILE__, __LINE__,
  //  __FUNCTION__);

  if (!pskb_may_pull (skb, hdrlen))
    return -1;			/* No space for IPv6 header. */

  *next = ip6h->nexthdr;

next_hdr:
  switch (*next)
    {
    case IPPROTO_HOPOPTS:	/* IPv6 hop-by-hop options      */
    case IPPROTO_ROUTING:	/* IPv6 routing header          */
      /* case IPPROTO_FRAGMENT: *//* IPv6 fragmentation header    */
    case IPPROTO_DSTOPTS:	/* IPv6 destination options     */
      /* We have to eat this and go on */
      if (!pskb_may_pull (skb, hdrlen + 2))
	return -1;		/* could not get to hdr len. */
      if (!pskb_may_pull
	  (skb, hdrlen + ipv6_optlen ((struct ipv6_opt_hdr *) p)))
	return -1;		/* could not get the full option. */
      *next = *p;
      hdrlen += ipv6_optlen ((struct ipv6_opt_hdr *) p);
      p += ipv6_optlen ((struct ipv6_opt_hdr *) p);
      goto next_hdr;
    }
  /* We found the last header, return this */
  //  printk (KERN_DEBUG "%s:%d - %s ( final header: %d )\n", __FILE__, __LINE__,
  //	  __FUNCTION__, *next);
  return 0;
}


static int
udp_encap_proto_input (struct sk_buff *skb)
{
  struct iphdr *top_iph = ip_hdr (skb);
  struct net *net;
  int proto = 0;
  struct xfrm_state *x;
  int accept = 1;
  __u8 next = 0;
#ifdef CONFIG_INET_XFRM_UDP_ENCAP_NATT
  __be32 saddr = top_iph->saddr;
  struct udphdr *uh = udp_hdr (skb);
#endif

  /* This function was called by ip_local_deliver_finish after
     udp_rcv has resubmitted the skb */
  //  printk (KERN_DEBUG "%s:%d - %s ( enter )\n", __FILE__, __LINE__,
  //	  __FUNCTION__);

  /* Check it's a real UDP packet that was resubmitted */
  if (top_iph->protocol != IPPROTO_UDP)
    {
      printk (KERN_DEBUG "Bad packet, dropped (proto %d)\n",
	      top_iph->protocol);
      goto drop;
    }

  /* We know here the packet has gone through UDP checks and is valid. */
  /* Let's find if we have some XFRM state for this packet. */
#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,29)
  net = dev_net (skb->dev);
#endif
  x = xfrm_state_lookup_byaddr (
#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,29)
				 net,
#endif
				 (xfrm_address_t *) & top_iph->daddr,
				 (xfrm_address_t *) & top_iph->saddr,
				 IPPROTO_UDP_ENCAPSULATION, AF_INET);
  if (x != NULL)
    {
      //      printk (KERN_DEBUG "%s:%d - %s ( state found: accept packet )\n",
      //	      __FILE__, __LINE__, __FUNCTION__);
      /* We have a valid state for this packet, it means that the v4 coa of MN is registered */
      accept = 1;
      xfrm_state_put (x);
    }

  /* Let's eat the UDP header -- TLV will be eaten later */
  skb_pull (skb, sizeof (struct udphdr));

  /* And update the internal skb pointers */
  skb->mac_header = skb->network_header;
  skb_reset_network_header (skb);

#ifdef CONFIG_INET_XFRM_UDP_ENCAP_NATT
  /* We must save saddr and ntohs(uh->source) as ancialliary data here */
  //  printk (KERN_DEBUG "Saving source %u.%u.%u.%u:%u into skb\n",
  //	  NIPQUAD (saddr), ntohs (uh->source));
  skb->udp_encap_info.saddr = saddr;
  skb->udp_encap_info.sport = uh->source;
#endif

  /* Now the inside is either IP or IPv6. We will do as in ipip_rcv or ipip6_rcv accordingly */
  proto = find_inside_proto (skb);
  switch (proto)
    {
    case IPPROTO_IP:		/* IP in the UDP vanilla encapsulation */
      if (!accept)
	goto drop;
      goto ipv4;

    case IPPROTO_IPV6:		/* IPv6 in the UDP packet */
      if (!accept)
	goto look_inside;
      goto ipv6;

    default:
      printk (KERN_DEBUG "Unsupported protocol (%d), dropped\n", proto);
    }
  goto drop;
ipv4:
  if (resubmit_as_ip (skb, top_iph) < 0)
    goto drop;
  goto end;

look_inside:
  /* We have received a new packet from unknown source. We check it contains
     either ESP or MH; otherwise we discard it. */
  if (find_ipv6_payload_type (skb, &next) < 0)
    goto drop;
  switch (next)
    {
    case IPPROTO_MH:		/* we accept all MH */
    case IPPROTO_ESP:		/* We also accept ESP and AH since they will be */
    case IPPROTO_AH:		/* discarded if no IPsec policy corresponds */
      break;
    default:
      printk (KERN_DEBUG "Unsupported inside protocol (%d), dropped\n", next);
      goto drop;
    }

ipv6:
  if (resubmit_as_ipv6 (skb, top_iph) < 0)
    goto drop;
  goto end;

drop:
  kfree_skb (skb);
end:
  return 0;
}

static void
udp_encap_destroy (struct xfrm_state *x)
{
  return;
}

static int
udp_encap_init_state (struct xfrm_state *x)
{
  if (x->props.mode != XFRM_MODE_TUNNEL)
    return -EINVAL;

  if (!x->encap)		/* Is this possible? */
    return -EINVAL;

  switch (x->encap->encap_type)
    {
    case UDP_ENCAP_IP_VANILLA:
      x->props.header_len = sizeof (struct iphdr) + sizeof (struct udphdr);
      break;
    case UDP_ENCAP_TLV:
      x->props.header_len =
	sizeof (struct iphdr) + sizeof (struct udphdr) +
	sizeof (struct tlvhdr);
    default:
      return -EINVAL;
    }

  return 0;
}


static struct xfrm_type udp_encap_type = { //ipv4 only
  .description = "UDP4",
  .owner = THIS_MODULE,
  .proto = IPPROTO_UDP_ENCAPSULATION,
  .init_state = udp_encap_init_state,
  .destructor = udp_encap_destroy,
  .get_mtu = udp_encap_get_mtu,
  .input = udp_encap_input,	/* can we remove this? */
  .output = udp_encap_output
};

static struct net_protocol udp_encap_protocol = {
  .handler = udp_encap_proto_input,
  .err_handler = udp_encap_proto_err,
  .no_policy = 1,
};

static int __init
udp_encap_init (void)
{
  printk (KERN_INFO "registering udp_encap type and protocol handler\n");

  if (xfrm_register_type (&udp_encap_type, AF_INET) < 0)
    {
      printk (KERN_INFO "ip udp_encap init: can't add xfrm type\n");
      return -EAGAIN;
    }

  if (inet_add_protocol (&udp_encap_protocol, IPPROTO_UDP_ENCAPSULATION) < 0)
    {
      printk (KERN_INFO "ip udp_encap init: can't add protocol\n");
      xfrm_unregister_type (&udp_encap_type, AF_INET);
      return -EAGAIN;
    }

  return 0;
}

static void __exit
udp_encap_fini (void)
{
  if (inet_del_protocol (&udp_encap_protocol, IPPROTO_UDP_ENCAPSULATION) < 0)
    printk (KERN_INFO "ip udp_encap close: can't remove protocol\n");
  if (xfrm_unregister_type (&udp_encap_type, AF_INET) < 0)
    printk (KERN_INFO "ip udp_encap close: can't remove xfrm type\n");
}

module_init (udp_encap_init);
module_exit (udp_encap_fini);
MODULE_LICENSE ("GPL");
MODULE_ALIAS_XFRM_TYPE (AF_INET, XFRM_PROTO_UDP_ENCAPS);
