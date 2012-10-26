#ifndef _LH_RTNL_H_
#define _LH_RTNL_H_ 1


#include <errno.h>
#include <time.h>
#include <syslog.h>
#include <netinet/in.h>
#include <netinet/icmp6.h>
#include <stdio.h>

//-----------------------data--structures------------------------
#include <asm/types.h>
#include <linux/netlink.h>
#include <linux/rtnetlink.h>
#include <linux/if_link.h>
#include <linux/if_addr.h>
#include <linux/neighbour.h>

struct rtnl_handle
{
  int fd;
  struct sockaddr_nl local;
  struct sockaddr_nl peer;
  __u32 seq;
  __u32 dump;
};

typedef int (*rtnl_filter_t)(const struct sockaddr_nl *,
			     struct nlmsghdr *n, void *);
//----------------------------interfaces-------------------------
int addr_del(const struct in6_addr *addr, uint8_t plen, int ifindex);
int addr4_del(const struct in_addr *addr, uint8_t plen4, int ifindex);

int addr_add(const struct in6_addr *addr, uint8_t plen, 
	     uint8_t flags, uint8_t scope, int ifindex, 
	     uint32_t prefered, uint32_t valid);
int addr4_add(const struct in_addr *addr, uint8_t plen4, int ifindex);

int route_add(int oif, uint8_t table, uint8_t proto,
	      unsigned flags, uint32_t metric,
	      const struct in6_addr *src, int src_plen,
	      const struct in6_addr *dst, int dst_plen, 
	      const struct in6_addr *gateway);

int route_del(int oif, uint8_t table, uint32_t metric,
	      const struct in6_addr *src, int src_plen,
	      const struct in6_addr *dst, int dst_plen, 
	      const struct in6_addr *gateway);


int route4_add(int oif, uint8_t table, unsigned flags,
	       const struct in_addr *src, int src_plen,
	       const struct in_addr *dst, int dst_plen,
	       const struct in_addr *gateway);

int route4_del(int oif, uint8_t table,
	       const struct in_addr *src, int src_plen,
	       const struct in_addr *dst, int dst_plen,
	       const struct in_addr *gateway);

int rule_add(const char *iface, uint8_t table,
	     uint32_t priority, uint8_t action,
	     const struct in6_addr *src, int src_plen,
	     const struct in6_addr *dst, int dst_plen, int flags);

int rule_del(const char *iface, uint8_t table,
	     uint32_t priority, uint8_t action,
	     const struct in6_addr *src, int src_plen,
	     const struct in6_addr *dst, int dst_plen,int flags);

int rule4_add(const char *iface, uint8_t table,
	      uint32_t priority, uint8_t action,
	      const struct in_addr *src, int src_plen,
	      const struct in_addr *dst, int dst_plen, int flags);


int rule4_del(const char *iface, uint8_t table,
	      uint32_t priority,  uint8_t action,
	      const struct in_addr *src, int src_plen,
	      const struct in_addr *dst, int dst_plen, int flags);

int rtnl_listen(struct rtnl_handle *rtnl,
		rtnl_filter_t handler,
		void *jarg);


//----------------------------libnetlink-------------------------
#define parse_rtattr_nested(tb, max, rta) \
  (parse_rtattr((tb), (max), RTA_DATA(rta), RTA_PAYLOAD(rta)))

#define NLMSG_TAIL(nmsg) \
  ((struct rtattr *) (((void *) (nmsg)) + NLMSG_ALIGN((nmsg)->nlmsg_len)))

#ifndef IFA_RTA
#define IFA_RTA(r) \
  ((struct rtattr*)(((char*)(r)) + NLMSG_ALIGN(sizeof(struct ifaddrmsg))))
#endif
#ifndef IFA_PAYLOAD
#define IFA_PAYLOAD(n)NLMSG_PAYLOAD(n,sizeof(struct ifaddrmsg))
#endif

#ifndef IFLA_RTA
#define IFLA_RTA(r) \
  ((struct rtattr*)(((char*)(r)) + NLMSG_ALIGN(sizeof(struct ifinfomsg))))
#endif
#ifndef IFLA_PAYLOAD
#define IFLA_PAYLOAD(n)NLMSG_PAYLOAD(n,sizeof(struct ifinfomsg))
#endif

#ifndef NDA_RTA
#define NDA_RTA(r) \
  ((struct rtattr*)(((char*)(r)) + NLMSG_ALIGN(sizeof(struct ndmsg))))
#endif
#ifndef NDA_PAYLOAD
#define NDA_PAYLOAD(n)NLMSG_PAYLOAD(n,sizeof(struct ndmsg))
#endif

#ifndef NDTA_RTA
#define NDTA_RTA(r) \
  ((struct rtattr*)(((char*)(r)) + NLMSG_ALIGN(sizeof(struct ndtmsg))))
#endif
#ifndef NDTA_PAYLOAD
#define NDTA_PAYLOAD(n) NLMSG_PAYLOAD(n,sizeof(struct ndtmsg))
#endif


#ifndef SOL_NETLINK
#define SOL_NETLINK 270
#endif


#define SO_SNDBUF_SIZE 32768
#define SO_RCVBUF_SIZE 32768
#define NL_DUMP_SIZE 16384
#define NL_TALK_SIZE 16384
#define NL_LISTEN_SIZE 8192

