/*
 * common.h
 * some common utility functions
 * Lin Hui
 * linhui08@gmail.com
 * last modified: June 29, 2010
 */

#ifndef __LH_COMMON__H__
#define __LH_COMMON__H__

#include <inttypes.h>
#include <netinet/in.h>
#include <time.h>
#include <netinet/ip6.h>
#include <string.h>
#include <sys/socket.h>/*add by syl for make*/

#include <netinet/in6.h>

const struct in6_addr in6addr_any=IN6ADDR_ANY_INIT; /*add by syl for make*/

#define IPV6_RTHDR_TYPE_0	0	/* IPv6 Routing header type 0.  */ /*add by syl for make*/

#ifndef IPPROTO_MH
#define IPPROTO_MH 135/* IPv6 Mobility Header */
#endif


#ifndef IPV6_RTHDR_TYPE_2
#define IPV6_RTHDR_TYPE_2 2
#endif

#ifndef IPV6_JOIN_ANYCAST
#define IPV6_JOIN_ANYCAST 27
#endif


#ifndef IPV6_RECVPKTINFO
#define IPV6_RECVPKTINFO        49
#ifdef IPV6_PKTINFO
#undef IPV6_PKTINFO
#define IPV6_PKTINFO            50
#endif
#endif

#ifndef IPV6_RECVHOPLIMIT
#define IPV6_RECVHOPLIMIT       51
#ifdef IPV6_HOPLIMIT
#undef IPV6_HOPLIMIT
#define IPV6_HOPLIMIT           52
#endif
#endif

#ifndef IPV6_RECVRTHDR
#define IPV6_RECVRTHDR          56
#ifdef IPV6_RTHDR
#undef IPV6_RTHDR
#define IPV6_RTHDR              57
#endif
#endif

#ifndef IPV6_RECVDSTOPTS
#define IPV6_RECVDSTOPTS        58
#ifdef IPV6_DSTOPTS
#undef IPV6_DSTOPTS
#define IPV6_DSTOPTS            59
#endif
#endif

#define HAVE_STRUCT_IP6_EXT
#ifndef HAVE_STRUCT_IP6_EXT
/* Generic extension header.  */
struct ip6_ext {
  uint8_t  ip6e_nxt;          /* next header.  */
  uint8_t  ip6e_len;          /* length in units of 8 octets.  */
};
#endif

/* Home Address Destination Option */
#ifndef HAVE_STRUCT_IP6_OPT_HOME_ADDRESS
struct ip6_opt_home_address {
  uint8_t ip6oha_type;
  uint8_t ip6oha_len;
  uint8_t ip6oha_addr[16];/* Home Address */
} __attribute((packed));
#endif


#ifndef IP6OPT_PAD0
#define IP6OPT_PAD0		0x0
#endif
#ifndef IP6OPT_PADN
#define IP6OPT_PADN		0x1
#endif
#ifndef IP6OPT_HOME_ADDRESS
#define IP6OPT_HOME_ADDRESS	0xc9	/* 11 0 01001 */ 
#endif

/* Type 2 Routing header for Mobile IPv6 */
#ifndef HAVE_STRUCT_IP6_RTHDR2
struct ip6_rthdr2 {
	uint8_t		ip6r2_nxt;	/* next header */
	uint8_t		ip6r2_len;	/* length : always 2 */
	uint8_t		ip6r2_type;	/* always 2 */
	uint8_t		ip6r2_segleft;	/* segments left: always 1 */
	uint32_t	ip6r2_reserved;	/* reserved field */
	struct in6_addr	ip6r2_homeaddr;	/* Home Address */
} __attribute((packed));
#endif



struct ip6_mh {
	uint8_t		ip6mh_proto;	/* NO_NXTHDR by default */
	uint8_t		ip6mh_hdrlen;	/* Header Len in unit of 8 Octets
				           excluding the first 8 Octets */
	uint8_t		ip6mh_type;	/* Type of Mobility Header */
	uint8_t		ip6mh_reserved;	/* Reserved */
	uint16_t	ip6mh_cksum;	/* Mobility Header Checksum */
	/* Followed by type specific messages */
} __attribute__ ((packed));

