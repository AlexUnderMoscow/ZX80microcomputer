;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 3.5.0 #9253 (Jun 20 2015) (MINGW64)
; This file was generated Fri Sep 02 15:07:15 2016
;--------------------------------------------------------
	.module screenout
	.optsdcc -mz80
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _main
	.globl _boot
	.globl _printLCD
	.globl _stop
	.globl _getch
	.globl _putch
	.globl _printfl
	.globl _pos
	.globl _prints
	.globl _printl
	.globl _print
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
__video	=	0x0090
__xpos	=	0x0091
__ypos	=	0x0092
__leds	=	0x0001
__kbrd	=	0x0080
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _DATA
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _INITIALIZED
;--------------------------------------------------------
; absolute external ram data
;--------------------------------------------------------
	.area _DABS (ABS)
;--------------------------------------------------------
; global & static initialisations
;--------------------------------------------------------
	.area _HOME
	.area _GSINIT
	.area _GSFINAL
	.area _GSINIT
;--------------------------------------------------------
; Home
;--------------------------------------------------------
	.area _HOME
	.area _HOME
;--------------------------------------------------------
; code
;--------------------------------------------------------
	.area _CODE
;screenout.c:7: void boot()
;	---------------------------------
; Function boot
; ---------------------------------
_boot::
;screenout.c:13: __endasm;
	ld sp, #0x8000
	ld ix, #0x7000
	call _main
	ret
;screenout.c:15: int main()
;	---------------------------------
; Function main
; ---------------------------------
_main::
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl,#-17
	add	hl,sp
	ld	sp,hl
;screenout.c:27: printLCD(" Hello world! ");
	ld	hl,#___str_0
	push	hl
	call	_printLCD
;screenout.c:28: pos(5,2);
	ld	hl, #0x0205
	ex	(sp),hl
	call	_pos
;screenout.c:29: print("Hello world!");
	ld	hl, #___str_1
	ex	(sp),hl
	call	_print
;screenout.c:30: pos(5,5);
	ld	hl, #0x0505
	ex	(sp),hl
	call	_pos
;screenout.c:31: print("Z80 handmade computer.");
	ld	hl, #___str_2
	ex	(sp),hl
	call	_print
;screenout.c:32: print(" Memory test.");
	ld	hl, #___str_3
	ex	(sp),hl
	call	_print
	pop	af
;screenout.c:37: for (ind=0;ind<256;ind++)
	xor	a, a
	ld	-9 (ix),a
	ld	-8 (ix),a
	ld	-7 (ix),a
	ld	-6 (ix),a
00114$:
;screenout.c:40: point = (char*)(ind+0x6000);
	ld	a,-9 (ix)
	add	a, #0x00
	ld	c,a
	ld	a,-8 (ix)
	adc	a, #0x60
	ld	b,a
	ld	a,-7 (ix)
	adc	a, #0x00
	ld	e,a
	ld	a,-6 (ix)
	adc	a, #0x00
	ld	d,a
	ld	l, c
	ld	h, b
;screenout.c:41: *point=0xFF;
	ld	(hl),#0xFF
;screenout.c:45: cool=0;
	ld	-17 (ix),#0x00
	ld	-16 (ix),#0x00
;screenout.c:47: *point = 0x00;
	ld	(hl),#0x00
;screenout.c:48: c= *point;
	ld	a,(hl)
;screenout.c:49: if (c!=0x00)
	ld	-1 (ix), a
	or	a, a
	jr	Z,00104$
;screenout.c:51: cool=0;
	ld	hl,#0x0000
	ex	(sp), hl
00104$:
;screenout.c:53: pos(5,10);
	push	bc
	push	de
	ld	hl,#0x0A05
	push	hl
	call	_pos
	pop	af
	pop	de
	pop	bc
;screenout.c:54: printl("byte #: %d ",ind+0x6000);
	push	de
	push	bc
	ld	hl,#___str_4
	push	hl
	call	_printl
	ld	hl,#6
	add	hl,sp
	ld	sp,hl
;screenout.c:37: for (ind=0;ind<256;ind++)
	inc	-9 (ix)
	jr	NZ,00177$
	inc	-8 (ix)
	jr	NZ,00177$
	inc	-7 (ix)
	jr	NZ,00177$
	inc	-6 (ix)
