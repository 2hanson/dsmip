/*
 * get MAC address by IP address
 * Lin Hui
 * linhui08@gmail.com
 *last modified: June 30. 2010
 */

#ifndef __LH__ARP__H__
#define __LH__ARP__H__
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include <unistd.h>
#include <netdb.h>
#include <sys/socket.h>
#include <sys/un.h>
#include <sys/ioctl.h>
#include <netinet/in.h>
#include <net/if.h>
#include <sys/types.h>
#include <asm/types.h>
#include <bits/time.h>
#include <features.h>
//#if __GLIBC__ >= 2 && __GLIBC_MINOR >= 1 d:syl
#if 1
        #include <netpacket/packet.h>
        #include <net/ethernet.h>
#else
        #include <asm/types.h>
        #include <linux/if_packet.h>
        #include <linux/if_ether.h>
#endif
#include <netinet/if_ether.h>

#define INLEN 4
#ifndef MAC_BCAST_ADDR
#define MAC_BCAST_ADDR  (uint8_t *) "\xff\xff\xff\xff\xff\xff"
#endif

int get_ifi(char *dev, char *mac, int macln, struct in_addr *lc_addr, int ipln);
void prmac(u_char *ptr);



int get_ifi(char *dev, char * mac, int macln, struct in_addr *lc_addr, int ipln)
{
  int reqfd, n;
  struct ifreq macreq;
  reqfd = socket(AF_INET, SOCK_DGRAM, 0);
  strcpy(macreq.ifr_name, dev);
  if(ioctl(reqfd, SIOCGIFHWADDR, &macreq) != 0)
    return 1;
  memcpy(mac, macreq.ifr_hwaddr.sa_data, macln);
  if(ioctl(reqfd, SIOCGIFADDR, &macreq) != 0)
    return 1;
  memcpy(lc_addr, &((struct sockaddr_in *)(&macreq.ifr_addr))->sin_addr, ipln);
  return 0;
}      



void prmac(u_char *ptr)
{
  fprintf(stderr,
	  "Peer MAC is: %02x:%02x:%02x:%02x:%02x:%02x\n",
	  *ptr,*(ptr+1),*(ptr+2),*(ptr+3),*(ptr+4),*(ptr+5));
}



int get_mac_by_ip(int ifindex, int ip, char mac[6])
{
  int reqfd, recvfd, salen, n;   
  char recv_buf[120], rep_addr[16];
  struct in_addr lc_addr, req_addr;
  struct sockaddr_ll reqsa, repsa;
  struct arp_pkt {
    struct ether_header eh;
    struct ether_arp ea;
    u_char padding[18];
  } req;
  bzero(&reqsa, sizeof(reqsa));
  reqsa.sll_family = PF_PACKET;
  reqsa.sll_ifindex = ifindex;
  char ifname[100];
  if_indextoname(ifindex,ifname);
  if((reqfd = socket(PF_PACKET, SOCK_RAW, htons(ETH_P_RARP))) < 0) {
    perror("Socket error");
    exit(1);
  }
  bzero(&req, sizeof(req));
  if(get_ifi(ifname, mac, ETH_ALEN, &lc_addr, INLEN)) {
    fprintf(stderr, "Error: Get host's information failed\n");
    return -1;
  }
  memcpy(req.eh.ether_dhost, MAC_BCAST_ADDR, ETH_ALEN);
  memcpy(req.eh.ether_shost, mac, ETH_ALEN);
  req.eh.ether_type = htons(ETHERTYPE_ARP);
  req.ea.arp_hrd = htons(ARPHRD_ETHER);
  req.ea.arp_pro = htons(ETHERTYPE_IP);
  req.ea.arp_hln = ETH_ALEN;
  req.ea.arp_pln = INLEN;
  req.ea.arp_op = htons(ARPOP_REQUEST);
  memcpy(req.ea.arp_sha, mac, ETH_ALEN);
  memcpy(req.ea.arp_spa, &lc_addr, INLEN);
  memcpy(req.ea.arp_tpa,&ip,sizeof(int));
  recvfd = socket(PF_PACKET, SOCK_RAW, htons(ETH_P_ARP));
  if((n = sendto(reqfd, &req, sizeof(req), 0, (struct sockaddr *)&reqsa, sizeof(reqsa))) <= 0) {
    perror("Sendto error");
    return -1;
  }
  bzero(recv_buf, sizeof(recv_buf));
  bzero(&repsa, sizeof(repsa));
  salen = sizeof(struct sockaddr_ll);
  fd_set rfds;
  FD_ZERO(&rfds);
  FD_SET(recvfd, &rfds);
  struct timeval tv;
  tv.tv_sec = 1;
  tv.tv_usec = 0;
  int retval = 0;
  while(1) {
    retval=select(recvfd+1,&rfds,0,0,&tv);
    if(retval<=0)return -1;
    if((n = recvfrom(recvfd, recv_buf, sizeof(req), 0, (struct sockaddr *)&repsa, &salen)) <= 0) {
      perror("Recvfrom error");
      return -1;
    }
    if( ntohs(*(__be16 *)(recv_buf + 20))==2 && !memcmp(req.ea.arp_tpa, recv_buf + 28, 4) ) {
      fprintf(stderr,"Peer IP is: %s\n", 
	      inet_ntop(AF_INET, (struct in_addr *)(recv_buf + 28), rep_addr, 1024));
      memcpy(mac,recv_buf+22,6);
      prmac(mac); //prmac( (u_char *)(recv_buf + 6) );
      break;
    }
  }
}


#endif


#if 0
int main()
{
  char mac[6];
  get_mac_by_ip(2,(172<<0)|(16<<8)|(0<<16)|(1<<24),mac);
}
#endif
