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
	utmpl->id.proto = IPPROTO_UDP_ENCAPSULATION; // IPPROTO_ESP, IPPROTO_AH, IPPROTO_COMP
	utmpl->mode = mode; // 0 for transport, 1 for tunnel
	utmpl->optional = 1; // option 'level' of ip utility, 0 for 'required', 1 for 'use'
	utmpl->reqid = 0; // some __u32 value

	if (dst->s_addr != INADDR_ANY)
		memcpy(&utmpl->id.daddr, dst, sizeof(struct in_addr));
	if (src->s_addr != INADDR_ANY)
		memcpy(&utmpl->saddr, src, sizeof(struct in_addr));

	// set all algos to infinity:
	utmpl->aalgos = (~(__u32)0);
	utmpl->ealgos = (~(__u32)0);
	utmpl->calgos = (~(__u32)0);

    //for the state
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

int xfrm_v4_state_add(const struct xfrm_selector *sel, 
		const struct in_addr *src, 
		const struct in_addr *dst,/* int prio, (proto?)*/
		int proto, const struct xfrm_encap_tmpl *etmpl)
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
	memcpy(&sa->sel, sel, sizeof(struct xfrm_selector));

	/* DSMIPv6: src and dst addresses for IPv4 header */
	memcpy(&sa->id.daddr.a4, dst, sizeof(dst));
	sa->id.proto = IPPROTO_COMP;
	sa->id.spi = (__u32)0x0010001;
	memcpy(&sa->saddr.a4, src, sizeof(src));
	xfrm_lft(&sa->lft);
	sa->family = AF_INET;
	sa->mode = XFRM_MODE_TUNNEL;
	//addattr_l(n,sizeof(buf), XFRMA_ENCAP, etmpl,
	//		sizeof(struct xfrm_encap_tmpl));

	if ((err = rtnl_xfrm_do(n, NULL)) < 0){
		perror("line at 144, rtnl_xfrm_do:\n");
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
		perror("line at 185, rtnl_xfrm_do: Failed to add policy.\n");
		//"Failed to add policy:\n",
	}
	return err;
}

int xfrm_v4_policy_add(int action, int dir, int priority, 
		const struct xfrm_selector *sel, struct xfrm_user_tmpl *tmpls, int num_tmpl)
{
	return xfrm_policy_add(action, dir, priority, XFRM_POLICY_TYPE_SUB, sel, tmpls, num_tmpl);
}


#define RTA_BUF_SIZE 2048
#define XFRM_ALGO_KEY_BUF_SIZE 512

/**
 * This example will insert new security association (SA) in kernel's
 * security association database (SADB).
 * 
 * Ip equivalent is:
 *     ip xfrm state add src 10.0.11.41 dst 10.0.11.33 proto esp 
 *     enc des3_ede 0x79b5d6e36dda9da4982f51293767d6108649ced573c8349e
 */