00177$:
	ld	a,-8 (ix)
	sub	a, #0x01
	ld	a,-7 (ix)
	sbc	a, #0x00
	ld	a,-6 (ix)
	rla
	ccf
	rra
	sbc	a, #0x80
	jr	C,00114$
;screenout.c:57: if (cool==0)
	ld	a,-16 (ix)
	or	a,-17 (ix)
	jr	NZ,00131$
;screenout.c:59: print(" Ok");
	ld	hl,#___str_5
	push	hl
	call	_print
	pop	af
;screenout.c:61: for (ind = 0; ind < 256; ind++)
00131$:
	ld	bc,#0x0000
	ld	de,#0x0000
00119$:
;screenout.c:63: for (j=0; j<20;j++)
	ld	-13 (ix),#0x14
	xor	a, a
	ld	-12 (ix),a
	ld	-11 (ix),a
	ld	-10 (ix),a
00118$:
;screenout.c:65: c++;
	ld	a,-1 (ix)
	inc	a
;screenout.c:66: c--;
	add	a,#0xFF
	ld	-1 (ix),a
	ld	a,-13 (ix)
	add	a,#0xFF
	ld	-5 (ix),a
	ld	a,-12 (ix)
	adc	a,#0xFF
	ld	-4 (ix),a
	ld	a,-11 (ix)
	adc	a,#0xFF
	ld	-3 (ix),a
	ld	a,-10 (ix)
	adc	a,#0xFF
	ld	-2 (ix),a
	ld	a,-5 (ix)
	ld	-13 (ix),a
	ld	a,-4 (ix)
	ld	-12 (ix),a
	ld	a,-3 (ix)
	ld	-11 (ix),a
	ld	a,-2 (ix)
	ld	-10 (ix),a
;screenout.c:63: for (j=0; j<20;j++)
	ld	a,-2 (ix)
	or	a, -3 (ix)
	or	a, -4 (ix)
	or	a,-5 (ix)
	jr	NZ,00118$
;screenout.c:68: c++;
	inc	-1 (ix)
;screenout.c:69: _leds = c;
	ld	a,-1 (ix)
	out	(__leds),a
;screenout.c:70: pos(40,10);
	push	bc
	push	de
	ld	hl,#0x0A28
	push	hl
	call	_pos
	pop	af
	pop	de
	pop	bc
;screenout.c:71: prints("LED TEST. STEP = %d ",ind);
	ld	l, c
	ld	h, b
	push	bc
	push	de
	push	hl
	ld	hl,#___str_6
	push	hl
	call	_prints
	pop	af
	pop	af
	pop	de
	pop	bc
;screenout.c:61: for (ind = 0; ind < 256; ind++)
	inc	c
	jr	NZ,00178$
	inc	b
	jr	NZ,00178$
	inc	e
	jr	NZ,00178$
	inc	d
00178$:
	ld	a,b
	sub	a, #0x01
	ld	a,e
	sbc	a, #0x00
	ld	a,d
	rla
	ccf
	rra
	sbc	a, #0x80
	jp	C,00119$
;screenout.c:73: pos (5,15);
	ld	hl,#0x0F05
	push	hl
	call	_pos
	pop	af
;screenout.c:75: printl("LONG type print test: %d OK",ind);
	ld	de,#___str_7+0
	ld	hl,#0xFFDF
	push	hl
	ld	hl,#0x585A
	push	hl
	push	de
	call	_printl
	ld	hl,#6
	add	hl,sp
	ld	sp,hl
;screenout.c:77: pos (5,16);
	ld	hl,#0x1005
	push	hl
	call	_pos
	pop	af
;screenout.c:78: prints("SHORT type print test = %d OK",my);
	ld	hl,#___str_8+0
	ld	bc,#0xECF0
	push	bc
	push	hl
	call	_prints
	pop	af
;screenout.c:79: pos (5,17);
	ld	hl, #0x1105
	ex	(sp),hl
	call	_pos
	pop	af
;screenout.c:81: printfl("FLOAT type print test = %f OK",fl);
	ld	de,#___str_9+0
	ld	hl,#0xC0E8
	push	hl
	ld	hl,#0x134D
	push	hl
	push	de
	call	_printfl
	ld	hl,#6
	add	hl,sp
	ld	sp,hl
;screenout.c:82: pos (5,18);
	ld	hl,#0x1205
	push	hl
	call	_pos
;screenout.c:84: print("Are you sure? (Y/N):");
	ld	hl, #___str_10+0
	ex	(sp),hl
	call	_print
	pop	af
