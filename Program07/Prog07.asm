;Zadatak 7: Napisati program koji poslije brisanja ekrana ispise jedan meni, nakon toga  u pozadini
;           prvog reda treba da se pojavi zelena traka (pozadina teksta). Zelenu traku prozivoljno
;           moguce je namjestiti strelicma. Sa pritiskom enter treba da se pojavi tekst sa crvenom
;           pozadinom. Takodje treba biti i odgovor d/n.


Prog07  Segment                         ;definicija segmenta
        assume CS:Prog07, DS:Prog07     ;pocetak CS i DS segmenta
            
Start:  mov ax, Prog07                  ;pocetak DS
        mov ds, ax
        
        mov ax, 0b800h                  ;adreas video memorije u ES registru
        mov es, ax
        
        mov ax, 3                       ;brisanje ekrana
        int 10h
        
        call write1                     ;meni za ekran
lab1:   call line                       ;zelena traka u pozadini prvog reda

lab2:   mov ax, 0100h                   ;taster
        int 16h
        
        jz  lab2                        ;ne
        
        mov ax, 0                       ;da
        int 16h
        cmp ah, 1ch                     ;enter
        jz  ent                         ;da nastaviti
        
        cmp ah, 48h                     ;^? (gore)
        jnz lab3                        ;ne, provjeriti
        
        cmp byte ptr [POINTER], 1       ;POINTER = 1
        jz  lab2
        
        dec byte ptr [POINTER]          ;POINTER - 1
        jmp lab1                        ;opet cekati na taster
        
lab3:   cmp ah, 50h                     ;dole taster
        jnz lab2                        ;ne
        
        cmp byte ptr [POINTER], 5       ;pointer inkrementirati na 5. poziciju
        jz  lab2
        
        inc byte ptr [POINTER]
        jmp lab1                        ;taster

ent:    mov cl, byte ptr [POINTER]      ;u CL vrijednost pointera
        mov si, offset ADDRESS          ;u BS adresu
        
ent1:   mov bx, [si]
        add si, 2
        loop ent1
        jmp bx                          ;skok na osnvu BX registra
        
ent2:   mov si, offset QUEST            ;pitanje
        call write2
        
ent3:   mov ax, 0100h                   ;da/ne
        int 16h
        jz  ent3
        
        mov ax, 0
        int 16h
        
        cmp ah, 31h                     ;ne izlaziti iz programa
        jz  ent4
        
        cmp ah, 17h                     ;drugi taster, testirati dalje
        jnz ent3
        
        jmp Start                       ;da, na pocetak

ent4:   mov ax, 4c00h                   ;nazad
        int 21h
        
        
pr1:    mov si, offset TXT1             ;ispisivanje teksta
        call write2
        jmp ent2
        
pr2:    mov si, offset TXT2             ;ispisivanje teksta
        call write2
        jmp ent2

pr3:    mov si, offset TXT3
        call write2
        jmp ent2
        
pr4:    mov si, offset TXT4
        call write2
        jmp ent2
        
pr5:    mov si, offset TXT5
        call write2
        jmp ent2
        

;Procedura line
    line Proc                           ;podprogram trake
        mov al, byte ptr [POINT2]       ;prdhodna vrijednost pokazivaca u AL
        mov bl, 160                     ;duzina u BL
        mov ah, 0
        
        mul bl                          ;pocetna adresa pokazivaca
        add ax, 1499
        mov di, ax
        mov cx, 21
        mov al, 7                       ;crna pozadina bijeli karakteri
        
        line1:  mov es:[di], al         ;boja
                add di, 2
                loop line1
                mov al, byte ptr [POINTER]  ;kao predhodna al nova pozicija
                mov byte ptr [POINT2], al   ;pojacna pozadina
                mov bl, 160
                mov ah, 0
                mul bl
                add ax, 1499
                mov di, ax
                mov cx, 21
                mov al, 47
                
        line2:  mov es:[di], al
                add di, 2
                loop line2

        ret                             ;nazad
    line Endp                           ;kraj podprograma
    
    
;Procedura write1
    write1 Proc                         ;podprogram za ispisivanje teksta
        mov si, offset CHOICE           ;0 ==> di + 160 (novi red)
        mov ah, 7                       ;255 ==> kraj teksta i izlaz
        mov di, 1660
        
        wr1:    push di
        
        wr2:    mov al, [si]
                inc si
                cmp al, 0
                jz  wr3
                cmp al, 0ffh
                jz  wr4
                mov es:[di], ax
                add di, 2
                jmp wr2
    
        wr3:    pop di
                add di ,160
                jmp wr1
        
        wr4:    pop di
        
        ret                             ;povratak
    write1 Endp                         ;kraj procedure/podprograma
    
    
;Podprogram/procedura write2
    write2  Proc                        ;ispisivanje teksta
        mov al, [si]                    ;izracunavanje koordinate
        mov ah, 0
        shl ax, 1
        mov di, ax
        mov al, [si+1]
        mov bl, 160
        mul bl
        add di, ax
        add si, 2
        mov ah, 12
        
        wr21:   mov al, [si]
                inc si
                cmp al, 0
                jz  wr22
                mov es:[di], ax
                add di, 2
                jmp wr21
       
        wr22:   ret
    write2 Endp
    

POINTER:    db  1
POINT2:     db  1

CHOICE:     db  "PRVI", 0
            db  "DRUGI", 0
            db  "TRECI", 0
            db  "CETVRTI", 0
            db  "PETI", 255
        
TXT1:       db  22, 5, "IZABERAN PRVI MENI", 0
TXT2:       db  21, 5, "IZABERAN DRUGI MENI", 0    
TXT3:       db  21, 5, "IZABRAN TRECI MENI", 0
TXT4:       db  21, 5, "IZABRAN CETVRTI MENI", 0
TXT5:       db  21, 5, "IZABRAN PETI MENI", 0

QUEST:      db  28, 20, "NOVI IZBOR (d/n)", 0

ADDRESS:    dw  offset pr1
            dw  offset pr2
            dw  offset pr3
            dw  offset pr4
            dw  offset pr5
            
Prog07  Ends                                ;kraj segmenta
        End Start