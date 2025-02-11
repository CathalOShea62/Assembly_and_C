    ORG    $1000        ; Start of the program memory


START:
    ; Initialize player health (100%) at $3000
    MOVE.B  #$64, $3000          ; Player Health = 100% (Hex $64)

    ; Load player health address into Address Register A1
    LEA     $3000, A1

    ; Player takes damage
    BSR     TAKING_DAMAGE

    ; Health pickup (player gets more health)
    BSR     HEALTH_PICKUP

    ; Game Over: End the game
    BRA     GAME_END

TAKING_DAMAGE:
    ; Player hit by NPC: subtract 20 from health
    SUB.B   #$14, (A1)           ; Subtract 20 (Hex $14)
    BRA     GAME_END             ; Go to game end after taking damage

HEALTH_PICKUP:
    ; Player picks up health: add 10 to health
    ADD.B   #$0A, (A1)           ; Add 10 (Hex $0A)
    RTS                          ; Return from subroutine

GAME_END:
    ; Game Over: clear player health
    MOVE.B #$00, (A1)

    SIMHALT                      ; Halt simulator

* Variables and constants
        



    END    START
        

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
