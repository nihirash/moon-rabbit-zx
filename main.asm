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
    di
    ld sp, asmOrg
    ei
    call TextMode.init
    ld hl, initing : call TextMode.printZ
    call Wifi.init
    call History.home
    jr $

outputBuffer:
initing db "Initing Wifi...",13,0

    display "ENDS: ", $
    display "Buff size", #ffff - $

    savebin "moon.bin", asmOrg, $ - asmOrg