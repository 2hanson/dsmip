/*
  icmp.h:
  handle the following messages:
  
  send 'router solicitation'
  receive 'router advertisement'
  
  make 'neighbor_proxy'
  send 'neighbor advertisement'
  
  
  LIN HUI 
  linhui08@gmail.com
  last modified: JUNE 29. 2010
*/

#ifndef __LH_ICMP6__H__
#define __LH_ICMP6__H__


/* IPv6 packet information.  */
/*struct in6_pktinfo
  {
    struct in6_addr ipi6_addr;	/* src/dst IPv6 address */
   // unsigned int ipi6_ifindex;	/* send/recv interface index */
  //}; /*add by syl for make*/

#include <sys/socket.h>
#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <net/if_arp.h>
#include <net/if.h>
#include <syslog.h>
#include <netinet/in.h>
#include <netinet/ip6.h>
#include <netinet/icmp6.h>
#include <pthread.h>
#include "rtnl.h"
#include "common.h"
#include "tunlctl.h"

#ifndef dbg
#define dbg(format, args...) fprintf(stderr,format,##args)
#endif

#define PTHREAD_MUTEX_FAST_NP PTHREAD_MUTEX_TIMED_NP

#define IN6ADDR_ALL_NODES_MC_INIT \
  { { { 0xff,0x02,0,0,0,0,0,0,0,0,0,0,0,0,0,0x1 } } }

#define IN6ADDR_ALL_ROUTERS_MC_INIT \
  { { { 0xff,0x02,0,0,0,0,0,0,0,0,0,0,0,0,0,0x2 } } }

#define MAX_PKT_LEN 1540

const struct in6_addr in6addr_all_nodes_mc = IN6ADDR_ALL_NODES_MC_INIT;
const struct in6_addr in6addr_all_routers_mc = IN6ADDR_ALL_ROUTERS_MC_INIT;

struct __icmp6_sock {
  pthread_mutex_t send_mutex;
  int fd;
};

static struct __icmp6_sock icmp6_sock ;
static pthread_t icmp6_listener;

static int is_mn;

//-----------------------------interfaces--------------------------
int icmp6_init(int _is_mn);
int icmp6_cleanup();
int ndisc_send_na(int ifindex, const struct in6_addr *src,
                  const struct in6_addr *dst,
                  const struct in6_addr *target, uint32_t flags);
int ndisc_send_ns(int ifindex, const struct in6_addr *src,
                  const struct in6_addr *dst,
                  const struct in6_addr *target);
int ndisc_send_rs(int ifindex, const struct in6_addr *src,
                  const struct in6_addr *dst);
int proxy_nd_start(int ifindex, struct in6_addr *target,
                   struct in6_addr *src, int bu_flags);
void proxy_nd_stop(int ifindex, struct in6_addr *target, int bu_flags);
//-----------------------------------------------------------------
ssize_t icmp6_recv(int sockfd, unsigned char *msg, size_t msglen,
		   struct sockaddr_in6 *addr, struct in6_pktinfo *pkt_info,
		   int *hoplimit)
{
#define CMSG_BUF_LEN  128
  struct msghdr mhdr;
  struct cmsghdr *cmsg;
  struct iovec iov;
  static unsigned char chdr[CMSG_BUF_LEN];
  ssize_t len;

  iov.iov_len = msglen;
  iov.iov_base = (unsigned char *) msg;

  mhdr.msg_name = (void *)addr;
  mhdr.msg_namelen = sizeof(struct sockaddr_in6);
  mhdr.msg_iov = &iov;
  mhdr.msg_iovlen = 1;
  mhdr.msg_control = (void *)chdr;
  mhdr.msg_controllen = CMSG_BUF_LEN;

  if ((len = recvmsg(sockfd, &mhdr, 0)) < 0)
    return -errno;

  for (cmsg = CMSG_FIRSTHDR(&mhdr); cmsg; 
       cmsg = CMSG_NXTHDR(&mhdr, cmsg)) {
    if (cmsg->cmsg_level != IPPROTO_IPV6)
      continue;
    switch(cmsg->cmsg_type) {
    case IPV6_HOPLIMIT:
      *hoplimit = *(int *)CMSG_DATA(cmsg);
      break;
    case IPV6_PKTINFO:
      memcpy(pkt_info, CMSG_DATA(cmsg), sizeof(*pkt_info));
      break;
    }
  }
  return len;
}