;screenout.c:85: key = getch();
	call	_getch
	ld	h,l
;screenout.c:86: putch(key);
	push	hl
	inc	sp
	call	_putch
	inc	sp
;screenout.c:88: pos (5,19);
	ld	hl,#0x1305
	push	hl
	call	_pos
;screenout.c:89: print("LOOP test:");
	ld	hl, #___str_11+0
	ex	(sp),hl
	call	_print
	pop	af
;screenout.c:90: for (my=0; my<15;my++)
	ld	de,#0x0000
00121$:
;screenout.c:92: pos(5,21+my);
	ld	a,e
	add	a, #0x15
	push	de
	ld	d,a
	ld	e,#0x05
	push	de
	call	_pos
	pop	af
	pop	de
;screenout.c:93: prints("STEP %d ",my);
	ld	hl,#___str_12
	push	de
	push	de
	push	hl
	call	_prints
	pop	af
	pop	af
	pop	de
;screenout.c:90: for (my=0; my<15;my++)
	inc	de
	ld	a,e
	sub	a, #0x0F
	ld	a,d
	rla
	ccf
	rra
	sbc	a, #0x80
	jr	C,00121$
;screenout.c:95: pos (25,19);
	ld	hl,#0x1319
	push	hl
	call	_pos
;screenout.c:96: print("Float test:");
	ld	hl, #___str_13+0
	ex	(sp),hl
	call	_print
	pop	af
;screenout.c:97: fl=-15.24;
	ld	bc,#0xD70A
	ld	de,#0xC173
;screenout.c:99: while (fl<5.5)
	ld	-15 (ix),#0x00
	ld	-14 (ix),#0x00
00111$:
	push	bc
	push	de
	ld	hl,#0x40B0
	push	hl
	ld	hl,#0x0000
	push	hl
	push	de
	push	bc
	call	___fslt
	pop	af
	pop	af
	pop	af
	pop	af
	ld	a,l
	pop	de
	pop	bc
	or	a, a
	jr	Z,00113$
;screenout.c:101: pos(25,21+my);
	ld	a,-15 (ix)
	add	a, #0x15
	push	bc
	push	de
	ld	d,a
	ld	e,#0x19
	push	de
	call	_pos
	pop	af
	pop	de
	pop	bc
;screenout.c:102: printfl("%f ",fl);
	push	bc
	push	de
	push	de
	push	bc
	ld	hl,#___str_14
	push	hl
	call	_printfl
	ld	hl,#6
	add	hl,sp
	ld	sp,hl
	pop	de
	pop	bc
;screenout.c:103: fl=fl+1.8690435;
	ld	hl,#0x3FEF
	push	hl
	ld	hl,#0x3CD1
	push	hl
	push	de
	push	bc
	call	___fsadd
	pop	af
	pop	af
	pop	af
	pop	af
	ld	c,l
	ld	b,h
;screenout.c:104: my++;
	inc	-15 (ix)
	jr	NZ,00111$
	inc	-14 (ix)
	jr	00111$
00113$:
;screenout.c:106: stop();
	call	_stop
;screenout.c:107: return 0;
	ld	hl,#0x0000
	ld	sp, ix
	pop	ix
	ret
___str_0:
	.ascii " Hello world! "
	.db 0x00
___str_1:
	.ascii "Hello world!"
	.db 0x00
___str_2:
	.ascii "Z80 handmade computer."
	.db 0x00
___str_3:
	.ascii " Memory test."
	.db 0x00
___str_4:
	.ascii "byte #: %d "
	.db 0x00
___str_5:
	.ascii " Ok"
	.db 0x00
___str_6:
	.ascii "LED TEST. STEP = %d "
	.db 0x00
___str_7:
	.ascii "LONG type print test: %d OK"
	.db 0x00
___str_8:
	.ascii "SHORT type print test = %d OK"
	.db 0x00
___str_9:
	.ascii "FLOAT type print test = %f OK"
	.db 0x00
___str_10:
	.ascii "Are you sure? (Y/N):"
	.db 0x00
___str_11:
	.ascii "LOOP test:"
	.db 0x00
___str_12:
	.ascii "STEP %d "
	.db 0x00
___str_13:
	.ascii "Float test:"
	.db 0x00
___str_14:
	.ascii "%f "
	.db 0x00
	.area _CODE
	.area _INITIALIZER
	.area _CABS (ABS)
