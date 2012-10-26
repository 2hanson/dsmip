/*
 * dhcp related functions
 * Lin Hui
 * linhui08@gmail.com
 * June 28, 2010
 */
#ifndef _LH_DHCP_H
#define _LH_DHCP_H 1


#include <syslog.h>
#include <errno.h>
#include <netinet/icmp6.h>
#include <net/if.h>
#include <linux/types.h>
#include <linux/ipv6_route.h>
#include <linux/in_route.h>

#include <stdio.h>
#include <string.h>
#include <unistd.h>

#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>

#include <linux/if_ether.h>
#include <linux/if_packet.h>
#include <netinet/ip.h>
#include <linux/udp.h>

#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <pthread.h>
#include <sys/ioctl.h>
#include <stdarg.h>
#include <linux/kernel.h>
#include "mn-xfrm.h"
#include "rtnl.h"
#include "arp.h"
#define DHCP_RUNNING	1
#define DHCP_ACQUIRED	2

/* udhcp imported, rfc related defines */

#define DHCP_INIT_SELECTING	0
#define DHCP_REQUESTING		1
#define DHCP_BOUND		2
#define DHCP_RENEWING		3
#define DHCP_REBINDING		4
#define DHCP_INIT_REBOOT	5
#define DHCP_RENEW_REQUESTED	6
#define DHCP_RELEASED		7
#define DHCP_POLL		8

#define DHCP_SERVER_PORT	67
#define DHCP_CLIENT_PORT	68

#define DHCP_MAGIC		0x63825363

/* DHCP option codes (partial list) */
#define DHCP_PADDING		0x00
#define DHCP_SUBNET		0x01
#define DHCP_TIME_OFFSET	0x02
#define DHCP_ROUTER		0x03
#define DHCP_TIME_SERVER	0x04
#define DHCP_NAME_SERVER	0x05
#define DHCP_DNS_SERVER		0x06
#define DHCP_LOG_SERVER		0x07
#define DHCP_COOKIE_SERVER	0x08
#define DHCP_LPR_SERVER		0x09
#define DHCP_HOST_NAME		0x0c
#define DHCP_BOOT_SIZE		0x0d
#define DHCP_DOMAIN_NAME	0x0f
#define DHCP_SWAP_SERVER	0x10
#define DHCP_ROOT_PATH		0x11
#define DHCP_IP_TTL		0x17
#define DHCP_MTU		0x1a
#define DHCP_BROADCAST		0x1c
#define DHCP_NTP_SERVER		0x2a
#define DHCP_WINS_SERVER	0x2c
#define DHCP_REQUESTED_IP	0x32
#define DHCP_LEASE_TIME		0x33
#define DHCP_OPTION_OVER	0x34
#define DHCP_MESSAGE_TYPE	0x35
#define DHCP_SERVER_ID		0x36
#define DHCP_PARAM_REQ		0x37
#define DHCP_MESSAGE		0x38
#define DHCP_MAX_SIZE		0x39
#define DHCP_T1			0x3a
#define DHCP_T2			0x3b
#define DHCP_VENDOR		0x3c
#define DHCP_CLIENT_ID		0x3d

#define DHCP_END		0xFF


#define DHCP_BOOTREQUEST	1
#define DHCP_BOOTREPLY		2

#define DHCP_ETH_10MB		1
#define DHCP_ETH_10MB_LEN	6

#define DHCPDISCOVER		1
#define DHCPOFFER		2
#define DHCPREQUEST		3
#define DHCPDECLINE		4
#define DHCPACK			5
#define DHCPNAK			6
#define DHCPRELEASE		7
#define DHCPINFORM		8

#define DHCP_BROADCAST_FLAG	0x8000

#define DHCP_OPTION_FIELD	0
#define DHCP_FILE_FIELD		1
#define DHCP_SNAME_FIELD	2

/* miscellaneous defines */
#define DHCP_MAC_BCAST_ADDR	(unsigned char *) "\xff\xff\xff\xff\xff\xff"
#define DHCP_OPT_CODE		0
#define DHCP_OPT_LEN		1
#define DHCP_OPT_DATA		2
#define DHCP_OPTION_REQ		0x10
#define DHCP_OPTION_LIST	0x20
#define DHCP_OPTION_FIELD       0
#define DHCP_FILE_FIELD         1
#define DHCP_SNAME_FIELD        2
#define DHCP_TYPE_MASK		0x0F

struct dhcp_message {
        u_int8_t op;
        u_int8_t htype;
        u_int8_t hlen;
        u_int8_t hops;
        u_int32_t xid;
        u_int16_t secs;
        u_int16_t flags;
        u_int32_t ciaddr;
        u_int32_t yiaddr;
        u_int32_t siaddr;
        u_int32_t giaddr;
        u_int8_t chaddr[16];
        u_int8_t sname[64];
        u_int8_t file[128];
        u_int32_t cookie;
        u_int8_t options[308]; /* 312 - cookie */
};

struct udp_dhcp_packet {
        struct iphdr ip;
        struct udphdr udp;
        struct dhcp_message data;
};
struct dhcp_option {
        char name[10];
        char flags;
        unsigned char code;
};

struct option_set {
        unsigned char *data;
        struct option_set *next;
};


