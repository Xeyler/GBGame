enable_debug EQU 1

; Prints a message to the bgb debugger
; Accepts a string as input, see http://bgb.bircd.org/manual.html#expressions for support
if def(enable_debug) && enable_debug == 1
debug_message: MACRO
        ld  d, d
        jr .end\@
        DW $6464
        DW $0000
        DB \1
.end\@:
ENDM
else
debug_message: MACRO
ENDM
endc