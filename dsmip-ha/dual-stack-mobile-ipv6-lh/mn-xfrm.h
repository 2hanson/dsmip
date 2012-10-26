#ifndef __XFRM_H__
#define __XFRM_H__


#include <errno.h>
#include <string.h>
#include <unistd.h>
#include <pthread.h>
#include <time.h>
//#include <netinet/icmp6.h>
//#include <netinet/ip6.h>
//#include <netinet/in.h>
//#include <netinet/ip6mh.h>
#include <stdio.h>

#include <linux/xfrm.h>
#include "common.h"
#include "rtnl.h"

//-------------------interfaces ----------------------
int start_udp_encap(const struct in6_addr * mn_addrv6,//mn's ipv6 addr
		    const struct in_addr  * mn_addrv4,//mn's ipv4 addr
		    const struct in_addr * src,//encapsulation src
                    const struct in_addr * dst,//encapsulation dst
                    int sport,
                    int dport,
                    int prio);

int stop_udp_encap(const struct in6_addr * mn_addrv6,
		   const struct in_addr  * mn_addrv4,
		   const struct in_addr * src,
		   const struct in_addr * dst,
		   int sport,
		   int dport,
		   int prio);

//-----------------------------------------------------

#define MIPV6_MAX_TMPLS 3 /* AH, ESP, IPCOMP */
#define DSMIP_UDP_DPORT 666
#define UDP_ENCAP_IP_VANILLA 4


#ifndef IPPROTO_UDP_ENCAPSULATION 
#define IPPROTO_UDP_ENCAPSULATION 166
#endif

#define dbg(format,args...) fprintf(stderr,format,##args)
#define cdbg dbg
#define XDBG dbg

static void xfrm_sel_dump(const struct xfrm_selector *sel)
{
  cdbg("sel.daddr %x:%x:%x:%x:%x:%x:%x:%x\n"
       "sel.saddr %x:%x:%x:%x:%x:%x:%x:%x\n"
       "sel.dport %x\n"
       "sel.dport_mask %x\n"
       "sel.sport %x\n"
       "sel.sport_mask %x\n"
       "sel.prefixlen_d %d\n"
       "sel.prefixlen_s %d\n"
       "sel.proto %d\n"
       "sel.ifindex %d\n",
       NIP6ADDR((struct in6_addr *)&sel->daddr),
       NIP6ADDR((struct in6_addr *)&sel->saddr),
       sel->dport,
       sel->dport_mask,
       sel->sport,
       sel->sport_mask,
       sel->prefixlen_d,
       sel->prefixlen_s,
       sel->proto,
       sel->ifindex);
}

static void xfrm_sel4_dump(const struct xfrm_selector *sel)
{
  cdbg("sel.daddr %d.%d.%d.%d\n"
       "sel.saddr %d.%d.%d.%d\n"
       "sel.dport %x\n"
       "sel.dport_mask %x\n"
       "sel.sport %x\n"
       "sel.sport_mask %x\n"
       "sel.prefixlen_d %d\n"
       "sel.prefixlen_s %d\n"
       "sel.proto %d\n"
       "sel.ifindex %d\n",
       NIP4ADDR((struct in_addr *)&sel->daddr.a4),
       NIP4ADDR((struct in_addr *)&sel->saddr.a4),
       sel->dport,
       sel->dport_mask,
       sel->sport,
       sel->sport_mask,
       sel->prefixlen_d,
       sel->prefixlen_s,
       sel->proto,
       sel->ifindex);
}

 
static void nlmsg_dump(int nlmsg_flags, int nlmsg_type)
{
  cdbg("nlmsg_flags %x\n"
       "nlmsg_type %d\n",
       nlmsg_flags,
       nlmsg_type);
}



