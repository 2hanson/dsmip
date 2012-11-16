/*
 * mn.c
 * all functions used for mobile node
 * author: Lin Hui
 * mail: linhui08@gmail.com
 * last modified: SEP 08 2010
 */

/*
  UPDATE NOTE:
  Sep. 8 2010   I deleted all dhcp and IPv4 address management related code
  this is the second version of mn
  UPDATE NOTE:
  Oct. 21 2010  
  1. I add some code to print the time used by each function and
     the time some critical process is called.
  2. I also change the interval of consecutive BUs to 10 seconds.
  3. I add the code to delete the default route when handoff between IPv6 
     neworks, to avoid duplicate link up and link down made by kernel.
  WARNING: 
    1. There is still problem in sending the first BU after handoff.
     BUs cannot be sent immediately after handoff!  
  4. need waitpid to release the zombies
  
  NOV. 1 2010
  fixed the bug to remoev zombies
  
  NOV. 17 2010
  fixed the bug for which MN cannot handoff to WLAN while MN is communicating on GPRS interface 
  and wlan interface becomes OK
  
  NOV. 30 2010
  1. added some mechanisms(ipfix, ctrl_fix, witten by syl)
     to imform external control procedures to update routes while handoff
  2. added command messages to control whether to use auto-handoff or not

*/
         
#include "common.h"
#include "dhcp.h"
#include "icmp.h"
#include "rtnl.h"
#include "tunlctl.h"
#include "mn-xfrm.h"
#include <unistd.h>
#include <string.h>
#include <signal.h>
#include <sys/types.h>
#include <arpa/inet.h>
#include <sys/socket.h>
#include <sys/time.h>
#include <sys/wait.h>
#include "udpencap.h"

#define MDBG dbg
#define pthread_dbg dbg
int skip_ctrl_fd=0;//a:syl
int mh_sock=0;
int consecutive_bu = 0;
#define EXTERNAL_CTRL 1
//--------------------------------------
int wlan_ifindex = 0;
static struct in6_addr old_rtaddr; 
char sold_rtaddr[100]={0};
//--------------------------------------

static int auto_handoff_enabled = 1;

#define wlan_name  "wlan" /*"wlan"  /*eth0*/
#define gprs_name  "rmnet" /*"rmnet" /*eth1*/
//-------route in mobile table-------
#define MN_MOBILE_ROUTE_TABLE 250
#define MN_ROUTE_DEFAULT 254
#define MN_MOBILE_RULE_HIGH_PRIO 870
//-----------------------------------
static uint16_t preferred_ifindex = 0;
static uint16_t current_ifindex = 0;
static struct in6_addr current_coav6;
static struct in_addr  current_coav4;
static uint8_t current_coa_type = 0;//1 ipv4, 2 ipv4 without NAT, -1 ipv6, 
                         //0 at home or not configured
static int __BU_SEQ__ = 1;
uint32_t last_bu_t = 0;
//----------------
static uint16_t tnl44_ifindex = 0;
static uint16_t tnl64_ifindex = 0;
static uint16_t tnl66_ifindex = 0;
inline int nat_probe_send(int ifindex, struct in_addr addrv4);  

//the address defined here should be changed according to 
//the mac address of HA and MN
//the default addresses, we will take this for test
#define _hoav6 "3ffe:501:ffff:100:221:e8ff:fefb:e658" 
#define _hoav4 "172.16.0.199"
#define _hav6  "2001:cc0:2026:3:21e:c9ff:fe2c:6db"
#define _hav4  "159.226.39.212"
#define _hagateway "172.16.0.1"
#define _hasubnet "255.255.255.0"


static struct in6_addr hoav6;
static struct in_addr  hoav4;
static struct in6_addr hav6;
static struct in_addr  hav4;
void pctime()
{
  struct timeval tvpre;
  struct timezone tz;
  gettimeofday (&tvpre , &tz);
  fprintf(stderr,"[%d:%03d]",
	  tvpre.tv_sec,
	  tvpre.tv_usec/1000);
}
struct _iface
{
  uint16_t ifindex;
  char ifname[100];
  int flags; //IFF_UP|IFF_RUNNING
  //------v6------
  int last_ra_t;    //last time when ra is received
  struct in6_addr coav6;
  //------v4------
  struct in_addr coav4;
  uint8_t invalidv4;//address here are invalid
                    //because of handoff
  uint8_t invalidv6;//the address here are 
                    //invalid because of handoff
  uint32_t last_nat_probe_t;//last time when nat probe is sent
};


inline int mod_ipv6_gateway()
{
  int filedes[2];
  char buf[1024];
  pid_t pid;
  pipe( filedes );
  if((pid=fork())>0){
    system("ip -6 route");
    fprintf(stderr,"--------------------------------\n");
    close(filedes[1]);
    int n=read(filedes[0],buf,1024);
    fprintf(stderr,"%d bytes read from filedes[0]\n",n);
    buf[n]=0;
    fprintf(stderr,"%s\n",buf);
    char route_entry[2][100];
    int nid=0;
    char *pdefault = strstr(buf,"default");
    
    while(pdefault){
      //default via fe80::214:78ff:fe86:7559 dev wlan0  proto kernel  metric 1024 
      //entry one
      pdefault=strstr(pdefault,"via")+4;
      //char * q = strstr(pdefault,"dev")-1;
      char * q = strstr(pdefault,"proto")-1;
	  *q=0;
      strcpy(route_entry[nid],pdefault);
      pdefault=strstr(q+1,"default");
      fprintf(stderr,"route[%d]: %s\n",nid,route_entry[nid]);
      ++nid;
    }
    if(nid==2){
      if(fork()==0){
	if(sold_rtaddr[0]==0)
	  strcpy(sold_rtaddr,route_entry[0]);
	char cmd[100];
	sprintf(cmd,"ip -6 route del default via %s",sold_rtaddr);
	//execl("/system/bin/ip","ip","-6","route","del",cmd);
	fprintf(stderr,"system call %s\n",cmd);
	system(cmd);
	exit(0);
      }
      strcpy(sold_rtaddr,memcmp(sold_rtaddr,route_entry[0],strlen(sold_rtaddr))?
	     route_entry[0]:route_entry[1]);
    }
    else if(nid==1){
      strcpy(sold_rtaddr,route_entry[0]);
    }
    
  }
  else{
    close(filedes[0]);//close unused read fd
    dup2(filedes[1],STDOUT_FILENO);
    //execl("/system/bin/ip","ip","-6","route");
    execl("/system/bin/ip","ip","-6","route","show","dev","wlan0");//a:syl
	return 0;
  }
  //fprintf(stderr,"I am sleeping for 3 seconds ...\n");
  //sleep(3);
  //fprintf(stderr,"I am waked up, now send bu with SEQ No %d\n",__BU_SEQ__);
}

