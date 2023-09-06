;=======================================================================;
;									;
;       **********      FUTURA ENGINE DE CUTSCENES	*********	;
;									;
;=======================================================================;

.BANK 0 SLOT 0
.ORGA	$0E66
.SECTION "SCENE_00_IN" OVERWRITE
	call	scene_00
.ENDS


; TELA 199X
;----------
.BANK 2 SLOT 2
.SECTION "SCENE_00"	FREE

scene_00:		
	call	clr_psg
	call	clr_tilemap	; limpar tilemap

	; gfx 199X
	ld	hl,gfx_199X
	ld	de,$6820
	ld	bc,s_199X
	ld	a,$0F
	call	ld_gfx

	; tilemap 199X
	ld	hl,tm_199X
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
	
	-:	push	bc
		ld	b,$08
		ld	a,(hl)
		inc	hl
		call	timer
		call	ld_pal
		pop	bc
		djnz	-
	
	dec	hl
	ld	b,$78
	call	timer
	ld	b,$04
	
	-:	push	bc
		ld	b,$08
		ld	a,(hl)
		dec	hl
		call	timer
		call	ld_pal
		pop	bc
		djnz	-
	
	
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
-:	halt
	djnz	-
	ret

d_fade:
.DB	$00, $15, $2a, $3f

.ENDS
