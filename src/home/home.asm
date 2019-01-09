SECTION "EntryPoint", ROM0[$0100]
EntryPoint::
    nop
    nop
    jr LogoFade

    ; Reserve space for the header
    dbr 0, $150 - $104

LogoFade: ; Fade the Nintendo logo to white
    xor a
    ldh [rAUDENA], a ; disable audio
    ldh [rDIV], a ; TODO: Is it necessary to reset rDIV? The APU uses it, but what if we didn't?
.fadeLogo
    ld c, 8 ; Number of frames between each logo fade step
.logoWait
    ld a, [rLY]
    cp a, SCRN_Y
    jr nc, .logoWait ; if rLY is greater than the screen's height, goto .logoWait
.waitVBlank
    ld a, [rLY]
    cp a, SCRN_Y
    jr c, .waitVBlank ; if rLY is less than the screen's height, goto .waitVBlank 
    dec c
    jr nz, .logoWait ; if c is nz, goto .logoWait
    ; Fade the palette by one level
    ld a, [rBGP]
    call GetFadedPalette
    ld [rBGP], a
    jr nz, .fadeLogo ; End if the palette is fully blank(GetFadedPalette sets ZF when new palette is white)

; Soft-reset to here.
; Reset SP, disable audio, disable screen, clear HRAM, copy OAMDMA function into HRAM, jump to Start
Reset::
    di
    ld sp, wStackBottom ; reset stack

    xor a
    ldh [rAUDENA], a ; disable audio
    ldh [rDIV], a ; TODO: Is it necessary to reset rDIV? The APU uses it, but what if we didn't?

.waitVBlank
    ld a, [rLY]
    cp SCRN_Y
    jr nz, .waitVBlank
    xor a
    ldh [rLCDC], a ; disable screen

; Clear HRAM
; This resets rIE, but we overwrite it soon.
    ld c, LOW(hClearStart)
    xor a
.clearHRAM
    ld [$ff00+c], a
    inc c
    jr nz, .clearHRAM

; Copy OAM DMA routine into HRAM
    ld hl, OAMDMA
    lb bc, OAMDMAEnd - OAMDMA, LOW(hOAMDMA)
.copyOAMDMA
    ld a, [hli]
    ld [$ff00+c], a
    inc c
    dec b
    jr nz, .copyOAMDMA

jp StartEngine

; Copied into HRAM during init
; Performs OAM DMA with address (a << 8)
SECTION "OAMDMARoutine", ROM0
OAMDMA:
    ldh [rDMA], a
    ld a, $28
.wait
    dec a
    jr nz, .wait
    ret
OAMDMAEnd: