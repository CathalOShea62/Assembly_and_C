    ORG    $1000
                
START:
        MOVE.L  #HEALTH, -(SP)  ; Push address of HEALTH onto stack
        JSR     GAME_LOOP       ; Jump to GAME_LOOP subroutine
        BSR     HEADS_UP_DISPLAY ; Branch to HEADS_UP_DISPLAY
        BRA     END             ; Branch to END (missing label, define if needed)

GAME_LOOP:
        MOVEA.L 4(SP), A1       ; Load address from stack into A1
        SUB.B   #10, (A1)       ; Subtract 10 from HEALTH
        RTS                     ; Return

HEADS_UP_DISPLAY:
        LEA     MESSAGE, A1     ; Load address of MESSAGE into A1
        MOVE.B  #14, D0         ; Set trap code for printing string
        TRAP    #15             ; System call to display MESSAGE

        MOVE.B  HEALTH, D1      ; Load HEALTH value into D1
        MOVE.B  #3, D0          ; Set trap code for printing number
        TRAP    #15             ; System call to display HEALTH
        RTS                     ; Return

HEALTH: 
        DC.B    100             ; Define HEALTH with initial value 100

MESSAGE: 
        DC.B    'Health:', 0    ; Define MESSAGE string (NULL-terminated)

END:
    STOP    #2700
    SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
