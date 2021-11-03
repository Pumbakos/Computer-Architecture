Progr           segment
assume  cs:Progr, ds:dane, ss:stosik

start:
                mov     ax,dane
                mov     ds,ax
                mov     ax,stosik
                mov     ss,ax
                mov     sp,offset szczyt

                mov     ah,62h 
                int     21h 
                mov     es,bx 
                



                xor     bx,bx
                mov     bl,es:[128d] 
                cmp     bl,6 
                jb      brakPliku 
;muzyka 
                xor     cx,cx 
                mov     cl,bl 
                dec     cl 
                xor     si,si

wprowadzNazwe:
                mov     bl,es:[130d][si] 
                mov     plik[si],bl 
                inc     si
                dec     cl 
                cmp     cl,0 
                jg      wprowadzNazwe 

                mov     dx,offset plik
                mov     ah,3dh 
                               
                mov     al,0   
                int     21h
                mov     uchwyt,ax

odczyt:     
                mov     bx,uchwyt
                mov     cx,3 
                             
                mov     dx, offset bufor
                mov     ah,3Fh 
                int     21h
                jmp     graj

brakPliku:      
                call    wykonajBrakPliku

graj:
                xor     ax,ax
                mov     al,bufor[0] 
                                    
                mov     dl,al
                cmp     dl,'C'
                je      do
                cmp     dl,'D'
                je      re
                cmp     dl,'E'
                je      mi
                cmp     dl,'F'
                je      fa
                cmp     dl,'G'
                je      so
                cmp     dl,'A'
                je      la
                cmp     dl,'H'
                je      sii

                cmp     dl,'a'
                je      chasz
                cmp     dl,'b'
                je      d2
                cmp     dl,'c'
                je      dhasz
                cmp     dl,'d'
                je      ee
                cmp     dl,'e'
                je      ff
                cmp     dl,'f'
                je      fhasz
                cmp     dl,'g'
                je      gg

                cmp     dl,'h'
                je      ghasz
                cmp     dl,'i'
                je      aa
                cmp     dl,'j'
                je      ahasz
                cmp     dl,'l'
                je      bb
                cmp     dl,'m'
                je      cc
                cmp     dl,'n'
                je      chasz2
                cmp     dl,'Q' 
                               
                               
                je      pauza


after_reading:
                jmp     zamknij
                
                
                
                
                
            
do:             mov     ax,9121 
                        
                        
                jmp     note
re:             mov     ax,8126
                jmp     note
mi:             mov     ax,7239
                jmp     note
fa:             mov     ax,6833
                jmp     note
so:             mov     ax,6087
                jmp     note
la:             mov     ax,5423
                jmp     note
sii:            mov     ax,4831
                jmp     note
chasz:          mov     ax,4304
                jmp     note
d2:             mov     ax,4063
                jmp     note
dhasz:          mov     ax,3834
                jmp     note
ee:             mov     ax,3619
                jmp     note
ff:             mov     ax,3416
                jmp     note
fhasz:          mov     ax,3224
                jmp     note
gg:             mov     ax,3043
                jmp     note
ghasz:          mov     ax,2873
                jmp     note
aa:             mov     ax,2711
                jmp     note
ahasz:          mov     ax,2559
                jmp     note
bb:             mov     ax,2415
                jmp     note
cc:             mov     ax,2280
                jmp     note
chasz2:         mov     ax,2152
                jmp     note
pauza:        xor     ax,ax
                jmp     note

note:           push    ax 
note_1:         mov     dl,bufor[2] 
                sub     dl,'0' 
                cmp     dl,1 
                je      tune
                cmp     dl,2
                je      minim
                cmp     dl,3
                je      crotchet
                cmp     dl,4
                je      quaver
                cmp     dl,5
                je      semiquaver

                
                
tune:           mov     dlugosc,16 ;16/16
                jmp     first_play
minim:          mov     dlugosc,8 ;pół
                jmp     first_play
crotchet:       mov     dlugosc,4 ;ćwierć
                jmp     first_play
quaver:         mov     dlugosc,2 ;ósemka
                jmp     first_play
semiquaver:     mov     dlugosc,1 ;szesnastka
                jmp     first_play



first_play:
                pop     ax     
                out     42h,al 
                               
                mov     al,ah
                out     42h,al 
                
                
                in      al,61h 
                or      al,00000011b 
                out     61h,al 
                xor     bx,bx
                mov     bl,dlugosc 
outside:
                mov     cx,63535 
inside:
                dec     cx
                jne     inside
                dec     bx
                jne     outside
                

                
                in      al,61
                and     al,11111100b 
                      
                out     61h,al
                jmp     odczyt

zamknij:   

                mov     ah,3eh
                int     21h

koniec:
                mov     ah,4ch
                mov     al,0
                int     21h
wykonajBrakPliku:     
                mov     dx,offset blad
                mov     ah,09h
                int     21h
                jmp     koniec

Progr           ends

dane            segment

plik            db 15 dup(?)
uchwyt          dw 0
bufor           db 3 dup(0)
blad            db 13,10, 'Brak pliku$'
dlugosc           db 0
dane            ends

stosik          segment
                dw    100h dup(0)
szczyt          Label word
stosik          ends

end start