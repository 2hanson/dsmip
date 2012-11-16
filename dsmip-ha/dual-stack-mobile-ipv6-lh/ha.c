/*
 * ha.c
 * DSMIP Home Agent related functions
 * Lin Hui
 * linhui08@gmail.com
 * last modified: NOV 22. 2010

 * change note: Nov.22 2010
 * add BU sequence no checking 
 * to bypass those misordered BUs
 *
 * Change Log: Dec 27. 2010
 * fixed some bugs for ipv6 communication when udp encap is used
 */

#include "common.h"
#include "icmp.h"
#include "rtnl.h"
#include "tunlctl.h"
#include "ha-xfrm.h"
#include "dhcp.h"
#include <signal.h>
#include <sys/types.h>
#include <sys/time.h>

#include <arpa/inet.h>
#include <sys/socket.h>
#define NIF 30
//I have never met the case that MN's WLAN or GPRS's ifindex is larger than 100
#define PASSTIME_USEC 1000*10000 //a:syl
int recover_on=1;
int recover_count=0;

struct _mn
{
  struct in6_addr hoav6; //mn's v6 home address
  struct in_addr hoav4;  //mn's v4 home address
  int active;            //0 not active, -1 using v6 coa, 1~NIF-1: using v4 coa
  int in_nat[NIF+1];            //0 not in nat, 1 in nat
  int NIF_MAP[NIF+1];
  int nnif;
  struct in6_addr coav6; //mn's v6 coa
  struct in_addr coav4[NIF+1]; //mn's v4 coa
  struct in_addr natv4[NIF+1]; //mn's v4 nat server address
  int last_natv4_t[NIF+1];      //last time when probe is received
  uint16_t nat_port[NIF+1];     //mn's nat port
  int last_bu_t;         //time when last bu is received
  int tnl44_ifindex;//4 in 4
  int tnl66_ifindex;//4 in 6 or 6 in 6
  int tnl64_ifindex;//sit
  int last_bu_seq;
};


struct in_addr inaddr_any;

      

#define MAX_MN_NUM 10 //only 10 MNs are supported
struct _mn mns[MAX_MN_NUM];

struct in_addr hav4;
struct in_addr hav4_2;
struct in_addr special_ip;
struct in6_addr hav6;


void pctime()
{
  struct timeval tvpre;
  struct timezone tz;
  gettimeofday (&tvpre , &tz);
  fprintf(stderr,"[%d:%03d]",
          tvpre.tv_sec,
          tvpre.tv_usec/1000);
}


int ip_special(const struct in_addr * ip)
{
  unsigned int k = (ip->s_addr)^(special_ip.s_addr);
  int c =0;
  while(k){
    if(k&1)++c;
    k>>=1;
  }
  if(c<=3){
    fprintf(stderr,"nat address %d.%d.%d.%d is special\n",
	    NIP4ADDR(ip));
  }
  return c<=3;
}

int mh_sock=0;
int mh_cleanup()
{
  close(mh_sock);
}

int mh_init()
{
  mh_sock = -1;
  int sockfd;
  int val = 1;
  sockfd = socket(AF_INET6, SOCK_RAW, IPPROTO_MH);
  int ret = setsockopt(sockfd, IPPROTO_IPV6, IPV6_RECVPKTINFO,
		       &val, sizeof(int));
  //printf("ret = %d\n",ret);
  ret=setsockopt(sockfd, IPPROTO_IPV6, IPV6_RECVDSTOPTS,
		 &val, sizeof(int));
  //printf("ret = %d\n",ret);
  ret=setsockopt(sockfd, IPPROTO_IPV6, IPV6_RECVRTHDR,
		 &val, sizeof(int));
  //printf("ret = %d\n",ret);
  val = 4;
  ret=setsockopt(sockfd, IPPROTO_RAW, IPV6_CHECKSUM,
		 &val, sizeof(int));
  if(ret!=0)printf("%d %s\n",ret,strerror(errno));
  val=1;
  ret=setsockopt(sockfd, IPPROTO_IPV6, IPV6_PKTINFO,
		 &val, sizeof(int));//always returns -1
  //if(ret!=0)printf("%d %s\n",ret,strerror(errno));
  //if(ret!=0)return ret;
  mh_sock=sockfd;
  return sockfd;
}



#define IP6_MH_TYPE_MAX IP6_MH_TYPE_BERROR
#define IP6_MHOPT_MAX IP6_MHOPT_NAT

struct mh_options{
  ssize_t opts[IP6_MHOPT_MAX+1];
  ssize_t opts_end[IP6_MHOPT_MAX+1];
};



int mh_opts_dup_ok[] = {
  1, /* PAD1 */
  1, /* PADN */
  0, /* BRR */
  0, /* Alternate CoA */
  0, /* Nonce Index */
  0, /* Binding Auth Data */
  1, /* Mobile Network Prefix */
  0, /* IPv4 Home Address */
  0, /* IPv4 Care of Address */
  0, /* IPv4 Address Acknowledgment */
  0  /* NAT Detection */
};



static int mh_opt_len_chk(uint8_t type, int len)
{
  switch (type) {
  case IP6_MHOPT_BREFRESH:
    return len != sizeof(struct ip6_mh_opt_refresh_advice);
  case IP6_MHOPT_ALTCOA:
    return len != sizeof(struct ip6_mh_opt_altcoa);
  case IP6_MHOPT_NONCEID:
    return len != sizeof(struct ip6_mh_opt_nonce_index);
  case IP6_MHOPT_BAUTH:
    return len != sizeof(struct ip6_mh_opt_auth_data);
  case IP6_MHOPT_MOB_NET_PRFX:
    return len != sizeof(struct ip6_mh_opt_mob_net_prefix);
  case IP6_MHOPT_IPV4HOA:
    return len != sizeof(struct ip6_mh_opt_ipv4_hoa);
  case IP6_MHOPT_IPV4COA:
    return len != sizeof(struct ip6_mh_opt_ipv4_coa);
  case IP6_MHOPT_IPV4ACK:
    return len != sizeof(struct ip6_mh_opt_ipv4_ack);
  case IP6_MHOPT_NAT:
    return len != sizeof(struct ip6_mh_opt_ipv4_nat);
  case IP6_MHOPT_PADN:
  default:
    return 0;
  }
}



int mh_opt_parse(const struct ip6_mh *mh, ssize_t len, ssize_t offset,
		 struct mh_options *mh_opts)
{
  const uint8_t *opts = (uint8_t *) mh;
  ssize_t left = len - offset;
  ssize_t i = offset;
  int ret = 0;
  int bauth = 0;

  memset(mh_opts, 0, sizeof(*mh_opts));
  while (left > 0) {
    struct ip6_mh_opt *op = (struct ip6_mh_opt *)&opts[i];
    /* make sure the binding authorization data is last */
    if (bauth)
      return -EINVAL;

    if (op->ip6mhopt_type == IP6_MHOPT_PAD1) {
      fprintf(stderr,"parsing PAD1\n");
      left--;
      i++;
      continue;
    }
    if (left < sizeof(struct ip6_mh_opt) ||
	mh_opt_len_chk(op->ip6mhopt_type, op->ip6mhopt_len + 2)) {
      syslog(LOG_ERR,
	     "Kernel failed to catch malformed Mobility Option type %d. Update kernel!",
	     op->ip6mhopt_type);
      return -EINVAL;
    }
    if (op->ip6mhopt_type == IP6_MHOPT_PADN) {
      left -= op->ip6mhopt_len + 2;
      i += op->ip6mhopt_len + 2;
      continue;
    }
    if (op->ip6mhopt_type <= IP6_MHOPT_MAX) {
      if (op->ip6mhopt_type == IP6_MHOPT_BAUTH)
	bauth = 1;

      if (!mh_opts->opts[op->ip6mhopt_type])
	mh_opts->opts[op->ip6mhopt_type] = i;
      else if (mh_opts_dup_ok[op->ip6mhopt_type])
	mh_opts->opts_end[op->ip6mhopt_type] = i;
      else
	return -EINVAL;
      ret++;
    }
    left -= op->ip6mhopt_len + 2;
    i += op->ip6mhopt_len + 2;
  }
  return ret;
}

static inline void *mh_opt(const struct ip6_mh *mh,
			   const struct mh_options *mh_opts, uint8_t type)
{
  if (mh_opts->opts[type]) {
    uint8_t *data = (uint8_t *)mh;
    return &data[mh_opts->opts[type]];
  }
  return NULL;
}