#define NLDBG(format, arg...) fprintf(stderr, format, ##arg)
#define NLDBG_SYS(message) perror(message)

#define RTDBG(format, arg...) fprintf(stderr, format, ##arg)

//#define NLDBG(format, arg...)
//#define NLDBG_SYS(message)
void rtnl_close(struct rtnl_handle *rth)
{
  if (rth->fd >= 0) {
    close(rth->fd);
    rth->fd = -1;
  }
}

int rtnl_open_byproto(struct rtnl_handle *rth, unsigned subscriptions,
		      int protocol)
{
  socklen_t addr_len;
  int sndbuf = SO_SNDBUF_SIZE;
  int rcvbuf = SO_RCVBUF_SIZE;
  
  memset(rth, 0, sizeof(rth));
  
  rth->fd = socket(AF_NETLINK, SOCK_RAW, protocol);
  if (rth->fd < 0) {
    NLDBG_SYS("Cannot open netlink socket");
    return -1;
  }
  
  if (setsockopt(rth->fd,SOL_SOCKET,SO_SNDBUF,&sndbuf,sizeof(sndbuf)) < 0) {
    NLDBG_SYS("SO_SNDBUF");
    return -1;
  }
  
  if (setsockopt(rth->fd,SOL_SOCKET,SO_RCVBUF,&rcvbuf,sizeof(rcvbuf)) < 0) {
    NLDBG_SYS("SO_RCVBUF");
    return -1;
  }
  
  memset(&rth->local, 0, sizeof(rth->local));
  rth->local.nl_family = AF_NETLINK;
  rth->local.nl_groups = subscriptions;
  
  if (bind(rth->fd, (struct sockaddr*)&rth->local, sizeof(rth->local)) < 0) {
    NLDBG_SYS("Cannot bind netlink socket");
    return -1;
  }
  addr_len = sizeof(rth->local);
  if (getsockname(rth->fd, (struct sockaddr*)&rth->local, &addr_len) < 0) {
    NLDBG_SYS("Cannot getsockname");
    return -1;
  }
  if (addr_len != sizeof(rth->local)) {
    NLDBG("Wrong address length %d\n", addr_len);
    return -1;
  }
  if (rth->local.nl_family != AF_NETLINK) {
    NLDBG("Wrong address family %d\n", rth->local.nl_family);
    return -1;
  }
  rth->seq = time(NULL);
  return 0;
}

int rtnl_open(struct rtnl_handle *rth, unsigned subscriptions)
{
	return rtnl_open_byproto(rth, subscriptions, NETLINK_ROUTE);
}

int rtnl_wilddump_request(struct rtnl_handle *rth, int family, int type)
{
	struct {
		struct nlmsghdr nlh;
		struct rtgenmsg g;
	} req;
	struct sockaddr_nl nladdr;

	memset(&nladdr, 0, sizeof(nladdr));
	nladdr.nl_family = AF_NETLINK;

	memset(&req, 0, sizeof(req));
	req.nlh.nlmsg_len = sizeof(req);
	req.nlh.nlmsg_type = type;
	req.nlh.nlmsg_flags = NLM_F_ROOT|NLM_F_MATCH|NLM_F_REQUEST;
	req.nlh.nlmsg_pid = 0;
	req.nlh.nlmsg_seq = rth->dump = ++rth->seq;
	req.g.rtgen_family = family;

	return sendto(rth->fd, (void*)&req, sizeof(req), 0,
		      (struct sockaddr*)&nladdr, sizeof(nladdr));
}

int rtnl_dump_request(struct rtnl_handle *rth, int type, void *req, int len)
{
	struct nlmsghdr nlh;
	struct sockaddr_nl nladdr;
	struct iovec iov[2] = {
		{ .iov_base = &nlh, .iov_len = sizeof(nlh) },
		{ .iov_base = req, .iov_len = len }
	};
	struct msghdr msg = {
		.msg_name = &nladdr,
		.msg_namelen = 	sizeof(nladdr),
		.msg_iov = iov,
		.msg_iovlen = 2,
	};

	memset(&nladdr, 0, sizeof(nladdr));
	nladdr.nl_family = AF_NETLINK;

	nlh.nlmsg_len = NLMSG_LENGTH(len);
	nlh.nlmsg_type = type;
	nlh.nlmsg_flags = NLM_F_ROOT|NLM_F_MATCH|NLM_F_REQUEST;
	nlh.nlmsg_pid = 0;
	nlh.nlmsg_seq = rth->dump = ++rth->seq;

	return sendmsg(rth->fd, &msg, 0);
}

