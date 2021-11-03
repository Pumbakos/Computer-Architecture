Progr           segment
                assume  cs:Progr, ds:dane, ss:stosik

start:          mov ax, dane
                mov ds, ax
                mov ax, stosik
                mov ss, ax
                mov sp, offset szczyt

czas:           call czysc
                int 1aH               ;przerwanie, które do cx i dx wrzuca tick count
                mov losuj, dl         ;losuj <- 1bajt ticków (0-255)

losujLinie:     call czysc
                mov al, losuj         ;losuj stanowi nasz indeks
                mov si, ax            ;si <- indeks
                mov dl, random(si)    ;wyciągnięcie 'randomowej' liczby z tablicy
                mov losuj, dl         ;losuj <- random(si)

pozycja:        mov ax, 160           ;160B ma cały wiersz (80 znaków, 1 znak = 2B)
                mul losuj             ;mnożenie losuj * 160 (żeby okreslić pozycję wylosowanej linii)
                mov bx, ax            ;bx <- przemnożony losuj

kopiuj:  		cld                   ;zerowanie znacznika kierunku zeby program ogarnał że ma lecieć w przod a nie tył (tak bylo w instrukcji)
                push ds               ;? zrzucanie ze stosu ale jak to dziala to nwm, po prostu te juz przypisane wartosci zrzuca w wylosowane miejsce
                push ds				
                pop es                ;es ze stosu, do przechowywania zawartości zasłoniętych linii
                mov di, 0             ;di <- 0 czyszczenie di
                mov ax, 0B800H        ;wartosc poczatku do ax
                mov ds, ax            ;ds <- 0B800H
                mov si, bx            ;si <- bx
                mov cx, 80            ;80 znaków na jeden wiersz (do repa potrzebne, zeby sie wykonał 80 razy)
                rep movsw             ;wykonanie cx razy (80) opepracji movsw, przeniesienie znaku z ds:si do es:di
                                      ;instrukcja przepisuje dane wskazywane przez DS:SI pod adres ES:DI, a następnie modyfikują rejestry indeksowe.
                pop ds                ;??
                mov es, ax            ;es <- 0B800H start od punktu poczatkowego
                mov di, bx            ;di <- bx, czyli losuj * 160, przesunięcie o tyle bajtów ile linii wylosowanych

                mov cx, 80			   ;czas a raczej ile jest ||||| znakow do pokolorowania
przyslon:       mov ah, 01110000B	   ;kolor
				mov al, 0H             ; dopelnienie rejestru ?
                rep stosw              ; no i wypisujemy ten kolorek

czekaj:         mov cx, 0FH                ;ustawienie czasu oczekiwania na sekunde
                mov dx, 00H          
                mov ax, 0
                mov ah, 86H
                int 15H


przywroc:       mov si, offset line   ;si <- offset do zmiennej line
                mov di, bx            ;di <- bx w bx cały czas jest 160*nr linii
                mov cx, 80            ;iterator do repa
                rep movsw             ;nie do konca wiem jak dziala

czykoniec:    	mov ah, 01H
        		int 16H
        		jnz stop
        		jmp czas

stop:           mov ah, 4cH
                mov al, 0
                int 21H

czysc:       mov ax, 0  ;ustawienie rejestru -> czyszczenie
                mov bx, 0
                mov cx, 0
                mov dx, 0
                ret

Progr           ends

dane            segment
                line db 160 dup(0)
                random db 18, 21, 10, 4, 2, 19, 2, 5, 7, 10, 16, 11, 7, 21, 23, 17, 8, 19, 23, 24, 21, 2, 1, 22, 14, 11, 11, 21, 0, 7, 14, 13, 3, 5, 23, 7, 6, 10, 11, 17, 6, 21, 10, 6, 12, 4, 5, 19, 20, 8, 4, 20, 23, 8, 13, 23, 23, 15, 21, 5, 8, 10, 9, 6, 0, 11, 7, 16, 2, 22, 11, 20, 9, 21, 15, 4, 13, 19, 6, 20, 20, 4, 7, 22, 11, 16, 12, 3, 12, 0, 3, 17, 11, 12, 14, 24, 5, 19, 4, 19, 15, 4, 10, 2, 15, 24, 6, 3, 8, 16, 16, 8, 21, 19, 3, 0, 6, 21, 12, 12, 11, 13, 11, 24, 3, 24, 0, 4, 0, 2, 9, 23, 16, 13, 0, 4, 15, 10, 1, 23, 13, 12, 17, 8, 4, 4, 24, 2, 15, 10, 13, 3, 6, 18, 8, 16, 10, 16, 2, 11, 1, 11, 22, 20, 0, 10, 14, 6, 18, 16, 24, 3, 19, 20, 7, 9, 11, 16, 12, 13, 8, 23, 23, 15, 19, 0, 11, 22, 16, 23, 13, 11, 2, 1, 23, 4, 13, 11, 2, 23, 19, 22, 13, 9, 15, 11, 14, 10, 1, 12, 12, 5, 20, 7, 23, 21, 1, 14, 7, 16, 5, 24, 16, 16, 7, 10, 7, 16, 4, 14, 7, 14, 3, 14, 13, 7, 3, 21, 23, 19, 7, 5, 24, 24, 20, 14, 11, 2, 19, 0, 0, 9, 6, 1, 15, 9
                losuj db 0
dane            ends

stosik          segment
                dw    100h dup(0)
szczyt          Label word
stosik          ends

end start