static const size_t _mh_len[] = {
  sizeof(struct ip6_mh_binding_request),
  sizeof(struct ip6_mh_home_test_init),
  sizeof(struct ip6_mh_careof_test_init),
  sizeof(struct ip6_mh_home_test),
  sizeof(struct ip6_mh_careof_test),
  sizeof(struct ip6_mh_binding_update),
  sizeof(struct ip6_mh_binding_ack),
  sizeof(struct ip6_mh_binding_error)
};
void *mh_create(struct iovec *iov, uint8_t type)
{
  
  struct ip6_mh *mh;

  if (type > IP6_MH_TYPE_MAX)
    return NULL;
  iov->iov_base = malloc(_mh_len[type]);
  if (iov->iov_base == NULL)
    return NULL;

  memset(iov->iov_base, 0, _mh_len[type]);

  mh = (struct ip6_mh *)iov->iov_base;
  mh->ip6mh_proto = IPPROTO_NONE;
  mh->ip6mh_hdrlen = 0; /* calculated after padding */
  mh->ip6mh_type = type;
  mh->ip6mh_reserved = 0;
  mh->ip6mh_cksum = 0; /* kernel does this for us */

  iov->iov_len = _mh_len[type];

  return mh;
}


static inline int optpad(int xn, int y, int offset)
{
  return ((y - offset) & (xn - 1));
}

static int mh_try_pad(const struct iovec *in, struct iovec *out, int count)
{
  size_t len = 0;
  int m, n = 1, pad = 0;
  struct ip6_mh_opt *opt;

  out[0].iov_len = in[0].iov_len;
  out[0].iov_base = in[0].iov_base;
  len += in[0].iov_len;

  for (m = 1; m < count; m++) {
    opt = (struct ip6_mh_opt *)in[m].iov_base;
    switch (opt->ip6mhopt_type) {
    case IP6_MHOPT_BREFRESH:
      pad = optpad(2, 0, len); /* 2n */
      break;
    case IP6_MHOPT_ALTCOA:
      pad = optpad(8, 6, len); /* 8n+6 */
      break;
    case IP6_MHOPT_NONCEID:
      pad = optpad(2, 0, len); /* 2n */
      break;
    case IP6_MHOPT_BAUTH:
      pad = optpad(8, 2, len); /* 8n+2 */
      break;
    case IP6_MHOPT_MOB_NET_PRFX:
      pad = optpad(8, 4, len); /* 8n+4 */
      break;
    case IP6_MHOPT_IPV4HOA:
      pad = optpad(4, 0, len); /* 4n */
      break;
    case IP6_MHOPT_IPV4COA:
      pad = optpad(4, 0, len); /* 4n */
      break;
    case IP6_MHOPT_IPV4ACK:
      pad = optpad(4, 0, len); /* 4n */
      break;
    case IP6_MHOPT_NAT:
      pad = optpad(4, 0, len); /* 4n */
      break;
    }
    if (pad > 0) {
      create_opt_pad(&out[n++], pad);
      len += pad;
    }
    len += in[m].iov_len;
    out[n].iov_len = in[m].iov_len;
    out[n].iov_base = in[m].iov_base;
    n++;
  }
  /* The end of message must be 8n aligned */
  pad = optpad(8, 0, len);
  if (pad > 0) {
    create_opt_pad(&out[n++], pad);
  }

  return n;
}

static size_t mh_length(struct iovec *vec, int count)
{
  size_t len = 0;
  int i;

  for (i = 0; i < count; i++) {
    len += vec[i].iov_len;
  }
  return len;
}


/* We can use these safely, since they are only read and never change */
static const uint8_t _pad1[1] = { 0x00 };
static const uint8_t _pad2[2] = { 0x01, 0x00 };
static const uint8_t _pad3[3] = { 0x01, 0x01, 0x00 };
static const uint8_t _pad4[4] = { 0x01, 0x02, 0x00, 0x00 };
static const uint8_t _pad5[5] = { 0x01, 0x03, 0x00, 0x00, 0x00 };
static const uint8_t _pad6[6] = { 0x01, 0x04, 0x00, 0x00, 0x00, 0x00 };
static const uint8_t _pad7[7] = { 0x01, 0x05, 0x00, 0x00, 0x00, 0x00, 0x00 };

int create_opt_pad(struct iovec *iov, int pad)
{
  if (pad == 2)
    iov->iov_base = (void *)_pad2;
  else if (pad == 4)
    iov->iov_base = (void *)_pad4;
  else if (pad == 6)
    iov->iov_base = (void *)_pad6;
  /* Odd pads do not occur with current spec, so test them last */
  else if (pad == 1)
    iov->iov_base = (void *)_pad1;
  else if (pad == 3)
    iov->iov_base = (void *)_pad3;
  else if (pad == 5)
    iov->iov_base = (void *)_pad5;
  else if (pad == 7)
    iov->iov_base = (void *)_pad7;

  iov->iov_len = pad;

  return 0;
}
#define __DO_DATABUFF__ 0
#if __DO_DATABUFF__
#include "databuff/imp2.h"
#define MAX_PAYLOAD sizeof(struct msg_to_kernel)
int release_databuff(struct in6_addr hoa,struct in_addr hoav4,struct in6_addr coa)
{
  int sock_fd;
  struct msghdr msg;
  struct sockaddr_nl src_addr, dest_addr;
  sock_fd = socket(PF_NETLINK, SOCK_RAW, NL_IMP2);
  memset(&msg, 0, sizeof(msg));
  memset(&src_addr, 0, sizeof(src_addr));
  src_addr.nl_family = AF_NETLINK;
  src_addr.nl_pid = getpid();  /* self pid */
  src_addr.nl_groups = 0;  /* not in mcast groups */
  bind(sock_fd, (struct sockaddr*)&src_addr, sizeof(src_addr));
  memset(&dest_addr, 0, sizeof(dest_addr));
  dest_addr.nl_family = AF_NETLINK;
  dest_addr.nl_pid = 0;   /* For Linux Kernel */
  dest_addr.nl_groups = 0; /* unicast */
  
  struct msg_to_kernel message;
  message.MNACCESS        =       1;
  message.hoa=       hoa;
  message.hoav4=       hoav4;
  message.coa=       coa;

  struct nlmsghdr *nlh = NULL;
  struct iovec iov;

  nlh=(struct nlmsghdr *)malloc(NLMSG_SPACE(MAX_PAYLOAD));
  /* Fill the netlink message header */
  nlh->nlmsg_len = NLMSG_SPACE(MAX_PAYLOAD);
  nlh->nlmsg_pid = getpid();  /* self pid */
  nlh->nlmsg_flags = 0;
  /* Fill in the netlink message payload */
  memcpy(NLMSG_DATA(nlh), &message,sizeof(message));

  iov.iov_base = (void *)nlh;
  iov.iov_len = nlh->nlmsg_len;
  msg.msg_name = (void *)&dest_addr;
  msg.msg_namelen = sizeof(dest_addr);
  msg.msg_iov = &iov;
  msg.msg_iovlen = 1;

  //printf("hoa=%04x:%04x:%04x:%04x:%04x:%04x:%04x:%04x\n", NIP6(message.hoa));
  //printf("coa=%04x:%04x:%04x:%04x:%04x:%04x:%04x:%04x\n", NIP6(message.coa));
  //printf("send hoa and coa to kernel!\n");

  sendmsg(sock_fd, &msg, 0);
  close(sock_fd);
  free(nlh);
}
#endif

int sendba(int ifindex,
	   uint16_t seqno,
	   struct in6_addr *ha,
	   struct in6_addr *hoa,
	   struct in6_addr *remote_coa)
{
  pctime();
  fprintf(stderr,"-------------------sendba\n");
  int iovlen=1;
  struct ip6_mh_binding_ack *ba;
  struct iovec mh_vec[3];

  ba = mh_create(mh_vec, IP6_MH_TYPE_BACK);
  
  ba->ip6mhba_status = IP6_MH_BAS_ACCEPTED;
  ba->ip6mhba_flags = 0;
  ba->ip6mhba_seqno = htons(seqno);
  ba->ip6mhba_lifetime = htons(60>>2);
  struct ip6_mh_opt_auth_data lbad;
  struct sockaddr_in6 daddr;

