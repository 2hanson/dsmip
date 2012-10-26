//#include "rtnl.h"

#define ON 1
#define OFF 0
#define TRUE 1
#define FALSE 0
#define DEFAULT_BMISSCNT 1
#define DEFAULT_BMISSINTVL 100
#define DEFAULT_BMISSBEACONS 5
#define RESUME_BMISSBEACONS 7

#define IDNUMS 2

#define WPA_SUPPLICANT_CONFIG_PATH "/data/misc/wifi/wpa_supplicant.conf"
#define WPA_CLI_CMD "wpa_cli -i wlan0 -p /data/system/wpa_supplicant "
#define WPA_SUPPLICANT_CMD "wpa_supplicant -Bdd -Dwext -iwlan0 -c/data/misc/wifi/wpa_supplicant.conf"
#define PROCKMSG "/proc/kmsg"
#define WMICONFIG_CMD "wmiconfig -i wlan0 "
#define LOGCAT_CMD "logcat "
#define CAT_CMD "cat "
//#define KILL_CMD "kill -9 "

extern volatile int exiting;
extern volatile int halting;
extern int ping(int argc, char *argv[]);
/*
enum {
	IPFIX=0,
};*/

//ACK for cngictrl received from mn
enum{
	ACK_IPFIX=0,
	ACK_RMNET,
};

int prompt=TRUE;
int wifiswitch=OFF;

int bmisscnt=DEFAULT_BMISSCNT;
int bmissintvl=DEFAULT_BMISSINTVL;

pthread_cond_t cond_bmisscntDetect;
pthread_t tid_bmisscntDetect;
int bmisscntDetect_run;
int bmissbeacons=-1;

#define SYSTEM_ARG(CMD,ARG) do { \
	char command[80]; \
	sprintf(command,CMD " %d", ARG); \
	system(command); \
} while(0)

#define RFROMSYSSIZE 1024*10
char cmdresult[RFROMSYSSIZE]={0};

int linknumwlan=0,linknumrmnet=3;
char wlan_route[80]={0};


int autohandoff=ON;
int currentlinknum=-1;

int
getcmdResult(char cmd[])
{
	int fd[2],num;
	pid_t pid;

	pipe(fd);
	pid=fork();
	if(pid<0)
	{
		return -1;
		perror("fork");
	}
	else
	if(pid==0){
		close(fd[0]);
		int oldstdout=dup(STDOUT_FILENO);
    	dup2(fd[1], STDOUT_FILENO);
    	close(fd[1]);
		system(cmd);
		dup2(oldstdout,STDOUT_FILENO);
		close(oldstdout);
		exit(0);
	}
	else
	if(pid>0){
		close(fd[1]);
		num=read(fd[0], cmdresult, RFROMSYSSIZE);
		cmdresult[num]=0;
		close(fd[0]);
	}
	waitpid(pid,NULL,0);
	return 0;
}


static int
getnumfromstr(char *p)
{
	int result=0,ret=-1;
	while(*p==' ')
		p++;
	while(*p>='0'&&*p<='9')
	{
		ret=0;
		result=result*10+(*p-'0');
		p++;
	}
	if (ret)
		return ret;
	else
		return result;
}

static void
skipspace(char **p)
{
	while(**p==' ')
		(*p)++;
}

static int
nextworkid(int currnid, int *p)
{
	return p[0]==currnid?p[1]:p[0];
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
}__attribute((packed));;;

struct CTRL_CMD_ACK
{
  uint16_t seqno;
  uint16_t chksum;
  uint16_t acklen;//length of ack data                                
  uint8_t ack[300];//data 500 bytes at most                              
}__attribute((packed));;;;

  uint16_t __SEQNO__;
  struct sockaddr_in dest, src;
  int sock_fd;
