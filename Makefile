SOURCES=$(shell find . -type f -iname  "*.asm") $(shell find . -type f -iname  "*.gph")
BINARY=moon.bin
VERSION=$(shell cat version.def)

LST=main.lst
all: 
	@echo "For making MB03 version call: 'make mb03'"
	@echo "For making ZXUno(esxDOS) version call: 'make zxuno'"
	@echo "For making ZXUno(esxDOS, usual screen) version call: 'make zxuno-zxscreen'"
	@echo "For making Ay-Wifi(esxDOS) version call: make esxdos-ay"
	@echo ""
	@echo "Before changing version call: 'make clean' for removing builded images"

	
mb03: $(SOURCES)
	sjasmplus main.asm -DPROXY -DMB03 -DTIMEX -DGS --lst=main.lst -DV=$(VERSION)
	
zxuno: $(SOURCES)
	sjasmplus main.asm -DUNO -DTIMEX --lst=main.lst -DV=$(VERSION)

zxuno-zxscreen: $(SOURCES)
	sjasmplus main.asm -DUNO -DZXSCR --lst=main.lst -DV=$(VERSION)

esxdos-ay: $(SOURCES)
	sjasmplus main.asm -DAY -DZXSCR --lst=main.lst -DV=$(VERSION)
	
clean:
	rm $(BINARY) $(LST)