static void xfrm_tmpl_dump(const struct xfrm_user_tmpl *tmpl)
{
  cdbg("xfrma_tmpl.id.daddr %x:%x:%x:%x:%x:%x:%x:%x\n"
       "xfrma_tmpl.id.spi %x\n"
       "xfrma_tmpl.id.proto %d\n"
       "xfrma_tmpl.saddr %x:%x:%x:%x:%x:%x:%x:%x\n"
       "xfrma_tmpl.reqid %d\n"
       "xfrma_tmpl.mode %d\n"
       "xfmra_tmpl.optional %d\n"
       "xfrma_tmpl.aalgos %x\n"
       "xfrma_tmpl.ealgos %d\n"
       "xfrma_tmpl.calgos %d\n",
       NIP6ADDR((struct in6_addr *)&tmpl->id.daddr),
       tmpl->id.spi,
       tmpl->id.proto,
       NIP6ADDR((struct in6_addr *)&tmpl->saddr),
       tmpl->reqid,
       tmpl->mode,
       tmpl->aalgos,
       tmpl->ealgos,
       tmpl->calgos);
}



static void xfrm_policy_dump(const char *msg, int nlmsg_flags, int nlmsg_type,
			     const struct xfrm_userpolicy_info *sp,
			     const struct xfrm_userpolicy_type *ptype,
			     struct xfrm_user_tmpl *tmpls, int num_tmpl)
{
  int i;
  char ptype_buf[64];
  sprintf(ptype_buf, "%u", ptype->type);

  cdbg(msg);
  nlmsg_dump(nlmsg_flags, nlmsg_type);
  xfrm_sel_dump(&sp->sel);
  cdbg("priority %d\n"
       "dir %d\n"
       "action %d\n"
       "type %s\n",
       sp->priority,
       sp->dir,
       sp->action,
       ptype_buf);
  for (i = 0; i < num_tmpl; i++)
    xfrm_tmpl_dump(&tmpls[i]);
}

static void xfrm_policy_id_dump(const char *msg, 
				const struct xfrm_userpolicy_id *sp_id,
				const struct xfrm_userpolicy_type *ptype)
{
  char ptype_buf[64];
  sprintf(ptype_buf, "%u", ptype->type);
  cdbg(msg);
  xfrm_sel_dump(&sp_id->sel);
  cdbg("dir %d\n"
       "type %s\n",
       sp_id->dir,
       ptype_buf);
}


static void xfrm_state_dump(const char *msg, int nlmsg_flags, int nlmsg_type,
			    const struct xfrm_usersa_info *sa,
			    const struct in6_addr *coa)
{
  cdbg(msg);
  nlmsg_dump(nlmsg_flags, nlmsg_type);
  xfrm_sel_dump(&sa->sel);
  cdbg("id.daddr %x:%x:%x:%x:%x:%x:%x:%x\n"
       "id.spi %x\n"
       "id.proto %d\n"
       "saddr %x:%x:%x:%x:%x:%x:%x:%x\n"
       "reqid %d\n"
       "mode %d\n"
       "flags %x\n"
       "xfrma_addr %x:%x:%x:%x:%x:%x:%x:%x\n",
       NIP6ADDR((struct in6_addr *)&sa->id.daddr),
       sa->id.spi,
       sa->id.proto,
       NIP6ADDR((struct in6_addr *)&sa->saddr),
       sa->reqid,
       sa->mode,
       sa->flags,
       NIP6ADDR(coa));
}

static void xfrm_state_id_dump(const char *msg,
			       const struct xfrm_usersa_id *sa_id,
			       const xfrm_address_t *saddr)
{
  cdbg(msg);
  cdbg("daddr %x:%x:%x:%x:%x:%x:%x:%x\n"
       "spi %x\n"
       "proto %d\n"
       "saddr %x:%x:%x:%x:%x:%x:%x:%x\n",
       NIP6ADDR((struct in6_addr *)&sa_id->daddr),
       sa_id->spi,
       sa_id->proto,
       NIP6ADDR((struct in6_addr *)saddr));
}


static void set_selector(const struct in6_addr *daddr, 
			 const struct in6_addr *saddr,
			 int proto, int type, int code, int ifindex,
			 struct xfrm_selector *sel)
{
  memset(sel, 0, sizeof(*sel));