/*
const char wpa_supplicant_conf[]="\
ctrl_interface=DIR=/data/system/wpa_supplicant GROUP=system\n\
ap_scan=2\n\
update_config=1\n\
\n\
network={\n\
	ssid=\"hub\"\n\
	key_mgmt=NONE\n\
	priority=1\n\
}\n\
\n\
network={\n\
	ssid=\"hat\"\n\
	key_mgmt=NONE\n\
	priority=2\n\
}\n";*/

char wpa_supplicant_conf[1000];
char wpaconfpart1[]="\
ctrl_interface=DIR=/data/system/wpa_supplicant GROUP=system\n\
ap_scan=2\n\
update_config=1\n\
\n\
network={\n\
	ssid=\"";
char wpaconfpart2[]="\
\"\n\
	key_mgmt=NONE\n\
	priority=1\n\
}\n\
\n\
network={\n\
	ssid=\"";
char wpaconfpart3[]="\
\"\n\
	key_mgmt=NONE\n\
	priority=2\n\
}\n";

char apssid[IDNUMS][80]={"hub","hat"};

int
fileload(char path[],char content[])
{
	FILE *fp;
	int ret;
	fp=fopen(path,"w+");
	if(fp==NULL){
		perror("Error:fopen failed\n");
		return -1;
	}
	if(fputs(content,fp)==EOF){
		ret=-1;
		perror("Error:fputs failed\n");
	}
	else{
		ret=0;
	}
	fclose(fp);
	return ret;
}

#define CNGIPATH "/cngi"
#define MNLOGPATH "/cngi/mn.log"
int mnswitch=OFF;
int mnstop=FALSE;
int mnpid=-1;

#include <sys/stat.h>

int checkdir(char dirpath[])
{
	//DIR *pdir;
	
	//if(pdir=opendir(dirpath)==NULL)
	if(access(dirpath,F_OK)!=0)
	{
		int fd=mkdir(dirpath,0777);
		if (fd==-1){
			perror("Error:dir created failed!\n");
			return -1;
		}	
	}/*
	else{
		close(pdir);
	}*/
	return 0;
}

void
ruleshow(void)
{
	fprintf(stderr, "ipv4 rule:\n");
	system("ip rule");
	fprintf(stderr, "\nipv4 route table main:\n");
	system("ip route");
	fprintf(stderr, "\nipv4 route table 252:\n");
	system("ip route show table 252");
	fprintf(stderr, "\nipv4 xfrm state:\n");
	system("ip xfrm state");
	fprintf(stderr, "\nipv4 xfrm policy:\n");
	system("ip xfrm policy");

	fprintf(stderr, "\nipv6 rule:\n");
	system("ip -6 rule");
	fprintf(stderr, "\nipv6 route table main:\n");
	system("ip -6 route");
	fprintf(stderr, "\nipv6 route table 252:\n");
	system("ip -6 route show table 252");
	fprintf(stderr, "\nipv6 xfrm state:\n");
	system("ip -6 xfrm state");
	fprintf(stderr, "\nipv6 xfrm policy:\n");
	system("ip -6 xfrm policy");
}

void
ruleclear(void)
{
	char *p;
	int pref;

	getcmdResult("ip rule");
	p=cmdresult;
	while(p!=NULL && *p!=0){
		pref=getnumfromstr(p);
		if(pref>100 && pref<30000){
			SYSTEM_ARG("ip rule del pref",pref);
		}
		p=strchr(p,'\n')+1;
	}

	//getcmdResult("ip xfrm state");
	system("ip xfrm state deleteall");

	//getcmdResult("ip xfrm policy");
	system("ip xfrm policy flush ptype sub");

	getcmdResult("ip -6 rule");
	p=cmdresult;
	while(p!=NULL && *p!=0){
		pref=getnumfromstr(p);
		if(pref>100 && pref<30000){
			SYSTEM_ARG("ip -6 rule del pref",pref);
		}
		p=strchr(p,'\n')+1;
	}
	
	//getcmdResult("ip -6 xfrm state");
	system("ip -6 xfrm state deleteall");

	//getcmdResult("ip -6 xfrm policy");
	system("ip -6 xfrm policy flush ptype sub");
}