int recvra(struct in6_addr *rtaddr)
{
  #define MAX_PKT_LEN  1540
  uint8_t msg[MAX_PKT_LEN];
  struct sockaddr_in6 addr;
  struct in6_addr *saddr, *daddr;
  struct in6_pktinfo pkt_info;
  struct icmp6_hdr *ih;
  int iif, hoplimit;
  ssize_t len;
  struct icmp6_handler *h;
  len = icmp6_recv(icmp6_sock.fd, msg, sizeof(msg),
		   &addr, &pkt_info, &hoplimit);
  if (len == -EBADF)
    return -1;
  if (len < sizeof(struct icmp6_hdr))
    return -1;
  saddr = &addr.sin6_addr;
  daddr = &pkt_info.ipi6_addr;
  iif = pkt_info.ipi6_ifindex;
  ih = (struct icmp6_hdr *)msg;
  if(ih->icmp6_type == ND_ROUTER_ADVERT){
    fprintf(stderr,
	    "ROUTER_ADVERT received from "
	    "%x:%x:%x:%x:%x:%x:%x:%x on iface %d\n",
	    NIP6ADDR(saddr), iif);
    memcpy(rtaddr,saddr,sizeof(struct in6_addr));
    return iif;
  }
  return -1;
  //pthread_exit(NULL);
}



int icmp6_init(int _is_mn)
{
  //must be called at first!!
  is_mn = _is_mn;
  struct icmp6_filter filter;
  int val;
  icmp6_sock.fd = socket(AF_INET6, SOCK_RAW, IPPROTO_ICMPV6);
  if (icmp6_sock.fd < 0) {
    syslog(LOG_ERR,
	   "Unable to open ICMPv6 socket! "
	   "Do you have root permissions?");
    return icmp6_sock.fd;
  }
  val = 1;
  if (setsockopt(icmp6_sock.fd, IPPROTO_IPV6, IPV6_RECVPKTINFO, 
		 &val, sizeof(val)) < 0)
    return -1;
  if (setsockopt(icmp6_sock.fd, IPPROTO_IPV6, IPV6_RECVHOPLIMIT,
		 &val, sizeof(val)) < 0)
    return -1;
  ICMP6_FILTER_SETBLOCKALL(&filter);
  if(_is_mn)
    ICMP6_FILTER_SETPASS(ND_ROUTER_ADVERT, &filter);
  
  if (setsockopt(icmp6_sock.fd, IPPROTO_ICMPV6, ICMP6_FILTER, 
		 &filter, sizeof(struct icmp6_filter)) < 0)
    return -1;
  val = 2;
  if (setsockopt(icmp6_sock.fd, IPPROTO_RAW, IPV6_CHECKSUM, 
		 &val, sizeof(val)) < 0)
    return -1;
  return 0;
}


int icmp6_cleanup()
{
  close(icmp6_sock.fd);
  //if(is_mn){
  //pthread_cancel(icmp6_listener);
  //pthread_join(icmp6_listener, NULL);
  //}
  return 0;
}



static inline void free_iov_data(struct iovec *iov, int count)
{
  int len = count;

  if (iov == NULL) return;
  while (len--) {
    if (iov[len].iov_base)
      free(iov[len].iov_base);
  }
}


static int neigh_mod(int nl_flags, int cmd, int ifindex,
		     uint16_t state, uint8_t flags, struct in6_addr *dst,
		     uint8_t *hwa, int hwalen)
{
  uint8_t buf[256];
  struct nlmsghdr *n;
  struct ndmsg *ndm;

  memset(buf, 0, sizeof(buf));
  n = (struct nlmsghdr *)buf;
  n->nlmsg_len = NLMSG_LENGTH(sizeof(struct ndmsg));
  n->nlmsg_flags = NLM_F_REQUEST|nl_flags;
  n->nlmsg_type = cmd;

  ndm = NLMSG_DATA(n);
  ndm->ndm_family = AF_INET6;
  ndm->ndm_ifindex = ifindex;
  ndm->ndm_state = state;
  ndm->ndm_flags = flags;
  ndm->ndm_type = (IN6_IS_ADDR_MULTICAST(dst) ? 
		   RTN_MULTICAST : RTN_UNICAST);

  addattr_l(n, sizeof(buf), NDA_DST, dst, sizeof(*dst));

  if (hwa)
    addattr_l(n, sizeof(buf), NDA_LLADDR, hwa, hwalen);

  return rtnl_route_do(n, NULL);
}