int rtnl_dump_filter(struct rtnl_handle *rth,
		     rtnl_filter_t filter,
		     void *arg1,
		     rtnl_filter_t junk,
		     void *arg2)
{
	struct sockaddr_nl nladdr;
	struct iovec iov;
	struct msghdr msg = {
		.msg_name = &nladdr,
		.msg_namelen = sizeof(nladdr),
		.msg_iov = &iov,
		.msg_iovlen = 1,
	};
	char buf[NL_DUMP_SIZE];

	iov.iov_base = buf;
	while (1) {
		int status;
		struct nlmsghdr *h;

		iov.iov_len = sizeof(buf);
		status = recvmsg(rth->fd, &msg, 0);

		if (status < 0) {
			if (errno == EINTR)
				continue;
			NLDBG_SYS("OVERRUN");
			continue;
		}

		if (status == 0) {
			NLDBG("EOF on netlink\n");
			return -1;
		}

		h = (struct nlmsghdr*)buf;
		while (NLMSG_OK(h, status)) {
			int err;

			if (nladdr.nl_pid != 0 ||
			    h->nlmsg_pid != rth->local.nl_pid ||
			    h->nlmsg_seq != rth->dump) {
				if (junk) {
					err = junk(&nladdr, h, arg2);
					if (err < 0)
						return err;
				}
				goto skip_it;
			}

			if (h->nlmsg_type == NLMSG_DONE)
				return 0;
			if (h->nlmsg_type == NLMSG_ERROR) {
				struct nlmsgerr *err = (struct nlmsgerr*)NLMSG_DATA(h);
				if (h->nlmsg_len < NLMSG_LENGTH(sizeof(struct nlmsgerr))) {
					NLDBG("ERROR truncated\n");
				} else {
					errno = -err->error;
					NLDBG_SYS("RTNETLINK answers");
				}
				return -1;
			}
			err = filter(&nladdr, h, arg1);
			if (err < 0)
				return err;

skip_it:
			h = NLMSG_NEXT(h, status);
		}
		if (msg.msg_flags & MSG_TRUNC) {
			NLDBG("Message truncated\n");
			continue;
		}
		if (status) {
			NLDBG("!!!Remnant of size %d\n", status);
			return -2;
		}
	}
}

int rtnl_talk(struct rtnl_handle *rtnl, struct nlmsghdr *n, pid_t peer,
	      unsigned groups, struct nlmsghdr *answer,
	      rtnl_filter_t junk,
	      void *jarg)
{
	int status;
	unsigned seq;
	struct nlmsghdr *h;
	struct sockaddr_nl nladdr;
	struct iovec iov = {
		.iov_base = (void*) n,
		.iov_len = n->nlmsg_len
	};
	struct msghdr msg = {
		.msg_name = &nladdr,
		.msg_namelen = sizeof(nladdr),
		.msg_iov = &iov,
		.msg_iovlen = 1,
	};
	char   buf[NL_TALK_SIZE];

	memset(&nladdr, 0, sizeof(nladdr));
	nladdr.nl_family = AF_NETLINK;
	nladdr.nl_pid = peer;
	nladdr.nl_groups = groups;

	n->nlmsg_seq = seq = ++rtnl->seq;

	if (answer == NULL)
		n->nlmsg_flags |= NLM_F_ACK;

	status = sendmsg(rtnl->fd, &msg, 0);

	if (status < 0) {
		NLDBG_SYS("Cannot talk to rtnetlink");
		return -1;
	}

	memset(buf,0,sizeof(buf));

	iov.iov_base = buf;

	while (1) {
		iov.iov_len = sizeof(buf);
		status = recvmsg(rtnl->fd, &msg, 0);

		if (status < 0) {
			if (errno == EINTR)
				continue;
			NLDBG_SYS("OVERRUN");
			continue;
		}
		if (status == 0) {
			NLDBG("EOF on netlink\n");
			return -1;
		}
		if (msg.msg_namelen != sizeof(nladdr)) {
			NLDBG("sender address length == %d\n", msg.msg_namelen);
			return -2;
		}
		for (h = (struct nlmsghdr*)buf; status >= sizeof(*h); ) {
			int err;
			int len = h->nlmsg_len;
			int l = len - sizeof(*h);

			if (l<0 || len>status) {
				if (msg.msg_flags & MSG_TRUNC) {
					NLDBG("Truncated message\n");
					return -1;
				}
				NLDBG("!!!malformed message: len=%d\n", len);
				return -2;
			}

			if (nladdr.nl_pid != peer ||
			    h->nlmsg_pid != rtnl->local.nl_pid ||
			    h->nlmsg_seq != seq) {
				if (junk) {
					err = junk(&nladdr, h, jarg);
					if (err < 0)
						return err;
				}
				/* Don't forget to skip that message. */
				status -= NLMSG_ALIGN(len);
				h = (struct nlmsghdr*)((char*)h + NLMSG_ALIGN(len));
				continue;
			}

			if (h->nlmsg_type == NLMSG_ERROR) {
				struct nlmsgerr *err = (struct nlmsgerr*)NLMSG_DATA(h);
				if (l < sizeof(struct nlmsgerr)) {
					NLDBG("ERROR truncated\n");
				} else {
					errno = -err->error;
					if (errno == 0) {
						if (answer)
							memcpy(answer, h, h->nlmsg_len);
						return 0;
					}
					NLDBG_SYS("RTNETLINK answers");
				}
				return -1;
			}
			if (answer) {
				memcpy(answer, h, h->nlmsg_len);
				return 0;
			}

			NLDBG("Unexpected reply!!!\n");

			status -= NLMSG_ALIGN(len);
			h = (struct nlmsghdr*)((char*)h + NLMSG_ALIGN(len));
		}
		if (msg.msg_flags & MSG_TRUNC) {
			NLDBG("Message truncated\n");
			continue;
		}
		if (status) {
			NLDBG("!!!Remnant of size %d\n", status);
			return -2;
		}
	}
}