int newid;
char staticipaddr[IDNUMS][80]={"192.168.0.2/24","192.168.1.2/24"};

typedef enum {
	dhcpway=0,
	staticway,
	noway,
} ipcfgway;

ipcfgway ipcfg=noway;

typedef struct {
	int use;
	char addr[80];
} ipgatewaytype;
ipgatewaytype staticipgateway[IDNUMS]={{TRUE,"192.168.0.1"},{TRUE,"192.168.1.1"}};

void
ipaddrdel(void)
{	
	getcmdResult("ip -4 addr");
	if(strstr(cmdresult,"wlan0")==NULL)
		return;
	getcmdResult("ip -4 addr show dev wlan0");
	char *p;
	p=cmdresult;
	while((p=strstr(p,"inet"))!=NULL)
	{
		p=p+4;
		char oldipaddr[80];
		skipspace(&p);
		char *pend=strchr(p,' ');
		*pend=0;
		strcpy(oldipaddr,p);
		*pend=' ';
		char cmd[80];
		sprintf(cmd,"ip addr del ");
		strcat(cmd,oldipaddr);
		strcat(cmd," dev wlan0");
		fprintf(stderr,"%s[%d] cmd: %s\n",__FUNCTION__,__LINE__,cmd);
		system(cmd);
	}
}

void
iproutedel(void)
{
	char *p,*q,temp;
	getcmdResult("ip -4 route");
	p=cmdresult;
	do{
		//getcmdResult("ip -4 route");
		if((p=strstr(p,"default"))==NULL)
			break;
		char cmd[80];
		sprintf(cmd,"ip route del ");
		if((q=strchr(p,'\n'))!=NULL)
			temp=*q;
		if(q!=NULL)
			*q=0;
		strcat(cmd,p);
		if(q!=NULL)
			*q=temp;
		fprintf(stderr,"%s[%d] cmd: %s\n",__FUNCTION__,__LINE__,cmd);
		system(cmd);
		if(q==NULL)
			break;
		p=q;
	} while(1);	
}

int
nowayfix(void)
{
	//ipaddrdel();
	return 1;
}

int
staticwayfix(void)
{
	//ipaddrdel();
	char cmd[80];
	sprintf(cmd,"ip addr add ");
	strcat(cmd,staticipaddr[newid]);
	strcat(cmd," dev wlan0");
	fprintf(stderr,"%s[%d] cmd: %s\n",__FUNCTION__,__LINE__,cmd);
	system(cmd);
	if(staticipgateway[newid].use==TRUE){
		sprintf(cmd,"ip route add default via ");
		strcat(cmd,staticipgateway[newid].addr);
		strcat(cmd," dev wlan0");
		fprintf(stderr,"%s[%d] cmd: %s\n",__FUNCTION__,__LINE__,cmd);
		system(cmd);
	}
	return 1;
}

int
dhcpwayfix(void)
{
	//ipaddrdel();
	//system("dhcpcd wlan0");
	fprintf(stderr,"%s[%d] cmd: netcfg wlan0 dhcp\n",__FUNCTION__,__LINE__);
	system("netcfg wlan0 dhcp");
	return 1;
}

#define IPFIX_USE_RTNETLINK 0
#if IPFIX_USE_RTNETLINK==1

//pthread_cond_t cond_processaddr;
pthread_t tid_processaddr;
struct rtnl_handle md_rth;