int neigh_add(int ifindex, uint16_t state, uint8_t flags,
	      struct in6_addr *dst, uint8_t *hwa, int hwalen,
	      int override)
{
  return neigh_mod(NLM_F_CREATE | (override ? NLM_F_REPLACE : 0),
		   RTM_NEWNEIGH, ifindex, state, flags,dst, hwa, hwalen);
}

int neigh_del(int ifindex, struct in6_addr *dst)
{
  return neigh_mod(0, RTM_DELNEIGH, ifindex, 0, 0, dst, NULL, 0);
}

int pneigh_add(int ifindex, uint8_t flags, struct in6_addr *dst)
{
  return neigh_mod(NLM_F_CREATE | NLM_F_REPLACE, RTM_NEWNEIGH,
		   ifindex, NUD_PERMANENT, flags|NTF_PROXY, dst,
		   NULL, 0);
}

int pneigh_del(int ifindex, struct in6_addr *dst)
{
  return neigh_mod(0, RTM_DELNEIGH, ifindex, 0, NTF_PROXY, dst, NULL, 0);
}

/* Adapted from RFC 1071 "C" Implementation Example */
static uint16_t csum(const void *phdr, const void *data, socklen_t datalen)
{
  register unsigned long sum = 0;
  socklen_t count;
  uint16_t *addr;
  int i;

  /* caller must make sure datalen is even */

  addr = (uint16_t *)phdr;
  for (i = 0; i < 20; i++)
    sum += *addr++;

  count = datalen;
  addr = (uint16_t *)data;

  while (count > 1) {
    sum += *(addr++);
    count -= 2;
  }

  while (sum >> 16)
    sum = (sum & 0xffff) + (sum >> 16);

  return (uint16_t)~sum;
}



void *icmp6_create(struct iovec *iov, uint8_t type, uint8_t code)
{
  struct icmp6_hdr *hdr;
  int msglen;

  switch (type) {
  case ICMP6_DST_UNREACH:
  case ICMP6_PACKET_TOO_BIG:
  case ICMP6_TIME_EXCEEDED:
  case ICMP6_PARAM_PROB:
    msglen = sizeof(struct icmp6_hdr);
    break;
  case ND_ROUTER_SOLICIT:
    msglen = sizeof(struct nd_router_solicit);
    break;
  case ND_ROUTER_ADVERT:
    msglen = sizeof(struct nd_router_advert);
    break;
  case ND_NEIGHBOR_SOLICIT:
    msglen = sizeof(struct nd_neighbor_solicit);
    break;
  case ND_NEIGHBOR_ADVERT:
    msglen = sizeof(struct nd_neighbor_advert);
    break;
  case ND_REDIRECT:
    msglen = sizeof(struct nd_redirect);
    break;
  default:
    msglen = sizeof(struct icmp6_hdr);
  }
  hdr = malloc(msglen);
  if (hdr == NULL)
    return NULL;

  memset(hdr, 0, msglen);
  hdr->icmp6_type = type;
  hdr->icmp6_code = code;
  iov->iov_base = hdr;
  iov->iov_len = msglen;

  return hdr;
}



int icmp6_send(int oif, uint8_t hoplimit,
	       const struct in6_addr *src, const struct in6_addr *dst,
	       struct iovec *datav, size_t iovlen)
{
  struct sockaddr_in6 daddr;
  struct msghdr msg;
  struct cmsghdr *cmsg;
  struct in6_pktinfo pinfo;
  int cmsglen, ret = 0, on = 1, hops;

  hops = (hoplimit == 0) ? 64 : hoplimit;

  memset(&daddr, 0, sizeof(struct sockaddr_in6));
  daddr.sin6_family = AF_INET6;
  daddr.sin6_addr = *dst;
  daddr.sin6_port = htons(IPPROTO_ICMPV6);