int rtnl_listen(struct rtnl_handle *rtnl,
		rtnl_filter_t handler,
		void *jarg)
{
  int status;
  struct nlmsghdr *h;
  struct sockaddr_nl nladdr;
  struct iovec iov;
  struct msghdr msg = {
    .msg_name = &nladdr,
    .msg_namelen = sizeof(nladdr),
    .msg_iov = &iov,
    .msg_iovlen = 1,
  };
  char   buf[NL_LISTEN_SIZE];
  
  memset(&nladdr, 0, sizeof(nladdr));
  nladdr.nl_family = AF_NETLINK;
  nladdr.nl_pid = 0;
  nladdr.nl_groups = 0;
  
  iov.iov_base = buf;
  iov.iov_len = sizeof(buf);
  status = recvmsg(rtnl->fd, &msg, 0);
  
  if (status >0){
    if (msg.msg_namelen != sizeof(nladdr)) {
      NLDBG("Sender address length == %d\n", msg.msg_namelen);
      return -2;
    }
    for (h = (struct nlmsghdr*)buf; status >= sizeof(*h); ) {
      int err;
      int len = h->nlmsg_len;
      int l = len - sizeof(*h);
      
      if (l<0 || len>status) {
	if (msg.msg_flags & MSG_TRUNC) {
	  NLDBG("Truncated message\n");
	  return -1;
	}
	NLDBG("!!!malformed message: len=%d\n", len);
	return -2;
      }
	    
      err = handler(&nladdr, h, jarg);
      if (err < 0)
	return err;
	    
      status -= NLMSG_ALIGN(len);
      h = (struct nlmsghdr*)((char*)h + NLMSG_ALIGN(len));
    }
    if (msg.msg_flags & MSG_TRUNC) {
      NLDBG("Message truncated\n");
      return 0;
    }
    if (status) {
      NLDBG("!!!Remnant of size %d\n", status);
      return -2;
    }
    return 0;
  }
  return -1;
}

static inline int addattr32(struct nlmsghdr *n, int maxlen, int type, __u32 data)
{
	int len = RTA_LENGTH(4);
	struct rtattr *rta;
	if (NLMSG_ALIGN(n->nlmsg_len) + len > maxlen) {
		NLDBG("addattr32: Error! max allowed bound %d exceeded\n",maxlen);
		return -1;
	}
	rta = NLMSG_TAIL(n);
	rta->rta_type = type;
	rta->rta_len = len;
	memcpy(RTA_DATA(rta), &data, 4);
	n->nlmsg_len = NLMSG_ALIGN(n->nlmsg_len) + len;
	return 0;
}

static inline int addattr_l(struct nlmsghdr *n, int maxlen, int type, const void *data,
	      int alen)
{
	int len = RTA_LENGTH(alen);
	struct rtattr *rta;

	if (NLMSG_ALIGN(n->nlmsg_len) + RTA_ALIGN(len) > maxlen) {
		NLDBG("addattr_l ERROR: message exceeded bound of %d\n",maxlen);
		return -1;
	}
	rta = NLMSG_TAIL(n);
	rta->rta_type = type;
	rta->rta_len = len;
	memcpy(RTA_DATA(rta), data, alen);
	n->nlmsg_len = NLMSG_ALIGN(n->nlmsg_len) + RTA_ALIGN(len);
	return 0;
}

static inline int addraw_l(struct nlmsghdr *n, int maxlen, const void *data, int len)
{
	if (NLMSG_ALIGN(n->nlmsg_len) + NLMSG_ALIGN(len) > maxlen) {
		NLDBG("addraw_l ERROR: message exceeded bound of %d\n",maxlen);
		return -1;
	}

	memcpy(NLMSG_TAIL(n), data, len);
	memset((void *) NLMSG_TAIL(n) + len, 0, NLMSG_ALIGN(len) - len);
	n->nlmsg_len = NLMSG_ALIGN(n->nlmsg_len) + NLMSG_ALIGN(len);
	return 0;
}

static inline int rta_addattr32(struct rtattr *rta, int maxlen, int type, __u32 data)
{
	int len = RTA_LENGTH(4);
	struct rtattr *subrta;

	if (RTA_ALIGN(rta->rta_len) + len > maxlen) {
		NLDBG("rta_addattr32: Error! max allowed bound %d exceeded\n",maxlen);
		return -1;
	}
	subrta = (struct rtattr*)(((char*)rta) + RTA_ALIGN(rta->rta_len));
	subrta->rta_type = type;
	subrta->rta_len = len;
	memcpy(RTA_DATA(subrta), &data, 4);
	rta->rta_len = NLMSG_ALIGN(rta->rta_len) + len;
	return 0;
}

static inline int rta_addattr_l(struct rtattr *rta, int maxlen, int type,
		  const void *data, int alen)
{
	struct rtattr *subrta;
	int len = RTA_LENGTH(alen);

	if (RTA_ALIGN(rta->rta_len) + RTA_ALIGN(len) > maxlen) {
		NLDBG("rta_addattr_l: Error! max allowed bound %d exceeded\n",maxlen);
		return -1;
	}
	subrta = (struct rtattr*)(((char*)rta) + RTA_ALIGN(rta->rta_len));
	subrta->rta_type = type;
	subrta->rta_len = len;
	memcpy(RTA_DATA(subrta), data, alen);
	rta->rta_len = NLMSG_ALIGN(rta->rta_len) + RTA_ALIGN(len);
	return 0;
}