#define NIF 3
static struct _iface ifaces[NIF];//at most ten interfaces are supported;
int sendbu(const struct in6_addr * ha, 
	   const struct in6_addr * hoa, 
	   const struct in6_addr * coa,
	   int seqno)
{
  fprintf(stderr,"sendbu: from %x:%x:%x:%x:%x:%x:%x:%x\n"
                 "        (hoa=%x:%x:%x:%x:%x:%x:%x:%x)\n"
	         "        to %x:%x:%x:%x:%x:%x:%x:%x\n",
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
  pctime();
  fprintf(stderr,"sendbu.\n");
  ret= sendmsg(sockfd, &msg, 0);
  if(ret<0)
    perror("sendbu failed.");
  else 
    last_bu_t = uptime();
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
  if(ret!=0)fprintf(stderr,"%d %s\n",ret,strerror(errno));
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
#define PROC_SYS_IP6_OPTIMISTIC_DAD "/proc/sys/net/ipv6/conf/%s/optimistic_dad"


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
  set_iface_proc_entry(PROC_SYS_IP6_OPTIMISTIC_DAD, ifname, 1);
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
  {
    struct in_addr inaddr_any; 
    inaddr_any.s_addr = 0;
    
    /*fprintf(stderr,"do handoff called coav6 = %x:%x:%x:%x:%x:%x:%x:%x, coav4 = %d.%d.%d.%d, ifindex = %d\n",
	    NIP6ADDR(coav6?coav6:&in6addr_any),
	    NIP4ADDR(coav4?coav4:&inaddr_any),
	    ifindex);
    */
  }
  //fprintf(stderr,"do handoff called\n");
  //firstly update the database
  //fprintf(stderr,"----------------here %d\n", __LINE__);
  

  printf("Handoff begin----------------\n");
  int i =0;
  for(;i<NIF&&ifaces[i].ifindex!=ifindex;++i);
  if(i==NIF)
  {
	  printf("Returned at line 391----------------\n");
	  return -1;
  }
  if(type==(uint8_t)-1){
    //ipv6
    if(memcmp(&ifaces[i].coav6,coav6,sizeof(struct in6_addr))){
      //addr_del(&ifaces[i].coav6, 128, ifaces[i].ifindex);    
      memcpy(&ifaces[i].coav6,coav6,sizeof(struct in6_addr));
    }
  }
  else if(type == 1)//will dhcp update it ?
    memcpy(&ifaces[i].coav4,coav4,sizeof(struct in_addr));
  //-----------------------------
  if(ifindex!=preferred_ifindex){
    fprintf(stderr,"WARNING: interface is not what we want.\n");
	  
	printf("Returned at line 407----------------\n");
    return 0;
  }
  //check if coa has changed
  //fprintf(stderr,"----------------here %d\n", __LINE__);
  if(type==(uint8_t)-1&&
     (current_coa_type==(uint8_t)-1||current_coa_type==0)){
    if(memcmp(&current_coav6,coav6,sizeof(struct in6_addr))==0){
      consecutive_bu = 0;
	  printf("Returned at line 416----------------\n");
      return 0;//coa not change
    }
  }
  if((type==1||type==2)&&(current_coa_type==1||current_coa_type==2)){
    if(memcmp(&current_coav4,coav4,sizeof(struct in_addr))==0){
      consecutive_bu = 0;
	  printf("Returned at line 423----------------\n");
      return 0;//coa not change, do nothing
    }
  }
  //fprintf(stderr,"----------------here %d\n", __LINE__);
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
  //fprintf(stderr,"----------------here %d\n", __LINE__);  
  if(type==(uint8_t)-1&&current_coa_type!=0&&current_coa_type!=(uint8_t)-1)
    sendbu(&hav6, //only from ipv4 -> ipv6 
	   &hoav6,
	   coav6,
	   __BU_SEQ__++);//firstly we send a bu from current path
  //fprintf(stderr,"----------------here %d\n", __LINE__);
  if(type==(uint8_t)-1){
    if(memcmp(coav6,&hoav6,sizeof(struct in6_addr)))
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
      fprintf(stderr,"handoff to home\n");
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
	pctime();//a:syl
	tunnel66_del(tnl66_ifindex);
	pctime();
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
	if(current_coav4.s_addr!=hoav4.s_addr){
	  fprintf(stderr,"rule4_del %d\n",__LINE__);
	  rule4_del(NULL, MN_MOBILE_ROUTE_TABLE,
		    MN_MOBILE_RULE_HIGH_PRIO, RTN_UNICAST,
		    &current_coav4, 32,
		    &inaddr_any,0, //to
		    0);
	}
	else fprintf(stderr,"WARNING: current_coav4 eq hoav4\n");
	if(current_coa_type ==1){
	  stop_udp_encap(&hoav6,&hoav4,&current_coav4,&hav4,666,666,UDP_ENCAP_PRIO);
	}
	route4_del(tnl44_ifindex, ROUTE_MOBILE,
		   &hoav4,32, //from src                      
		   &inaddr_any,0, //to                     
		   0);
	route_del(tnl64_ifindex, ROUTE_MOBILE,
		  IP6_RT_PRIO_MIP6_FWD,//metrics                  
		  &hoav6,128,//src                            
		  &in6addr_any,0,0);
	pctime();//a:syl
	tunnel64_del(tnl64_ifindex);
	pctime();//a:syl
	tunnel44_del(tnl44_ifindex);
	pctime();//a:syl
	tnl64_ifindex = tnl44_ifindex = 0;
      }
    
      //add coavq4 into iface ifindex? add HA as the default gateway
      //ifindex must be of wlan0, or it is impossible to have ipv6 address
      current_coa_type = 0;
      memcpy(&current_coav6,coav6,sizeof(struct in6_addr));
      current_coav4.s_addr = hoav4.s_addr;
      //memset(&current_coav6,0,sizeof(struct in6_addr));
      //memset(&current_coav4,0,sizeof(struct in_addr));
      mod_ipv6_gateway();
      int k = consecutive_bu?10:1;
      for(;k>0;--k){
	sendbu(&hav6,
	       &hoav6,
	       coav6,
	       __BU_SEQ__++);
	usleep(10*1000);
	}
      consecutive_bu = 0;
      //we need to add ipv4 routes and home address on the interface
    }//at home
    else {
      //fprintf(stderr,"not at home, start creating tunnels and handoff...\n");
      //not at home, ipv6
      //firstly add temp route in temp table
      int tnl66_ifindex_tmp = tunnel66_add(coav6,&hav6,ifindex);
      addr_add(&hoav6,128,0,RT_SCOPE_UNIVERSE,tnl66_ifindex_tmp,100000,100000);
      //fprintf(stderr,"addr4_add %d\n",__LINE__);
      addr4_add(&hoav4,32,tnl66_ifindex_tmp);      
      pctime();
      fprintf(stderr,"adding route %d\n",__LINE__);
      route4_add(tnl66_ifindex_tmp,ROUTE_MOBILE_TMP,0,
		 &inaddr_any,0,&inaddr_any,0,0);
      pctime();
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
      if(current_coa_type==(uint8_t)-1){
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
	pctime();//a:syl
	tunnel66_del(tnl66_ifindex);
	pctime();
	tnl66_ifindex=0;
	pctime();
	fprintf(stderr,"rule_del %d\n",__LINE__);
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
	int _ret;
	_ret=route4_del(tnl44_ifindex, ROUTE_MOBILE,
		   &inaddr_any,0, //from src                      
		   &inaddr_any,0, //to                     
		   0);
	fprintf(stderr,"route4_del ret is %d\n",_ret);
	_ret=route_del(tnl64_ifindex, ROUTE_MOBILE,
		  IP6_RT_PRIO_MIP6_FWD,//metrics                  
		  &in6addr_any,0,//src                            
		  &in6addr_any,0,0);
	fprintf(stderr,"route_del ret is %d\n",_ret);
	pctime();//a:syl
	tunnel64_del(tnl64_ifindex);
	pctime();//a:syl
	tunnel44_del(tnl44_ifindex);
	pctime();//a:syl
	tnl64_ifindex = tnl44_ifindex = 0;
	rule4_del(NULL, MN_MOBILE_ROUTE_TABLE,
		  MN_MOBILE_RULE_HIGH_PRIO, RTN_UNICAST,
		  &current_coav4, 32,
		  &inaddr_any,0, //to
		  0);
      }
      //then we add routes in MOBILE route table
      pctime();
      fprintf(stderr,"adding route %d\n",__LINE__);
      route4_add(tnl66_ifindex_tmp,ROUTE_MOBILE,0,
		 &inaddr_any,0,&inaddr_any,0,0);
      pctime();
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
      pctime();
      fprintf(stderr,"rule4_del %d\n",__LINE__);
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
      memcpy(&current_coav6,coav6,sizeof(struct in6_addr));
      //if(current_coa_type == (uint8_t)(-1))
      mod_ipv6_gateway();
      current_coa_type = -1;
      int k = consecutive_bu?10:1;
      for(;k>0;--k){
	sendbu(&hav6,
	     &hoav6,
	     coav6,
	     __BU_SEQ__++);
	usleep(10*1000);
	}    
      consecutive_bu = 0;
    }
  }//coa is ipv6
  else if(type == 1|| type ==2){
    //fprintf(stderr,"----------------here %d\n", __LINE__);
    struct in6_addr mapped_v4coa ;
    ipv6_map_addr(&mapped_v4coa,coav4);
    //ipv4 coa
    if(memcmp(coav4,&hoav4,sizeof(struct in_addr))==0){
      //the address got is home address, do nothing
      //in fact this is impossible, if we do not set HA as a DHCP server
      //even if we set HA as a DHCP server, we should assign mn the HOAv4
      //that is impossible to get via DHCP
	  printf("Returned at line 674----------------\n");
      return -1;
    }
    //when MN comes back to home, it use statically configured ip address
    //and will not do dhcp
    //we firstly add routes and then add udp encapsulation
    struct in6_addr mapped_coav4,mapped_hav4;
    ipv6_map_addr(&mapped_coav4,coav4);
    ipv6_map_addr(&mapped_hav4,&hav4);
    fprintf(stderr,"Start modify Rule----------------here\n");
    if(current_coav4.s_addr!=coav4->s_addr){
      rule4_add(NULL, MN_ROUTE_DEFAULT,
		MN_MOBILE_RULE_HIGH_PRIO, RTN_UNICAST,
		coav4, 32,
		&inaddr_any,0, //to
		0);
      rule4_del(NULL, MN_ROUTE_DEFAULT,
		MN_MOBILE_RULE_HIGH_PRIO, RTN_UNICAST,
		&current_coav4, 32,
		&inaddr_any,0, //to
		0);
      fprintf(stderr,"End modify Rule----------------here\n");
    }
    else fprintf(stderr,"[do_handoff] WARNING: error! current_coav4 == coav4\n");
    //fprintf(stderr,"----------------here %d\n", __LINE__);
    int tnl64_ifindex_tmp = tunnel64_add(&mapped_coav4,&mapped_hav4,ifindex);
    addr_add(&hoav6,128,0,RT_SCOPE_UNIVERSE,tnl64_ifindex_tmp,100000,100000);
    int tnl44_ifindex_tmp = tunnel44_add(&mapped_coav4,&mapped_hav4,ifindex);
    pctime();
    fprintf(stderr,"adding tunnel %d.%d.%d.%d to %d.%d.%d.%d\n",
	    NIP4ADDR(coav4),NIP4ADDR(&hav4));
    //fprintf(stderr,"addr4_add %d\n",__LINE__);
    addr4_add(&hoav4,32,tnl44_ifindex_tmp);      
    pctime();
    fprintf(stderr,"adding route %d\n",__LINE__);    
    route4_add(tnl44_ifindex_tmp,ROUTE_MOBILE_TMP,0,
	       &inaddr_any,0,&inaddr_any,0,0);
    pctime();
    fprintf(stderr,"adding routev6 %d\n",__LINE__);    
    route_add(tnl64_ifindex_tmp,ROUTE_MOBILE_TMP,
	      RTPROT_MIP,0,
	      IP6_RT_PRIO_MIP6_FWD,//metrics
	      &in6addr_any,0,&in6addr_any,0,0);
    if(type == 1){
      if(current_coa_type==1)
	stop_udp_encap(&hoav6,&hoav4,
		       &current_coav4,&hav4,666,666,UDP_ENCAP_PRIO);
	pctime();//a:syl
	start_udp_encap(&hoav6,&hoav4,coav4,&hav4,666,666,UDP_ENCAP_PRIO);
    pctime();
	}
    //fprintf(stderr,"----------------here %d\n", __LINE__);
    //fprintf(stderr,"rule4_add %d\n",__LINE__);    
    rule4_add(NULL, ROUTE_MOBILE_TMP,
	      RULE_MOBILE_PRIO-1, RTN_UNICAST,
	      &inaddr_any, 0,
	      &inaddr_any,0,0);
    rule_add (NULL, ROUTE_MOBILE_TMP,
	      RULE_MOBILE_PRIO-1, RTN_UNICAST,
	      &in6addr_any,0,
	      &in6addr_any,0,0);    
    //fprintf(stderr,"----------------here %d\n", __LINE__);
    if(current_coa_type==(uint8_t)-1){
      //fprintf(stderr,"----------------here %d\n", __LINE__);
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
      pctime();//a:syl
	  tunnel66_del(tnl66_ifindex);
      pctime();
	  tnl66_ifindex=0;
      fprintf(stderr,"rule_del %d\n",__LINE__);
      rule_del(NULL, MN_ROUTE_DEFAULT,
	       MN_MOBILE_RULE_HIGH_PRIO, 
	       RTN_UNICAST,
	       &current_coav6,128,
	       &in6addr_any,0,
	       0);
      //fprintf(stderr,"----------------here %d\n", __LINE__);
    }
    else if(current_coa_type==1||current_coa_type==2){
      route4_del(tnl44_ifindex, ROUTE_MOBILE,
		 &inaddr_any,0, //from src                      
		 &inaddr_any,0, //to                     
		 0);
      route_del(tnl64_ifindex, ROUTE_MOBILE,
		IP6_RT_PRIO_MIP6_FWD,//metrics                  
		&in6addr_any,0,//src                            
		&in6addr_any,0,0);
      fprintf(stderr,"Here!!\n");
	  pctime();//a:syl
	  tunnel64_del(tnl64_ifindex);//d:syl
      pctime();//a:syl
	  tunnel44_del(tnl44_ifindex);//d:syl
      pctime();//a:syl
	  tnl64_ifindex = tnl44_ifindex = 0;      
      //old coa is ipv4 with NAT
    }
    //add new udp encapsulation and route
    //add new route to MOBILE route table
    pctime();
    fprintf(stderr,"adding route %d\n",__LINE__);
    route4_add(tnl44_ifindex_tmp,ROUTE_MOBILE,0,
	       &inaddr_any,0,&inaddr_any,0,0);
    pctime();
    fprintf(stderr,"adding routev6 %d\n",__LINE__);    
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
    pctime();
    fprintf(stderr,"rule4_del %d\n",__LINE__);
    rule4_del(NULL, ROUTE_MOBILE_TMP,
	      RULE_MOBILE_PRIO-1, RTN_UNICAST,
	      &inaddr_any, 0,
	      &inaddr_any,0, 
	      0);
    fprintf(stderr,"sentinel1 at %d\n", __LINE__);
    rule_del (NULL, ROUTE_MOBILE_TMP,
	      RULE_MOBILE_PRIO-1, RTN_UNICAST,
	      &in6addr_any,0,
	      &in6addr_any,0,0);    
    fprintf(stderr,"sentinel2 at %d\n", __LINE__);
    memcpy(&current_coav4,coav4,sizeof(struct in_addr));
    tnl64_ifindex = tnl64_ifindex_tmp;
    tnl44_ifindex = tnl44_ifindex_tmp;
    //if(current_coa_type == (uint8_t)(-1))
    //nat_probe_send_simple(ifindex, *coav4);
	mod_ipv6_gateway();
    current_coa_type = type;
    int k = consecutive_bu?10:1;
    fprintf(stderr,"sentinel3 at %d\n", __LINE__);
    for(;k>0;--k)
	{
      //nat_probe_send_simple(ifindex, *coav4);
	  nat_probe_send(ifindex, *coav4);
	  usleep(10*1000);
	  sendbu(&hav6,
	   &hoav6,
	   &mapped_v4coa,
	   __BU_SEQ__++);
	  usleep(10*1000);
	}	
    consecutive_bu = 0;
  }//ipv4 coa

  printf("Returned at line 833, the end of dohandoff----------------\n");
  return 0;
}

