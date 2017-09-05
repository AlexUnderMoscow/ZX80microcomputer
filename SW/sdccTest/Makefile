LINK_TARGET = screenout.ihx
CXX = sdcc
CODE = 0x0000
RAM = 0x6000
DATA = 0x1000
#0x0D58
STACK = 0x7000
CXXFLAGS = -mz80 --float-reent --no-std-crt0 --vc --code-loc $(CODE) --data-loc $(DATA) --xram-loc $(RAM)
#16384

SRC = screenout.c lib.c

all : $(LINK_TARGET)
	echo All done

hardware:
	config.exe -b -2 screenout.bin

clean :
	rm -f $(LINK_TARGET)
	rm -f main.hex
	rm -f *.sg
	rm -f *.sms
	rm -f *.ihx
	rm -f *.noi
	rm -f *.lk
	rm -f *.rel
	rm -f *.sym
	rm -f *.map
	rm -f *.lst
	rm -f *.hex
	rm -f *.bin
	echo clean done

$(LINK_TARGET):
	$(CXX) -c -mz80 lib.c
	$(CXX) -c -mz80 screenout.c
	$(CXX) $(CXXFLAGS) screenout.rel lib.rel
#	lib.rel
	hex2bin $(LINK_TARGET)
	mv $(LINK_TARGET) screenout.hex