enum {
  DHCP_OPTION_IP=1,
  DHCP_OPTION_IP_PAIR,
  DHCP_OPTION_STRING,
  DHCP_OPTION_BOOLEAN,
  DHCP_OPTION_U8,
  DHCP_OPTION_U16,
  DHCP_OPTION_S16,
  DHCP_OPTION_U32,
  DHCP_OPTION_S32
};

struct dhcp_option dhcp_options[] = {
  /* name[10]	flags							code */
  {"subnet",	DHCP_OPTION_IP | DHCP_OPTION_REQ,			0x01},
  {"timezone",	DHCP_OPTION_S32,					0x02},
  {"router",	DHCP_OPTION_IP | DHCP_OPTION_LIST | DHCP_OPTION_REQ,	0x03},
  {"timesvr",	DHCP_OPTION_IP | DHCP_OPTION_LIST,			0x04},
  {"namesvr",	DHCP_OPTION_IP | DHCP_OPTION_LIST,			0x05},
  {"dns",	DHCP_OPTION_IP | DHCP_OPTION_LIST | DHCP_OPTION_REQ,	0x06},
  {"logsvr",	DHCP_OPTION_IP | DHCP_OPTION_LIST,			0x07},
  {"cookiesvr",	DHCP_OPTION_IP | DHCP_OPTION_LIST,			0x08},
  {"lprsvr",	DHCP_OPTION_IP | DHCP_OPTION_LIST,			0x09},
  {"hostname",	DHCP_OPTION_STRING | DHCP_OPTION_REQ,			0x0c},
  {"bootsize",	DHCP_OPTION_U16,					0x0d},
  {"domain",	DHCP_OPTION_STRING | DHCP_OPTION_REQ,			0x0f},
  {"swapsvr",	DHCP_OPTION_IP,						0x10},
  {"rootpath",	DHCP_OPTION_STRING,					0x11},
  {"ipttl",	DHCP_OPTION_U8,						0x17},
  {"mtu",	DHCP_OPTION_U16,					0x1a},
  {"broadcast",	DHCP_OPTION_IP | DHCP_OPTION_REQ,			0x1c},
  {"ntpsrv",	DHCP_OPTION_IP | DHCP_OPTION_LIST,			0x2a},
  {"wins",	DHCP_OPTION_IP | DHCP_OPTION_LIST,			0x2c},
  {"requestip",	DHCP_OPTION_IP,						0x32},
  {"lease",	DHCP_OPTION_U32,					0x33},
  {"dhcptype",	DHCP_OPTION_U8,						0x35},
  {"serverid",	DHCP_OPTION_IP,						0x36},
  {"message",	DHCP_OPTION_STRING,					0x38},
  {"tftp",	DHCP_OPTION_STRING,					0x42},
  {"bootfile",	DHCP_OPTION_STRING,					0x43},
  {"",		0x00,							0x00}
};

/* Lengths of the different option types */
int dhcp_option_lengths[] = {
  [DHCP_OPTION_IP] =		4,
  [DHCP_OPTION_IP_PAIR] =	8,
  [DHCP_OPTION_BOOLEAN] =	1,
  [DHCP_OPTION_STRING] =	1,
  [DHCP_OPTION_U8] =		1,
  [DHCP_OPTION_U16] =		2,
  [DHCP_OPTION_S16] =		2,
  [DHCP_OPTION_U32] =		4,
  [DHCP_OPTION_S32] =		4
};

u_int16_t checksum(void *addr, int count)
{
	/* Compute Internet Checksum for "count" bytes
	 *         beginning at location "addr".
	 */
	register int32_t sum = 0;
	u_int16_t *source = (u_int16_t *) addr;

	while (count > 1)  {
		/*  This is the inner loop */
		sum += *source++;
		count -= 2;
	}

	/*  Add left-over byte, if any */
	if (count > 0) {
		/* Make sure that the left-over byte is added correctly both
		 * with little and big endian hosts */
		u_int16_t tmp = 0;
		*(unsigned char *) (&tmp) = * (unsigned char *) source;
		sum += tmp;
	}
	/*  Fold 32-bit sum to 16 bits */
	while (sum >> 16)
		sum = (sum & 0xffff) + (sum >> 16);

	return ~sum;
}

