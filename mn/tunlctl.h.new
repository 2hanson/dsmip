/*
 * Author Lin Hui
 * Email: linhui08@gmail.com
 * Create Date: 2010.7.29
 * Last Modified: 2010.11.11
 */

/* 2010.11.11
 * Change Note:
 * Optimze tunnel_add and tunnel_del
 * use tunnel pools to reduce the time used by creating
 * and deleting tunnels
 */
#ifndef __TUNNELCTL_H__
#define __TUNNELCTL_H__ 1



#include <stdlib.h>
#include <unistd.h>
#include <stdio.h>
#include <errno.h>
#include <string.h>
#include <asm/types.h>
#include <sys/socket.h>
#include <netinet/in.h>

#include <sys/types.h>
#include <arpa/inet.h>

#include <net/if.h>
#include <sys/ioctl.h>
#include <netinet/ip.h>
#include <linux/if_tunnel.h>
#include <linux/ip6_tunnel.h>
#include <pthread.h>
#include "common.h"

int tnl44_fd=0, tnl66_fd=0, tnl64_fd=0;
//
struct Tunnel_data
{
  int type;//66, 64, 46, 44
  struct in6_addr src;
  struct in6_addr dst;
  int link;//
  int ifindex;
  int last_access;
};
#define NTNL 100
struct Tunnel_data tunnel_pool[NTNL];

int find_tunnel(int type, void *src, void *dst, int link, int *feedback)
{
  *feedback=0;
  int beg=0;
  switch(type){
  case 66:
    beg=0;
    break;
  case 46:
    beg=25;
    break;
  case 44:
    beg=50;
    break;
  case 64:
    beg=75;
    break;
  }
  int i=beg;
  int min_access_time=0x7fffffff;
  int replacei=-1;
  for(;i<beg+25;++i){
    if(tunnel_pool[i].type==0){
	return i;
    }
    else {
      if(memcmp(src,&tunnel_pool[i].src,sizeof(struct in6_addr))==0&&
	 memcmp(dst,&tunnel_pool[i].dst,sizeof(struct in6_addr))==0&&
	 link == tunnel_pool[i].link)
	return i;
    }
    if(tunnel_pool[i].last_access<min_access_time){
      replacei=i;
      min_access_time = tunnel_pool[i].last_access;
      //NRU delete
    }
  }
  if(i==beg+25){
    *feedback=1;
    return replacei;
  }
}

//I think linear probe and 100 slots is enough!

//------------------interfaces-----------------------
int tnl_init()
{
  //this function should be called before any other functions.
  if ((tnl66_fd = socket(AF_INET6, SOCK_DGRAM, 0)) < 0)
    return -1;
  if ((tnl64_fd = socket(AF_INET, SOCK_DGRAM, 0)) < 0)
    return -1;
  if ((tnl44_fd = socket(AF_INET, SOCK_DGRAM, 0)) < 0)
    return -1;
  memset(tunnel_pool,0,sizeof(tunnel_pool));
  return 0;
}

int tnl_cleanup()
{
  int i;

  for(i=0;i<NTNL;++i){
    if(tunnel_pool[i].type){
      if(tunnel_pool[i].type==66)_tunnel66_del(tunnel_pool[i].ifindex);
      else if(tunnel_pool[i].type==44)_tunnel44_del(tunnel_pool[i].ifindex);
      else if(tunnel_pool[i].type==46){/*_tunnel46_del(tunnel_pool[i].ifindex);*/}//never comes here!
      else _tunnel64_del(tunnel_pool[i].ifindex);
    }
  }
  close(tnl66_fd);
  close(tnl64_fd);
  close(tnl44_fd);
  
  return 0;
}
//---------------------------------------------------
//6 in 6  or 4 in 6 tunnels
int tunnel66_add(struct in6_addr *local,
	       struct in6_addr *remote,
	       int link);
int tunnel66_mod(int ifindex,
	       struct in6_addr *local,
	       struct in6_addr *remote,
	       int link);
int tunnel66_del(int ifindex);
//---------------------------------------------------
// 6 in 4 tunnels (sit)
int tunnel64_add(struct in6_addr *local,
		struct in6_addr *remote,
		int link);
int tunnel64_mod(int ifindex,
		struct in6_addr *local,
		struct in6_addr *remote,
		int link);