  memset(&pinfo, 0, sizeof(pinfo));
  pinfo.ipi6_addr = *src;
  if (oif > 0)
    pinfo.ipi6_ifindex = oif;

  cmsglen = CMSG_SPACE(sizeof(pinfo));
  cmsg = malloc(cmsglen);
  if (cmsg == NULL) {
    dbg("out of memory\n");
    return -ENOMEM;
  }
  cmsg->cmsg_len = CMSG_LEN(sizeof(pinfo));
  cmsg->cmsg_level = IPPROTO_IPV6;
  cmsg->cmsg_type = IPV6_PKTINFO;
  memcpy(CMSG_DATA(cmsg), &pinfo, sizeof(pinfo));

  msg.msg_control = cmsg;
  msg.msg_controllen = cmsglen;
  msg.msg_iov = datav;
  msg.msg_iovlen = iovlen;
  msg.msg_name = (void *)&daddr;
  msg.msg_namelen = CMSG_SPACE(sizeof(struct in6_pktinfo));

  setsockopt(icmp6_sock.fd, IPPROTO_IPV6, IPV6_PKTINFO,
	     &on, sizeof(int));
  setsockopt(icmp6_sock.fd, IPPROTO_IPV6, IPV6_UNICAST_HOPS, 
	     &hops, sizeof(hops));
  setsockopt(icmp6_sock.fd, IPPROTO_IPV6, IPV6_MULTICAST_HOPS, 
	     &hops, sizeof(hops));

  ret = sendmsg(icmp6_sock.fd, &msg, 0);
  if (ret < 0)
    dbg("sendmsg: %s\n", strerror(errno));


  free(cmsg);

  return ret;
}



static int ndisc_send_unspec(int type, int oif, const struct in6_addr *dest) 
{
  struct _phdr {
    struct in6_addr src;
    struct in6_addr dst;
    uint32_t plen;
    uint8_t reserved[3];
    uint8_t nxt;
  } phdr;

  struct {
    struct ip6_hdr ip;
    union {
      struct icmp6_hdr icmp;
      struct nd_neighbor_solicit ns;
      struct nd_router_solicit rs;
    } i;
  } frame;

  struct msghdr msgh;
  struct cmsghdr *cmsg;
  struct in6_pktinfo *pinfo;
  struct sockaddr_in6 dst;
  char cbuf[CMSG_SPACE(sizeof(*pinfo))];
  struct iovec iov;
  int fd, datalen, ret, val = 1;

  fd = socket(AF_INET6, SOCK_RAW, IPPROTO_RAW);
  if (fd < 0) return -1;

  if (setsockopt(fd, IPPROTO_IPV6, IP_HDRINCL,
		 &val, sizeof(val)) < 0) {
    dbg("cannot set IP_HDRINCL: %s\n", strerror(errno));
    close(fd);
    return -errno;
  }

  memset(&frame, 0, sizeof(frame));
  memset(&dst, 0, sizeof(dst));

  if (type == ND_NEIGHBOR_SOLICIT) {
    datalen = sizeof(frame.i.ns); /* 24, csum() safe */
    frame.i.ns.nd_ns_target = *dest;
    ipv6_addr_solict_mult(dest, &dst.sin6_addr);
  } else if (type == ND_ROUTER_SOLICIT) {
    datalen = sizeof(frame.i.rs); /* 8, csum() safe */
    dst.sin6_addr = *dest;
  } else {
    close(fd);
    return -EINVAL;
  }

  /* Fill in the IPv6 header */
  frame.ip.ip6_vfc = 0x60;
  frame.ip.ip6_plen = htons(datalen);
  frame.ip.ip6_nxt = IPPROTO_ICMPV6;
  frame.ip.ip6_hlim = 255;
  frame.ip.ip6_dst = dst.sin6_addr;
  /* all other fields are already set to zero */

  /* Prepare pseudo header for csum */
  memset(&phdr, 0, sizeof(phdr));
  phdr.dst = dst.sin6_addr;
  phdr.plen = htonl(datalen);
  phdr.nxt = IPPROTO_ICMPV6;

  /* Fill in remaining ICMP header fields */
  frame.i.icmp.icmp6_type = type;
  frame.i.icmp.icmp6_cksum = csum(&phdr, &frame.i, datalen);

  iov.iov_base = &frame;
  iov.iov_len = sizeof(frame.ip) + datalen;

  dst.sin6_family = AF_INET6;
  msgh.msg_name = &dst;
  msgh.msg_namelen = sizeof(dst);
  msgh.msg_iov = &iov;
  msgh.msg_iovlen = 1;
  msgh.msg_flags = 0;

  memset(cbuf, 0, CMSG_SPACE(sizeof(*pinfo)));
  cmsg = (struct cmsghdr *)cbuf;
  pinfo = (struct in6_pktinfo *)CMSG_DATA(cmsg);
  pinfo->ipi6_ifindex = oif;

  cmsg->cmsg_len = CMSG_LEN(sizeof(*pinfo));
  cmsg->cmsg_level = IPPROTO_IPV6;
  cmsg->cmsg_type = IPV6_PKTINFO;
  msgh.msg_control = cmsg;
  msgh.msg_controllen = cmsg->cmsg_len;
  fprintf(stderr,"start sending ... \n");
  ret = sendmsg(fd, &msgh, 0);
  if (ret < 0)
    dbg("sendmsg: %s\n", strerror(errno));
  fprintf(stderr,"sending end. %d returned.\n",ret);
  close(fd);
  return ret;
}