static inline int parse_rtattr(struct rtattr *tb[], int max, struct rtattr *rta, int len)
{
	memset(tb, 0, sizeof(struct rtattr *) * (max + 1));
	while (RTA_OK(rta, len)) {
		if (rta->rta_type <= max)
			tb[rta->rta_type] = rta;
		rta = RTA_NEXT(rta,len);
	}
	if (len)
		NLDBG("!!!Deficit %d, rta_len=%d\n", len, rta->rta_len);
	return 0;
}

static inline int parse_rtattr_byindex(struct rtattr *tb[], int max, struct rtattr *rta, int len)
{
	int i = 0;

	memset(tb, 0, sizeof(struct rtattr *) * max);
	while (RTA_OK(rta, len)) {
		if (rta->rta_type <= max && i < max)
			tb[i++] = rta;
		rta = RTA_NEXT(rta,len);
	}
	if (len)
		NLDBG("!!!Deficit %d, rta_len=%d\n", len, rta->rta_len);
	return i;
}

//------------------------------------------------

static inline int rtnl_route_open(struct rtnl_handle *rth, 
				  unsigned subscriptions)
{
  return rtnl_open_byproto(rth, subscriptions, NETLINK_ROUTE);
}

static inline int rtnl_xfrm_open(struct rtnl_handle *rth,
				 unsigned subscriptions)
{
  return rtnl_open_byproto(rth, subscriptions, NETLINK_XFRM);
}


static inline int rtnl_do(int proto, struct nlmsghdr *sn, struct nlmsghdr *rn)
{
  struct rtnl_handle rth;
  int err;
  if (rtnl_open_byproto(&rth, 0, proto) < 0) {
    fprintf(stderr,"rtnl: rtnl_open_byproto failed\n");
    return -1;
  }
  err = rtnl_talk(&rth, sn, 0, 0, rn, NULL, NULL);
  rtnl_close(&rth);
  return err;
}

static inline int rtnl_route_do(struct nlmsghdr *sn, struct nlmsghdr *rn)
{
  return rtnl_do(NETLINK_ROUTE, sn, rn);
}

static inline int rtnl_xfrm_do(struct nlmsghdr *sn, struct nlmsghdr *rn)
{
  return rtnl_do(NETLINK_XFRM, sn, rn);
}

int addr_do(const struct in6_addr *addr, int plen, int ifindex, void *arg,
	    int (*do_callback)(struct ifaddrmsg *ifa, 
			       struct rtattr *rta_tb[], 
			       void *arg))
{
  uint8_t sbuf[256];
  uint8_t rbuf[256];
  struct nlmsghdr *sn, *rn;
  struct ifaddrmsg *ifa;
  int err;
  struct rtattr *rta_tb[IFA_MAX+1];
  struct rtattr *rta;

  memset(sbuf, 0, sizeof(sbuf));
  sn = (struct nlmsghdr *)sbuf;
  sn->nlmsg_len = NLMSG_LENGTH(sizeof(struct ifaddrmsg));
  sn->nlmsg_flags = NLM_F_REQUEST;
  sn->nlmsg_type = RTM_GETADDR;

  ifa = NLMSG_DATA(sn);
  ifa->ifa_family = AF_INET6;
  ifa->ifa_prefixlen = plen;
  ifa->ifa_scope = RT_SCOPE_UNIVERSE;
  ifa->ifa_index = ifindex;

  addattr_l(sn, sizeof(sbuf), IFA_LOCAL, addr, sizeof(*addr));

  memset(rbuf, 0, sizeof(rbuf));
  rn = (struct nlmsghdr *)rbuf;
  err = rtnl_route_do(sn, rn);
  if (err < 0) {
    rn = sn;
    ifa = NLMSG_DATA(rn);
  } else {
    ifa = NLMSG_DATA(rn);
    
    if (rn->nlmsg_type != RTM_NEWADDR || 
	rn->nlmsg_len < NLMSG_LENGTH(sizeof(*ifa)) ||
	ifa->ifa_family != AF_INET6) {
      return -EINVAL;
    }
  }
  memset(rta_tb, 0, sizeof(rta_tb));
  parse_rtattr(rta_tb, IFA_MAX, IFA_RTA(ifa), 
	       rn->nlmsg_len - NLMSG_LENGTH(sizeof(*ifa)));

  if (!rta_tb[IFA_ADDRESS])
    rta_tb[IFA_ADDRESS] = rta_tb[IFA_LOCAL];

  if (!rta_tb[IFA_ADDRESS] ||
      !IN6_ARE_ADDR_EQUAL((struct in6_addr *)RTA_DATA(rta_tb[IFA_ADDRESS]), addr)) {
    return -EINVAL;
  }
  if (do_callback)
    err = do_callback(ifa, rta_tb, arg);

  return err;
}

