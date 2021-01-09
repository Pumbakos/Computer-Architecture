assume 		cs:program, ds:dane, ss:stosik

program		segment

err1:			mov dx,offset blad1
					mov ah,09h
					int 21h
					jmp koniec

err2:			mov dx,offset blad2
					mov ah,09h					;wyświetl string
					int 21h
					jmp koniec

start:
					mov ax,dane											;deklaracja zmiennych
					mov ds,ax
					mov ax,stosik
					mov ss,ax
					mov sp,offset szczyt

pobierz:	mov dx,offset znakZach		;pobranie liczby od użytkownika
					mov ah,09h
					int 21h
					mov dx,offset max
					mov ah,0Ah			;przyjmuje string
					int 21h

					cmp len,0h			;sprawdź czy wpisano minimum jeden znak
					je err1

					xor bx,bx			;sprawdza, czy liczba nie za duża
					xor cx,cx
					mov cl,len
petla1:		xor ax,ax			;iteruje po tablicy z wprowadzonymi znakami
					mov al,znaki[bx]
					sub al,'0'
					push ax

					cmp ax,10			;sprawdza, czy jest to znak 0-9
					jnc err1

					mov ax,suma
					mov dx,10d
					mul dx
					jc err2

					mov suma,ax
					pop ax
					add suma,ax
					jc err2

					inc bx					;iterator
					loop petla1

					xor bx,bx			;wstaw '$' na końcu tablicy
					mov bl,len
					mov znaki[bx],'$'

					mov dx,offset dziesietna	;wyświetl liczbe dziesiętnie
					mov ah,09h
					int 21h
					mov dx,offset znaki
					mov ah,09h
					int 21h

					mov dx,offset binarna		;przelicz i wyświetl liczbe binarnie
					mov ah,09h
					int 21h
					mov cx,16
					mov ah,02h					;display output dl
					mov dx,suma
					rol dx,1
					push dx
petla2:		and dx,0000000000000001b
					add dx,'0'
					int 21h
					pop dx
					rol dx,1
					push dx
					loop petla2

					mov dx,offset heksadecymalna	;przelicz i wyświetl liczbe heksadecymalnie
					mov ah,09h
					int 21h
					mov ah,02h
					mov cx,4
					mov bx,suma
					rol bx,4
					push bx
petla3:		and bx,0000000000001111b
					mov dl,hex[bx]
					int 21h
					pop bx
					rol bx,4
					push bx
					loop petla3

koniec:		mov al,0h
					mov ah,4Ch										;koniec programu
					int 21h

program		ends

dane			segment

		max		db	6
		len		db	?
		znaki		db	6 dup(0)
		suma		dw	0
		hex		db	'0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F','$'

		znakZach	db	13,10,'Podaj liczbe do konwersji (0-65535):$'
		dziesietna	db	13,10,'Liczba w notacji dziesietnej:$'
		binarna		db	13,10,'Liczba w notacji binarnej:$'
		heksadecymalna	db	13,10,'Liczba w notacji heksadecymalnej:$'
		blad1		db	13,10,'Niepoprawne dane!$'
		blad2		db	13,10,'Liczba poza zakresem!$'

dane		ends

stosik		segment

		dw 100h dup(0)

szczyt		dw 0

stosik		ends

end start