int
process_addr(const struct sockaddr_nl *who, struct nlmsghdr *n, void *arg)
{
	int ret=0;
	struct ifinfomsg *ifi;
  	struct rtattr *rta_tb[IFLA_MAX+1];

  	if(n->nlmsg_len < NLMSG_LENGTH(sizeof(*ifi)))
    	return -1;
  	ifi = NLMSG_DATA(n);
  	if(ifi->ifi_family != AF_UNSPEC && ifi->ifi_family != AF_INET6)
    	return 0;
	/*
  	if(ifi->ifi_type == ARPHRD_LOOPBACK ||
    	ifi->ifi_type == ARPHRD_TUNNEL6  ||
      	ifi->ifi_type == ARPHRD_TUNNEL   ||
      	ifi->ifi_type == ARPHRD_SIT)
    	return 0;
	*/
  	memset(rta_tb, 0, sizeof(rta_tb));
  	parse_rtattr(rta_tb, IFLA_MAX, IFLA_RTA(ifi),n->nlmsg_len - NLMSG_LENGTH(sizeof(*ifi)));
  
  	if(n->nlmsg_type == RTM_NEWLINK){        
    	if((ifi->ifi_flags&(IFF_UP|IFF_RUNNING))==(IFF_UP|IFF_RUNNING)){
	    	//ifconfig eth0 up
			switch(ipcfg)
			{
				case noway:
				ret=nowayfix();
				break;
				case staticway:
				ret=staticwayfix();
				break;
				case dhcpway:
				ret=dhcpwayfix();
				break;
			}
	  	}
	  	else{
	    	//ifconfig eth0 down
	  		ipaddrdel();
	  		ret=1;
		}
	}
	
	return ret; 
}

void *
processaddr(void * unused)
{
	rtnl_listen(&md_rth, process_addr, NULL);
	rtnl_listen(&md_rth, process_addr, NULL);
	return NULL;
}

int
ipfix(void)
{
	int ret=1;
	tid_processaddr=0;
    if(pthread_create(&tid_processaddr,NULL,processaddr,NULL)<0){
    	perror("ERROR:processaddr can't start\n");
    	ret=-1;
	}
	return ret;
}

#else
//#define RECVFROMMN
//#ifndef RECVFROMMN
int
ipfix_mnoff(void)
{
	int ret=1;
	ipaddrdel();
	switch(ipcfg)
	{
		case noway:
		ret=nowayfix();
		break;
		case staticway:
		ret=staticwayfix();
		break;
		case dhcpway:
		ret=dhcpwayfix();
		break;
	}
	return ret;
}
//#else
char rmnet_route[80];
int rmnet_flag=0;

enum{
	RMNET_ON=0,
	RMNET_OFF,
	RMNET_FIX,
} rmnetstatus=RMNET_FIX;

void
rmnetcheck(void){
	do{
		getcmdResult("ip -4 route");
		if(strstr(cmdresult,"rmnet0")==NULL)
			break;
		getcmdResult("ip -4 route show dev rmnet0");
		char *p=strstr(cmdresult,"default");
		if(p==NULL)
			break;
		strcpy(rmnet_route,p);
		p=strchr(rmnet_route,'\n');
		if(p!=NULL)
			*p=' ';
		strcat(rmnet_route," dev rmnet0");
		rmnet_flag=1;
		rmnetstatus=RMNET_ON;
	} while(0);
}

void
rmnet_route_add(void)
{
	if(rmnet_flag==1){
		char cmd[80];
		sprintf(cmd,"ip route add ");
		strcat(cmd,rmnet_route);
		fprintf(stderr,"%s[%d] cmd: %s\n",__FUNCTION__,__LINE__,cmd);
		system(cmd);
	}
}

void
rmnet_route_del(void)
{
	if(rmnet_flag==1){
		char cmd[80];
		sprintf(cmd,"ip route del ");
		strcat(cmd,rmnet_route);
		fprintf(stderr,"%s[%d] cmd: %s\n",__FUNCTION__,__LINE__,cmd);
		system(cmd);
	}
}

