COLOR=0
    define LINE_LIMIT 80
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
    
    IFDEF UNO
    ;; Force turbo mode
    ld bc, 64571 : ld a, #0b : out (c), a
    ld bc, 64827 : in a, (c) : or #c0 : out (c),a
    ENDIF
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
    ld (drawC.char_tmp), a

	cp 13
	jp z, .cr
    
    ld de, (coords)
    ld a, e
    cp 85
    ret nc


    ld a, 7
    call Memory.setPage
    push iy
    call drawC
    pop iy

    ld hl, coords
    inc (hl)

    jr .exit
.cr
	ld hl, (coords)
	inc h
	ld l, 0, (coords), hl
	cp 24
	ret c
	ld hl, 0, (coords), hl
.exit
    xor a : call Memory.setPage
	ret	

drawC:
    ld hl, (coords)
    ld b, l
    call .calc
    ld d, h
    ld e, l
    ld (.rot_tmp), a
    call findAddr
    push de
    call .get_char

    pop hl
.print0
    ld ix, hl
    ld a, h 
    bit 5, a 
    jr z, .ok
    inc l
.ok
    xor #20 : ld h, a
    ld iy, hl
    ld a, (.rot_tmp)
    call .rotate_mask
    ld a, (.rot_tmp)
    jp basic_draw
.calc
      ld l,0
      ld a, b : and a : ret z
      ld ix, 0
      ld de,6
1     add ix, de
      djnz 1b
      ld de, -8
2     ld a, ixh
      and a 
      jr nz, 3f
      ld a, ixl
      cp 8
      ret c
3     
      add ix, de
      inc l
      jr 2b
      ret

.rotate_mask
    ld hl, #03ff
    and a : ret z
.rot_loop
    ex af, af
    ld a,l
    rrca
    rr h
    rr l
    ex af, af
    dec a
    jr nz, .rot_loop
    ret
.get_char:
    ld a, (.char_tmp)
    ld l, a
    ld h, 0
    add hl, hl
    add hl, hl
    add hl, hl
    ld bc, font
    add hl, bc
    ex hl, de
    ret
.char_tmp db 0
.rot_tmp  db 0
; A - rotation counter
; DE - font PTR
; HL - mask
; IX - left half on screen 
; IY - right half on screen
basic_draw:
    ld (.rot_cnt),a

    ld a, l
    ld (.mask1), a
    ld a, h
    ld (.mask2), a
    ld b, 8
.printIt
    ld a, (de)
    ld h, a
    ld l, 0
    ld a, 0
.rot_cnt = $ - 1
    and a : jr z, .skiprot
.rot
    ex af, af
    ld a,l
    rrca
    rr h
    rr l
    ex af, af
    dec a
    jr nz, .rot
.skiprot
    ld a, (iy)
    and #0f
.mask1 = $ - 1
    or l
    ld (iy), a
    ld a, (ix)
    and #fc
.mask2 = $ -1
    or h
    ld (ix), a
    inc ixh
    inc iyh
    inc de
    djnz .printIt
    ret


; H - line 
; A - char
fillLine:
    ld d, h, e, 0 : call gotoXY
    ld b, 85
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
    ld e,a
    ld b, #E0
    jr c, .proc
    ld b, #C0
.proc
    LD A,D
    AND 7
    RRCA
    RRCA
    RRCA
    OR E
    LD E,A
    LD A,D
    AND 24
    OR b
    LD D,A
    ret


disable:
    xor a : out (#fe), a : out (#ff), a
    ret

coords dw 0
font equ #4000 ; Using ZX-Spectrum screen as font buffer
font_file db "data/font80.bin", 0
    endmodule

exit:
    ld bc, TextMode.PORT_SELECT, a, 1           
    out (c), a
    inc b : xor a
    out (c), a
    rst 0