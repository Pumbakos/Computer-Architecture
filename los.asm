assume	CS:program, DS:dane, SS:stosik

program	segment

start:

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
    ADD los, AL
    MOV AH, 02h
	INT 21h
	
	;PAMIETAJ LINIĘ
	

	;SLEEP ~1S
		MOV CX,16
		MOV AH,86h
		MOV DX, 0FFFFh
skok:	PUSH CX
		XOR CX,CX
		INT 15h
		POP CX
		LOOP skok

	MOV DL,los
	INT 02h
	INT 21h

koniec: MOV AL,0h
		MOV AH,4Ch                                        ;koniec programu
		INT 21h

program	ends

dane	segment

	bufor db 160 dup(?)
	los db 2 
	losuj db 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24 

dane	ends

stosik	segment



stosik	ends

end	start
