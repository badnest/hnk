;=======================================================================;
;									;
;             	*****          TELA VERMELHA		*****		;
;									;
;=======================================================================;
;									;
; LINHA 1	X CAPÍTULO						;
; LINHA 2	NOME DO CAPITULO					;
; LINHA 3	JOGADOR X						;
; LINHA	4	SPRITE X (VIDAS)					;
;									;
;=======================================================================;

.STRINGMAPTABLE	MAIN	"tbl/tabela_00.tbl"
.BANK 0 SLOT 0


; LINHA 1
;--------

.ORGA	$066b9
.SECTION "VM_CAP0_PROP" 	OVERWRITE

	ld	de,$3954			; pos tela
	call	$01EA
	ld	b,txt_capitulo_end-txt_capitulo	; tamanho
	ld	de,$3956			; pos tela
	ld	hl,txt_capitulo

	; aproveitar pra botar o acento no capítulo
	call	acento_cap

.ENDS


.BANK 4 SLOT 2
.SECTION "VM_CAP0_EXT"	FREE

acento_cap:
	call	$0233

	ld 	de,$7920
	rst	08h
	ld	a,$2e
	out	($be),a
	ld	a,$11
	out	($be),a
	ret
.ENDS


.SECTION "VM_CAP0_TXT"	FREE
	txt_capitulo:
		.STRINGMAP MAIN, "º CAPITULO"
	txt_capitulo_end:
.ENDS



; LINHA 2
;--------

.BANK 0 SLOT 0
.ORGA	$6717
.SECTION "TXT_CAP_IN"	OVERWRITE

TXT_CAP_IN:
	ld	a,(hl)
	ld	e,a
	inc	hl
	ld	a,(hl)
	ld	d,a
	inc	hl

	; hl = ponteiro do texto
	; de = destino vram

	call	txt_engine

.ENDS


.ORGA	$0677e
.SECTION "VM_CAP1_TXT" FORCE

; ponteiros dos nomes dos capitulos
txt_capitulo_ptr_tbl:
.DW	txt_cap1
.DW	txt_cap2
.DW	txt_cap3
.DW	txt_cap4
.DW	txt_cap5

txt_cap1:
.DW	$7a4a
.STRINGMAP MAIN, "CIDADE DA CRUZ DO SUL"
.DB	$ff

txt_cap2:
.DW	$7a52
.STRINGMAP MAIN, "TERRA DE DEUS"
.DB	$ff

txt_cap3:
.DW	$7a52
.STRINGMAP MAIN, "DEVIL REVERSE"
.DB	$ff

txt_cap4:
.DW	$7a4a
.STRINGMAP MAIN, "A LENDA DE CASSANDRA"
.DB	$ff

txt_cap5:
.DW	$7a46
.STRINGMAP MAIN, "ESTILO DO CRUZEIRO DO SUL"
.DB	$ff

.ENDS



; LINHA 3
;--------

.ORGA	$66ca
.SECTION "VM_JOG_TXT_PROP" 	OVERWRITE

ld	b,txt_jogador_end-txt_jogador	; tamanho
ld	de,$3b56			; pos tela
ld	hl,txt_jogador

.ENDS


.ORGA	$6751
.SECTION "VM_JOG_TXT"	OVERWRITE	;onde estava "CHAPTER"

	txt_jogador:
	.STRINGMAP MAIN, "JOGADOR"

txt_jogador_end:
.ENDS


.ORGA	$669b
.SECTION "VM_JOG_NUM_PROP"	OVERWRITE

	; número jogador
	ld	de,$3b66	; pos tela

.ENDS



; LINHA 4
;--------

.ORGA	$066d5
.SECTION "VM_X_PROP"	OVERWRITE
	ld	de,$3c1e	; pos tela
	ld	a,$27		; cod caractere
.ENDS

.ORGA 	$066a3
.SECTION "VM_VIDAS_PROP"	OVERWRITE
	ld	de,$3c22	; pos tela
.ENDS

.ORGA	$066f5
.SECTION "VM_SPRITE_PROP"	OVERWRITE
	ld	(iy+4),$60	; pos tela
.ENDS




;=======================================================================;
;									;
;             	*****          GAME OVER	*****			;
;									;
;=======================================================================;

.BANK 0 SLOT 0
.ORGA	$068eb
.SECTION "GAMEOVER_TXT"	OVERWRITE
	.STRINGMAP MAIN, "GAME OVER"
.ENDS




;=======================================================================;
;									;
;             		*****    HUD    *****				;
;									;
;=======================================================================;

; remover numero do capitulo
----------------------------
.ORGA	$00850
.SECTION "HUD_CAP" OVERWRITE
	nop
	nop
	nop
.ENDS


; pontuação
;----------
.ORGA	$00bdd
.SECTION "HUD_1UP" 	OVERWRITE
	.STRINGMAP MAIN, "UP"
.ENDS

.ORGA	$00be7
.SECTION "HUD_TOP" 	OVERWRITE
	.STRINGMAP MAIN, "TO"
