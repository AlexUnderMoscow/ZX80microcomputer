;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 3.5.0 #9253 (Jun 20 2015) (MINGW64)
; This file was generated Fri Nov 13 14:28:06 2015
;--------------------------------------------------------
	.module hello_led_lcd
	.optsdcc -mz80
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _main
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
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
;hello-led-lcd.c:2: int main()
;	---------------------------------
; Function main
; ---------------------------------
_main::
;hello-led-lcd.c:69: __endasm;
;
	ld sp,#fefah
	ld a,#0x55
	out (#01),a
	ld A,#0
	OUT (#0x91),A
	ld a,#0
	out(#0x92),a ;
	ld hl,#hello
	call printmsg
	ld a,#0x20
	out (#0x90),a
	ld a,#0
	out (#0x91),a
	ld a,#2
	out (#0x92),a
	ld hl,#Text1
	call printmsg
	ld IY,#0xFFE0
	ld hl,#Text2
	call prinLCD
	halt
	prinLCD$:
	ploop1$:
	ld a,(hl)
	or a
	ret z
	ld (IY),a
	inc hl
	inc IY
	jr ploop1$
	ret
	printmsg$:
	ploop$:
	ld a,(hl)
	or a
	ret z
	out (#0x90),a
	inc hl
	jr ploop
	ret
	hello$:
	.ascii "HELLO WORLD"
	.db 0
	Text1:
	.ascii "Handmade "
	.ascii " computer "
	.ascii " based on "
	.ascii " Zilog Z80"
	.db 0
	Text2:
	.ascii "Zilog Z80 "
	.ascii "      computer"
	.ascii "      "
	.db 0
;hello-led-lcd.c:70: return 0;
	ld	hl,#0x0000
	ret
	.area _CODE
	.area _INITIALIZER
	.area _CABS (ABS)