/*
   Construct a IP and UDP header for a packet
   and specify the source and dest hardware address
*/
int raw_packet(struct dhcp_message *payload, 
	       u_int32_t source_ip, int source_port,
	       u_int32_t dest_ip, int dest_port, 
	       unsigned char *dest_arp, int ifindex)
{
  int fd;
  int result;
  struct sockaddr_ll dest;
  struct udp_dhcp_packet packet;

  if ((fd = socket(PF_PACKET, SOCK_DGRAM, htons(ETH_P_IP))) < 0) {
    fprintf(stderr, "dhcp_dna: socket call failed: %s\n", strerror(errno));
    return -1;
  }

  memset(&dest, 0, sizeof(dest));
  memset(&packet, 0, sizeof(packet));

  dest.sll_family = AF_PACKET;
  dest.sll_protocol = htons(ETH_P_IP);
  dest.sll_ifindex = ifindex;
  dest.sll_halen = 6;
  memcpy(dest.sll_addr, dest_arp, 6);
  if (bind(fd, (struct sockaddr *)&dest, sizeof(struct sockaddr_ll)) < 0) {
    fprintf(stderr, "dhcp_dna: bind call failed: %s\n", strerror(errno));
    close(fd);
    return -1;
  }

  packet.ip.protocol = IPPROTO_UDP;
  packet.ip.saddr = source_ip;
  packet.ip.daddr = dest_ip;
  packet.udp.source = htons(source_port);
  packet.udp.dest = htons(dest_port);
  packet.udp.len = htons(sizeof(packet.udp) + sizeof(struct dhcp_message)); /* cheat on the psuedo-header */
  packet.ip.tot_len = packet.udp.len;
  memcpy(&(packet.data), payload, sizeof(struct dhcp_message));
  packet.udp.check = checksum(&packet, sizeof(struct udp_dhcp_packet));

  packet.ip.tot_len = htons(sizeof(struct udp_dhcp_packet));
  packet.ip.ihl = sizeof(packet.ip) >> 2;
  packet.ip.version = IPVERSION;
  packet.ip.ttl = IPDEFTTL;
  packet.ip.check = checksum(&(packet.ip), sizeof(packet.ip));

  result = sendto(fd, &packet, sizeof(struct udp_dhcp_packet), 0, (struct sockaddr *) &dest, sizeof(dest));
  if (result <= 0) {
    fprintf(stderr, "dhcp_dna: write on socket failed: %s\n", strerror(errno));
  }

  close(fd);
  return result;
}


/*
   Let the kernel do all the work for packet generation
*/
int kernel_packet(struct dhcp_message *payload, u_int32_t source_ip, int source_port,
		   u_int32_t dest_ip, int dest_port)
{
  int n = 1;
  int fd, result;
  struct sockaddr_in client;

  if ((fd = socket(PF_INET, SOCK_DGRAM, IPPROTO_UDP)) < 0)
    return -1;

  if (setsockopt(fd, SOL_SOCKET, SO_REUSEADDR, (char *) &n, sizeof(n)) == -1)
    return -1;

  memset(&client, 0, sizeof(client));
  client.sin_family = AF_INET;
  client.sin_port = htons(source_port);
  client.sin_addr.s_addr = source_ip;

  if (bind(fd, (struct sockaddr *)&client, sizeof(struct sockaddr)) == -1)
    return -1;

  memset(&client, 0, sizeof(client));
  client.sin_family = AF_INET;
  client.sin_port = htons(dest_port);
  client.sin_addr.s_addr = dest_ip;

  if (connect(fd, (struct sockaddr *)&client, sizeof(struct sockaddr)) == -1)
    return -1;

  result = write(fd, payload, sizeof(struct dhcp_message));
  close(fd);
  return result;
}

/*
   Create a random xid, based on (hopefully) random data from /dev/urandom
*/
unsigned long random_xid(void)
{
  static int initialized;

  if (!initialized) {
    int fd;
    unsigned long seed;

    fd = open("/dev/urandom", 0);
    if (fd < 0 || read(fd, &seed, sizeof(seed)) < 0)
      {
	fprintf(stderr, "dhcp_dna: could not load seed from /dev/urandom: %s\n",
		strerror(errno));
	seed = time(0);
      }

    if (fd >= 0) close(fd);
    srand(seed);
    initialized++;
  }

  return rand();
}
/*
   get an option with bounds checking (warning, not aligned).
*/
unsigned char * get_option(struct dhcp_message *packet, int code)
{
  int i, length;
  unsigned char *optionptr;
  int over = 0, done = 0, curr = DHCP_OPTION_FIELD;

  optionptr = packet->options;
  i = 0;
  length = 308;
  while (!done) {

    if (i >= length) {
      fprintf(stderr, "dhcp_dna: bogus packet, option fields too long.\n");
      return NULL;
    }

    if (optionptr[i + DHCP_OPT_CODE] == code)
      {
	if (i + 1 + optionptr[i + DHCP_OPT_LEN] >= length)
	  {
	    fprintf(stderr, "dhcp_dna: bogus packet, option fields too long.\n");
	    return NULL;
	  }
	return optionptr + i + 2;
      }

    switch (optionptr[i + DHCP_OPT_CODE]) {
    case DHCP_PADDING:
      i++;
      break;
    case DHCP_OPTION_OVER:
      if (i + 1 + optionptr[i + DHCP_OPT_LEN] >= length) {
	fprintf(stderr, "dhcp_dna: bogus packet, option fields too long.\n");
	return NULL;
      }
      over = optionptr[i + 3];
      i += optionptr[DHCP_OPT_LEN] + 2;
      break;
    case DHCP_END:
      if (curr == DHCP_OPTION_FIELD && over & DHCP_FILE_FIELD) {
	optionptr = packet->file;
	i = 0;
	length = 128;
	curr = DHCP_FILE_FIELD;
      } else if (curr == DHCP_FILE_FIELD && over & DHCP_SNAME_FIELD) {
	optionptr = packet->sname;
	i = 0;
	length = 64;
	curr = DHCP_SNAME_FIELD;
      } else done = 1;
      break;
    default:
      i += optionptr[DHCP_OPT_LEN + i] + 2;
    }
  }
  return NULL;
}


/*
   return the position of the 'end' option (no bounds checking)
*/
int end_option(unsigned char *optionptr)
{
  int i = 0;

  while (optionptr[i] != DHCP_END) {
    if (optionptr[i] == DHCP_PADDING) i++;
    else i += optionptr[i + DHCP_OPT_LEN] + 2;
  }
  return i;
}

