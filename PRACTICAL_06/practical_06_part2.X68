    ORG    $1000
START:                  ; first instruction of program
        ORG     $1000           ; Start at memory location 1000h

; === Display string at (A1), D1.W bytes long with CR, LF (Task 13) ===
DisplayStringWithCRLF:
        MOVE.L  A1, A0          ; Load address of string
        MOVE.W  D1, D2          ; Load string length

PrintLoop:
        SUBQ.W  #1, D2          ; Decrease length counter
        BMI     PrintCRLF       ; If negative, print CRLF

        MOVE.B  (A0)+, D0       ; Load next character
        BSR     PrintChar       ; Call print routine
        BRA     PrintLoop       ; Loop until done

PrintCRLF:
        MOVE.B  #10, D0         ; Line Feed (LF)
        BSR     PrintChar
        MOVE.B  #13, D0         ; Carriage Return (CR)
        BSR     PrintChar
        RTS                     ; Return

; === Display string at (A1), D1.W bytes long without CR, LF (Task 14) ===
DisplayStringNoCRLF:
        MOVE.L  A1, A0          ; Load address
        MOVE.W  D1, D2          ; Load length

NoCRLFLoop:
        SUBQ.W  #1, D2
        BMI     NoCRLFEnd

        MOVE.B  (A0)+, D0
        BSR     PrintChar
        BRA     NoCRLFLoop

NoCRLFEnd:
        RTS

; === Read string from keyboard, store at (A1), NULL terminate, return length in D1.W (max 80) ===
ReadString:
        MOVE.L  A1, A0          ; Store buffer address
        CLR.W   D1              ; Clear length counter

ReadLoop:
        BSR     ReadChar        ; Get character from keyboard
        CMP.B   #13, D0         ; Enter key?
        BEQ     StringEnd

        MOVE.B  D0, (A0)+       ; Store char
        ADDQ.W  #1, D1          ; Increment length
        CMP.W   #80, D1         ; Max length?
        BGE     StringEnd       ; If max, stop

        BRA     ReadLoop

StringEnd:
        MOVE.B  #0, (A0)        ; NULL terminate
        RTS

; === Display signed number in D1.L in decimal (smallest field) ===
DisplaySignedNumber:
        MOVE.L  D1, -(SP)       ; Save original number
        BSR     ConvertToDecimal
        BSR     DisplayStringNoCRLF
        ADDQ.L  #4, SP          ; Restore stack
        RTS

; === Read a number from the keyboard into D1.L ===
ReadNumber:
        BSR     ReadString
        BSR     ConvertStringToNumber
        RTS

; === Read single character from keyboard into D1.B ===
ReadChar:
        MOVE    #5, D0          ; Trap code for input
        TRAP    #3
        RTS

; === Display single character in D1.B ===
PrintChar:
        MOVE    D1, -(SP)       ; Save D1
        MOVE    #6, D0          ; Trap code for output
        TRAP    #3
        MOVE    (SP)+, D1       ; Restore D1
        RTS

; === Set D1.B to 1 if keyboard input is pending, otherwise set to 0 ===
CheckKeyPending:
        MOVE    #5, D0
        TRAP    #3
        RTS

; === Return time in hundredths of a second since midnight in D1.L ===
GetTime:
        MOVE    #9, D0
        TRAP    #3
        RTS

; === Terminate program ===
Terminate:
        MOVE    #0, D0
        TRAP    #3
        STOP    #2700           ; Halt simulator

; === Position cursor at ROW, COL ===
SetCursorPosition:
        MOVE    #11, D0
        TRAP    #3
        RTS

; === Clear Screen ===
ClearScreen:
        MOVE.W  #$FF00, D1
        MOVE    #12, D0
        TRAP    #3
        RTS

; === Enable/Disable Keyboard Echo ===
SetKeyboardEcho:
        MOVE    #13, D0
        TRAP    #3
        RTS

; === Display NULL terminated string at (A1) with CR, LF ===
DisplayNullStringCRLF:
        MOVE    #14, D0
        TRAP    #3
        RTS

; === Display NULL terminated string at (A1) without CR, LF ===
DisplayNullStringNoCRLF:
        MOVE    #15, D0
        TRAP    #3
        RTS

; === Adjust display properties ===
AdjustDisplay:
        MOVE    #16, D0
        TRAP    #3
        RTS

; === Combination of displaying a string and a decimal number ===
DisplayStringAndNumber:
        MOVE    #17, D0
        TRAP    #3
        RTS

; === Combination of displaying a string and reading a number ===
DisplayStringAndReadNumber:
        MOVE    #18, D0
        TRAP    #3
        RTS

; === Check key state ===
CheckKeyState:
        MOVE    #19, D0
        TRAP    #3
        RTS

; === Display signed number in a field D2.B columns wide ===
DisplayNumberWithField:
        MOVE    #20, D0
        TRAP    #3
        RTS

; === Set font color ===
SetFontColor:
        MOVE    #21, D0
        TRAP    #3
        RTS

; === Read character at a specific screen position ===
ReadCharAtPosition:
        MOVE    #22, D0
        TRAP    #3
        RTS
ConvertToDecimal:
        MOVE.L  D1, D3          ; Copy original value
        MOVEA.L A1, A0          ; Load buffer address
        CLR.B   D5              ; Flag for negative number

        TST.L   D3              ; Check if negative
        BPL     ConvertLoop     ; If positive, continue
        NEG.L   D3              ; Make it positive
        MOVE.B  #'-', (A0)+     ; Store '-' sign
        MOVE.B  #1, D5          ; Set negative flag

ConvertLoop:
        DIVU    #10, D3         ; Divide D3 by 10
        SWAP    D3              ; Move remainder to upper word
        ADD.B   #'0', D3        ; Convert to ASCII
        MOVE.B  D3, -(SP)       ; Push to stack
        SWAP    D3              ; Restore quotient
        TST.L   D3              ; Check if finished
        BNE     ConvertLoop

WriteDigits:
        MOVE.B  (SP)+, (A0)+    ; Pop and write digits
        CMPA.L  A1, A0          ; Check if done
        BNE     WriteDigits

        MOVE.B  #0, (A0)        ; NULL terminate
        RTS
ConvertStringToNumber:
        CLR.L   D1              ; Clear output register
        CLR.B   D2              ; Clear negative flag

        MOVEA.L A1, A0          ; Load string address

CheckSign:
        MOVE.B  (A0)+, D3       ; Read first character
        CMP.B   #'-', D3        ; Check if negative
        BNE     ConvertLoop
        MOVE.B  #1, D2          ; Set negative flag
        BRA     ConvertLoop

ConversionLoop:
        MOVE.B  (A0)+, D3       ; Read next character
        BEQ     ApplySign       ; If NULL, finish
        CMP.B   #'0', D3        ; Check if valid digit
        BLT     ApplySign
        CMP.B   #'9', D3
        BGT     ApplySign

        SUB.B   #'0', D3        ; Convert ASCII to integer
        MULU    #10, D1         ; Multiply current number by 10
        ADD.L   D3, D1          ; Add new digit
        BRA     ConvertLoop

ApplySign:
        TST.B   D2              ; Check negative flag
        BEQ     Done
        NEG.L   D1              ; Apply negative sign

Done:
        RTS


    SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
