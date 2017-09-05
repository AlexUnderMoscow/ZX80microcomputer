LINK_TARGET = config.exe
CXX = g++ -g
CXXFLAGS = -std=c++11 -I C:/WpdPack/Include
LIBS += -L C:/WpdPack/Lib -lwpcap -lpacket -lwsock32
# -g -gdwarf
AS = nasm
ASFLAGS = -f win32 -g
#-f win32 -F dwarf -g
#-f win32
#coff

OBJS =  \
	main.o

REBUILDABLES = $(OBJS) $(LINK_TARGET)

clean :
	rm -f *.exe
	rm -f *.o
	echo clean done

all : $(LINK_TARGET)
	echo All done

$(LINK_TARGET) : $(OBJS)
	$(CXX) $(CXXFLAGS) -o $@ $^ $(LIBS)

%.o : %.c
	$(CXX) $(CXXFLAGS) -o $@ -c $< $(LIBS)

#hello.o : hello.asm
#	$(AS) $(ASFLAGS) -o hello.o hello.asm

#-strip-local-absolute -traditional-format -march=i386
