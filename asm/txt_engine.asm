;=======================================================================;
;									;
;                   *****    ENGINE DE TEXTO    *****			;
;									;
;=======================================================================;

; de = destino vram
; hl = ponteiro texto
; bc = offset pra subir/descer linhas

.BANK 0 SLOT 0
.ORG $0000
.SECTION "TXT_ENGINE" 	SEMISUPERFREE BANKS 0-1

txt_engine:
	rst	08h		; configurar endereço vram
	push	de		; guardar de pra calcular newline depois
	
-:	ld	a,(hl)		; carregar caractere do ponteiro (hl)
	inc	hl		; aumentar ponteiro

	check_acentos:
		cp	$f8		; byte de controle?
		jr	c,txt_normal	; se não, desenhar normal
		jr	z,txt_cedilha	; cedilha?
		cp	$fe
		jr	c,txt_acento	; acento?
		jr	z,txt_newline	; nova linha?

	; caso contrário, resta o endbyte
	txt_endbyte:
		pop	de		; voltar stack
		ret

	txt_normal:
		rst	20h		; desenhar caractere
		rst	08h		; atualizar endereço vram
		jr	-		; loop

	txt_cedilha:
		sub	$ce		; localizar cedilha
		rst	20h		; desenhar cedilha
		ld	bc,$003e
		rst	30h		; descer linha
		inc	a		; localizar perna do cedilha
		rst	20h		; desenhar perna do cedilha
		ld	bc,$0040
		rst	28h		; subir linha
		jr	-
			
	txt_acento:
		sub	$cd		; localizar acento
		ld	bc,$0042
		rst	28h		; subir linha
		rst	20h		; desenhar acento
		ld	bc,$0040
		rst	30h		; descer linha
		jr	-

	txt_newline:
		pop	de		; pegar pos inicial da linha
		ld	bc,$0080
		rst	30h		; descer linha
		push	de
		jr	-
.ENDS



; interrupts
;-----------
.BANK 0	SLOT 0
.ORGA	$20
.SECTION "RESET_20H" OVERWRITE
	out	($be),a
	inc	de
	inc	de
	ret
.ENDS

.ORGA	$28
.SECTION "RESET_28H" OVERWRITE
	ex	de,hl
	sbc	hl,bc
	ex	de,hl
	push	af
	rst	08h
	pop	af
	ret
.ENDS

.ORGA	$30
.SECTION "RESET_30H" OVERWRITE
	ex	de,hl
	add	hl,bc
	ex	de,hl
	push	af
	rst	08h
	pop	af
	ret
.ENDS
