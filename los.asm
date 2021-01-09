assume	CS:program, DS:dane, SS:stosik

program	segment

start:
    MOV AX, dane
	MOV DS, AX

	MOV AX, stosik
	MOV SS, AX

	MOV SP, offset szczyt

	;LOSOWANIE
	MOV AH, 00h  ; interrupts to get system time
    INT 1AH      ; CX:DX now hold number of clock ticks since midnight
	
    MOV  AX, DX
    XOR  DX, DX
    MOV  BX, 25
    DIV  BX       ; here bx contains the remainder of the division - from 0 to 8
    
	XOR BX, BX
	MOV BL, DL
	MOV AL, losuj[BX]
    ADD nr_linii, AL
    ; MOV AH, 02h
	; INT 21h
	
	MOV AL, 160
	MUL nr_linii
	MOV poczatek, AX
	; MOV AH, 09h
	; INT 21h

	; MOV DX, AX
	; MOV AH, 09h
	; INT 21h

	;PAMIETAJ LINIĘ
	CLD
	MOV CX,80
	PUSH DS
	PUSH DS
	POP ES
	MOV AX, 0B800h
	MOV DS,AX
	MOV DI, OFFSET bufor
	MOV SI, poczatek
	REP MOVSW
	POP DS
	
	;POKOLORUJ
	mov cx,80   ;ile razy wypisać dany znak
	petla: 
		mov ah,9   ;nr funkcji przerwania 10h
		mov al,219   ;kod ASCII danego znaku
		mov bh,0   ;strona video (zazwyczaj 0)
		mov bl,0ah   ;nr koloru
		int 10h   ;wywołanie przerwania nr 10h
	loop petla

	;SLEEP ~1S
		MOV CX,16
		MOV AH,86h
		MOV DX, 0FFFFh
skok:	PUSH CX
		XOR CX,CX
		INT 15h
		POP CX
		LOOP skok


		; mov dx, sign
        ; mov ah, 09h
        ; int 21h

koniec: MOV AL,0h
		MOV AH,4Ch                                        ;koniec programu
		INT 21h

program	ends

dane	segment
	
	; bgkolor 00h, 01h, 02h, 03h, 04h, 05h, 06h, 07h
	; fgkolor 00h, 01h, 02h, 03h, 04h, 05h, 06h, 07h, 08h, 09h, 0ah, 0bh, 0ch, 0dh, 0eh, 0fh
	; znak equ bgkolor[0502h]
	kolor equ 0Ah
	sign equ 0520h
	bufor db 160 dup(?)
	nr_linii db 2 
	losuj db 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24 
	poczatek dw 16

dane	ends

stosik	segment

			dw 100h dup(0)
szczyt		dw 0

stosik	ends

end	start

;         mov dx, sign
;         mov ah, 09h
;         int 21h

