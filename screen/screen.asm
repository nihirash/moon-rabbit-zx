    module ScreenViewer
display:
    call Console.waitForKeyUp
    ld a, 7 : call Memory.setPage
    ld hl, outputBuffer, de, #c000, bc, 6912 : ldir
    xor a : out (#fe), a : out (#ff), a
.wait
    xor a : in a, (#fe) : cpl : and 31 : jr z, .wait
    call TextMode.cls
    jp History.back

    endmodule