.ENDS


; bonus
;------
.ORGA	$061d8
.SECTION "HUD_BONUS00_PROP"	OVERWRITE
	ld	de,$7854	; pos tela
.ENDS

.ORGA	$061fc
.SECTION "HUD_BONUS01_PROP" 	OVERWRITE
	ld	de,$7854	; pos tela
.ENDS

.ORGA	$061e3
.SECTION "HUD_BONUS02_PROP" 	OVERWRITE
	ld	de,$7860	; pos tela
.ENDS

.ORGA	$06208
.SECTION "HUD_BONUS00_TXT" 	OVERWRITE
	.STRINGMAP MAIN, "BONUS"
.ENDS

.ORGA	$06213
.SECTION "HUD_BONUS01_TXT" 	OVERWRITE
	.STRINGMAP MAIN, "PTS."
.ENDS


; linha principal
;----------------
.ORGA	$0833
.SECTION "HUD_MAIN_PROP" 	OVERWRITE
	ld	b,txt_hud_end-txt_hud
	ld	de,$7888
	ld	hl,txt_hud
.ENDS

.ORGA	$0be9
.SECTION "HUD_MAIN_TXT"		OVERWRITE
	txt_hud:
		.STRINGMAP MAIN, "KENSHIRO"
		.DB	$3a,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3a
		.STRINGMAP MAIN, " TEMPO"
	txt_hud_end:
.ENDS

.ORGA	$06184
.SECTION "HUD_TEMPO00_PROP"	OVERWRITE
	ld	de,$78ba	; pos tela
.ENDS

.ORGA	$012d4
.SECTION "HUD_TEMPO01_PROP"	OVERWRITE
	ld	de,$78ba	; pos tela
.ENDS


; pos barra vida kenshiro
-------------------------
.ORGA	$0610f
.SECTION "HUD_VIDA00_PROP"	OVERWRITE
	ld	hl,$789a
.ENDS

.ORGA	$0088d
.SECTION "HUD_VIDA01_PROP"	OVERWRITE
	ld	de,$78ab
.ENDS

; pos barra vida chefe
----------------------
.ORGA	$060fa
.SECTION "HUD_VIDAC00_PROP"	OVERWRITE
	ld	hl,$785a
.ENDS

.ORGA	$00859
.SECTION "HUD_VIDAC01_PROP"	OVERWRITE
	ld	de,$7858
.ENDS

.ORGA	$00895
.SECTION "HUD_VIDAC02_PROP"	OVERWRITE
	ld	de,$786b
.ENDS


; nomes dos chefes
;-----------------
.SECTION "BOSS_SHIN_TXT"	SEMISUPERFREE BANKS 0/6
boss_shin:
.STRINGMAP MAIN, 	"SHIN"
boss_shin_end:
.ENDS

.SECTION "BOSS_CORONEL_TXT"	SEMISUPERFREE BANKS 0/6
boss_coronel:
.STRINGMAP MAIN, 	"CORONEL"
boss_coronel_end:
.ENDS

.SECTION "BOSS_DEVIL_TXT"	SEMISUPERFREE BANKS 0/6
boss_devil:
.STRINGMAP MAIN, 	"D. REVERSE"
boss_devil_end:
.ENDS

.SECTION "BOSS_TOKI_TXT" 	SEMISUPERFREE BANKS 0/6
boss_toki:
.STRINGMAP MAIN, 	"TOKI"
boss_toki_end:
.ENDS

.SECTION "BOSS_SOUTHER_TXT" 	SEMISUPERFREE BANKS 0/6
boss_souther:
.STRINGMAP MAIN, 	"SOUTHER"
boss_souther_end:
.ENDS



; nomes de chefes de tamanho variavel
;------------------------------------

.ORGA	$0881
.SECTION "HUD_SHIN_PROP" OVERWRITE
	ld	hl,boss_shin
	add	hl,bc
	ld	de,$7850
.ENDS

.ORGA	$087c
.SECTION "TXT_CHEFE_TVAR_IN"	OVERWRITE
	jp	txt_chefe_tvar
.ENDS


.BANK 6 SLOT 2
.SECTION "TXT_CHEFE_TVAR" 	FREE

txt_chefe_tvar:
	cp 	$03	; coronel
	jr	z,txt_chefe_tvar_coronel
	cp	$05
	jr	z,txt_chefe_tvar_devil
	cp	$07
	jr	z,txt_chefe_tvar_toki
	dec	a
	add	a,a
	ld	c,a
	jp	$087f

txt_chefe_tvar_coronel:
	ld	hl,boss_coronel
	ld	de,$784a
	ld	b,boss_coronel_end-boss_coronel
	jp	$088a

txt_chefe_tvar_devil:
	ld	hl,boss_devil
	ld	de,$7844
	ld	b,boss_devil_end-boss_devil
	jp	$088a

txt_chefe_tvar_toki:
	ld	hl,boss_toki
	ld	de,$7850
	ld	b,boss_toki_end-boss_toki
	jp	$088a
.ENDS
