ORIGIN 4x0000
    ;; Refer to the LC-3b manual for the operation of each
    ;; instruction.  (LDR, STR, ADD, AND, NOT, BR)
SEGMENT  CodeSegment:
    ;; R0 is assumed to contain zero, because of the construction
    ;; of the register file.  (After reset, all registers contain
    ;; zero.)

START:
    LDB R1, R0, MEM1
    LEA R6, MEM1
    LDB R2, R6, 1
    ADD R3, R1, R2
    STB R3, R6, 3
    LDB R4, R6, 3
    LDR R5, R0, MEM3
    TRAP 40
    
HALT:                   ; Infinite loop to keep the processor
    BRnzp HALT          ; from trying to execute the data below.

MEM1: DATA1 32
MEM2: DATA1 64
MEM3: DATA1 127
MEM4: DATA1 127
COOLBEANS:
DATA2 START
DATA2 START
DATA2 START
DATA2 START
DATA2 START
DATA2 START
DATA2 START
DATA2 START
DATA2 START
DATA2 START
DATA2 START
DATA2 START
DATA2 START
DATA2 START
DATA2 START
DATA2 START
DATA2 START
DATA2 START
DATA2 START
DATA2 START
DATA2 START
DATA2 START
DATA2 START
DATA2 START
DATA2 START
DATA2 START
DATA2 START
DATA2 START
DATA2 START
DATA2 START