  sel->family = AF_INET6;
  sel->user = getuid();
  sel->ifindex = 0;
  sel->proto = proto;
  switch (proto) {
  case 0: /* Any */
    break;
  case IPPROTO_ICMPV6:
    sel->sport = htons(type);
    if (type)
      sel->sport_mask = ~((__u16)0);
    sel->dport = htons(code);
    if (code)
      sel->dport_mask = ~((__u16)0);
    break;
  case IPPROTO_MH:
    sel->sport = htons(type);
    if (type)
      sel->sport_mask = ~((__u16)0);
    sel->dport = code;
    if (code)
      sel->dport_mask = code;
    break;
  default:
    sel->sport = htons(type);
    if (type)
      sel->sport_mask = ~((__u16)0);
    sel->dport = code;
    if (code)
      sel->dport_mask = ~((__u16)0);

  }
  memcpy(&sel->saddr.a6, saddr, sizeof(*saddr));
  memcpy(&sel->daddr.a6, daddr, sizeof(*daddr));

  if (!IN6_ARE_ADDR_EQUAL(daddr, &in6addr_any))
    sel->prefixlen_d = 128;
  if (!IN6_ARE_ADDR_EQUAL(saddr, &in6addr_any))
    sel->prefixlen_s = 128;
}

void set_v4selector(const struct in_addr daddr,
		    const struct in_addr saddr,
		    int proto, int type, int code,
		    int ifindex, struct xfrm_selector *sel)
{
  memset(sel, 0, sizeof(*sel));

  sel->family = AF_INET;
  sel->user = getuid();
  sel->ifindex = ifindex;
  sel->proto = proto;
  memcpy(&sel->saddr.a4, &saddr, sizeof(struct in_addr));
  memcpy(&sel->daddr.a4, &daddr, sizeof(struct in_addr));
  if (daddr.s_addr != INADDR_ANY)
    sel->prefixlen_d = 32;
  if (saddr.s_addr != INADDR_ANY)
    sel->prefixlen_s = 32;
}


static inline void xfrm_lft(struct xfrm_lifetime_cfg *lft)
{
  lft->soft_byte_limit = XFRM_INF;
  lft->soft_packet_limit = XFRM_INF;
  lft->hard_byte_limit = XFRM_INF;
  lft->hard_packet_limit = XFRM_INF;
}


static int xfrm_policy_add(uint8_t type, const struct xfrm_selector *sel,
			   int update, int dir, int action, int priority,
			   struct xfrm_user_tmpl *tmpls, int num_tmpl)
{
  uint8_t buf[NLMSG_SPACE(sizeof(struct xfrm_userpolicy_info))
	      + RTA_SPACE(sizeof(struct xfrm_userpolicy_type))
	      + RTA_SPACE(sizeof(struct xfrm_user_tmpl)
			  * MIPV6_MAX_TMPLS)];
  struct nlmsghdr *n;
  struct xfrm_userpolicy_info *pol;
  struct xfrm_userpolicy_type ptype;

  int err;
  memset(buf, 0, sizeof(buf));
  n = (struct nlmsghdr *)buf;
  n->nlmsg_len = NLMSG_LENGTH(sizeof(struct xfrm_userpolicy_info));
  if (update) {
    n->nlmsg_flags = NLM_F_REQUEST | NLM_F_REPLACE;
    n->nlmsg_type = XFRM_MSG_UPDPOLICY;
  } else {
    n->nlmsg_flags = NLM_F_REQUEST | NLM_F_CREATE;
    n->nlmsg_type = XFRM_MSG_NEWPOLICY;
  }
  pol = NLMSG_DATA(n);
  memcpy(&pol->sel, sel, sizeof(struct xfrm_selector));
  xfrm_lft(&pol->lft);
  pol->priority = priority;
  pol->dir = dir;
  pol->action = action;
  pol->share = XFRM_SHARE_ANY;

