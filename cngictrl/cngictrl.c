#include <sys/select.h>
#include <string.h>
#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/file.h>
#include <sys/ioctl.h>
#include <sys/socket.h>
#include <linux/types.h>
#include <linux/if.h>
#include <linux/wireless.h>
#include <arpa/inet.h>
#include <a_types.h>

#include <sys/types.h>
#include <sys/wait.h>

#include "athdrv_linux.h"
#include "cngictrl.h"
#include "cngictrl-xfrm3.h"
#include <errno.h>

#define errBmisscntDetect(args...) do { \
	bmisscntDetect_run=OFF; \
    fprintf(stderr, "\n%s: line %d ", __FILE__, __LINE__); \
    fprintf(stderr, args); fprintf(stderr, ": %d\n", errno); \
	fprintf(stderr,"BmisscntDetect Off\n"); \
	fprintf(stderr,"# "); \
	return NULL; \
} while(0)

#define KILL_KILL_ARG(ARG) do { \
	char command[80]; \
	sprintf(command,"kill -9" " %d", ARG); \
	system(command); \
} while(0)

#define KILL_TERM_ARG(ARG) do { \
	char command[80]; \
	sprintf(command,"kill -15" " %d", ARG); \
	system(command); \
} while(0)

#define KILL_COMMON_ARG(ARG) do { \
	char command[80]; \
	sprintf(command,"kill" " %d", ARG); \
	system(command); \
} while(0)

#define KILL_INT_ARG(ARG) do { \
	char command[80]; \
	sprintf(command,"kill -2" " %d", ARG); \
	system(command); \
} while(0)

#define KILL_STOP_ARG(ARG) do { \
	char command[80]; \
	sprintf(command,"kill -19" " %d", ARG); \
	system(command); \
} while(0)

#define KILL_CONT_ARG(ARG) do { \
	char command[80]; \
	sprintf(command,"kill -18" " %d", ARG); \
	system(command); \
} while(0)

#define WPA_CLI_COMMON(CMD) do { \
	system(WPA_CLI_CMD CMD); \
} while(0)

#define WPA_CLI_ARG(CMD, ARG) do { \
	char command[80]; \
	sprintf(command, WPA_CLI_CMD CMD " %d", ARG); \
	system(command); \
} while(0)

#define WMICONFIG_COMMON(CMD) do { \
	system(WMICONFIG_CMD CMD); \
} while(0)

#define WMICONFIG_ARG(CMD, ARG) do { \
	char command[80]; \
	sprintf(command, WMICONFIG_CMD CMD " %d", ARG); \
	system(command); \
} while(0)

#define LOGCAT_COMMON(CMD) do { \
	system(LOGCAT_CMD CMD); \
} while(0)

#define CAT_COMMON(CMD) do { \
	system(CAT_CMD CMD); \
} while(0)

const char commands[]=
"commands:\n\
help\n\
wifi <on | off>\n\
rmnet <on | off | fix>\n\
mn <on | off | stop | cont | status>\n\
ping <on | off | stop | cont | restart | fix <ping cmd> | miss <num> | status>\n\
	where <ping cmd> is <ping -q -i 0.01 10.21.5.74	> by default\n\
	where <num> is the count above which a disconnect event is decided to happen\n\
rule <show | clear>:to show or clear rule,route,xfrm in v4/v6\n\
staticip <show | fix <ip1 ip2> >: to show or fix the static ip address\n\
	note:fix should include the mask, eg:staticip fix *.*.*.*/24 [via gateway] *.*.*.*/24 [via gateway]\n\
apssid <show | fix <ssid1 ssid2> >:to show or fix the ap ssid\n\
ipfixway <dhcp | static | no | status>\n\
setbmisscnt <cnt>\n\
  where <cnt> 0 - Disable bmiss control,\n\
             >0 - Enable and if missed beacons reach cnt, then disconnect\n\
setbmissintvl <intvl ms>\n\
to <networkid>: to select_network\n\
list: to list_network\n\
scan <on | off>\n\
wpa_cli_shell\n\
wpa_cli <cmd>\n\
show: to show the wpa_supplicant.conf\n\
wmiconfig <cmd>\n\
setbmissbeacons <num>: where num>=1\n\
logcat: logcat wpa_supplicant\n\
catproc: to show the proc/kmsg\n\
auto <on | off | status>\n\
ap <on | off | move>\n\
handoff <rmnet | wlan>: handoff to ifindex of <rmnet | wlan>\n\
	Note: May fail if ifindex have no valid ipv6 address\n\
lscoa: list the address and interfaces of Mobile Node\n\
	Note: The address used for COA is denoted as [x] and alternative addresses are denoted as [o]\n\
link <status | fix <linknumrmnet linknumwlan> >\n\
quit\n";

static void 
usage(void)
{
	fprintf(stderr, "usage:\n%s", commands);
}