/*
   add an option string to the options
   (an option string contains an option code, length, then data)

   heh, it looks so much like that TLV stuff
*/
int add_option_string(unsigned char *optionptr, unsigned char *string)
{
  int end = end_option(optionptr);

  /* end position + string length + option code/length + end option */
  if (end + string[DHCP_OPT_LEN] + 2 + 1 >= 308) {
    fprintf(stderr, "dhcp_dna: Option 0x%02x did not fit into the packet!\n", string[DHCP_OPT_CODE]);
    return 0;
  }
  memcpy(optionptr + end, string, string[DHCP_OPT_LEN] + 2);
  optionptr[end + string[DHCP_OPT_LEN] + 2] = DHCP_END;
  return string[DHCP_OPT_LEN] + 2;
}
/*
   add a one to four byte option to a packet
*/
int add_simple_option(unsigned char *optionptr, unsigned char code, u_int32_t data)
{
  char length = 0;
  int i;
  unsigned char option[2 + 4];
  unsigned char *u8;
  u_int16_t *u16;
  u_int32_t *u32;
  u_int32_t aligned;
  u8 = (unsigned char *) &aligned;
  u16 = (u_int16_t *) &aligned;
  u32 = &aligned;

  for (i = 0; dhcp_options[i].code; i++)
    if (dhcp_options[i].code == code) {
      length = dhcp_option_lengths[dhcp_options[i].flags & DHCP_TYPE_MASK];
    }

  if (!length) {
    fprintf(stderr, "dhcp_dna: could not add option 0x%02x\n", code);
    return 0;
  }

  option[DHCP_OPT_CODE] = code;
  option[DHCP_OPT_LEN] = length;

  switch (length) {
  case 1: *u8 =  data; break;
  case 2: *u16 = data; break;
  case 4: *u32 = data; break;
  }

  memcpy(option + 2, &aligned, length);
  return add_option_string(optionptr, option);
}

void init_header(struct dhcp_message *packet, char type)
{
  memset(packet, 0, sizeof(struct dhcp_message));
  switch (type) {
  case DHCPDISCOVER:
  case DHCPREQUEST:
  case DHCPRELEASE:
  case DHCPINFORM:
    packet->op = DHCP_BOOTREQUEST;
    break;
  case DHCPOFFER:
  case DHCPACK:
  case DHCPNAK:
    packet->op = DHCP_BOOTREPLY;
  }
  packet->htype = DHCP_ETH_10MB;
  packet->hlen = DHCP_ETH_10MB_LEN;
  packet->cookie = htonl(DHCP_MAGIC);
  packet->options[0] = DHCP_END;
  add_simple_option(packet->options, DHCP_MESSAGE_TYPE, type);
}
/*
   Add a paramater request list for stubborn DHCP servers. Pull the data
   from the struct in options.c. Don't do bounds checking here because it
   goes towards the head of the packet.
*/
static void add_requests(struct dhcp_message *packet)
{
  int end = end_option(packet->options);
  int i, len = 0;

  packet->options[end + DHCP_OPT_CODE] = DHCP_PARAM_REQ;
  for (i = 0; dhcp_options[i].code; i++)
    if (dhcp_options[i].flags & DHCP_OPTION_REQ)
      packet->options[end + DHCP_OPT_DATA + len++] = dhcp_options[i].code;
  packet->options[end + DHCP_OPT_LEN] = len;
  packet->options[end + DHCP_OPT_DATA + len] = DHCP_END;

}
static void init_packet(char * mac, struct dhcp_message *packet, char type)
{
  struct vendor  {
    char vendor, length;
    char str[sizeof("umip 0.4")];
  } vendor_id = { DHCP_VENDOR, sizeof("umip 0.4") - 1, "umip 0.4"};
  char clientid[6+3];
  clientid[DHCP_OPT_CODE] = DHCP_CLIENT_ID;
  clientid[DHCP_OPT_LEN] = 7;
  clientid[DHCP_OPT_DATA] = 1;
  memcpy(clientid + 3, mac, 6);
  init_header(packet, type);
  memcpy(packet->chaddr, mac, 6);
  add_option_string(packet->options, clientid);
  add_option_string(packet->options, (unsigned char *) &vendor_id);
}

/*
 * create and bind on a raw socket 
 */
int raw_socket(int ifindex)
{
  fprintf(stderr,"dhcp_dna: raw_socket called\n");
  int fd;
  struct sockaddr_ll sock;
  if ((fd = socket(PF_PACKET, SOCK_DGRAM, htons(ETH_P_IP))) < 0) {
    fprintf(stderr, "dhcp_dna: socket call failed: %s", strerror(errno));
    return -1;
  }

  sock.sll_family = AF_PACKET;
  sock.sll_protocol = htons(ETH_P_IP);
  sock.sll_ifindex = ifindex;
  if (bind(fd, (struct sockaddr *) &sock, sizeof(sock)) < 0) {
    fprintf(stderr, "dhcp_dna: bind call failed: %s", strerror(errno));
    close(fd);
    return -1;
  }
  return fd;
}

/*
 * listen on udp port, bind on interface inf
 * inf, of type char*, is the name of interface
 * ip, my ip address(listen on packets destined to this address)
 */
