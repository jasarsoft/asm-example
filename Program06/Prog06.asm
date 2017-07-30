;Zadatak 6: Vrijeme ispisa iz memorije racunara

Prog06  Segment                     ;definicija segmenta
        assume CS:Prog06, DS:Prog06 ;pocetak CS i DS segmenta

Start:  mov ax, Prog06              ;pocetak na DS
        mov ds, ax
        
        mov ax, 0b800h              ;adreas video memorije u ES registru
        mov es, ax
        
    cikl:   mov ax, 0200h           ;citanje vremena iz sistemsog casovnika
            int 1ah
            
            call vrisp              ;ispisivanje vremena
            
            mov ax, 0100h           ;taster
            int 16h
            
            jz  cikl                ;ne, nazad
            
        mov ax, 0                   ;iscita vrijednost
        int 16h
        
        mov ax, 4c00h               ;nazad
        int 21h
            
    vrisp Proc                  ;program za ispisivanje vremena
        mov di, 0               ;monitor, lijevo gore
        mov ah, 15              ;crna pozadina bijeli karakter
        
        mov bx, cx              ;bx <== sati, minuti
        call isp1               ;sati na ekranu
        
        inc di                  ;mjesto za separator
        inc di
        
        call isp1               ;minute na ekranu
        inc di                  ;spearator
        inc di
        
        mov bh, dh              ;bh <== sekunde
        call isp1               ;sekunde na ekrnau
        
        mov al, "-"             ;separator
        mov es:[di-6], ax       ;na odgovarajuce pozicije
        mov es:[di-12], ax
        
        ret                     ;povratak na galvni program
    vrisp Endp                  ;kraj podrograma
        

;ISP1 Procedura ----------------
    isp1 Proc                   ;podprogram ispis 1
        mov cx, 2               ;ispisivanje 2 cifre
        
    cikl1:  push cx
            mov cx, 4           ;BCD broj (4 bita)
            mov al, 0
            
    cikl2:  shl bx, 1           ;dio BX registra (BCD broj)
            rcl al, 1
            loop cikl2
                
        or al, 30h              ;bin ==> ASCII
        mov es:[di], ax         ;u video memoriju
        inc di                  ;sljedeca pozicija
        inc di
        pop cx                  ;druga cifra
        loop cikl1
        
        ret                     ;nazad na program odakle je pozvan
    isp1 Endp
    

Prog06  Ends                    ;kraj segmenta    
        End Start