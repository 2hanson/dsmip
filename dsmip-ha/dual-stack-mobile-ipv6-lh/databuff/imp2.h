#ifndef __IMP2_H__
#define __IMP2_H__

#define IMP2_U_PID   0
#define IMP2_K_MSG   1
#define IMP2_CLOSE   2

#define NL_IMP2      22

struct msg_to_kernel
{
	int MNACCESS;
	struct in6_addr hoa;
	struct in_addr	hoav4;
	struct in6_addr coa;
};
int my_inet_ntoa(char *string,struct in_addr addr)
{
	snprintf(string,16,"%d.%d.%d.%d",(ntohl(addr.s_addr)>>24)&0xff,(ntohl(addr.s_addr)>>16)&0xff,(ntohl(addr.s_addr)>>8)&0xff,ntohl(addr.s_addr)&0xff);
	return 1;
}
#endif
