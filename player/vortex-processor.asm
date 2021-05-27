    MODULE VortexProcessor
play:
    call Console.waitForKeyUp

    ld hl, message : call DialogBox.msgNoWait

    ld hl, outputBuffer  : call VTPL.INIT

    
    ld a, 1, (Render.play_next), a
    ifdef GS
    call GeneralSound.stopModule
    endif
.loop
    halt : di : call VTPL.PLAY : ei
    xor a : in a, (#fe) : cpl : and 31 : jp nz, .stopKey
    ld a, (VTPL.SETUP) : rla : jr nc, .loop 
    ld a, 1, (Render.play_next), a
.stop
    call VTPL.MUTE
    
    IFDEF AY
    call restoreAyState
    ENDIF

    call Console.waitForKeyUp
    ret
.stopKey
    xor a : ld (Render.play_next), a
    jr .stop

    IFDEF AY
restoreAyState:
    ld a, #07
    ld bc, #fffd
    out (c), a
    ld a, #fc
    ld b, #bf
    out (c), a ; Enable read mode
    
    ld a, #0e
    ld bc, #fffd
    out (c), a
    ret
    ENDIF 

message db "Press key to stop...", 0
    ENDMODULE
    include "player.asm"
    