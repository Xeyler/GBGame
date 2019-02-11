enable_debug EQU 1

; Prints a message to the bgb debugger
; Accepts a string as input, see http://bgb.bircd.org/manual.html#expressions for support
if def(enable_debug) && enable_debug == 1
debug_message: MACRO
        ld  d, d
        jr .message_end\@
        DW $6464
        DW $0000
        DB \1
.message_end\@:
ENDM

debug_variable: MACRO
        push hl
        ld hl, \1
        ld d, d
        jr .message_end\@
        DW $6464
        DW $0000
        DB "%(HL)%"
.message_end\@
pop hl
ENDM
else
debug_message: macro
endm
debug_variable: macro
endm
endc

