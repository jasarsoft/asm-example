;Zadatak 2: Na monitoru u 7. redu i 13. koloni treba ispisati slovo X

Prog02  Segment                         ;definija segmenta
        assume CS:Prog02, DS:Prog02     ;pocetak CS i DS segmenta
          
Start:  mov ax, Prog02                  ;pocetak na DS
        mov ds, ax
        
        mov ds, ax
        mov ax, 0b800h                  ; adreas video memorije u es registru
        mov es, ax
        
        mov di, 1146                    ; offset adreas u DI
        
        mov al, "X"                     ;slovo X u AL registru
        mov ah, 7                       ;crna pozadina, bijeli karakter
        mov es:[di], ax                 ;slovo u video memoriji
        
        mov ax, 4c00h                   ;nazad
        int 21h
        
Prog02  Ends
        End Start                       ;kraj segmenta