int tunnel64_del(int ifindex);
//----------------------------------------------------
//4 in 4 tunnels 
int tunnel44_add(struct in6_addr *local,
		struct in6_addr *remote,
		 int link
		 );


int tunnel44_mod(int ifindex,
		struct in6_addr *local,
		struct in6_addr *remote,
		int link);
int tunnel44_del(int ifindex);
//-----------------------------------------------------

#define TDBG(format,args...) fprintf(stderr,format,##args)

int _tunnel66_add(struct in6_addr *local,
		 struct in6_addr *remote,
		 int link)
{
  fprintf(stderr,"adding 66 tnl %x:%x:%x:%x:%x:%x:%x:%x to %x:%x:%x:%x:%x:%x:%x:%x\n",
	  NIP6ADDR(local),NIP6ADDR(remote));
  struct ifreq ifr;
  struct ip6_tnl_parm parm;
  memset(&parm,0,sizeof(parm));
  parm.proto = 0;//IPPROTO_IPV6;
  parm.flags = IP6_TNL_F_MIP6_DEV|IP6_TNL_F_IGN_ENCAP_LIMIT;
  parm.hop_limit = 64;
  parm.laddr = *local;
  parm.raddr = *remote;
  parm.link = link;
  strcpy(ifr.ifr_name,"ip6tnl0");
  ifr.ifr_ifru.ifru_data = (void *)&parm;
  if (ioctl(tnl66_fd, SIOCADDTUNNEL, &ifr) < 0) {
    TDBG("tunnel66_add: SIOCADDTUNNEL failed status %d %s\n", 
	 errno, strerror(errno));
    goto err;
  }
  if (!(parm.flags & IP6_TNL_F_MIP6_DEV)) {
    TDBG("tunnel66_add: tunnel exists,but isn't used for MIPv6\n");
    goto err;
  }
  strcpy(ifr.ifr_name, parm.name);
  if (ioctl(tnl66_fd, SIOCGIFFLAGS, &ifr) < 0) {
    TDBG("tunnel66_add: SIOCGIFFLAGS failed status %d %s\n", 
	 errno, strerror(errno));
    goto err;
  }
  ifr.ifr_flags |= IFF_UP | IFF_RUNNING;
  if (ioctl(tnl66_fd, SIOCSIFFLAGS, &ifr) < 0) {
    TDBG("SIOCSIFFLAGS failed status %d %s\n",
	 errno, strerror(errno));
    goto err;
  }
  int ifindex;
  if (!(ifindex = if_nametoindex(parm.name))) {
    TDBG("no device called %s\n", parm.name);
    goto err;
  }
  return ifindex;
 err:
  return -1;
  
}
int _tunnel66_del(int ifindex);
int tunnel66_add(struct in6_addr *local,
		 struct in6_addr *remote,
		 int link)
{
  int del=0;
  int i = find_tunnel(66,local,remote,link,&del);
  if(del){
    _tunnel66_del(tunnel_pool[i].ifindex);
    tunnel_pool[i].type=0;
  }
  if(tunnel_pool[i].type==0){
    tunnel_pool[i].type=66;
    tunnel_pool[i].src=*local;
    tunnel_pool[i].dst=*remote;
    tunnel_pool[i].link=link;
    tunnel_pool[i].ifindex=_tunnel66_add(local,remote,link);
  }

  tunnel_pool[i].last_access=time(0);
  return tunnel_pool[i].ifindex;
}
  
int tunnel66_del(int ifindex)
{
  return 0;
}

int _tunnel66_del(int ifindex)
{
  struct ifreq ifr;
  int res = 0;
  char tnlname[100];
  if_indextoname(ifindex,tnlname);
  strcpy(ifr.ifr_name, tnlname);
  if ((res = ioctl(tnl66_fd, SIOCDELTUNNEL, &ifr)) < 0) {
    TDBG("SIOCDELTUNNEL failed status %d %s\n",
	 errno, strerror(errno));
    return -1;
  } 
  else
    TDBG("tunnel deleted\n");
  return 0;
}


