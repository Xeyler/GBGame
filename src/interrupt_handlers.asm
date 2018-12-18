INCLUDE "includes.asm"

SECTION "IRHVBlank", ROM0[$0040]
    call VBlankHandler
    reti
SECTION "IRHLCDStat", ROM0[$0048]
    reti
SECTION "IRHTimerOverflow", ROM0[$0050]
    reti
SECTION "IRHSerial", ROM0[$0058]
    reti
SECTION "IRHJoypad", ROM0[$0060]
    reti