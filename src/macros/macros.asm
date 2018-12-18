INCLUDE "macros/psuedo_instructions.asm"

; dbr value, nb_times
; Writes nb_times consecutive bytes with value.
dbr: MACRO
    REPT \2
        db \1
    ENDR
ENDM

; dwr value, nb_times
; Writes nb_times consecutive words with value.
dwr: MACRO
    REPT \2
        dw \1
    ENDR
ENDM

; lb register, high byte, low byte
; Writes to a 16-bit register with two bytes
lb: MACRO
    ld \1, ((\2) << 8) | (\3)
ENDM