int _tunnel64_add(struct in6_addr *local,
		 struct in6_addr *remote,
		 int link)
{
  struct ifreq ifr;
  struct ip_tunnel_parm parm4;
  memset(&parm4,0,sizeof(parm4));
  parm4.iph.version = 4;
  parm4.iph.ihl = 5;
  parm4.iph.frag_off = htons(IP_DF);
  parm4.iph.protocol = IPPROTO_IPV6;
  parm4.iph.ttl = 64;
  parm4.link = link;
  ipv6_unmap_addr(local, &parm4.iph.saddr);
  ipv6_unmap_addr(remote, &parm4.iph.daddr);
  strcpy(ifr.ifr_name,"sit0");
  ifr.ifr_ifru.ifru_data = (void *)&parm4;
  
  if (ioctl(tnl64_fd, SIOCADDTUNNEL, &ifr) < 0) {
    TDBG("tunnel64_add: SIOCADDTUNNEL failed status %d %s\n",
	 errno, strerror(errno));
    goto err;
  }
  strcpy(ifr.ifr_name, parm4.name);
  if (ioctl(tnl64_fd, SIOCGIFFLAGS, &ifr) < 0) {
    TDBG("tunnel64_add: SIOCGIFFLAGS failed status %d %s\n",
	 errno, strerror(errno));
    goto err;
  }
  ifr.ifr_flags |= IFF_UP | IFF_RUNNING;
  if (ioctl(tnl64_fd, SIOCSIFFLAGS, &ifr) < 0) {
    TDBG("tunnel64_add: SIOCSIFFLAGS failed status %d %s\n",
	 errno, strerror(errno));
    goto err;
  }
  int ifindex = if_nametoindex(parm4.name);
  if(ifindex==0){
    TDBG("no device called %s\n", parm4.name);
    return -1;
  }
  return ifindex;
 err:
  return -1;
}

int _tunnel64_del(int ifindex);
int tunnel64_add(struct in6_addr *local,
		 struct in6_addr *remote,
		 int link)
{
  int del=0;
  int i = find_tunnel(64,local,remote,link,&del);
  if(del){
    _tunnel64_del(tunnel_pool[i].ifindex);
    tunnel_pool[i].type=0;
  }
  if(tunnel_pool[i].type==0){
    tunnel_pool[i].type=64;
    tunnel_pool[i].src=*local;
    tunnel_pool[i].dst=*remote;
    tunnel_pool[i].link=link;
    tunnel_pool[i].ifindex=_tunnel64_add(local,remote,link);
  }
  tunnel_pool[i].last_access=time(0);
  return tunnel_pool[i].ifindex;
}
  
int tunnel64_del(int ifindex)
{
  return 0;
}

int _tunnel64_del(int ifindex)
{
    struct ifreq ifr;
  int res = 0;
  char tnlname[100];
  if_indextoname(ifindex,tnlname);
  strcpy(ifr.ifr_name, tnlname);
  if ((res = ioctl(tnl64_fd, SIOCDELTUNNEL, &ifr)) < 0) {
    TDBG("SIOCDELTUNNEL failed status %d %s\n",
	 errno, strerror(errno));
    return -1;
  } 
  else
    TDBG("tunnel deleted\n");
  return 0;
}

int _tunnel44_add(struct in6_addr *local,
		 struct in6_addr *remote,
		 int link
		 )
{

  struct ip_tunnel_parm parm4;
  struct ifreq ifr;
  memset(&parm4,0,sizeof(parm4));
  parm4.iph.version = 4;
  parm4.iph.ihl = 5;
  parm4.iph.frag_off = htons(IP_DF);/*IP flag: Don't fragment*/
  parm4.iph.protocol = IPPROTO_IPIP;
  parm4.iph.ttl = 64;
  parm4.link = link;
  ipv6_unmap_addr(local, &parm4.iph.saddr);
  ipv6_unmap_addr(remote, &parm4.iph.daddr);
  strcpy(ifr.ifr_name,"tunl0");
  ifr.ifr_ifru.ifru_data = (void *)&parm4;
  if (ioctl(tnl44_fd, SIOCADDTUNNEL, &ifr) < 0) {
    TDBG("tunnel44_add: SIOCADDTUNNEL failed status %d %s\n",
	 errno, strerror(errno));
    goto err;
  }
  strcpy(ifr.ifr_name, parm4.name);
  
  if(ioctl(tnl44_fd, SIOCGIFFLAGS, &ifr) < 0) {
    TDBG("tunnel44_add: SIOCGIFFLAGS failed status %d %s\n",
	 errno, strerror(errno));
    goto err;
  }
  
  ifr.ifr_flags |= IFF_UP | IFF_RUNNING;
  if (ioctl(tnl44_fd, SIOCSIFFLAGS, &ifr) < 0) {
    TDBG("tunnel44_add: SIOCSIFFLAGS failed status %d %s\n",
	 errno, strerror(errno));
    goto err;
  }
  int ifindex = if_nametoindex(parm4.name);
  if(ifindex==0){
    TDBG("no device called %s\n", parm4.name);
    goto err;
  }
  return ifindex;
 err:
  return -1;
}

