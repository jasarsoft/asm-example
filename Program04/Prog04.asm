;Zadatak 4: Program treba da stampa tekst iz memorije. Duzina teksta je proizvoljna,
;           kraj teksta je oznacena sa ASCII karakterom, koji ne moze da bude ni
;           slovo ni broj, na primjer 0.

Prog04  Segment                     ;definicija segmenta
        assume CS:Prog04, DS:Prog04 ;pocetak CS i DS segmenta

Start:  mov ax, Prog04              ;pocetak na DS
        mov ds, ax
        
        mov ds, ax
        mov ax, 0b800h              ;adreas video memorije u ES
        mov es, ax
        
        mov al, byte ptr [Y]        ;y
        mov ah, 0
        mov bl, 160                 ;0. red 80*2 bajta
        mul bl                      ;ax = al * bl
        mov di, ax                  ;upisati u di
        
        mov al, byte ptr [X]        ;x
        mov ah, 0
        mov bl, 2                   ;x * 2
        mul bl
        add di, ax                  ;pozicija karaktera u memoriji
        
        mov ah, byte ptr [BOJA]     ;kod boje
        mov si, offset TEKST        ;addresa teksta u SI
        
cikl:   mov al, [si]                ;podatak u AL registru
        cmp al, 0                   ;kraj teksta
        jz  kraj                    ;kraj
        mov es:[di], ax             ;karakter u video memoriji
        add di, 2                   ;sljedeca pozicija u video memoriji
        inc si                      ;sljedeci karakter
        jmp cikl                    ;nastavi dalje
        
kraj:   mov ax, 4c00h               ;nazad
        int 21h

X:      db  30                      ;pozicija teksta
Y:      db  12
TEKST:  db  "PROGRAM 4", 0
BOJA:   db  7

Prog04  Ends                        ;kraj segmenta
        End Start