  memset(&ptype, 0, sizeof(ptype));
  ptype.type = type;
  addattr_l(n, sizeof(buf), XFRMA_POLICY_TYPE, &ptype, sizeof(ptype));

  if(num_tmpl > 0)
    addattr_l(n, sizeof(buf), XFRMA_TMPL, 
	      tmpls, sizeof(struct xfrm_user_tmpl) * num_tmpl);

  if ((err = rtnl_xfrm_do(n, NULL)) < 0)
    xfrm_policy_dump("Failed to add policy:\n",
		     n->nlmsg_flags, n->nlmsg_type, 
		     pol, &ptype, tmpls, num_tmpl);
  return err;
}


int xfrm_mip_policy_add(const struct xfrm_selector *sel,
			       int update, int dir, int action, int priority,
			       struct xfrm_user_tmpl *tmpls, int num_tmpl)
{
  return xfrm_policy_add(XFRM_POLICY_TYPE_SUB, sel, update, dir,
			 action, priority, tmpls, num_tmpl);
}


static int xfrm_policy_del(uint8_t type, const struct xfrm_selector *sel, 
			   int dir)
{
  uint8_t buf[NLMSG_SPACE(sizeof(struct xfrm_userpolicy_id))
	      + RTA_SPACE(sizeof(struct xfrm_userpolicy_type))];
  struct nlmsghdr *n;
  struct xfrm_userpolicy_id *pol_id;
  struct xfrm_userpolicy_type ptype;
  int err;

  memset(buf, 0, sizeof(buf));
  n = (struct nlmsghdr *)buf;
  n->nlmsg_len = NLMSG_LENGTH(sizeof(struct xfrm_userpolicy_id));
  n->nlmsg_flags = NLM_F_REQUEST;
  n->nlmsg_type = XFRM_MSG_DELPOLICY;

  pol_id = NLMSG_DATA(n);
  memcpy(&pol_id->sel, sel, sizeof(struct xfrm_selector));
  pol_id->dir = dir;

  memset(&ptype, 0, sizeof(ptype));
  ptype.type = type;
  addattr_l(n, sizeof(buf), XFRMA_POLICY_TYPE, &ptype, sizeof(ptype));

  if ((err = rtnl_xfrm_do(n, NULL)) < 0)
    xfrm_policy_id_dump("Failed to del policy:\n", pol_id, &ptype);
  return err;
}


int xfrm_mip_policy_del(const struct xfrm_selector *sel, int dir)
{
  return xfrm_policy_del(XFRM_POLICY_TYPE_SUB, sel, dir);
}


int xfrm_state_add(const struct xfrm_selector *sel,
			  int proto, const struct in6_addr *coa,
			  int update, uint8_t flags)
{
  uint8_t buf[NLMSG_SPACE(sizeof(struct xfrm_usersa_info))
	      + RTA_SPACE(sizeof(struct in6_addr))];
  struct nlmsghdr *n;
  struct xfrm_usersa_info *sa;
  int err;

  memset(buf, 0, sizeof(buf));
  n = (struct nlmsghdr *)buf;
  n->nlmsg_len = NLMSG_LENGTH(sizeof(struct xfrm_usersa_info));
  if (update) {
    n->nlmsg_flags = NLM_F_REQUEST | NLM_F_REPLACE;
    n->nlmsg_type = XFRM_MSG_UPDSA;
  } else {
    n->nlmsg_flags = NLM_F_REQUEST | NLM_F_CREATE;
    n->nlmsg_type = XFRM_MSG_NEWSA;
  }
  sa = NLMSG_DATA(n);
  memcpy(&sa->sel, sel, sizeof(struct xfrm_selector));
  /* State src and dst addresses */
  memcpy(sa->id.daddr.a6, sel->daddr.a6, sizeof(sel->daddr.a6));
  sa->id.proto = proto;
  memcpy(sa->saddr.a6, sel->saddr.a6, sizeof(sel->saddr.a6));
  xfrm_lft(&sa->lft);
  sa->family = AF_INET6;
  sa->mode = XFRM_MODE_ROUTEOPTIMIZATION;
  sa->flags = flags;

  addattr_l(n, sizeof(buf), XFRMA_COADDR, coa, sizeof(struct in6_addr));

  if ((err = rtnl_xfrm_do(n, NULL)) < 0)
    xfrm_state_dump("Failed to add state:\n",
		    n->nlmsg_flags, n->nlmsg_type, sa, coa);
  return err;
}