int _tunnel44_del(int ifindex);
int tunnel44_add(struct in6_addr *local,
		 struct in6_addr *remote,
		 int link)
{
  int del=0;
  int i = find_tunnel(44,local,remote,link,&del);
  if(del){
    _tunnel44_del(tunnel_pool[i].ifindex);
    tunnel_pool[i].type=0;
  }
  if(tunnel_pool[i].type==0){
    tunnel_pool[i].type=44;
    tunnel_pool[i].src=*local;
    tunnel_pool[i].dst=*remote;
    tunnel_pool[i].link=link;
    tunnel_pool[i].ifindex=_tunnel44_add(local,remote,link);
  }

  tunnel_pool[i].last_access=time(0);
  return tunnel_pool[i].ifindex;
}
int tunnel44_del(int ifindex)
{
  return 0;//do nothing
}
int _tunnel44_del(int ifindex)
{
  struct ifreq ifr;
  int res = 0;
  char tnlname[100];
  if_indextoname(ifindex,tnlname);
  strcpy(ifr.ifr_name, tnlname);
  if ((res = ioctl(tnl44_fd, SIOCDELTUNNEL, &ifr)) < 0) {
    TDBG("SIOCDELTUNNEL failed status %d %s\n",
	 errno, strerror(errno));
    return -1;
  } 
  else
    TDBG("tunnel deleted\n");
  return 0;
}


#endif

#define TNL_NO_TEST 1
#ifndef TNL_NO_TEST
#define TNL_NO_TEST

int main()
{
  tnl_init();
  struct in6_addr  
    ha={0x3f,0xfe,0x5,0x01,0xff,0xff,0x01,0x0,0,0,0,0,0,0,0x0,0x8}
  ,hoa={0x3f,0xfe,0x5,0x01,0xff,0xff,0x01,0x0,0,0,0,0,0,0,0x0,0x1}
  ,coa={0x20,0x01,0xc,0xc0,0x20,0x26,0x1,0x89,0x02,0x0c,0x29,0xff,0xfe,0x5d,
        0xe2,0x9c};
  struct in_addr ha4,hoa4,coa4;
  ha4.s_addr=(10<<0)|(21<<8)|(5<<16)|(53<<24);
  hoa4.s_addr=(192<<0)|(168<<8)|(10<<16)|(1<<24);
  coa4.s_addr=(182<<0)|(11<8)|(22<<16)|(33<<24);
  
  struct in6_addr tmp1,tmp2;
  //first let's create ip6ip6 tunnel 
  int eth0ifindex = if_nametoindex("eth0");
  int ip66tnl = tunnel66_add(&coa,&ha,eth0ifindex);
  if(ip66tnl>0){
    fprintf(stderr,"add ip66tnl Succeeded\n");
    int ret = tunnel66_del(ip66tnl);
    if(ret<0)fprintf(stderr,"delete ip66tnl failed\n");
    else fprintf(stderr,"delete ip66tnl succeed\n");
  }
  ipv6_map_addr(&tmp1,&ha4);
  ipv6_map_addr(&tmp2,&hoa4);
  
  int ip64tnl1 = tunnel64_add(&tmp2,&tmp1,eth0ifindex);
  if(ip64tnl1>0){
    fprintf(stderr,"sit created successfully\n");
    int ret = tunnel64_del(ip64tnl1);
    if(ret ==0 )fprintf(stderr,"sit delete succeed\n");
  }

  int ip44tnl1 = tunnel44_add(&tmp2,&tmp1,eth0ifindex);
  if(ip44tnl1>0){
    fprintf(stderr,"ipip created successfully\n");
    int ret = tunnel44_del(ip44tnl1);
    if(ret == 0)fprintf(stderr,"delete ipip succeeded\n");
  }

    



}

#endif
