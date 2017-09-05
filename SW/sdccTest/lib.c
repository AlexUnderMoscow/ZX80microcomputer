#include "lib.h"
#include <stdlib.h>


void stop()
{
  __asm
      halt
  __endasm;
}

void printLCD(char* str)
{
  char* LCD;
  char c;
  c=*str;
 LCD = 0xFFE0;
  while (c!=0)
    {
      c=*str++;
      *LCD = c;
      LCD++;
    }
}

unsigned char getch()
{
  unsigned char c;
  c=0;
  while (c==0)
    {
      c=_kbrd;
    }
  return c;
}

void putch(unsigned char ch)
{
  unsigned char c[2];
  c[0] = ch;
  c[1]=0;
  print(c);
}

void pos(unsigned char x, unsigned char y)
{
  _xpos = x;
  _ypos = y;
  return;
}
void print(char* message)
{
  char c;
  c= *message;
  while(c!=0)
    {
      _video = c;
      c=*(++message);
    }
  return;
}
void printfl(char* message, float f)
{
  unsigned long* asInteger;
  char znak,poryadok,l ;
  char c;
  char i;
  unsigned long mantissa;
  unsigned long mask,mask2;
  long cel,drob;
  unsigned char minus_flag,y;
  const long drobn[] = {500000,250000,125000,62500,
                        31250,15625,7812,3906,
                        1953,976,488,244,
                       122,61,30,15,7,3,1};
  c= *message;
  asInteger = (unsigned long*)&f;
  while(c!=0)
    {
      if (c=='%')
        {
          mask = 0x800000;
          znak = (*asInteger) >> 31;
          poryadok = (((*asInteger) >> 23) & 0xFF)-127;
          mantissa = (*asInteger) & 0x7FFFFF;
          mantissa = mask | mantissa;
          l=poryadok;
          if (l>=0)
              {
                mask= mask >> l;
              }
            else
              {
                minus_flag = l >> 7;
                y = minus_flag ^ l;
                y -= minus_flag;
                l=y;
                mask= mask << l;
              }
             cel = 0;
             drob = 0;
             mask2=0x01;
             while (mask!=0)
                  {
                    if ((mantissa & mask)!=0)
                      {
                        cel = cel | mask2;
                      }
                    mask = mask<<1;
                    mask2 = mask2<<1;
                  }
             l=poryadok;
                mask = 0x400000;
                if (l>=0)
                  {
                     mask= mask >> l;
                  }
                else
                  {
                    minus_flag = l >> 7;
                    y = minus_flag ^ l;
                    y -= minus_flag;
                    l=y;
                    mask= mask << l;
                  }
                for (i=0;i<19;i++)
                     {
                      if ((mask & mantissa)!=0)
                        {
                          drob+=drobn[i];
                        }
                       mask = mask >> 1;
                     }
                if (znak!=0) print("-");
                   printl("%d.",cel);
                   printl("%d ",drob);
          c=*(++message);
          c=*(++message);
        }
      _video = c;
      c=*(++message);
    }

  return;
}

void prints (char* message, short number)
{
  short minus_flag,y,cel,ost,div,l;
  char symbol,c;
  int first;
  first = 1;
  c= *message;
  div = 10000;
  l=number;
  while(c!=0)
    {
      if (c=='%')
        {
          if (l<0) //если число менее нуля
            { //перевод отрицательного числа в положительный код
              _video = '-';
              minus_flag = l >> 15;
              y = minus_flag ^ l;
              y -= minus_flag;
              l=y;
            }
          while (div!=1)
            {
              //cel = l / div;
              //ost = l % div;
              cel = 0;
              while (l >= 0)
                {
                  l-=div;
                  ++cel;
                }
                --cel;
                l+=div;
                ost = l;
              //division(l,div,&cel,&ost);

              ////////////////////////////////////
              if (cel!=0)
                {
                  symbol = (char)cel;
                  _video = symbol+0x30;
                  first = 0;
                }
              else
                {
                  if (first!=1)
                    {
                      symbol = (char)cel;
                      _video = symbol+0x30;
                    }
                }
              l = ost;
              if (div==10)
                {
                  div = 1;
                  symbol = (char)ost;
                  _video = symbol+0x30;
                }
              else
                {
                  //div = div/10;
                  switch (div) {
                    case 10000:
                      div = 1000;
                      break;
                    case 1000:
                      div = 100;
                      break;
                    case 100:
                      div = 10;
                      break;
                    }

                  //division(div,10,&cel,&ost); div = cel;

                }
            }
         c=*(++message);
         c=*(++message);
        }
      _video = c;
      c=*(++message);
    }
}

void printl (char* message, long number)
{
  long minus_flag,y,cel,ost,div,l;
  char symbol,c;
  int first;
  first = 1;
  c= *message;
  div = 1000000;
  l=number;
  while(c!=0)
    {
      if (c=='%')
        {
          if (l<0) //если число менее нуля
            { //перевод отрицательного числа в положительный код
              _video = '-';
              minus_flag = l >> 31;
              y = minus_flag ^ l;
              y -= minus_flag;
              l=y;
            }
          while (div!=1)
            {
              //cel = l / div;
              //ost = l % div;

              //division(l,div,&cel,&ost);
              cel = 0;
              while (l >= 0)
                {
                  l-=div;
                  cel++;
                }
                cel--;
                l+=div;
                ost = l;
              ////////////////////////////////////
              if (cel!=0)
                {
                  symbol = (char)cel;
                  _video = symbol+0x30;
                  first = 0;
                }
              else
                {
                  if (first!=1)
                    {
                      symbol = (char)cel;
                      _video = symbol+0x30;
                    }
                }
              l = ost;
              if (div==10)
                {
                  div = 1;
                  symbol = (char)ost;
                  _video = symbol+0x30;
                }
              else
                {
                  //div = div/10;
                  switch (div) {
                    case 1000000:
                      div = 100000;
                      break;
                    case 100000:
                      div = 10000;
                      break;
                    case 10000:
                      div = 1000;
                      break;
                    case 1000:
                      div = 100;
                      break;
                    case 100:
                      div = 10;
                      break;
                    }
                  //division(div,10,&cel,&ost); div = cel;

                }
            }
         c=*(++message);
         c=*(++message);
        }
      _video = c;
      c=*(++message);
    }
}


