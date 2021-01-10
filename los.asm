assume	CS:program, DS:dane, SS:stosik

program	segment

start:
    MOV AX, dane
	MOV DS, AX

	MOV AX, stosik
	MOV SS, AX

	MOV SP, offset szczyt

pocz:
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
	
	MOV AX, 160
	MUL nr_linii
	MOV poczatek, AX

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

	;USTAW KURSOR NA WYLOSOWANĄ LINIĘ
	MOV AH, 02h
	MOV BH, 0
	MOV DH, nr_linii
	MOV DL, 0
	INT 10h

	;POKOLORUJ
	MOV cx,80   ;ile razy wypisać dany znak
	petla: 
		MOV AH,9   ;nr funkcji przerwania 10h
		MOV AL,219   ;kod ASCII danego znaku
		MOV BH,0   ;strona video (zazwyczaj 0)
		MOV BL,0b9h   ;nr koloru
		int 10h   ;wywołanie przerwania nr 10h
	LOOP petla

	;SLEEP ~1S
		MOV CX,16
		MOV AH,86h
		MOV DX, 0FFFFh
skok:	PUSH CX
		XOR CX,CX
		INT 15h
		POP CX
		LOOP skok

	;PRZYWRÓC LINIĘ
	CLD
	MOV CX,80
	MOV AX, 0B800h
	MOV ES,AX
	MOV DI, poczatek
	MOV SI, OFFSET bufor
	REP MOVSW

	;SPRAWDZA NACIEŚNIECIE KLAWISZA
	MOV AH, 01h
	INT 16h

	;JEŻELI NIE KLAWISZ WCIŚNIĘTO Z=1, POWRÓT NA POCZĄTEK
	JZ pocz

koniec: MOV AL,0h
		MOV AH,4Ch                                        ;koniec programu
		INT 21h

program	ends

dane	segment
	
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

