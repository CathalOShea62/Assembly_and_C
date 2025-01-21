
    ORG    $1000
START:                  ; first instruction of program

    MOVE.L #100, D1
    MOVE.L #$100, D1
    MOVE.L #%0100, D1
    
    MOVE.L #100, $2000
    MOVE.W #$100, $2000
    MOVE.B #%, $2000

    SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