int addr4_do(const struct in_addr *addr4, int plen4, int ifindex, void *arg,
	     int (*do_callback)(struct ifaddrmsg *ifa, void *arg))
{
  uint8_t sbuf[256];
  uint8_t rbuf[256];
  struct nlmsghdr *sn, *rn;
  struct ifaddrmsg *ifa;
  int err;

  memset(sbuf, 0, sizeof(sbuf));
  sn = (struct nlmsghdr *)sbuf;
  sn->nlmsg_len = NLMSG_LENGTH(sizeof(struct ifaddrmsg));
  sn->nlmsg_flags = NLM_F_REQUEST;
  sn->nlmsg_type = RTM_GETADDR;

  ifa = NLMSG_DATA(sn);
  ifa->ifa_family = AF_INET;
  ifa->ifa_prefixlen = plen4;
  ifa->ifa_scope = RT_SCOPE_UNIVERSE;
  ifa->ifa_index = ifindex;

  addattr_l(sn, sizeof(sbuf), IFA_LOCAL, addr4, sizeof(*addr4));

  memset(rbuf, 0, sizeof(rbuf));
  rn = (struct nlmsghdr *)rbuf;
  err = rtnl_route_do(sn, rn);
  if (err < 0) {
    rn = sn;
    ifa = NLMSG_DATA(rn);
  } else {
    ifa = NLMSG_DATA(rn);
  }
  if (do_callback)
    err = do_callback(ifa, arg);
  return err;
}

static int addr_mod(int cmd, uint16_t nlmsg_flags,
		    const struct in6_addr *addr, uint8_t plen, 
		    uint8_t flags, uint8_t scope, int ifindex, 
		    uint32_t prefered, uint32_t valid)
        
{
  uint8_t buf[256];
  struct nlmsghdr *n;
  struct ifaddrmsg *ifa;

  memset(buf, 0, sizeof(buf));
  n = (struct nlmsghdr *)buf;
  n->nlmsg_len = NLMSG_LENGTH(sizeof(struct ifaddrmsg));
  n->nlmsg_flags = NLM_F_REQUEST | nlmsg_flags;
  n->nlmsg_type = cmd;

  ifa = NLMSG_DATA(n);
  ifa->ifa_family = AF_INET6;
  ifa->ifa_prefixlen = plen;
  ifa->ifa_flags = flags;
  ifa->ifa_scope = scope;
  ifa->ifa_index = ifindex;

  addattr_l(n, sizeof(buf), IFA_LOCAL, addr, sizeof(*addr));

  if (prefered || valid) {
    struct ifa_cacheinfo ci;
    ci.ifa_prefered = prefered;
    ci.ifa_valid = valid;
    ci.cstamp = 0;
    ci.tstamp = 0;
    addattr_l(n, sizeof(buf), IFA_CACHEINFO, &ci, sizeof(ci));
  }
  return rtnl_route_do(n, NULL);
}

static int addr4_mod(const struct in_addr *addr, int plen4, int ifindex, int cmd)
{
  struct rtnl_handle rth;
  struct {
    struct nlmsghdr n;
    struct ifaddrmsg ifa;
    char buf[256];
  } req;
  struct list_head *list;

  memset(&req, 0, sizeof(req));
  req.n.nlmsg_len = NLMSG_LENGTH(sizeof(struct ifaddrmsg));
  req.n.nlmsg_flags = NLM_F_REQUEST;
  req.n.nlmsg_type = cmd;
  req.ifa.ifa_family = AF_INET;
  req.ifa.ifa_prefixlen = plen4;
  req.ifa.ifa_index = ifindex;
  addattr_l(&req.n, sizeof(req), IFA_LOCAL, addr, sizeof(struct in_addr));

  if (rtnl_open(&rth, 0) != 0)
    return -1;

  if (rtnl_talk(&rth, &req.n, 0, 0, NULL, NULL, NULL) < 0) {
    fprintf(stderr,"Failed to modify address");
    close(rth.fd);
    return -1;
  }

  close(rth.fd);
  return 0;
}

int addr_add(const struct in6_addr *addr, uint8_t plen, 
	     uint8_t flags, uint8_t scope, int ifindex, 
	     uint32_t prefered, uint32_t valid)
{
  return addr_mod(RTM_NEWADDR, NLM_F_CREATE|NLM_F_REPLACE,
		  addr, plen, flags, scope, ifindex, prefered, valid);
}


int addr_del(const struct in6_addr *addr, uint8_t plen, int ifindex)
{
  return addr_mod(RTM_DELADDR, 0, addr, plen, 0, 0, ifindex, 0, 0);
}

int addr4_add(const struct in_addr *addr, uint8_t plen4, int ifindex)
{
  return addr4_mod(addr, plen4, ifindex, RTM_NEWADDR);
}

int addr4_del(const struct in_addr *addr, uint8_t plen4, int ifindex)
{
  return addr4_mod(addr, plen4, ifindex, RTM_DELADDR);
}

static int route_mod(int cmd, int oif, uint8_t table, uint8_t proto,
		     unsigned flags, uint32_t priority,
		     const struct in6_addr *src, int src_plen,
		     const struct in6_addr *dst, int dst_plen,
		     const struct in6_addr *gateway)
{
  uint8_t buf[512];
  struct nlmsghdr *n;
  struct rtmsg *rtm;

  if (cmd == RTM_NEWROUTE && oif == 0)
    return -1;

  memset(buf, 0, sizeof(buf));
  n = (struct nlmsghdr *)buf;
  
  n->nlmsg_len = NLMSG_LENGTH(sizeof(struct rtmsg));
  n->nlmsg_flags = NLM_F_REQUEST;
  if (cmd == RTM_NEWROUTE) {
    n->nlmsg_flags |= NLM_F_CREATE|NLM_F_EXCL;
  }
  n->nlmsg_type = cmd;

  rtm = NLMSG_DATA(n);
  rtm->rtm_family = AF_INET6;
  rtm->rtm_dst_len = dst_plen;
  rtm->rtm_src_len = src_plen;
  rtm->rtm_table = table;
  rtm->rtm_protocol = proto;
  rtm->rtm_scope = RT_SCOPE_UNIVERSE;
  rtm->rtm_type = RTN_UNICAST;
  rtm->rtm_flags = flags;

  addattr_l(n, sizeof(buf), RTA_DST, dst, sizeof(*dst));
  if (src)
    addattr_l(n, sizeof(buf), RTA_SRC, src, sizeof(*src));
  addattr32(n, sizeof(buf), RTA_OIF, oif);
  if (gateway)
    addattr_l(n, sizeof(buf), 
	      RTA_GATEWAY, gateway, sizeof(*gateway));
  if (priority)
    addattr32(n, sizeof(buf), RTA_PRIORITY, priority);
  return rtnl_route_do(n, NULL);
}

