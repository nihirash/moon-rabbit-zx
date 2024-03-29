COLOR=1
;; Usual speccy screen driver
    module TextMode
init:
    ld hl, font_file, b, Dos.FMODE_READ
    call Dos.fopen
    push af
    ld bc, 2048, hl, font64
    call Dos.fread
    pop af
    call Dos.fclose
	xor a : out (#fe), a
	ret
cls:
    ld de, 0 : call gotoXY
    ld a, 7 : call Memory.setPage
    xor a : out (#fe), a
    ld hl, #c000, de, #c001, bc, 6911, (hl), a : ldir
    jp Memory.setPage
    

; Set console coordinates
; d = row(0..23), e = column (0..63)
gotoXY:
	rr e
	ld a, 0
	ld (half_tile_screen), a
    ld (col_screen), de
    ret    

disable:
    ; Nothing to disable
    ret

; H - line 
; A - char
fillLine:
    push af
    ld d, h, e, 0 : call gotoXY
    pop af
    ld hl, fill_buff, de, fill_buff + 1, bc, 63, (hl), a : ldir
    ld hl, fill_buff : jp printZ

usualLine:
    ld b, a
    ld c, 0
    call bc_to_attr
    ld a, 7 : call Memory.setPage
    ld (hl), #7
    ld de, hl
    inc de
    ld bc, 31
    ldir
    xor a : call Memory.setPage
    ret

highlightLine:
    ld b, a
    ld c, 0
    call bc_to_attr
    ld a, 7 : call Memory.setPage
    ld (hl), #C
    ld de, hl
    inc de
    ld bc, 31
    ldir
    xor a : call Memory.setPage
    ret

mvCR 
	ld de, (col_screen)
	inc d
	ld e, 0
	ld a, 0 
	ld (half_tile_screen), a
	jp gotoXY
	
; Print just one symbol
; A - symbol
putC
    cp 13 : jp z, mvCR

	ld hl, single_symbol
	ld (hl), a
	ld a, 7 : call Memory.setPage
    ld hl, single_symbol_print
    call printL
    xor a : jp Memory.setPage

; Put string
; hl - string pointer that's begins from symbol count
printZ
    ld a, (hl) : and a : ret z
    push hl
    call putC
    pop hl
    inc hl
    jr printZ
    
printL	
        ld	a, (hl)
		and	a
		ret	z

		push	hl
		call	calc_addr_attr
		ld	a,(attr_screen)
		ld	(hl),a
		pop	hl

		call	calc_addr_scr

		ld	a,(half_tile_screen)
		bit	0,a
		ld	a,(hl)
		jp	nz,print64_4
print64_3 
        push    af
		push	hl
		call	calc_addr_attr
		ld	a,(attr_screen)
		ld	(hl),a
		pop	hl
        
        inc     hl
        push    hl
        
        ld      a,(hl)
		ld	l,a
		ld	h,0
		add	hl,hl
		add	hl,hl
		add	hl,hl
        ld      bc,font64
        add     hl,bc

        push    de
        
        ld      b,6
		xor	a
		ld	(de),a
print64_1   
	inc     d
	ld      a,(hl)
	and	#f0
	ld      (de),a
	inc     hl
	djnz    print64_1

	inc	d
	xor	a
	ld	(de),a

	ld	a,1
	ld	(half_tile_screen),a

	pop     de
	pop     hl
	pop     af

	dec     a
	ret     z

print64_4	
	push    af

	inc     hl
	push    hl

	ld      a,(hl)
	ld	l,a
	ld	h,0
	add	hl,hl
	add	hl,hl
	add	hl,hl
	ld      bc,font64
	add     hl,bc

	push    de

	ld      b,6
	xor	a
	ld	(de),a
print64_2       
	inc     d
	ld      a,(hl)
	and     #0f
	ld      c,a
	ld      a,(de)
	or      c
	ld      (de),a
	inc     hl
	djnz    print64_2

	inc	d
	xor	a
	ld	(de),a

	ld	(half_tile_screen),a

	pop     de

	call	move_cr64

	pop     hl
	pop     af
	dec     a
	
	jp      nz,print64_3

	ret

; move cursor
move_cr64	
	inc	de

	ld	hl,col_screen
	inc	(hl)
	ld	a,(hl)

	cp	32
	ret	c

	xor	a
	ld	(half_tile_screen),a
	ld	(hl),a
	ld	c,a

	inc	hl
	inc	(hl)
	ld	a,(hl)
	ld	b,a

	cp	24
	jp	c,move_cr64_01

	ld	a,23
	ld	(hl),a
	ld	b,a

	push	bc
	call	scroll_up8
	pop	bc

move_cr64_01	
	call	calc_addr_scr
	ret

calc_addr_scr		
	ld      a,b
	ld      d,a
	rrca
	rrca
	rrca
	and     a,224
	add     a,c
	ld      e,a
	ld      a,d
	and     24
	or      #c0
	ld      d,a
	ret

calc_addr_attr		
	ld	bc,(col_screen)
bc_to_attr:
	ld	a,b
	rrca
	rrca
	rrca
	ld	l,a
	and	31
	or	#d8
	ld	h,a
	ld	a,l
	and	252
	or	c
	ld	l,a
	ret

scroll_up8		
	ld	hl,table_addr_scr
	ld	b,184

scroll_up8_01		
	push	bc

	ld	e,(hl)
	inc	hl
	ld	d,(hl)
	inc	hl

	push	hl

	ld	bc,14
	add	hl,bc
	ld	c,(hl)
	inc	hl
	ld	b,(hl)

	ld	h,b
	ld	l,c

	ld	bc,32
	ldir

	pop	hl
	pop	bc
	djnz	scroll_up8_01

	ld	b,8

scroll_up8_02		
	push	bc

	ld	e,(hl)
	inc	hl
	ld	d,(hl)
	inc	hl

	push	hl

	ld	h,d
	ld	l,e
	inc	de
	ld	(hl),0
	ld	bc,31
	ldir

	pop	hl
	pop	bc
	djnz	scroll_up8_02
	ld	de,#D800, hl,#D820, bc,736
	ldir
	ld	a,(de)
	ld	hl,#dae0, de,#dae1, (hl),a, bc,31
	ldir

	ret

font64 equ #4000 ; Using ZX-Spectrum screen as font buffer
font_file db "data/font64.bin", 0 


table_addr_scr		
	defw	#4000,#4100,#4200,#4300,#4400,#4500,#4600,#4700
	defw	#4020,#4120,#4220,#4320,#4420,#4520,#4620,#4720
	defw	#4040,#4140,#4240,#4340,#4440,#4540,#4640,#4740
	defw	#4060,#4160,#4260,#4360,#4460,#4560,#4660,#4760
	defw	#4080,#4180,#4280,#4380,#4480,#4580,#4680,#4780
	defw	#40a0,#41a0,#42a0,#43a0,#44a0,#45a0,#46a0,#47a0
	defw	#40c0,#41c0,#42c0,#43c0,#44c0,#45c0,#46c0,#47c0
	defw	#40e0,#41e0,#42e0,#43e0,#44e0,#45e0,#46e0,#47e0

	defw	#4800,#4900,#4a00,#4b00,#4c00,#4d00,#4e00,#4f00
	defw	#4820,#4920,#4a20,#4b20,#4c20,#4d20,#4e20,#4f20
	defw	#4840,#4940,#4a40,#4b40,#4c40,#4d40,#4e40,#4f40
	defw	#4860,#4960,#4a60,#4b60,#4c60,#4d60,#4e60,#4f60
	defw	#4880,#4980,#4a80,#4b80,#4c80,#4d80,#4e80,#4f80
	defw	#48a0,#49a0,#4aa0,#4ba0,#4ca0,#4da0,#4ea0,#4fa0
	defw	#48c0,#49c0,#4ac0,#4bc0,#4cc0,#4dc0,#4ec0,#4fc0
	defw	#48e0,#49e0,#4ae0,#4be0,#4ce0,#4de0,#4ee0,#4fe0

	defw	#5000,#5100,#5200,#5300,#5400,#5500,#5600,#5700
	defw	#5020,#5120,#5220,#5320,#5420,#5520,#5620,#5720
	defw	#5040,#5140,#5240,#5340,#5440,#5540,#5640,#5740
	defw	#5060,#5160,#5260,#5360,#5460,#5560,#5660,#5760
	defw	#5080,#5180,#5280,#5380,#5480,#5580,#5680,#5780
	defw	#50a0,#51a0,#52a0,#53a0,#54a0,#55a0,#56a0,#57a0
	defw	#50c0,#51c0,#52c0,#53c0,#54c0,#55c0,#56c0,#57c0
	defw	#50e0,#51e0,#52e0,#53e0,#54e0,#55e0,#56e0,#57e0


col_screen			db	0		
row_screen			db	0					
half_tile_screen	db	0					
attr_screen			db	07					

col_screen_temp			dw	0				
half_tile_screen_temp	db	0				

single_symbol_print db 1
single_symbol 		db 0

fill_buff ds 65

    endmodule