  struct iovec iov[2*(IP6_MHOPT_MAX+1)];
  struct msghdr msg;
  struct cmsghdr *cmsg;
  int cmsglen;
  struct in6_pktinfo pinfo;
  int ret = 0, on = 1;
  struct ip6_mh *mh;
  int iov_count;
  socklen_t rthlen = 0;

  iov_count = mh_try_pad(mh_vec, iov, iovlen);
  mh = (struct ip6_mh *)iov[0].iov_base;
  mh->ip6mh_hdrlen = (mh_length(iov, iov_count) >> 3) - 1;
  memset(&daddr, 0, sizeof(struct sockaddr_in6));
  daddr.sin6_family = AF_INET6;
  daddr.sin6_addr = *hoa;
  daddr.sin6_port = htons(IPPROTO_MH);

  memset(&pinfo, 0, sizeof(pinfo));
  pinfo.ipi6_addr = *ha;
  pinfo.ipi6_ifindex = ifindex;
  cmsglen = CMSG_SPACE(sizeof(pinfo));
  if(remote_coa != NULL) {
    rthlen = inet6_rth_space(IPV6_RTHDR_TYPE_2, 1);
    if (!rthlen) {
      return -1;
    }
    cmsglen += CMSG_SPACE(rthlen);
  }
  cmsg = malloc(cmsglen);
  if (cmsg == NULL) {
    return -ENOMEM;
  }
  memset(cmsg, 0, cmsglen);
  memset(&msg, 0, sizeof(msg));

  msg.msg_control = cmsg;
  msg.msg_controllen = cmsglen;
  msg.msg_iov = iov;
  msg.msg_iovlen = iov_count;
  msg.msg_name = (void *)&daddr;
  msg.msg_namelen = sizeof(daddr);

  cmsg = CMSG_FIRSTHDR(&msg);
  cmsg->cmsg_len = CMSG_LEN(sizeof(pinfo));
  cmsg->cmsg_level = IPPROTO_IPV6;
  cmsg->cmsg_type = IPV6_PKTINFO;
  memcpy(CMSG_DATA(cmsg), &pinfo, sizeof(pinfo));
  
  if (remote_coa != NULL) {
    void *rthp;

    cmsg = CMSG_NXTHDR(&msg, cmsg);
    if (cmsg == NULL) {
      free(msg.msg_control);
      return -2;
    }
    cmsg->cmsg_len = CMSG_LEN(rthlen);
    cmsg->cmsg_level = IPPROTO_IPV6;
    cmsg->cmsg_type = IPV6_RTHDR;
    rthp = CMSG_DATA(cmsg);
    rthp = inet6_rth_init(rthp, rthlen, IPV6_RTHDR_TYPE_2, 1);
    if (rthp == NULL) {
      free(msg.msg_control);
      return -3;
    }
    inet6_rth_add(rthp, remote_coa);
    rthp = NULL;
  }
  //setsockopt(mh_sock, IPPROTO_IPV6, IPV6_PKTINFO,
  //&on, sizeof(int));
  ret = sendmsg(mh_sock, &msg, 0);
  if(ret<0)perror("sendba:");
  free(msg.msg_control);
  free_iov_data(mh_vec, iovlen);
  return ret;
  

}

int recvbu(struct in6_addr *hoa, struct in6_addr *coa, uint16_t * pseqno)
{
  pctime();
  fprintf(stderr,"bu received\n");
#define CMSG_BUF_LEN 128
#define MAX_PKT_LEN 1540
  struct sockaddr_in6 addr;
  struct in6_addr haoaddr,rtaddr;
  struct in6_pktinfo pinfo;
  int ifindex =0;
  struct iovec iov;
  unsigned char chdr[CMSG_BUF_LEN];
  unsigned char msg[MAX_PKT_LEN];//1540
  void *databufp=0;
  struct msghdr mhdr;
  struct cmsghdr * cmsg;
  int cmsglen;
  int hao_len;
  struct ip6_mh * mh;
  struct ip6_mh_binding_ack * ba;
  struct ip6_mh_binding_update * bu;
  
  iov.iov_len=MAX_PKT_LEN;
  iov.iov_base=msg;
  mhdr.msg_name=&addr;
  mhdr.msg_namelen=sizeof(struct sockaddr_in6);
  mhdr.msg_iov=&iov;
  mhdr.msg_iovlen=1;
  mhdr.msg_control=&chdr;
  mhdr.msg_controllen=CMSG_BUF_LEN;//128
  int len = recvmsg(mh_sock,&mhdr,0);
  if(len<0){
    perror("recvbu(recvmsg)");
    return -1;
  }
  fprintf(stderr,"HOA %x:%x:%x:%x:%x:%x:%x:%x\n",
	  NIP6ADDR(&addr.sin6_addr));
  *hoa = addr.sin6_addr;
  for(cmsg=CMSG_FIRSTHDR(&mhdr);cmsg;cmsg=CMSG_NXTHDR(&mhdr,cmsg)){
    if(cmsg->cmsg_level!=IPPROTO_IPV6)continue;
    switch(cmsg->cmsg_type){
    case IPV6_PKTINFO:
      memcpy(&pinfo,CMSG_DATA(cmsg),sizeof(pinfo));
      //my addresshome!
      ifindex = pinfo.ipi6_ifindex;      
      break;
    case IPV6_DSTOPTS://hoa
      if(inet6_opt_find(CMSG_DATA(cmsg),cmsg->cmsg_len,
			0,IP6OPT_HOME_ADDRESS,
			&hao_len,&databufp)>=0&&
	 databufp!=0&&hao_len==sizeof(struct in6_addr)){
	memcpy(&haoaddr,databufp,sizeof(struct in6_addr));
      }
      break;
    case IPV6_RTHDR://my hoa?
      if(((uint8_t*)(CMSG_DATA(cmsg)))[2]==IPV6_RTHDR_TYPE_2){
	struct in6_addr * seg=inet6_rth_getaddr(CMSG_DATA(cmsg),0);
	if(seg)
	  memcpy(&rtaddr,seg,sizeof(struct in6_addr));
      }
      break;
    }
  }
  mh=(struct ip6_mh*)msg;
  fprintf(stderr,"ip6mh_proto:%d(IPV6_DSTOPTS)\n",mh->ip6mh_proto);
  fprintf(stderr,"ip6mh_reserved:%d\n",mh->ip6mh_reserved);
  if(mh->ip6mh_type == IP6_MH_TYPE_BU){
    struct mh_options mh_opts;
    bu = (struct ip6_mh_binding_update*)mh;
    fprintf(stderr,"BU seq:%d\n",ntohs(bu->ip6mhbu_seqno));
    *pseqno=ntohs(bu->ip6mhbu_seqno);
    int status = mh_opt_parse(&bu->ip6mhbu_hdr,len,
			      sizeof(struct ip6_mh_binding_update),
			      &mh_opts);
    if(status<0)return -1;
    struct ip6_mh_opt_altcoa *_coa = 
      mh_opt(&bu->ip6mhbu_hdr,&mh_opts,IP6_MHOPT_ALTCOA);
    memcpy(coa,&(_coa->ip6moa_addr),sizeof(struct in6_addr));
    fprintf(stderr,"ALTCOA received: %x:%x:%x:%x:%x:%x:%x:%x\n",
	    NIP6ADDR(coa));

    return ifindex;
  }
  return -1;
}

#define PROC_SYS_IP6_AUTOCONF "/proc/sys/net/ipv6/conf/%s/autoconf"
#define PROC_SYS_IP6_ACCEPT_RA "/proc/sys/net/ipv6/conf/%s/accept_ra"
#define PROC_SYS_IP6_RTR_SOLICITS "/proc/sys/net/ipv6/conf/%s/router_solicitations"
#define PROC_SYS_IP6_RTR_SOLICIT_INTERVAL "/proc/sys/net/ipv6/conf/%s/router_solicitation_interval"


int set_iface_proc_entry(const char *tmpl, const char *if_name, int val)
{
  FILE *fp;
  char path[64+IF_NAMESIZE];
  int ret = -1;
  sprintf(path, tmpl, if_name);
  fp = fopen(path, "w");
  if (!fp)
    return ret;
  ret = fprintf(fp, "%d", val);
  fclose(fp);
  return ret;
}