int ap_off()
{
  //ap is off, change to gprs
  int i=0;
  for(;i<NIF;++i)
    if(memcmp(ifaces[i].ifname,gprs_name,sizeof(char)*strlen(gprs_name))==0){
      //found gprs card
      if(ifaces[i].invalidv4==0){
	//address usable
	//preferred_ifindex = ?
	//do_handoff();
	break;
      }
    }
  return 0;
}

int ap_on()
{
  //ap is ok, wlan0 is ok
  int i = 0;
  for(;i<NIF;++i)
    if(memcmp(ifaces[i].ifname,wlan_name,sizeof(char)*strlen(wlan_name))==0){
      //handoff to wlan
      
      break;
    }
  
  return 0;
}       


	       
struct rtnl_handle md_rth;

static int process_link(struct nlmsghdr *n, void *arg)
{
  struct timeval tvafter,tvpre;
  struct timezone tz;
  gettimeofday (&tvpre , &tz);

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
    //fprintf(stderr,"LINK %d is up FLAG: %s %s\n",
    //ifi->ifi_index,
    //ifi->ifi_flags&IFF_UP?"IFF_UP":"IFF_DOWN",
    //ifi->ifi_flags&IFF_RUNNING?"IFF_RUNNING":"IFF_NOT_RUNNING");
    
    //-----------------------------------------------------------------
    //link flag may change from RUNNING|UP to NOT_RUNNING |NOT_UP
    //when link is down, we delete all of the route and related tunnels
    //initialize the system to the original state
    
    char ifname[100];
    if_indextoname(ifi->ifi_index,ifname);
    if(memcmp(ifname,wlan_name,sizeof(char)*strlen(wlan_name))==0){
      wlan_ifindex = ifi->ifi_index;
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
	  pctime();
	  fprintf(stderr,"wlan card flags changed...\n");
	  ifaces[i].flags = ifi->ifi_flags;
	  //flags changed
	  if((ifi->ifi_flags&(IFF_UP|IFF_RUNNING))==(IFF_UP|IFF_RUNNING)){
	    pctime();
	    fprintf(stderr,"%s is up\n",ifname);
	    consecutive_bu = 1;
	    //last_bu_t  = 0;
	    //addr_del(&ifaces[i].coav6, 128, ifaces[i].ifindex);
	    //ifconfig eth0 up
		cngictrl_ipfix(1);//a:syl
	  }
	  else{
	    //ifconfig eth0 down
	    //we need to handoff to the other interfaces
	    //ap_off will do this for me
	    int imn=0;
	    while(imn<NIF&&ifaces[imn].ifindex!=ifi->ifi_index)++imn;
	    if(imn<NIF){
	      if(ifaces[imn].invalidv6==0){
		//delete current v6 coa and v6 route
		/*
		  fprintf(stderr,"deleting %x:%x:%x:%x:%x:%x:%x:%x(%d)\n",
			NIP6ADDR(&ifaces[imn].coav6),
			ifaces[imn].ifindex);
		  addr_del(&ifaces[imn].coav6, 128, ifaces[imn].ifindex);
		*/
		//char cmd[100];
		//pctime();fprintf(stderr,"start delete route\n");
		//sprintf(cmd,"ip -6 route del default via %s",sold_rtaddr);
		//system(cmd);
		//fprintf(stderr,"%s\n",cmd);
		//pctime();fprintf(stderr,"end delete route\n");
	      }
	      pctime();
	      fprintf(stderr,"link down, make iface %d invalid v4 and v6 coa\n",
		      imn);
		  cngictrl_ipfix(0);//a:syl
	      ifaces[imn].invalidv6=1;
	      ifaces[imn].invalidv4=1;
	    if(auto_handoff_enabled){  
		for(imn=0;imn<NIF;++imn){
		if(ifaces[imn].ifindex>0&&
		   ifaces[imn].ifindex!=ifi->ifi_index&&
		   (ifaces[imn].flags&IFF_RUNNING)&&(ifaces[imn].flags&IFF_UP))
		  break;
	      }
	      if(imn<NIF){
		if(ifaces[imn].invalidv6==0){
		  preferred_ifindex=ifaces[imn].ifindex;
		  do_handoff(&ifaces[imn].coav6,0,ifaces[imn].ifindex,-1);
		}
		else if(ifaces[imn].invalidv4==0){
		  preferred_ifindex=ifaces[imn].ifindex;
		  do_handoff(0,&ifaces[imn].coav4,ifaces[imn].ifindex,1);
		}
	      }//if(imn<NIF) find alterative iface if current one is down
	    	//cngictrl_ipfix(0);//a:syl
		 }//if(auto_handoff_enabled)
		}//if(imn<NIF) find current iface
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
	ifaces[i].invalidv4 = 1;
	ifaces[i].invalidv6 = 1;
      }
    }
    else if(memcmp(ifname,gprs_name,sizeof(char)*strlen(gprs_name))==0){
      //gprs card
      int i;
      for(i=0;i<NIF&&ifaces[i].ifindex!=ifi->ifi_index;++i);
      if(i==NIF)
	for(i=0;i<NIF&&ifaces[i].ifindex;++i); //find an unused interface
      if(ifaces[i].ifindex == ifi->ifi_index){
	if((ifaces[i].flags&(IFF_UP|IFF_RUNNING))!=
	   (ifi->ifi_flags&(IFF_UP|IFF_RUNNING))){
	  ifaces[i].flags=ifi->ifi_flags;
	  //flags changed
	  if(ifi->ifi_flags&(IFF_UP|IFF_RUNNING)){
	    pctime();
	    fprintf(stderr,"gprs card is up.\n");
		cngictrl_gprsfix();
	    //ifconfig gprs up
	  }
	  else{
	    //ifconfig gprs down
	    //check if current ifindex is gprs, 
	    //if it is, delete the tunnels and routes
		fprintf(stderr,"gprs card is down.\n");
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
      }
    }
    //-----------------------------------------------------------------
  }//end of RTM_NEWLINK
  else if (n->nlmsg_type == RTM_DELLINK){
    pctime();
    fprintf(stderr,"LINK %d is DELETED \n",
	    ifi->ifi_index);
    int imn=0;
    int id =-1;
    for(;imn<NIF;++imn){
      if(ifaces[imn].ifindex==ifi->ifi_index){
	id=imn;
      }
      else if(ifaces[imn].ifindex!=0){
	//handoff to this iface
	if(ifaces[imn].invalidv6==0){
	  preferred_ifindex=ifaces[imn].ifindex;
	  do_handoff(&ifaces[imn].coav6,0,ifaces[imn].ifindex,-1);
	}
	else if(ifaces[imn].invalidv4==0){
	  preferred_ifindex=ifaces[imn].ifindex;
	  do_handoff(0,&ifaces[imn].coav4,ifaces[imn].ifindex,1);
	}
	else {
	  preferred_ifindex=ifaces[imn].ifindex;
	  do_handoff(&hoav6,0,ifaces[imn].ifindex,-1);//let it go home
	}
	break;
      }
    }
    if(imn==NIF){
      //current iface deleted, handoff to a dummy card
      preferred_ifindex=0;
      do_handoff(&hoav6,0,preferred_ifindex,-1);
    }
    memset(ifaces+id,0,sizeof(struct _iface));
	
    //-----------------------------------------------------------------
    //link is deleted, I have not meet this scenario yet...
    //but when this happen, we do as if the link is down
    //-----------------------------------------------------------------
  }//end of RTM_DELLINK
  gettimeofday (&tvafter , &tz);
  int timeused = (tvafter.tv_sec-tvpre.tv_sec)*1000+
    (tvafter.tv_usec-tvpre.tv_usec)/1000;
  if(timeused)
    fprintf(stderr,"NOTE: process_link uses %d ms.\n",
	    timeused);
  
  return 0;
}


static int process_addr(struct nlmsghdr *n, void *arg)
{
  struct timeval tvafter,tvpre;
  struct timezone tz;
  gettimeofday (&tvpre , &tz);

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
      pctime();
      fprintf(stderr,"NEW ADDR %x:%x:%x:%x:%x:%x:%x:%x\n",
	      NIP6ADDR(addr6));
      if(consecutive_bu){
	last_bu_t = 0;
      }
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
	if(ifaces[i].ifindex){
	  if((ifaces[i].flags &(IFF_RUNNING|IFF_UP))!=(IFF_RUNNING|IFF_UP)){
	    pctime();
	    fprintf(stderr,"new address got but link is down, ignore it!\n");
	     return 0;
	  }
	}
	if(ifaces[i].ifindex==0){
	  //add new interface into database
	  memset(&ifaces[i],0,sizeof(struct _iface));
	  ifaces[i].ifindex=ifa->ifa_index;
	  ifaces[i].flags=IFF_UP|IFF_RUNNING;
	  if_indextoname(ifaces[i].ifindex,ifaces[i].ifname);
	  if(memcmp(ifaces[i].ifname,gprs_name,sizeof(char)*strlen(gprs_name))
	     &&
	     memcmp(ifaces[i].ifname,wlan_name,sizeof(char)*strlen(wlan_name))){
	    memset(ifaces+i,0,sizeof(struct _iface));
	    //not a valid wlan iface or gprs iface
	    return 0;
	  }
	  ifaces[i].invalidv4 = 1;//ipv6 is valid now, but ipv4 is not(because this iface is inited)
	}
	ifaces[i].invalidv6=0;//ipv6 now is valid
	if(memcmp(&ifaces[i].coav6,addr6,sizeof(struct in6_addr))){
	  //addr_del(&ifaces[i].coav6, 128, ifaces[i].ifindex);
	  memcpy(&ifaces[i].coav6,addr6,sizeof(struct in6_addr));
	}
	if(auto_handoff_enabled)
	  preferred_ifindex=ifa->ifa_index;
	//fprintf(stderr,"assigning preferred_ifindex as %d\n",ifa->ifa_index);
	if(preferred_ifindex==0||preferred_ifindex == ifa->ifa_index){
	  preferred_ifindex = ifa->ifa_index;
	  do_handoff(addr6,0,ifa->ifa_index,-1);
	}
      }
      //------------------------------------------------------
    }
    else if (ifa->ifa_family == AF_INET){
      pctime();
      fprintf(stderr,"IPv4 ADDR addeded:");
      addr4 = RTA_DATA(rta_tb[IFA_ADDRESS]);
      if(addr4 == 0){
	fprintf(stderr,"rta_tb[IFA_ADDRESS] is NULL\n");
	return 0;
      }
      fprintf(stderr,"%d.%d.%d.%d\n",NIP4ADDR(addr4));

      if(memcmp(&hoav4,addr4,sizeof(struct in_addr))==0)
	return 0;//do not process the home address
      int i = 0;
      int iswlan=0;
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
	//iswlan = memcmp(ifaces[i].ifname,wlan_name,sizeof(char)*strlen(wlan_name))==0;
	ifaces[i].invalidv6=1;
      }//i==NIF
	  iswlan = memcmp(ifaces[i].ifname,wlan_name,sizeof(char)*strlen(wlan_name))==0;
      ifaces[i].invalidv4=0;      
      ifaces[i].flags=IFF_UP|IFF_RUNNING;//it must be running and up
      ifaces[i].coav4 = *addr4;
      //let dhcp_worker send dhcp_discovery,not dhcp_select
      //because we do not know dhcp server
      if(preferred_ifindex==0){
	//if we do not have preferred ifindex we init it to the 
	//first active interface
	preferred_ifindex=ifaces[i].ifindex;
      }
      pctime();
      fprintf(stderr,"adding rules\n");
      memcpy(&ifaces[i].coav4,addr4,sizeof(struct in_addr));      
      //---------------------------------------
      nat_probe_send(ifaces[i].ifindex, ifaces[i].coav4);
		    
      int now = uptime();
      ifaces[i].last_nat_probe_t = now;
      if(iswlan&&auto_handoff_enabled)
	preferred_ifindex=ifa->ifa_index;
      if(ifa->ifa_index==preferred_ifindex||preferred_ifindex==0){
	preferred_ifindex = ifa->ifa_index;
	//if this is the preferred ifindex
	//only when the ipv6 is invalid will we use ipv4
	if(ifaces[i].invalidv6){//the ipv6 address is invalid
	  //fprintf(stderr,"calling do_handoff... to %d.%d.%d.%d\n",NIP4ADDR(addr4));
	  do_handoff(0,addr4,ifa->ifa_index,1);
	  //fprintf(stderr,"do_handoff completed.\n");
	}
	else do_handoff(&ifaces[i].coav6,0,ifa->ifa_index,-1);//never exec
      }
    }
  }//RTM_NEWADDR
  else if (n->nlmsg_type == RTM_DELADDR){
    if (ifa->ifa_family == AF_INET6){
      addr6 = RTA_DATA(rta_tb[IFA_ADDRESS]);
      pctime();
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
      
      if(current_coa_type == (uint8_t)-1||
	 current_coa_type == 0){
	if(ifa->ifa_index==current_ifindex&&
	   memcmp(&current_coav6,addr6,sizeof(struct in6_addr))==0){
	  //call do_handoff to hoame address to delete all routes
	  //do_handoff(&hoav6,0,ifa->ifa_index,-1);
	  int imn=0;
	  for(imn=0;auto_handoff_enabled&&imn<NIF;++imn){
	    if(ifaces[imn].ifindex!=0&&
	       ifaces[imn].ifindex!=ifa->ifa_index){
	      
	      if(ifaces[imn].invalidv6==0){
		fprintf(stderr,"DEBUG: handoff to %d ipv6\n",preferred_ifindex);
		preferred_ifindex = ifaces[imn].ifindex;
		do_handoff(&ifaces[imn].coav6,0,preferred_ifindex,-1);
	      }
	      else if(ifaces[imn].invalidv4==0){
		preferred_ifindex = ifaces[imn].ifindex;
		fprintf(stderr,"DEBUG: handoff to %d ipv4\n",preferred_ifindex);		
		do_handoff(0,&ifaces[imn].coav4,preferred_ifindex,1);
	      }
	      else {
		preferred_ifindex = 0;
		do_handoff(&hoav6,0,preferred_ifindex,-1);
	      }
	      //handoff to home link, delete all routes and rules
	    }
	    break;
	  }
	}
      }
      int imn=0;
      for(;imn<NIF&&ifaces[imn].ifindex!=ifa->ifa_index;++imn);
      if(imn<NIF){
	if(memcmp(&ifaces[imn].coav6,addr6,sizeof(struct in6_addr))==0){
	  memset(&ifaces[imn].coav6,0,sizeof(struct in6_addr));
	  ifaces[imn].invalidv6=1;
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
	  int imn=0;
	  for(imn=0;auto_handoff_enabled&&imn<NIF;++imn){
	    if(ifaces[imn].ifindex!=0&&
	       ifaces[imn].ifindex!=ifa->ifa_index){
	      if(ifaces[imn].invalidv6==0){
		preferred_ifindex = ifaces[imn].ifindex;
		do_handoff(&ifaces[imn].coav6,0,ifaces[imn].ifindex,-1);
	     break;
		 }
	      else if(ifaces[imn].invalidv4==0){
		preferred_ifindex = ifaces[imn].ifindex;		
		do_handoff(0,&ifaces[imn].coav4,ifaces[imn].ifindex,1);
	      break;
		  }
	      else {
		preferred_ifindex = 0;
		do_handoff(&hoav6,0,preferred_ifindex,-1);
	      break;
		  }
	      //handoff to home link, delete all routes and rules
	    }
	    break;
	  }
	}
      }
      int imn=0;
      for(;imn<NIF&&ifaces[imn].ifindex!=ifa->ifa_index;++imn);
      if(imn<NIF){
	if(memcmp(&ifaces[imn].coav4,addr4,sizeof(struct in_addr))==0){
	  ifaces[imn].coav4.s_addr = 0;
	  ifaces[imn].invalidv4=1;
	}
      }
    }//AF_INET
  }//RTM_DELADDR
  gettimeofday (&tvafter , &tz);
  int timeused = (tvafter.tv_sec-tvpre.tv_sec)*1000+
    (tvafter.tv_usec-tvpre.tv_usec)/1000;
  if(timeused)
    fprintf(stderr,"NOTE: process_addr uses %d ms.\n",
	   timeused);
  //printf("NOTE: process_addr used %ld ms.\n",
  //(tvafter.tv_sec-tvpre.tv_sec)*1000+
  //(tvafter.tv_usec-tvpre.tv_usec)/1000);
  
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

