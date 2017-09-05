#ifndef LIB_H
#define LIB_H

__sfr __at 0x90 _video;
__sfr __at 0x91 _xpos;
__sfr __at 0x92 _ypos;
__sfr __at 0x01 _leds;
__sfr __at 0x80 _kbrd;



void print(char* message);
void printl (char* message, long l);
void prints (char* message, short l);
void pos(unsigned char x, unsigned char y);
void printfl(char* message, float f);
void putch(unsigned char ch);
unsigned char getch();
void stop();
void printLCD(char* str);

#endif // LIB_H