void
ipfix(struct CTRL_CMD_ACK *ctrl_cmd_ack)
{
	currentlinknum=ctrl_cmd_ack->ack[2];
	//if(rmnet_flag==0)
	if(rmnetstatus==RMNET_FIX)
		rmnetcheck();

	if(ctrl_cmd_ack->ack[0]==0){
		ipaddrdel();
		if(ctrl_cmd_ack->ack[2]!=linknumrmnet){
			iproutedel();
			if(ctrl_cmd_ack->ack[1]!=0){
				rmnet_route_add();
				currentlinknum=linknumrmnet;
			}
		}
	}
	else
	if(ctrl_cmd_ack->ack[0]==1){
		if(ctrl_cmd_ack->ack[2]==linknumrmnet)
			rmnet_route_del();
		if(wifiswitch==ON){
			switch(ipcfg)
			{
				case noway:
					nowayfix();
					break;
				case staticway:
					staticwayfix();
					break;
				case dhcpway:
					dhcpwayfix();
					break;
			}
		}
		wlancheck();
		currentlinknum=linknumwlan;
		//a:yhz
		if (ctrl_cmd_ack->ack[1]==0/*auto off*/ && ctrl_cmd_ack->ack[2]==linknumrmnet/*rmnet's ifindex*/)
		{
			char cmd[80];
			sprintf(cmd,"ip route del ");
			strcat(cmd,wlan_route);
			fprintf(stderr,"%s[%d] cmd: %s\n",__FUNCTION__,__LINE__,cmd);
			if(strstr(cmd,"dev")!=NULL)
				system(cmd);
			rmnet_route_add();
			currentlinknum=linknumrmnet;
		}
		/*	
		if(rmnet0_flag==1){
			char cmd[80];
			sprintf(cmd,"ip route add ");
			strcat(cmd,rmnet0_dftrt);
			system(cmd);
		}
		*/
	}
}
//#endif
#endif

void
staticipshow(void)
{
	fprintf(stderr,"[0] %s via %s\n[1] %s via %s\n",staticipaddr[0],staticipgateway[0].use?staticipgateway[0].addr:"",
	staticipaddr[1],staticipgateway[1].use?staticipgateway[1].addr:"");
}

void
staticipfix(char *p)
{
	skipspace(&p);
	char *pstart=p,temp;
	while(*p!=' ')
		p++;
	*p=0;
	strcpy(staticipaddr[0],pstart);
	*p=' ';
	skipspace(&p);
	if(*p=='v'){
		p=p+3;
		skipspace(&p);
		pstart=p;
		while(*p!=' '&& *p!='\n' && *p!=0)
			p++;
		temp=*p;
		*p=0;
		strcpy(staticipgateway[0].addr,pstart);
		*p=temp;
		staticipgateway[0].use=TRUE;
		skipspace(&p);
	}
	else{
		staticipgateway[0].use=FALSE;
	}
		
	pstart=p;
	while(*p!=' '&& *p!='\n' && *p!=0)
		p++;
	temp=*p;
	*p=0;
	strcpy(staticipaddr[1],pstart);
	*p=temp;

	skipspace(&p);
	if(*p=='v'){
		p=p+3;
		skipspace(&p);
		pstart=p;
		while(*p!=' '&& *p!='\n' && *p!=0)
			p++;
		temp=*p;
		*p=0;
		strcpy(staticipgateway[1].addr,pstart);
		*p=temp;
		staticipgateway[1].use=TRUE;
		skipspace(&p);
	}
	else{
		staticipgateway[1].use=FALSE;
	}
}

void
makewpaconf(void)
{
	wpa_supplicant_conf[0]=0;
	strcat(wpa_supplicant_conf,wpaconfpart1);
	strcat(wpa_supplicant_conf,apssid[0]);
	strcat(wpa_supplicant_conf,wpaconfpart2);
	strcat(wpa_supplicant_conf,apssid[1]);
	strcat(wpa_supplicant_conf,wpaconfpart3);	
}

