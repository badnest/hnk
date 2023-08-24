//---------------------------------------
//reset handler
//---------------------------------------


//adicionar checks de reset ao jogo
//---------------------------------

origin	$0166d
rst	10h

origin	$00135
rst	10h


//rotina principal de reset no vetor 10h
//--------------------------------------

origin	$00010
vetor_reset:

//reset está pressionado?
in	a,($dd)
bit	4,a		
jr	nz,+		//se sim, resetar

	//desligar video
	ld	a,$a0
	out	($bf),a
	ld	a,$81
	out	($bf),a

	//desligar audio
	ld	a,%10011111
	out	($7f),a
	ld	a,%10111111
	out	($7f),a
	ld	a,%11011111
	out	($7f),a
	ld	a,%11111111
	out	($7f),a

	//reset
	rst	00h

//se reset não estiver pressionado, voltar
+;xor	a
ret



//---------------------------------------
//manter hi score após reset
//---------------------------------------


//interceptar rotina que inicializa a ram
//---------------------------------------

origin	$00084
jp	ram_init_load

origin	$07f7a
ram_init_load:

//carregar banco onde está a rotina
	ld	a,$06
	ld	($ffff),a

//chamar a rotina
	call	$be36

//recarregar banco anterior e voltar
	ld	a,$02
	ld	($ffff),a
	jp	$008b


//nova rotina de inicialização de ram
//-----------------------------------

origin	$1be36
ram_init:

//guardar endereços usados pra limpar ram
push	hl
push	de

//a ram está inicializada?
ld	hl,ram_initstr
ld	de,rom_initstr

	-;ld	a,(de)
	inc	de
	cpi
	jr	nz,limpar_ram00	//se não, executar limpeza total
	ld	a,l
	cp	$8f
	jr	nz,-	


//se sim, executar limpeza parcial
limpar_ram01:
pop	de
pop	hl

//limpar ram até o hi score
	ld	bc,$d988-$c000
	ld	(hl),l
	ldir

//pular hi score e limpar o resto
	ld	hl,$d990
	ld	(hl),$00
	ld	de,$d991
	ld	bc,$dfef-$d991
	ldir

jr	gravar_initstr


limpar_ram00:	//limpeza total
pop	de
pop	hl

	ld	bc,$1fef
	ld	(hl),l
	ldir


//gravar initstr na ram
//---------------------

gravar_initstr:
ld	hl,rom_initstr
ld	de,ram_initstr
ld	bc,$0005
ldir
ret


rom_initstr:
db	$59,$55,$52,$49,$41