int xfrm_state_del(int proto, const struct xfrm_selector *sel)
{
  uint8_t buf[NLMSG_SPACE(sizeof(struct xfrm_usersa_id)) +
	      RTA_SPACE(sizeof(xfrm_address_t))];
  struct nlmsghdr *n;
  struct xfrm_usersa_id *sa_id;
  int err;

  memset(buf, 0, sizeof(buf));
  n = (struct nlmsghdr *)buf;
  n->nlmsg_len = NLMSG_LENGTH(sizeof(struct xfrm_usersa_id));
  n->nlmsg_flags = NLM_F_REQUEST;
  n->nlmsg_type = XFRM_MSG_DELSA;

  sa_id = NLMSG_DATA(n);
  /* State src and dst addresses */
  memcpy(sa_id->daddr.a6, sel->daddr.a6, sizeof(sel->daddr.a6));
  /* modified for dsmip */
  /*sa_id->family = AF_INET6;*/
  sa_id->family = sel->family;
  /**********************/
  sa_id->proto = proto;

  addattr_l(n, sizeof(buf), XFRMA_SRCADDR, &sel->saddr,
	    sizeof(sel->saddr));

  if ((err = rtnl_xfrm_do(n, NULL)) < 0)
    xfrm_state_id_dump("Failed to del state:\n", sa_id, &sel->saddr);
  return err;
}



int xfrm_state_encap_add(const struct xfrm_selector *sel,
				int proto, const struct xfrm_encap_tmpl *tmpl,
				int update, uint8_t flags,
				const struct xfrm_selector *v4)
{
  uint8_t buf[4096];
  struct nlmsghdr *n;
  struct xfrm_usersa_info *sa;
  int err;

  memset(buf, 0, sizeof(buf));
  n = (struct nlmsghdr *)buf;
  n->nlmsg_len = NLMSG_LENGTH(sizeof(struct xfrm_usersa_info));
  if (update) {
    n->nlmsg_flags = NLM_F_REQUEST | NLM_F_REPLACE;
    n->nlmsg_type = XFRM_MSG_UPDSA;
  } else {
    n->nlmsg_flags = NLM_F_REQUEST | NLM_F_CREATE;
    n->nlmsg_type = XFRM_MSG_NEWSA;
  }
  sa = NLMSG_DATA(n);
  memcpy(&sa->sel, sel, sizeof(struct xfrm_selector));
  /* DSMIPv6: src and dst addresses for IPv4 header */
  memcpy(&sa->id.daddr.a4, &v4->daddr.a4, sizeof(v4->daddr.a4));
  sa->id.proto = proto;
  memcpy(&sa->saddr.a4, &v4->saddr.a4, sizeof(v4->saddr.a4));
  xfrm_lft(&sa->lft);
  sa->family = AF_INET;
  sa->mode = XFRM_MODE_TUNNEL;
  sa->flags = flags;
  
  addattr_l(n, sizeof(buf), XFRMA_ENCAP, tmpl,
	    sizeof(struct xfrm_encap_tmpl));
  
  if ((err = rtnl_xfrm_do(n, NULL)) < 0){
    perror("rtnl_xfrm_do:\n");
    XDBG("Failed (%d) to add state for UDP encapsulation\n", err);
    xfrm_sel_dump(sel);
    xfrm_sel4_dump(v4);
  }
  XDBG("adding xfrm state encap succeed \n");
  return err;
}