void
checkwpaconf(void)
{
	makewpaconf();
	if(fileload(WPA_SUPPLICANT_CONFIG_PATH,wpa_supplicant_conf)==-1){
		perror("Error:fileload failed\n");
	}
	else{
		system("chmod 660 " WPA_SUPPLICANT_CONFIG_PATH);
		system("chown system.wifi " WPA_SUPPLICANT_CONFIG_PATH);
	}
}

void
apssidshow(void)
{
	fprintf(stderr,"[0] %s\n[1] %s\n",apssid[0],apssid[1]);
}

void
apssidfix(char *p)
{
	skipspace(&p);
	char *pstart=p;
	while(*p!=' ')
		p++;
	*p=0;
	strcpy(apssid[0],pstart);
	*p=' ';
	skipspace(&p);
	pstart=p;
	while(*p!=' '&& *p!='\n' &&*p!=0)
		p++;
	char temp=*p;
	*p=0;
	strcpy(apssid[1],pstart);
	*p=temp;
}

pthread_cond_t cond_ping_on;
pthread_t tid_ping_on;
char pingcmd[80]="ping -q -i 0.01 10.21.5.74";
char pingcmdbuf[80];
enum{
	PINGON=0,	
	PINGOFF,
	PINGSTOP,
} pingstatus=PINGOFF;
int pingfixed=FALSE;
extern __u16 missedseq;
extern struct timeval missedtime;

void *
ping_on(void *unused)
{
	char *p;
	int argc=0;
	char *argv[10];
	bzero(pingcmdbuf,80);
	strcpy(pingcmdbuf,pingcmd);
	p=strtok(pingcmdbuf," ");
	while(p!=NULL)
	{
		argv[argc++]=p;
		p=strtok(NULL," ");
	}
	/*	
	int i=0;
	while(i<argc)
		fprintf(stderr,"\n[ping]%s",argv[i++]);
	*/
	ping(argc,argv);
	
	return NULL;
}

void
ping_halt(void)
{
	pthread_mutex_t mut=PTHREAD_MUTEX_INITIALIZER;
    struct timeval now;
    struct timespec timeout;
	int retcode;

	while(1)
	{
		pthread_mutex_lock(&mut);
    	gettimeofday(&now, NULL);
		timeout.tv_sec = now.tv_sec+1000;
		timeout.tv_nsec = now.tv_usec*1000;
		if ((retcode = pthread_cond_timedwait(&cond_ping_on, &mut, &timeout)) < 0) {
      	   	perror("pthread_cond_timedwait");
			break;
    	}
   	 	if (retcode != 110){
			pthread_mutex_unlock(&mut);
			break;
        }
   		pthread_mutex_unlock(&mut);
	}
}

/*
int wlan_flag=0;
enum{
	WLAN_ON=0,
	WLAN_OFF,
	WLAN_FIX,
} wlanstatus=WLAN_FIX;*/
void
wlancheck(void){
	do{
		getcmdResult("ip -4 route");
		if(strstr(cmdresult,"wlan0")==NULL)
			break;
		getcmdResult("ip -4 route show dev wlan0");
		char *p=strstr(cmdresult,"default");
		if(p==NULL)
			break;
		strcpy(wlan_route,p);
		p=strchr(wlan_route,'\n');
		if(p!=NULL)
			*p=' ';
		strcat(wlan_route," dev wlan0");
		//wlan_flag=1;
		//wlanstatus=WLAN_ON;
	} while(0);
}
int
wlan_route_add(void)
{
	if(wifiswitch==ON){
		char cmd[80];
		sprintf(cmd,"ip route add ");
		strcat(cmd,wlan_route);
		fprintf(stderr,"%s[%d] cmd: %s\n",__FUNCTION__,__LINE__,cmd);
		if(strstr(cmd,"dev")!=NULL)
			system(cmd);
		else{
			fprintf(stderr,"AP is not ready!\n");
			return 1;
		}
		return 0;
	}
	fprintf(stderr,"wifi card is off!\n");
	return -1;
}
