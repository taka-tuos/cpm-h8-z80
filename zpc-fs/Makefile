MAKE	= make
DD		= dd
MKFS	= mkfs.cpm
CPMCP	= cpmcp
CPMLS	= cpmls
CP		= cp
RM		= rm
H2BIN	= h2bin/h2bin


default : Makefile
	$(MAKE) -r diskimage

diskimage : Makefile
	$(MAKE) -C h2bin clean
	$(MAKE) -C ../zpc-ipl clean
	$(MAKE) -C ../zpc-bios clean
	$(MAKE) -C ../zpc-cpm clean
	$(MAKE) -C ../zpc-rom clean
	$(MAKE) -C h2bin
	$(MAKE) -C ../zpc-ipl
	$(MAKE) -C ../zpc-bios
	$(MAKE) -C ../zpc-cpm
	$(MAKE) -C ../zpc-rom
	$(DD) conv=sync bs=128  count=1 if=../zpc-ipl/ipl.bin > cpm.bin
	$(DD) conv=sync bs=128 count=44 if=../zpc-cpm/cpm22.bin >> cpm.bin
	$(DD) conv=sync bs=128  count=10 if=../zpc-bios/bios.bin >> cpm.bin
	$(MKFS) -f cpm_a -b cpm.bin -L zpc-cpm diskimage
	$(CPMCP) -f cpm_a diskimage ./files/*.* 0:
	$(CPMLS) -f cpm_a diskimage
	$(CP) ../zpc-rom/eeprom.bin .
	$(H2BIN) eeprom.bin eeprom > eeprom.h

all-clean : Makefile
	$(MAKE) -r clean
	$(MAKE) -C h2bin clean 
	$(MAKE) -C ../zpc-ipl clean
	$(MAKE) -C ../zpc-bios clean
	$(MAKE) -C ../zpc-cpm clean
	$(MAKE) -C ../zpc-rom clean
	
clean : Makefile
	-$(RM) diskimage
	-$(RM) cpm.bin
	-$(RM) eeprom.bin
	-$(RM) eeprom.h


