    ORG    $1000
START:                  ; first instruction of program

    MOVE.L #2000, D1
    MOVE.L #%100, D2
    MOVE.L #100,  D3
    
    MOVE.B $2000, $3010
    MOVE.B #64,   $3020
    MOVE.B #$10, $3000
    
    MOVE.W $2000, $3010
    MOVE.W #%100, $3000
    MOVE.W #64,   $3020

    MOVE.L D1,    $3000
    MOVE.L D2,    $3010
    MOVE.L D3,    $3020
    
    MOVE.W #1000, D1
    MOVE.W #64,   D2
    MOVE.W $300,  D3 

    MOVE.L D1, D2
    MOVE.L D2, D3
    MOVE.L D3, D0  

    SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
