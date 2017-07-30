Prog01  Segment ;definicija segmenta
        assume CS:Prog01, DS:Prog01 ;pocetak CS i DS segmenta

Start:  mov ax, Prog01 ;pocetak na DS
        mov ds, ax
        
        mov ax, 4c00h   ;nazad u DOS
        int 21h
        
Porg01  Ends    ;kraj segmenta
        End Start