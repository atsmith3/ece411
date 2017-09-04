; Andrew Smith
; Factoral
; ECE 411 - MP0

; This program calculates the factoral of the number stored in
; the memory location [IN].
; 
; Registers:
;    R0 : Holds Zero
;    R1 : Accumulator for final product
;    R2 : -1 used for decrimenting loops
;    R3 : holds counter for inner multiplication loop
;    R4 : temporary multiplication accumulator
;    R5 : holds the current value being multiplied
;
; The function uses an iterative outer loop to multiply N(N-1)(N-2)...(2)(1)
; with an iterative inner multiplication loop. 

ORIGIN 4x0000
SEGMENT CodeSegment:

    LDR R1, R0, IN       ; Load in the input value
    LDR R5, R0, IN
    LDR R2, R0, NEG_ONE  ; Load -1 into R2
LOOP_OUTER:
    ADD R3, R5, R2       ; Store R5 - 1 into R3
    BRnz STORE           ; If the value is <= 0 we are done computing
    AND R4, R0, R0       ; Clear the temp multiplicaion register
LOOP_MULT:
    ADD R4, R4, R1       ; Loop to multiply
    ADD R3, R3, R2
    BRp LOOP_MULT
    ADD R1, R4, R0       ; Move the result of the multiplication into R1
    ADD R5, R5, R2       ; Decriment the factoral outer loop
    BRnzp LOOP_OUTER 
STORE:
    STR R1, R0, OUT      ; Store the result into memory
HALT:
    BRnzp HALT           ; Loop to halt

IN:   DATA2 4x0005
OUT:  DATA2 4x0000
ZERO: DATA2 4x0000
NEG_ONE:  DATA2 4xFFFF
