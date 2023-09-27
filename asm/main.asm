;=======================================================================;
;									;
;             	*****    CONFIGURAÇÃO DO ASSEMBLER	*****		;
;									;
;=======================================================================;


; CABEÇALHO
;----------
.SMSHEADER
	PRODUCTCODE	$03, $13, $0
	VERSION		$0
	RESERVEDSPACE	$FF, $FF
	REGIONCODE	$04
	ROMSIZE		$0
.ENDSMS


; MAPEAMENTO DE MEMÓRIA
;----------------------
.MEMORYMAP
	DEFAULTSLOT	2
	SLOTSIZE	$4000
	SLOT 0		$0000
	SLOTSIZE	$4000
	SLOT 1		$4000
	SLOTSIZE	$4000
	SLOT 2		$8000
	SLOTSIZE	$2000
	SLOT 3		$C000		; RAM
.ENDME


; MAPEAMENTO DOS BANCOS
;----------------------
.ROMBANKMAP
	BANKSTOTAL	16
	BANKSIZE	$4000
	BANKS		16
.ENDRO


; MAPEAMENTO DA ROM
;------------------
.BACKGROUND	"rom/hnk.sms"
.UNBACKGROUND	$08B9	$08CC		; nomes chefes
.UNBACKGROUND	$0F13	$0FA8		; texto tela de titulo	
.UNBACKGROUND	$137F	$165C		; texto principal
.UNBACKGROUND	$6758	$675D		; texto "player"
.UNBACKGROUND	$677E	$680D		; nomes capitulos
.UNBACKGROUND 	$7F2E	$7FFF
.UNBACKGROUND 	$B394	$B57F
.UNBACKGROUND	$FE43	$FFFF
.UNBACKGROUND	$136D5	$13A4C		; fonte
.UNBACKGROUND	$13DC6	$13FFF		; charmap
.UNBACKGROUND	$17F5C	$17FFF
.UNBACKGROUND	$1BE36	$1BFFF
.UNBACKGROUND	$1FF8D	$1FFFF
.EMPTYFILL	$FF


; INCLUDES
;---------
.INCLUDE	"asm/reset.asm"
.INCLUDE	"asm/charmap.asm"
.INCLUDE	"asm/txt_engine.asm"
.INCLUDE	"asm/scene.asm"
.INCLUDE	"asm/interface.asm"
.INCLUDE	"asm/titulo.asm"
.INCLUDE	"asm/txt_main.asm"
.INCLUDE	"psg/psglib.asm"


; ROTINAS NATIVAS
;----------------
.DEFINE	clr_tilemap	$0244
.DEFINE ld_gfx		$0295
.DEFINE ld_tmap		$025e
.DEFINE clr_psg		$6d7a


; VARIÁVEIS RAM
;--------------
.DEFINE timer_hi	$d9a4
.DEFINE timer_lo	$d9a3
.DEFINE ram_initstr	$df8b


; TABELAS DOS TEXTOS
;-------------------
.STRINGMAPTABLE MAIN	"tbl/tabela_00.tbl"



;=======================================================================;
;									;
;      			*****      DEBUG       	*****			;
;									;
;=======================================================================;

.BANK 0 SLOT 0

; DESLIGAR INIMIGOS NORMAIS
;--------------------------
;.ORGA	$19f8
;.SECTION "DEBUG_INIM_OFF" 	OVERWRITE
;	nop
;	nop
;.ENDS

; DESABILITAR GRAFICOS GOLPES
;----------------------------
.ORGA	$27cb
.SECTION "DEBUG_GOLPE_OFF" 	OVERWRITE
	nop
	nop
	nop
.ENDS

; DESABILITAR TELA MARKIII
;-------------------------
.ORGA	$00d4b
.SECTION "DEBUG_MARKIII_OFF" 	OVERWRITE
	jr	-0Eh
.ENDS

; BOOT RAPIDO
;------------
.ORGA	$00504
.SECTION "DEBUG_FASTBOOT"	OVERWRITE
	jr	+08H
.ENDS

; INICIALIZAR SP MELHOR
;----------------------
.ORGA	$0003
.SECTION "INIT_STACK" 		OVERWRITE
	ld	sp,$DFEF
.ENDS



;=======================================================================;
;									;
;      			*****      VBLANK      	*****			;
;									;
;=======================================================================;

.BANK 0 SLOT 0
.ORGA	$011A
.SECTION "BLK_00"	OVERWRITE
	call	vblank
.ENDS

.SECTION "BLK_01"	FREE
vblank:
	call	$165D
	ld	a,(f_scene)
	or	a
	call	nz,scene_vblank
	ld	a,($D981)
	or	a
	ret	z
	jp	$0135
.ENDS



;=======================================================================;
;									;
;      			*****      FONTE       	*****			;
;									;
;=======================================================================;

; carregar fonte contínua
;------------------------
.BANK 1 SLOT 1
.ORGA	$063d2
.SECTION "CHARMAP_OVER_00" OVERWRITE
	ld	hl,$bdc6
.ENDS

.ORGA	$0667d
.SECTION "CHARMAP_OVER_01" OVERWRITE
	ld	hl,$bdc6
.ENDS

.BANK 0 SLOT 0
.ORGA	$03202
.SECTION "CHARMAP_OVER_02" OVERWRITE
	ld	hl,$bdc6
.ENDS

.ORGA	$0303d		; chefe cap 2
.SECTION "CHARMAP_OVER_03" OVERWRITE
	ld	hl,$bdc6
.ENDS

.ORGA	$030a3		; chefe cap 3
.SECTION "CHARMAP_OVER_04" OVERWRITE
	ld	hl,$bdc6
.ENDS

.ORGA	$0310b		; chefe cap 4
.SECTION "CHARMAP_OVER_05" OVERWRITE
	ld	hl,$bdc6
.ENDS

.BANK 4 SLOT 2

.ORG	$36d5
.SECTION "F_FONTE"	FORCE
fonte:
	.INCBIN	"gfx/fonte_00_br.1bpp"	FSIZE s_fonte
.ENDS



;=======================================================================;
;									;
;      			*****     ARQUIVOS   	*****			;
;									;
;=======================================================================;

.BANK 8 SLOT 1

; gráficos
;---------
.SECTION "F_GFX_199X"	FREE
	gfx_199X:
		.INCBIN	"gfx/199X.1bpp"	FSIZE s_199X
.ENDS

; tilemaps
;---------
.SECTION "F_TMAP_199X"	FREE
	tmap_199X:
		.INCBIN	"gfx/199X.map"
.ENDS

.BANK 9 SLOT 2

; psg
;----
.SECTION "F_PSG"	FREE
	f_psg_evilp:
		.INCBIN "psg/evilp.psg"
.ENDS
