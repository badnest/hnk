arch	sms.cpu
endian	lsb
insert	"..\rom\hnk.sms"
output	"..\rom\hnk_br.sms",create

//;_GRÁFICOS__________________________________________________________

origin $000136D5
insert	"..\gfx\fonte_00_br.1bpp"


//;_MODIFICAÇÕES NO CÓDIGO____________________________________________

origin $00000D4A
nop					//;pular a tela sega mark iii (incompleto)


