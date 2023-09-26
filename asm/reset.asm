;=======================================================================;
;									;
;             	*****       RESET HANDLER      	*****			;
;									;
;=======================================================================;

.BANK 0 SLOT 0

; adicionar checks de reset ao jogo 
;----------------------------------

.ORG	$0135
.SECTION	"RESET_IN1"	OVERWRITE
	rst	$10
.ENDS


; rotina que checa reset no interrupt 10h
;----------------------------------------

.ORGA	$10

.SECTION "RESET_HANDLER" OVERWRITE
reset_handler:
	in	a,($dd)
	bit	4,a		; reset está pressionado?	
	jp	z,reset		; se sim, resetar
	xor	a
	ret			; se não, voltar
.ENDS


; rotina principal de reset
;--------------------------
.SECTION "RESET" FREE

reset:
	; desligar video
	ld	a,$a0
	out	($bf),a
	ld	a,$81
	out	($bf),a

	; desligar audio
	ld	a,%10011111
	out	($7f),a
	ld	a,%10111111
	out	($7f),a
	ld	a,%11011111
	out	($7f),a
	ld	a,%11111111
	out	($7f),a

	; reset
	rst	00h
.ENDS

;=======================================================================;
;									;
;             	*****      NOVA ROTINA DE INIT_RAM  	*****		;
;									;
;=======================================================================;

; interceptar rotina que inicializa a ram
.ORGA	$00084
.SECTION "RAM_INIT_IN" 		OVERWRITE
jp	ld_ram_init
.ENDS

.SECTION "LD_RAM_INIT" 	FREE
ld_ram_init:
	
	ld	a,$06		; carregar banco da rotina
	ld	($ffff),a
	call	ram_init	; chamar a rotina

; recarregar banco anterior e voltar
	ld	a,$02
	ld	($ffff),a
	jp	$008b
.ENDS

.BANK 6 SLOT 2
.SECTION "RAM_INIT" 	FREE

ram_init:

	; guardar endereços usados pra limpar ram
	push	hl
	push	de
	
	; a ram está inicializada?
	ld	hl,ram_initstr
	ld	de,rom_initstr

-:	ld	a,(de)
	inc	de
	cpi
	jr	nz,limpar_ram00	; se não, executar limpeza total
	ld	a,l
	cp	$8f
	jr	nz,-	


	; se sim, executar limpeza parcial
	limpar_ram01:
	pop	de
	pop	hl
	
	; limpar ram até o hi score
	ld	bc,$d988-$c000
	ld	(hl),l
	ldir

	; pular hi score e limpar o resto
	ld	hl,$d990
	ld	(hl),$00
	ld	de,$d991
	ld	bc,$dfdf-$d991
	ldir

	jr	gravar_initstr


limpar_ram00:	; limpeza total
	pop	de
	pop	hl

	ld	bc,$1fef
	ld	(hl),l
	ldir

gravar_initstr:
	ld	hl,rom_initstr
	ld	de,ram_initstr
	ld	bc,$0005
	ldir
	ret

rom_initstr:
.DB	$59,$55,$52,$49,$41
.ENDS
