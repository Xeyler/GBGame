SECTION "GraphicsLibrary", ROM0
; Returns byte palette faded to white($00) by one value in register A
; @param A: Palette
; @value A: Faded palette
; @value B: Whack
; @value C: Whack
; @value ZF: 0 if new palette is entirely white($00)
GetFadedPalette::
    ld b, a
    rrca
    or b
    and %01010101
    ld c, a
    ld a, b
    sub c
    ret

; Waits BC number of frames
; @param BC: Number of frames to halt for
; @value A: 0
WaitFrames::
    call WaitVBlank
    dec bc
    ld a, b
    cp 0
    jr nz, WaitFrames
    ld a, c
    cp 0
    jr nz, WaitFrames
    ret

; Waits for the VBlank interrupt
; Note: if the interrupt occurs without being waited for, it will skip performing some actions
WaitVBlank::
    xor a
    ;ldh [hVBlankFlag], a
.waitVBlank
    halt
    jr z, .waitVBlank
    ret

VBlankHandler::
    ldh a, [hVBlankFlag]
    and a
    jr nz, .lagFrame
    ; implement handler code here
    pop af
    xor a ; Might actually be unnecessary
    inc a
    ldh [hVBlankFlag], a
    reti

.lagFrame
    pop af
    reti