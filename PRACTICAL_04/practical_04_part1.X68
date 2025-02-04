    ORG    $1000
START:                 
    ; Move health to memory location $3000
    MOVE.B  #100, $3000
    
    ; LOAD MEMORY ADDRESS $3000 INTO
    ; ADDRESS REGISTER A1
    LEA     $3000, A1
    
    ; Hit by NPC
    SUB.B   #20, (A1)
    
    ; Pickup health found
    ADD.B   #10, (A1)

    SIMHALT             ; halt simulator


    END    START        ; last line of source

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