static void _create_dstopt_tmpl(struct xfrm_user_tmpl *tmpl,
				const struct in6_addr *dst,
				const struct in6_addr *src,
				int mode)
{
  memset(tmpl, 0, sizeof(*tmpl));
  tmpl->family = AF_INET6;
  tmpl->id.proto = IPPROTO_DSTOPTS;
  tmpl->mode = mode;
  tmpl->optional = 1;
  tmpl->reqid = 0;
  if (dst)
    memcpy(&tmpl->id.daddr, dst, sizeof(tmpl->id.daddr));
  if (src)
    memcpy(&tmpl->saddr, src, sizeof(tmpl->saddr));
}

static inline void create_dstopt_tmpl(struct xfrm_user_tmpl *tmpl,
				      const struct in6_addr *dst,
				      const struct in6_addr *src)
{
  _create_dstopt_tmpl(tmpl, dst, src, XFRM_MODE_ROUTEOPTIMIZATION);
}


static void _create_rh_tmpl(struct xfrm_user_tmpl *tmpl, int mode)
{
  memset(tmpl, 0, sizeof(*tmpl));
  tmpl->family = AF_INET6;
  tmpl->id.proto = IPPROTO_ROUTING;
  tmpl->mode = mode;
  tmpl->optional = 1;
  tmpl->reqid = 0;
}

static void create_rh_tmpl(struct xfrm_user_tmpl *tmpl)
{
  _create_rh_tmpl(tmpl, XFRM_MODE_ROUTEOPTIMIZATION);
}

static void create_udpencaps_tmpl(struct xfrm_user_tmpl *utmpl,
				  struct xfrm_encap_tmpl *etmpl,
				  const struct in_addr dst,
				  const struct in_addr src)
{
  /* For the policy */
  memset(utmpl, 0, sizeof(*utmpl));
  utmpl->family = AF_INET;
  utmpl->id.proto = IPPROTO_UDP_ENCAPSULATION;
  utmpl->mode = XFRM_MODE_TUNNEL;
  utmpl->optional = 1;
  utmpl->reqid = 0;
  if (dst.s_addr != INADDR_ANY)
    memcpy(&utmpl->id.daddr, &dst, sizeof(struct in_addr));
  if (src.s_addr != INADDR_ANY)
    memcpy(&utmpl->saddr, &src, sizeof(struct in_addr));

  /* For the state */
  memset(etmpl, 0, sizeof(*etmpl));
  etmpl->encap_type = UDP_ENCAP_IP_VANILLA;
  etmpl->encap_sport = htons(DSMIP_UDP_DPORT);
  etmpl->encap_dport = htons(DSMIP_UDP_DPORT);
}


#define NPROTOv6 1
static const int protolistv6[NPROTOv6][2]=
  {
    {0,0},
    {IPPROTO_MH,0},
    {IPPROTO_ICMPV6,ICMP6_ECHO_REQUEST},
    {IPPROTO_ICMPV6,ICMP6_ECHO_REPLY},
    {IPPROTO_TCP,0},
    {IPPROTO_UDP,0}
  };
#define NPROTOv4 1
static const int protolistv4[NPROTOv4][2]=
  {
    {0,0},
    {IPPROTO_ICMP,0},
    {IPPROTO_UDP,0},
    {IPPROTO_TCP,0}
  };