void *
bmisscntDetect(void * unused)
{
    pthread_mutex_t mut=PTHREAD_MUTEX_INITIALIZER;
    struct timeval now;
    struct timespec timeout;
    int retcode=0,s;
	struct ifreq ifr;
	char ifname[]="wlan0";
	TARGET_STATS_CMD tgtStatsCmd;

	tgtStatsCmd.clearStats=0;
    strncpy(ifr.ifr_name, ifname, sizeof(ifr.ifr_name));
	ifr.ifr_data = (void *)&tgtStatsCmd;

	fprintf(stderr, "BmisscntDetect On!\n");

	s=socket(AF_INET, SOCK_DGRAM, 0);
    if(s<0){
    	errBmisscntDetect("socket");
    }

	//fprintf(stderr, "BmisscntDetect On!\n");
	if(bmissbeacons==-1){
		WMICONFIG_ARG("--setbmissbeacons",DEFAULT_BMISSBEACONS);
	}
	else{
		WMICONFIG_ARG("--setbmissbeacons",bmissbeacons);
	}

	int flag=0,towait=0;
	int bmisscntold,bmisscntnew;
    while(bmisscntDetect_run)
    {
		if (ioctl(s, AR6000_IOCTL_WMI_GET_TARGET_STATS, &ifr) < 0)
        {
        	//close(s);
			fprintf(stderr, "\nError--AR6000_IOCTL_WMI_GET_TARGET_STATS ioctl: %d", errno);
			flag=2;
        }
		else{
			if(flag==2){
				flag=0;
				fprintf(stderr, "\n# ");
			}
		}
		if(flag==0)
		{
			bmisscntnew=tgtStatsCmd.targetStats.cs_bmiss_cnt;
			bmisscntold=bmisscntnew;
			flag=1;
		}
		else
		if(flag==1)
		{
			bmisscntold=bmisscntnew;
			bmisscntnew=tgtStatsCmd.targetStats.cs_bmiss_cnt;
			if((bmisscntnew-bmisscntold)>=bmisscnt){//send disconect;
				//to find "[CURRENT]" in list_network
				getcmdResult(WPA_CLI_CMD "list_network");
				char *pstart,*pend;
				int correct=-1,ids[IDNUMS],index=-1;
				pstart=strchr(cmdresult,'\n')+1;
				while(pstart!=NULL && *pstart!=0)
				{
					ids[++index]=getnumfromstr(pstart);
					pend=strchr(pstart,'\n');
					*pend=0;
					if(correct==-1){
						if(strstr(pstart,"[CURRENT]")!=NULL){
							correct=index;
						}
					}
					*pend='\n';
					pstart=pend+1;
				}
				int currnid;
				if(correct!=-1){
					currnid=ids[correct];
				}
				else{	
					//to find "id=" in status
					getcmdResult(WPA_CLI_CMD "status");
					char *p=strstr(cmdresult,"\nid=")+4;
					currnid=getnumfromstr(p);
					//fprintf(stderr,"the cmdresult is :\n%s\n",cmdresult);
					//fprintf(stderr,"the currnid is : %d\n",currnid);
				}
				newid=nextworkid(currnid,ids);
				//ipfix();

			if(!(currentlinknum==linknumrmnet && autohandoff==OFF)){
				WPA_CLI_ARG("-B select_network", newid);
				if(mnswitch==OFF)
					ipfix_mnoff();
			}
				//WPA_CLI_ARG("-B enable_network",(currnid+1)%2);
				//WPA_CLI_ARG("-B disable_network",currnid);
				//WPA_CLI_COMMON("-B reassociate");
				//system("wpa_cli -i wlan0 -p /data/system/wpa_supplicant/ -B disconnect");
				//system("wpa_cli -i wlan0 -p /data/system/wpa_supplicant/ -B reassociate");
				//system("wpa_cli -i wlan0 -p /data/system/wpa_supplicant/ -B reconnect");
				towait=1;
			}
		}
		pthread_mutex_lock(&mut);
        gettimeofday(&now, NULL);
		if(!towait)
		{
        	timeout.tv_sec = now.tv_sec+(bmissintvl/1000);
        	timeout.tv_nsec = (now.tv_usec+(bmissintvl%1000)*1000)*1000;
        }
		else
		{
			timeout.tv_sec = now.tv_sec+10;
			timeout.tv_nsec = now.tv_usec*1000;
			flag=0;
			towait=0;
		}
		if ((retcode = pthread_cond_timedwait(&cond_bmisscntDetect, &mut, &timeout)) < 0) {
			close(s);
      	   	errBmisscntDetect("pthread_cond_timedwait");
        }
        if (retcode != 110){
			pthread_mutex_unlock(&mut);
			//fprintf(stderr,"BmisscntDetect Off\n");
			break;
        }
       	pthread_mutex_unlock(&mut);
	}
	
	if(bmissbeacons==-1){
		WMICONFIG_ARG("--setbmissbeacons",RESUME_BMISSBEACONS);
	}		
	close(s);
	fprintf(stderr,"BmisscntDetect Off!\n");
	
	return NULL;
}

