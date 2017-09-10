#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <Windows.h>
#include "winsock.h"
//#pragma comment(lib,"libws2_32.a")
#define HAVE_REMOTE
#include "pcap.h"
#include <iostream>
#include <conio.h>


#define packSize 1024

struct header{
  char macdst[6];
  char macsrc[6];
  short EtherType;
};

struct mypacket{
  header head;
  unsigned char data[packSize];
};

void payload(unsigned char* pbuf, short len, mypacket* pack, unsigned short* addr)
{
  unsigned short addrtosenf;
  unsigned char* c;
  unsigned int pksz = (packSize >> 2);
  pack->head.EtherType=0;
  //заливка данных
  for (int i = 0; i<len; i++)
    {
      *((unsigned char*)(&addrtosenf)+0)=*((unsigned char*)(addr)+1);
       *((unsigned char*)(&addrtosenf)+1)=*((unsigned char*)(addr)+0);
      memcpy(pack->data+i*4,&addrtosenf,sizeof(unsigned short));
      *(addr)+=1;
      pack->data[i*4+2]=*(pbuf+i);
      *(pack->data+i*4+3) = 0;
    }
  *((unsigned char*)(&addrtosenf)+0)=*((unsigned char*)(addr)+1);
   *((unsigned char*)(&addrtosenf)+1)=*((unsigned char*)(addr)+0);

  for (int i = len ;i<pksz;i++)
    {
       memcpy(pack->data+i*4,&addrtosenf,sizeof(unsigned short));
       pack->data[i*4+2]=*(pbuf+len-1);
       *(pack->data+i*4+3) = 0;
    }
  //данные готовы
}

void packSend(unsigned char* buf, short len, mypacket* pack, pcap_t* fp)
{
  unsigned short addr=0;
  payload(buf,len,pack,&addr);
  //теперь заголовки
  for (int i = 0; i<2;i++)
    {
      if (i==0)
        {
          for (int j = 0; j< 6; j++)
            {
              pack->head.macdst[j] = 0x22;
              pack->head.macsrc[j] = 0x11;
            }
        }
      if (i==1)
        {
          for (int j = 0; j< 6; j++)
            {
              pack->head.macsrc[j] = 0x22;
            }
        }
      // отправка даных
      int s= sizeof(mypacket);
      pcap_sendpacket(fp, (u_char*)pack, sizeof(mypacket) /* size */);
    }

}

void multyPackSend(unsigned char* buf, short len, mypacket* pack, int packCount,pcap_t* fp)
{
  unsigned char* point;
  point = buf;
  int offset = 0;
  unsigned short addr=0;
  for (int j = 0; j< 6; j++)
    {
      pack->head.macdst[j] = 0x22;
      pack->head.macsrc[j] = 0x11;
    }
  for (int i = 0; i<packCount-1; i++)
    {
      payload(point+offset,(packSize>>2),pack,&addr);
      int s = sizeof(mypacket);
      pcap_sendpacket(fp, (u_char*)pack, sizeof(mypacket) /* size */);
      offset+=(packSize>>2);
    }

  payload(point+offset,len-offset,pack,&addr);
  for (int j = 0; j< 6; j++)
    {
      pack->head.macsrc[j] = 0x22;
    }
  int s= sizeof(mypacket);
  pcap_sendpacket(fp, (u_char*)pack, sizeof(mypacket) /* size */);
}

int main(int argc, char *argv[])
{
  int i=0;
  //int d;
  float f;
  long int l;
  FILE *file;
  unsigned char* buf;
  pcap_t *fp;
  pcap_if_t *alldevs, *d;
  char errbuf[PCAP_ERRBUF_SIZE];
  u_char packet[1032];
if (argc!=4)
  {
    printf("\nUsage: config.exe -b -1 binfile.bin\n");
    printf("\n -b - binary file (*.bin)\n");
    printf("\n -1 - number of ethernet interface\n");
    printf("\n binfile.bin - firmware file\n");
    return -1;
  }
  if (pcap_findalldevs_ex(PCAP_SRC_IF_STRING, NULL, &alldevs, errbuf) == -1)
          {
              fprintf(stderr,"Error in pcap_findalldevs: %s\n", errbuf);
              return 1;
          }
          for(d=alldevs; d; d=d->next)
              {
              ++i;
              }

              if(i==0)
              {
                  printf("\nNo interfaces found! Make sure WinPcap is installed.\n");
                  return 1;
              }

              int inum = abs(atoi(argv[2]));
              if(inum < 1 || inum > i)
                  {
                      printf("\nInterface number out of range.\n");
                      /* Free the device list */
                      pcap_freealldevs(alldevs);
                      return 1;
                  }
              for(d=alldevs, i=0; i< inum-1 ;d=d->next, i++);

                 /* Open the device */
                 if ( (fp= pcap_open(d->name,          // name of the device
                                           65536,            // portion of the packet to capture.
                                                             // 65536 guarantees that the whole packet will be captured on all the link layers
                                           PCAP_OPENFLAG_PROMISCUOUS,    // promiscuous mode
                                           1000,             // read timeout
                                           NULL,             // authentication on the remote machine
                                           errbuf            // error buffer
                                           ) ) == NULL)
                 {
                     fprintf(stderr,"\nUnable to open the adapter. %s is not supported by WinPcap\n", d->name);
                     /* Free the device list */
                     pcap_freealldevs(alldevs);
                     return 1;
                 }
  printf("\nNetwork device=%s", d->description);
  mypacket pack;
  for (i=1; i< argc; i++) {
      printf("\narg%d=%s", i, argv[i]);
   }
  file = fopen( argv[3], "rb" );
  /* fopen returns NULL pointer on failure */
  if ( file == NULL) {
      printf("\nCould not open file");
    }
  else {
      printf("\nFile %s opened", argv[3]);
      int size = _filelength(fileno(file));
      printf("\nFile size = %d bytes", size);
      buf = new unsigned char[size];
      fread(buf,sizeof(char),size,file);
      int packCount = (size << 2) / packSize;
      packCount++;
      if (strcmp(argv[1],"b"))
        {         //бинарник
            if (packCount==1)
              {//отправляем 1 пакет с прошивкой и тот же завершающий
                  packSend(buf, size, &pack, fp);
              }
            else
              { //отпраялем все пакеты последовательно, последний завершающий
                  multyPackSend(buf,size,&pack,packCount,fp);
              }
        }
      else
        {

        }
      if (strcmp(argv[1],"h"))
        {       //hex

        }
      //delete [] buf;
    }
// fclose(file);
 // printf("\n");
   return 0;
}