int start_udp_encap(const struct in6_addr * mn_addrv6,
		    const struct in_addr  * mn_addrv4,
		    const struct in_addr * src,
		    const struct in_addr * dst,
		    int sport,
		    int dport,
		    int prio)
{
  XDBG("--------start---udp---encap-------------\n");
  struct xfrm_selector traffic_sel, encap_sel;
  struct xfrm_user_tmpl tmpl;
  struct xfrm_encap_tmpl etmpl;
  int ret=0,i;
  struct in_addr inaddr_any;
  inaddr_any.s_addr = 0;
  create_udpencaps_tmpl(&tmpl, &etmpl, *dst, *src);
  etmpl.encap_sport = htons(sport);
  etmpl.encap_dport = htons(dport);
  etmpl.encap_oa.a4=dst->s_addr;//destination address
  memset(&traffic_sel,0,sizeof(struct xfrm_selector));
  set_selector(&in6addr_any, &in6addr_any, 0, 0, 0, 0, &traffic_sel);
  set_v4selector(*dst, *src, IPPROTO_UDP_ENCAPSULATION, 0, 0, 0, &encap_sel);
  //encapsulation
  ret = xfrm_state_encap_add(&traffic_sel,
                             IPPROTO_UDP_ENCAPSULATION,
                             &etmpl,
                             0 /* create */,
                             0, &encap_sel);
  if (ret < 0){
    XDBG("adding udp encap state for traffic  failed.\n");
    return ret;
  }
  for(i=0;i<NPROTOv6;++i){
    if(mn_addrv6==0){
      set_selector(&in6addr_any, &in6addr_any, protolistv6[i][0], 
		   protolistv6[i][1], 0, 0, &traffic_sel);
      traffic_sel.prefixlen_d = 0;                                       
      traffic_sel.prefixlen_s = 0;      
    }
    else {
      set_selector(&in6addr_any, 
		   mn_addrv6, 
		   protolistv6[i][0], 
		   protolistv6[i][1], 0, 0, &traffic_sel);
      traffic_sel.prefixlen_d = 0;                                       
      traffic_sel.prefixlen_s = 128;
    }
    ret+= xfrm_mip_policy_add(&traffic_sel,
			      0 /* create */,
			      XFRM_POLICY_OUT,
			      XFRM_POLICY_ALLOW, prio, &tmpl, 1);
  }
  if(ret<0){
    XDBG("adding udp encap policy for v6 traffic failed.\n");
    goto clean;
  }
  for(i=0;i<NPROTOv4;++i){
    if(mn_addrv4==0){
    set_selector(&in6addr_any, &in6addr_any, protolistv4[i][0], 
		 protolistv4[i][1], 0, 0, &traffic_sel);
    traffic_sel.family=AF_INET;
    traffic_sel.prefixlen_d = 0;                                       
    traffic_sel.prefixlen_s = 0;      
    }
    else {
      set_v4selector(inaddr_any,
		     *mn_addrv4, 
		     protolistv4[i][0], 
		     protolistv4[i][1], 0, 0, &traffic_sel);
      traffic_sel.family=AF_INET;
      traffic_sel.prefixlen_d = 0;                                       
      traffic_sel.prefixlen_s = 32; 
    }
    ret += xfrm_mip_policy_add(&traffic_sel,
			       0 /* create */,
			       XFRM_POLICY_OUT,
			       XFRM_POLICY_ALLOW, prio, &tmpl, 1);
  }
  if(ret<0){
    XDBG("adding udp encap policy for v4 traffic failed.\n");
    goto clean;
  }
  return 0;
 clean:
  stop_udp_encap(mn_addrv6,
		 mn_addrv4,
		 src,
		 dst,
		 sport,
		 dport,
		 prio);
  return -1;
}


