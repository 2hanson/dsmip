/*
 * mn.c
 * all functions used for mobile node
 * author: Lin Hui
 * mail: linhui08@gmail.com
 * last modified: JULY 9 2010
 */

#include "common.h"
#include "dhcp.h"
#include "icmp.h"
#include "rtnl.h"
#include "tunlctl.h"
#include "mn-xfrm.h"

#include <signal.h>
#include <sys/types.h>
#include <arpa/inet.h>
#include <sys/socket.h>
#define LEPHONE 0
#if LEPHONE
#include "udpencap.h"
#endif
#define MDBG dbg
#define pthread_dbg dbg
int mh_sock=0;

#define wlan_name  "wlan" /*"wlan"  /*eth0*/
#define gprs_name  "rmnet" /*"rmnet" /*eth1*/
//-------route in mobile table-------
#define MN_MOBILE_ROUTE_TABLE 250
#define MN_ROUTE_DEFAULT 254
#define MN_MOBILE_RULE_LOW_PRIO (RULE_MOBILE_PRIO+10) /*888+10*/
#define MN_MOBILE_RULE_HIGH_PRIO (RULE_MOBILE_PRIO-10) /*888-10*/

static uint16_t default_ifindex = 0;
static struct in_addr default_gateway;
#define MN_RULE_L 1  //low prio rule
#define MN_RULE_H 2  // high prio rule
#define MN_RULE_TYPE_WLAN 4 //wlan rule look up 250
#define MN_RULE_TYPE_GPRS 8 //gprs rule lookup 254
static uint32_t mn_rule_mobile = 0; 
//rule mn_rule_mobile : ip rule add pref RULE_MOBILE_PRIO+10 lookup 250
//-----------------------------------
static uint16_t preferred_ifindex = 0;
static uint16_t current_ifindex = 0;
static struct in6_addr current_coav6;
static struct in_addr  current_coav4;
static uint8_t current_coa_type = 0;//1 ipv4, 2 ipv4 without NAT, -1 ipv6, 
                         //0 at home or not configured
static int __BU_SEQ__ = 1;
uint32_t last_bu_t;
//----------------
static uint16_t tnl44_ifindex = 0;
static uint16_t tnl64_ifindex = 0;
static uint16_t tnl66_ifindex = 0;
  

//the address defined here should be changed according to 
//the mac address of HA and MN
//the default addresses, we will take this for test
#define _hoav6 "3ffe:501:ffff:100:221:e8ff:fefb:e658" 
#define _hoav4 "172.16.0.199"
#define _hav6  "2001:cc0:2026:3:21e:c9ff:fe2c:6db"
#define _hav4  "159.226.39.196"
#define _hagateway "172.16.0.1"
#define _hasubnet "255.255.255.0"


static struct in6_addr hoav6;
static struct in_addr  hoav4;
static struct in6_addr hav6;
static struct in_addr  hav4;
static struct in_addr  hagateway;
static struct in_addr  hasubnet;

struct _iface
{
  uint16_t ifindex;
  char ifname[100];
  int flags; //IFF_UP|IFF_RUNNING
  //------v6------
  uint8_t invalidv6;//the address here are 
                    //invalid because of handoff
  int last_ra_t;    //last time when ra is received
  struct in6_addr coav6;
  //------v4------
  uint8_t invalidv4;//address here are invalid
                    //because of handoff
  struct in_addr gateway;//gateway
  struct in_addr dns_server;//dnsserver
  struct in_addr dhcp_server;//dhcpserver
  struct in_addr subnet;
  struct in_addr coav4;//current v4 address in use
  uint32_t last_dhcp_t;//last time when dhcp ack packets are received
  uint8_t do_dhcp;//whether to use dhcp
  uint8_t dhcp_pkt_num;//num of dhcp request packets sent
  uint16_t dhcp_fd;//file discriptor for dhcp discovery receiver
  uint32_t dhcp_xid;//xid of last dhcp packet
  uint32_t last_nat_probe_t;//last time when nat probe is sent
};

#define NIF 3
static struct _iface ifaces[NIF];//at most ten interfaces are supported;
int subnet_len(struct in_addr subnet);
int sendbu(const struct in6_addr * ha, 
	   const struct in6_addr * hoa, 
	   const struct in6_addr * coa,
	   int seqno)
{
  
  fprintf(stderr,"sendbu: from %x:%x:%x:%x:%x:%x:%x:%x(hoa=%x:%x:%x:%x:%x:%x:%x:%x) to %x:%x:%x:%x:%x:%x:%x:%x\n",
  	  NIP6ADDR(coa),NIP6ADDR(hoa),NIP6ADDR(ha));

  static uint8_t _pad2[2] = { 0x01, 0x00 };
  struct sockaddr_in6 daddr;
  struct iovec iovec[3];
  struct msghdr msg;
  struct cmsghdr * cmsg;
  int cmsglen;
  struct in6_pktinfo pinfo;
  struct ip6_mh * mh;
  struct ip6_mh_binding_update * bu;
  struct ip6_mh_opt_altcoa * altcoa;
  int sockfd;
  iovec[0].iov_len = sizeof(struct ip6_mh_binding_update);//12
  iovec[0].iov_base = malloc(iovec[0].iov_len);
  mh=(struct ip6_mh *)iovec[0].iov_base;
  bu=(struct ip6_mh_binding_update *)iovec[0].iov_base;
  mh->ip6mh_proto = IPPROTO_NONE;
  mh->ip6mh_type = IP6_MH_TYPE_BU;
  mh->ip6mh_reserved = 0;
  mh->ip6mh_cksum = 0; /* kernel does this for us */
  mh->ip6mh_hdrlen = 3; //(12+2+18)/8-1=3
  bu->ip6mhbu_seqno = htons(seqno);//sequence number
  bu->ip6mhbu_flags = htons(IP6_MH_BU_ACK|IP6_MH_BU_HOME);
  bu->ip6mhbu_lifetime = htons(10000>>2);//time in unit of 4 sec
  iovec[1].iov_len=2;
  iovec[1].iov_base=_pad2;//2 byte padding
  iovec[2].iov_len=sizeof(struct ip6_mh_opt_altcoa);//18
  iovec[2].iov_base=malloc(iovec[2].iov_len);
  altcoa = (struct ip6_mh_opt_altcoa *)iovec[2].iov_base;
  altcoa->ip6moa_type = IP6_MHOPT_ALTCOA;
  altcoa->ip6moa_len = 16;
  altcoa->ip6moa_addr = *coa;
  daddr.sin6_family = AF_INET6;
  daddr.sin6_addr = *ha; //dst
  daddr.sin6_port = htons(IPPROTO_MH);
  pinfo.ipi6_addr = *hoa; //src
  pinfo.ipi6_ifindex = 2;//index of output interface eg. index of eth0
  cmsglen = CMSG_SPACE(sizeof(pinfo));
  cmsg = (struct cmsghdr*)malloc(cmsglen);
  memset(cmsg, 0, cmsglen);
  memset(&msg, 0, sizeof(msg));
  msg.msg_control = cmsg;
  msg.msg_controllen = cmsglen;
  msg.msg_iov = iovec;
  msg.msg_iovlen = 3;
  msg.msg_name = (void *)&daddr;
  msg.msg_namelen = sizeof(daddr);
  cmsg->cmsg_len = cmsglen;
  cmsg->cmsg_level = IPPROTO_IPV6;
  cmsg->cmsg_type = IPV6_PKTINFO;
  memcpy((unsigned char *)(cmsg+1), &pinfo, sizeof(pinfo));
  sockfd = socket(AF_INET6, SOCK_RAW, IPPROTO_MH);
  int val = 4;
  int ret=setsockopt(sockfd, IPPROTO_RAW, IPV6_CHECKSUM,
		 &val, sizeof(int));
  if(ret!=0)perror("send bu failed!");
  errno=0;
  tzset();
  time_t curtime = time(0);
  struct tm *curtm = localtime(&curtime);
  fprintf(stderr,"[%02d:%02d:%02d] send bu.\n",curtm->tm_hour,
	  curtm->tm_min,curtm->tm_sec);
  ret= sendmsg(sockfd, &msg, 0);
  if(ret<0)
    perror("sendbu failed.");
  close(sockfd);
  return ret;
}

int mh_cleanup()
{
  close(mh_sock);
  return 0;
}

