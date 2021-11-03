	 ORG 800H
	 JMP START
PYTANIE 	 LXI H,NEXT_1
	 RST 3
	 LXI H,NEXT_2
	 RST 3
	 LXI H,CHOISE
LOOP 	 RST 3
	 RST 2
	 CPI 'G'
	 JZ START
	 CPI 'g'
	 JZ START
	 CPI 'E'
	 JZ END
	 CPI 'e'
	 JZ END
	 JMP LOOP
START 	 LXI H,LICZBA ;przesylam napis do H
	 RST 3 ;wyswietlam napis
	 RST 5 ;pobieram do DE liczbe hex
	 MOV C,E ;E -> C
	 MOV B,D ;D -> B
	 LXI H,OPER
	 RST 3
;-----------------------WYBOR OPERATORA
SKOK 	 RST 2 ;pobieram znak do A
	 CPI '+'
	 JZ DODAW
	 CPI '-'
	 JZ ODEJM
	 CPI 'N'
	 JZ NEGAC
	 CPI 'n'
	 JZ NEGAC
	 JMP SKOK
;----------------------------DODAWANIE
DODAW 	 LXI H,LICZBA ;przesylam napis do H
	 RST 3 ;wyswietlam napis
	 RST 5 ;pobieram do DE liczbe hex
	 LXI H,WYNIK
	 RST 3
	 MOV A,C ;C -> A
	 ADD E ;A + E /// E+C
	 MOV C,A ;zapisuje wynik w C
	 MOV A,B
	 ADC D
	 MOV B,A
	 JNC W_O ;jesli nie ma przeniesienia -> skok do wypisanie wyniku , jesli bylo wykonaj MVI
	 MVI A,01H
	 RST 4
	 JMP W_O
;----------------------------ODEJMOWANIE
ODEJM 	 LXI H,LICZBA ;przesysam napis do H
	 RST 3 ;wyswietlam napis
	 RST 5 ;pobieram do DE liczbe hex
	 LXI H,WYNIK
	 RST 3
	 MOV A,C
	 CMP E
	 JZ NC_MB ;NoCarryMlodszyBajt
	 JC C_MB ;CarryMlodszyBajt
NC_MB 	 MOV A,B
	 CMP D
	 JZ NC_SB ;NoCarryStarszyBajt
	 JC C_SB
NC_SB 	 MOV A,C
	 SUB E
	 MOV C,A
	 MOV A,B
	 SUB D
	 MOV B,A
	 JMP W_O ;WynikOdejmowania
C_MB 	 CMC
	 MOV A,B
	 CMP D
	 JZ NC_SB
	 JC C_SB
	 MOV A,C
	 SUB E
	 MOV C,A
	 MOV A,B
	 SBB D
	 MOV B,A
	 JMP W_O
C_SB 	 CMC
	 JMP REVERT
REVERT 	 MOV A,E
	 SUB C
	 MOV C,A
	 MOV A,D
	 SBB B
	 MOV B,A
	 JMP W_O_U ;WynikOdejmowaniaUjemny
W_O_U 	 LXI H,MINUS
	 RST 3
W_O 	 MOV A,B
	 RST 4
	 MOV A,C
	 RST 4
	 JMP PYTANIE
;-------------------------------NEGACJA
NEGAC 	 LXI H,NAP3
	 MOV A,E
	 CMA
	 MOV C,A
	 MOV A,D
	 CMA
	 MOV B,A
	 LXI H,WYNIK
	 RST 3
	 JMP W_O
END 	 LXI H,KONIEC
	 RST 3
	 HLT
OPER 	 DB 13,10,'Wprowadz operator: @'
NAP1 	 DB 13,10,'Dodawanie@'
NAP2 	 DB 13,10,'Odejmowanie@'
NAP3 	 DB 13,10,'Negacja@'
LICZBA 	 DB 13,10,'Wprowadz liczbe: @'
NEXT_1 	 DB 13,10,'G - rozpoczyna ponownie program @'
NEXT_2 	 DB 13,10,'E - konczy prace programu @'
CHOISE 	 DB 13,10,'>> @'
WYNIK 	 DB 13,10,'WYNIK: @'
MINUS 	 DB 13,10,'-@'
KONIEC 	 DB 13,10,'---KONIEC PROGRAMU--- @'