struct ip6_mh_binding_request {
	struct ip6_mh	ip6mhbr_hdr;
	uint16_t	ip6mhbr_reserved;
	/* Followed by optional Mobility Options */
} __attribute__ ((packed));

struct ip6_mh_home_test_init {
	struct ip6_mh	ip6mhhti_hdr;
	uint16_t	ip6mhhti_reserved;
	uint32_t	ip6mhhti_cookie[2];	/* 64 bit Cookie by MN */
	/* Followed by optional Mobility Options */
} __attribute__ ((packed));

struct ip6_mh_careof_test_init {
	struct ip6_mh	ip6mhcti_hdr;
	uint16_t	ip6mhcti_reserved;
	uint32_t	ip6mhcti_cookie[2];	/* 64 bit Cookie by MN */
	/* Followed by optional Mobility Options */
} __attribute__ ((packed));

struct ip6_mh_home_test {
	struct ip6_mh	ip6mhht_hdr;
	uint16_t	ip6mhht_nonce_index;
	uint32_t	ip6mhht_cookie[2];	/* Cookie from HOTI msg */
	uint32_t	ip6mhht_keygen[2];	/* 64 Bit Key by CN */
	/* Followed by optional Mobility Options */
} __attribute__ ((packed));

struct ip6_mh_careof_test {
	struct ip6_mh	ip6mhct_hdr;
	uint16_t	ip6mhct_nonce_index;
	uint32_t	ip6mhct_cookie[2];	/* Cookie from COTI message */
	uint32_t	ip6mhct_keygen[2];	/* 64bit key by CN */
	/* Followed by optional Mobility Options */
} __attribute__ ((packed));

struct ip6_mh_binding_update {
	struct ip6_mh	ip6mhbu_hdr;
	uint16_t	ip6mhbu_seqno;		/* Sequence Number */
	uint16_t	ip6mhbu_flags;
	uint16_t	ip6mhbu_lifetime;	/* Time in unit of 4 sec */
	/* Followed by optional Mobility Options */
} __attribute__ ((packed));

/* ip6mhbu_flags */
#if BYTE_ORDER == BIG_ENDIAN
#define IP6_MH_BU_ACK		0x8000	/* Request a binding ack */
#define IP6_MH_BU_HOME		0x4000	/* Home Registration */
#define IP6_MH_BU_LLOCAL	0x2000	/* Link-local compatibility */
#define IP6_MH_BU_KEYM		0x1000	/* Key management mobility */
#define IP6_MH_BU_MAP		0x0800	/* HMIPv6 MAP Registration */
#define IP6_MH_BU_MR		0x0400	/* NEMO MR Registration */
#define IP6_MH_BU_UDP           0x0100  /* dsmip udp encapsulation ,lh 090827*/
#else				        /* BYTE_ORDER == LITTLE_ENDIAN */
#define IP6_MH_BU_ACK		0x0080	/* Request a binding ack */
#define IP6_MH_BU_HOME		0x0040	/* Home Registration */
#define IP6_MH_BU_LLOCAL	0x0020	/* Link-local compatibility */
#define IP6_MH_BU_KEYM		0x0010	/* Key management mobility */
#define IP6_MH_BU_MAP		0x0008	/* HMIPv6 MAP Registration */
#define IP6_MH_BU_MR		0x0004	/* NEMO MR Registration */
#define IP6_MH_BU_UDP           0x0001  /* dsmip udp encapsulation ,lh 090827*/
#endif

struct ip6_mh_binding_ack {
	struct ip6_mh	ip6mhba_hdr;
	uint8_t 	ip6mhba_status;	/* Status code */
	uint8_t		ip6mhba_flags;
	uint16_t	ip6mhba_seqno;
	uint16_t	ip6mhba_lifetime;
	/* Followed by optional Mobility Options */
} __attribute__ ((packed));

/* ip6mhba_flags */
#define IP6_MH_BA_KEYM		0x80	/* Key management mobility */
#define IP6_MH_BA_MR		0x40	/* NEMO MR registration */

