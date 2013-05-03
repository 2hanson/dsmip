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

void set_v4_selector(const struct in_addr saddr,
        const struct in_addr daddr,
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

static void _create_v4_tmpl(const struct in_addr *src, 
        const struct in_addr *dst,
        int mode, struct xfrm_user_tmpl *tmpl)
{
    memset(tmpl, 0, sizeof(*tmpl));
    utmpl->family = AF_INET;
    utmpl->mode = mode; // 0 for transport, 1 for tunnel
    utmpl->reqid = 0xAF018; // some __u32 value
    utmpl->id.proto = IPPROTO_ESP; // IPPROTO_ESP, IPPROTO_AH, IPPROTO_COMP
    utmpl->optional = 1; // option 'level' of ip utility, 0 for 'required', 1 for 'use'
    tmpl->id.spi = (__u32) 0x118; // some __u32 number

    if (dst.s_addr != INADDR_ANY)
        memcpy(&tmpl->id.daddr, dst, sizeof(struct in_addr));
    if (src.s_addr != INADDR_ANY)
        memcpy(&tmpl->saddr, src, sizeof(struct in_addr));

    // set all algos to infinity:
    tmpl->aalgos = (~(__u32)0);
    tmpl->ealgos = (~(__u32)0);
    tmpl->calgos = (~(__u32)0);
}

static inline void create_v4_tmpl(const struct in_addr *src, 
        const struct in_addr *dst, 
        struct xfrm_user_tmpl *tmpl)
{
    _create_v4_tmpl(src, dst, 1/*0 for transport, 1 for tunnel*/, tmpl);
}

int xfrm_v4_state_add(int prio, int proto, const struct in_addr *src, 
        const struct in_addr *dst, const struct xfrm_selector *v4)
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
    /* DSMIPv6: src and dst addresses for IPv4 header */
    memcpy(&sa->id.daddr.a4, dst, sizeof(dst));
    sa->id.proto = proto;
    memcpy(&sa->saddr.a4, src, sizeof(src));
    xfrm_lft(&sa->lft);
    sa->family = AF_INET;
    sa->mode = XFRM_MODE_TUNNEL;

    if ((err = rtnl_xfrm_do(n, NULL)) < 0){
        perror("rtnl_xfrm_do:\n");
    }
    return err;
}




static int xfrm_policy_add(uint8_t type, const struct xfrm_selector *sel, int dir, int action, int priority,
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



int xfrm_v4_policy_add(const struct xfrm_selector *sel, int dir, int action, int priority,
        struct xfrm_user_tmpl *tmpls, int num_tmpl)
{
    return xfrm_policy_add(XFRM_POLICY_TYPE_SUB, sel, dir,
            action, priority, tmpls, num_tmpl);
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

    create_v4_tmpl(&COA, &HA, &tmpl);
    set_v4_selector(&HOA, &CNA, &sel);
    
    ret = xfrm_v4_state_add(prio, &sel, coa, hoa);
    //-----------------------------------bug: ----------------------
    //sel is same for state and policy;
    //---------------------------------------------
    if (ret < 0)
    {
        //error
        //adding udp encap state for traffic  failed.
        return ret;
    }
    sel.family=AF_INET;
    ret += xfrm_v4_policy_add(&sel,
            XFRM_POLICY_OUT,
            XFRM_POLICY_ALLOW, prio, &tmpl, 1);

    if (ret < 0)
    {
        //error
        //adding udp encap policy for v4 traffic failed.
        return ret;
    }
    return 0;
}
#endif

