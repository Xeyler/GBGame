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

; Waits for the VBlank interrupt
; Note: You must wait for VBlank for the handler to perform its task
WaitVBlank::
    xor a
    inc a ; set zero flag to false and signal VBlank
    ldh [hVBlankFlag], a
.waitVBlank
    halt
    jr z, .waitVBlank
    ret

; Waits for the VBlank interrupt with an OAM DMA request
; Note: if the interrupt occurs without being waited for, it will skip performing some actions
WaitVBlankWithOAMDMA::
    xor a
    or a, %00000011 ; signal OAM DMA update and set ZF to false
    ldh [hVBlankFlag], a
.waitVBlank
    halt
    jr z, .waitVBlank
    ret

; When allowed to run via hVBlankFlag, this handler DOES NOT PRESERVE REGISTER AF
; This is how we know it's finished(see WaitVBlank).
; By default, we update hRAM vars and process a memcpy request. We can also do an OAM DMA if requested.
VBlankHandler::
    push af
    ldh a, [hVBlankFlag]
    bit 0, a
    jr z, .lagFrame ; VBlank has not been requested, so preserve registers and return
    
    ; First, update HRAM screen registers with HRAM register buffers
    ldh a, [hLCDC] ; LCD Control
    ldh [rLCDC], a
    ldh a, [hSCY] ; Scroll Y
    ldh [rSCY], a
    ldh a, [hSCX] ; Scroll X
    ldh [rSCX], a
    ldh a, [hWY] ; Window Y
    ldh [rWY], a
    ldh a, [hWX] ; Window X
    ldh [rWX], a
    ldh a, [hBGP] ; Background palette
    ldh [rBGP], a
    ldh a, [hOBP0] ; Object palette 0
    ldh [rOBP0], a
    ldh a, [hOBP1] ; Object palette 1
    ldh [rOBP1], a

    ; Second, process a memcpy request if it exists
    ; TODO: Please make an actually optimized memcpy. This is trash.
    ; If you're someone who realizes how bad this is, please don't cyberbully me ;-;
    ld hl, hVBlankCopySrc
    ld d, [hl]
    inc hl
    ld e, [hl]
    ld hl, hVBlankCopyDest
    ld a, [hli]
    ld l, [hl]
    ld h, a
    ld a, [hVBlankCopyLen]
    ld c, a

.vblankMemcpy
    ld a, [de]
    ld [hli], a
    inc de
    dec c
    ld a, c
    jr nz, .vblankMemcpy

    ; Finally, process an OAM DMA request if the second bit of hVblankFlag is on
    ldh a, [hVBlankFlag]
    bit 1, a
    jp z, .skipOAMDMA
    ld a, HIGH(wOAMBuffer)
    call hOAMDMA

.skipOAMDMA

    ; Return with zero flag not set
    pop af
    xor a
    ldh [hVBlankFlag], a ; set hVBlankFlag to zero
    inc a ; unset zero flag
    reti

.lagFrame
    pop af ; Return with original register positions
    reti