static struct nd_opt_hdr *nd_opt_create(struct iovec *iov, uint8_t type,
					uint16_t len, uint8_t *value)
{
  struct nd_opt_hdr *opt;
  int hlen = sizeof(struct nd_opt_hdr);

  /* len must be lenght(value) in bytes */
  opt = malloc(len + hlen);
  if (opt == NULL)
    return NULL;

  opt->nd_opt_type = type;
  opt->nd_opt_len = (len + hlen) >> 3;
  memcpy(opt + 1, value, len);
  iov->iov_base = opt;
  iov->iov_len = len + hlen;

  return opt;
}
static inline short nd_get_l2addr_len(unsigned short iface_type)
{
  switch (iface_type) {
    /* supported physical devices */
  case ARPHRD_ETHER:
  case ARPHRD_IEEE802:
  case ARPHRD_IEEE802_TR:
  case ARPHRD_IEEE80211:
  case ARPHRD_FDDI:
    return 6;
  case ARPHRD_ARCNET:
    return 1;
    /* supported virtual devices */
  case ARPHRD_TUNNEL:
  case ARPHRD_SIT:
  case ARPHRD_TUNNEL6:
  case ARPHRD_PPP:
  case ARPHRD_IPGRE:
    return 0;
    return 1;
  default:
    /* unsupported */
    return -1;
  }
}


static int nd_get_l2addr(int ifindex, uint8_t *addr)
{
  struct ifreq ifr;
  int fd;
  int res;
 
  fd = socket(PF_PACKET, SOCK_DGRAM, 0);
  if (fd < 0) return -1;

  memset(&ifr, 0, sizeof(ifr));
  if_indextoname(ifindex, ifr.ifr_name);
  if (ioctl(fd, SIOCGIFHWADDR, &ifr) < 0) {
    perror("nd_get_l2addr(SIOCGIFHWADDR)");
    close(fd);
    return -1;
  }
  if ((res = nd_get_l2addr_len(ifr.ifr_hwaddr.sa_family)) < 0)
    dbg("Unsupported sa_family %d.\n", ifr.ifr_hwaddr.sa_family);
  else if (res > 0)
    memcpy(addr, ifr.ifr_hwaddr.sa_data, res);

  close(fd);
  return res;
}


int ndisc_send_ns(int ifindex, const struct in6_addr *src, 
		  const struct in6_addr *dst,
		  const struct in6_addr *target)
{
  struct nd_neighbor_solicit *ns;
  struct iovec iov[2];
  uint8_t l2addr[32];
  int len;
  int res;

  if (IN6_IS_ADDR_UNSPECIFIED(src))
    return ndisc_send_unspec(ND_NEIGHBOR_SOLICIT, ifindex, target);

  if ((len = nd_get_l2addr(ifindex, l2addr)) < 0)
    return -EINVAL;

  ns = icmp6_create(iov, ND_NEIGHBOR_SOLICIT, 0);

  if (ns == NULL) return -ENOMEM;

  ns->nd_ns_target = *target;

  if (len > 0 && nd_opt_create(&iov[1], ND_OPT_SOURCE_LINKADDR, 
			       len, l2addr) == NULL)
    return -ENOMEM;

  res = icmp6_send(ifindex, 255, src, dst, iov, 2);
  free_iov_data(iov, 2);

  return res;
}

