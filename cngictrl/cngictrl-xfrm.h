/*
 * author: hanson yu
 * mail: hangzhong.yu@gmail.com
 */

#ifndef __CNGICTRL_XFRM_H__
#define __CNGICTRL_XFRM_H__

#include <errno.h>
#include <string.h>
#include <unistd.h>
#include <pthread.h>
#include <time.h>
#include <stdio.h>
#include <linux/xfrm.h>

#include "common.h"
#include "rtnl.h"

//-------------------interfaces-------------------------------
int do_v4_handoff(const struct in_addr *HOA,
		const struct in_addr  *CNA,
		const struct in_addr  *COA,
		const struct in_addr  *HA,
		int sport,
		int dport,
		int prio);
//------------------------------------------------------------

#define MIPV6_MAX_TMPLS 3 /* AH, ESP, IPCOMP */
//added by ld 13/5/5 13:50
#define DSMIP_UDP_DPORT 666
#define UDP_ENCAP_IP_VANILLA 4
#define _hoav4 "172.16.0.197" 
#define _cnav4 "172.16.0.198" 
#define _coav4 "172.16.0.199" 
#define _hav4 "172.16.0.200" 
#ifndef IPPROTO_UDP_ENCAPSULATION
#define IPPROTO_UDP_ENCAPSULATION 166 
#endif


void set_v4_selector(const struct in_addr *src,
		const struct in_addr *dst,
		int proto, int type, int code, 
		struct xfrm_selector *sel)
{
	memset(sel, 0, sizeof(*sel));

	sel->family = AF_INET;
	sel->user = getuid();
	//m: ld 13/5/5 13:55
	//add the proto
	sel->proto = proto; 
	memcpy(&sel->saddr.a4, src, sizeof(struct in_addr));
	memcpy(&sel->daddr.a4, dst, sizeof(struct in_addr));
	if (dst->s_addr != INADDR_ANY)
		sel->prefixlen_d = 32;
	if (src->s_addr != INADDR_ANY)
		sel->prefixlen_s = 32;
}

static void _create_v4_tmpl(const struct in_addr *src, 
		const struct in_addr *dst, int mode,
		struct xfrm_user_tmpl *utmpl,
		/*ld*/struct xfrm_encap_tmpl *etmpl/*ld*/)
{
	memset(utmpl, 0, sizeof(*utmpl));
	utmpl->family = AF_INET;
	utmpl->mode = mode; // 0 for transport, 1 for tunnel
	utmpl->reqid = 0xAF018; // some __u32 value
	//m: ld 13/5/5 13:44
	utmpl->id.proto = IPPROTO_UDP_ENCAPSULATION; // IPPROTO_ESP, IPPROTO_AH, IPPROTO_COMP
	utmpl->optional = 1; // option 'level' of ip utility, 0 for 'required', 1 for 'use'
	utmpl->id.spi = (__u32) 0x118; // some __u32 number

	if (dst->s_addr != INADDR_ANY)
		memcpy(&utmpl->id.daddr, dst, sizeof(struct in_addr));
	if (src->s_addr != INADDR_ANY)
		memcpy(&utmpl->saddr, src, sizeof(struct in_addr));

	// set all algos to infinity:
	utmpl->aalgos = (~(__u32)0);
	utmpl->ealgos = (~(__u32)0);
	utmpl->calgos = (~(__u32)0);

	//added by ld
	memset(etmpl, 0, sizeof(*etmpl));
	etmpl->encap_type = UDP_ENCAP_IP_VANILLA;
	etmpl->encap_sport = htons(DSMIP_UDP_DPORT);
	etmpl->encap_dport = htons(DSMIP_UDP_DPORT);
}


static inline void create_v4_tmpl(const struct in_addr *src, 
		const struct in_addr *dst, 
		struct xfrm_user_tmpl *tmpl,
		/*ld*/struct xfrm_encap_tmpl *etmpl/*ld*/)
{
	_create_v4_tmpl(src, dst, 1/*0 for transport, 1 for tunnel*/, tmpl, etmpl);
}

static inline void xfrm_lft(struct xfrm_lifetime_cfg *lft)
{
	lft->soft_byte_limit = XFRM_INF;
	lft->soft_packet_limit = XFRM_INF;
	lft->hard_byte_limit = XFRM_INF;
	lft->hard_packet_limit = XFRM_INF;
}


