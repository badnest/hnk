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
	REGIONCODE	$04
	RESERVEDSPACE	$FF, $FF
	ROMSIZE		$0F
.ENDSMS


; MAPEAMENTO DE MEMÓRIA
;----------------------
.MEMORYMAP
	DEFAULTSLOT	2
	SLOTSIZE	$7FF0		;primeiros 2 bancos
	SLOT 0		$0000
	SLOTSIZE	$0010		;header
	SLOT 1		$7FF0
	SLOTSIZE	$4000		;slot trocável
	SLOT 2		$8000
.ENDME


; MAPEAMENTO DOS BANCOS
;----------------------
.ROMBANKMAP
	BANKSTOTAL	8
	BANKSIZE	$7FF0
	BANKS		1
	BANKSIZE	$0010
	BANKS		1
	BANKSIZE	$4000
	BANKS		6
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
.UNBACKGROUND	$136D5	$13A4D
.UNBACKGROUND	$13DC6	$13FFF		; charmap
.UNBACKGROUND	$17F5C	$17FFF
.UNBACKGROUND	$1BE36	$1BFFF
.UNBACKGROUND	$1FF8D	$1FFFF
.EMPTYFILL	$FF


; includes
;---------
.INCLUDE	"asm/reset.asm"
.INCLUDE	"asm/charmap.asm"
.INCLUDE	"asm/txt_engine.asm"
.INCLUDE	"asm/scene.asm"
.INCLUDE	"asm/interface.asm"
.INCLUDE	"asm/titulo.asm"
.INCLUDE	"asm/txt_main.asm"


; rotinas nativas
;----------------
.DEFINE	clr_tilemap	$0244
.DEFINE ld_gfx		$0295
.DEFINE ld_tilemap	$025e
.DEFINE clr_psg		$6d7a


; variáveis ram
;--------------
.DEFINE timer_hi	$d9a4
.DEFINE timer_lo	$d9a3
.DEFINE ram_initstr	$df8b


; tabelas dos textos
;-------------------
.STRINGMAPTABLE MAIN	"tbl/tabela_00.tbl"



;=======================================================================;
;									;
;      			*****      DEBUG       	*****			;
;									;
;=======================================================================;

.BANK 0 SLOT 0

; desligar inimigos normais
;--------------------------
;.ORGA	$19f8
;.SECTION "DEBUG_INIM_OFF" OVERWRITE
;	nop
;	nop
;.ENDS

; desabilitar graficos golpes
;----------------------------
.ORGA	$27cb
.SECTION "DEBUG_GOLPE_OFF" OVERWRITE
	nop
	nop
	nop
.ENDS

; desabilitar tela markIII
;-------------------------
.ORGA	$00d4b
.SECTION "DEBUG_MARKIII_OFF" OVERWRITE
	jr	-0Eh
.ENDS

; boot rapido
;------------
.ORGA	$00504
.SECTION "DEBUG_FASTBOOT" OVERWRITE
	jr	+08H
.ENDS



;=======================================================================;
;									;
;      			*****      FONTE       	*****			;
;									;
;=======================================================================;

; carregar fonte contínua
;------------------------
.ORGA	$063d2
.SECTION "CHARMAP_OVER_00" OVERWRITE
	ld	hl,$bdc6
.ENDS

.ORGA	$0667d
.SECTION "CHARMAP_OVER_01" OVERWRITE
	ld	hl,$bdc6
.ENDS

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

.BANK 2 SLOT 2

; gráficos
;---------
.SECTION "F_GFX_199X"	FREE
	gfx_199X:
		.INCBIN	"gfx/199X.1bpp"	FSIZE s_199X
.ENDS

; tilemaps
;---------
.SECTION "F_TM_199X"	FREE
	tm_199X:
		.INCBIN	"gfx/199X.map"
.ENDS


