*-------------------------------------------------------
* STARTING MEMORY ADDRESS FOR THE PROGRAMME $1000
*-------------------------------------------------------
	ORG $1000
*-------------------------------------------------------
*CHOOSE TO BE A MINI KNIGHT OR A TINY EXPLORER
*-------------------------------------------------------

*-------------------------------------------------------
*VALIDATION VALUES TO BE USED, MODIFY AS NEEDED
*-------------------------------------------------------
EXIT		EQU 0			;USED TO EXIT ASSEMBLY PROGRAM
MIN_POTIONS	EQU 1			;MIN NUMBER OF SMALL POTIONS
MAX_POTIONS	EQU 9			;MAX NUMBER OF SMALL POTIONS
MIN_WEAPONS	EQU 1			;MIN WEAPONS (NEEDLE SWORD, ACORN SHIELD)
MAX_WEAPONS	EQU 3			;MAX WEAPONS
WIN_POINT	EQU 5			;BRAVERY POINTS GAINED ON SUCCESS
LOSE_POINT	EQU 8			;BRAVERY POINTS LOST ON FAILURE
DROUGHT          EQU 1
RESOURCE_SHORTAGE EQU 2
LUCKY_FIND       EQU 3

DANGER_LOC  EQU 100         ;USED FOR SIMPLE COLLISION DETECTION
                            ;* EXAMPLE FOR A HIT (GIANT FOOTSTEP)

*START OF GAME
START:
    MOVE.B  #100,$4000      ;PUT BRAVERY POINTS IN MEMORY LOCATION $4000
    LEA     $4000,A3        ;ASSIGN ADDRESS A3 TO THAT MEMORY LOCATION

    BSR     WELCOME         ;BRANCH TO THE WELCOME SUBROUTINE
    ;BSR     INPUT           ;BRANCH TO THE INPUT SUBROUTINE
    BSR     GAME            ;BRANCH TO THE GAME SUBROUTINE

*GAME LOOP
    ORG     $3000           ;THE REST OF THE PROGRAM IS TO BE LOCATED FROM 3000 ONWARDS

*-------------------------------------------------------
*-------------------GAME SUBROUTINE---------------------
*-------------------------------------------------------
GAME:
    BSR     GAMELOOP        ;BRANCH TO GAMELOOP SUBROUTINE
    RTS                     ;RETURN FROM GAME: SUBROUTINE
          
END:
    SIMHALT

*-------------------------------------------------------
*-------------------WELCOME SUBROUTINE------------------
*-------------------------------------------------------
WELCOME:
    BSR     ENDL            ;BRANCH TO ENDL SUBROUTINE
    LEA     WELCOME_MSG,A1  ;ASSIGN MESSAGE TO ADDRESS REGISTER A1
    MOVE.B  #14,D0          ;MOVE LITERAL 14 TO DO
    TRAP    #15             ;TRAP AND INTERPRET VALUE IN D0
    BSR     ENDL            ;BRANCH TO ENDL SUBROUTINE
    BSR     CONTINUE        ;BRANCH TO CONTINUE SUBROUTINE 
    RTS                     ;RETURN FROM WELCOME: SUBROUTINE

*-------------------------------------------------------
*---------GAMEPLAY INPUT VALUES SUBROUTINE--------------
*-------------------------------------------------------    
INPUT:
    BSR     POTIONS         ;BRANCH TO POTION INPUT SUBROUTINE
    BSR     ENDL            ;BRANCH TO ENDL SUBROUTINE
    BSR     CONTINUE        ;BRANCH TO CONTINUE SUBROUTINE
    BSR     WEAPONS         ;BRANCH TO WEAPONS INPUT SUBROUTINE
    BSR     ENDL            ;BRANCH TO ENDL SUBROUTINE
    BSR     CONTINUE        ;BRANCH TO CONTINUE SUBROUTINE
    RTS