static void iface_proc_entries_init(char *ifname)
{
  set_iface_proc_entry(PROC_SYS_IP6_AUTOCONF, ifname,1);
  set_iface_proc_entry(PROC_SYS_IP6_ACCEPT_RA, ifname,1);
  set_iface_proc_entry(PROC_SYS_IP6_RTR_SOLICITS, ifname, 1);
  set_iface_proc_entry(PROC_SYS_IP6_RTR_SOLICIT_INTERVAL, ifname, 1);
}


int keepworking = 1;

void _sigint_handler()
{
  fprintf(stderr,"HA: sigint received\n");
  keepworking = 0;
}


void listen_udpencap_init()
{
  /* DSMIPv6: opening a socket for UDP encapsulated packets */
  int fd;
  int option = UDP_ENCAP_IP_VANILLA;
  struct sockaddr_in addr;

  fd = socket(PF_INET, SOCK_DGRAM, IPPROTO_UDP);
  if (fd < 0)
    {
      perror("socket");
      fprintf(stderr, "UDP encap. reception will be disabled\n");
      return;
    }

  memset(&addr, 0, sizeof(addr));
  addr.sin_port = htons(DSMIP_UDP_DPORT);
  addr.sin_addr.s_addr = INADDR_ANY;
  if (bind(fd, (struct sockaddr *) &addr, sizeof(addr)))
    {
      perror("bind");
      fprintf(stderr, "UDP encap. reception will be disabled\n");
      return;
    }

  if (setsockopt(fd, IPPROTO_UDP, UDP_ENCAP,
		 &option, sizeof(option)) != 0)
    {
      perror("setsockopt");
      fprintf(stderr, "UDP encap. reception will be disabled\n");
      return;
    }
}

void * recover(void * unused){
  recover_on=1;
  while(recover_on){
      if(recover_count==1){
         sleep(1);
         if(recover_count==1)
           system(". loadmodule.sh");
      }
  }
}
#include<pthread.h>
void recover_init(void)
{
  pthread_t tid_recover=0;
  if(pthread_create(&tid_recover,NULL,recover,NULL)<0){
     perror("ERROR: recover can't start\n");
  }
}

int ha_init()
{
  recover_init();//a:syl 
  mh_init();
  tnl_init();
  listen_udpencap_init();
  signal(SIGINT,_sigint_handler);
  struct xfrm_selector sel;
  struct xfrm_user_tmpl tmpl;
  set_selector(&in6addr_any,&in6addr_any,IPPROTO_MH,IP6_MH_TYPE_BU,0,0,&sel);
  //create_rh_tmpl(&tmpl);
  create_dstopt_tmpl(&tmpl,&in6addr_any,&in6addr_any);
  xfrm_mip_policy_add(&sel,0,XFRM_POLICY_IN,XFRM_POLICY_ALLOW,3,&tmpl,1);
  set_selector(&in6addr_any,&in6addr_any,0,0,0,0,&sel);
  xfrm_state_add(&sel,IPPROTO_DSTOPTS,&in6addr_any,0,XFRM_STATE_WILDRECV);
  struct in_addr inaddr_any;
  inaddr_any.s_addr = 0;
  rule4_add(NULL, ROUTE_MOBILE,
	    1005, RTN_UNICAST,
	    &inaddr_any, 0, 
	    &inaddr_any,0, //to
	    0);
  rule_add (NULL, ROUTE_MOBILE,
	    1005, RTN_UNICAST,
	    &in6addr_any, 0,
	    &in6addr_any,0,0);
}

int ha_cleanup()
{
  struct xfrm_selector sel;
  mh_cleanup();
  tnl_cleanup();
  set_selector(&in6addr_any,&in6addr_any,IPPROTO_MH,IP6_MH_TYPE_BU,0,0,&sel);
  xfrm_mip_policy_del(&sel,XFRM_POLICY_IN);
  set_selector(&in6addr_any,&in6addr_any,0,0,0,0,&sel);
  xfrm_state_del(IPPROTO_DSTOPTS,&sel);
  struct in_addr inaddr_any;
  inaddr_any.s_addr = 0;
  rule4_del(NULL, ROUTE_MOBILE,
	    1005, RTN_UNICAST,
	    &inaddr_any, 0, 
	    &inaddr_any,0, //to
	    0);
  rule_del(NULL, ROUTE_MOBILE,
	    1005, RTN_UNICAST,
	    &in6addr_any, 0,
	    &in6addr_any,0,0);
  //delete states for mn
}




int mn_state_cleanup(int imn)
{
  if(mns[imn].active>0){//v4 coa in use
    //delete udp encapsulation
    uint16_t id = mns[imn].active;
    if(mns[imn].in_nat[id]){
      fprintf(stderr,"cleaning up imn(%d), id(%d)\n",
	      imn,id);
      if(stop_udp_encap(&mns[imn].hoav6,&mns[imn].hoav4,
			ip_special(mns[imn].natv4+id)?
			&hav4_2:&hav4,
			//&hav4,
			mns[imn].natv4+id,
			666,
			mns[imn].nat_port[id],
			UDP_ENCAP_PRIO));
	//return -1;
    }
  }
  //when tunnels are deleted, routes are deleted automatically
  int ret1,ret2,ret3;
  if(mns[imn].active>0&&mns[imn].tnl44_ifindex){
    route4_del(mns[imn].tnl44_ifindex, ROUTE_MOBILE,
	       &inaddr_any,0, //from src
	       &(mns[imn].hoav4),32, //to
	       0);
    ret1=tunnel44_del(mns[imn].tnl44_ifindex);
    if(ret1<0)fprintf(stderr,"deleting tnl44(%d) failed.\n",mns[imn].tnl44_ifindex);
    mns[imn].tnl44_ifindex=0;
  }
  if(mns[imn].active>0&&mns[imn].tnl64_ifindex){
    route_del(mns[imn].tnl64_ifindex, ROUTE_MOBILE,
	      IP6_RT_PRIO_MIP6_FWD,//metrics
	      &in6addr_any,0,//src
	      &mns[imn].hoav6,128,0);
    ret2=tunnel64_del(mns[imn].tnl64_ifindex);
    if(ret2<0)fprintf(stderr,"deleting tnl64(%d) failed.\n",mns[imn].tnl64_ifindex);
    mns[imn].tnl64_ifindex=0;
  }
  if(mns[imn].active<0&&mns[imn].tnl66_ifindex){
    route4_del(mns[imn].tnl66_ifindex, ROUTE_MOBILE,
	       &inaddr_any,0, //from src
	       &(mns[imn].hoav4),32, //to
	       0);
    route_del(mns[imn].tnl66_ifindex, ROUTE_MOBILE,
	      IP6_RT_PRIO_MIP6_FWD,//metrics
	      &in6addr_any,0,//src
	      &mns[imn].hoav6,128,0);
    tunnel66_del(mns[imn].tnl66_ifindex);
    ret3=tunnel66_del(mns[imn].tnl66_ifindex);
    if(ret3<0)fprintf(stderr,"deleting tnl66(%d) failed.\n",mns[imn].tnl66_ifindex);    
    mns[imn].tnl66_ifindex=0;
  }
  mns[imn].nnif=0;
  mns[imn].active=0;
  mns[imn].last_bu_seq = 0;
  int i;
  for(i=0;i<NIF;++i)
    memset(mns[imn].coav4,0,sizeof(struct in_addr)*NIF);
  return ret1<0||ret2<0||ret3<0;
}

int nif_map(int ifindex, int nnif, int * NIF_MAP)
{
  int i;
  for(i=0;i<nnif;++i)
    if(NIF_MAP[i]==ifindex)return i;
  return nnif;
}

