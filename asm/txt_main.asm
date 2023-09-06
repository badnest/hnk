;=======================================================================;
;									;
;             	*****     TEXTOS PRINCIPAIS  	*****			;
;									;
;=======================================================================;

.BANK 0 SLOT 0
.ORG	$137F
.SECTION "TEXTO" FORCE


; tabela de ponteiros
---------------------

txt_ptr_tbl:
.DW	txt_yuria
.DW	txt_batalha
.DW	txt_devil
.DW	txt_toki



; textos
--------
.STRINGMAPTABLE MAIN "tbl/tabela_00.tbl"

txt_yuria:
.DW	CHARMAP_00		; charmap
.DW	$051C			; tamanho caixa yyxx
.DW	$79C4			; pos vram

.STRINGMAP MAIN, 	"ERA APENAS UMA BONECA...[BREAK]"
.STRINGMAP MAIN, 	"SALVE A VERDADEIRA YURIA!![END]"


txt_batalha:
.DW	CHARMAP_00		; charmap
.DW	$0B14			; tamanho caixa yyxx
.DW	$794C			; pos vram

.STRINGMAP MAIN, 	"A BATALHA ESTÁ[BREAK]"
.STRINGMAP MAIN, 	"SÓ COMEÇANDO...[BREAK]"
.STRINGMAP MAIN, 	"[BREAK]"
.STRINGMAP MAIN, 	"INIMIGOS TERRÍVEIS [BREAK]"
.STRINGMAP MAIN, 	"O AGUARDAM!![END]"


txt_devil:
.DW	CHARMAP_00		; charmap
.DW	$091A			; tamanho caixa yyxx
.DW	$7946			; pos vram

.STRINGMAP MAIN, 	"O DEMÔNIO FOI DESTRUÍDO.[BREAK]"
.STRINGMAP MAIN, 	"[BREAK]"
.STRINGMAP MAIN, 	"O PRÓXIMO DESAFIO É [BREAK]"
.STRINGMAP MAIN, 	"A LENDA DE CASSANDRA![END]"


txt_toki:
.DW	CHARMAP_00		; charmap
.DW	$071C			; tamanho caixa yyxx
.DW	$7944			; pos vram

.STRINGMAP MAIN, 	"DURANTE A LUTA,[BREAK]"
.STRINGMAP MAIN, 	"TOKI ENSINOU PARA KENSHIRO[BREAK]"
.STRINGMAP MAIN, 	"A TÉCNICA DO PUNHO SUAVE.[END]"
.ENDS



; caixas de texto
;----------------
.ORGA	$0129d
call	txt_cx

.BANK 4 SLOT 2
.SECTION "CAIXA" FREE
txt_cx:
	push	de
	push	hl
	ld	hl,$dce0
	call	$025e
	pop	hl
	pop	de
	ld	c,$42
	rst	30h
	call	txt_engine
	ret
.ENDS
