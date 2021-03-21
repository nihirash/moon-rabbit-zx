    MODULE Dos
; API methods
ESX_GETSETDRV = #89
ESX_FOPEN = #9A
ESX_FCLOSE = #9B
ESX_FSYNC = #9C
ESX_FREAD = #9D
ESX_FWRITE = #9E

; File modes
FMODE_READ = #01
FMODE_WRITE = #06
FMODE_CREATE = #0E

    MACRO esxCall func
    rst #8 : db func
    ENDM

; HL - filename in ASCIIZ
loadBuffer:
    ld b, Dos.FMODE_READ: call Dos.fopen
    push af
        ld hl, outputBuffer, bc, #ffff - outputBuffer : call Dos.fread
        ld hl, outputBuffer : add hl, bc : xor a : ld (hl), a : inc hl : ld (hl), a
    pop af
    call Dos.fclose
    ret

; Returns: 
;  A - current drive
getDefaultDrive:
    ld a, 0 : esxCall ESX_GETSETDRV
    ret

; Opens file on default drive
; B - File mode
; HL - File name
; Returns:
;  A - file stream id
fopen:
    push bc : push hl 
    call getDefaultDrive
    pop ix : pop bc
    esxCall ESX_FOPEN
    ret

; A - file stream id
fclose:
    esxCall ESX_FCLOSE
    ret

; A - file stream id
; BC - length
; HL - buffer
; Returns
;  BC - length(how much was actually read) 
fread:
    push hl : pop ix
    esxCall ESX_FREAD
    ret

; A - file stream id
; BC - length
; HL - buffer
; Returns:
;   BC - actually written bytes
fwrite:
    push hl : pop ix
    esxCall ESX_FWRITE
    ret
    
; A - file stream id
fsync:
    esxCall ESX_FSYNC
    ret

    ENDMODULE