int kernel_socket(unsigned int ip, int port, char *inf)
{
  fprintf(stderr,"dhcp_dna: kernel_socket called\n");
  struct ifreq interface;
  int fd;
  struct sockaddr_in addr;
  int n = 1;

  fprintf(stderr, "dhcp_dna: Opening listen socket on 0x%08x:%d %s\n", ip, port, inf);
  if ((fd = socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP)) < 0) {
    fprintf(stderr, "dhcp_dna: socket call failed: %s", strerror(errno));
    return -1;
  }

  memset(&addr, 0, sizeof(addr));
  addr.sin_family = AF_INET;
  addr.sin_port = htons(port);
  addr.sin_addr.s_addr = ip;

  if (setsockopt(fd, SOL_SOCKET, SO_REUSEADDR, (char *) &n, sizeof(n)) == -1) {
    close(fd);
    return -1;
  }
  if (setsockopt(fd, SOL_SOCKET, SO_BROADCAST, (char *) &n, sizeof(n)) == -1) {
    close(fd);
    return -1;
  }

  strncpy(interface.ifr_ifrn.ifrn_name, inf, IFNAMSIZ);
  if (setsockopt(fd, SOL_SOCKET, SO_BINDTODEVICE,(char *)&interface, sizeof(interface)) < 0) {
    close(fd);
    return -1;
  }

  if (bind(fd, (struct sockaddr *)&addr, sizeof(struct sockaddr)) == -1) {
    close(fd);
    return -1;
  }

  return fd;
}


/*
 *  Resolve interface index and mac address based on user friendly name
 *  copy the mac address of interface to arp
 */
int read_interface_hwaddr(char *interface, unsigned char *arp)
{
  int fd;
  struct ifreq ifr;

  memset(&ifr, 0, sizeof(struct ifreq));
  if((fd = socket(AF_INET, SOCK_RAW, IPPROTO_RAW)) >= 0) {
    ifr.ifr_addr.sa_family = AF_INET;
    strcpy(ifr.ifr_name, interface);

    if (ioctl(fd, SIOCGIFINDEX, &ifr) == 0) {
      //success
    } else {
      fprintf(stderr, "dhcp_dna: SIOCGIFINDEX failed!: %s", strerror(errno));
      return -1;
    }
    
    if (ioctl(fd, SIOCGIFHWADDR, &ifr) == 0) {
      memcpy(arp, ifr.ifr_hwaddr.sa_data, 6);
      fprintf(stderr, "dhcp_dna: adapter hardware address %02x:%02x:%02x:%02x:%02x:%02x\n",
	      arp[0], arp[1], arp[2], arp[3], arp[4], arp[5]);
    } else {
      fprintf(stderr, "SIOCGIFHWADDR failed!: %s", strerror(errno));
      return -1;
    }

  } else {
    fprintf(stderr, "dhcp_dna: socket failed!: %s", strerror(errno));
    return -1;
  }
  close(fd);
  return 0;
}

/*
  return: -1 on errors that are fatal for the socket
          -2 for those that are not
*/
int get_raw_packet(struct dhcp_message *payload, int fd)
{
  int bytes;
  struct udp_dhcp_packet packet;
  u_int32_t source, dest;
  u_int16_t check;

  memset(&packet, 0, sizeof(struct udp_dhcp_packet));
  bytes = read(fd, &packet, sizeof(struct udp_dhcp_packet));
  if (bytes < 0) {
    fprintf(stderr, "dhcp_dna: couldn't read on raw listening socket, ignoring\n");
    usleep(500000); /* possible down interface, looping condition */
    return -1;
  }

  if (bytes < (int) (sizeof(struct iphdr) + sizeof(struct udphdr))) {
    fprintf(stderr, "dhcp_dna: message too short, ignoring\n");
    return -2;
  }

  if (bytes < ntohs(packet.ip.tot_len)) {
    fprintf(stderr, "dhcp_dna: truncated packet\n");
    return -2;
  }

  /* ignore any extra garbage bytes */
  bytes = ntohs(packet.ip.tot_len);

  /* Make sure its the right packet for us, and that it passes sanity checks */
  if (packet.ip.protocol != IPPROTO_UDP || packet.ip.version != IPVERSION ||
      packet.ip.ihl != sizeof(packet.ip) >> 2 || packet.udp.dest != htons(DHCP_CLIENT_PORT) ||
      bytes > (int) sizeof(struct udp_dhcp_packet) ||
      ntohs(packet.udp.len) != (short) (bytes - sizeof(packet.ip)))
    {
      return -2;
    }

  /* check IP checksum */
  check = packet.ip.check;
  packet.ip.check = 0;
  if (check != checksum(&(packet.ip), sizeof(packet.ip))) {
    return -1;
  }

  /* verify the UDP checksum by replacing the header with a psuedo header */
  source = packet.ip.saddr;
  dest = packet.ip.daddr;
  check = packet.udp.check;
  packet.udp.check = 0;
  memset(&packet.ip, 0, sizeof(packet.ip));

  packet.ip.protocol = IPPROTO_UDP;
  packet.ip.saddr = source;
  packet.ip.daddr = dest;
  packet.ip.tot_len = packet.udp.len; /* cheat on the psuedo-header */
  if (check && check != checksum(&packet, bytes)) {
    return -2;
  }

  memcpy(payload, &(packet.data), bytes - (sizeof(packet.ip) + sizeof(packet.udp)));

  if (ntohl(payload->cookie) != DHCP_MAGIC) {
    return -2;
  }
  fprintf(stderr, "dhcp_dna: DHCP packet received\n");
  return bytes - (sizeof(packet.ip) + sizeof(packet.udp));
}