void _sigchld_handler(int num)
{
  int status;
  int pid = waitpid(-1,&status,WNOHANG);
  pctime();
  fprintf(stderr,"child %d exited with code %d\n",pid,status);
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
int ctrl_init();
int mn_init()
{
  system("ifconfig ip6tnl0 up");
  system("ifconfig tunl0 up");
  system("ifconfig sit0 up");
  if(load_udpencap())return -1;
  struct in_addr inaddr_any;
  inaddr_any.s_addr = 0;
  iface_proc_entries_init("default");
  signal(SIGINT, _sigint_handler);
  signal(SIGCHLD, _sigchld_handler);
  int i = 0;
  memset(ifaces,0,sizeof(struct _iface)*NIF);
  memset(&current_coav6,0,sizeof(current_coav6));
  memset(&current_coav4,0,sizeof(current_coav4));
  memset(&old_rtaddr,0,sizeof(struct in6_addr));
  current_coa_type=0;
  current_ifindex=0;
  preferred_ifindex = 0;
  tnl66_ifindex = 0;
  tnl64_ifindex = 0;
  tnl44_ifindex = 0;
  //once we receive ra and verify that we are at home
  //we will configure the ipv4 hoa into wlan interface.
  //but now we just clear everything.
  mh_init();
  md_init();
  tnl_init();
  ctrl_init();
  listen_udpencap_init();
  icmp6_init(1);
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
  if(current_coav4.s_addr!=hoav4.s_addr)
    rule4_del(0,
	      MN_ROUTE_DEFAULT,
	      MN_MOBILE_RULE_HIGH_PRIO,
	      RTN_UNICAST,
	      &current_coav4,32,
	      &inaddr_any,0,
	      0);    
  if(memcmp(&current_coav6,&hoav6,sizeof(struct in6_addr)))
    rule_del(NULL, MN_ROUTE_DEFAULT,
	     MN_MOBILE_RULE_HIGH_PRIO, 
	     RTN_UNICAST,
	     &current_coav6,128,
	     &in6addr_any,0,
	     0);
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
    memset(&current_coav6,0,sizeof(struct in6_addr));
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
  tnl_cleanup();
  
  fprintf(stderr,"rule4_del %d\n",__LINE__);
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
  system("rmmod udpencap");
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

inline int nat_probe_send(int ifindex, struct in_addr addrv4)
{
  //send nat probe from some ifindex
  //firstly we need to set rules and policies 
  //to bypass the encapsulation and route
  //after sending the probe we delete the rules
  //return 0;//a:syl
  struct sockaddr_in dest, src;
  int sock_fd;
  int n;
  int flag=1;
  bzero(&dest,sizeof(dest));
  dest.sin_family = AF_INET;
  dest.sin_addr = hav4;
  dest.sin_port = htons(667);
  sock_fd = socket(AF_INET,SOCK_DGRAM,IPPROTO_UDP);
  //src.sin_addr = addrv4;
  src.sin_addr.s_addr=INADDR_ANY;
  //src.sin_port = htons(666);
  src.sin_port=htons(667);
  if(setsockopt(sock_fd, SOL_SOCKET, SO_REUSEADDR, &flag, sizeof(flag)) <0){
    fprintf(stderr,"udp rebind error!.\n");
  }
  pctime();//a:syl
  while(bind(sock_fd, (struct sockaddr *) &src, sizeof(src))){
    time_t t = time(0);
    fprintf(stderr,"%s",ctime(&t));
    pctime();//a:syl
	perror("nat_probe sender bind error in here:");
    //return 0;
	usleep(10*1000);
  }
  pctime();//a:syl
  struct NATINFO data;
  data.hoa=hoav6;
  data.port = 666;
  data.seqno = 12345;
  data.ifindex = ifindex;
  data.coa = addrv4;
  data.checksum = data.seqno^data.ifindex^data.port;
  fprintf(stderr,"nat initial src %d.%d.%d.%d\n",NIP4ADDR(&addrv4));//a:syl
  //bypass rule ---------------------------------
  struct in_addr inaddr_any;
  inaddr_any.s_addr = 0;
  //let the packet lookup default route table, (GPRS)
  fprintf(stderr,"rule4_add to default table. %d\n",__LINE__);    
  //rule4_add(0,MN_ROUTE_DEFAULT,RULE_MOBILE_PRIO-30,RTN_UNICAST,
	//    &addrv4,32,&inaddr_any,0,0);
  pctime();//a:syl
  n = sendto(sock_fd,&data,sizeof(data),0,(struct sockaddr *)&dest, sizeof(dest));
  if(-1==n){
    perror("send nat probe error\n");
  }
  else {
	//b:syl
	int natsendcount=5;
	for(;natsendcount--;){
	  dest.sin_port = htons(668);
	  n = sendto(sock_fd,&data,sizeof(data),0,(struct sockaddr *)&dest, sizeof(dest));
  	  if(-1==n){
    	perror("send 2nd nat probe error\n");
  	  }
    }
	//e:syl
    time_t curtime = time(0);
    struct tm *curtm = localtime(&curtime);
    fprintf(stderr,"[%02d:%02d:%02d] send nat probe.\n",curtm->tm_hour,
	    curtm->tm_min,curtm->tm_sec);
  }
  pctime();//a:syl
  //delete bypass rule --------------------------
  //delete route which let the packet lookup default route table
  fprintf(stderr,"rule4_del %d\n",__LINE__);
  //rule4_del(0,MN_ROUTE_DEFAULT,
	//    RULE_MOBILE_PRIO-30, RTN_UNICAST,	      
	  //  &addrv4,32,&inaddr_any,0,0);
  pctime();//a:syl
  close(sock_fd);
  return n;
}
/*
inline int nat_probe_send_simple(int ifindex, struct in_addr addrv4)
{
  //send nat probe
  //used before BU
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
    fprintf(stderr,"udp rebind error!.\n");
  }
  while(bind(sock_fd, (struct sockaddr *) &src, sizeof(src))){
    time_t t = time(0);
    fprintf(stderr,"%s",ctime(&t));
    perror("nat_probe_simple sender bind error:");
    //return 0;
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
  //let the packet lookup default route table, (GPRS)
  n = sendto(sock_fd,&data,sizeof(data),0,(struct sockaddr *)&dest, sizeof(dest));
  if(-1==n){
    perror("send nat probe error\n");
  }
  close(sock_fd);
  return n;
}
*/
int nat_probe_worker()
{
  struct timeval tvafter,tvpre;
  struct timezone tz;
  gettimeofday (&tvpre , &tz);
  //in fact this is only necessary for those interfaces that do not take dhcp 
  //interfaces using dhcp will send nat probes when they are updating address
  //information.
  int now = uptime();
  int i = 0;
  int flag = 0;
  for(i=0;i<NIF;++i)
  //if(ifaces[i].ifindex&& //c:syl	  
    if(ifaces[i].ifindex&&ifaces[i].ifindex==preferred_ifindex&&
       (ifaces[i].flags&(IFF_UP|IFF_RUNNING))==(IFF_UP|IFF_RUNNING)&&
       ifaces[i].invalidv4==0){
      if(abs(ifaces[i].last_nat_probe_t-now)>5){
	nat_probe_send(ifaces[i].ifindex,ifaces[i].coav4);
	ifaces[i].last_nat_probe_t = now;
	flag=1;
      }
    }
  gettimeofday (&tvafter , &tz);
  int timeused = (tvafter.tv_sec-tvpre.tv_sec)*1000+
    (tvafter.tv_usec-tvpre.tv_usec)/1000;
  if(timeused)
    fprintf(stderr,"NOTE: nat_probe_worker uses %d ms.\n",
	   timeused);
  //printf("NOTE: nat_probe_worker used %ld ms.\n",
  //(tvafter.tv_sec-tvpre.tv_sec)*1000+
  //(tvafter.tv_usec-tvpre.tv_usec)/1000);
  
  return 0;
}
 
int ba_fd_init()
{
  //to be implemented
  return 0;
}

int ba_fd_cleanup()
{
  //to be implemented
  return 0;
}

int ba_fd_set(fd_set *rfds, int maxfd)
{
  //to be implemented
  return maxfd;
}

int ba_fd_checker(fd_set *rfds)
{
  //check to see if we have received ba
  return 0;
}


int bu_worker(int force)
{/*
  struct timeval tvafter,tvpre;
  struct timezone tz;
  gettimeofday (&tvpre , &tz);*/

  const static int bu_interval = 5;
  //send bu to HA periodly 
  int now = uptime();
  if(abs(last_bu_t-now)>bu_interval||force){
    if(current_coa_type==(uint8_t)-1){//ipv6
      sendbu(&hav6,&hoav6,&current_coav6,__BU_SEQ__++);
    }
    else if(current_coa_type==1||//ipv4
	    current_coa_type==2){
      struct in6_addr mapped_coa;
      ipv6_map_addr(&mapped_coa,&current_coav4);
      sendbu(&hav6,&hoav6,&mapped_coa,__BU_SEQ__++);
    }
    else return 0;/*
    gettimeofday (&tvafter , &tz);
    int timeused = (tvafter.tv_sec-tvpre.tv_sec)*1000+
      (tvafter.tv_usec-tvpre.tv_usec)/1000;
    if(timeused)
      fprintf(stderr,"NOTE: bu_worker uses %d ms.\n",
	     timeused);*/
	   
    
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
#define CTRL_CMD_AUTO_HANDOFF_ON 6
#define CTRL_CMD_AUTO_HANDOFF_OFF 7

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
	      "preferred_ifindex = %d, "
	      "current coav6 = %x:%x:%x:%x:%x:%x:%x:%x, "
	      "current coav4=%d.%d.%d.%d\n",
	      preferred_ifindex,
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
     if(current_ifindex!=preferred_ifindex&&auto_handoff_enabled){
    	sprintf(tmpbuf,"You must firstly disable auto_handoff(handoff off)\n");
   		strcat(ack,tmpbuf);
      }
      else
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
	case CTRL_CMD_AUTO_HANDOFF_ON:
      auto_handoff_enabled=1;
      break;
    case CTRL_CMD_AUTO_HANDOFF_OFF:
      auto_handoff_enabled=0;
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

#ifdef EXTERNAL_CTRL
/*
pthread_cond_t cond_main;

//a:syl
void *
ipfix_done(void *arg)
{
	pthread_t tid_main=*(pthread_t *)arg;
	struct CTRL_CMD cmd_data;
    struct sockaddr_in rin;
	int address_size = sizeof (rin);
    //while(1)
	do
	{
		int n = recvfrom (ctrl_fd, &cmd_data, sizeof(cmd_data),0,
		      (struct sockaddr *) &rin,
		      &address_size);
		skip_ctrl_fd=1;
		pctime();
		fprintf(stderr,"\nrecvfrom cngictrl in ipfix_done\n");
		//#define CTRL_CMD_IPFIXDONE 10
		if(cmd_data.cmd==10){
			pthread_cond_signal(&cond_main);
			break;
		}
	}while(0);
	return NULL;
}
*/

//a:syl
enum{
	ACK_IPFIX=0,
	ACK_RMNET,
};

//a: yhz
int
getCurrentIfindex()
{
	int i = 0;
    for(i=0;i<NIF;++i){
	if(ifaces[i].ifindex){
	  if(ifaces[i].invalidv6==0){
		    if (((current_coa_type==(uint8_t)-1||
		      current_coa_type==0)&&
		     memcmp(&current_coav6,&ifaces[i].coav6,sizeof(struct in6_addr))==0))
			{
				return ifaces[i].ifindex;
			}
	  }
	  if(ifaces[i].invalidv4==0){
		    if (((current_coa_type==0
		      ||current_coa_type==1
		      ||current_coa_type==2)&&
		     memcmp(&current_coav4,&ifaces[i].coav4,sizeof(struct in_addr))==0))
			{
				return ifaces[i].ifindex;		
			}
	  }
	}
	}

	//if run to here, then there is something wrong
	return -1;
}

void
cngictrl_ipfix(int flag)
{
	struct CTRL_CMD_ACK ctrl_ack;	
    struct sockaddr_in rin;
	
	ctrl_ack.seqno=0;
	ctrl_ack.chksum=ACK_IPFIX;
	ctrl_ack.ack[0]=flag;
	//a: yhz
	ctrl_ack.ack[1] = auto_handoff_enabled;
	ctrl_ack.ack[2] = getCurrentIfindex();
	
	ctrl_ack.acklen=1;

	bzero(&rin,sizeof(rin));
  	rin.sin_family = AF_INET;
	//rin.sin_addr.s_addr = INADDR_ANY;
	inet_pton(AF_INET,"127.0.0.1",&rin.sin_addr);
	rin.sin_port = htons(7776);
	pctime();fprintf(stderr,"starting to send to cngictrl\n");
	int n=sendto(ctrl_fd,&ctrl_ack,sizeof(ctrl_ack),0,(struct sockaddr*)&rin,sizeof(rin));
	if(n==-1){
		pctime();
		perror("has sent,but failed!\n");
	}
	else{
		pctime();
		fprintf(stderr,"has sent, succeeded!\n");
	}
	/*	
	//pthread_cond_t cond_ipfix_done;
	pthread_t tid_ipfix_done;

	tid_ipfix_done=0;
	pthread_t tid_main=pthread_self();
    if(pthread_create(&tid_ipfix_done,NULL,ipfix_done, (void *)&tid_main)<0){
    	perror("ERROR: ipfix_done can't start\n");
    }
	else{
		pthread_mutex_t mut=PTHREAD_MUTEX_INITIALIZER;
    	struct timeval now;
    	struct timespec timeout;
		int retcode;

		//while(1)
		do{
			pthread_mutex_lock(&mut);
    		gettimeofday(&now, NULL);
			timeout.tv_sec = now.tv_sec+5;
			timeout.tv_nsec = now.tv_usec*1000;
			if ((retcode = pthread_cond_timedwait(&cond_main, &mut, &timeout)) < 0) {
      	   		perror("pthread_cond_timedwait");
				break;
    		}
   	 		if (retcode != 110){
				pthread_mutex_unlock(&mut);
				break;
        	}
   			pthread_mutex_unlock(&mut);
		} while(0);
		pthread_join(tid_ipfix_done,NULL);
		pctime();
		fprintf(stderr,"\ncngictrl_ipfix blocking is now canceled by ipfix_done\n");
	}
	*/
	
	skip_ctrl_fd=0;
	struct CTRL_CMD cmd_data;
	int address_size = sizeof (rin);
	n = recvfrom (ctrl_fd, &cmd_data, sizeof(cmd_data),0,(struct sockaddr *) &rin, &address_size);
	pctime();
	fprintf(stderr,"recvfrom cngictrl\n");
	
}

void
cngictrl_gprsfix()
{
	struct CTRL_CMD_ACK ctrl_ack;	
    struct sockaddr_in rin;
	
	ctrl_ack.seqno=0;
	ctrl_ack.chksum=ACK_RMNET;
	ctrl_ack.ack[0]=1;	
	ctrl_ack.acklen=1;

	bzero(&rin,sizeof(rin));
  	rin.sin_family = AF_INET;
	//rin.sin_addr.s_addr = INADDR_ANY;
	inet_pton(AF_INET,"127.0.0.1",&rin.sin_addr);
	rin.sin_port = htons(7776);
	pctime();fprintf(stderr,"starting to send to cngictrl\n");
	int n=sendto(ctrl_fd,&ctrl_ack,sizeof(ctrl_ack),0,(struct sockaddr*)&rin,sizeof(rin));
	if(n==-1){
		pctime();
		perror("has sent,but failed!\n");
	}
	else{
		pctime();
		fprintf(stderr,"has sent, succeeded!\n");
	}
}

#endif

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



int ra_fd_set(fd_set *rfds, int maxfd)
{
  if(maxfd<ctrl_fd)maxfd=ctrl_fd;
  FD_SET(icmp6_sock.fd,rfds);
  return maxfd;
}



inline int ra_fd_check(fd_set * rfds)
{
  // too slow
  if(FD_ISSET(icmp6_sock.fd,rfds)){
    struct in6_addr rtaddr;
    recvra(&rtaddr);
    //fprintf(stderr,"ra received %x:%x:%x:%x:%x:%x:%x:%x\n",
    //NIP6ADDR(&rtaddr));
    if(memcmp(&old_rtaddr,&rtaddr,sizeof(struct in6_addr))){
      //route_del();
      if(memcmp(&old_rtaddr,&in6addr_any,sizeof(struct in6_addr))){
	route_del(wlan_ifindex, MN_ROUTE_DEFAULT,
		  1024,
		  &in6addr_any,0,//src                                                       
		  &in6addr_any,0,&old_rtaddr);
      }
      memcpy(&old_rtaddr,&rtaddr,sizeof(struct in6_addr));
    }
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
    max_fd=nat_probe_fd_set(&rfds,max_fd);
    max_fd=ctrl_fd_set(&rfds,max_fd);
    //mianshi max_fd=ra_fd_set(&rfds,max_fd);
    struct timeval tv;
    tv.tv_sec = 1;
    tv.tv_usec = 0;
    //ndisc_send_rs(2,&in6addr_any,
    //&in6addr_all_routers_mc);
    int retval = select(max_fd+1,&rfds,0,0,&tv);
    //messages:
    if(retval>0){
      //ra_fd_check(&rfds);
      link_event_fd_check(&rfds);
      nat_probe_fd_check(&rfds);//check to see if nat probes have ack
      if(skip_ctrl_fd++)
	  	ctrl_fd_check(&rfds);
    }
    //do other things
    bu_worker(0);
    nat_probe_worker();
  }
  fprintf(stderr,"existing from mn_worker ... \n");
  return 0;
}

//a:yhz
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
    //a:yhz
	if(mn_conf("conf/mn.conf")==-1)
	{
		inet_pton(AF_INET,_hoav4,&hoav4);
		inet_pton(AF_INET,_hav4,&hav4);
		inet_pton(AF_INET6,_hav6,&hav6);
		inet_pton(AF_INET6,_hoav6,&hoav6);
		inet_pton(AF_INET,_hoav4,&hoav4);
	}

  mn_init();
  mn_worker();
  mn_cleanup();
  ctrl_cleanup();
  return 0;
}


/* NOTE:
   1) When MN comes back to home link, it uses static IP v4 home address. 

   2) MAKE SURE THAT nat probes are sent before the coav4 is used
      or HA will decline the request from BU
*/
   