*-------------------------------------------------------
*----------------GAMELOOP (MAIN LOOP)-------------------
*------------------------------------------------------- 
GAMELOOP:
    BSR     INPUT           ;BRANCH TO INPUT SUBROUTINE
    BSR     UPDATE          ;BRANCH TO UPDATE GAME SUBROUTINE 
    ;BSR     CLEAR_SCREEN    ;CLEARS THE SCREEN 
    BSR     DRAW            ;BRANCH TO DRAW GAME SUBROUTINE               
    ;BSR     CLEAR_SCREEN    ;CLEARS THE SCREEN 
    BSR     GAMEPLAY        ;BRANCH TO GAMEPLAY SUBROUTINE
    ;BSR     CLEAR_SCREEN    ;CLEARS THE SCREEN        
    BSR     HUD             ;BRANCH TO HUD SUBROUTINE
    ;BSR     CLEAR_SCREEN    ;CLEARS THE SCREEN
    BSR     REPLAY          ;BRANCH TO REPLAY SUBROUTINE 
    BSR     CLEAR_SCREEN    ;CLEARS THE SCREEN
    RTS                     ;RETURN FROM GAMELOOP: SUBROUTINE       

*-------------------------------------------------------
*----------------UPDATE QUEST PROGRESS------------------
*  COMPLETE QUEST
*------------------------------------------------------- 
UPDATE:
    BSR     ENDL            ;BRANCH TO ENDL SUBROUTINE
    BSR     DECORATE        ;BRANCH TO DECORATE SUBROUTINE   
    LEA     UPDATE_MSG,A1   ;ASSIGN MESSAGE TO ADDRESS REGISTER A1 
    MOVE.B  #14,D0          ;MOVE LITERAL 14 TO DO
    TRAP    #15             ;TRAP AND INTERPRET VALUE IN D0
    BSR     DECORATE        ;BRANCH TO DECORATE SUBROUTINE
    RTS                     

*-------------------------------------------------------
*-----------------DRAW QUEST UPDATES--------------------
* DRAW THE GAME PROGRESS INFORMATION, STATUS REGARDING
* QUEST
*------------------------------------------------------- 
DRAW:
    BSR     ENDL            ;BRANCH TO ENDL SUBROUTINE            
    BSR     DECORATE        ;BRANCH TO DECORATE SUBROUTINE    
    LEA     DRAW_MSG,A1     ;ASSIGN MESSAGE TO ADDRESS REGISTER A1     
    MOVE.B  #14,D0          ;MOVE LITERAL 14 TO DO
    TRAP    #15             ;TRAP AND INTERPRET VALUE IN D0
    BSR     DECORATE        ;BRANCH TO DECORATE SUBROUTINE
    RTS                     ;RETURN FROM DRAW: SUBROUTINE

*-------------------------------------------------------
*--------------------POTIONS INVENTORY---------------------
* NUMBER OF POTIONS TO BE USED IN A QUEST 
*------------------------------------------------------- 
POTIONS:
    BSR     ENDL            ;BRANCH TO ENDL SUBROUTINE
    BSR     DECORATE        ;BRANCH TO DECORATE SUBROUTINE
    LEA     POTIONS_MSG,A1  ;ASSIGN MESSAGE TO ADDRESS REGISTER A1
    MOVE.B  #14,D0          ;MOVE LITERAL 14 TO DO
    TRAP    #15             ;TRAP AND INTERPRET VALUE IN D0
    BSR     DECORATE        ;BRANCH TO DECORATE SUBROUTINE
    RTS                     ;RETURN FROM POTIONS: SUBROUTINE

*-------------------------------------------------------
*-------------------------WEAPONS-----------------------
* NUMBER OF WEAPONS
*-------------------------------------------------------   
WEAPONS:
    BSR     ENDL            ;BRANCH TO ENDL SUBROUTINE
    BSR     DECORATE        ;BRANCH TO DECORATE SUBROUTINE
    LEA     WEAPONS_MSG,A1  ;ASSIGN MESSAGE TO ADDRESS REGISTER A1      
    MOVE.B  #14,D0          ;MOVE LITERAL 14 TO DO
    TRAP    #15             ;TRAP AND INTERPRET VALUE IN D0
    BSR     DECORATE        ;BRANCH TO DECORATE SUBROUTINE
    RTS                     ;RETURN FROM WEAPONS: SUBROUTINE

*-------------------------------------------------------
*---GAME PLAY (QUEST PROGRESS)--------------------------
*------------------------------------------------------- 
GAMEPLAY:
    BSR     ENDL
    BSR     DECORATE
    LEA     GAMEPLAY_MSG,A1
    MOVE.B  #14,D0
    TRAP    #15
    MOVE.B  #4,D0
    TRAP    #15
    BSR     COLLISION
    MOVE.W  HEALTH, D1            ; Load health into D1
    CMP.W   #0, D1                ; Check if health is zero
    BEQ     GAME_OVER             ; If health is zero, go to game over
    RTS               ;RETURN FROM GAMEPLAY: SUBROUTINE
    
