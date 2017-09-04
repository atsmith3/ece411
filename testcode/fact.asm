; Andrew Smith
; Factoral
ORIGIN 4x0000
SEGMENT CodeSegment:

    LDR R1, R0, IN
    LDR R5, R0, IN
    LDR R2, R0, NEG_ONE
LOOP_OUTER:
    ADD R3, R5, R2
    BRnz STORE
    AND R4, R0, R0
LOOP_MULT:
    ADD R4, R4, R1
    ADD R3, R3, R2
    BRp LOOP_MULT
    ADD R1, R4, R0
    ADD R5, R5, R2
    BRnzp LOOP_OUTER 
STORE:
    STR R1, R0, OUT
HALT:
    BRnzp HALT

IN:   DATA2 4x0005
OUT:  DATA2 4x0000
ZERO: DATA2 4x0000
NEG_ONE:  DATA2 4xFFFF