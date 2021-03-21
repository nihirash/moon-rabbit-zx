    device	zxspectrum128

    org 24576
tapBegin:
    jp start
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
    ld sp, tapBegin
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

    savebin "moon.bin", tapBegin, $ - tapBegin