void
mnctrl_init(char *todest)
{
	//from mn-ctrl
	__SEQNO__ = 2;
    bzero(&dest,sizeof(dest));
  	dest.sin_family = AF_INET;
  	if(todest==NULL)
    	inet_pton(AF_INET,"127.0.0.1",&dest.sin_addr);
  	else 
    	inet_pton(AF_INET,todest,&dest.sin_addr);
  	dest.sin_port = htons(7777);
  	sock_fd = socket(AF_INET,SOCK_DGRAM,IPPROTO_UDP);
	int on=1;	
	if(setsockopt(sock_fd, SOL_SOCKET, SO_REUSEADDR, &on, sizeof(on)) <0){
   		fprintf(stderr,"socket rebind set error!\n");
  	}
	struct sockaddr_in addr;
	memset(&addr, 0, sizeof(addr));
  	addr.sin_port = htons(7776);
  	addr.sin_addr.s_addr = INADDR_ANY;
	while(bind(sock_fd, (struct sockaddr *) &addr, sizeof(addr)));
		//perror("bind failed");
  
	//not from mn-ctrl
	mnswitch=OFF;
	mnstop=FALSE;
	mnpid=-1;
	prompt=TRUE;
}

int
cngictrl_init(void)
{
	checkdir(CNGIPATH);
	checkwpaconf();

#if IPFIX_USE_RTNETLINK==1	
	int err,val;
  	if((err = rtnl_route_open(&md_rth, 0)) < 0)
    	return err;
  	val = RTNLGRP_LINK;
  	if(setsockopt(md_rth.fd, SOL_NETLINK,NETLINK_ADD_MEMBERSHIP, &val, sizeof(val)) < 0) {
    	perror("Error: setsockopt\n");
		return -1;
  	}
#endif

	getcmdResult("lsmod");
	if(strstr(cmdresult,"ar6000")==NULL){
		wifiswitch=OFF;	
	}
	else{
		wifiswitch=ON;
	}
	getcmdResult("ps mn");
	if(strstr(cmdresult,"mn")==NULL){
		mnswitch=OFF;
	}
	else{
		mnswitch=ON;
		checkdir(CNGIPATH);
		//find the mn pid
		getcmdResult("ps mn");
		char *p=strchr(cmdresult,'\n');
		while(!(*p>='0'&&*p<='9'))
			p++;
		mnpid=getnumfromstr(p);
		//if(mnpid==-1)
			//fprintf(stderr, "Error:finding mnpid failed!\n");
		mnstop=FALSE;
	}
	rmnetstatus=RMNET_FIX;
	return 0;
}

