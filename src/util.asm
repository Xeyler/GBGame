INCLUDE "includes.asm"

SECTION "Util", ROM0
; Copy data at [de] into [hl] of lengh bc
; @param DE: Source address
; @param HL: Destination address
; @param BC: Length
; @value DE: Source address + length
; @value HL: Destination address + length
; @value BC: 0
; @value A: 0
Memcpy::
    ld a, [de]
    ld [hli], a
    inc de
    dec bc
    ld a, b
    or c
    jr nz, Memcpy
    ret