*-------------------------------------------------------
*-----------------RANDOM EVENT---------------
*------------------------------------------------------- 
RANDOM_EVENT:
    ; Generate a pseudo-random number between 1 and 3
    MOVE.B  #DANGER_LOC,D1   ; Use DANGER_LOC for randomness
    ANDI.B  #3, D1            ; AND D1 with 3 to get a value between 0 and 3
    ADDI.B  #1, D1            ; Adjust to get a range of 1 to 3
    RTS                        ; Return with the random event in D1
    
    HANDLE_EVENT:
    MOVE.B  D1, D0           ; Move the random event into D0
    CMP.B   #DROUGHT, D0     ; Check for drought
    BEQ     EVENT_DROUGHT
    CMP.B   #RESOURCE_SHORTAGE, D0 ; Check for resource shortage
    BEQ     EVENT_RESOURCE_SHORTAGE
    CMP.B   #LUCKY_FIND, D0   ; Check for lucky find
    BEQ     EVENT_LUCKY_FIND
    RTS                        ; Return if no event

EVENT_DROUGHT:
    ; Decrease potions by 1
    SUBI.W  #1, POTIONS       ; Decrease potions
    LEA     DROUGHT_MSG,A1    ; Load drought message
    MOVE.B  #14,D0            ; Move literal 14 to D0
    TRAP    #15               ; Display drought message
    RTS

EVENT_RESOURCE_SHORTAGE:
    ; Decrease score by 2
    SUBI.W  #2, SCORE          ; Decrease score
    LEA     RESOURCE_SHORTAGE_MSG,A1 ; Load resource shortage message
    MOVE.B  #14,D0            ; Move literal 14 to D0
    TRAP    #15               ; Display resource shortage message
    RTS

EVENT_LUCKY_FIND:
    ; Increase potions by 1
    ADDI.W  #1, POTIONS        ; Increase potions
    LEA     LUCKY_FIND_MSG,A1  ; Load lucky find message
    MOVE.B  #14,D0            ; Move literal 14 to D0
    TRAP    #15               ; Display lucky find message
    RTS
*-------------------------------------------------------
*-----------------HEADS UP DISPLAY (SCORE)--------------
*-------------------------------------------------------   
HUD:
    BSR     ENDL            ; BRANCH TO ENDL SUBROUTINE
    BSR     DECORATE        ; BRANCH TO DECORATE SUBROUTINE

    ; Display current health
    LEA     HEALTH_MSG,A1   ; Load health message
    MOVE.B  #14,D0          ; Move literal 14 to D0
    TRAP    #15             ; Display health message
    MOVE.W  HEALTH, D1      ; Load health into D1
    MOVE.B  #3,D0           ; Move literal 3 to D0 for display
    TRAP    #15             ; Display health value

    ; Display current score
    LEA     SCORE_MSG,A1    ; Load score message
    MOVE.B  #14,D0          ; Move literal 14 to D0
    TRAP    #15             ; Display score message
    MOVE.W  SCORE, D1       ; Load score into D1
    MOVE.B  #3,D0           ; Move literal 3 to D0 for display
    TRAP    #15             ; Display score value

    BSR     DECORATE        ; BRANCH TO DECORATE SUBROUTINE    
    RTS                     ; RETURN FROM HUD: SUBROUTINE           

*-------------------------------------------------------
*-----------------------BEING ATTACKED------------------
* THIS COULD BE USED FOR COLLISION DETECTION
*-------------------------------------------------------
COLLISION:                  
    MOVE.B  #DANGER_LOC,D1  ;MOVE LITERAL DANGER_LOC TO D1
    CMP     #100,D1         ;  IS( X == 100)?
    BNE     COLLISION_MISS  ;  IF NOT, BRANCH TO COLLISION_MISS
    BSR     COLLISION_HIT   ;  ELSE, BRANCH TO COLLISION_HIT
    RTS                     ;RETURN FROM COLLISION: SUBROUTINE  