int add_state_3des() {

	struct {
		struct nlmsghdr     n;
		struct xfrm_usersa_info xsinfo;
		char            buf[RTA_BUF_SIZE];
	} req;

	memset( &req, 0, sizeof(req) );

	// Netlink Header:
	req.n.nlmsg_len = NLMSG_LENGTH( sizeof(req.xsinfo) );
	req.n.nlmsg_flags = NLM_F_REQUEST|NLM_F_CREATE|NLM_F_EXCL;
	req.n.nlmsg_type = XFRM_MSG_NEWSA;


	// primitive xsinfo fields:
	req.xsinfo.family = AF_INET;        // IP4
	req.xsinfo.saddr.a4 = 0x290b000a;   // saddr = 10.0.11.41
	// req.xsinfo.seq = ;
	// req.xsinfo.reqid = (__u32) 0;       // __u32 value
	// req.xsinfo.mode = (__u8) 0;         // 0=transport,1=tunnel
	// req.xsinfo.replay_window = (__u8) 0;// __u8 value
	// req.xsinfo.flags = ;             // XFRM_STATE_NOECN, XFRM_STATE_DECAP_DSCP

	// ID:
	req.xsinfo.id.daddr.a4 = 0x210b000a;// daddr = 10.0.11.33
	req.xsinfo.id.proto = IPPROTO_ESP;  // IPPROTO_ESP, IPPROTO_AH, IPPROTO_COMP, IPPROTO_IPV6 (testing only)
	req.xsinfo.id.spi = (__u32) 0x0010001; // __u32 value

	// LFT:
	// set this to value you desire or to infinity if you dont' want any limits
	req.xsinfo.lft.soft_byte_limit = XFRM_INF;
	req.xsinfo.lft.hard_byte_limit = XFRM_INF;
	req.xsinfo.lft.soft_packet_limit = XFRM_INF;
	req.xsinfo.lft.hard_packet_limit = XFRM_INF;
	// req.xsinfo.lft.soft_add_expires_seconds = ;
	// req.xsinfo.lft.soft_add_expires_seconds = ;
	// req.xsinfo.lft.soft_add_expires_seconds = ;
	// req.xsinfo.lft.soft_add_expires_seconds = ;

	// SEL:
	// req.xsinfo.sel.daddr = ;
	// req.xsinfo.sel.saddr = ;
	// req.xsinfo.sel.dport = ;
	// req.xsinfo.sel.dport_mask = ;
	// req.xsinfo.sel.sport = ;
	// req.xsinfo.sel.sport_mask = ;
	// req.xsinfo.sel.family = ;
	// req.xsinfo.sel.prefixlen_d = ;
	// req.xsinfo.sel.prefixlen_s = ;
	// req.xsinfo.sel.proto = ;
	// req.xsinfo.sel.ifindex = ;
	// req.xsinfo.sel.user = ;


	// add algortihms:
	struct alg {
		struct xfrm_algo alg;
		char buf[XFRM_ALGO_KEY_BUF_SIZE];
	};

	// XFRMA_ALG_CRYPT:
	struct alg des;
	memset(&des, 0, sizeof( struct alg ));
	strncpy(des.alg.alg_name, "des3_ede", sizeof(des.alg.alg_name));

	// key = 0x79b5d6e36dda9da4982f51293767d6108649ced573c8349e

	des.alg.alg_key_len = 192;
	des.alg.alg_key[0] = 0x79;
	des.alg.alg_key[1] = 0xb5;
	des.alg.alg_key[2] = 0xd6;
	des.alg.alg_key[3] = 0xe3;
	des.alg.alg_key[4] = 0x6d;
	des.alg.alg_key[5] = 0xda;
	des.alg.alg_key[6] = 0x9d;
	des.alg.alg_key[7] = 0xa4;
	des.alg.alg_key[8] = 0x98;
	des.alg.alg_key[9] = 0x2f;
	des.alg.alg_key[10] = 0x51;
	des.alg.alg_key[11] = 0x29;
	des.alg.alg_key[12] = 0x37;
	des.alg.alg_key[13] = 0x67;
	des.alg.alg_key[14] = 0xd6;
	des.alg.alg_key[15] = 0x10;
	des.alg.alg_key[16] = 0x86;
	des.alg.alg_key[17] = 0x49;
	des.alg.alg_key[18] = 0xce;
	des.alg.alg_key[19] = 0xd5;
	des.alg.alg_key[20] = 0x73;
	des.alg.alg_key[21] = 0xc8;
	des.alg.alg_key[22] = 0x34;
	des.alg.alg_key[23] = 0x9e;


	int len = sizeof(struct xfrm_algo) + des.alg.alg_key_len;
	addattr_l(&req.n, sizeof(req.buf), XFRMA_ALG_CRYPT, (void *)&des, len);

	struct rtnl_handle rth;

	if (rtnl_open_byproto(&rth, 0, NETLINK_XFRM) < 0) { 
		fprintf(stderr,"rtnl: rtnl_open_byproto failed\n");
		return -1;
	}
	int err = rtnl_talk(&rth, &req.n, 0, 0, NULL, NULL, NULL);
	rtnl_close(&rth);

	/*
	   int err = 0;

	   if ((err = rtnl_xfrm_do(&req.n, NULL)) < 0){
	   perror("line at 308, rtnl_xfrm_do:\n");
	   }
	   */
	return 0;
}


int do_v4_handoff(const struct in_addr *HOA,
		const struct in_addr  *CNA,
		const struct in_addr  *COA,
		const struct in_addr  *HA,
		int sport,
		int dport,
		int prio)
{
	struct xfrm_selector sel;
	struct xfrm_user_tmpl tmpl;
	struct xfrm_encap_tmpl etmpl;

	create_v4_tmpl(COA, HA, &tmpl, &etmpl);
	
    etmpl.encap_sport = htons(sport);
	etmpl.encap_dport = htons(dport);
	etmpl.encap_oa.a4=HA->s_addr;//destination address

	set_v4_selector(HOA, CNA, 0, 0, 0, &sel);
	//add_state_3des();
	int ret = xfrm_v4_state_add(&sel, COA, HA, IPPROTO_UDP_ENCAPSULATION, &etmpl);
	if (ret < 0)
	{
		//error
		//adding udp encap state for traffic  failed.
		return ret;
	}
	
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
	do_v4_handoff(&hoav4, &coav4, &cnav4, &hav4, 5000, 5000, 1);

	return 0;
}

void xfrm_test()
{
	fprintf(stderr, "just a test!\n");
}
#endif