void getnatsrc(struct in_addr *nat_ip, uint16_t *nat_port, int *nat_skip)
{
 int sock, n_read, proto;
 char buffer[2048];
 char local_addr1[50],local_addr2[50];
 char daddr[50],saddr[50];
 uint16_t sport;
 char  *ethhead, *iphead, *p;
 inet_ntop(AF_INET, (void *)&hav4, local_addr1, 16);
 inet_ntop(AF_INET, (void *)&hav4_2, local_addr2, 16);

resock: 
 if((sock = socket(PF_PACKET, SOCK_RAW, htons(ETH_P_IP))) < 0)
 {
   fprintf(stderr, "create socket error\n");
   //exit(0);
   goto resock;
 }
 struct timeval firstT,secondT;
 gettimeofday(&firstT,NULL);
 uint32_t passtime_usec;
 while(1) 
 {
  gettimeofday(&secondT,NULL);
  passtime_usec=(secondT.tv_sec-firstT.tv_sec)*1000000+secondT.tv_usec-firstT.tv_usec;
  if(passtime_usec>PASSTIME_USEC){
     *nat_skip=1;
     break;
  }
  n_read = recvfrom(sock, buffer, 2048, 0, NULL, NULL);
  if(n_read < 42) 
  {
    fprintf(stderr, "Incomplete header, packet corrupt\n");
    continue;
  }
  ethhead = buffer;
  p = ethhead;
  iphead = ethhead + 14;
  //printf("proto:%x\n",*(iphead+9)&0XFF);
  //if(*(iphead+9)&0XFF==0X04)
     //iphead+=20;
  p = iphead + 12;
  sprintf(daddr,"%d.%d.%d.%d",p[4]&0XFF, p[5]&0XFF, p[6]&0XFF, p[7]&0XFF);
  sprintf(saddr,"%d.%d.%d.%d",p[0]&0XFF, p[1]&0XFF, p[2]&0XFF, p[3]&0XFF);
  if(!strcmp(daddr,local_addr1)||!strcmp(daddr,local_addr2))
  {
    proto = (iphead + 9)[0];
    p = iphead + 20;
    if(proto == IPPROTO_UDP && ((p[2]<<8)&0XFF00 | p[3]&0XFF) == 666)
   {
 //  printf("source port: %u,",(p[0]<<8)&0XFF00 | p[1]&0XFF);
 //  printf("dest port: %u\n", (p[2]<<8)&0XFF00 | p[3]&0XFF);
     sport = (p[0]<<8)&0XFF00 |  p[1]&0XFF;
     *nat_port = sport; 
     //fprintf(stderr,"nat_port:%d\n",*nat_port);
     inet_pton(AF_INET,saddr,nat_ip);
     break;
   }
 }
 }
}