COLLISION_HIT:
    LEA     HIT_MSG,A1      ;ASSIGN MESSAGE TO ADDRESS REGISTER A1
    MOVE    #14,D0          ;MOVE LITERAL 14 TO DO
    TRAP    #15             ;TRAP AND INTERPRET VALUE IN D0
    RTS                     ;RETURN FROM COLLISION_HIT: SUBROUTINE
    
COLLISION_MISS:
    LEA     MISS_MSG,A1		;ASSIGN MESSAGE TO ADDRESS REGISTER A1
    MOVE    #14,D0          ;MOVE LITERAL 14 TO DO
    TRAP    #15             ;TRAP AND INTERPRET VALUE IN D0
    RTS                     ;RETURN FROM COLLISION_MISS: SUBROUTINE

*-------------------------------------------------------
*--------------------------LOOP-------------------------
*-------------------------------------------------------
LOOP:
    MOVE.B  #5, D3          ; LOOP COUNTER D3=5
NEXT:
    LEA     LOOP_MSG,A1     ; ASSIGN MESSAGE TO ADDRESS REGISTER A1
    MOVE.B  #14,D0          ; MOVE LITERAL 14 TO DO          
    TRAP    #15             ; TRAP AND INTERPRET VALUE IN D0

    ; Display current health
    MOVE.W  HEALTH, D1      ; Load health into D1
    LEA     HEALTH_MSG,A1    ; Load health message
    MOVE.B  #14,D0          ; Move literal 14 to D0
    TRAP    #15              ; Display health message
    MOVE.W  D1, D0          ; Move health value to D0 for display
    MOVE.B  #3,D0           ; Move literal 3 to D0 for display
    TRAP    #15              ; Display health value

    ; Display current score
    MOVE.W  SCORE, D1       ; Load score into D1
    LEA     SCORE_MSG,A1     ; Load score message
    MOVE.B  #14,D0          ; Move literal 14 to D0
    TRAP    #15              ; Display score message
    MOVE.W  D1, D0          ; Move score value to D0 for display
    MOVE.B  #3,D0           ; Move literal 3 to D0 for display
    TRAP    #15              ; Display score value

    SUB     #1,D3           ; DECREMENT LOOP COUNTER
    BNE     NEXT            ; REPEAT UNTIL D3=0
*-------------------------------------------------------
*------------------SCREEN DECORATION--------------------
*-------------------------------------------------------
DECORATE:
    MOVE.B  #60, D3         ;LOOP COUNTER D3=60
    BSR     ENDL            ;BRANCH TO ENDL SUBROUTINE
OUT:
    LEA     LOOP_MSG,A1     ;ASSIGN MESSAGE TO ADDRESS REGISTER A1
    MOVE.B  #14,D0          ;MOVE LITERAL 14 TO DO
    TRAP    #15             ;TRAP AND INTERPRET VALUE IN D0
    SUB     #1,D3           ;DECREMENT LOOP COUNTER
    BNE     OUT             ;REPEAT UNTIL D0=0
    BSR     ENDL            ;BRANCH TO ENDL SUBROUTINE
    RTS                     ;RETURN FROM DECORATE: SUBROUTINE
    
CLEAR_SCREEN: 
    MOVE.B  #11,D0          ;CLEAR SCREEN
    MOVE.W  #$FF00,D1       ;SET COLOUR
    TRAP    #15             ;TRAP AND INTERPRET VALUE IN D0
    RTS                     ;RETURN FROM CLEAR_SCREEN: SUBROUTINE                

*-------------------------------------------------------
*------------------------REPLAY-------------------------
*-------------------------------------------------------
REPLAY:
    BSR     ENDL            ;BRANCH TO ENDL SUBROUTINE
    LEA     REPLAY_MSG,A1   ;ASSIGN MESSAGE TO ADDRESS REGISTER A1
    MOVE.B  #14,D0          ;MOVE LITERAL 14 TO DO
    TRAP    #15             ;TRAP AND INTERPRET VALUE IN D0
    
    MOVE.B  #4,D0           ;MOVE LITERAL 4 TO DO
    TRAP    #15             ;TRAP AND INTERPRET VALUE IN D0

    CMP     #EXIT,D1        ;COMPARE D1 TO EXIT
    BEQ     END             ;IF EQUAL, BRANCH TO END
    BSR     GAMELOOP        ;BRANCH TO GAMELOOP SUBROUTINE
    
