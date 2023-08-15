arch	sms.cpu
endian	lsb
insert	"../hnk.sms"
output	"../hnk_br.sms"


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
//arquivos
//--------------------------------------------------------

origin	$0b2b4
insert	"../gfx/199X.1bpp"

origin	$07f2e
tilemap_199X:
insert	"../gfx/199X.map"

origin	$136d5
insert	"../gfx/fonte_00_br.1bpp"