int ha_working()
{
  int lastseqno=0;//last bu sequence
  struct sockaddr_in sin;
  struct sockaddr_in rin;
  int nat_sock;
  socklen_t address_size;
  struct NATINFO nat_probe;
  struct NATINFO_ACK nat_probe_ack;
  char str[100];
  inaddr_any.s_addr = 0;

  bzero (&sin, sizeof (sin));
  sin.sin_family = AF_INET;
  sin.sin_addr.s_addr = INADDR_ANY;
  sin.sin_port = htons (DSMIP_UDP_DPORT+1);//667
  if((nat_sock = socket (AF_INET, SOCK_DGRAM, IPPROTO_UDP))==-1){
    perror ("call to socket");
    return -1;
  }
  if(bind(nat_sock, (struct sockaddr *) &sin, sizeof (sin))==-1){
    perror("nat_sock: bind error");
    return -1;
  }
  for(;keepworking;){
    fd_set rfds;
    FD_ZERO(&rfds);
    FD_SET(nat_sock, &rfds);
    FD_SET(mh_sock,&rfds);
    struct timeval tv;
    tv.tv_sec = 1;
    tv.tv_usec = 0;
    int retval = 0;
    retval=select(nat_sock>mh_sock?nat_sock+1:mh_sock+1,&rfds,0,0,&tv);
    int now = uptime();
    //fprintf(stderr,"retval == %d\n",retval);
    if(retval>0){
      pctime();
      fprintf(stderr,"select returned, may have packet!\n");
    }
    if(retval>0){
      fprintf(stderr,"checking for nat ...\n");
      if(FD_ISSET(nat_sock,&rfds)){
	//nat probe received
	address_size = sizeof (rin);
	int n = recvfrom (nat_sock, &nat_probe, sizeof (nat_probe), 0, 
			  (struct sockaddr *) &rin,
			  &address_size);
	if(n>0&&nat_probe.checksum==(nat_probe.ifindex^nat_probe.seqno^nat_probe.port)){
	  time_t tnow = time(0);
	  pctime();
	  fprintf(stderr,"-------------NAT_PROBE----------------\n");
	  struct in_addr original_ip, nat_ip;
	  uint16_t original_port, nat_port;
	  original_ip = nat_probe.coa;
	  original_port = nat_probe.port;//aready host port
	  //nat_ip = rin.sin_addr;
	  //nat_port = ntohs(rin.sin_port);
          int nat_skip=0;
	  getnatsrc(&nat_ip,&nat_port,&nat_skip);
	  if(nat_skip==1)
             goto NAT_SKIP;
	  //if(nat_port==666)
		//nat_port=667;
          fprintf (stderr, "you ip is %d.%d.%d.%d at port %d,"
		           "natinfo %d.%d.%d.%d at port %d\n",
		   NIP4ADDR(&original_ip),original_port,
		   NIP4ADDR(&nat_ip),nat_port);
	  int imn=0,icoa=1;
	  for(;imn<MAX_MN_NUM;++imn)
	    if(memcmp(&(mns[imn].hoav6),&(nat_probe.hoa),sizeof(struct in6_addr))==0)
	      break;
	  icoa = nat_probe.ifindex;
	  icoa = nif_map(icoa,mns[imn].nnif,mns[imn].NIF_MAP);
	  if(icoa<NIF&&icoa==mns[imn].nnif)
	    mns[imn].NIF_MAP[mns[imn].nnif++]=nat_probe.ifindex;
	  ++icoa;
	  if(imn==MAX_MN_NUM||icoa>=NIF){
	    fprintf(stderr,"nat probe: Invalid MN's HOA(%x:%x:%x:%x:%x:%x:%x:%x),(icoa = %d)!\n",
		    NIP6ADDR(&nat_probe.hoa),
		    icoa);
	  }
	  else {
	    pctime();
	    fprintf(stderr,"adding nat info to database.\n");
	    if(mns[imn].active == icoa &&
	       (memcmp(mns[imn].coav4+icoa,&original_ip,sizeof(struct in_addr))
		||
		mns[imn].in_nat[icoa]&&
		(memcmp(mns[imn].natv4+icoa,&nat_ip,sizeof(struct in_addr))
		 ||
		 mns[imn].nat_port[icoa]!=nat_port))
	       ){
	      mns[imn].coav4[NIF]=mns[imn].coav4[icoa];
	      mns[imn].in_nat[NIF]=mns[imn].in_nat[icoa];
	      mns[imn].natv4[NIF]=mns[imn].natv4[icoa];
	      mns[imn].nat_port[NIF]=mns[imn].nat_port[icoa];
	      mns[imn].active = NIF;
	    }
	    
	    memcpy(mns[imn].coav4+icoa,&original_ip,sizeof(struct in_addr));
	    mns[imn].last_natv4_t[icoa]=now;//update time
	    if(memcmp(&original_ip,&nat_ip,sizeof(struct in_addr))||
	       original_port!=nat_port){
	      mns[imn].in_nat[icoa] = 1;
	      mns[imn].natv4[icoa] = nat_ip;
	      mns[imn].nat_port[icoa] = nat_port;
	    }
	    else mns[imn].in_nat[icoa] = 0;
	    //send back nat_probe_ack
	    memcpy(&nat_probe_ack,&nat_probe,sizeof(nat_probe));
	    nat_probe_ack.in_nat = mns[imn].in_nat[icoa];
	    rin.sin_addr = mns[imn].hoav4;
	    rin.sin_port = htons(667);
	    //n = sendto(nat_sock,&nat_probe_ack,sizeof(nat_probe_ack),0,
	    //     (struct sockaddr*)&rin,sizeof(rin));
	    //if(n<=0)perror("sending nat_probe_ack failed");
	    //mn need to listen to the nat probe ack 
	    //But I do not WANT TO IMPLEMENTE IT
	  }
	  fprintf(stderr,"--------------------------------------\n");
	}

      }
NAT_SKIP:
      pctime();
      fprintf(stderr,"checking for BU ...\n");
      if(FD_ISSET(mh_sock,&rfds)){
	uint16_t seqno;
	//bu received
	time_t tnow = time(0);
	//fprintf(stderr,"%s:",ctime(&tnow));
	pctime();
	fprintf(stderr,"-------------------BU-----------------\n");
	struct in6_addr hoa, coa;
	int ifindex = recvbu(&hoa,&coa,&seqno);
	pctime();
	fprintf(stderr,"recvbu returned\n");
	if(ifindex>0){
	  int imn=0;
	  for(;imn<MAX_MN_NUM;++imn)
	    if(memcmp(&mns[imn].hoav6,&hoa,sizeof(hoa))==0)
	      break;
	  fprintf(stderr,"imn found ... %d\n",imn);
	  if(imn==MAX_MN_NUM){
	    fprintf(stderr,"error! MN not found in list\n");
	  }
	  else {
	    if(mns[imn].last_bu_seq>seqno&&mns[imn].last_bu_seq-seqno<10){
	      fprintf(stderr,"sequence number invalid, ignore it!\n");
	      continue;
	    }
	    mns[imn].last_bu_seq = seqno;
	    mns[imn].last_bu_t = now;
	    if(IN6_IS_ADDR_V4MAPPED(&coa)){
	      //ipv4 coa
	      struct in_addr coav4;
	      ipv6_unmap_addr(&coa,&coav4.s_addr);
	      fprintf(stderr,"BU v4 coa: %d.%d.%d.%d\n",NIP4ADDR(&coav4));
	      int icoa=0;
	      for(;memcmp(mns[imn].coav4+icoa,&coav4,sizeof(struct in_addr))&&icoa<NIF;++icoa);
	      if(icoa==NIF){
		fprintf(stderr,"ERROR! BU's v4 COA not found in database.\n");
	      }
	      else if(mns[imn].active == icoa){
		fprintf(stderr,"coa do not change, do nothing\n");
		goto endofv4process;
	      }
	      else {
	      	fprintf(stderr,"imn = %d, mns[imn].active = %d icoa = %d\n",
			imn,mns[imn].active,
			icoa);
		int innat = 0;
		if(mns[imn].in_nat[icoa]){
		  innat = 1;
		  goto next_v4_process;
		  //current v4 coa is in NAT
		  fprintf(stderr,"current v4 coa is in NAT\n");
		  if(mns[imn].active>0){
		    //old coa is also IPV4
		    //check if this two are the same
		    if(mns[imn].active==icoa){
		      //do nothing
		      fprintf(stderr,"coa do not change, do nothing\n");
		    }
		    else{
		      fprintf(stderr,"icoa = %d, mns[imn].active = %d\n",
			      icoa,mns[imn].active);
		      if(mns[imn].in_nat[mns[imn].active]){
			//delete old xfrm policies
			stop_udp_encap(&mns[imn].hoav6,&mns[imn].hoav4,
				       ip_special(mns[imn].natv4+mns[imn].active)?
				       &hav4_2:&hav4,				       
				       //&hav4,
				       mns[imn].natv4+mns[imn].active,
				       666,mns[imn].nat_port[mns[imn].active],
				       UDP_ENCAP_PRIO);
		      }
		      //add new xfrm policies
		      start_udp_encap(&mns[imn].hoav6,&mns[imn].hoav4,
				      ip_special(mns[imn].natv4+icoa)?
				      &hav4_2:&hav4,				      
				      //&hav4,
				      mns[imn].natv4+icoa,
				      666,mns[imn].nat_port[icoa],
				      UDP_ENCAP_PRIO);
		      
		      if(!mns[imn].in_nat[mns[imn].active]){
			//old ipv4 coa not in NAT
			//delete tunnel64 and tunnel44
			fprintf(stderr,"tunnel64_del may happen at %d\n",__LINE__);
			tunnel44_del(mns[imn].tnl44_ifindex);
			tunnel64_del(mns[imn].tnl64_ifindex);
			//tunnel44_del(mns[imn].tnl44_ifindex);
			mns[imn].tnl66_ifindex=0;
			mns[imn].tnl64_ifindex=0;
			mns[imn].active=icoa;
		      }
		    }//mn[imn].active==icoa
		  }//active > 0
		  else {//active <=0
		    //old is not ipv4
		    //we first add xfrm policies
		    start_udp_encap(&mns[imn].hoav6,&mns[imn].hoav4,
				    ip_special(mns[imn].natv4+icoa)?
				    &hav4_2:&hav4,
				    mns[imn].natv4+icoa,
				    666,mns[imn].nat_port[icoa],
				    UDP_ENCAP_PRIO);
		    if(mns[imn].active<0){
		      //old is ipv6 coa
		      //delete the tunnel
		      route4_del(mns[imn].tnl66_ifindex, ROUTE_MOBILE,
				 &inaddr_any,0, //from src
				 &(mns[imn].hoav4),32, //to
				 0);
		      route_del(mns[imn].tnl66_ifindex, ROUTE_MOBILE,
				IP6_RT_PRIO_MIP6_FWD,//metrics
				&in6addr_any,0,//src
				&mns[imn].hoav6,128,0);
		      tunnel66_del(mns[imn].tnl66_ifindex);
		      mns[imn].tnl66_ifindex=0;
		    }
		  }
		  mns[imn].active=icoa;
		}//innat
		else {
		  //current v4 coa not in NAT
		  //first we add tunnel64
		next_v4_process:;
		  struct in6_addr mapped_hav4,mapped_coav4;
		  ipv6_map_addr(&mapped_hav4,&hav4);
		  ipv6_map_addr(&mapped_coav4,&coav4);
		  int tnl64_ifindex = tunnel64_add(&mapped_hav4,
						   &mapped_coav4,
						   ifindex);
		  //then we add tunnel44
		  int tnl44_ifindex = tunnel44_add(&mapped_hav4,
						   &mapped_coav4,
						   ifindex);
		  //we first create route in a contemporary route table
		  if(mns[imn].active<0||
		     mns[imn].active>0/*&&(mns[imn].in_nat[mns[imn].active]==0)*/){
		    //route already exists
		    //firstly we add route to a temporary route table 
		    //in order to avoid collision with existing routes
		    fprintf(stderr,"route4_add %d\n",__LINE__);
		    route4_add(tnl44_ifindex, ROUTE_MOBILE_TMP,
			       0,//flags
			       &inaddr_any,0, //from src
			       &(mns[imn].hoav4),32, //to
			       0);
		    route_add(tnl64_ifindex, ROUTE_MOBILE_TMP,
			      RTPROT_MIP,//proto, what does this do?
			      0,//flags
			      IP6_RT_PRIO_MIP6_FWD,//metrics
			      &in6addr_any,0,//src
			      &mns[imn].hoav6,128,0);
		    rule4_add(NULL, ROUTE_MOBILE_TMP,
			      RULE_MOBILE_PRIO-1, RTN_UNICAST,
			      &inaddr_any, 0, 
			      &(mns[imn].hoav4),32, //to
			      0);
		    rule_add (NULL, ROUTE_MOBILE_TMP,
			      RULE_MOBILE_PRIO-1, RTN_UNICAST,
			      &in6addr_any, 0,
			      &mns[imn].hoav6,128,0);
		  
		    //then we delete the existing route in ROUTE_MOBILE table
		    if(mns[imn].active<0){
		      //old route is ipv6
		      //delete the old tunnels 
		      route4_del(mns[imn].tnl66_ifindex, ROUTE_MOBILE,
				 &inaddr_any,0, //from src
				 &(mns[imn].hoav4),32, //to
				 0);
		      route_del(mns[imn].tnl66_ifindex, ROUTE_MOBILE,
				IP6_RT_PRIO_MIP6_FWD,//metrics
				&in6addr_any,0,//src
				&mns[imn].hoav6,128,0);
		      
		      tunnel66_del(mns[imn].tnl66_ifindex);
		      mns[imn].tnl66_ifindex=0;
		      //and the route are also deleted
		    }
		    else if(mns[imn].active>0){
		      //if(!mns[imn].in_nat[mns[imn].active]){
		      fprintf(stderr,"tunnel64_del may happen at %d\n",__LINE__);
                      //recover_count=1;
		      tunnel44_del(mns[imn].tnl44_ifindex);
		      tunnel64_del(mns[imn].tnl64_ifindex);
                      //recover_count=0;
		      //fprintf(stderr,"recover!!\n",__LINE__);
		      //tunnel44_del(mns[imn].tnl44_ifindex);
		      mns[imn].tnl64_ifindex=0;
		      mns[imn].tnl44_ifindex=0;
		      //}
		    }
		  }
		  //now we have to create the route on the main table
		  fprintf(stderr,"route4_add %d\n",__LINE__);
		  route4_add(tnl44_ifindex, ROUTE_MOBILE,
			     0,//flags
			     &inaddr_any,0, //from src
			     &(mns[imn].hoav4),32, //to
			     0);
		  route_add(tnl64_ifindex, ROUTE_MOBILE,
			    RTPROT_MIP,//proto, what does this do?
			    0,//flags
			    IP6_RT_PRIO_MIP6_FWD,//metrics
			    &in6addr_any,0,//src
			    &mns[imn].hoav6,128,0);
		  //at last we delete the temporary rules and routes
		  if(mns[imn].active>0&&
		     mns[imn].in_nat[mns[imn].active])
		    //delete existing UDP encapsulations
		    stop_udp_encap(&mns[imn].hoav6,&mns[imn].hoav4,
				   ip_special(mns[imn].natv4+mns[imn].active)?
				   &hav4_2:&hav4,
				   //&hav4,
				   mns[imn].natv4+mns[imn].active,
				   666,mns[imn].nat_port[mns[imn].active],
				   UDP_ENCAP_PRIO);
		  
		  if(mns[imn].active<0||
		     mns[imn].active>0/*&&(mns[imn].in_nat[mns[imn].active]==0)*/){
		    rule_del (NULL, ROUTE_MOBILE_TMP,
			      RULE_MOBILE_PRIO-1, RTN_UNICAST,
			      &in6addr_any, 0, 
			      &mns[imn].hoav6,128,0);
		    rule4_del(NULL, ROUTE_MOBILE_TMP,
			      RULE_MOBILE_PRIO-1, RTN_UNICAST,
			      &inaddr_any, 0, 
			      &(mns[imn].hoav4),32, //to
			      0);
		    route4_del(tnl44_ifindex, ROUTE_MOBILE_TMP,
			       &inaddr_any,0, //from src
			       &(mns[imn].hoav4),32, //to
			       0);
		    route_del(tnl64_ifindex, ROUTE_MOBILE_TMP,
			      IP6_RT_PRIO_MIP6_FWD,//metrics
			      &in6addr_any,0,//src
			      &mns[imn].hoav6,128,0);
		  }
		  mns[imn].active=icoa;
		  mns[imn].tnl64_ifindex=tnl64_ifindex;
		  mns[imn].tnl44_ifindex=tnl44_ifindex;
		  if(innat){
		    start_udp_encap(&mns[imn].hoav6,&mns[imn].hoav4,
				    ip_special(mns[imn].natv4+icoa)?
				    &hav4_2:&hav4,				      
				    //&hav4,
				    mns[imn].natv4+icoa,
				    666,mns[imn].nat_port[icoa],
				    UDP_ENCAP_PRIO);
		    
		  }
		}//not innat
		mns[imn].active=icoa;
	      endofv4process:
		fprintf(stderr,"sending ba %d no coa\n",
			sendba(ifindex,seqno,&hav6,&hoa,0));
		
		#if __DO_DATABUFF__
		fprintf(stderr,"WARNING: releasing databuff for\n"
			"%x:%x:%x:%x:%x:%x:%x:%x(%d.%d.%d.%d)\n"
		        "coa is %x:%x:%x:%x:%x:%x:%x:%x\n",
			NIP6ADDR(&mns[imn].hoav6),
			NIP4ADDR(&mns[imn].hoav4),
			NIP6ADDR(&coa));
		release_databuff(mns[imn].hoav6,mns[imn].hoav4,coa);
		#endif
		
	      }
	    }//ipv4 coa end
	    else {
	      //ipv6 coa
	      //check to see if it comes back!
	      if(memcmp(&mns[imn].hoav6,&coa,sizeof(struct in6_addr))==0){
		//go home
		if(mns[imn].active<0){
		  //old coa is ipv6
		  //tunnel66_del(mns[imn].tnl66_ifindex);
		  route4_del(mns[imn].tnl66_ifindex, ROUTE_MOBILE,
			     &inaddr_any,0, //from src
			     &(mns[imn].hoav4),32, //to
			     0);
		  route_del(mns[imn].tnl66_ifindex, ROUTE_MOBILE,
			    IP6_RT_PRIO_MIP6_FWD,//metrics
			    &in6addr_any,0,//src
			    &mns[imn].hoav6,128,0);
		  tunnel66_del(mns[imn].tnl66_ifindex);
		  //tnl_add_trash(mns[imn].tnl66_ifindex,66,now);
		  //tnl_trash[mns[imn].tnl66_ifindex]=66;		  
		  mns[imn].tnl66_ifindex=0;
		}
		else if(mns[imn].active>0){
		  if(mns[imn].in_nat[mns[imn].active]){
		    //old coa is in NAT
		    stop_udp_encap(&mns[imn].hoav6,&mns[imn].hoav4,
				   ip_special(mns[imn].natv4+mns[imn].active)?
				   &hav4_2:&hav4,
				   //&hav4,
				   mns[imn].natv4+mns[imn].active,
				   666,mns[imn].nat_port[mns[imn].active],
				   UDP_ENCAP_PRIO);
		    goto next_v6_process;
		  }
		  else {
		    //old coa is not in NAT
		  next_v6_process:
		    route4_del(mns[imn].tnl44_ifindex, ROUTE_MOBILE,
			     &inaddr_any,0, //from src
			     &(mns[imn].hoav4),32, //to
			     0);
		    route_del(mns[imn].tnl64_ifindex, ROUTE_MOBILE,
			      IP6_RT_PRIO_MIP6_FWD,//metrics
			      &in6addr_any,0,//src
			      &mns[imn].hoav6,128,0);
		    fprintf(stderr,"tunnel64_del may happen at %d\n",__LINE__);
		    tunnel44_del(mns[imn].tnl44_ifindex);
                    tunnel64_del(mns[imn].tnl64_ifindex);
		    mns[imn].tnl64_ifindex=0;
		    mns[imn].tnl44_ifindex=0;		    
		  }
		}
		mns[imn].active=0;
	      }
	      else {
		//not at home
		if(mns[imn].active<0&&
		   memcmp(&mns[imn].coav6,&coa,sizeof(struct in6_addr))==0){
		  //do nothing
		  fprintf(stderr,"do nothing, coa is current coa\n");
		  goto endofv6process;
		}
		else {
		  memcpy(&mns[imn].coav6,&coa,sizeof(struct in6_addr));
		  //we firstly crete the tunnel
		  
		  int tnl66_ifindex = tunnel66_add(&hav6,&coa,ifindex);
		  //in order not to conflict with the existing ones
		  //we firstly create the routes in a temporary route table
		  if(mns[imn].active<0||
		     mns[imn].active>0/*&&mns[imn].in_nat[mns[imn].active]==0*/){
		    fprintf(stderr,"route4_add %d\n",__LINE__);
		    route4_add(tnl66_ifindex, ROUTE_MOBILE_TMP,
			       0,//flags
			       &inaddr_any,0, //from src
			       &(mns[imn].hoav4),32, //to
			       0);
		    route_add(tnl66_ifindex, ROUTE_MOBILE_TMP,
			      RTPROT_MIP,//proto, what does this do?
			      0,//flags
			      IP6_RT_PRIO_MIP6_FWD,//metrics
			      &in6addr_any,0,//src
			      &mns[imn].hoav6,128,0);
		    rule4_add(NULL, ROUTE_MOBILE_TMP,
			      RULE_MOBILE_PRIO-1, RTN_UNICAST,
			      &inaddr_any, 0, 
			      &(mns[imn].hoav4),32, //to
			      0);
		    rule_add (NULL, ROUTE_MOBILE_TMP,
			      RULE_MOBILE_PRIO-1, RTN_UNICAST,
			      &in6addr_any, 0,
			      &mns[imn].hoav6,128,0);
		  }
		  //we now delete old tunnels
		  if(mns[imn].active<0){
		    route4_del(mns[imn].tnl66_ifindex, ROUTE_MOBILE,
			       &inaddr_any,0, //from src
			       &(mns[imn].hoav4),32, //to
			       0);
		    route_del(mns[imn].tnl66_ifindex, ROUTE_MOBILE,
			      IP6_RT_PRIO_MIP6_FWD,//metrics
			      &in6addr_any,0,//src
			      &mns[imn].hoav6,128,0);
		    //cannot be deleted
		    tunnel66_del(mns[imn].tnl66_ifindex);
		    //tnl_add_trash(mns[imn].tnl66_ifindex,66,now);
		    mns[imn].tnl66_ifindex=0;
		  }		  
		  else if(mns[imn].active>0){
		    //if(mns[imn].in_nat[mns[imn].active]==0){
		      fprintf(stderr,"tunnel64_del may happen at %d\n",__LINE__);
		      tunnel44_del(mns[imn].tnl44_ifindex);
                      tunnel64_del(mns[imn].tnl64_ifindex);
		      mns[imn].tnl64_ifindex=0;
		      mns[imn].tnl44_ifindex=0;
		      //}
		  }
		  //we now add routes in main table
		  fprintf(stderr,"route4_add %d\n",__LINE__);
		  route4_add(tnl66_ifindex, ROUTE_MOBILE,
			     0,//flags
			     &inaddr_any,0, //from src
			     &(mns[imn].hoav4),32, //to
			     0);
		  route_add(tnl66_ifindex, ROUTE_MOBILE,
			    RTPROT_MIP,//proto, what does this do?
			    0,//flags
			    IP6_RT_PRIO_MIP6_FWD,//metrics
			    &in6addr_any,0,//src
			    &mns[imn].hoav6,128,0);
		  if(mns[imn].active>0&&
		     mns[imn].in_nat[mns[imn].active]){
		    stop_udp_encap(&mns[imn].hoav6,&mns[imn].hoav4,
				   ip_special(mns[imn].natv4+mns[imn].active)?
				   &hav4_2:&hav4,
				   //&hav4,
				   mns[imn].natv4+mns[imn].active,
				   666,mns[imn].nat_port[mns[imn].active],
				   UDP_ENCAP_PRIO);		  
		  }
		  else if(mns[imn].active!=0){
		    //now we delete temporary routes and rules
		    rule_del (NULL, ROUTE_MOBILE_TMP,
			      RULE_MOBILE_PRIO-1, RTN_UNICAST,
			      &in6addr_any, 0, 
			      &mns[imn].hoav6,128,0);
		    rule4_del(NULL, ROUTE_MOBILE_TMP,
			      RULE_MOBILE_PRIO-1, RTN_UNICAST,
			      &inaddr_any, 0, 
			      &(mns[imn].hoav4),32, //to
			      0);
		    route4_del(tnl66_ifindex, ROUTE_MOBILE_TMP,
			       &inaddr_any,0, //from src
			       &(mns[imn].hoav4),32, //to
			       0);
		    route_del(tnl66_ifindex, ROUTE_MOBILE_TMP,
			      IP6_RT_PRIO_MIP6_FWD,//metrics
			      &in6addr_any,0,//src
			      &mns[imn].hoav6,128,0);
		  }
		  mns[imn].active=-1;
		  mns[imn].tnl66_ifindex=tnl66_ifindex;
		}
	      endofv6process:
		fprintf(stderr,"sending ba... %d, have coa\n",
			sendba(ifindex,seqno,&hav6,&hoa,&coa));
		#if __DO_DATABUFF__
		fprintf(stderr,"WARNING: releasing databuff for\n"
			"%x:%x:%x:%x:%x:%x:%x:%x(%d.%d.%d.%d)\n"
		        "coa is %x:%x:%x:%x:%x:%x:%x:%x\n",
			NIP6ADDR(&mns[imn].hoav6),
			NIP4ADDR(&mns[imn].hoav4),
			NIP6ADDR(&coa));
		release_databuff(mns[imn].hoav6,mns[imn].hoav4,coa);
		#endif
	      }
	    }
	  }
	}
	fprintf(stderr,"--------------------------------------\n");
      }
    }
    //--------------------clean up old bu lists---------------------
    int imn=0;
    for(;imn<MAX_MN_NUM;++imn)
      if(now - mns[imn].last_bu_t > 60){
	mn_state_cleanup(imn);
      }
  }
  int imn;
  for(imn=0;imn<MAX_MN_NUM;++imn)
    mn_state_cleanup(imn);
  fprintf(stderr,"HA: exiting from ha_working...\n");
}


