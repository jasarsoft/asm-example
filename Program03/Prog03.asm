;Zadatak 3: Ispisati jedan karakter na monitoru, pozicija karaktera je data sa x i y
;           koordinatama, program treba da izracuna adresu u video memoriji.

Prog03  Segment                         ;definicija segmenta
        assume CS:Prog03, DS:Prog03     ;pocetak CS i DS segmenta

Start:  mov ax, Prog03                  ;pocetak na DS
        mov ds, ax
        
        mov ds, ax
        mov ax, 0b800h                  ;adreas video memorije u ES
        mov es, ax
        
        mov al, byte ptr [Y]            ;y
        mov ah, 0
        mov bl, 160                     ;0 red 80*2 bajta
        mul bl                          ;ax = al * bl
        mov di, ax                      ;upis u dl
        
        mov al, byte ptr [X]            ;x
        mov ah, 0
        mov bl, 2                       ;x*2
        mul bl
        add di, ax                      ;pozicija karaktera u memoriji
        
        mov al, byte ptr [KARAKT]       ;ASCII kod karaktera
        mov ah, byte ptr [BOJA]         ;kod boje
        
        mov es:[di], ax                 ;upisivanje karaktera u memoriju
        
        mov ax, 4c00h                   ;nazad
        int 21h
        
X:      db 40
Y:      db 12
KARAKT: db "X"
BOJA:   db 7

Prog03  Ends                            ;kraj segmenta
        End Start