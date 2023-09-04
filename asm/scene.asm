//----------------------------------------------
//CENA 199X
//----------------------------------------------

origin	$00e66
call	scene_00

origin	$0b4c9
scene_00:		//199X
call	clr_psg
call	clr_tilemap	//limpar tilemap

//gfx 199X
ld	hl,gfx_199X
ld	de,$6820
ld	bc,gfx_199X_end-gfx_199X
ld	a,$0f
call	ld_gfx

//tilemap 199X
ld	hl,tilemap_199X
ld	de,$3a92
ld	bc,$040e
call	ld_tilemap

call	fade

scene_00_out:
ld	a,($d992)
ret

fade:
ld	b,$10
call	timer
ld	c,$be
ld	b,$04
ld	hl,d_fade

	-;push	bc
	ld	b,$08
	ld	a,(hl)
	inc	hl
	call	timer
	call	ld_pal
	pop	bc
	djnz	-;

dec	hl
ld	b,$78
call	timer
ld	b,$04

	-;push	bc
	ld	b,$08
	ld	a,(hl)
	dec	hl
	call	timer
	call	ld_pal
	pop	bc
	djnz	-;

ld	b,$60
call	timer
ret

ld_pal:
ld	de,$c00f
push	af
rst	08h
pop	af
out	(c),a
ret

timer:
ei
-;halt
djnz	-
ret

d_fade:
db	$00, $15, $2a, $3f
