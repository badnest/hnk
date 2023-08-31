arch	sms.cpu
endian	lsb
insert	"../rom/hnk.sms"
output	"../rom/hnk_br.sms"
include	"./var.asm"
include	"./reset.asm"
include "./charmap.asm"
include	"./txt_engine.asm"
include "./table.asm"


//--------------------------------------------------------
//DEBUG
//--------------------------------------------------------
origin	$19f8
//desligar inimigos normais
nop
nop

origin	$27cb
//desabilitar graficos golpes por enquanto
nop
nop
nop

//vida infinita
//--------------------------------------------------------
//tela titulo
//--------------------------------------------------------

origin	$00ee2
ld	hl,$0f64
ld	bc,$041b
ld	de,$7d06

origin	$00f13
db	"                      =    "
db	"JOGADOR 1 PRESSIONE INICIO "
db	"            OU        =    "
db	"JOGADOR 2 PRESSIONE INICIO "

//espaço liberado $00f7f até $00fa8, já ocupado parcialmente

origin	$0b3b4
creditos:
db	"                           "
db	"( BURONSON, TETSUO HARA,   "
db	"  SHUEISHA, TOEI ANIMATION,"
db	"  FUJI TV    ( sega 1986   "

creditos_alt:
//3 linhas de $1b tiles
db	"        ~                  "
db	"    VERSAO BRASILEIRA      "
db	"                           "
db	"     HERBERT RICHERS       "


//créditos na tela de titulo
//--------------------------------------------------------

origin	$00ee0
jp	injetar_creditos

origin	$0b56c
injetar_creditos:
	jr	c,++	//se for texto 1p start, sair
	
//na segunda vez, carregar creditos alternativos
	ld	hl,creditos	
	push	af
	ld	a,(timer_hi)
	cp	$01
	jr	nz,+
	ld	hl,creditos_alt
	+;pop	af
	+;jp	$0ee5



//--------------------------------------------------------
//tela vermelha
//--------------------------------------------------------

//jogador
//------------------------------------------------
origin	$066ca
ld	b,txt_jogador_end-txt_jogador	//tamanho
ld	de,$3b54			//pos tela
ld	hl,txt_jogador

origin	$06751
txt_jogador:
	db	"JOGADOR"
txt_jogador_end:

//espaço livre $06758 - $0675d - 6 bytes


//nome do capitulo
//---------------------------------------------

origin	$06717
ld	a,(hl)
ld	e,a
inc	hl
ld	a,(hl)
ld	d,a
inc	hl
//hl = ponteiro do texto
//de = destino vram
call	txt_engine

origin	$0678a
txt_cidade:
dw	$7a48
db	"CIDADE DA CRUZ DO SUL"
db	$ff

txt_deus:
dw	$7a50
db	"TERRA DE DEUS"
db	$ff

txt_devil:
dw	$7a50
db	"DEVIL REVERSE"
db	$ff

origin	$0677e
//ponteiros dos nomes dos capitulos
txt_capitulo_ptr_tbl:
dw	txt_cidade
dw	txt_deus
dw	txt_devil


//texto "capítulo"
//-----------------------------------------------
origin	$066bf
ld	b,txt_capitulo_end-txt_capitulo	//tamanho
ld	de,$3954			//pos tela
ld	hl,$bedf

//aproveitar pra botar o acento no capítulo
call	$bff0

origin	$13ff0
call	$0233

ld 	de,$791e
rst	08h
ld	a,$2e
out	($be),a
ld	a,$11
out	($be),a
ret

//número capitulo
origin	$066b9
ld	de,$3952	//pos tela

origin	$13edf
txt_capitulo:
db	"o CAPITULO"
txt_capitulo_end:



//x vidas
origin	$066d8
ld	a,$27



//--------------------------------------------------------
//game over
//--------------------------------------------------------
origin	$068eb
db	"GAME OVER"

//--------------------------------------------------------
//HUD
//--------------------------------------------------------

//remover numero do capitulo
origin	$00850
nop
nop
nop

//pontuação
origin	$00bdd
db	"UP"
origin	$00be7
db	"TO"

//linha central
origin	$00833
ld	b,txt_hud_end-txt_hud
ld	de,$7888
ld	hl,txt_hud

origin	$00be9
txt_hud:
db	"KENSHIRO"
db	$3a,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3a
db	" TEMPO"
txt_hud_end:

//pos barra vida kenshiro
origin	$0610f
ld	hl,$789a
origin	$0088d
ld	de,$78ab

//pos barra vida chefe
origin	$00895
ld	de,$786b
//pos tempo
origin	$06184
ld	de,$78ba

//--------------------------------------------------------
//tela 199X
//--------------------------------------------------------

origin	$00d4e
db	$00			//fundo preto
origin	$00d5e
db	$00			//borda preta
origin	$00d12
ld	bc,$0100		//tamanho do gráfico
origin	$00d1f
ld	hl,tilemap_199X	
ld	de,$3a92		//posição do 199X na tela
ld	bc,$040e		//4 linhas de 14 tiles


//--------------------------------------------------------
//caixas de texto
//--------------------------------------------------------
origin	$0129d
call	txt_cx

//textos
//--------------------------------------------------------
origin	$01391
txt_yuria:
insert	"../txt/yuria.bin"


//--------------------------------------------------------
//fonte
//--------------------------------------------------------
//carregar fonte contínua
origin	$063d2
ld	hl,$bdc6
origin	$0667d
ld	hl,$bdc6
origin	$03202
ld	hl,$bdc6
origin	$138b
dw	$bdc6



//--------------------------------------------------------
//melhorias
//--------------------------------------------------------

//por algum motivo, o jogo demora pra iniciar de
//proposito.

//boot rapido
origin	$00504
jr	$0050e



//--------------------------------------------------------
//arquivos
//--------------------------------------------------------

origin	$0b2b4
insert	"../gfx/199X.1bpp"

origin	$0b48c
tilemap_199X:
insert	"../gfx/199X.map"

origin	$136d5
insert	"../gfx/fonte_00_br.1bpp"