int mh_init()
{
  int sockfd;
  int val = 1;
  sockfd = socket(AF_INET6, SOCK_RAW, IPPROTO_MH);
  int ret = setsockopt(sockfd, IPPROTO_IPV6, IPV6_RECVPKTINFO,
		       &val, sizeof(int));
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
  mh_sock = sockfd;
  return sockfd;
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
  

inline int mobile_route_update(int ifindex,
			       struct in_addr gateway)
{
  struct in_addr inaddr_any;
  inaddr_any.s_addr = 0;
  if(default_ifindex!=ifindex||
     memcmp(&gateway,&default_gateway,sizeof(struct in_addr))){
    //delete old route
    //add new route
    //fprintf(stderr,"updating mobile route table ... \n");
    if(default_ifindex){
      route4_del(default_ifindex,MN_MOBILE_ROUTE_TABLE,
		 &inaddr_any,0,
		 &inaddr_any,0,
		 &default_gateway);
      route4_del(default_ifindex,
		 254,//MN_MOBILE_ROUTE_TABLE,
		 &inaddr_any,0,
		 &default_gateway,32,
		 0);      
    }
    //fprintf(stderr,"let %d.%d.%d.%d/32 go through dev %d directly\n",
    //NIP4ADDR(&gateway),ifindex);
    fprintf(stderr,"adding route %d\n",__LINE__);
    route4_add(ifindex,
	       254,//MN_MOBILE_ROUTE_TABLE,
	       0,
	       &inaddr_any,0,//src
	       &gateway,32,
	       0);
    //fprintf(stderr,"let others  go through dev %d.%d.%d.%d\n",
    //NIP4ADDR(&gateway));
    fprintf(stderr,"adding route %d\n",__LINE__);
    route4_add(ifindex,
	       MN_MOBILE_ROUTE_TABLE,
	       0,
	       &inaddr_any,0,
	       &inaddr_any,0,
	       &gateway);
	
    /*char gw[100];
    sprintf(gw,"ip route add default via %d.%d.%d.%d dev wlan0 table 250",
	    NIP4ADDR(&gateway));
    fprintf(stderr,gw);
    system(gw);
    */
    memcpy(&default_gateway,&gateway,sizeof(struct in_addr));
    default_ifindex = ifindex;
    //fprintf(stderr,"updating mobile route end ... \n");
  }
  return 0;
}

int mobile_route_cleanup()
{
  struct in_addr inaddr_any;
  inaddr_any.s_addr = 0;
  if(default_ifindex&&default_gateway.s_addr){
    route4_del(default_ifindex,
	       254,//MN_MOBILE_ROUTE_TABLE,
	       &inaddr_any,0,
	       &default_gateway,32,
	       0);  
    route4_del(default_ifindex,
	       MN_MOBILE_ROUTE_TABLE,
	       &inaddr_any,0,
	       &inaddr_any,0,
	       &default_gateway);  
  }
  default_ifindex = 0;
  default_gateway.s_addr = 0;
  return 0;
}

int mn_dstopt_policies_add(struct in6_addr coa)
{
  struct xfrm_user_tmpl tmpl;
  struct xfrm_selector sel;
  create_dstopt_tmpl(&tmpl,&hav6,&hoav6);
  set_selector(&hav6,&hoav6,IPPROTO_MH,IP6_MH_TYPE_BU,0,0,&sel);
  int retp = xfrm_mip_policy_add(&sel,0,XFRM_POLICY_OUT,
				 XFRM_POLICY_ALLOW, 3, //priority
				 &tmpl, 1);
  if(retp <0)fprintf(stderr,"add dstopt policy failed\n");
  int rets = xfrm_state_add(&sel, IPPROTO_DSTOPTS, &coa, 0, 0);
  if(rets<0)fprintf(stderr,"add state failed\n");
  return retp == rets && rets == 0?0:-1;
}

int mn_dstopt_policies_del(struct in6_addr coa)
{
  struct xfrm_user_tmpl tmpl;
  struct xfrm_selector sel;
  create_dstopt_tmpl(&tmpl,&hav6,&hoav6);
  set_selector(&hav6,&hoav6,IPPROTO_MH,IP6_MH_TYPE_BU,0,0,&sel);  
  int retp = xfrm_mip_policy_del(&sel,XFRM_POLICY_OUT);
  int rets = xfrm_state_del(IPPROTO_DSTOPTS,&sel);
  return retp == 0 && rets ==0 ? 0:-1;
}

inline int do_handoff(struct in6_addr *coav6,
	       struct in_addr  *coav4,
	       uint16_t ifindex,
	       uint8_t type)//type = -1, v6coa, else 1 v4 coa
{
  fprintf(stderr,"do handoff called\n");
  //firstly update the database
  int i =0;
  for(;i<NIF&&ifaces[i].ifindex!=ifindex;++i);
  if(i==NIF)return -1;
  if(type==(uint8_t)-1){
    //ipv6
    memcpy(&ifaces[i].coav6,coav6,sizeof(struct in6_addr));
  }
  else if(type == 1)//will dhcp update it ?
    memcpy(&ifaces[i].coav4,coav4,sizeof(struct in_addr));
  //-----------------------------
  if(ifindex!=preferred_ifindex){
    fprintf(stderr,"WARNING: interface is not what we want.\n");
    return 0;
  }
  //check if coa has changed

  if(type==(uint8_t)-1&&
     (current_coa_type==(uint8_t)-1||current_coa_type==0)){
    if(memcmp(&current_coav6,coav6,sizeof(struct in6_addr))==0)
      return 0;//coa not change
  }
  if((type==1||type==2)&&(current_coa_type==1||current_coa_type==2)){
    if(memcmp(&current_coav4,coav4,sizeof(struct in_addr))==0)
      return 0;//coa not change, do nothing
  }
  current_ifindex = ifindex;//update ifindex that is current used for communication
  //current_ifindex must equal to preferred_ifindex
  if(current_ifindex!=preferred_ifindex){
    fprintf(stderr,"WARNING: current_ifindex(%d) does not equal to preferred_ifindex(%d)\n",
	    current_ifindex,
	    preferred_ifindex);
  }
  struct in_addr inaddr_any;
  inaddr_any.s_addr = 0;
  //ifindex = preffered_ifindex
  if(type==(uint8_t)-1){
    sendbu(&hav6,
	   &hoav6,
	   coav6,
	   __BU_SEQ__++);//firstly we send a bu from current path

    rule_add (NULL, MN_ROUTE_DEFAULT,
	      MN_MOBILE_RULE_HIGH_PRIO, 
	      RTN_UNICAST,
	      coav6,128,
	      &in6addr_any,0,
	      0);
    //ipv6 coa
    //first check if go home
    if(memcmp(coav6,&hoav6,sizeof(struct in6_addr))==0){
      //go home
      //fprintf(stderr,"addr4_add %d\n",__LINE__);
      addr4_add(&hoav4,subnet_len(hasubnet),ifindex);            
      //fprintf(stderr,"rule4_add %d\n",__LINE__);
      rule4_add(NULL, MN_MOBILE_ROUTE_TABLE,
		MN_MOBILE_RULE_HIGH_PRIO, RTN_UNICAST,
		&inaddr_any,0,
		&inaddr_any,0, //to
		0);
      mn_rule_mobile = MN_RULE_TYPE_WLAN|MN_RULE_H;
      //default_index = ifindex;
      mobile_route_update(ifindex,hagateway);
      //delete address on ifindex
      {
	int imn=0;
	while(imn<NIF&&ifaces[imn].ifindex!=ifindex)++imn;
	if(imn<NIF){
	  if(ifaces[imn].coav4.s_addr&&ifaces[imn].coav4.s_addr!=hoav4.s_addr){
	    addr4_del(&ifaces[i].coav4,	    
		      subnet_len(ifaces[i].subnet),
		      ifindex);
	  }
	  ifaces[imn].coav4.s_addr = hoav4.s_addr;
	  ifaces[imn].gateway.s_addr=hagateway.s_addr;
	  ifaces[imn].subnet = hasubnet;
	  ifaces[imn].invalidv4=0;
	}
      }
      
      if(current_coa_type==(uint8_t)-1){
	//old coa is ipv6
	//delete old route
	route4_del(tnl66_ifindex, ROUTE_MOBILE,
		   &inaddr_any,0, //from src                      
		   &inaddr_any,0, //to                     
		   0);
	route_del(tnl66_ifindex, ROUTE_MOBILE,
		  IP6_RT_PRIO_MIP6_FWD,//metrics                  
		  &in6addr_any,0,//src                            
		  &in6addr_any,0,0);
	mn_dstopt_policies_del(current_coav6);	
	tunnel66_del(tnl66_ifindex);
	tnl66_ifindex=0;
	fprintf(stderr,"rule_del %d\n",__LINE__);
	rule_del(NULL, MN_ROUTE_DEFAULT,
		 MN_MOBILE_RULE_HIGH_PRIO, 
		 RTN_UNICAST,
		 &current_coav6,128,
		 &in6addr_any,0,
		 0);
      }
      else if(current_coa_type==1||current_coa_type==2){
	//old coa is NAT v4
	//delete old rules
	if(mn_rule_mobile){
	  if(mn_rule_mobile&MN_RULE_TYPE_WLAN){
	    if(current_coav4.s_addr == hoav4.s_addr)
	      rule4_del(NULL, MN_MOBILE_ROUTE_TABLE,
			MN_MOBILE_RULE_HIGH_PRIO, RTN_UNICAST,
			&inaddr_any,0,
			&inaddr_any,0, //to
			0);
	    else 
	      rule4_del(NULL, MN_MOBILE_ROUTE_TABLE,
			MN_MOBILE_RULE_HIGH_PRIO, RTN_UNICAST,
			&current_coav4, 32,
			&inaddr_any,0, //to
			0);
	  }
	  if(mn_rule_mobile&MN_RULE_TYPE_GPRS){
	    rule4_del(NULL, MN_ROUTE_DEFAULT,
		      MN_MOBILE_RULE_HIGH_PRIO, RTN_UNICAST,
		      &current_coav4, 32,
		      &inaddr_any,0, //to
		      0);
	  }
	  mn_rule_mobile = MN_RULE_TYPE_WLAN|MN_RULE_H;
	}
	if(current_coa_type ==1){
	  stop_udp_encap(&hoav6,&hoav4,&current_coav4,&hav4,666,666,UDP_ENCAP_PRIO);
	}
	route4_del(tnl44_ifindex, ROUTE_MOBILE,
		   &inaddr_any,0, //from src                      
		   &inaddr_any,0, //to                     
		   0);
	route_del(tnl64_ifindex, ROUTE_MOBILE,
		  IP6_RT_PRIO_MIP6_FWD,//metrics                  
		  &in6addr_any,0,//src                            
		  &in6addr_any,0,0);
	tunnel64_del(tnl64_ifindex);
	tunnel44_del(tnl44_ifindex);
	tnl64_ifindex = tnl44_ifindex = 0;
      }
      //add coav4 into iface ifindex? add HA as the default gateway
      //ifindex must be of wlan0, or it is impossible to have ipv6 address
      current_coa_type = 0;
      memcpy(&current_coav6,coav6,sizeof(struct in6_addr));
      current_coav4.s_addr = hoav4.s_addr;

      sendbu(&hav6,
	     &hoav6,
	     coav6,
	     __BU_SEQ__++);
      //we need to add ipv4 routes and home address on the interface
      
      
    }//at home
    else {
      //fprintf(stderr,"not at home, start creating tunnels and handoff...\n");
      //not at home, ipv6
      //firstly add temp routes
      //firstly add temp route in temp table
      int tnl66_ifindex_tmp = tunnel66_add(coav6,&hav6,ifindex);
      addr_add(&hoav6,128,0,RT_SCOPE_UNIVERSE,tnl66_ifindex_tmp,100000,100000);
      //fprintf(stderr,"addr4_add %d\n",__LINE__);
      addr4_add(&hoav4,32,tnl66_ifindex_tmp);      
      fprintf(stderr,"adding route %d\n",__LINE__);
      route4_add(tnl66_ifindex_tmp,ROUTE_MOBILE_TMP,0,
		 &inaddr_any,0,&inaddr_any,0,0);
      fprintf(stderr,"adding routev6 %d\n",__LINE__);    
      route_add(tnl66_ifindex_tmp,ROUTE_MOBILE_TMP,
		RTPROT_MIP,0,
		IP6_RT_PRIO_MIP6_FWD,//metrics
		&in6addr_any,0,&in6addr_any,0,0);
      //fprintf(stderr,"rule4_add %d\n",__LINE__);
      rule4_add(NULL, ROUTE_MOBILE_TMP,
		RULE_MOBILE_PRIO-1, RTN_UNICAST,
		&inaddr_any, 0,
		&inaddr_any,0, 
		0);
      rule_add (NULL, ROUTE_MOBILE_TMP,
		RULE_MOBILE_PRIO-1, RTN_UNICAST,
		&in6addr_any,0,
		&in6addr_any,0,0);
      //then we delete old routes
      if(current_coa_type==0){
	//old coa is at home
	rule_del (NULL, MN_ROUTE_DEFAULT,
		  MN_MOBILE_RULE_HIGH_PRIO, 
		  RTN_UNICAST,
		  &hoav6,128,
		  &in6addr_any,0,
		  0);
	addr4_del(&hoav4,subnet_len(hasubnet),ifindex);
	//old coa is at home
      }
      else if(current_coa_type==(uint8_t)-1){
	//old coa is ipv6
	//delete old tunnels and routes
	route4_del(tnl66_ifindex, ROUTE_MOBILE,
		   &inaddr_any,0, //from src                      
		   &inaddr_any,0, //to                     
		   0);
	route_del(tnl66_ifindex, ROUTE_MOBILE,
		  IP6_RT_PRIO_MIP6_FWD,//metrics                  
		  &in6addr_any,0,//src                            
		  &in6addr_any,0,0);
	mn_dstopt_policies_del(current_coav6);	
	tunnel66_del(tnl66_ifindex);
	tnl66_ifindex=0;
	rule_del(NULL, MN_ROUTE_DEFAULT,
		 MN_MOBILE_RULE_HIGH_PRIO, 
		 RTN_UNICAST,
		 &current_coav6,128,
		 &in6addr_any,0,
		 0);
      }
      else if(current_coa_type==1||current_coa_type==2){
	//old coa is ipv4 with NAT
	//delete old encapsulation and routes
	if(current_coa_type ==1){//delete encapsulation
	  stop_udp_encap(&hoav6,&hoav4,
			 &current_coav4,&hav4,666,666,UDP_ENCAP_PRIO);
	}
	route4_del(tnl44_ifindex, ROUTE_MOBILE,
		   &inaddr_any,0, //from src                      
		   &inaddr_any,0, //to                     
		   0);
	route_del(tnl64_ifindex, ROUTE_MOBILE,
		  IP6_RT_PRIO_MIP6_FWD,//metrics                  
		  &in6addr_any,0,//src                            
		  &in6addr_any,0,0);
	tunnel64_del(tnl64_ifindex);
	tunnel44_del(tnl44_ifindex);
	tnl64_ifindex = tnl44_ifindex = 0;
	if(mn_rule_mobile){
	  if(mn_rule_mobile&MN_RULE_TYPE_WLAN){
	    rule4_del(NULL, MN_MOBILE_ROUTE_TABLE,
		      MN_MOBILE_RULE_HIGH_PRIO, RTN_UNICAST,
		      &current_coav4, 32,
		      &inaddr_any,0, //to
		      0);

	  }
	  if(mn_rule_mobile&MN_RULE_TYPE_GPRS){
	    rule4_del(NULL, MN_ROUTE_DEFAULT,
		      MN_MOBILE_RULE_HIGH_PRIO, RTN_UNICAST,
		      &current_coav4, 32,
		      &inaddr_any,0, //to
		      0);
	  }
	  mn_rule_mobile = 0;
	}
      }
      else {//ERROR
	return -1;
      }

      //then we add routes in MOBILE route table
      fprintf(stderr,"adding route %d\n",__LINE__);
      route4_add(tnl66_ifindex_tmp,ROUTE_MOBILE,0,
		 &inaddr_any,0,&inaddr_any,0,0);
      fprintf(stderr,"adding routev6 %d\n",__LINE__);    
      route_add(tnl66_ifindex_tmp,ROUTE_MOBILE,
		RTPROT_MIP,0,
		IP6_RT_PRIO_MIP6_FWD,//metrics
		 &in6addr_any,0,&in6addr_any,0,0);
      mn_dstopt_policies_add(*coav6);	
      //then we delete the temp route table
      route4_del(tnl66_ifindex_tmp, ROUTE_MOBILE_TMP,
		 &inaddr_any,0, //from src                        
		 &inaddr_any,0, //to                       
		 0);
      route_del(tnl66_ifindex_tmp, ROUTE_MOBILE_TMP,
		IP6_RT_PRIO_MIP6_FWD,//metrics                    
		&in6addr_any,0,//src                              
		&in6addr_any,0,0);
      rule4_del(NULL, ROUTE_MOBILE_TMP,
		RULE_MOBILE_PRIO-1, RTN_UNICAST,
		&inaddr_any, 0,
		&inaddr_any,0, 
		0);
      rule_del (NULL, ROUTE_MOBILE_TMP,
		RULE_MOBILE_PRIO-1, RTN_UNICAST,
		&in6addr_any,0,
		&in6addr_any,0,0);
      tnl66_ifindex = tnl66_ifindex_tmp;//update tunnel ifindex
      current_coa_type = -1;
      memcpy(&current_coav6,coav6,sizeof(struct in6_addr));
      sendbu(&hav6,
	     &hoav6,
	     coav6,
	     __BU_SEQ__++);    
    }
  }//coa is ipv6
  else if(type == 1|| type ==2){
    struct in6_addr mapped_v4coa ;
    ipv6_map_addr(&mapped_v4coa,coav4);
    //ipv4 coa
    if(memcmp(coav4,&hoav4,sizeof(struct in_addr))==0){
      //the address got is home address, do nothing
      //in fact this is impossible, if we do not set HA as a DHCP server
      //even if we set HA as a DHCP server, we should assign mn the HOAv4
      //that is impossible to get via DHCP
      return -1;
    }
    //when MN comes back to home, it use statically configured ip address
    //and will not do dhcp
    //we firstly add routes and then add udp encapsulation
    struct in6_addr mapped_coav4,mapped_hav4;
    ipv6_map_addr(&mapped_coav4,coav4);
    ipv6_map_addr(&mapped_hav4,&hav4);
    {
      //fprintf(stderr,"creating bypass rules .... \n");
      char ifname[100];
      int flag = 0;
      if_indextoname(ifindex,ifname);
      
      if(memcmp(ifname,wlan_name,sizeof(char)*strlen(wlan_name))==0){
	//wlan card
	//fprintf(stderr,"rule4_add %d\n",__LINE__);
	rule4_add(NULL, MN_MOBILE_ROUTE_TABLE,
		  MN_MOBILE_RULE_HIGH_PRIO, RTN_UNICAST,
		  coav4, 32,
		  &inaddr_any,0, //to
		  0);
	flag=MN_RULE_TYPE_WLAN;
      }
      else {
	//gprs card
	//fprintf(stderr,"rule4_add %d\n",__LINE__);
	rule4_add(NULL, MN_ROUTE_DEFAULT,
		  MN_MOBILE_RULE_HIGH_PRIO, RTN_UNICAST,
		  coav4, 32,
		  &inaddr_any,0, //to
		  0);
	flag=MN_RULE_TYPE_GPRS;
      }
      if(mn_rule_mobile){
	if(mn_rule_mobile&MN_RULE_TYPE_WLAN){//current we have rule for wlan
	  rule4_del(NULL, MN_MOBILE_ROUTE_TABLE,
		    MN_MOBILE_RULE_HIGH_PRIO, RTN_UNICAST,
		    current_coav4.s_addr==hoav4.s_addr?
		    &inaddr_any:&current_coav4, 
		    current_coav4.s_addr==hoav4.s_addr?
		    0:32,//from
		    &inaddr_any,0, //to
		    0);
	  
	}
	if(mn_rule_mobile&MN_RULE_TYPE_GPRS){//we have rule for gprs
	  rule4_del(NULL, MN_ROUTE_DEFAULT,
		    MN_MOBILE_RULE_HIGH_PRIO, RTN_UNICAST,
		    &current_coav4, 32,
		    &inaddr_any,0, //to
		    0);
	}
      }      
      mn_rule_mobile=flag|MN_RULE_H;
    }

    int tnl64_ifindex_tmp = tunnel64_add(&mapped_coav4,&mapped_hav4,ifindex);
    addr_add(&hoav6,128,0,RT_SCOPE_UNIVERSE,tnl64_ifindex_tmp,100000,100000);
    int tnl44_ifindex_tmp = tunnel44_add(&mapped_coav4,&mapped_hav4,ifindex);
    fprintf(stderr,"adding tunnel %d.%d.%d.%d to %d.%d.%d.%d\n",
	    NIP4ADDR(coav4),NIP4ADDR(&hav4));
    //fprintf(stderr,"addr4_add %d\n",__LINE__);
    addr4_add(&hoav4,32,tnl44_ifindex_tmp);      
    fprintf(stderr,"adding route %d\n",__LINE__);    
    route4_add(tnl44_ifindex_tmp,ROUTE_MOBILE_TMP,0,
	       &inaddr_any,0,&inaddr_any,0,0);
    //fprintf(stderr,"adding routev6 %d\n",__LINE__);    
    route_add(tnl64_ifindex_tmp,ROUTE_MOBILE_TMP,
	      RTPROT_MIP,0,
	      IP6_RT_PRIO_MIP6_FWD,//metrics
	      &in6addr_any,0,&in6addr_any,0,0);
    if(type == 1){
      if(current_coa_type==1)
	stop_udp_encap(&hoav6,&hoav4,
		       &current_coav4,&hav4,666,666,UDP_ENCAP_PRIO);
	start_udp_encap(&hoav6,&hoav4,coav4,&hav4,666,666,UDP_ENCAP_PRIO);
    }
    //fprintf(stderr,"rule4_add %d\n",__LINE__);    
    rule4_add(NULL, ROUTE_MOBILE_TMP,
	      RULE_MOBILE_PRIO-1, RTN_UNICAST,
	      &inaddr_any, 0,
	      &inaddr_any,0,0);
    rule_add (NULL, ROUTE_MOBILE_TMP,
	      RULE_MOBILE_PRIO-1, RTN_UNICAST,
	      &in6addr_any,0,
	      &in6addr_any,0,0);    
    /*if(current_coa_type==0&&
       !memcmp(&current_coav6,&hoav6,
	       sizeof(struct in6_addr))){
      //fprintf(stderr,"rule_del %d\n",__LINE__);
      //rule_del (NULL, MN_ROUTE_DEFAULT,
      //MN_MOBILE_RULE_HIGH_PRIO, 
      //RTN_UNICAST,
      //&hoav6,128,
      //&in6addr_any,0,
      //0);
      
      }*/
    //else 
    if(current_coa_type==(uint8_t)-1){
      //old coa is ipv6
      route4_del(tnl66_ifindex, ROUTE_MOBILE,
		 &inaddr_any,0, //from src                      
		 &inaddr_any,0, //to                     
		 0);
      route_del(tnl66_ifindex, ROUTE_MOBILE,
		IP6_RT_PRIO_MIP6_FWD,//metrics                  
		&in6addr_any,0,//src                            
		&in6addr_any,0,0);
      mn_dstopt_policies_del(current_coav6);	
      tunnel66_del(tnl66_ifindex);
      tnl66_ifindex=0;
      fprintf(stderr,"rule_del %d\n",__LINE__);
      rule_del(NULL, MN_ROUTE_DEFAULT,
	       MN_MOBILE_RULE_HIGH_PRIO, 
	       RTN_UNICAST,
	       &current_coav6,128,
	       &in6addr_any,0,
	       0);
    }
    else if(current_coa_type==1||current_coa_type==2){
      if(type==2){
	if(current_coa_type==1){
	  stop_udp_encap(&hoav6,&hoav4,
			 &current_coav4,&hav4,666,666,UDP_ENCAP_PRIO);
	}
      }//will not execute
      route4_del(tnl44_ifindex, ROUTE_MOBILE,
		 &inaddr_any,0, //from src                      
		 &inaddr_any,0, //to                     
		 0);
      route_del(tnl64_ifindex, ROUTE_MOBILE,
		IP6_RT_PRIO_MIP6_FWD,//metrics                  
		&in6addr_any,0,//src                            
		&in6addr_any,0,0);
      tunnel64_del(tnl64_ifindex);
      tunnel44_del(tnl44_ifindex);
      tnl64_ifindex = tnl44_ifindex = 0;      
      //old coa is ipv4 with NAT
    }
    //add new udp encapsulation and route
    //add new route to MOBILE route table
    fprintf(stderr,"adding route %d\n",__LINE__);
    route4_add(tnl44_ifindex_tmp,ROUTE_MOBILE,0,
	       &inaddr_any,0,&inaddr_any,0,0);
    //fprintf(stderr,"adding routev6 %d\n",__LINE__);    
    route_add(tnl64_ifindex_tmp,ROUTE_MOBILE,
	      RTPROT_MIP,0,
	      IP6_RT_PRIO_MIP6_FWD,//metrics
	      &in6addr_any,0,&in6addr_any,0,0);
    //delete temp route 
    route4_del(tnl44_ifindex_tmp, ROUTE_MOBILE_TMP,
	       &inaddr_any,0, //from src                        
	       &inaddr_any,0, //to                       
	       0);
    route_del(tnl64_ifindex_tmp, ROUTE_MOBILE_TMP,
	      IP6_RT_PRIO_MIP6_FWD,//metrics                    
	      &in6addr_any,0,//src                              
	      &in6addr_any,0,0);
    rule4_del(NULL, ROUTE_MOBILE_TMP,
	      RULE_MOBILE_PRIO-1, RTN_UNICAST,
	      &inaddr_any, 0,
	      &inaddr_any,0, 
	      0);
    rule_del (NULL, ROUTE_MOBILE_TMP,
	      RULE_MOBILE_PRIO-1, RTN_UNICAST,
	      &in6addr_any,0,
	      &in6addr_any,0,0);    
    current_coa_type = type;
    memcpy(&current_coav4,coav4,sizeof(struct in_addr));
    tnl64_ifindex = tnl64_ifindex_tmp;
    tnl44_ifindex = tnl44_ifindex_tmp;

    sendbu(&hav6,
	   &hoav6,
	   &mapped_v4coa,
	   __BU_SEQ__++);	
  }//ipv4 coa
  return 0;
}

int ap_off()
{
  //ap is off, change to gprs
  return 0;
}

int ap_move()
{
  //ap is ok, wlan0 is ok
  return 0;
}       


	       
struct rtnl_handle md_rth;

static int process_link(struct nlmsghdr *n, void *arg)
{
  struct ifinfomsg *ifi;
  struct rtattr *rta_tb[IFLA_MAX+1];

  if (n->nlmsg_len < NLMSG_LENGTH(sizeof(*ifi)))
    return -1;
  ifi = NLMSG_DATA(n);
  if (ifi->ifi_family != AF_UNSPEC && ifi->ifi_family != AF_INET6)
    return 0;
  if (ifi->ifi_type == ARPHRD_LOOPBACK ||
      ifi->ifi_type == ARPHRD_TUNNEL6  ||
      ifi->ifi_type == ARPHRD_TUNNEL   ||
      ifi->ifi_type == ARPHRD_SIT)
    return 0;
  memset(rta_tb, 0, sizeof(rta_tb));
  parse_rtattr(rta_tb, IFLA_MAX, IFLA_RTA(ifi),
	       n->nlmsg_len - NLMSG_LENGTH(sizeof(*ifi)));
  //ifi->ifi_index
  //ifi->ifi_flags IFF_UP IFF_RUNNING
  if (n->nlmsg_type == RTM_NEWLINK){
    fprintf(stderr,"LINK %d is up FLAG: %s %s\n",
	    ifi->ifi_index,
	    ifi->ifi_flags&IFF_UP?"IFF_UP":"IFF_DOWN",
	    ifi->ifi_flags&IFF_RUNNING?"IFF_RUNNING":"IFF_NOT_RUNNING");
    
    //-----------------------------------------------------------------
    //link flag may change from RUNNING|UP to NOT_RUNNING |NOT_UP
    //when link is down, we delete all of the route and related tunnels
    //initialize the system to the original state
    
    char ifname[100];
    if_indextoname(ifi->ifi_index,ifname);
    fprintf(stderr,"%s is up: ",ifname);
    if(memcmp(ifname,wlan_name,sizeof(char)*strlen(wlan_name))==0){
      //wlan card
      //fprintf(stderr,"wlan card\n");
      int i;
      for(i=0;i<NIF&&ifaces[i].ifindex!=ifi->ifi_index;++i);
      if(i==NIF)
	for(i=0;i<NIF&&ifaces[i].ifindex;++i);
      
      if(ifaces[i].ifindex==ifi->ifi_index){//interface already exist
	//check to see if flag have changed
	if((ifaces[i].flags&(IFF_UP|IFF_RUNNING))!=
	   (ifi->ifi_flags&(IFF_UP|IFF_RUNNING))){
	  fprintf(stderr,"wlan card flags changed...\n");
	  ifaces[i].flags = ifi->ifi_flags;
	  //flags changed
	  if((ifi->ifi_flags&(IFF_UP|IFF_RUNNING))==(IFF_UP|IFF_RUNNING)){
	    //ifconfig eth0 up
	    if(preferred_ifindex == 0)
	      preferred_ifindex = ifi->ifi_index;
	    ifaces[i].do_dhcp=1;
	    if(ifaces[i].dhcp_fd==0)
	      ifaces[i].dhcp_fd=
		raw_socket(ifaces[i].ifindex);
	    ifaces[i].dhcp_xid=887617890;
	    send_discover(ifaces[i].ifindex,
			  ifaces[i].ifname,
			  ifaces[i].dhcp_xid,
			  ifaces[i].coav4.s_addr);
	  }
	  else{
	    //ifconfig eth0 down
	    //we need to handoff to the other interfaces
	    //ap_off will do this for me
	    int imn=0;
	    while(imn<NIF&&ifaces[imn].ifindex!=ifi->ifi_index)++imn;
	    if(imn<NIF){
	      fprintf(stderr,"make iface %d invalid v4 and v6 coa\n",
		      imn);
	      ifaces[imn].invalidv6=1;
	      ifaces[imn].invalidv4=1;
	    }
	  }
	}
      }//
      else if((ifi->ifi_flags&IFF_RUNNING)&&(ifi->ifi_flags&IFF_UP)){
	//wlan card 
	//add new interface to database
	memset(&ifaces[i],0,sizeof(struct _iface));
	ifaces[i].ifindex = ifi->ifi_index;
	strcpy(ifaces[i].ifname,ifname);
	ifaces[i].flags=ifi->ifi_flags;
	ifaces[i].do_dhcp = 1;
	if(ifaces[i].dhcp_fd==0)
	  ifaces[i].dhcp_fd = 
	    raw_socket(ifaces[i].ifindex);
	ifaces[i].dhcp_pkt_num = 0;
	ifaces[i].invalidv4 = 1;
	ifaces[i].invalidv6 = 1;
	if(preferred_ifindex == 0)
	  preferred_ifindex = ifi->ifi_index;
      }
    }
    else if(memcmp(ifname,gprs_name,sizeof(char)*strlen(gprs_name))==0){
      fprintf(stderr,"gprs card\n");
      //gprs card
      int i;
      for(i=0;i<NIF&&ifaces[i].ifindex!=ifi->ifi_index;++i);
      if(i==NIF)
	for(i=0;i<NIF&&ifaces[i].ifindex;++i); //find an unused interface
      if(ifaces[i].ifindex == ifi->ifi_index){
	if(ifaces[i].flags&(IFF_UP|IFF_RUNNING)!=
	   ifi->ifi_flags&(IFF_UP|IFF_RUNNING)){
	  ifaces[i].flags=ifi->ifi_flags;
	  //flags changed
	  if(ifi->ifi_flags&(IFF_UP|IFF_RUNNING)){
	    //ifconfig gprs up
	    if(preferred_ifindex == 0)
	      preferred_ifindex = ifi->ifi_index;
	  }
	  else{
	    //ifconfig gprs down
	    //check if current ifindex is gprs, 
	    //if it is, delete the tunnels and routes
	  }
	}
      }
      else if((ifi->ifi_flags & (IFF_UP|IFF_RUNNING))==(IFF_UP|IFF_RUNNING)){
	//new gprs interface
	//add new interface to database
	memset(&ifaces[i],0,sizeof(struct _iface));
	ifaces[i].ifindex = ifi->ifi_index;
	strcpy(ifaces[i].ifname,ifname);
	ifaces[i].flags=ifi->ifi_flags;
	ifaces[i].invalidv4 = 1;
	ifaces[i].invalidv6 = 1;	
	if(preferred_ifindex == 0)
	  preferred_ifindex = ifi->ifi_index;
      }
    }
    //-----------------------------------------------------------------
  }//end of RTM_NEWLINK
  else if (n->nlmsg_type == RTM_DELLINK){
    fprintf(stderr,"LINK %d is DELETED \n",
	    ifi->ifi_index);
    //-----------------------------------------------------------------
    //link is deleted, I have not meet this scenario yet...
    //but when this happen, we do as if the link is down
    //-----------------------------------------------------------------
  }//end of RTM_DELLINK
  return 0;
}


static int process_addr(struct nlmsghdr *n, void *arg)
{
  struct in_addr inaddr_any;
  inaddr_any.s_addr = 0;

  struct ifaddrmsg *ifa;
  struct rtattr *rta_tb[IFA_MAX+1];

  if (n->nlmsg_len < NLMSG_LENGTH(sizeof(*ifa))){
    return -1;
  }

  ifa = NLMSG_DATA(n);

  memset(rta_tb, 0, sizeof(rta_tb));
  parse_rtattr(rta_tb, IFA_MAX, IFA_RTA(ifa),
	       n->nlmsg_len - NLMSG_LENGTH(sizeof(*ifa)));

  if (!rta_tb[IFA_ADDRESS] ){
    return -1;
  }
  if(!rta_tb[IFA_CACHEINFO]) {
    if(ifa->ifa_family!=AF_INET)
      return -1;
  }
  
  struct in6_addr *addr6;
  struct in_addr *addr4;

  if (n->nlmsg_type == RTM_NEWADDR){
    if (ifa->ifa_family == AF_INET6){
      //process_new_addr(ifa, rta_tb);
      addr6 = RTA_DATA(rta_tb[IFA_ADDRESS]);
      fprintf(stderr,"NEW ADDR %x:%x:%x:%x:%x:%x:%x:%x\n",
	      NIP6ADDR(addr6));
      //------------------------------------------------------
      //new IPv6 address is added
      //handoff may happen here
      //if at home, check if the system has moved
      //if not at home, check to see if the system has gone home
      //or if the system has moved to some other place
      if(ifa->ifa_scope == RT_SCOPE_UNIVERSE){
	//universe address
	//first check if we are at home
	int i = 0;
	for(;i<NIF;++i)
	  if(ifaces[i].ifindex==ifa->ifa_index)
	    break;
	if(i==NIF)
	  for(i=0;i<NIF&&ifaces[i].ifindex!=0;++i);
	if(ifaces[i].ifindex==0){
	  memset(&ifaces[i],0,sizeof(struct _iface));
	  ifaces[i].ifindex=ifa->ifa_index;
	  ifaces[i].flags=IFF_UP|IFF_RUNNING;
	  if_indextoname(ifaces[i].ifindex,ifaces[i].ifname);
	  if(memcmp(ifaces[i].ifname,gprs_name,sizeof(char)*strlen(gprs_name))
	     &&
	     memcmp(ifaces[i].ifname,wlan_name,sizeof(char)*strlen(wlan_name))){
	    memset(ifaces+i,0,sizeof(struct _iface));
	    return 0;
	  }
	  ifaces[i].invalidv6 = 0;
	  ifaces[i].invalidv4 = 1;
	  ifaces[i].do_dhcp = memcmp(ifaces[i].ifname,wlan_name,sizeof(wlan_name))==0;
	  if(ifaces[i].do_dhcp)
	    if(ifaces[i].dhcp_fd==0)		
	      if(ifaces[i].dhcp_fd==0)
		ifaces[i].dhcp_fd = 
		  //kernel_socket(0,DHCP_CLIENT_PORT,ifaces[i].ifname);
		  raw_socket(ifa->ifa_index);
	}
	ifaces[i].invalidv6=0;//ipv6 now is valid
	memcpy(&ifaces[i].coav6,addr6,sizeof(struct in6_addr));
	if(preferred_ifindex==0||preferred_ifindex == ifa->ifa_index){
	  preferred_ifindex = ifa->ifa_index;
	  do_handoff(addr6,0,ifa->ifa_index,-1);
	}
	//fprintf(stderr,"do_handoff returned %d\n",ret);
      }
      //------------------------------------------------------
    }
    else if (ifa->ifa_family == AF_INET){
      fprintf(stderr,"IPv4 ADDR addeded:");
      addr4 = RTA_DATA(rta_tb[IFA_ADDRESS]);
      if(addr4 == 0){
	fprintf(stderr,"rta_tb[IFA_ADDRESS] is NULL\n");
	return 0;
      }
      fprintf(stderr,"%d.%d.%d.%d\n",NIP4ADDR(addr4));

      if(memcmp(&hoav4,addr4,sizeof(struct in_addr))==0)
	return 0;//do not process the home address
      
      //------------------------------------------------------
      //new IPv4 address is added
      //Because HA do not have DHCP server, so when a new IPv4 address
      //is added, it may come from GPRS card or from wlan0 in foreign network
      //if the address is from GPRS card, we update the information and 
      //use it to send nat probes
      //if the address is from WLAN card, we have to check if we have moved
      //if we do have moved, we need to change the route and xfrm encapsulation
      //in fact, GPRS address may also change, but with very low possibility
      //------------------------------------------------------
      int i = 0;
      for(;i<NIF&&ifaces[i].ifindex!=ifa->ifa_index;++i);
      if(i==NIF){//the interface is not active, we activate it
	fprintf(stderr,"IPV4 NEW ADDR get but Interface not initialized."
		"Initializing iface %d \n",ifa->ifa_index);
	for(i=0;i<NIF&&ifaces[i].ifindex!=0;++i);//find an unused place
	if(i==NIF)return -1;
	//init the interface---------------------
	ifaces[i].ifindex=ifa->ifa_index;
	if_indextoname(ifaces[i].ifindex,ifaces[i].ifname);
	if(memcmp(ifaces[i].ifname,gprs_name,sizeof(char)*strlen(gprs_name))
	   &&
	   memcmp(ifaces[i].ifname,wlan_name,sizeof(char)*strlen(wlan_name))){
	  memset(ifaces+i,0,sizeof(struct _iface));
	  return 0;
	}
	fprintf(stderr,"check complete\n");
	ifaces[i].invalidv6=1;
	ifaces[i].invalidv4=0;
	ifaces[i].flags=IFF_UP|IFF_RUNNING;//it must be running and up
	ifaces[i].do_dhcp = 
	  memcmp(ifaces[i].ifname,gprs_name,sizeof(char)*strlen(gprs_name))?1:0;
	
	if(ifaces[i].do_dhcp)
	  if(ifaces[i].dhcp_fd==0)
	    ifaces[i].dhcp_fd= 
	      //kernel_socket(0,DHCP_CLIENT_PORT,ifaces[i].ifname);
	      raw_socket(ifaces[i].ifindex);
	
	ifaces[i].coav4 = *addr4;
	ifaces[i].dhcp_pkt_num=10;
	//let dhcp_worker send dhcp_discovery,not dhcp_select
	//because we do not know dhcp server
	if(preferred_ifindex==0){
	  //if we do not have preferred ifindex we init it to the 
	  //first active interface
	  preferred_ifindex=ifaces[i].ifindex;
	}
      }//i==NIF
      fprintf(stderr,"adding rules\n");
      //add rules
      ifaces[i].invalidv4=0;
      struct in_addr tmp_coav4_to_be_del;
      int tmp_coav4_to_be_del_subnetlen=-1;
      if(memcmp(&ifaces[i].coav4,addr4,sizeof(struct in_addr)))
	if(ifaces[i].coav4.s_addr){
	  fprintf(stderr,"addr4_del %d\n",__LINE__);
	  //addr4_del(&ifaces[i].coav4,
	  //subnet_len(ifaces[i].subnet),
	  //ifaces[i].ifindex);
	  tmp_coav4_to_be_del_subnetlen=subnet_len(ifaces[i].subnet);
	  tmp_coav4_to_be_del = ifaces[i].coav4;
	}
      memcpy(&ifaces[i].coav4,addr4,sizeof(struct in_addr));      
      
      //---------------------------------------
      if(ifa->ifa_index==preferred_ifindex||preferred_ifindex==0){
	preferred_ifindex = ifa->ifa_index;
	//if this is the preferred ifindex
	//only when the ipv6 is invalid will we use ipv4
	if(ifaces[i].invalidv6){//the ipv6 address is invalid
	  fprintf(stderr,"calling do_handoff... \n");

	  do_handoff(0,addr4,ifa->ifa_index,1);
	  fprintf(stderr,"do_handoff completed.\n");
	}
      }
      if(tmp_coav4_to_be_del_subnetlen!=-1){
	addr4_del(&tmp_coav4_to_be_del,
		  tmp_coav4_to_be_del_subnetlen,
		  ifa->ifa_index);
      }
    }
  }//RTM_NEWADDR
  else if (n->nlmsg_type == RTM_DELADDR){
    if (ifa->ifa_family == AF_INET6){
      addr6 = RTA_DATA(rta_tb[IFA_ADDRESS]);
      fprintf(stderr,"DEL ADDR %x:%x%x:%x:%x:%x:%x:%x\n",
	      NIP6ADDR(addr6));      
      //------------------------------------------------------
      //IPv6 address is deleted
      //this is trivial, this may happen when the address is expired
      //or when the link is deleted
      //we only deal with global scope addresses
      //------------------------------------------------------
      //what if current coa is deleted?
      //delete the routes and tunnels if the deleted coa is in use
      if(current_coa_type == (uint8_t)-1){
	if(ifa->ifa_index==current_ifindex&&
	   memcmp(&current_coav6,addr6,sizeof(struct in6_addr))==0){
	  //delete the routes and tunnels
	  route4_del(tnl66_ifindex, ROUTE_MOBILE,
		     &inaddr_any,0, //from src                      
		     &inaddr_any,0, //to                     
		     0);
	  route_del(tnl66_ifindex, ROUTE_MOBILE,
		    IP6_RT_PRIO_MIP6_FWD,//metrics                  
		    &in6addr_any,0,//src                            
		    &in6addr_any,0,0);
	  mn_dstopt_policies_del(current_coav6);	
	  tunnel66_del(tnl66_ifindex);
	  tnl66_ifindex=0;
	  current_coa_type=0;
	}
      }
    }
    else if(ifa->ifa_family == AF_INET){
      fprintf(stderr,"IPv4 ADDR deleted:");
      addr4 = RTA_DATA(rta_tb[IFA_ADDRESS]);
      fprintf(stderr,"%d.%d.%d.%d(%d)\n",NIP4ADDR(addr4),ifa->ifa_index);
      //------------------------------------------------------
      //del ipv4 address
      //we may delete ipv4 address because of DHCP update
      //but this is trivial
      //------------------------------------------------------
      if(current_coa_type==1||current_coa_type==2){
	if(ifa->ifa_index==current_ifindex&&
	   memcmp(&current_coav4,addr4,sizeof(struct in_addr))==0){
	  if(current_coa_type == 1){
	    //delete NAT encapsulation
	    stop_udp_encap(&hoav6,&hoav4,
			   &current_coav4,&hav4,666,666,UDP_ENCAP_PRIO);
	  }
	  //delete tunnels and routes
	  route4_del(tnl44_ifindex, ROUTE_MOBILE,
		     &inaddr_any,0, //from src                      
		     &inaddr_any,0, //to                     
		     0);
	  route_del(tnl64_ifindex, ROUTE_MOBILE,
		    IP6_RT_PRIO_MIP6_FWD,//metrics                  
		    &in6addr_any,0,//src                            
		    &in6addr_any,0,0);
	  tunnel64_del(tnl64_ifindex);
	  tunnel44_del(tnl44_ifindex);
	  tnl64_ifindex = tnl44_ifindex = 0;
	  current_coa_type=0;
	}
      }
      //delete the address in database
      int imn=0;
      for(;imn<NIF&&ifaces[imn].ifindex!=ifa->ifa_index;++imn);
      if(imn==NIF)return -1;
      if(memcmp(&ifaces[imn].coav4,addr4,sizeof(struct in_addr))==0){
	ifaces[imn].coav4.s_addr = 0;
	ifaces[imn].invalidv4=1;
      }
    }//AF_INET
  }//RTM_DELADDR
  return 0;
}


static int process_nlmsg(const struct sockaddr_nl *who,
			 struct nlmsghdr *n, void *arg)
{
  switch (n->nlmsg_type) {
  case RTM_NEWLINK:
  case RTM_DELLINK:
    process_link(n, arg);
    break;
  case RTM_NEWADDR:
  case RTM_DELADDR:
    process_addr(n, arg);
    break;
  default:
    break;
  }
  return 0;
}

int md_init()
{
  int err,val;
  if((err = rtnl_route_open(&md_rth, 0)) < 0)
    return err;
  val = RTNLGRP_LINK;
  if (setsockopt(md_rth.fd, SOL_NETLINK,
		 NETLINK_ADD_MEMBERSHIP, &val, sizeof(val)) < 0) {
    dbg("%d %s\n", __LINE__, strerror(errno));  
    return -1;
  }
  val = RTNLGRP_IPV6_IFADDR;
  if (setsockopt(md_rth.fd, SOL_NETLINK,
		 NETLINK_ADD_MEMBERSHIP, &val, sizeof(val)) < 0) {
    dbg("%d %s\n", __LINE__, strerror(errno));  
    return -1;
  }
  val = RTNLGRP_IPV4_IFADDR;
  if (setsockopt(md_rth.fd, SOL_NETLINK,
		 NETLINK_ADD_MEMBERSHIP, &val, sizeof(val)) < 0) {
    dbg("%d %s\n", __LINE__, strerror(errno));  
    return -1;
  }
  val = RTNLGRP_IPV6_IFINFO;
  if (setsockopt(md_rth.fd, SOL_NETLINK,
		 NETLINK_ADD_MEMBERSHIP, &val, sizeof(val)) < 0) {
    dbg("%d %s\n", __LINE__, strerror(errno));  
    return -1;
  }
 
  return 0;
}

int md_cleanup()
{
  close(md_rth.fd);
  return 0;
}

int keepworking = 1;

void _sigint_handler()
{
  fprintf(stderr,"STOP signal caught.\n");
  keepworking = 0;
}


void listen_udpencap_init()
{
  /* DSMIPv6: opening a socket for UDP encapsulated packets */
  int fd;
  int option = UDP_ENCAP_IP_VANILLA;
  struct sockaddr_in addr;
  fd = socket(PF_INET, SOCK_DGRAM, IPPROTO_UDP);
  if (fd < 0){
    perror("socket");
    fprintf(stderr, "UDP encap. reception will be disabled\n");
    return;
  }

  memset(&addr, 0, sizeof(addr));
  addr.sin_port = htons(DSMIP_UDP_DPORT);
  addr.sin_addr.s_addr = INADDR_ANY;
  int option2=1;
  if(setsockopt(fd,SOL_SOCKET,SO_REUSEADDR,&option2,sizeof(option2))<0){
    fprintf(stderr,"cannot resue\n");
  }
  if (bind(fd, (struct sockaddr *) &addr, sizeof(addr))){
    perror("bind");
    fprintf(stderr, "UDP encap. reception will be disabled\n");
    return;
  }

  if (setsockopt(fd, IPPROTO_UDP, UDP_ENCAP,
		 &option, sizeof(option)) != 0){
      perror("setsockopt");
      fprintf(stderr, "UDP encap. reception will be disabled\n");
      return;
  }
}

#if LEPHONE
int load_udpencap()
{
  FILE * fp = fopen("/system/bin/udpencap.ko","w");
  if(fp==0){
    fprintf(stderr,"open file error!\n");
    return -1;
  }
  int k = sizeof(udpencap);
  int i = 0;
  while(i<k){
    fwrite(udpencap+i,1,1,fp);
    i++;
  }
  fclose(fp);
  system("insmod /system/bin/udpencap.ko");
  return 0;
}
#endif
int mn_init()
{
  system("ifconfig ip6tnl0 up");
  system("ifconfig tunl0 up");
  system("ifconfig sit0 up");
  #if LEPHONE
  if(load_udpencap())return -1;
  #endif 
  struct in_addr inaddr_any;
  inaddr_any.s_addr = 0;
  iface_proc_entries_init("default");
  signal(SIGINT, _sigint_handler);
  int i = 0;
  memset(ifaces,0,sizeof(struct _iface)*NIF);
  memset(&current_coav6,0,sizeof(current_coav6));
  memset(&current_coav4,0,sizeof(current_coav4));
  current_coa_type=0;
  current_ifindex=0;
  preferred_ifindex = 0;
  tnl66_ifindex = 0;
  tnl64_ifindex = 0;
  tnl44_ifindex = 0;
  //once we receive ra and verify that we are at home
  //we will configure the ipv4 hoa into wlan interface.
  //but now we just clear everything.
  default_ifindex = 0;
  default_gateway.s_addr = 0;
  mh_init();
  md_init();
  tnl_init();
  ctrl_init();
  listen_udpencap_init();
  fprintf(stderr,"rule4_add %d\n",__LINE__);
  int ret = rule4_add(NULL, ROUTE_MOBILE,
            RULE_MOBILE_PRIO, 
	    RTN_UNICAST,
            &inaddr_any,0,
            &inaddr_any,0,
            0);
  ret |= rule_add (NULL, ROUTE_MOBILE,
            RULE_MOBILE_PRIO, 
	    RTN_UNICAST,
            &in6addr_any,0,
            &in6addr_any,0,
	    0);
  return ret;
}

int mn_cleanup()
{
  struct in_addr inaddr_any;
  inaddr_any.s_addr = 0;
  mh_cleanup();
  md_cleanup();
  if(mn_rule_mobile&MN_RULE_L){
    //clear rule
    /*rule4_del(0,
	      mn_rule_mobile&MN_RULE_TYPE_WLAN?
	      MN_MOBILE_ROUTE_TABLE:MN_ROUTE_DEFAULT,
	      MN_MOBILE_RULE_LOW_PRIO,
	      RTN_UNICAST,
	      current_coav4.s_addr == hoav4.s_addr?
	      &inaddr_any:&current_coav4,
	      current_coav4.s_addr == hoav4.s_addr?
	      0:32,
	      &inaddr_any,0,
	      0);
    */
    /*rule4_del(NULL, MN_MOBILE_ROUTE_TABLE,
	      MN_MOBILE_RULE_HIGH_PRIO, RTN_UNICAST,
	      current_coav4.s_addr==hoav4.s_addr?
	      &inaddr_any:&current_coav4, 
	      current_coav4.s_addr==hoav4.s_addr?
	      0:32,//from
	      &inaddr_any,0, //to
	      0);
    */
  }
  if(mn_rule_mobile&MN_RULE_H){
    rule4_del(0,
	      mn_rule_mobile&MN_RULE_TYPE_WLAN?
	      MN_MOBILE_ROUTE_TABLE:MN_ROUTE_DEFAULT,
	      MN_MOBILE_RULE_HIGH_PRIO,
	      RTN_UNICAST,
	      current_coav4.s_addr == hoav4.s_addr?
	      &inaddr_any:&current_coav4,
	      current_coav4.s_addr == hoav4.s_addr?
	      0:32,
	      &inaddr_any,0,
	      0);    
    /*rule4_del(0,
	      mn_rule_mobile&MN_RULE_TYPE_WLAN?
	      MN_MOBILE_ROUTE_TABLE:MN_ROUTE_DEFAULT,	      
	      MN_MOBILE_RULE_HIGH_PRIO,
	      RTN_UNICAST,
	      &current_coav4,32,
	      &inaddr_any,0,
	      0);
    */
  }
  mn_rule_mobile = 0;
  if(tnl66_ifindex){				
    route4_del(tnl66_ifindex, ROUTE_MOBILE,
	       &inaddr_any,0, //from src                      
	       &inaddr_any,0, //to                     
	       0);
    route_del(tnl66_ifindex, ROUTE_MOBILE,
	      IP6_RT_PRIO_MIP6_FWD,//metrics                  
	      &in6addr_any,0,//src                            
	      &in6addr_any,0,0);
    mn_dstopt_policies_del(current_coav6);	
    tunnel66_del(tnl66_ifindex);
    fprintf(stderr,"rule_del %d\n",__LINE__);
    rule_del(NULL, MN_ROUTE_DEFAULT,
	     MN_MOBILE_RULE_HIGH_PRIO, 
	     RTN_UNICAST,
	     &current_coav6,128,
	     &in6addr_any,0,
	     0);
  }
  
  if(tnl64_ifindex){
    route_del(tnl64_ifindex, ROUTE_MOBILE,
	      IP6_RT_PRIO_MIP6_FWD,//metrics                  
	      &in6addr_any,0,//src                            
	      &in6addr_any,0,0);
    tunnel64_del(tnl64_ifindex);
  }
  if(tnl44_ifindex){
    route4_del(tnl44_ifindex, ROUTE_MOBILE,
	       &inaddr_any,0, //from src                      
	       &inaddr_any,0, //to                     
	       0);
    tunnel44_del(tnl44_ifindex);
  }
  tnl66_ifindex = 0;
  tnl44_ifindex = 0;
  tnl64_ifindex = 0;
  //clear route table in MN_MOBILE_ROUTE_TABLE
  mobile_route_cleanup();
  
  tnl_cleanup();
  rule4_del(NULL, ROUTE_MOBILE,
            RULE_MOBILE_PRIO, 
	    RTN_UNICAST,
            &inaddr_any,0,
            &inaddr_any,0,
            0);
  rule_del(NULL, ROUTE_MOBILE,
            RULE_MOBILE_PRIO, 
	    RTN_UNICAST,
            &in6addr_any,0,
            &in6addr_any,0,
	    0);
  if(current_coa_type==1){
    stop_udp_encap(&hoav6,
		   &hoav4,
		   &current_coav4,
		   &hav4,
		   666,666,UDP_ENCAP_PRIO);
  }
  int i;
  for(i=0;i<NIF;++i){//clean up addresses we add
    if(ifaces[i].ifindex&&ifaces[i].coav4.s_addr){
      if(memcmp(ifaces[i].ifname,gprs_name,sizeof(char)*strlen(gprs_name)))
	//only delete the address configured on wlan card
	//becuase we do not configure gprs address
	//gprs address is considered as always usable
	addr4_del(&ifaces[i].coav4,
		  subnet_len(ifaces[i].subnet),
		  ifaces[i].ifindex);
    }
  }
  if(memcmp(&current_coav6,&hoav6,sizeof(struct in6_addr))==0){
    fprintf(stderr,"rule_del %d\n",__LINE__);
    rule_del (NULL, MN_ROUTE_DEFAULT,
	      MN_MOBILE_RULE_HIGH_PRIO, 
	      RTN_UNICAST,
	      &hoav6,128,
	      &in6addr_any,0,
	      0);
  }
  #if LEPHONE
  system("rmmod udpencap");
  #endif
  return 0;
}


int nat_fd;
int nat_probe_init()
{
  nat_fd = 0;
  //init nat_fd to receive NAT probe ACK
  return 0;
}

int nat_probe_cleanup()
{
  if(nat_fd)close(nat_fd);
  return 0;
}

int nat_probe_fd_set(fd_set *rfds, int maxfd)
{
  return maxfd;
}
 
int nat_probe_fd_check(fd_set *rfds)
{
  //check to see if HA has send me some nat-probe ack
  return 0;
}

inline int nat_probe_send(int ifindex, struct in_addr addrv4, 
			  struct in_addr *gateway)
{
  //send nat probe from some ifindex
  //firstly we need to set rules and policies 
  //to bypass the encapsulation and route
  
  //create a socket and bind on ifindex
  //create rules to bypass policies
  struct sockaddr_in dest, src;

  int sock_fd;
  int n;
  int flag=1;
  bzero(&dest,sizeof(dest));
  dest.sin_family = AF_INET;
  dest.sin_addr = hav4;
  dest.sin_port = htons(667);
  sock_fd = socket(AF_INET,SOCK_DGRAM,IPPROTO_UDP);
  src.sin_addr = addrv4;
  src.sin_port = htons(666);
  if(setsockopt(sock_fd, SOL_SOCKET, SO_REUSEADDR, &flag, sizeof(flag)) <0){
    fprintf(stderr,"udp rebind error\n");
  }
  if (bind(sock_fd, (struct sockaddr *) &src, sizeof(src))){
    perror("nat_probe sender bind");
    return 0;
  }
  struct NATINFO data;
  data.hoa=hoav6;
  data.port = 666;
  data.seqno = 12345;
  data.ifindex = ifindex;
  data.coa = addrv4;
  data.checksum = data.seqno^data.ifindex^data.port;
  
  //bypass rule ---------------------------------
  struct in_addr inaddr_any;
  inaddr_any.s_addr = 0;
  if(gateway){
    fprintf(stderr,"adding route to by pass rules gateway = %d.%d.%d.%d...\n",
	    NIP4ADDR(gateway));
  //we have to firstly add gateway route then we add the other route
      fprintf(stderr,"adding route %d\n",__LINE__);
      route4_add(ifindex,ROUTE_MOBILE_TMP,0,&addrv4,32,&inaddr_any,0,gateway);
      fprintf(stderr,"rule4_add %d\n",__LINE__);    
      rule4_add(NULL, ROUTE_MOBILE_TMP,
		RULE_MOBILE_PRIO-30, RTN_UNICAST,
		&addrv4,32,&inaddr_any,0,0);
  }
  else {
    //let the packet lookup default route table, (GPRS)
        fprintf(stderr,"rule4_add to default table. %d\n",__LINE__);    
	rule4_add(0,MN_ROUTE_DEFAULT,RULE_MOBILE_PRIO-30,RTN_UNICAST,
		  &addrv4,32,&inaddr_any,0,0);
  }

  //struct xfrm_selector bypass_sel;
  //set_v4selector(hav4, addrv4, IPPROTO_UDP, 0, 0, 0, &bypass_sel);
  //xfrm_mip_policy_add(&bypass_sel, 0, XFRM_POLICY_OUT, XFRM_POLICY_ALLOW, 2, NULL, 0);
  //---------------------------------------------
  
  n = sendto(sock_fd,&data,sizeof(data),0,(struct sockaddr *)&dest, sizeof(dest));
  if(-1==n){
    perror("send nat probe error\n");
  }
  else {
    time_t curtime = time(0);
    struct tm *curtm = localtime(&curtime);
    fprintf(stderr,"[%02d:%02d:%02d] send nat probe.\n",curtm->tm_hour,
	    curtm->tm_min,curtm->tm_sec);
  }
  
  
  //delete bypass rule --------------------------
  if(gateway){
    route4_del(ifindex,ROUTE_MOBILE_TMP,&addrv4,32,&inaddr_any,0,gateway);
    rule4_del(NULL, ROUTE_MOBILE_TMP,
       	      RULE_MOBILE_PRIO-30, RTN_UNICAST,
	      &addrv4,32,&inaddr_any,0,0);
    //fprintf(stderr,"by pass routes deleted\n");
  }
  else {
    //delete route which let the packet lookup default route table
    rule4_del(0,MN_ROUTE_DEFAULT,
	      RULE_MOBILE_PRIO-30, RTN_UNICAST,	      
	      &addrv4,32,&inaddr_any,0,0);
  } 
  
  //xfrm_mip_policy_del(&bypass_sel,XFRM_POLICY_OUT);
  //---------------------------------------------
  
  close(sock_fd);
  return n;
}

int nat_probe_worker()
{
  //in fact this is only necessary for those interfaces that do not take dhcp 
  //interfaces using dhcp will send nat probes when they are updating address
  //information.
  int now = uptime();
  int i = 0;
  for(i=0;i<NIF;++i)
    if(ifaces[i].ifindex&&
       (ifaces[i].flags&(IFF_UP|IFF_RUNNING))==(IFF_UP|IFF_RUNNING)&&
       ifaces[i].invalidv4==0){
      if(abs(ifaces[i].last_nat_probe_t-now)>20){
	nat_probe_send(ifaces[i].ifindex,
		       ifaces[i].coav4,
		       ifaces[i].gateway.s_addr==0?0:&ifaces[i].gateway);
	ifaces[i].last_nat_probe_t = now;
      }
    }
  return 0;
}
 
int ba_fd_init()
{
  return 0;
}

int ba_fd_cleanup()
{
  return 0;
}

int ba_fd_set(fd_set *rfds, int maxfd)
{
  return maxfd;
}

int ba_fd_checker(fd_set *rfds)
{
  //check to see if we have received ba
  return 0;
}

int bu_worker()
{
  //send bu to HA periodly 
  int now = uptime();
  if(abs(last_bu_t-now)>10){
    if(current_coa_type==(uint8_t)-1){
      sendbu(&hav6,&hoav6,&current_coav6,__BU_SEQ__++);
    }
    else if(current_coa_type==1||
	    current_coa_type==2){
      struct in6_addr mapped_coa;
      ipv6_map_addr(&mapped_coa,&current_coav4);
      sendbu(&hav6,&hoav6,&mapped_coa,__BU_SEQ__++);
    }
    last_bu_t = now;
  }
  
  return 0;
}
 

//use UDP packets for mobility control
int ctrl_fd = 0;
int ctrl_init()
{
  struct sockaddr_in addr;
  ctrl_fd = socket(PF_INET, SOCK_DGRAM, IPPROTO_UDP);
  if (ctrl_fd < 0){
      perror("socket");
      fprintf(stderr, "UDP encap. reception will be disabled\n");
      return -1;
  }
  memset(&addr, 0, sizeof(addr));
  addr.sin_port = htons(CTRL_PORT);//CTRL_PORT(7777) is defined in common.h 
  addr.sin_addr.s_addr = INADDR_ANY;
  if (bind(ctrl_fd, (struct sockaddr *) &addr, sizeof(addr))){
      perror("bind");
      fprintf(stderr, "UDP encap. reception will be disabled\n");
      return -1;
  }
  return ctrl_fd;
}

int ctrl_fd_set(fd_set *rfds, int maxfd)
{
  if(maxfd<ctrl_fd)maxfd=ctrl_fd;
  FD_SET(ctrl_fd,rfds);
  return maxfd;
}


#define CTRL_CMD_LSCOA   1
#define CTRL_CMD_HANDOFF 2 
//handoff from current interface to alternative interface
//we do not check whether alternative interface is ok
#define CTRL_CMD_AP_OFF  3
#define CTRL_CMD_AP_ON   4
#define CTRL_CMD_AP_MOVE 5
 
struct CTRL_CMD{
  uint16_t cmd;//lscoa //handoff ifindex
  
  uint16_t data; //if handoff, data contains ifindex
  uint16_t seqno;
  uint16_t chksum;//cmd^data^seqno
}__attribute((packed));

struct CTRL_CMD_ACK
{
  uint16_t seqno;
  uint16_t chksum;
  uint16_t acklen;//length of ack data
  uint8_t ack[300];
}__attribute((packed));


int ctrl_fd_check(fd_set *rfds)
{
  if(FD_ISSET(ctrl_fd,rfds)){
    struct CTRL_CMD cmd_data;
    struct sockaddr_in rin;
    int address_size = sizeof (rin);
    int n = recvfrom (ctrl_fd, &cmd_data, sizeof(cmd_data),0,
		      (struct sockaddr *) &rin,
		      &address_size);
    char ack[300]={0},tmpbuf[100];
    int i=0;
    struct CTRL_CMD_ACK ctrl_ack;
    ctrl_ack.seqno = cmd_data.seqno;
    ctrl_ack.chksum = cmd_data.chksum;
    
    switch(cmd_data.cmd){
    case CTRL_CMD_LSCOA:
      sprintf(ack,
	      "preferred_ifindex = %d, default_ifindex = %d\n"
	      "current coav6 = %x:%x:%x:%x:%x:%x:%x:%x, "
	      "current coav4=%d.%d.%d.%d\n",
	      preferred_ifindex,
	      default_ifindex,
	      NIP6ADDR(&current_coav6),
	      NIP4ADDR(&current_coav4)
	      );
      
      for(i=0;i<NIF;++i){
	if(ifaces[i].ifindex){
	  sprintf(tmpbuf,"iface %d(%s):\n",ifaces[i].ifindex,ifaces[i].ifname);
	  strcat(ack,tmpbuf);
	  if(ifaces[i].invalidv6==0){
	    sprintf(tmpbuf,"[%c]IPV6 COA: %x:%x:%x:%x:%x:%x:%x:%x\n",
		    ((current_coa_type==(uint8_t)-1||
		      current_coa_type==0)&&
		     memcmp(&current_coav6,&ifaces[i].coav6,sizeof(struct in6_addr))==0)?
		    'x':'o',		    
		    NIP6ADDR(&ifaces[i].coav6));
	    strcat(ack,tmpbuf);
	  }
	  if(ifaces[i].invalidv4==0){
	    sprintf(tmpbuf,"[%c]IPV4 COA: %d.%d.%d.%d\n",
		    ((current_coa_type==0
		      ||current_coa_type==1
		      ||current_coa_type==2)&&
		     memcmp(&current_coav4,&ifaces[i].coav4,sizeof(struct in_addr))==0)?
		    'x':'o',
		    NIP4ADDR(&ifaces[i].coav4));
	    strcat(ack,tmpbuf);
	    
	  }
	}
      }
      //fprintf(stderr,"%s",ack);
      ctrl_ack.acklen=strlen(ack);
      memcpy(ctrl_ack.ack,ack,sizeof(ack));
      sendto(ctrl_fd,&ctrl_ack,sizeof(ctrl_ack),0,(struct sockaddr*)&rin,
	     sizeof(rin));
      break;

    case CTRL_CMD_HANDOFF:
      ack[0]=0;
      preferred_ifindex = cmd_data.data;
      if(current_ifindex==preferred_ifindex){
	sprintf(tmpbuf,"system is already running on interface %d\n",preferred_ifindex);
	strcat(ack,tmpbuf);
      }
      else {
	sprintf(tmpbuf,"moving to interface %d...\n",preferred_ifindex);
	strcat(ack,tmpbuf);
	int imn=0;
	for(imn=0;imn<NIF&&ifaces[imn].ifindex!=preferred_ifindex;++imn);
	if(imn==NIF){
	  sprintf(tmpbuf,"failed! no such interface!\n");
	  strcat(ack,tmpbuf);
	}
	else{
	  if(ifaces[imn].invalidv6==0){
	    sprintf(tmpbuf,"have ipv6 address %x:%x:%x:%x:%x:%x:%x:%x, using it!\n",
		    NIP6ADDR(&ifaces[imn].coav6));
	    strcat(ack,tmpbuf);
	    do_handoff(&ifaces[imn].coav6,&ifaces[imn].coav4,ifaces[imn].ifindex,-1);
	  }	  
	  else if(ifaces[imn].invalidv4==0){
	    sprintf(tmpbuf,"have ipv4 address %d.%d.%d.%d, using it!\n",
		    NIP4ADDR(&ifaces[imn].coav4));
	    strcat(ack,tmpbuf);
	    do_handoff(&ifaces[imn].coav6,&ifaces[imn].coav4,ifaces[imn].ifindex,1);
	  }
	  else {	  
	    sprintf(tmpbuf,"interface found but the addresses there are not valid!"
		    "I will wait to handoff to interface %d when the addresses are"
		    "available!",ifaces[imn].ifindex);
	    strcat(ack,tmpbuf);
	  }
	}//imn != NIF
      }//current_ifindex!=preferred_ifindex
      ctrl_ack.acklen=strlen(ack);
      memcpy(ctrl_ack.ack,ack,sizeof(ack));
      sendto(ctrl_fd,&ctrl_ack,sizeof(ctrl_ack),0,(struct sockaddr*)&rin,
	     sizeof(rin));      
      break;
    default:
      break;
    }
  }
  return 0;
}

int ctrl_cleanup()
{
  close(ctrl_fd);
  return 0;
}


#define __XID__ 887617890
int dhcp_fd_set(fd_set * rfds, int maxfd)
{
  //maximum fd is returned
  int i=0;
  for(;i<NIF;++i){
    if((ifaces[i].flags&(IFF_UP|IFF_RUNNING))==(IFF_UP|IFF_RUNNING)){
      if(ifaces[i].do_dhcp&&ifaces[i].dhcp_fd){
	FD_SET(ifaces[i].dhcp_fd,rfds);
	if(maxfd<ifaces[i].dhcp_fd)
	  maxfd=ifaces[i].dhcp_fd;
      }
    }
  }
  return maxfd;
}

int subnet_len(struct in_addr subnet)
{
  if(subnet.s_addr==0)return 0;
  int ret = 0;
  while(subnet.s_addr&(1<<ret)==0)++ret;
  return 32-ret;
}

inline int dhcp_fd_check(const fd_set *rfds)
{
  int i;
  for(i=0;i<NIF;++i)
    if((ifaces[i].flags&(IFF_UP|IFF_RUNNING))==(IFF_UP|IFF_RUNNING)){
      if(ifaces[i].do_dhcp){
	if(FD_ISSET(ifaces[i].dhcp_fd,rfds)){
	  //fprintf(stderr,"checking interface(dhcp) %s ... \n",ifaces[i].ifname);
	  //every packet will be checked
	  //receive dhcp data
	  struct dhcp_message packet;
	  int len = get_raw_packet(&packet,ifaces[i].dhcp_fd);
	  if(len<=0)continue;
	  if(packet.xid != ifaces[i].dhcp_xid)continue;
	  uint8_t *message = get_option(&packet,DHCP_MESSAGE_TYPE);
	  if(*message != DHCPOFFER&&*message != DHCPACK)continue;
	  ifaces[i].dhcp_pkt_num=0;//clear packet counter
	  memcpy(&ifaces[i].gateway.s_addr,
		 get_option(&packet,DHCP_ROUTER),4);
	  memcpy(&ifaces[i].dhcp_server.s_addr,
		 get_option(&packet,DHCP_SERVER_ID),4);
	  int old_subnet_len = subnet_len(ifaces[i].subnet);
	  memcpy(&ifaces[i].subnet.s_addr,
		 get_option(&packet,DHCP_SUBNET),4);
	  memcpy(&ifaces[i].dns_server.s_addr,
		 get_option(&packet,DHCP_DNS_SERVER),4);
	  //we ad it to the interface
	  if(ifaces[i].coav4.s_addr!=
	     packet.yiaddr){
	    if(ifaces[i].coav4.s_addr)
	      fprintf(stderr,
		      "coav4 changed, deleting the old ones and add new one\n");
	    //delete the old addr and add the new one
	    fprintf(stderr,"adding ipv4 address %d.%d.%d.%d to the interface.\n",NIP4ADDR((struct in_addr*)&packet.yiaddr));
	    fprintf(stderr,"addr4_add %d\n",__LINE__);
	    addr4_add((struct in_addr*)&packet.yiaddr,
		      subnet_len(ifaces[i].subnet),
		      ifaces[i].ifindex);
	    if(ifaces[i].coav4.s_addr!=0){
	      addr4_del(&ifaces[i].coav4,old_subnet_len,ifaces[i].ifindex);  
	    }
	    //it will cause handoff if necessary
	    ifaces[i].coav4.s_addr = packet.yiaddr;
	    //optimization:
	    //we can add do_handoff here to make the handoff process faster
	    //or we need to wait for the loop to get the address add event
	    //and perform handoff
	  }
	  if(ifaces[i].ifindex==preferred_ifindex||
	     preferred_ifindex==0){
	    //I must be configuring the wlan interface
	    //because I do not run dhcp on gprs links
	    mobile_route_update(ifaces[i].ifindex,
				ifaces[i].gateway);
	  }
	  
	  ifaces[i].invalidv4=0;
	  //send nat probes when we receive the dhcp offer/ack
	  nat_probe_send(ifaces[i].ifindex, ifaces[i].coav4, &ifaces[i].gateway);
	  int now = uptime();
	  ifaces[i].last_nat_probe_t = now;
	  
	}
      }
    }
  return 0;
}


int dhcp_worker()
{
  //fprintf(stderr,"dhcp worker ... \n");
  int now = uptime();
  int i;
  for(i=0;i<NIF;++i){
    //fprintf(stderr,"ifaces[%d].flag = %s, do_dhcp = %d\n",
    //i,
    //(ifaces[i].flags&(IFF_RUNNING|IFF_UP))==(IFF_RUNNING|IFF_UP)?
    //"IFF_RUNNING|IFF_UP":"NOT RUNNING",
    //ifaces[i].do_dhcp);
      if(((ifaces[i].flags&(IFF_RUNNING|IFF_UP))==(IFF_RUNNING|IFF_UP))
       &&ifaces[i].do_dhcp){
	//fprintf(stderr,"checking iface %d(%s)\n",ifaces[i].ifindex,ifaces[i].ifname);
      if(ifaces[i].invalidv6){//if v6 is valid we ignore it
	if(ifaces[i].invalidv4==0){//ipv4 is valid, limite the request rate
	  if(now - ifaces[i].last_dhcp_t<20)continue;//check next interface
	}
	else if(now - ifaces[i].last_dhcp_t<1)continue;	//limite the rate
	ifaces[i].last_dhcp_t=now;
	//ifaces[i].dhcp_fd=raw_socket(ifaces[i].ifindex);
	if(ifaces[i].invalidv4||ifaces[i].dhcp_pkt_num>3){
	  //we send dhcp discover
	  ifaces[i].dhcp_xid=__XID__;
	  send_discover(ifaces[i].ifindex,
			ifaces[i].ifname,
			ifaces[i].dhcp_xid,
			ifaces[i].coav4.s_addr);
	}
	else {
	  //we send dhcp request
	  send_selecting(ifaces[i].ifindex,
			 ifaces[i].ifname,
			 ifaces[i].dhcp_xid,
			 ifaces[i].dhcp_server.s_addr,
			 ifaces[i].coav4.s_addr);
	  ++ifaces[i].dhcp_pkt_num;
	}
      }
    }
  }
  return 0;
}


int link_event_fd_set(fd_set *rfds,int maxfd)
{
  if(maxfd<md_rth.fd)maxfd=md_rth.fd;
  FD_SET(md_rth.fd,rfds);
  return maxfd;
}
  
int link_event_fd_check(fd_set *rfds)
{
  if(FD_ISSET(md_rth.fd,rfds)){
    rtnl_listen(&md_rth, process_nlmsg, NULL);
  }
  return 0;
}

int mn_worker()
{
  for(;keepworking;){
    int max_fd = 0;
    fd_set rfds;
    FD_ZERO(&rfds);
    max_fd=link_event_fd_set(&rfds,max_fd);
    max_fd=dhcp_fd_set(&rfds,max_fd);
    max_fd=nat_probe_fd_set(&rfds,max_fd);
    max_fd=ctrl_fd_set(&rfds,max_fd);
    struct timeval tv;
    tv.tv_sec = 1;
    tv.tv_usec = 0;
    //ndisc_send_rs(2,&in6addr_any,
    //&in6addr_all_routers_mc);
    int retval = select(max_fd+1,&rfds,0,0,&tv);
    //messages:
    if(retval>0){
      link_event_fd_check(&rfds);
      dhcp_fd_check(&rfds);
      nat_probe_fd_check(&rfds);//check to see if nat probes have ack
      ctrl_fd_check(&rfds);
    }
    //do other things
    bu_worker();
    dhcp_worker();
    nat_probe_worker();
  }
  fprintf(stderr,"existing from mn_worker ... \n");
  return 0;
}

int mn_conf(char * filename)
{
  FILE * fp = fopen(filename,"r");
  uint8_t fill[4]={0};
  if(fp==0)return -1;
  char line[1024];
  while(fgets(line,1024,fp)){
    char * p = line;
    while(*p&&*p==' ')++p;
    if(*p=='#')continue;
    char * q = p+1;
    while(*q!=' '&&*q!='\n'&&*q&&*q!='\r')++q;
    *q=0;
    int flag =-1;
    if(strcmp(p,"HOAV6")==0){
      flag=0;
    }
    else if(strcmp(p,"HOAV4")==0){
      flag = 1;
    }
    else if(strcmp(p,"HAV6")==0)
      flag = 2;
    else if(strcmp(p,"HAV4")==0)
      flag = 3;
    fprintf(stderr,"%s: ",p);
    p=q+1;
    while(*p&&*p==' ')++p;
    q=p+1;
    while(*q&&*q!=' '&&*q!='\n'&&*q!='\r')++q;
    *q=0;
    
    if(flag == 0){
      inet_pton(AF_INET6,p,&hoav6);
      fprintf(stderr,"%x:%x:%x:%x:%x:%x:%x:%x\n",
	      NIP6ADDR(&hoav6));      
    }
    else if(flag == 1){
      inet_pton(AF_INET,p,&hoav4);
      fprintf(stderr,"%d.%d.%d.%d\n",
	      NIP4ADDR(&hoav4));
    }
    else if(flag ==2){
      inet_pton(AF_INET6,p,&hav6);
      fprintf(stderr,"%x:%x:%x:%x:%x:%x:%x:%x\n",
	      NIP6ADDR(&hav6));      
    }
    else if(flag ==3){
      inet_pton(AF_INET,p,&hav4);
      fprintf(stderr,"%d.%d.%d.%d\n",
	      NIP4ADDR(&hav4));
    }
    if(fill[flag])return -1;
    fill[flag]=1;
  }
  fclose(fp);
  if(!(fill[0]&&
       fill[1]&&
       fill[2]&&
       fill[3]))return -1;
  return 0;
}
int main()
{
  if(mn_conf("conf/mn.conf")==-1){
    inet_pton(AF_INET,_hoav4,&hoav4);
    inet_pton(AF_INET,_hav4,&hav4);
    inet_pton(AF_INET6,_hav6,&hav6);
    inet_pton(AF_INET6,_hoav6,&hoav6);
    inet_pton(AF_INET,_hoav4,&hoav4);
    inet_pton(AF_INET,_hagateway,&hagateway);
    inet_pton(AF_INET,_hasubnet,&hasubnet);

  }
  //  start_udp_encap(&hoav4,&hav4,666,666,3);
  mn_init();
  mn_worker();
  mn_cleanup();
  ctrl_cleanup();
  //stop_udp_encap(&hoav4,&hav4,666,666,3);  
  return 0;
}


/* REMAINING PROBLEMS:

 * 1) 
      
      When MN comes back to home link, it uses static IP v4 home address. 

   2) MAKE SURE THAT nat probes are sent before the coav4 is used
      or HA will decline the request from BU
*/
   
