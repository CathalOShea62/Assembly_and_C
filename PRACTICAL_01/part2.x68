
    ORG    $1000
START:                  ; first instruction of program

    MOVE.L #%00001111,D1
    MOVE.B D1,D2
    MOVE.B D1,$2000
    MOVE.B %2000,D2
    MOVE.B $2000,%3000

    SIMHALT             ;



    END    START        ; last line of source

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
