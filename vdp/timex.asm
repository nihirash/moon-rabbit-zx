COLOR=0
    module TextMode
PORT_SELECT = #7c3b
init:
    ld hl, font_file, b, Dos.FMODE_READ
    call Dos.fopen
    push af
    ld bc, 2048, hl, font
    call Dos.fread
    pop af
    call Dos.fclose
cls:
    ld a, 7 : call Memory.setPage

    ld a, #3E : out (#ff), a

    di
    ld	hl,0, d,h, e,h, b,h, c,b
    add	hl,sp
    ld	sp,#c000 + 6144
.loop
    dup 12
	push	de
    edup

    djnz	.loop

    ld	b,c
    ld	sp,#e000 + 6144
.loop2:
    dup 12
	push	de
    edup

    djnz .loop2
    ld	sp,hl
    ld hl ,0 : ld (coords), hl 
    xor a : call Memory.setPage
    
    ei
    ret

; A - line
usualLine:
   ld d, a
   jr fill 
; A - line
highlightLine:
    ld d, a
fill:
    ld e, 0, b, 64
.lloop
	push bc
	push de
	call findAddr
    ld a, 7 : call Memory.setPage
	
	ld b, 8
.cloop	
	ld a, (de) : xor #ff : ld (de), a
	inc d
	djnz .cloop
	pop de
	inc e
	pop bc
	djnz .lloop

    xor a : call Memory.setPage
    ret

printZ:
    ld a, (hl) : and a : ret z
    push hl
    call putC
    pop hl
    inc hl
    jr printZ


; A - char
putC:
	cp 13
	jp z, .cr

    ld b, a
    
    ld de, (coords)
    ld a, e
    cp 64
    ret nc

	push bc

    ld a, 7
    call Memory.setPage

	call findAddr
	pop af
	ld l, a
	ld h, 0
	add hl, hl
	add hl, hl
	add hl, hl
	ld bc, font
	add hl, bc
	ld b, 8
.loop
	ld a, (HL)
	ld (DE), A
	inc hl
	inc d
	djnz .loop
	ld hl, (coords)
	inc l
	ld (coords), hl

    xor a : call Memory.setPage
	ret
.cr
	ld hl, (coords)
	inc h
	ld l, 0, (coords), hl
	cp 24
	ret c
	ld hl, 0, (coords), hl
    xor a : call Memory.setPage
	ret	

; H - line 
; A - char
fillLine:
    ld d, h, e, 0 : call gotoXY
    ld b, 64
.loop
    push af, bc
    call putC
    pop bc, af
    djnz .loop
    ret


gotoXY:
    ld (coords), de
    ret

; D - Y
; E - X
; OUT: de - coords
findAddr:
    ld a, e
    srl a
    ld e, a, hl, #A000
    jr c, fa1
    ld hl, #8000
fa1:		   
    LD A,D
    AND 7
    RRCA
    RRCA
    RRCA
    OR E
    LD E,A
    LD A,D
    AND 24
    OR 64
    LD D,A
    ADD hl, de
    ex hl, de
    ret

disable:
    xor a : out (#fe), a : out (#ff), a
    ret

coords dw 0
font equ #4000 ; Using ZX-Spectrum screen as font buffer
font_file db "data/font.bin", 0
    endmodule

exit:
    ld bc, TextMode.PORT_SELECT, a, 1           
    out (c), a
    inc b : xor a
    out (c), a
    rst 0