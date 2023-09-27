;=======================================================================;
;									;
;            **********     ENGINE DE CUTSCENES	     *********		;
;									;
;=======================================================================;

; COMANDOS
;---------

.DEFINE	scene_stack	$D000
.DEFINE	f_scene		$D9DF

.ENUM $0000

; TODOS OS ARGUMENTOS SÃO 16 BITS

	cmd_dis_off	DB
	; desligar display

	cmd_dis_on	DB
	; ligar display

	cmd_ld_gfx	DB
	; carregar graficos
	; uso: cmd_ld_gfx, destino, endereço, tamanho

	cmd_ld_tmap	DB
	; carregar tilemaps
	; uso: cmd_ld_gfx, destino, endereço, tamanho yyxx

	cmd_fade_in	DB
	; fade in

	cmd_fade_out	DB
	; fade out

	cmd_psg_play	DB
	; tocar musica
	; uso: cmd_psg_play, musica

	cmd_psg_wait	DB
	; esperar fim da musica

	cmd_timer	DB
	; timer
	; uso: timer,frames

	cmd_end		DB

.ENDE

.BANK 8 SLOT 1
.SECTION "SCENE_ENGINE" FREE
scene_engine_ent:

	; guardar stack pointer em iy
	ld	hl,$0000
	add	hl,sp
	push	hl
	pop	iy

	; ativar stack secundario
	ld	sp,ix

scene_engine:
	pop	af			; carregar cmd
	add	a			; dobrar - tabela é 16-bits
	ld	h,>scene_jumptbl	; carregar tabela de vetores
	ld	l,a			; carregar offset do cmd
	ld	a,(hl)			; ld hl,(hl)
	inc	hl			;
	ld	h,(hl)			;
	ld	l,a			;
	jp	(hl)			; hl = vetor do comando

scene_end:
	ld	sp,iy			; restaurar antigo stack
	ret

scene_dis_off:
	di
	ld	a,%10100000
	out	($bf),a
	ld	a,$81
	out	($bf),a
	jr	scene_engine

scene_dis_on:
	ld	a,%11100000
	out	($bf),a
	ld	a,$81
	out	($bf),a
	ei
	jr	scene_engine

scene_timer:	
	pop	bc
-: 	dec	bc
	ld	a,b
	or	c
	jr	z,scene_engine
	halt
	jr	-

scene_ld_gfx:
	pop	de	; carregar argumentos
	pop	hl
	pop	bc
	ld	a,$0F
	call	ld_gfx
	jp	scene_engine

scene_ld_tmap:
	pop	de	; carregar argumentos
	pop	hl
	pop	bc
	call	ld_tmap
	jp	scene_engine

scene_psg_play:
	pop	hl
	call	PSGPlayNoRepeat
	jp	scene_engine

scene_psg_wait:
-:	call	PSGGetStatus
	cp	0
	jp	z,scene_engine
	halt
	jr	-

scene_fade_in:
	ld	c,$be
	ld	b,$04
	ld	hl,d_fade
	
	-:	push	bc
		ld	b,$08
		ld	a,(hl)
		inc	hl
		call	fade_timer
		call	ld_pal
		pop	bc
		djnz	-

	jp	scene_engine
	
scene_fade_out:
	ld	c,$be
	ld	b,$04
	ld	hl,d_fade+03h
	
	-:	push	bc
		ld	b,$08
		ld	a,(hl)
		dec	hl
		call	fade_timer
		call	ld_pal
		pop	bc
		djnz	-

	jp	scene_engine
	
ld_pal:
	ld	de,$c00f
	push	af
	rst	08h
	pop	af
	out	(c),a
	ret

fade_timer:
-:	halt
	djnz	-
	ret

d_fade:
	.DB	$00, $15, $2a, $3f

.ENDS

.SECTION "JUMPTBL_00"	SEMIFREE ALIGN $100
	scene_jumptbl:
		.DW	scene_dis_off
		.DW	scene_dis_on
		.DW	scene_ld_gfx
		.DW	scene_ld_tmap
		.DW	scene_fade_in
		.DW	scene_fade_out
		.DW	scene_psg_play
		.DW	scene_psg_wait
		.DW	scene_timer
		.DW	scene_end
.ENDS

; TELA 199X
;----------
.BANK 0 SLOT 0
.ORG	$0E66
.SECTION "SCENE_00_HOOK" OVERWRITE
	call	scene_00_in
.ENDS

.SECTION "SCENE_00_IN" FREE
scene_00_in:
	call	clr_psg				; cortar som

	; carregar banco com engine e gfx
	ld	a,$08
	ld	($FFFE),a

	; carregar banco com musica
	ld	a,$09
	ld	($FFFF),a
	call	scene_00
	ld	a,01
	ld	($FFFE),a
	ld	a,02
	ld	($FFFF),a
	xor	a
	ld	(f_scene),a
	ld	a,($d992)
	di
	ret
.ENDS

.BANK 8 SLOT 1
.SECTION "CMD"		FREE
cmd_199X:
.DB	$40,cmd_dis_off		; desligar tela

.DB	$40,cmd_ld_gfx		; carregar gfx_199X na vram em $2820
.DW	$6820,gfx_199X,s_199X

.DB	$40,cmd_ld_tmap		; carregar tmap_199X na vram em $7a92
.DW	$3A92,tmap_199X,$040e	; $040e = tamanho yyxx

.DB	$40,cmd_dis_on		; ligar tela

.DB	$40,cmd_timer		; esperar $20 frames
.DW	$0020

.DB	$40,cmd_fade_in		; fade in

.DB	$40,cmd_psg_play
.DW	f_psg_evilp		; tocar evil prognosis

.DB	$40,cmd_psg_wait	; esperar fim da musica

.DB	$40,cmd_fade_out	; fade out

.DB	$40,cmd_timer		; esperar $60 frames
.DW	$0060

.DB	$40,cmd_end		; fim da cena
cmd_199X_end:
.ENDS

.SECTION "SCENE_00"	FREE
scene_00:		
	call	clr_tilemap			; limpar tilemap
	call	PSGInit				; inicializar psglib
	ld	a,$FF
	ld	(f_scene),a

	; inicializar stack secundario com os comandos da cutscene
	ld	de,scene_stack
	ld	hl,cmd_199X
	ld	bc,cmd_199X_end-cmd_199X
	ldir

	; carregar stack secundario em ix
	ld	ix,scene_stack
	
	; a engine de cutscenes vai carregar os comandos e argumentos
	; do stack secundario
	jp	scene_engine_ent

.ENDS

.SECTION "SCENE_VBLANK"	FREE
scene_vblank:
	call	PSGFrame
	ret
.ENDS
