CPM = 62
BADR = $$(( ($(CPM)-20)*1024 + 0x3400 ))
EADR = $$(( ($(CPM)-20)*1024 + 0x49FF ))
TARGET = cpm22
OBJS_TARGET = cpm22.o
AFLAGS = --defsym MEM=$(CPM)
LFLAGS = -Tflat.x

include Makefile.in