struct ip6_mh_binding_error {
	struct ip6_mh	ip6mhbe_hdr;
	uint8_t 	ip6mhbe_status;	/* Error Status */
	uint8_t		ip6mhbe_reserved;
	struct in6_addr	ip6mhbe_homeaddr;
	/* Followed by optional Mobility Options */
} __attribute__ ((packed));

/*
 * Mobility Option TLV data structure
 */
struct ip6_mh_opt {
	uint8_t		ip6mhopt_type;	/* Option Type */
	uint8_t		ip6mhopt_len;	/* Option Length */
	/* Followed by variable length Option Data in bytes */
} __attribute__ ((packed));

/*
 * Mobility Option Data Structures 
 */
struct ip6_mh_opt_refresh_advice {
	uint8_t		ip6mora_type;
	uint8_t		ip6mora_len;
	uint16_t	ip6mora_interval;	/* Refresh interval in 4 sec */
} __attribute__ ((packed));

struct ip6_mh_opt_altcoa {
	uint8_t		ip6moa_type;
	uint8_t		ip6moa_len;
	struct in6_addr	ip6moa_addr;		/* Alternate Care-of Address */
} __attribute__ ((packed));

struct ip6_mh_opt_nonce_index {
	uint8_t		ip6moni_type;
	uint8_t		ip6moni_len;
	uint16_t	ip6moni_home_nonce;
	uint16_t	ip6moni_coa_nonce;
} __attribute__ ((packed));

struct ip6_mh_opt_auth_data {
	uint8_t		ip6moad_type;
	uint8_t 	ip6moad_len;
	uint8_t 	ip6moad_data[12];	/* 96 bit Authenticator */
} __attribute__ ((packed));

struct ip6_mh_opt_mob_net_prefix {
	uint8_t 	ip6mnp_type;
	uint8_t 	ip6mnp_len;
	uint8_t 	ip6mnp_reserved;
	uint8_t 	ip6mnp_prefix_len;
	struct in6_addr ip6mnp_prefix;
} __attribute__ ((packed));

/* DSMIPv6 specific options */
struct ip6_mh_opt_ipv4_hoa {
  uint8_t ip6moih_type;
  uint8_t ip6moih_len;
  unsigned ip6moih_prefix_len:6;
  unsigned ip6moih_flags_reserved:10;
  struct in_addr ip6moih_v4hoa;
} __attribute__ ((packed));

/* ip6moih_flags */
#if BYTE_ORDER == BIG_ENDIAN
#define IP6_MHOPT_IPV4HOA_PFX 0x200/* Request a prefix */
#else/* BYTE_ORDER == LITTLE_ENDIAN */
#define IP6_MHOPT_IPV4HOA_PFX 0x002/* Request a prefix */
#endif

struct ip6_mh_opt_ipv4_coa {
  uint8_t ip6moic_type;
  uint8_t ip6moic_len;
  uint16_t ip6moic_reserved;
  struct in_addr ip6moic_v4coa;
} __attribute__ ((packed));

struct ip6_mh_opt_ipv4_ack {
  uint8_t ip6moia_type;
  uint8_t ip6moia_len;
  uint8_t ip6moia_status;
  unsigned ip6moia_prefix_len:5;
  unsigned ip6moia_reserved:3;
  struct in_addr ip6moia_v4hoa;
} __attribute__ ((packed));

struct ip6_mh_opt_ipv4_nat {
  uint8_t ip6moin_type;
  uint8_t ip6moin_len;
  uint16_t ip6moin_flags_reserved;
  uint32_t ip6moin_refresh;/* Refresh time */
} __attribute__ ((packed));

/* ip6moin_flags */
#if BYTE_ORDER == BIG_ENDIAN
#define IP6_MHOPT_NAT_ENCAPS 0x8000/* Force UDP encapsulation */
#else/* BYTE_ORDER == LITTLE_ENDIAN */
#define IP6_MHOPT_NAT_ENCAPS 0x0080/* Force UDP encapsulation */
#endif

#define IP6_MHOPT_NO_REFRESH 0xffffffff/* No need to refresh NAT keepalive */