int
main(int argc,char *argv[])
{
  	fd_set rfds;
  	struct timeval tv;
	//int flag;
	char line[1024];

	//FD_ZERO(&rfds);
	//FD_SET(0,&rfds);
	//flag=1;
	
	//init mn-ctrl
	mnctrl_init(NULL);
	//init cngictrl
	cngictrl_init();

	fprintf(stderr,"# ");

	while(1)
	{
		/*
		if(flag){
			fprintf(stderr,"# ");
			flag=0;
		}*/
		
		FD_ZERO(&rfds);
		FD_SET(0,&rfds);
		FD_SET(sock_fd,&rfds);
		tv.tv_sec=1;
		tv.tv_usec=0;
	
		//int retval=select(1,&rfds,0,0,&tv);
		//fprintf(stderr,"the retval is %d\n",retval);
		if(select(sock_fd+1,&rfds,0,0,&tv)<=0)
			continue;
		else{
		  	//flag=1;
			
			if(FD_ISSET(sock_fd,&rfds)){
      			struct CTRL_CMD_ACK ctrl_cmd_ack;
      			struct sockaddr_in rin;
      			int address_size=sizeof(rin);
      			int n=recvfrom(sock_fd, &ctrl_cmd_ack, sizeof(ctrl_cmd_ack),0,(struct sockaddr *)&rin,&address_size);
      			//fprintf(stderr,"\nsock_fd changed, enter in!!\n#");
				if(ctrl_cmd_ack.seqno==__SEQNO__-1){
					fprintf(stderr,"\r%s",ctrl_cmd_ack.ack);
      			}
				else
				if(ctrl_cmd_ack.seqno==0){
					//fprintf(stderr,"\nseq==0 enter in!!\n#");
					switch(ctrl_cmd_ack.chksum){
						case ACK_IPFIX:
							if(wifiswitch==ON || (wifiswitch==OFF&&mnswitch==ON)){
								ipfix(&ctrl_cmd_ack);
								//wlancheck();
								//fprintf(stderr,"# ");
								struct CTRL_CMD ctrl_cmd;
								//#define CTRL_CMD_IPFIXDONE 10
								ctrl_cmd.cmd=10;
								//ctrl_cmd.seqno = __SEQNO__++;
								//int n=sendto(sock_fd,&ctrl_cmd,sizeof(ctrl_cmd),0,(struct sockaddr *)&dest,sizeof(dest));
								int n=sendto(sock_fd,&ctrl_cmd,sizeof(ctrl_cmd),0,(struct sockaddr *)&rin,sizeof(rin));
								if(n<=0)
									perror("send data failed.\n");
					
							}
							prompt=FALSE;
							break;
						case ACK_RMNET:
							if(ctrl_cmd_ack.ack[0]==1){
								rmnetstatus=RMNET_FIX;
							}
							prompt=FALSE;
							break;
					}
				}
    		}
			else
			if(FD_ISSET(0,&rfds))
			{
				fgets(line,1024,stdin);	
				if(strncmp(line,"wifi",4)==0){
					char *lp=line+4;
					if(strstr(lp,"on")!=NULL){
						//add wifi thread to process wifi on
						//we need to close the dad neither in mn here nor in the mn startup,
						//because the mn itself does it
						getcmdResult("lsmod");
						if(strstr(cmdresult,"ar6000")==NULL){
							system("insmod /system/wifi/ar6000.ko");
							/*
							if(fileload(WPA_SUPPLICANT_CONFIG_PATH,wpa_supplicant_conf)==-1){
								perror("Error:fileload failed\n");
							}
							else{
								system("chmod 660 " WPA_SUPPLICANT_CONFIG_PATH);
								system("chown system.wifi " WPA_SUPPLICANT_CONFIG_PATH);
							}
							*/
							//do{
							usleep(2500*1000);
								//getcmdResult("lsmod");
							//} while(strstr(cmdresult,"ar6000")==NULL);
							//usleep(500000);
							system(WPA_SUPPLICANT_CMD);
						}
						wifiswitch=ON;
						getcmdResult("ip link");
						if((lp=strstr(cmdresult,"wlan0"))!=NULL){
							while(*lp!='\n')
								lp--;
							lp++;
							linknumwlan=getnumfromstr(lp);
						}
					}
					else
					if(strstr(lp,"off")!=NULL){//kill wifi thread to process wifi off	
						//to kill the bmisscnt_detect thread
						wifiswitch=OFF;
						bmisscntDetect_run=OFF;
						pthread_cond_signal(&cond_bmisscntDetect);
						
						getcmdResult("ps wpa_supplicant");
						if(strstr(cmdresult,"wpa_supplicant")!=NULL){
							//fprintf(stderr, "the cmdresult is :\n%s\n", cmdresult);
							char *p=strchr(cmdresult,'\n');
							//fprintf(stderr, "the p is :\n%s\n",p);
							while(!(*p>='0'&&*p<='9'))
								p++;
							int pid=getnumfromstr(p);
							KILL_COMMON_ARG(pid);
							//fprintf(stderr, "the pid is:%d\n",pid);
						}
						system("rmmod ar6000");
						strcpy(wlan_route,"");
					}
					else{
						fprintf(stderr, "invalid arg, arg should be <on | off>\n");
					}
				}
				else
				if(strncmp(line,"rmnet",5)==0){
					char *lp=line+5;
					if(strstr(lp,"on")!=NULL){
						rmnet_flag=1;
						rmnetstatus=RMNET_ON;
					}
					else
					if(strstr(lp,"off")!=NULL){
						//To do
						//If the rmnet down, how can we get this signal?Now I used human, but will auto detect later on.
						rmnet_flag=0;
						rmnetstatus=RMNET_OFF;
					}
					else
					if(strstr(lp,"fix")!=NULL){
						rmnetstatus=RMNET_FIX;
					}
					else{
						fprintf(stderr, "invalid arg, arg should be <on | off | fix>\n");
					}
				}
				else
				if(strncmp(line,"mn",2)==0){
					char *lp=line+2;
					if(strstr(lp,"cont")==NULL && strstr(lp,"on")!=NULL){
						if(mnswitch==OFF){
							checkdir(CNGIPATH);
							system("mn>" MNLOGPATH " 2>&1 &");
							mnswitch=ON;
							//find the mn pid
							getcmdResult("ps mn");
							char *p=strchr(cmdresult,'\n');
							while(!(*p>='0'&&*p<='9'))
								p++;
							mnpid=getnumfromstr(p);
							//if(mnpid==-1)
								//fprintf(stderr, "Error:finding mnpid failed!\n");
							mnstop=FALSE;
						}
						else{
							fprintf(stderr, "mn already start!\n");
						}
					}
					else
					if(strstr(lp,"off")!=NULL){
						if(mnswitch==ON){
							if(mnpid!=-1){
								if(mnstop==TRUE)
									KILL_CONT_ARG(mnpid);
								KILL_INT_ARG(mnpid);
								mnpid=-1;
								mnswitch=OFF;
								mnstop=TRUE;
								rmnetstatus=RMNET_FIX;
								rmnet_flag=0;
							}
							else{
								fprintf(stderr, "Error:finding mnpid failed!\n");
							}
						}
						else{
							fprintf(stderr, "mn already shutdown!\n");
						}
					}
					else
					if(strstr(lp,"stop")!=NULL){
						if(mnswitch==ON){
							if(mnstop==FALSE){
								if(mnpid!=-1){
									KILL_STOP_ARG(mnpid);
									mnstop=TRUE;
								}
								else{
									fprintf(stderr, "Error:finding mnpid failed!\n");
								}
							}
							else{
								fprintf(stderr, "mn already stop!\n");
							}
						}
						else{
							fprintf(stderr,"mn already shutdown, can't stop!\n");
						}
					}
					else
					if(strstr(lp,"cont")!=NULL){
						if(mnswitch==ON){
							if(mnstop==TRUE){
								if(mnpid!=-1){
									KILL_CONT_ARG(mnpid);
									mnstop=FALSE;
								}
								else{
									fprintf(stderr, "Error:finding mnpid failed!\n");
								}
							}
							else{
								fprintf(stderr, "mn already cont!\n");
							}
						}
						else{
							fprintf(stderr, "mn already shutdown, can't cont!\n");
						}
					}
					else
					if(strstr(lp,"status")!=NULL){
						if(mnswitch==ON)
						{
							if(mnstop==TRUE){
								fprintf(stderr, "mn [stopped]\n");
							}
							else{
								fprintf(stderr, "mn [running]\n");
							}
						}
						else{
							fprintf(stderr,"mn [shutdown]\n");
						}
					}
					else{
						fprintf(stderr, "invalid arg, arg should be <on | off | stop | cont | status>\n");
					}
				}
				else
				if(strncmp(line,"ping",4)==0){
					char *lp=line+4;
					if(strstr(lp,"cont")==NULL && strstr(lp,"on")!=NULL){
						//int argc=4;
						//char *argv[20]={"ping","-i","0.01","10.21.5.54"};
						//ping(argc,argv);
ping_on_restart:
						if(pingstatus==PINGOFF){
							tid_ping_on=0;
    						if(pthread_create(&tid_ping_on,NULL,ping_on,NULL)<0){
    							perror("ERROR: ping can't start\n");
    						}
							else{
								pingstatus=PINGON;
								pingfixed=FALSE;
								halting=0;
								exiting=0;
							}
						}
						else{
							fprintf(stderr,"ping is already on!\n");
						}
					}
					else
					if(strstr(lp,"off")!=NULL){
						if(pingstatus!=PINGOFF){
							if(halting==1){
								halting=0;
								pthread_cond_signal(&cond_ping_on);
							}
							exiting=1;
							pthread_join(tid_ping_on,NULL);
							exiting=0;
							//pthread_kill(tid_ping_on,SIGINT);
							//pthread_join(tid_ping_on,NULL);
							pingstatus=PINGOFF;
						}
						else{
							fprintf(stderr,"ping is already off!\n");
						}
					}
					else
					if(strstr(lp,"stop")!=NULL){
						//pthread_kill(tid_ping_on,SIGSTOP);
						if(pingstatus==PINGON){
							halting=1;
							pingstatus=PINGSTOP;
						}
						else{
							fprintf(stderr,"ping is off or has already stopped, it need not stop!\n");
						}
					}
					else
					if(strstr(lp,"cont")!=NULL){
						//pthread_kill(tid_ping_on,SIGCONT);
						if(pingstatus==PINGSTOP){
							halting=0;
							pthread_cond_signal(&cond_ping_on);
							pingstatus=PINGON;
						}
						else{
							fprintf(stderr,"ping is not stopped, it need not cont!\n");
						}
					}
					else
					if(strstr(lp,"fix")!=NULL){
						lp=strstr(lp,"fix");
						lp=lp+3;
						skipspace(&lp);
						strcpy(pingcmd,lp);
						pingcmd[strlen(pingcmd)-1]=0;
						//fprintf(stderr,"the fixed pingcmd is :%s\n",pingcmd);
						pingfixed=TRUE;
					}
					else
					if(strstr(lp,"restart")!=NULL){
						//pthread_kill(tid_ping_on,SIGINT);
						if(pingstatus!=PINGOFF){
							if(halting==1){
								halting=0;
								pthread_cond_signal(&cond_ping_on);
							}
							exiting=1;
							pthread_join(tid_ping_on,NULL);
							exiting=0;
							//pthread_kill(tid_ping_on,SIGINT);
							//pthread_join(tid_ping_on,NULL);
							pingstatus=PINGOFF;
						}
						pingfixed=FALSE;
						goto ping_on_restart;
					}
					else
					if(strstr(lp,"miss")!=NULL){
						lp=strstr(lp,"miss")+4;
						missedseq=(__u16)getnumfromstr(lp);	
						//missedtime.tv_usec=(suseconds_t)getnumfromstr(lp);
					}
					else
					if(strstr(lp,"status")!=NULL){
						switch(pingstatus){
							case PINGON:
								fprintf(stderr,"%s [running]",pingcmd);
								break;
							case PINGOFF:
								fprintf(stderr,"%s [shutdown]",pingcmd);
								break;
							case PINGSTOP:
								fprintf(stderr,"%s [stopped]",pingcmd);
								break;
						}
						if(pingfixed==TRUE){
							fprintf(stderr," !!fixed, need to restart!!");
						}
						fprintf(stderr, " [missedseq %3u ; missedtime %3ld(ms)]",missedseq,missedtime.tv_usec/1000);
						//fprintf(stderr, " [missedtime %3ld(ms)]",missedtime.tv_usec/1000);
						fprintf(stderr,"\n");
						
					}
					else{
						fprintf(stderr,"invalid arg, arg should be <on | off | stop | cont | restart | fix <cmd> | miss <num> | status>\n");
					}
				}
				else
				if(strncmp(line,"rule",4)==0){
					char *lp=line+4;
					if(strstr(lp,"show")!=NULL){
						ruleshow();
					}
					else
					if(strstr(lp,"clear")!=NULL){
						ruleclear();	
					}
					else{
						fprintf(stderr, "invalid arg, arg should be <show | clear>\n");
					}
				}
				else
				if(strncmp(line,"staticip",8)==0){
					char *lp=line+8;
					if(strstr(lp,"show")!=NULL){
						staticipshow();
					}
					else
					if(strstr(lp,"fix")!=NULL){
						staticipfix(strstr(lp,"fix")+3);
					}
					else{
						fprintf(stderr, "invalid arg, arg should be <show | fix>\n");
					}
				}
				else
				if(strncmp(line,"apssid",6)==0){
					char *lp=line+6;
					if(strstr(lp,"show")!=NULL){
						apssidshow();
					}
					else
					if(strstr(lp,"fix")!=NULL){
						apssidfix(strstr(lp,"fix")+3);
						checkwpaconf();
					}
					else{
						fprintf(stderr, "invalid arg, arg should be <show | fix>\n");
					}
				}
				else
				if(strncmp(line,"ipfixway",8)==0){
					char *lp=line+8;
					if(strstr(lp,"dhcp")!=NULL){
						ipcfg=dhcpway;
					}
					else
					if(strstr(lp,"static")!=NULL){
						ipcfg=staticway;
					}
					else
					if(strstr(lp,"no")!=NULL){
						ipcfg=noway;
					}
					else
					if(strstr(lp,"status")!=NULL){
						fprintf(stderr, "%s\n",ipcfg?ipcfg-1?"no":"static":"dhcp");
					}
					else{
						fprintf(stderr, "invalid arg, arg should be <dhcp | static | no | status>\n");
					}
				}
				else
				if(strncmp(line,"setbmisscnt",11)==0){
					char *lp=line+11;
					while(*lp==' ')
						lp++;
					int temp_bmisscnt=0;
					int correct=0;
					while(*lp>='0'&&*lp<='9')
					{
						correct=1;
						temp_bmisscnt=temp_bmisscnt*10+(*lp-'0');
						lp++;
					}
					if(correct==0){
						fprintf(stderr,"bmisscnt value invalid\n");
					}
					else{
						if(temp_bmisscnt==0){		
							bmisscntDetect_run=OFF;
							pthread_cond_signal(&cond_bmisscntDetect);
							pthread_join(tid_bmisscntDetect,NULL);
							bmisscnt=DEFAULT_BMISSCNT;
							bmissintvl=DEFAULT_BMISSINTVL;
						}
						else{
							bmisscnt=temp_bmisscnt;
							if(bmisscntDetect_run==OFF){
								bmisscntDetect_run=ON;
								tid_bmisscntDetect=0;
                       			if(pthread_create(&tid_bmisscntDetect,NULL,bmisscntDetect,NULL)<0){
                            		perror("ERROR: bmisscntDetect can't start\n");
                            		bmisscntDetect_run=OFF;
                        		}
							}	
						}

					}
				}
				else 
				if(strncmp(line,"setbmissintvl",13)==0){
					char *lp=line+13;
					while(*lp==' ')
						lp++;
					int temp_bmissintvl=0;
					int correct=0;
					while(*lp>='0'&&*lp<='9')
					{
						correct=1;
						temp_bmissintvl=temp_bmissintvl*10+(*lp-'0');
						lp++;
					}
					if(correct==0){
						fprintf(stderr,"bmissintvl value invalid\n");
					}
					else{
						bmissintvl=temp_bmissintvl;
					}
				}
				else
				if(strncmp(line,"to",2)==0){
					if(wifiswitch==OFF){
						fprintf(stderr,"wlan card is off, can not set wifi.\n");
						goto toexit;
					}
					if(currentlinknum==linknumrmnet && autohandoff==OFF){
						fprintf(stderr,"Can not set wifi when auto off on rmnet.\n");
						goto toexit;
					}
					char *lp=line+2;
					while(*lp==' ')
						lp++;
					int tonetwork=0;
					int correct=0;
					while(*lp>='0'&&*lp<='9')
					{
						correct=1;
						tonetwork=tonetwork*10+(*lp-'0');
						lp++;
					}
					if(correct==0){
						fprintf(stderr,"selected network value invalid\n");
					}
					else{
						//to do:notify information about the previous link addr and link route,
						//		and then delete it after WPA_CLI_SELECT_NETWORK cmd happens.
						newid=tonetwork;
						//ipfix();
						WPA_CLI_ARG("select_network", newid);
						//bug?
						if(mnswitch==OFF)
							ipfix_mnoff();
						//system("ip -6 addr flush dev wlan0");
						//system("ip -6 addr del 2001:cc0:2026:5:221:e8ff:fefb:e658/64 dev wlan0");
						//system("ip -6 route del 2001:cc0:2026:5::/64 dev wlan0");
						//system("ip -6 route del default via fe80::214:78ff:fe84:5d3a dev wlan0");
					}
toexit:;
				}
				else
				if(strncmp(line,"list",4)==0){
					WPA_CLI_COMMON("list_network");
				}
				else
				if(strncmp(line,"scan",4)==0){
					char *lp=line+4;
					while(*lp==' ')
						lp++;
					if(strstr(lp,"on")!=NULL){
						WPA_CLI_COMMON("ap_scan 1");	
					}
					else
					if(strstr(lp,"off")!=NULL){
						WPA_CLI_COMMON("ap_scan 2");
					}
					else{
						fprintf(stderr, "invalid arg, arg should be <on | off>\n");
					}
				}
				else
				if(strncmp(line,"wpa_cli_shell",13)==0){
					WPA_CLI_COMMON("");
				}
				else
				if(strncmp(line,"wpa_cli",7)==0){
					char *lp=line+7;
					char cmd[80];
					sprintf(cmd, WPA_CLI_CMD);
					strcpy(cmd+strlen(WPA_CLI_CMD),lp);
					system(cmd);
				}
				else
				if(strncmp(line,"show",4)==0){
					system("cat " WPA_SUPPLICANT_CONFIG_PATH);
				}
				else
				if(strncmp(line,"setbmissbeacons",15)==0){
					char *lp=line+15;
					int ret=getnumfromstr(lp);
					if(ret!=-1){
						bmissbeacons=ret;
						WMICONFIG_ARG("--setbmissbeacons",bmissbeacons);
					}
					else{
						fprintf(stderr, "invalid arg, arg shoud be a positive number\n");
					}
				}
				else
				if(strncmp(line,"wmiconfig",9)==0){
					char *lp=line+9;
					char cmd[80];
					sprintf(cmd, WMICONFIG_CMD);
					strcpy(cmd+strlen(WMICONFIG_CMD),lp);
					system(cmd);
				}
				else
				if(strncmp(line,"logcat",6)==0){
					LOGCAT_COMMON("-v time wpa_supplicant:V *:S");
				}
				else
				if(strncmp(line,"catproc",7)==0){
					CAT_COMMON(PROCKMSG);
				}
				//add mn-ctrl
				else
				if(strncmp(line,"lscoa",5)==0){
					struct CTRL_CMD ctrl_cmd;
					ctrl_cmd.cmd=CTRL_CMD_LSCOA;
					ctrl_cmd.seqno = __SEQNO__++;
					int n=sendto(sock_fd,&ctrl_cmd,sizeof(ctrl_cmd),0,(struct sockaddr *)&dest,sizeof(dest));
					if(n<=0)
						perror("send data failed.\n");
      				}
      			else
				if(strncmp(line,"handoff",7)==0){
					uint16_t ifindex=0;
					char *p=line+7;
					/*
					while(*p!='\n'&&!(*p>='0'&&*p<='9'))
						++p;
					while(*p>='0'&&*p<='9'){
	  					ifindex*=10;
	  					ifindex+=*p++-'0';
					}
					*/
					if(strstr(p,"rmnet")!=NULL){
						ifindex=linknumrmnet;
					}
					else
					if(strstr(p,"wlan")!=NULL){
						ifindex=linknumwlan;
					}
					else{
						fprintf(stderr,"invalid arg, arg should be <rmnet | wlan>!\n");
						goto handexit;
					}
					if(ifindex==0){
	  					fprintf(stderr,"wlan card is not up\n");
					}
					else
					if(autohandoff==ON){
						fprintf(stderr,"You must firstly disable auto_handoff(auto off)\n");
					}				
					else{
						if(rmnetstatus==RMNET_FIX)
							rmnetcheck();
						iproutedel();
						if(ifindex==linknumrmnet){
							//if(rmnetstatus==RMNET_FIX)
								//rmnetcheck();
							rmnet_route_add();
							currentlinknum=linknumrmnet;
						}
						else{
						   if(wlan_route_add()!=0){
							 //fprintf(stderr,"!!Can not handoff!\n");
							 //goto handexit;
						   }
						   currentlinknum=linknumwlan;
						}

	  					struct CTRL_CMD ctrl_cmd;
	  					ctrl_cmd.cmd=CTRL_CMD_HANDOFF;
	  					ctrl_cmd.data=ifindex;
	  					ctrl_cmd.seqno=__SEQNO__++;
	  					int n=sendto(sock_fd,&ctrl_cmd,sizeof(ctrl_cmd),0,(struct sockaddr *)&dest, sizeof(dest));
	 					if(n<=0)perror("send data failed.\n");
					}
handexit:           ;
				}
      			else
				if(strncmp(line,"ap",2)==0){
					char * p = line+2;
					while(*p==' ')++p;
					char * q = p;
					while(*q>='a'&&*q<='z')++q;
					*q=0;
					if(strcmp(p,"on")==0){
	  					//ap on
	  					fprintf(stderr,"ap on\n");
					}
					else
					if(strcmp(p,"off")==0){
	  					//ap off
	  					fprintf(stderr,"ap off\n");
					}
					else
					if(strcmp(p,"move")==0){
	  					fprintf(stderr,"ap move\n");
					}
					else
						fprintf(stderr,"!! ap <on|off|move>\n");
      			}
				else
				if(strncmp(line,"auto",4)==0){
					char * p = line+4;
					while(*p==' ')++p;
					char * q = p;
					while(*q>='a'&&*q<='z')++q;
					*q=0;
					if(strcmp(p,"on")==0){
	  					//auto handoff on
	  					//fprintf(stderr,"auto handoff on\n");
						autohandoff=ON;
						struct CTRL_CMD ctrl_cmd;
	  					ctrl_cmd.cmd=CTRL_CMD_AUTO_HANDOFF_ON;
	  					//ctrl_cmd.data=ifindex;
	  					ctrl_cmd.seqno=__SEQNO__++;
	  					int n=sendto(sock_fd,&ctrl_cmd,sizeof(ctrl_cmd),0,(struct sockaddr *)&dest, sizeof(dest));	
	 					if(n<=0)perror("send data failed.\n");
					}
					else
					if(strcmp(p,"off")==0){
	  					//auto handoff off
	  					//fprintf(stderr,"auto handoff off\n");
						autohandoff=OFF;
						struct CTRL_CMD ctrl_cmd;
	  					ctrl_cmd.cmd=CTRL_CMD_AUTO_HANDOFF_OFF;
	  					//ctrl_cmd.data=ifindex;
	  					ctrl_cmd.seqno=__SEQNO__++;
	  					int n=sendto(sock_fd,&ctrl_cmd,sizeof(ctrl_cmd),0,(struct sockaddr *)&dest, sizeof(dest));	
	 					if(n<=0)perror("send data failed.\n");
					}
					else
					if(strcmp(p,"status")==0){//bug
						if(autohandoff==ON){
							fprintf(stderr,"[auto handoff] on\n");
						}
						else{
							fprintf(stderr,"[auto handoff] off\n");
						}
					}
					else
						fprintf(stderr,"!! auto <on | off | status>\n");
				}
				else
				if(strncmp(line,"quit",4)==0){
					bmisscntDetect_run=OFF;
					pthread_cond_signal(&cond_bmisscntDetect);
					//colse mn-ctrl socket
					close(sock_fd);
					//sleep(1);
					pthread_join(tid_bmisscntDetect,NULL);
					
					if(pingstatus!=PINGOFF){
						if(halting==1){
							halting=0;
							pthread_cond_signal(&cond_ping_on);
						}
						exiting=1;
						pthread_join(tid_ping_on,NULL);
						exiting=0;
						//pthread_kill(tid_ping_on,SIGINT);
						//pthread_join(tid_ping_on,NULL);
						pingstatus=PINGOFF;
					}

					if(mnswitch==ON){
						if(mnpid!=-1){
							if(mnstop==TRUE)
								KILL_CONT_ARG(mnpid);
							KILL_INT_ARG(mnpid);
							mnpid=-1;
							mnswitch=OFF;
							mnstop=TRUE;
							rmnetstatus=RMNET_FIX;
							rmnet_flag=0;
						}
						else{
							fprintf(stderr, "Error:finding mnpid failed!\n");
						}
					}
					
					return 0;
				}
				else
				if(strncmp(line,"link",4)==0){
					char *lp=line+4;
					if(strstr(lp,"status")!=NULL){
						fprintf(stderr, "rmnet:%d wlan:%d\n",linknumrmnet,linknumwlan);
					}
					else
					if(strstr(lp,"fix")!=NULL){
						lp=strstr(lp,"fix");
						lp=lp+3;
						linknumrmnet=getnumfromstr(lp);
						if(linknumrmnet!=-1){
							skipspace(&lp);
							while(*lp>='0'&&*lp<='9')
								lp++;
						}
						skipspace(&lp);
						while(*lp==" ")
							lp++;
						linknumwlan=getnumfromstr(lp);
					}
					else{
						fprintf(stderr, "Invalid arg, arg should be <status | fix rmnetnum wlanum>\n");
					}
				}
				else 
				if(strncmp(line,"help",4)==0){
					usage();
				}
                //a: yhz
				else 
				if(strncmp(line,"flowhf", 6)==0){
					do_handoff();
				}
				else{
					fprintf(stderr, "Command not found!\n");
				}
				//fprintf(stderr,"# ");
			}//FD_ISSET
			if(prompt==TRUE)
				fprintf(stderr,"# ");
			else
				prompt=TRUE;
		}//select
	}//while	
}