int route_add(int oif, uint8_t table, uint8_t proto,
	      unsigned flags, uint32_t metric, 
	      const struct in6_addr *src, int src_plen,
	      const struct in6_addr *dst, int dst_plen, 
	      const struct in6_addr *gateway)
{
  return route_mod(RTM_NEWROUTE, oif, table, proto, flags,
		   metric, src, src_plen, dst, dst_plen, gateway);
}

int route_del(int oif, uint8_t table, uint32_t metric, 
	      const struct in6_addr *src, int src_plen,
	      const struct in6_addr *dst, int dst_plen,
	      const struct in6_addr *gateway)
{
  return route_mod(RTM_DELROUTE, oif, table, RTPROT_UNSPEC, 
		   0, metric, src, src_plen, dst, dst_plen, gateway);
}

static int rule_mod(const char *iface, int cmd, uint8_t table,
		    uint32_t priority, uint8_t action,
		    const struct in6_addr *src, int src_plen,
		    const struct in6_addr *dst, int dst_plen, int flags)
{
  uint8_t buf[512];
  struct nlmsghdr *n;
  struct rtmsg *rtm;

  memset(buf, 0, sizeof(buf));
  n = (struct nlmsghdr *)buf;
  
  n->nlmsg_len = NLMSG_LENGTH(sizeof(struct rtmsg));
  n->nlmsg_flags = NLM_F_REQUEST;
  if (cmd == RTM_NEWRULE) {
    n->nlmsg_flags |= NLM_F_CREATE;
  }
  n->nlmsg_type = cmd;

  rtm = NLMSG_DATA(n);
  rtm->rtm_family = AF_INET6;
  rtm->rtm_dst_len = dst_plen;
  rtm->rtm_src_len = src_plen;
  rtm->rtm_table = table;
  rtm->rtm_scope = RT_SCOPE_UNIVERSE;
  rtm->rtm_type = action;
  rtm->rtm_flags = flags;

  addattr_l(n, sizeof(buf), RTA_DST, dst, sizeof(*dst));
  if (src)
    addattr_l(n, sizeof(buf), RTA_SRC, src, sizeof(*src));
  if (priority)
    addattr32(n, sizeof(buf), RTA_PRIORITY, priority);
  if (iface)
    addattr_l(n, sizeof(buf), RTA_IIF, iface, strlen(iface) + 1);

  return rtnl_route_do(n, NULL);
}

int rule_add(const char *iface, uint8_t table,
	     uint32_t priority, uint8_t action,
	     const struct in6_addr *src, int src_plen,
	     const struct in6_addr *dst, int dst_plen, int flags)
{
  return rule_mod(iface, RTM_NEWRULE, table,
		  priority, action,
		  src, src_plen, dst, dst_plen, flags);
}
int rule_del(const char *iface, uint8_t table,
	     uint32_t priority, uint8_t action,
	     const struct in6_addr *src, int src_plen,
	     const struct in6_addr *dst, int dst_plen, int flags)
{
  return rule_mod(iface, RTM_DELRULE, table,
		  priority, action,
		  src, src_plen, dst, dst_plen, flags);
}

static int change_iprule(int cmd, int type, const struct in_addr *src, 
			 int src_plen,
			 const struct in_addr *dst, int dst_plen, int table,
			 const char *device, int prio, int flags)
{
  struct rtnl_handle rth;
  struct {
    struct nlmsghdr n;
    struct rtmsg r;
    char buf[1024];
  } req;

  memset(&req, 0, sizeof(req));

  req.n.nlmsg_type = cmd;
  req.n.nlmsg_len = NLMSG_LENGTH(sizeof(struct rtmsg));
  req.n.nlmsg_flags = NLM_F_REQUEST;
  req.r.rtm_family = AF_INET;
  req.r.rtm_protocol = RTPROT_BOOT;
  req.r.rtm_scope = RT_SCOPE_UNIVERSE;
  req.r.rtm_table = 0;
  req.r.rtm_type = type;
  req.r.rtm_flags = flags;

  if (cmd == RTM_NEWRULE) {
    req.n.nlmsg_flags |= NLM_F_CREATE | NLM_F_EXCL;
  }

  if (src != NULL) {
    req.r.rtm_src_len = src_plen; /* bits */
    addattr_l(&req.n, sizeof(req), RTA_SRC, (void *) src,
	      sizeof(struct in_addr));
  }

  if (dst != NULL) {
    req.r.rtm_dst_len = dst_plen; /* bits */
    addattr_l(&req.n, sizeof(req), RTA_DST, (void *) dst,
	      sizeof(struct in_addr));
  }

  if (table < 0 || table > 255) {
    RTDBG("change_iprule: invalid table id %i\n", table);
    return -1;
  }
  req.r.rtm_table = table;

  if (prio >= 0) {
    addattr32(&req.n, sizeof(req), RTA_PRIORITY, prio);
  }

  if (device != NULL) {
    /* Use also the incoming device to distinct packages */
    addattr_l(&req.n, sizeof(req), RTA_IIF, device,
	      strlen(device) + 1);
  }

  if (rtnl_open(&rth, 0) != 0)
    return -1;

  if (rtnl_talk(&rth, &req.n, 0, 0, NULL, NULL, NULL) < 0) {
    RTDBG("change_iprule: rtnl_talk failed\n");
    close(rth.fd);
    return -1;
  }

  close(rth.fd);
  return 0;
}

