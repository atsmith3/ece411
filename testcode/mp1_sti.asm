ORIGIN 4x0000
    ;; Refer to the LC-3b manual for the operation of each
    ;; instruction.  (LDR, STR, ADD, AND, NOT, BR)
SEGMENT  CodeSegment:
    ;; R0 is assumed to contain zero, because of the construction
    ;; of the register file.  (After reset, all registers contain
    ;; zero.)


    LDR R1, R0, NFAC      ; R1 <= NFAC
    ADD R2, R0, 7         ; R2 <= 7
    STI R2, R1, 1         ; R2 <= M[M[R1 + 1]]
    STI R2, R1, 0         ; R3 <= M[M[R1 + 0]]
    LDR R4, R0, NFAC4     ; Read the memory we wrote:
    LDR R5, R0, NFAC3     

HALT:                   ; Infinite loop to keep the processor
    BRnzp HALT          ; from trying to execute the data below.

NFAC:	DATA2 NFAC2
NFAC2:  DATA2 NFAC3
NFAC3:  DATA2 NFAC4
NFAC4:  DATA2 4