/*
   read a packet from socket fd
   return : -1 on read error
            -2 on packet error
*/
int get_packet(struct dhcp_message *packet, int fd)
{
  fprintf(stderr,"get_packet called\n");
  int bytes;
  int i;
  const char broken_vendors[][8] = {
    "MSFT 98",
    ""
  };
  char unsigned *vendor;

  memset(packet, 0, sizeof(struct dhcp_message));
  bytes = read(fd, packet, sizeof(struct dhcp_message));
  if (bytes < 0) {
    fprintf(stderr, "dhcp_dna: couldn't read on listening socket, ignoring\n");
    return -1;
  }
  
  if (ntohl(packet->cookie) != DHCP_MAGIC) {
    return -2;
  }
  if (packet->op == DHCP_BOOTREQUEST &&
      (vendor = get_option(packet, DHCP_VENDOR)))
    {
      for (i = 0; broken_vendors[i][0]; i++) {
	if (vendor[DHCP_OPT_LEN - 2] == (unsigned char) strlen((const char *)broken_vendors[i]) &&
	    !strncmp((const char *)vendor, (const char *)broken_vendors[i], vendor[DHCP_OPT_LEN - 2]))
	  {
	    fprintf(stderr, "dhcp_dna: broken client (%s), forcing broadcast\n",
		    broken_vendors[i]);
	    packet->flags |= htons(DHCP_BROADCAST_FLAG);
	  }
      }
    }

  return bytes;
}


/*
  Broadcast a DHCP discover packet to the network
  with an optionally requested IP
*/
int send_discover(int ifindex, char * ifname, 
		  unsigned long xid, 
		  unsigned long requested)
{
  char mac[6];
  if(read_interface_hwaddr(ifname, mac)<0){
    fprintf(stderr, "dhcp_dna(send_discover): read_interface_hwaddr error\n");
    return -1;
  }
  struct in_addr any_addr;
  int ret;
  struct dhcp_message packet;
  any_addr.s_addr=0;
  init_packet(mac, &packet, DHCPDISCOVER);
  packet.xid = xid;
  if (requested)
    add_simple_option(packet.options, DHCP_REQUESTED_IP, requested);

  add_requests(&packet);
  fprintf(stderr, "dhcp_dna: sending discover...\n");
  
  //rule4_add(NULL, 254,701, 1,&any_addr, 32, &any_addr, 0, 0);
  
  ret = raw_packet(&packet, 0, DHCP_CLIENT_PORT, INADDR_BROADCAST,
		   //src should not be set as requested
		   DHCP_SERVER_PORT, DHCP_MAC_BCAST_ADDR, ifindex);
  //rule4_del(NULL, 254, 701, 1, &any_addr, 32, &any_addr, 0, 0);
  return ret;
}



/* Unicasts or broadcasts a DHCP renew message */
int send_renew(int ifindex, char *ifname, 
	       unsigned long xid, unsigned long server, 
	       unsigned long ciaddr)
{
  struct dhcp_message packet;
  int ret = 0;
  char mac[6];
  if(read_interface_hwaddr(ifname, mac)<0){
    fprintf(stderr, "dhcp_dna(send_discover): read_interface_hwaddr error\n ");
    return -1;
  }
  init_packet(mac,&packet, DHCPREQUEST);
  packet.xid = xid;
  packet.ciaddr = ciaddr;

  add_requests(&packet);
  if (server)
    ret = kernel_packet(&packet, ciaddr, DHCP_CLIENT_PORT, server, DHCP_SERVER_PORT);
  else ret = raw_packet(&packet, INADDR_ANY, DHCP_CLIENT_PORT, INADDR_BROADCAST,
			DHCP_SERVER_PORT, DHCP_MAC_BCAST_ADDR, ifindex);
  return ret;
}