int mn_list_init(char *mnlist_file)
{
  char line[1024];
  FILE *fp = fopen(mnlist_file,"r");
  if(fp==0)return -1;
  struct in6_addr hoav6;
  struct in_addr hoav4;
  int imn=0;
  memset(mns,0,sizeof(struct _mn)*MAX_MN_NUM);
  while(fgets(line,1024,fp)!=0){
    char *p=line;
    while(*p==' '||*p=='\n'||*p=='\r')++p;
    if(*p=='#')continue;
    char * q = p+1;
    while(*q!=' '&&*q!=0)++q;
    while(*q==' ')*q++=0;
    char * r = q;
    while(*r>='0'&&*r<='9'||*r=='.')++r;
    *r=0;
    if(*p==0)continue;
    inet_pton(AF_INET6,p,&hoav6);
    inet_pton(AF_INET,q,&hoav4);
    fprintf(stderr,"reading %x:%x:%x:%x:%x:%x:%x:%x -- %d.%d.%d.%d\n",
	    NIP6ADDR(&hoav6),NIP4ADDR(&hoav4));
    mns[imn].hoav6=hoav6;
    mns[imn].hoav4=hoav4;
    mns[imn].active=0;
    ++imn;
  }
  return 0;
}

//a:yhz
int ha_conf(char* fileName)
{
	FILE * fp = fopen(fileName,"r");
	uint8_t fill[4]={0};                          
	if(fp==0)
		return -1;
	char line[1024];
	while(fgets(line,1024,fp)){
		char * p = line;
		while(*p && *p==' ')
			++p;
		if(*p=='#')
			continue;
		char * q = p+1; 
		while(*q!=' '&&*q!='\n'&&*q&&*q!='\r')++q;
		*q=0;
		int flag =-1; 
		if(strcmp(p,"Special_IP")==0){
			flag=0;
		}    
		else if(strcmp(p,"HAV4_2")==0){
			flag = 1; 
		}    
		else if(strcmp(p,"HAV6")==0)
			flag = 2; 
		else if(strcmp(p,"HAV4")==0)
			flag = 3; 
		fprintf(stderr,"%s: ",p);
		p=q+1;
		while(*p&&*p==' ')
			++p;
		q=p+1;                                                                                           
		while(*q&&*q!=' '&&*q!='\n'&&*q!='\r')++q;
		*q=0;
		if(flag == 0){
			inet_pton(AF_INET, p, &special_ip);
			fprintf(stderr,"%d.%d.%d.%d\n", NIP4ADDR(&special_ip));      
		}
		else if(flag == 1){
			inet_pton(AF_INET,p,&hav4_2);
			fprintf(stderr,"%d.%d.%d.%d\n", NIP4ADDR(&hav4_2));
	   	}
		else if(flag ==2){
			inet_pton(AF_INET6,p,&hav6);
			fprintf(stderr,"%x:%x:%x:%x:%x:%x:%x:%x\n", NIP6ADDR(&hav6));      
		}
		else if(flag ==3){
		   	inet_pton(AF_INET,p,&hav4);
			fprintf(stderr,"%d.%d.%d.%d\n",	NIP4ADDR(&hav4));
		}
		if(fill[flag])return -1;
		fill[flag]=1;
	}
	fclose(fp);
	if(!(fill[0] && fill[1] && fill[2] && fill[3]))
		return -1;
  	return 0;
}


int main(int argc,char * argv[])
{
  mn_list_init("conf/mnlist.txt");

  //a:yhz
  if (ha_conf("conf/ha.conf") == -1)
  {
		inet_pton(AF_INET6,"2001:cc0:2026:3:21e:c9ff:fe2c:6db",&hav6);
		inet_pton(AF_INET,"10.21.5.74",&hav4);
  //--------------------------------used for local area network of my lab
		inet_pton(AF_INET,"159.226.39.212",&hav4_2);
		inet_pton(AF_INET,"10.21.5.54",&special_ip);
  }

  //-----------------------------------------------------------------------
  ha_init();
  //iface_proc_entries_init();
  struct in6_addr hoa,coa;
  //recvbu(&hoa,&coa);

  ha_working();
  ha_cleanup();
  return 0;
}

/*
 * REMAINING PROBLEMS
 * 1) Currnetly we do not consider neighbor discovery proxy 
      and arp proxy. This may cause some problem for Correspondent nodes
      at the same link with MN's home link to communicate with MN when MN
      is out.
      
      A temporary solution for this problem is to manually set route in CN 
      to force it to use HA as a forwarding router even if MN is at the same
      link with CN.

 */