int stop_udp_encap(const struct in6_addr * mn_addrv6,
		   const struct in_addr  * mn_addrv4,
		   const struct in_addr * src,
		   const struct in_addr * dst,
		   int sport,
		   int dport,
		   int prio)
{
  struct xfrm_selector traffic_sel, encap_sel;
  int ret=0,i;
  set_v4selector(*dst, *src, IPPROTO_UDP_ENCAPSULATION, 0, 0, 0, &encap_sel);
  for(i=0;i<NPROTOv6;++i){
    if(mn_addrv6==0){
      set_selector(&in6addr_any, &in6addr_any, 
		   protolistv6[i][0], protolistv6[i][1], 
		   0, 0, &traffic_sel);
      traffic_sel.prefixlen_d = 0;                                       
      traffic_sel.prefixlen_s = 0;      
    }
    else {
      set_selector(&in6addr_any, 
		   mn_addrv6,
		   protolistv6[i][0], 
		   protolistv6[i][1], 0, 0, &traffic_sel);
      traffic_sel.prefixlen_d = 0;                                       
      traffic_sel.prefixlen_s = 128;    
    }
    ret+= xfrm_mip_policy_del(&traffic_sel,
			      XFRM_POLICY_OUT);
  }
  if (ret < 0){
    XDBG("deleting udp traffic encap policy v6 failed.\n");
    //return ret;
  }
  for(i=0;i<NPROTOv4;++i){
    if(mn_addrv4==0){
      set_selector(&in6addr_any, &in6addr_any, 
		   protolistv4[i][0], protolistv4[i][1], 
		   0, 0, &traffic_sel);
      traffic_sel.family=AF_INET;
      traffic_sel.prefixlen_d = 0;                                       
      traffic_sel.prefixlen_s = 0;      
    }
    else {
      struct in_addr inaddr_any;
      inaddr_any.s_addr = 0;
      set_v4selector(inaddr_any, 
		     *mn_addrv4, 
		     protolistv4[i][0], 
		     protolistv4[i][1], 0, 0, &traffic_sel);
      traffic_sel.family=AF_INET;
      traffic_sel.prefixlen_d = 0;                                       
      traffic_sel.prefixlen_s = 32; 
    }
    ret += xfrm_mip_policy_del(&traffic_sel,
			       XFRM_POLICY_OUT);
  }
  if (ret < 0){
    XDBG("deleting udp traffic encap policy v4 failed.\n");
  }

  if(!xfrm_state_del(IPPROTO_UDP_ENCAPSULATION, &encap_sel)){
  }
  else {
    XDBG("deleting udp encap traffic state failed.\n");
  }
  return ret;
}


#define UDP_ENCAP_PRIO 5

#endif

#define XFRM_NO_TEST 1
#ifndef XFRM_NO_TEST 
#define XFRM_NO_TEST

int main()
{
  //create dstopt policies                                                                                        
   struct in6_addr
     ha={0x3f,0xfe,0x5,0x01,0xff,0xff,0x01,0x0,0,0,0,0,0,0,0x0,0x8}
   ,hoa={0x3f,0xfe,0x5,0x01,0xff,0xff,0x01,0x0,0,0,0,0,0,0,0x0,0x1}
   ,coa={0x20,0x01,0xc,0xc0,0x20,0x26,0x1,0x89,0x02,0x0c,0x29,0xff,0xfe,0x5d,
         0xe2,0x9c};
   struct xfrm_user_tmpl tmpl;
   struct xfrm_selector sel;
   create_dstopt_tmpl(&tmpl,&ha,&hoa);
   set_selector(&ha,&hoa,IPPROTO_MH,IP6_MH_TYPE_BU,0,0,&sel);
   int retp = xfrm_mip_policy_add(&sel,0,XFRM_POLICY_OUT,
				  XFRM_POLICY_ALLOW, 3,
				  &tmpl, 1);
   if(retp <0)fprintf(stderr,"add policy failed\n");
   else fprintf(stderr,"add policy succeed\n");

   //set_selector(&bule->peer_addr, &bule->hoa, 0, 0, 0, 0, &sel);                                                
   int rets = xfrm_state_add(&sel, IPPROTO_DSTOPTS, &coa, 0, 0);
   if(rets<0)fprintf(stderr,"add state failed\n");
   else fprintf(stderr,"add state succedd\n");
   char c;
   while(scanf("%c",&c)&&c!='x');
   if(retp ==0){
     retp = xfrm_mip_policy_del(&sel,XFRM_POLICY_OUT);
     if(retp <0)fprintf(stderr,"delete policy failed\n");
     else fprintf(stderr,"delete policy succeed\n");
   }
   if(rets ==0){
     rets = xfrm_state_del(IPPROTO_DSTOPTS,&sel);
     if(rets<0){
       fprintf(stderr,"delete state failed\n");
     }
     else fprintf(stderr,"delete state succeed\n");

   }

}
#endif
