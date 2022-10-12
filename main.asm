    device	zxspectrum128
    org 24576
asmOrg:
    jp start
    
; Generate version string
    LUA ALLPASS
    v = tostring(sj.get_define("V"))
    maj = string.sub(v, 1,1)
    min = string.sub(v, 2,2)
    sj.insert_define("VERSION_STRING", "\"" .. maj .. "." .. min .. "\"")
    ENDLUA

    include "vdp/index.asm"
    include "utils/index.asm"
    include "gopher/render/index.asm"
    include "dos/index.asm"
    include "gopher/engine/history/index.asm"
    include "gopher/engine/urlencoder.asm"
    include "gopher/engine/fetcher.asm"
    include "gopher/engine/media-processor.asm"
    include "gopher/gopher.asm"
    include "player/vortex-processor.asm"
    include "screen/screen.asm"
    include "drivers/index.asm"
start:
outputBuffer:
    di
    xor a : ld (#5c6a), a  ; Thank you, Mario Prato, for feedback
    ld (#5c00),a
    ld sp, asmOrg
    call Memory.init
    xor a : out (#fe),a
    ei
    
    ld a, 7 : call Memory.setPage
    ;; Logo
    ld hl, logo, b, Dos.FMODE_READ : call Dos.fopen
    push af
    ld hl, #c000, bc, 6912 : call Dos.fread
    pop af
    call Dos.fclose

    ld b, 150 
1   halt 
    djnz 1b
    ;; End of logo :-)
    
    call TextMode.init

    ld hl, initing : call TextMode.printZ
    IFNDEF EMU
    call Wifi.init
    ENDIF

    jp History.home

initing db "Initing Wifi...",13,0
logo    db  "data/logo.scr", 0
    display "ENDS: ", $
    display "Buff size", #ffff - $

    save3dos "moon.bin", asmOrg, $ - asmOrg
   ; savebin "moon.bin", asmOrg, $ - asmOrg