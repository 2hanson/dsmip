#include <signal.h>
#include <sys/types.h>
#include <arpa/inet.h>
#include <sys/socket.h>
#include <unistd.h>
#include <stdio.h>
#include <memory.h>
#include <string.h>

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
}__attribute((packed));;;

struct CTRL_CMD_ACK
{
  uint16_t seqno;
  uint16_t chksum;
  uint16_t acklen;//length of ack data                                
  uint8_t ack[300];//data 500 bytes at most                              
}__attribute((packed));;;;


int main(int argc,char *argv[])
{
  
  uint16_t __SEQNO__ = 1;
  struct sockaddr_in dest, src;
  int sock_fd;
  int n;
  bzero(&dest,sizeof(dest));
  dest.sin_family = AF_INET;
  if(argc==1)
    inet_pton(AF_INET,"127.0.0.1",&dest.sin_addr);
  else 
    inet_pton(AF_INET,argv[1],&dest.sin_addr);
  dest.sin_port = htons(7777);
  sock_fd = socket(AF_INET,SOCK_DGRAM,IPPROTO_UDP);
  char line[1024];
  int flag = 1;
  while(1){
    if(flag){
      fprintf(stderr,"# ");
      flag=0;
    }
    fd_set rfds;
    FD_ZERO(&rfds);
    FD_SET(0,&rfds);
    FD_SET(sock_fd,&rfds);
    struct timeval tv;
    tv.tv_sec = 1;
    tv.tv_usec = 0;
    int retval = select(sock_fd+1,&rfds,0,0,&tv);
    if(retval<=0)continue;
    flag=1;
		  
    if(FD_ISSET(sock_fd,&rfds)){
      struct CTRL_CMD_ACK ctrl_cmd_ack;
      struct sockaddr_in rin;
      int address_size = sizeof(rin);
      int n = recvfrom (sock_fd, &ctrl_cmd_ack, sizeof(ctrl_cmd_ack),0,
			(struct sockaddr *)&rin,
			&address_size);
      if(ctrl_cmd_ack.seqno==__SEQNO__-1){
	fprintf(stderr,"\r%s",ctrl_cmd_ack.ack);
      }
    }
    else if(FD_ISSET(0,&rfds)){
      fgets(line,1024,stdin);
      if(strncmp(line,"lscoa",5)==0){
	struct CTRL_CMD ctrl_cmd;
	ctrl_cmd.cmd=CTRL_CMD_LSCOA;
	ctrl_cmd.seqno = __SEQNO__++;
	n = sendto(sock_fd,&ctrl_cmd,sizeof(ctrl_cmd),0,
		   (struct sockaddr *)&dest, sizeof(dest));
	if(n<=0)perror("send data failed.");
      }
      else if(strncmp(line,"handoff",7)==0){
	uint16_t ifindex =0;
	char *p=line;
	while(*p!='\n'&&!(*p>='0'&&*p<='9'))++p;
	while(*p>='0'&&*p<='9'){
	  ifindex*=10;
	  ifindex+=*p++-'0';
	}
	if(ifindex==0){
	  fprintf(stderr,"!! handoff [ifindex]\n");
	}
	else {
	  struct CTRL_CMD ctrl_cmd;
	  ctrl_cmd.cmd=CTRL_CMD_HANDOFF;
	  ctrl_cmd.data=ifindex;
	  ctrl_cmd.seqno=__SEQNO__++;
	  n = sendto(sock_fd,&ctrl_cmd,sizeof(ctrl_cmd),0,
		     (struct sockaddr *)&dest, sizeof(dest));	
	  if(n<=0)perror("send data failed.");
	}
      }
      else if(strncmp(line,"ap",2)==0){
	char * p = line+2;
	while(*p==' ')++p;
	char * q = p;
	while(*q>='a'&&*q<='z')++q;
	*q=0;
	if(strcmp(p,"on")==0){
	  //ap on
	  fprintf(stderr,"ap on\n");
	}
	else if(strcmp(p,"off")==0){
	  //ap off
	  fprintf(stderr,"ap off\n");
	}
	else if(strcmp(p,"move")==0){
	  fprintf(stderr,"ap move");
	}
	else fprintf(stderr,"!! ap [on|off|move]\n");
      }
      else if(strncmp(line,"quit",4)==0||
	      strncmp(line,"exit",4)==0){
	close(sock_fd);
	return 0;
      }
      else if(strncmp(line,"help",4)==0){
	fprintf(stderr,"handoff [ifindex]: handoff to ifindex.\n"
		"Note: May fail if ifindex have no valid ipv6 address.\n\n"
		"lscoa: list the address and interfaces of Mobile Node.\n"
		"Note: The address used for COA is denoted as [x] and alternative\n"
		"addresses are denoted as [o].\n");
      }
      else {
	fprintf(stderr,"command not found!\n");
      }
    }
  }
}