/* Broadcasts a DHCP request message */
int send_selecting(int ifindex, char *ifname, 
		   unsigned long xid, 
		   unsigned long server, 
		   unsigned long requested)
{
  struct dhcp_message packet;
  struct in_addr addr;
  char mac[6];
  if(read_interface_hwaddr(ifname, mac)<0){
    fprintf(stderr, "dhcp_dna(send_discover): read_interface_hwaddr error\n ");
    return -1;
  }
  

  init_packet(mac,&packet, DHCPREQUEST);
  packet.xid = xid;

  add_simple_option(packet.options, DHCP_REQUESTED_IP, requested);
  add_simple_option(packet.options, DHCP_SERVER_ID, server);

  add_requests(&packet);
  addr.s_addr = requested;
  fprintf(stderr, "dhcp_dna: Sending select for %s...\n", inet_ntoa(addr));
  if(server==0||requested==0)
    return raw_packet(&packet, INADDR_ANY, DHCP_CLIENT_PORT, INADDR_BROADCAST,
		      DHCP_SERVER_PORT, DHCP_MAC_BCAST_ADDR, ifindex);
  else {
    struct in_addr inaddr_any;
    inaddr_any.s_addr = 0;
    route4_add(ifindex,ROUTE_MOBILE_TMP,0,
	       (struct in_addr*)&requested,32,
	       (struct in_addr*)&server,32,(struct in_addr*)&server);
    rule4_add(NULL, ROUTE_MOBILE_TMP,
	      RULE_MOBILE_PRIO-1, RTN_UNICAST,
	      (struct in_addr*)&requested,32,(struct in_addr*)&server,32,0);
    struct xfrm_selector bypass_sel;
    set_v4selector(*((struct in_addr*)&server),*((struct in_addr*)&requested), IPPROTO_UDP, 0, 0, 0, &bypass_sel);
    xfrm_mip_policy_add(&bypass_sel,0, XFRM_POLICY_OUT, XFRM_POLICY_ALLOW, 2, NULL, 0);
    int r = kernel_packet(&packet,requested,DHCP_CLIENT_PORT,server,DHCP_SERVER_PORT);
    route4_del(ifindex,ROUTE_MOBILE_TMP,	       
	       (struct in_addr*)&requested,32,
	       (struct in_addr*)&server,32,(struct in_addr*)&server);
    rule4_del(NULL, ROUTE_MOBILE_TMP,
              RULE_MOBILE_PRIO-1, RTN_UNICAST,
	      (struct in_addr*)&requested,32,(struct in_addr*)&server,32,0);
    xfrm_mip_policy_del(&bypass_sel,XFRM_POLICY_OUT);
    return r;
  }
}


struct DHCP_DATA
{
  int server_addr;//dhcp server
  int gw; //gateway
  int ip; //offered ip address
  int xid; 
  int ifindex;
  char ifname[30];
  int subnet; 
  int dnsserver;
  int requested_ip;
};


long uptime(void)
{
  struct sysinfo info;
  sysinfo(&info);
  return info.uptime;
}


#define LISTEN_KERNEL 1
#define LISTEN_RAW 2

