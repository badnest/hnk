;=======================================================================;
;									;
;             	*****         TELA DE TITULO 		*****		;
;									;
;=======================================================================;

.BANK 0 SLOT 0
.ORGA	$00ee0
.SECTION "CREDITOS_IN"	OVERWRITE
	jr	c,+
	jp	injetar_creditos
+:	ld	bc,$041b
	ld	de,$7d06
.ENDS

.STRINGMAPTABLE MAIN "tbl/tabela_00.tbl"
.ORG	$00F13
.SECTION "TXT_TITULO00" FORCE
.STRINGMAP MAIN,	"                      ´    "
.STRINGMAP MAIN,	"JOGADOR 1 PRESSIONE INICIO "
.STRINGMAP MAIN,	"            OU        ´    "
.STRINGMAP MAIN,	"JOGADOR 2 PRESSIONE INICIO "
.ENDS

.SECTION "TXT_TITULO01" SEMISUPERFREE BANKS 0-2
creditos:
.STRINGMAP MAIN,	"                           "
.STRINGMAP MAIN,	"© BURONSON, TETSUO HARA,   "
.STRINGMAP MAIN,	"  SHUEISHA, TOEI ANIMATION,"
.STRINGMAP MAIN,	"  FUJI TV    © sega 1986   "
.ENDS

.SECTION "TXT_TITULO02" SEMISUPERFREE BANKS 0-2
creditos_alt:
.STRINGMAP MAIN,	"        ~                  "
.STRINGMAP MAIN,	"    VERSAO BRASILEIRA      "
.STRINGMAP MAIN,	"                           "
.STRINGMAP MAIN,	"     HERBERT RICHERS       "
.ENDS

.BANK 2 SLOT 2
.SECTION "CREDITOS" FREE
injetar_creditos:
; na segunda vez, carregar creditos alternativos
	ld	hl,creditos	
	push	af
	ld	a,(timer_hi)
	cp	$01
	jr	nz,+
	ld	hl,creditos_alt
+:	pop	af
++:	jp	$0ee5
.ENDS
