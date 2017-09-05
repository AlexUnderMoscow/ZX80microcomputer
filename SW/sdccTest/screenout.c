
#include "lib.h"
#include <stdlib.h>
//#include <math.h>


void boot()
{
  __asm
     ld sp, #0x8000
     ld ix, #0x7000
     call _main
   __endasm;
}
int main()
{

  long ind, j;
  short my;
  unsigned short addr;
  char c;
  unsigned char s,key;
  char* point;
  int  cool;
  float fl;
  c=0;
  printLCD(" Hello world! ");
  pos(5,2);
  print("Hello world!");
  pos(5,5);
  print("Z80 handmade computer.");
  print(" Memory test.");
  s=0;
  cool=1;
  addr=0;
  ind=0;
  for (ind=0;ind<256;ind++)
  {

      point = (char*)(ind+0x6000);
      *point=0xFF;
      c=*point;
      if (c!=0xFF)
        {
          cool=0;
        }
          *point = 0x00;
          c= *point;
      if (c!=0x00)
        {
          cool=0;
        }
      pos(5,10);
      printl("byte #: %d ",ind+0x6000);
  }

  if (cool==0)
    {
      print(" Ok");
    }
  for (ind = 0; ind < 256; ind++)
    {
      for (j=0; j<20;j++)
        {
          c++;
          c--;
        }
      c++;
      _leds = c;
       pos(40,10);
      prints("LED TEST. STEP = %d ",ind);
    }
  pos (5,15);
  ind = -2140070;
  printl("LONG type print test: %d OK",ind);
 my = -4880;
  pos (5,16);
  prints("SHORT type print test = %d OK",my);
  pos (5,17);
  fl = -7.252356;
  printfl("FLOAT type print test = %f OK",fl);
   pos (5,18);

   print("Are you sure? (Y/N):");
     key = getch();
     putch(key);

   pos (5,19);
  print("LOOP test:");
  for (my=0; my<15;my++)
   {
       pos(5,21+my);
       prints("STEP %d ",my);
   }
  pos (25,19);
  print("Float test:");
  fl=-15.24;
  my=0;
  while (fl<5.5)
   {
       pos(25,21+my);
       printfl("%f ",fl);
       fl=fl+1.8690435;
       my++;
   }
  stop();
  return 0;
}

