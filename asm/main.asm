arch	sms.cpu
endian	lsb
insert	"../rom/hnk.sms"
output	"../rom/hnk_br.sms"
include	"./var.asm"
include	"./table.asm"



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
//créditos na tela de titulo
//--------------------------------------------------------

origin	$00ee0
jp	injetar_creditos

origin	$07f66
injetar_creditos:
jr	c,++		//se for texto 1p start, sair

//na segunda vez, carregar creditos alternativos
ld	hl,$0f64	
push	af
ld	a,(timer_hi)
cp	$01
jr	nz,+
ld	hl,creditos_alt
+;pop	af
+;jp	$0ee5

origin	$07fa0
creditos_alt:
//3 linhas de $1b tiles
db	"    VERSAO BRASILEIRA      "
db	"                           "
db	"     HERBERT RIGHERS       "



//--------------------------------------------------------
//arquivos
//--------------------------------------------------------

origin	$0b2b4
insert	"../gfx/199X.1bpp"

origin	$07f2e
tilemap_199X:
insert	"../gfx/199X.map"

origin	$136d5
insert	"../gfx/fonte_00_br.1bpp"
