#include <stdio.h>
#include <linux/types.h>
#include <string.h>
#include <arpa/inet.h>
#include <linux/netlink.h>
#include <stdlib.h>
#include "imp2.h"


#define MAX_PAYLOAD sizeof(struct msg_to_kernel)  /* maximum payload size*/
#define NIP6_FMT "%04x:%04x:%04x:%04x:%04x:%04x:%04x:%04x"
#define NIP6(addr) \
        ntohs((addr).s6_addr16[0]), \
        ntohs((addr).s6_addr16[1]), \
        ntohs((addr).s6_addr16[2]), \
        ntohs((addr).s6_addr16[3]), \
        ntohs((addr).s6_addr16[4]), \
        ntohs((addr).s6_addr16[5]), \
        ntohs((addr).s6_addr16[6]), \
        ntohs((addr).s6_addr16[7])

void mnaccess_notify(struct in6_addr hoa,struct in_addr hoav4,struct in6_addr coa)
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
        message.hoa	=       hoa;
        message.hoav4	=       hoav4;
        message.coa	=       coa;

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
	printf("send hoa and coa to kernel!\n");

	sendmsg(sock_fd, &msg, 0);
	close(sock_fd);
	free(nlh);
}

int main(int argc, char* argv[])
{
	struct in6_addr hoav6,coav6;
	struct in_addr	hoav4;
	inet_pton(AF_INET6,"2001:0cc0:2026:0003:0221:97ff:fe6a:824c",&hoav6);
	inet_pton(AF_INET,"10.21.5.131",&hoav4);
	inet_pton(AF_INET6,"2001:0cc0:2026:0003:0000:0000:0000:0001",&coav6);

	mnaccess_notify(hoav6,hoav4,coav6);

	printf("hoav6="NIP6_FMT"\n",NIP6(hoav6));
	char s[16];
	my_inet_ntoa(s,hoav4);
	printf("hoav4=%s\n",s);
	printf("coav6="NIP6_FMT"\n",NIP6(coav6));
	return 0;
}

