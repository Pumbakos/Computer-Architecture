assume	CS:program, DS:dane, SS:stosik

program	segment

start:

	MOV AH, 00h  ; interrupts to get system time
    INT 1AH      ; CX:DX now hold number of clock ticks since midnight

    MOV  AX, DX
    XOR  DX, DX
    MOV  BX, 25
    DIV  BX       ; here bx contains the remainder of the division - from 0 to 8
    ;ADD  DL, '0'  ; to ascii from '0' to '8'
	XOR BX, BX
	MOV BL, DL
	MOV AL, losuj[BX]
    ADD los, AL
    MOV AH, 02h
	INT 21h
	MOV DL, losuj[BX]
	MOV AH, 02h
	INT 21h



koniec: MOV AL,0h
		MOV AH,4Ch                                        ;koniec programu
		INT 21h

program	ends

dane	segment

	bufor db 160 dup(?)
	los db 1 
	;losuj db 8, 18, 12, 4, 0, 8, 2, 6, 6, 19, 11, 1, 18, 5, 8, 18, 5, 16, 19, 7, 17, 22, 22, 18, 5, 23, 24, 17, 14, 19, 1, 2, 15, 24, 10, 20, 19, 10, 12, 9, 13, 1, 10, 11, 1, 6, 4, 22, 0, 16, 15, 19, 9, 0, 4, 5, 2, 1, 18, 9, 4, 10, 24, 20, 6, 7, 22, 13, 15, 9, 19, 5, 20, 24, 2, 19, 22, 24, 21, 24, 6, 9, 18, 20, 7, 6, 9, 4, 2, 15, 8, 13, 1, 15, 5, 12, 20, 6, 13, 11, 2, 17, 6, 18, 12, 1, 10, 5, 8, 21, 6, 14, 22, 14, 22, 0, 13, 6, 18, 12, 1, 12, 13, 4, 20, 0, 0, 13, 12, 9, 23, 22, 21, 5, 15, 7, 3, 1, 3, 22, 8, 18, 13, 13, 10, 18, 13, 20, 11, 21, 12, 10, 9, 12, 18, 3, 23, 0, 24, 5, 8, 2, 20, 12, 2, 10, 5, 10, 0, 21, 17, 10, 10, 22, 24, 6, 8, 11, 19, 0, 15, 5, 7, 24, 11, 6, 2, 18, 15, 20, 18, 23, 14, 6, 19, 5, 5, 7, 18, 24, 20, 10, 23, 5, 5, 20, 20, 5, 19, 23, 23, 3, 24, 10, 16, 6, 19, 18, 15, 12, 4, 10, 24, 4, 10, 7, 17, 5, 12, 23, 1, 20, 12, 22, 20, 3, 3, 8, 17, 5, 17, 1, 2, 1, 24, 4, 3, 2, 11, 5, 20, 16, 19, 6, 5, 5, 4 
	losuj db 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24 

dane	ends

stosik	segment



stosik	ends

end	start