//m:ld 13/5/5 17:10
int xfrm_v4_state_add(/*ld*/const struct xfrm_selector *sel/*ld*/, 
		const struct in_addr *src, 
		const struct in_addr *dst,/* int prio, (proto?)*/
		/*ld*/int proto, const struct xfrm_encap_tmpl *etmpl/*ld*/)
{
	uint8_t buf[4096];
	struct nlmsghdr *n;
	struct xfrm_usersa_info *sa;
	int err;

	memset(buf, 0, sizeof(buf));
	n = (struct nlmsghdr *)buf;
	n->nlmsg_len = NLMSG_LENGTH(sizeof(struct xfrm_usersa_info));
	n->nlmsg_flags = NLM_F_REQUEST | NLM_F_CREATE;
	n->nlmsg_type = XFRM_MSG_NEWSA;
	sa = NLMSG_DATA(n);
	//added by ld 13/5/5 22:57
	memcpy(&sa->sel, sel, sizeof(struct xfrm_selector));

	/* DSMIPv6: src and dst addresses for IPv4 header */
	memcpy(&sa->id.daddr.a4, dst, sizeof(dst));
	sa->id.proto = proto;
	memcpy(&sa->saddr.a4, src, sizeof(src));
	xfrm_lft(&sa->lft);
	sa->family = AF_INET;
	sa->mode = XFRM_MODE_TUNNEL;
	//added by ld 
	addattr_l(n,sizeof(buf), XFRMA_ENCAP, etmpl,
			sizeof(struct xfrm_encap_tmpl));

	if ((err = rtnl_xfrm_do(n, NULL)) < 0){
		perror("rtnl_xfrm_do:\n");
	}
	return err;
}

static int xfrm_policy_add(int action, int dir, int priority, uint8_t type, 
		const struct xfrm_selector *sel, struct xfrm_user_tmpl *tmpls, int num_tmpl)
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
	n->nlmsg_flags = NLM_F_REQUEST | NLM_F_CREATE;
	n->nlmsg_type = XFRM_MSG_NEWPOLICY;

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
	{  
		//"Failed to add policy:\n",
	}
	return err;
}

int xfrm_v4_policy_add(int action, int dir, int priority, 
		const struct xfrm_selector *sel, struct xfrm_user_tmpl *tmpls, int num_tmpl)
{
	return xfrm_policy_add(action, dir, priority, XFRM_POLICY_TYPE_SUB, sel, tmpls, num_tmpl);
}


int do_v4_handoff(const struct in_addr *HOA,
		const struct in_addr  *CNA,
		const struct in_addr  *COA,
		const struct in_addr  *HA,
		int sport,
		int dport,
		int prio)
{
	struct xfrm_user_tmpl tmpl;
	struct xfrm_selector sel;
	//added by ld 13/5/5 20:41
	struct xfrm_encap_tmpl etmpl;

	create_v4_tmpl(COA, HA, &tmpl, &etmpl);
	//added by ld 13/5/5 20:50
	etmpl.encap_sport = htons(sport);
	etmpl.encap_dport = htons(dport);
	etmpl.encap_oa.a4=HA->s_addr;//destination address

	set_v4_selector(HOA, CNA, 0, 0, 0, &sel);
	//m:ld change hoa to ha
	int ret = xfrm_v4_state_add(&sel, COA, HA, 0, &etmpl);
	if (ret < 0)
	{
		//error
		//adding udp encap state for traffic  failed.
		return ret;
	}
	sel.family=AF_INET;
	ret += xfrm_v4_policy_add(XFRM_POLICY_ALLOW, XFRM_POLICY_OUT, prio, &sel, &tmpl, 1);

	if (ret < 0)
	{
		//error
		//adding udp encap policy for v4 traffic failed.
		return ret;
	}
	return 0;
}

int do_handoff()
{
	struct in_addr  hoav4;
	struct in_addr  coav4;
	struct in_addr  cnav4;
	struct in_addr  hav4;
	inet_pton(AF_INET,_hoav4,&hoav4);
	inet_pton(AF_INET,_cnav4,&coav4);
	inet_pton(AF_INET,_coav4,&cnav4);
	inet_pton(AF_INET,_hav4,&hav4);
	do_v4_handoff(hoav4, coav4, cnav4, hav4, 5000, 5000, 1);
}

void xfrm_test()
{
	fprintf(stderr, "just a test!\n");
}
#endif

