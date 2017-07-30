;Zadatak 5: Program treba da realizuje logicku I funkciju izmedju dva osmobitna broja
;           zatim treba da ispise brojeve i rezultat. Program mora da brise ekran.
;           Za realizaciju ponovljenih dijelova treba koristiti podprogram (ispisivanje teksta, brojeva)

Prog05  Segment                     ;definicija segmenta
        assume CS:Prog05, DS:Prog05 ;pocetak CS i DS segmenta

Start:  mov ax, Prog05              ;pocetak na DS
        mov ds, ax
        
        mov ax, 0b800h              ;adreas video memorije u ES
        mov es, ax
        
        mov ax, 3                   ;brisanje ekrana
        int 10h
        
        mov di, 0*160               ;pozicija 1. teksta (0,0)
        mov si, offset TEKST1       ;pocetna adreas TEKST1
        call tekstisp               ;ispisivanje teksta
        
        mov bl, byte ptr [BR1]      ;prvi broj
        call brojisp                ;ispisivanje broja
        
        mov di, 1*160               ;pozicija 2. teksta (1,0)
        mov si, offset TEKST2       ;pocetna adreas TEKST2
        call tekstisp               ;ispisivanje teksta
        
        mov bl, byte ptr [BR2]      ;drugi broj
        call brojisp                ;ispisivanje broja
        
        mov di, 2*160               ;pozicija teksta REZULTAT
        mov si, offset TEKST3       ;pocetna adreas TEKST3
        call tekstisp               ;ispisivanje teksta
        
        mov bl, byte ptr [BR1]      ;prvi broj
        and bl, byte ptr [BR2]      ;BR1 i BR2
        call brojisp                ;ispisivanje broja
        
        mov ax, 0                   ;cekanje
        int 16h

KRAJ:   mov ax, 4c00h               ;nazad
        int 21h
        
;TEKSTISP Procedura-------------
    tekstisp Proc               ;rutina za ispisivanje teksta
        mov cx, 16              ;tekst ima ukupno 16 karaktera
        mov ah, 15              ;crna pozadina bijeli karakter

    cikl1:  mov al, [si]        ;karakter u al
            mov es:[di], ax     ;karakter u video memoriji
            add di, 2           ;sljedeca pozicija
            inc si              ;sljedeci karakter
            loop cikl1          ;cx = cx - 1 i skok ako je cx <> 0
            ret                 ;povratak u glavni program
    tekstisp Endp               ;kraj podprograma
    
;BROJISP Procedura--------------
    brojisp Proc                ;podprogram za ispisivanje broja
        add di, 6               ;+ 3 pozicije
        mov cx, 8               ;broj je osmobitni
        mov ah, 15              ;crna pozadina bijeli kvadrant
    
        cikl2:  mov al, 48      ;ASCII kod nule (0)
                shl bl, 1       ;CY <== d7 bit
                jnc izl2        ;ako je nula skok na izlaz 2
                mov al, 49      ;ASCII kod jedinice (1)
        
        izl2:   mov es:[di], ax ;broj u video memoriji
                add di, 2       ;sljedeca pozicija
                loop cikl2      ;cx = cx - 1 ako je cx <> 0
                ret             ;povratak u glavni program
    brojisp Endp                ;kraj podprograma
    
        

TEKST1: db "1. BAJT     :"
TEKST2: db "2. BAJT     :"
TEKST3: db "REZULTAT    :"
BR1:    db 01011101b
BR2:    db 10101011b

Prog05  Ends                    ;kraj segmenta
        End Start  
        