*-------------------------------------------------------
*------------------------CONTINUE-------------------------
*-------------------------------------------------------
CONTINUE:
    BSR     ENDL            ;BRANCH TO ENDL SUBROUTINE
    LEA     CONTINUE_MSG,A1 ;ASSIGN MESSAGE TO ADDRESS REGISTER A1
    MOVE.B  #14,D0          ;MOVE LITERAL 14 TO DO
    TRAP    #15             ;TRAP AND INTERPRET VALUE IN D0
    
    MOVE.B  #4,D0           ;MOVE LITERAL 4 TO DO
    TRAP    #15             ;TRAP AND INTERPRET VALUE IN D0
    RTS                     ;RETURN FROM SUBROUTINE 

ENDL:
    MOVEM.L D0/A1,-(A7)     ;SAVE D0 AND A1
    MOVE    #14,D0          ;MOVE LITERAL 14 TO DO
    LEA     CRLF,A1         ;ASSIGN CRLF TO ADDRESS REGISTER A1
    TRAP    #15             ;TRAP AND INTERPRET VALUE IN D0
    MOVEM.L (A7)+,D0/A1     ;RESTORE D0 AND A1
    RTS                     ;RETURN FROM ENDL: SUBROUTINE
    
    *-------------------------------------------------------
*------------------------GAME OVER-------------------------
*-------------------------------------------------------
    GAME_OVER:
    BSR     ENDL
    LEA     GAME_OVER_MSG,A1      ; Load game over message
    MOVE.B  #14,D0
    TRAP    #15
    BSR     REPLAY                 ; Ask if the player wants to replay
    RTS
*-------------------------------------------------------
*-------------------DATA DECLARATIONS--------------------
*-------------------------------------------------------

CRLF:           DC.B    $0D,$0A,0
WELCOME_MSG:    DC.B    '************************************************************'
                DC.B    $0D,$0A
                DC.B    'WELCOME TO THE MINIATURE KINGDOM! '
                DC.B    $0D,$0A
                DC.B    'CHOOSE YOUR ADVENTURER:'
                DC.B    $0D,$0A
                DC.B    '1. MINI KNIGHT (TINY BUT BRAVE)'
                DC.B    $0D,$0A
                DC.B    '2. TINY EXPLORER (FAST AND CLEVER)'
                DC.B    $0D,$0A
                DC.B    '************************************************************'
                DC.B    $0D,$0A,0
POTIONS_MSG:    DC.B    'COLLECT SMALL POTIONS TO SHRINK! ENTER QUANTITY: ',0
WEAPONS_MSG:    DC.B    'EQUIP TINY WEAPONS: NEEDLE SWORD, ACORN SHIELD.',0
HEALTH_MSG      DC.B    'CURRENT HEALTH: ',0
SCORE_MSG       DC.B    'CURRENT SCORE: ',0
GAMEPLAY_MSG:   DC.B    'TINY ADVENTURE BEGINS!',0
UPDATE_MSG:     DC.B    'UPDATING QUEST STATUS...',0
DRAW_MSG:       DC.B    'REDRAWING MINIATURE WORLD...',0
HIT_MSG:        DC.B    'OH NO! STEPPED ON BY A GIANT!',0
MISS_MSG:       DC.B    'SAFE! HID UNDER A LEAF.',0
DROUGHT_MSG     DC.B    'OH NO, THERE WAS A DROUGHT, LOST 1 POTION. ',0
RESOURCE_SHORTAGE_MSG   DC.B    'YOU ARE SHORT ON RESOURCES. ',0
LUCKY_FIND_MSG  DC.B    'LUCKY FIND: ',0
LOOP_MSG:       DC.B    '.',0
REPLAY_MSG:     DC.B    'ENTER 0 TO QUIT, ANY OTHER NUMBER TO REPLAY: ',0
CONTINUE_MSG:   DC.B    'PRESS ANYKEY TO CONTINUE: ',0
GAME_OVER_MSG   DC.B    'GAME OVER, TRY AGAIN: ',0
HUD_MSG:        DC.B    'BRAVERY POINTS: ',0
HEALTH:         DS.W    1   ;PLAYERS HEALTH
SCORE:          DS.W    1   ;RESERVE SPACE FOR SCORE

    END START

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
