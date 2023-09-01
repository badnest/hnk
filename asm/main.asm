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
//nop
//nop

origin	$27cb
//desabilitar graficos golpes por enquanto
nop
nop
nop



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
ld	de,$3b56			//pos tela
ld	hl,txt_jogador

origin	$06751
txt_jogador:
	db	"JOGADOR"
txt_jogador_end:

//número jogador
origin	$0669b
ld	de,$3b66	//pos tela

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
txt_cap1:
dw	$7a4a
db	"CIDADE DA CRUZ DO SUL"
db	$ff

txt_cap2:
dw	$7a52
db	"TERRA DE DEUS"
db	$ff

txt_cap3:
dw	$7a52
db	"DEVIL REVERSE"
db	$ff

txt_cap4:
dw	$7a4c
db	"LENDA DE CASSANDRA"
db	$ff

origin	$0677e
//ponteiros dos nomes dos capitulos
txt_capitulo_ptr_tbl:
dw	txt_cap1
dw	txt_cap2
dw	txt_cap3
dw	txt_cap4


//texto "capítulo"
//-----------------------------------------------
origin	$066bf
ld	b,txt_capitulo_end-txt_capitulo	//tamanho
ld	de,$3956			//pos tela
ld	hl,$bedf

//aproveitar pra botar o acento no capítulo
call	$bff0

origin	$13ff0
	call	$0233

	ld 	de,$7920
	rst	08h
	ld	a,$2e
	out	($be),a
	ld	a,$11
	out	($be),a
	ret

//número capitulo
origin	$066b9
ld	de,$3954	//pos tela

origin	$13edf
txt_capitulo:
db	"o CAPITULO"
txt_capitulo_end:

//x vidas
origin	$066d8
ld	a,$27
origin	$066d5
ld	de,$3c1e	//pos tela

//numero vidas
origin 	$066a3
ld	de,$3c22	//pos tela

//sprite vidas
origin	$066f5
ld	(iy+4),$60	//pos tela



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

//bonus
origin	$061d8
ld	de,$7854	//pos tela
origin	$061fc
ld	de,$7854	//pos tela
origin	$061e3
ld	de,$7860
origin	$06208
db	"BONUS"
origin	$06213
db	"PTS."

//tempo diminuindo ao passar de fase
origin	$012d4
ld	de,$78ba	//pos tela

//linha principal
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

//pos tempo
origin	$06184
ld	de,$78ba

//pos barra vida kenshiro
origin	$0610f
ld	hl,$789a
origin	$0610f
ld	hl,$789a
origin	$0088d
ld	de,$78ab

//pos barra vida chefe
origin	$00885
ld	de,$7844
origin	$060fa
ld	hl,$785a
origin	$00859
ld	de,$7858
origin	$00895
ld	de,$786b

//pos tempo
origin	$06184
ld	de,$78ba

//shin
origin	$0881
ld	hl,boss_shin
ds	1
ld	de,$7850

//nomes dos chefes
//originalmente ficavam na região de $8b0
origin	$00f8f
boss_shin:
db	"SHIN"
boss_coronel:
db	"CORONEL"
boss_devil:
db	"D. REVERSE"
boss_toki:
db	"TOKI"
boss_end:


//nomes de chefes de tamanho variavel
//--------------------------------------------------------
origin	$0087c
jp	txt_vchefe

origin	$1be79
txt_vchefe:
	cp 	$03	//coronel
	jr	z,txt_vchefe_coronel
	cp	$05
	jr	z,txt_vchefe_devil
	cp	$07
	jr	z,txt_vchefe_toki
	dec	a
	add	a,a
	ld	c,a
	jp	$087f

txt_vchefe_coronel:
	ld	hl,boss_coronel
	ld	de,$784a
	ld	b,boss_devil-boss_coronel
	jp	$088a

txt_vchefe_devil:
	ld	hl,boss_devil
	ld	de,$7844
	ld	b,boss_toki-boss_devil
	jp	$088a

txt_vchefe_toki:
	ld	hl,boss_toki
	ld	de,$7850
	ld	b,boss_end-boss_toki
	jp	$088a



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
call	$bee9	//txt_cx

origin	$13ee9
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

origin	$0138d
//caixa cap 1
//dw	$051c	//tamanho yyxx
//dw	$79c4	//pos tela

//textos
//--------------------------------------------------------
origin	$0138b
txt_yuria:
insert	"../txt/yuria.bin"
txt_batalha:
insert	"../txt/batalha.bin"
txt_devil:
insert	"../txt/devil.bin"

origin	$01381
txt_ptr_tbl:
dw	txt_batalha
dw	txt_devil



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
origin	$0303d		//chefe cap 2
ld	hl,$bdc6
origin	$030a3		//chefe cap 3
ld	hl,$bdc6
origin	$0310b		//chefe cap 4
ld	hl,$bdc6
origin	$0138b
//dw	$bdc6
origin	$013e1
//dw	$bdc6



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
