ORIGIN 4x0000
    ;; Refer to the LC-3b manual for the operation of each
    ;; instruction.  (LDR, STR, ADD, AND, NOT, BR)
SEGMENT  CodeSegment:
    ;; R0 is assumed to contain zero, because of the construction
    ;; of the register file.  (After reset, all registers contain
    ;; zero.)


    ADD R5, R0, 6
    JSR SUBROUTINE
;    LEA R1, SUBROUTINE
;    JSRR R1

HALT:                   ; Infinite loop to keep the processor
    ADD R5, R0, 3
    BRnzp HALT          ; from trying to execute the data below.

SUBROUTINE:
    ADD R2, R0, 10
    RSHFL R2, R2, 1
    NOT R3, R2
    RSHFA R3, R3, 1
    LSHF R4, R2, 4
    RET