/*
 *     Mobility Header Message Types
 */
#define IP6_MH_TYPE_BRR		0	/* Binding Refresh Request */
#define IP6_MH_TYPE_HOTI	1	/* HOTI Message */
#define IP6_MH_TYPE_COTI	2	/* COTI Message */
#define IP6_MH_TYPE_HOT		3	/* HOT Message */
#define IP6_MH_TYPE_COT		4	/* COT Message */
#define IP6_MH_TYPE_BU		5	/* Binding Update */
#define IP6_MH_TYPE_BACK	6	/* Binding ACK */
#define IP6_MH_TYPE_BERROR	7	/* Binding Error */

/*
 *     Mobility Header Message Option Types
 */
#define IP6_MHOPT_PAD1		0x00	/* PAD1 */
#define IP6_MHOPT_PADN		0x01	/* PADN */
#define IP6_MHOPT_BREFRESH	0x02	/* Binding Refresh */
#define IP6_MHOPT_ALTCOA	0x03	/* Alternate COA */
#define IP6_MHOPT_NONCEID	0x04	/* Nonce Index */
#define IP6_MHOPT_BAUTH		0x05	/* Binding Auth Data */
#define IP6_MHOPT_MOB_NET_PRFX	0x06	/* Mobile Network Prefix */
#define IP6_MHOPT_IPV4HOA       0x15    /* IPv4 Home Address */
#define IP6_MHOPT_IPV4COA       0x16    /* IPv4 Care of Address */
#define IP6_MHOPT_IPV4ACK       0x17    /* IPv4 Address Acknowledgment */
#define IP6_MHOPT_NAT           0x18    /* NAT Detection */
/*
 *    Status values accompanied with Mobility Binding Acknowledgement
 */
#define IP6_MH_BAS_ACCEPTED		0	/* BU accepted */
#define IP6_MH_BAS_PRFX_DISCOV		1	/* Accepted, but prefix discovery
						   required */
#define IP6_MH_BAS_UNSPECIFIED		128	/* Reason unspecified */
#define IP6_MH_BAS_PROHIBIT		129	/* Administratively prohibited */
#define IP6_MH_BAS_INSUFFICIENT		130	/* Insufficient resources */
#define IP6_MH_BAS_HA_NOT_SUPPORTED	131	/* HA registration not supported */
#define IP6_MH_BAS_NOT_HOME_SUBNET	132	/* Not Home subnet */
#define IP6_MH_BAS_NOT_HA		133	/* Not HA for this mobile node */
#define IP6_MH_BAS_DAD_FAILED		134	/* DAD failed */
#define IP6_MH_BAS_SEQNO_BAD		135	/* Sequence number out of range */
#define IP6_MH_BAS_HOME_NI_EXPIRED	136	/* Expired Home nonce index */
#define IP6_MH_BAS_COA_NI_EXPIRED	137	/* Expired Care-of nonce index */
#define IP6_MH_BAS_NI_EXPIRED		138	/* Expired Nonce Indices */
#define IP6_MH_BAS_REG_NOT_ALLOWED	139	/* Registration type change 
						   disallowed */
#define IP6_MH_BAS_MR_OP_NOT_PERMITTED	140	/* MR Operation not permitted */
#define IP6_MH_BAS_INVAL_PRFX		141	/* Invalid Prefix */
#define IP6_MH_BAS_NOT_AUTH_FOR_PRFX	142	/* Not Authorized for Prefix */
#define IP6_MH_BAS_FWDING_FAILED	143	/* Forwarding Setup failed */
/*
 *    Status values for the Binding Error mobility messages
 */
#define IP6_MH_BES_UNKNOWN_HAO	1	        /* Unknown binding for HOA */
#define IP6_MH_BES_UNKNOWN_MH	2	        /* Unknown MH Type */

