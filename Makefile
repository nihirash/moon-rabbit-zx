SOURCES=$(shell find . -type f -iname  "*.asm")
BINARY=moon.bin
LST=main.lst
all: 
	@echo "For making MB03 version call: 'make mb03'"
	@echo "For making ZXUno version call: 'make zxuno'"
	@echo ""
	@echo "Before changing version call: 'make clean' for removing builded images"

	
mb03: $(SOURCES)
	sjasmplus main.asm -DPROXY -DMB03 -DTIMEX -DGS --lst=main.lst
	
zxuno: $(SOURCES)
	sjasmplus main.asm -DUNO -DTIMEX --lst=main.lst
	
clean:
	rm $(BINARY) $(LST)