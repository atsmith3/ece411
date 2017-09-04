; Andrew Smith
; 5 factoral

; THis program calculates 5 factoral and stores it.

ORIGIN 4x0000
SEGMENT CodeSegment:

    LDR R1, R0, IN     ; Load R1 with 5 
    LDR R0, R0, ZERO   ; clear an accumulator register
    LDR R2, R0, ONE    ; R2 is 1
    NOT R3, R2         ; R3 is -1
    ADD R3, R3, R2
    LDR R4, R0, ZERO

LOOP_OUTER:
    ADD R4,     
    
LOOP_MULT:
    ADD R0, R1, R0
    

HALT:
    BRnzp HALT


IN:   DATA2 4x0005
OUT:  DATA2 4x0000
ZERO: DATA2 4x0000
ONE:  DATA2 4x0001
