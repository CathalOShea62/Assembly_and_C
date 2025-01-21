    ORG    $1000
START:                  ; first instruction of program

    MOVE.L #2000, D1
    MOVE.B #%100, D2
    MOVE.W #100,  D3

    SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