/* status values for ipv4 Address Acknowledgement option*/
#define IP6_MHOPT_IPV4ACK_ACCEPTED          0  /* Success */
#define IP6_MHOPT_IPV4ACK_UNSPECIFIED       128/* Reason unspecified */
#define IP6_MHOPT_IPV4ACK_PROHIBIT          129/* Administratively prohibited */
#define IP6_MHOPT_IPV4ACK_INCORRECT         130/* Incorrect IPv4 Home Address */
#define IP6_MHOPT_IPV4ACK_INVALID           131/* Invalid IPv4 address */
#define IP6_MHOPT_IPV4ACK_NODHCP            132/* Dynamic IPv4 HoA assignement
				                  not available */
#define IP6_MHOPT_IPV4ACK_NOPFX             133/* Prefix allocation unauthorized */



#ifndef IP6OPT_PAD1
#define IP6OPT_PAD1 0
#endif


int inet6_opt_find(void *extbuf, socklen_t extlen, int offset, 
		   uint8_t type, socklen_t *lenp,
		   void **databufp)
{
  uint8_t *optp, *tailp;

  optp = (uint8_t *)extbuf;

  if (extlen < 2 || extlen <= offset || extlen < ((optp[1] + 1) << 3))
    return -1;

  tailp = optp + extlen;
  optp += (2 + offset);

  while (optp <= tailp) {
    if (optp[0] == IP6OPT_PAD1) {
      optp++;
      continue;
    }
    if (optp + optp[1] + 2 > tailp)
      return -1;
    if (optp[0] == type) {
      *databufp = optp + 2;
      *lenp = optp[1];
      return *lenp + (uint8_t *)optp - (uint8_t *)extbuf;
    }
    optp += (2 + optp[1]);
  }

  *databufp = NULL;
  return -1;
}

int inet6_rth_add(void *bp, const struct in6_addr *addr)
{
  struct ip6_rthdr *rth;

  rth = (struct ip6_rthdr *)bp;
  
  memcpy((uint8_t *)bp + 8 + rth->ip6r_segleft * sizeof(struct in6_addr),
	 addr, sizeof(struct in6_addr));

  rth->ip6r_segleft += 1;

  return 0;
}


struct in6_addr *inet6_rth_getaddr(const void *bp, int index)
{
  uint8_t *rthp = (uint8_t *)bp;
  struct in6_addr *addr = NULL;

  if (rthp[1] & 1) return NULL;
  if (index < 0 || index > rthp[3]) return NULL;

  addr = (struct in6_addr *)
    (rthp + 8 + index * sizeof(struct in6_addr));

  return addr;
}

int inet6_rth_gettype(void *bp)
{
  uint8_t *rthp = (uint8_t *)bp;

  return rthp[2];
}

#ifndef IPV6_RTHDR_TYPE_2
#define IPV6_RTHDR_TYPE_2 2
#endif

void *inet6_rth_init(void *bp, socklen_t bplen, int type,
		     int segments)
{
  struct ip6_rthdr *rth = (struct ip6_rthdr *)bp;
  uint8_t type_len = 0;

  if (type == IPV6_RTHDR_TYPE_0) {
    type_len = 8;
    *(uint32_t *)(rth+1) = 0;
  } else if (type == IPV6_RTHDR_TYPE_2) {
    type_len = 8;
    *(uint32_t *)(rth+1) = 0;
  } else
    return NULL;

  if (bplen < type_len + segments * sizeof(struct in6_addr))
    return NULL;

  rth->ip6r_nxt = 0;
  rth->ip6r_len = segments << 1;
  rth->ip6r_type = type;
  rth->ip6r_segleft = 0;
  
  return bp;
}

#ifndef IPV6_RTHDR_TYPE_2
#define IPV6_RTHDR_TYPE_2 2
#endif

socklen_t inet6_rth_space(int type, int segments)
{
  if (type == IPV6_RTHDR_TYPE_0) {
    if (segments > 128)
      return 0;
    return 8 + segments * sizeof(struct in6_addr);
  } else if (type == IPV6_RTHDR_TYPE_2) {
    if (segments != 1)
      return 0;
    return 8 + sizeof(struct in6_addr);
  }
  return 0;
}

