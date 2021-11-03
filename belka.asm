Progr           segment
                assume  cs:Progr, ds:dane, ss:stosik

start:          mov ax, dane
                mov ds, ax
                mov ax, stosik
                mov ss, ax
                mov sp, offset szczyt                
            
czas:           call ustawRej              
                int 1aH              ;przerwanie, które do cx i dx wrzuca tick count
                mov losuj, dl        ;losuj <- 1bajt ticków (0-255)

losujLinie:     call ustawRej 
                mov al, losuj        
                mov si, ax            ;wymaga ax 
                mov dl, random[si]
                mov losuj, dl         

pozycja:        mov ax, 160        ;długość jednej linii   
                mul losuj             
                mov bx, ax           

kopiuj:  		cld                ;zerujemy flage kierunku         
                push ds               
                push ds				
                pop es                 
                mov di, 0          
                mov ax, 0B800H        
                mov ds, ax            
                mov si, bx          ;w bx jest wylosowana liczba  
                mov cx, 80             
                rep movsw            ;przesyła słowo wskazywane przez ds:si pod es:di
                                    ;i modyfikuje rejestry indeksowe (+2)                 
                pop ds                
                mov es, ax          ;0B800H 
                mov di, bx          ;linia -> wylosowana liczba

                mov cx, 80			  
przyslon:       mov ah, 01110000B	;kolor tła   
				mov al, 0H            
                rep stosw           ;przesyła dane z ax w miejsce wskazane przez es:di
czekaj:         mov cx, 13H         ;nie jest 0Fh ponieważ było za szybko, zrobiłem poprawkę              
                mov dx, 00H          
                mov ax, 0
                mov ah, 86H         ;odczekuje czas zawarty w cx i dx
                int 15H


przywroc:       mov si, offset line
                mov di, bx      ;w bx jest nr linii
                mov cx, 80
                rep movsw       ;przesyła słowo wskazywane przez ds:si pod es:di
                                ;i modyfikuje rejestry indeksowe (+2)
czykoniec:    	mov ah, 01H
        		int 16H
        		jnz stop        ;1 -> wciśniety klawisz
        		jmp czas

stop:           mov ah, 4cH
                mov al, 0
                int 21H

ustawRej:       xor ax,ax
                xor bx,bx
                xor cx,cx
                xor dx,dx
                ret

Progr           ends

dane            segment

                line db 160 dup(0)
                losuj db 0
                random db 18, 21, 10, 4, 2, 19, 2, 5, 7, 10, 16, 11, 7, 21, 23, 17, 8, 19, 23, 24, 21, 2, 1, 22, 14, 11, 11, 21, 0, 7, 14, 13, 3, 5, 23, 7, 6, 10, 11, 17, 6, 21, 10, 6, 12, 4, 5, 19, 20, 8, 4, 20, 23, 8, 13, 23, 23, 15, 21, 5, 8, 10, 9, 6, 0, 11, 7, 16, 2, 22, 11, 20, 9, 21, 15, 4, 13, 19, 6, 20, 20, 4, 7, 22, 11, 16, 12, 3, 12, 0, 3, 17, 11, 12, 14, 24, 5, 19, 4, 19, 15, 4, 10, 2, 15, 24, 6, 3, 8, 16, 16, 8, 21, 19, 3, 0, 6, 21, 12, 12, 11, 13, 11, 24, 3, 24, 0, 4, 0, 2, 9, 23, 16, 13, 0, 4, 15, 10, 1, 23, 13, 12, 17, 8, 4, 4, 24, 2, 15, 10, 13, 3, 6, 18, 8, 16, 10, 16, 2, 11, 1, 11, 22, 20, 0, 10, 14, 6, 18, 16, 24, 3, 19, 20, 7, 9, 11, 16, 12, 13, 8, 23, 23, 15, 19, 0, 11, 22, 16, 23, 13, 11, 2, 1, 23, 4, 13, 11, 2, 23, 19, 22, 13, 9, 15, 11, 14, 10, 1, 12, 12, 5, 20, 7, 23, 21, 1, 14, 7, 16, 5, 24, 16, 16, 7, 10, 7, 16, 4, 14, 7, 14, 3, 14, 13, 7, 3, 21, 23, 19, 7, 5, 24, 24, 20, 14, 11, 2, 19, 0, 0, 9, 6, 1, 15, 9

dane            ends

stosik          segment
                dw    100h dup(0)
szczyt          Label word
stosik          ends

end start