int rule4_add(const char *iface, uint8_t table,
	      uint32_t priority, uint8_t action,
	      const struct in_addr *src, int src_plen,
	      const struct in_addr *dst, int dst_plen, int flags)
{
  return change_iprule(RTM_NEWRULE, action, src, src_plen, dst, dst_plen, table, iface,
		       priority, flags);
}

int rule4_del(const char *iface, uint8_t table,
	      uint32_t priority, uint8_t action,
	      const struct in_addr *src, int src_plen,
	      const struct in_addr *dst, int dst_plen, int flags)
{
  return change_iprule(RTM_DELRULE, action, src, src_plen, dst, dst_plen, 
		       table, iface,
		       priority, flags);
}

static int route4_mod(int cmd, int oif, uint8_t table, unsigned flags,
		      const struct in_addr *src, int src_plen,
		      const struct in_addr *dst, int dst_plen,
		      const struct in_addr *gateway)
{

  struct rtnl_handle rth;
  struct rtrequest {
    struct nlmsghdr n;
    struct rtmsg r;
    char payload[256];
  } rtreq;

  memset(&rtreq, 0, sizeof(rtreq));

  if (cmd == RTM_NEWROUTE && oif == 0)
    return -1;

  if (rtnl_open(&rth, 0) != 0)
    return -1;

  rtreq.n.nlmsg_len = NLMSG_LENGTH(sizeof(struct rtmsg));
  rtreq.n.nlmsg_flags = NLM_F_REQUEST;
  rtreq.n.nlmsg_type = cmd;
  if (cmd == RTM_NEWROUTE) {
    rtreq.n.nlmsg_flags |= NLM_F_CREATE|NLM_F_EXCL;
  }
  if (gateway) rtreq.n.nlmsg_flags = NLM_F_REQUEST | NLM_F_CREATE;// | NLM_F_EXCL;


  rtreq.r.rtm_family = AF_INET;
  rtreq.r.rtm_table = table;
  if (cmd == RTM_DELROUTE) {
    rtreq.r.rtm_protocol = RTPROT_UNSPEC;
    rtreq.r.rtm_scope = RT_SCOPE_NOWHERE;
    rtreq.r.rtm_type = RTN_UNSPEC;
  } else {
    rtreq.r.rtm_protocol = RTPROT_BOOT;
    rtreq.r.rtm_scope = RT_SCOPE_LINK;
    rtreq.r.rtm_type = RTN_UNICAST;
  }

  if (dst) {
    addattr_l(&rtreq.n, sizeof(rtreq), RTA_DST, dst, sizeof(*dst));
    rtreq.r.rtm_dst_len = dst_plen;
  }
  addattr32(&rtreq.n, sizeof(rtreq), RTA_OIF, oif);

  if (src) {
    addattr_l(&rtreq.n, sizeof(rtreq), RTA_SRC, src, sizeof(*src));
    rtreq.r.rtm_src_len = src_plen;
  }
  addattr32(&rtreq.n, sizeof(rtreq), RTA_OIF, oif);

  if (gateway) {
    addattr_l(&rtreq.n, sizeof(rtreq), RTA_GATEWAY, gateway, sizeof(*gateway));
    rtreq.r.rtm_scope = RT_SCOPE_UNIVERSE;
  }

  if (rtnl_talk(&rth, &rtreq.n, 0, 0, NULL, NULL, NULL) < 0){
    int errno_b = errno;
    fprintf(stderr,"%s",cmd==RTM_NEWROUTE?"RTM_NEWROUTE":"RTM_DELROUTE");
    errno = errno_b;
    perror("route failed!");
  }

  close(rth.fd);
  return 0;
}


int route4_add(int oif, uint8_t table, unsigned flags,
	       const struct in_addr *src, int src_plen,
	       const struct in_addr *dst, int dst_plen,
	       const struct in_addr *gateway)
{
  return route4_mod(RTM_NEWROUTE, oif, table, flags, src, 
		    src_plen, dst, dst_plen, gateway);
}

int route4_del(int oif, uint8_t table,
	       const struct in_addr *src, int src_plen,
	       const struct in_addr *dst, int dst_plen,
	       const struct in_addr *gateway)
{
  return route4_mod(RTM_DELROUTE, oif, table, 0, src, 
		    src_plen, dst, dst_plen, gateway);
}

#endif

#define RTNL_NO_TEST 1
#ifndef RTNL_NO_TEST
#define RTNL_NO_TEST
int main()
{

}

#endif