int ndisc_send_rs(int ifindex, const struct in6_addr *src,
		  const struct in6_addr *dst)
{
  struct iovec iov[2];
  uint8_t l2addr[32];
  int len;
  int res;

  if (IN6_IS_ADDR_UNSPECIFIED(src))
    return ndisc_send_unspec(ND_ROUTER_SOLICIT, ifindex, dst);

  if ((len = nd_get_l2addr(ifindex, l2addr)) < 0)
    return -EINVAL;

  if (icmp6_create(iov, ND_ROUTER_SOLICIT, 0) == NULL)
    return -ENOMEM;

  if (len > 0 && nd_opt_create(&iov[1], ND_OPT_SOURCE_LINKADDR, 
			       len, l2addr) == NULL) {
    free_iov_data(iov, 1);
    return -ENOMEM;
  }
  res = icmp6_send(ifindex, 255, src, dst, iov, 2);
  free_iov_data(iov, 2);

  return res;
}

int ndisc_send_na(int ifindex, const struct in6_addr *src, 
		  const struct in6_addr *dst,
		  const struct in6_addr *target, uint32_t flags)
{
  struct nd_neighbor_advert *na;
  struct iovec iov[2];
  uint8_t l2addr[32];
  int len;

  memset(iov, 0, sizeof(iov));

  if ((len = nd_get_l2addr(ifindex, l2addr)) < 0)
    return -EINVAL;

  na = icmp6_create(iov, ND_NEIGHBOR_ADVERT, 0);

  if (na == NULL) return -ENOMEM;

  if (len > 0 && nd_opt_create(&iov[1], ND_OPT_TARGET_LINKADDR,
			       len, l2addr) == NULL) {
    free_iov_data(iov, 1);
    return -ENOMEM;
  }
  na->nd_na_target = *target;
  na->nd_na_flags_reserved = flags;

  icmp6_send(ifindex, 255, src, dst, iov, 2);
  free_iov_data(iov, 2);
  return 0;
}


int proxy_nd_start(int ifindex, struct in6_addr *target, 
		   struct in6_addr *src, int bu_flags)
{
  struct in6_addr lladdr;
  int err;
  int nd_flags = 0;

  err = pneigh_add(ifindex, nd_flags, target);

  if (!err && bu_flags & IP6_MH_BU_LLOCAL) {
    ipv6_addr_llocal(target, &lladdr);
    err = pneigh_add(ifindex, nd_flags, &lladdr);
    if (err)
      pneigh_del(ifindex, target);
  }
  if (!err) {
    uint32_t na_flags = ND_NA_FLAG_OVERRIDE;
    ndisc_send_na(ifindex, src, &in6addr_all_nodes_mc,
		  target, na_flags);

    if (bu_flags & IP6_MH_BU_LLOCAL)
      ndisc_send_na(ifindex, src, &in6addr_all_nodes_mc,
		    &lladdr, na_flags);
  }
  return err;
}

void proxy_nd_stop(int ifindex, struct in6_addr *target, int bu_flags)
{
  if (bu_flags & IP6_MH_BU_LLOCAL) {
    struct in6_addr lladdr;
    ipv6_addr_llocal(target, &lladdr);
    pneigh_del(ifindex, &lladdr);
    neigh_del(ifindex, &lladdr);
  }
  pneigh_del(ifindex, target);
  neigh_del(ifindex, target);
}



#endif


#define ICMP_NO_TEST 1
#ifndef ICMP_NO_TEST
#define ICMP_NO_TEST

int main()
{
  int ret = icmp6_init(1);
  if(ret < 0) perror("icmp6_init()");
  int n=100;
  while(n--){
    int ifindex = if_nametoindex("eth0");
    ret =ndisc_send_rs(ifindex, &in6addr_any,
		       &in6addr_all_routers_mc);
    if(ret<0)perror("ndisc_send_rs");
  }
  //pthread_join(icmp6_listener, NULL);
  
}
#endif