#define NIP6ADDR(addr) \
  ntohs((addr)->s6_addr16[0]), \
    ntohs((addr)->s6_addr16[1]), \
    ntohs((addr)->s6_addr16[2]), \
    ntohs((addr)->s6_addr16[3]), \
    ntohs((addr)->s6_addr16[4]), \
    ntohs((addr)->s6_addr16[5]), \
    ntohs((addr)->s6_addr16[6]), \
    ntohs((addr)->s6_addr16[7])


#define NIP4ADDR(addr) \
  ((addr)->s_addr & 0x000000ff), \
    ((addr)->s_addr & 0x0000ff00) >> 8, \
    ((addr)->s_addr & 0x00ff0000) >> 16, \
    ((addr)->s_addr & 0xff000000) >> 24

inline int ipv6_unmap_addr(struct in6_addr *a6, uint32_t *a4)
{
  if (!IN6_IS_ADDR_V4MAPPED(a6))
    return 0;
  *a4 = 0;
  *a4 = *(uint32_t*)&a6->s6_addr[12];
  return 1;
}

inline int ipv6_map_addr(struct in6_addr *a6, struct in_addr *a4)
{
  memset(a6, 0, sizeof(struct in6_addr));
  a6->s6_addr32[2] = htonl (0xffff);
  a6->s6_addr32[3] = *(uint32_t*)&a4->s_addr;
  if (!IN6_IS_ADDR_V4MAPPED(a6))
    return 0;
  return 1;
}


static inline void ipv6_addr_set(struct in6_addr *addr, 
				 uint32_t w1, uint32_t w2,
				 uint32_t w3, uint32_t w4)
{
  addr->s6_addr32[0] = w1;
  addr->s6_addr32[1] = w2;
  addr->s6_addr32[2] = w3;
  addr->s6_addr32[3] = w4;
}

static inline void ipv6_addr_solict_mult(const struct in6_addr *addr,
					 struct in6_addr *solicited)
{
  ipv6_addr_set(solicited, htonl(0xFF020000), 0, htonl(0x1),
		htonl(0xFF000000) | addr->s6_addr32[3]);
}

static inline void ipv6_addr_llocal(const struct in6_addr *addr,
				    struct in6_addr *llocal)
{
  ipv6_addr_set(llocal, htonl(0xFE800000), 0,
		addr->s6_addr32[2], addr->s6_addr32[3]);
}

static inline int in6_is_addr_routable_unicast(const struct in6_addr *a)
{
  return ((!IN6_IS_ADDR_UNSPECIFIED(a) &&
	   !IN6_IS_ADDR_LOOPBACK(a) &&
	   !IN6_IS_ADDR_MULTICAST(a) &&
	   !IN6_IS_ADDR_LINKLOCAL(a)));
}

struct NATINFO
{
  struct in6_addr hoa;//16 bytes
  struct in_addr  coa; //4 bytes
  uint16_t ifindex; //2
  uint16_t checksum;//2 seqno^port^ifindex
  uint16_t port;    //2 
  uint16_t seqno;   //2
}__attribute((packed));;

struct NATINFO_ACK
{
  struct NATINFO natinfo;//28
  uint16_t in_nat;//2
}__attribute((packed));;


#ifndef RTPROT_MIP 
#define RTPROT_MIP 16
#endif

#define IP6_RT_PRIO_MIP6_FWD 192
#define IP6_RT_PRIO_ADDRCONF 256

#define RULE_MOBILE_PRIO 888
#define ROUTE_MOBILE 252
#define ROUTE_MOBILE_TMP 251

#define CTRL_PORT 7777

extern void pctime();//a:syl

/*
struct CTRL_CMD{
  uint16_t cmd;//lscoa //handoff ifindex
  uint16_t data; //if handoff, data contains ifindex
  uint16_t seqno;
  uint16_t chksum;//cmd^data^seqno
}__attribute((packed));;;

struct CTRL_CMD_ACK
{
  uint16_t seqno;
  uint16_t chksum;
  uint16_t acklen;//length of ack data
  uint8_t ack[500];//data 500 bytes at most
};
*/  

#endif














#define COMMON_NO_TEST 1
#ifndef COMMON_NO_TEST
#define COMMON_NO_TEST 1

int main()
{
  
}
#endif
