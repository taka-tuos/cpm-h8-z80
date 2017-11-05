CPM = 62
BADR = $$(( ($(CPM)-20)*1024 + 0x4A00 ))
EADR = $$(( 0x10000 ))
CADR = $$(( ($(CPM)-20)*1024 ))
TARGET = bios
OBJS_TARGET = bios.o
AFLAGS = --defsym msize=$(CPM)
LFLAGS = -Tflat.x

include Makefile.in
