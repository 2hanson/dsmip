#include <stdio.h>

int main(int argc, char * argv[])
{
  FILE * fp = fopen(argv[1],"r");
  if(!fp)return 0;
  char byte[1];
  int ret = fread(byte,1,1,fp);
  int k = 0;
  while(ret){
    fprintf(stderr,"0x%02x,",byte[0]&0xff);
     ret = fread(byte,1,1,fp);
     ++k;
     if(k%30==0)fprintf(stderr,"\n");
  }
}
  
