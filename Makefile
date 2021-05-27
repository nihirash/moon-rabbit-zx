SOURCES=$(shell find . -type f -iname  "*.asm") $(shell find . -type f -iname  "*.gph")
BINARY=moon.bin
LST=main.lst
all: 
	@echo "For making MB03 version call: 'make mb03'"
	@echo "For making ZXUno(esxDOS) version call: 'make zxuno'"
	@echo "For making ZXUno(esxDOS, usual screen) version call: 'make zxuno-zxscreen'"
	@echo ""
	@echo "Before changing version call: 'make clean' for removing builded images"

	
mb03: $(SOURCES)
	sjasmplus main.asm -DPROXY -DMB03 -DTIMEX -DGS --lst=main.lst
	
zxuno: $(SOURCES)
	sjasmplus main.asm -DUNO -DTIMEX --lst=main.lst

zxuno-zxscreen: $(SOURCES)
	sjasmplus main.asm -DUNO -DZXSCR --lst=main.lst

esxdos-ay: $(SOURCES)
	sjasmplus main.asm -DAY -DZXSCR --lst=main.lst
	
clean:
	rm $(BINARY) $(LST)