int dhcp_request(struct DHCP_DATA * dhcp_data)
{
  static int __xid__ = 0;
  //make dhcp discovery / request
  //dhcp_data.ifindex and dhcp_data.ifname should be valid!!!
  int timeout = 0;
  int fd = -1;
  int  listen_mode = 2; //dhcp_data->xid != -1? LISTEN_KERNEL:LISTEN_RAW;
  int packet_num = 0;
  struct timeval tv;
  struct dhcp_message packet;
  int  state = (dhcp_data->xid == -1||dhcp_data->server_addr == 0)? DHCP_INIT_SELECTING:DHCP_REQUESTING;
  if(dhcp_data->xid==-1)
    dhcp_data->xid = __xid__++;
  
  for(;;){
    tv.tv_sec = timeout - uptime();
    tv.tv_usec = 0;
    if(fd < 0){
      if(listen_mode == LISTEN_KERNEL)
	fd = kernel_socket(INADDR_ANY, DHCP_CLIENT_PORT,
			   dhcp_data->ifname);
      else fd = raw_socket(dhcp_data->ifindex);
      if(fd < 0){
	fprintf(stderr,"dhcp_dna: fatal error! cannot listen on socket!\n");
	return -1;
      }
    }
    fd_set rfds;
    int retval; 
    FD_ZERO(&rfds);
    FD_SET(fd, &rfds);
    if(tv.tv_sec >0){
      retval = select(fd + 1, &rfds, NULL, NULL, &tv);
    }
    else retval = 0;
    if(retval ==0)fprintf(stderr,"no packet now \n");
    int now = uptime();
    if(retval==0){
      switch(state){
      case DHCP_INIT_SELECTING:

	if(packet_num<3){
	  
	  send_discover(dhcp_data->ifindex,dhcp_data->ifname,
			dhcp_data->xid,dhcp_data->requested_ip);
	  
	  timeout = now+ (packet_num>1?4:2);
	  ++packet_num;
	}
	else {
	  packet_num = 0;
	  timeout = now + 60;
	}
	break;
      case DHCP_REQUESTING:
	if(packet_num<3){
	  send_selecting(dhcp_data->ifindex,dhcp_data->ifname,
			 dhcp_data->xid, dhcp_data->server_addr, 
			 dhcp_data->requested_ip);
	  //may be it can be changed to 'send_renew' here
	  ++packet_num;
	  timeout = now + (packet_num>1? 4:2);
	}
	else {
	  state= DHCP_INIT_SELECTING;
	  timeout = now;
	  if(fd>=0)close(fd);
	  fd = -1;
	  listen_mode = LISTEN_RAW;
	  packet_num = 0;
	}
	
      }

    }
    else if(retval >0 && FD_ISSET(fd,&rfds)){
      int len;
      //packet received
      if(listen_mode == LISTEN_KERNEL){
	len = get_packet(&packet,fd);
      }
      else len = get_raw_packet(&packet,fd);
      if(len <0){
	fprintf(stderr,"listen(%s) return error!\n",listen_mode == LISTEN_KERNEL?"kernel":"raw");
	continue;
      }
      if(packet.xid!=dhcp_data->xid){
	fprintf(stderr,
		"packet got, but packet.xid(%d) do not eq data_dhcp->xid(%d), ignore it!\n",
		packet.xid,
		dhcp_data->xid
		);
	continue;
      }
      uint8_t * message = get_option(&packet, DHCP_MESSAGE_TYPE);
      if(message == NULL){
	fprintf(stderr,"dhcp_dna: message is NULL\n");
	continue;
      }
      switch(state){
      case DHCP_INIT_SELECTING:
	if(*message==DHCPOFFER){
	  fprintf(stderr,"packet got, DHCPOFFER!!\n");
#define NIP4ADDR2(addr)				\
	  (addr & 0x000000ff),			\
	  (addr & 0x0000ff00) >> 8,		\
	  (addr & 0x00ff0000) >> 16,		\
	  (addr & 0xff000000) >> 24
	  dhcp_data->ip = packet.yiaddr;
	  memcpy(&dhcp_data->server_addr, get_option(&packet, DHCP_SERVER_ID), 4);
	  memcpy(&dhcp_data->gw, get_option(&packet, DHCP_ROUTER), 4);
	  memcpy(&dhcp_data->dnsserver, get_option(&packet, DHCP_DNS_SERVER), 4);
	  memcpy(&dhcp_data->subnet, get_option(&packet, DHCP_SUBNET), 4);
	  
	  fprintf(stderr,
		  "------DHCP_OFFER-----------------\n"
		  "[ip = %d.%d.%d.%d,\n"
		  "dhcp_server = %d.%d.%d.%d,\n"
		  "gateway = %d.%d.%d.%d,\n"
		  "dns server = %d.%d.%d.%d,\n"
		  "subnet = %d.%d.%d.%d\n]"
		  "---------------------------------\n",
		  NIP4ADDR2(dhcp_data->ip),
		  NIP4ADDR2(dhcp_data->server_addr),
		  NIP4ADDR2(dhcp_data->gw),
		  NIP4ADDR2(dhcp_data->dnsserver),
		  NIP4ADDR2(dhcp_data->subnet));

		  
	  
	  if(dhcp_data->requested_ip&&dhcp_data->requested_ip != packet.yiaddr){
	    fprintf(stderr,"requested_ip changed? wierd???\n");
	  }
	  state = DHCP_REQUESTING;
	  timeout = now;
	  return 1;
	  
	}
	else {
	  fprintf(stderr,"dhcp_dna: message got mismatch :%s\n",*message == DHCPACK? "DHCPACK":"UNKNOWN");
	}
	break;
      case DHCP_REQUESTING:
	if(*message == DHCPACK){
	  if(dhcp_data->requested_ip!=packet.yiaddr){
	    fprintf(stderr,"dhcp_dna: requested ip(%d.%d.%d.%d) not equal yiaddr(%d.%d.%d.%d)\n",
		    NIP4ADDR2(dhcp_data->requested_ip),
		    NIP4ADDR2(packet.yiaddr));
	   
	  }
	  fprintf(stderr,"dhcp_dna: DHCPACK received!\n");
	  dhcp_data->ip = packet.yiaddr;
	  memcpy(&dhcp_data->server_addr, get_option(&packet, DHCP_SERVER_ID), 4);
	  memcpy(&dhcp_data->gw, get_option(&packet, DHCP_ROUTER), 4);
	  memcpy(&dhcp_data->dnsserver, get_option(&packet, DHCP_DNS_SERVER), 4);
	  memcpy(&dhcp_data->subnet, get_option(&packet, DHCP_SUBNET), 4);

	  fprintf(stderr,
		  "------DHCP_ACK-------------------\n"
		  "ip = %d.%d.%d.%d,\n"
		  "dhcp_server = %d.%d.%d.%d,\n"
		  "gateway = %d.%d.%d.%d,\n"
		  "dns server = %d.%d.%d.%d,\n"
		  "subnet = %d.%d.%d.%d\n"
		  "---------------------------------\n",
		  NIP4ADDR2(dhcp_data->ip),
		  NIP4ADDR2(dhcp_data->server_addr),
		  NIP4ADDR2(dhcp_data->gw),
		  NIP4ADDR2(dhcp_data->dnsserver),
		  NIP4ADDR2(dhcp_data->subnet));
	  
	  return 1;
	}
	break;
      }
      return 0;
    }
  }
}
#endif

#define DHCP_TEST_ 1
#ifndef DHCP_TEST_
int main()
{
  struct DHCP_DATA dhcp_data;
  memset(&dhcp_data,0,sizeof(dhcp_data));
  dhcp_data.ifindex = 2;
  strcpy(dhcp_data.ifname,"eth0");
  dhcp_data.xid = -1;
  dhcp_data.server_addr = inet_addr("172.16.0.1");
  dhcp_data.requested_ip = inet_addr("172.16.0.3");
  dhcp_request(&dhcp_data);
}
#endif

/*
  REMAINING PROBLEMS:
  1) when listen on kernel_socket the program cannot receive the packet
     even if wireshark shows that the packets do have been sent to the 
     host. In order to avoid this problem I currently take raw socket 
     for all kinds of packets instead.
     
     The problem with raw socket solution is that it takes too much time 
     to deal with unrelevant packets, especially when the system traffic
     is heavy.
  
  2) The function defined here requres users to specify both of the index 
     and name of the interface. In fact we can make use of the system call
     'if_nametoindex' or 'if_indextoname' and eliminate the redundancy
     of ifindex and ifname in the parameters. 
*/
