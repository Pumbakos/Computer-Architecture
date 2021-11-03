TC equ 34546    ;1.19MHz/33Hz
TD equ 30811    ;1.19MHz/37Hz
TE equ 27805    ;1.19MHz/41Hz
TF equ 25909    ;1.19MHz/44Hz
TG equ 23265    ;1.19MHz/49Hz
TA equ 20727    ;1.19MHz/55Hz
TH equ 18387    ;1.19MHz/62Hz
TP equ 1        ;pauza

Progr           segment
                assume  cs:Progr, ds:dane, ss:stosik

                jmp start

zamknijPlik:    mov ah, 3EH             ;Funkcja do zamykania pliku, wymaga w bx "file handle", czyli plik pliku
                mov bx, idPliku
                int 21H
                ret

brakPliku:      mov dx, offset blad     ;wyświetlanie błędu o braku wprowadzonej nazwy pliku
                mov ah, 09H
                int 21H
                jmp koniec

koniec:         call zamknijPlik        ;koniec programu, który najpierw zamyka idPliku a potem
                mov ah, 4cH             ;wywołuje przerwanie 21H z argumentami 4CH i 0 (normal termination)
                mov al, 0
                int 21h

start:          mov ax,dane
                mov ds,ax
                mov ax,stosik
                mov ss,ax
                mov sp,offset szczyt

                xor ax,ax
                xor bx,bx
                xor cx,cx
                xor dx,dx
                                        ;62h -> pobranie adresu PSP, PSP oddziela argument od programu
wezDlugosc:     mov ah, 62H             ;Zwraca do bx adres segmentu PSP -> program segment prefix -> przechowuje stan w programie
                int 21H                 ;w psp znajduje sie nazwa pliku ktorą wprowadzilismy
                mov es, bx              ;oraz długość (pod adresem 128d), reszta znajduje sie
                mov al, es:[128d]       ;za adresem 128d
                cmp al, 0               ;sprawdzamy, czy nazwa pliku została podana
                je brakPliku            ;jeśli nie, to błąd

                mov cl, al              ;przenosimy dlugosc do cl, potrzebne do petli
                dec cl                  ;jedna iteracja mniej bo ostatni znak to enter
                mov si, 0               ;zerujemy si
pobierzNazwe:   mov al, es:[129d+si+1]  ;przenosimy do al pojedyncza litere nazwy pliku, omijamy space
                xor ah, ah              ;zerujemy a
                mov bx, offset plik     ;do bx ładujemy adres efektywny
                mov dane:[bx+si], al    ;do zmiennej plik dodajemy literkę z nazwy
                inc si
                loop pobierzNazwe

                xor ax, ax
otworzPlik:     mov ah, 3dH             ;otwarcie pliku
                mov al, 0               ;tryb pracy - 0 tylko do odczytu
                mov dx, offset plik     ;w dx jest nazwa pliku
                int 21H                 
                mov idPliku, ax         ;jeśli idPliku istnieje to w ax dostaniemy 16bitową wartość zwaną "file handle"

czytajPlik:     mov ah, 3FH             ;Funkcja do odczytu pliku, wymaga: bx - idPliku, cx - liczba bajtów do odczytu, dx - gdzie zapisujemy
                xor al, al              ;zerujemy dla pewnosci
                mov bx, idPliku
                mov cx, 3               ;3 bajty do przeczytania, na nute, nr. oktawy i długość
                mov dx, offset bufor    ;w zmiennej bufor przechowywane będzie 3 bajty z pliku
                int 21H

pobierzNute:    mov bx, offset bufor    ;bx<- adres pobranych 3 bajtów
                mov dl, dane:[bx]       ;nuta jest na 1 pozycji
                cmp dl, 'Q'             ;Q, to koniec programu
                je koniec               

ustawNute:      cmp dl, 'C'             
                je do                   
                cmp dl, 'D'
                je re
                cmp dl, 'E'
                je mi
                cmp dl, 'F'
                je fa
                cmp dl, 'G'
                je so
                cmp dl, 'A'
                je la
                cmp dl, 'H'
                je zi
                cmp dl, 'P'
                je pa

do:             mov oktawa, TC          
                jmp ustawOktawe         

re:             mov oktawa, TD
                jmp ustawOktawe

mi:             mov oktawa, TE
                jmp ustawOktawe

fa:             mov oktawa, TF
                jmp ustawOktawe

so:             mov oktawa, TG
                jmp ustawOktawe

la:             mov oktawa, TA
                jmp ustawOktawe

zi:             mov oktawa, TH
                jmp ustawOktawe

pa:             mov oktawa, TP
                jmp rownaj

ustawOktawe:    mov bx, offset bufor        ;do bx wrzucamy adres zmiennej bufor (w której trzymamy 3 bajty z pliku)
                mov cl, dane:[bx+1]         ;pobranie numeru oktawy
                sub cl, 30H                 ;Przesunięcie zakresu ze znaku HEX na znak w DEC
                shr oktawa, cl              ;Przesunięcie logiczne w prawo (do zmiany oktawy)

ustawCzas:      mov bx, offset bufor
                mov cl, dane:[bx+2]         ;Pobranie czasu
                sub cl, 30H                 ;Przesusnięcie z HEX do DEC
                xor ch, ch                  ;zerowanie ch
                mov dlugosc, cx

grajMuzyke:     mov ax, oktawa
                mov dx, 42h                 ;Adres układu 8253
                out dx, al                  ;wysyłamy do układu oktawę
                mov al, ah
                out dx, al

wlaczGlosnik:   mov dx, 61h                 ;61H to adres układu 8255, tu włączymy dźwięk
                in al, dx                   ;pobranie wartości portu do AL
                or al, 00000011B            ;1 na najmłodszych bitach odpowiada za włączenie głośnika
                out dx, al                  ;wysłanie tego co ustawiliśmy

rownaj:         jmp dopasujCzas             ;dopasowanie czasu do nuty
odczekaj:       mov dx, 0
                mov ah, 86h
                int 15h                     ;15h to przerwanie, przez które odczekamy chwile czasu, przyjmuje cx i dx jako argument

wylGlosnik:     mov dx, 61H                 ;61H - układ 8255
                in al, dx                   ;pobieramy to co jest w tym układzie
                and al, 11111100B           ;zerujemy dwa najmłodsze bity by wyłączyć głośnik
                out dx, al                  ;wysyłamy spowrotem zmodyfikowaną już zawartość
                jmp czytajPlik              ;wracamy do pobrania kolejnych 3 bajtów z pliku

dopasujCzas:    cmp dlugosc, 1
                je calaNuta
                cmp dlugosc, 2
                je polNuta
                cmp dlugosc, 4
                je cwiercNuta
                cmp dlugosc, 8
                je osemka

calaNuta:       mov cx, 8
                jmp odczekaj

polNuta:        mov cx, 4
                jmp odczekaj

cwiercNuta:     mov cx, 2
                jmp odczekaj

osemka:         mov cx, 1
                jmp odczekaj

Progr           ends

dane            segment

blad            db 'Brak pliku', '$'
plik            db 128 dup(0)
bufor           db 3 dup(0)
oktawa          dw 0
dlugosc         dw 0
idPliku         dw 0

dane            ends

stosik          segment

szczyt          Label word

stosik          ends

end start