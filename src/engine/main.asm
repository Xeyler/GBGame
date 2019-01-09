SECTION "Engine", ROM0
; Here, we assume that interrupts are disabled and the screen is off. 
StartTitle::

; Load title screen
    ld de, TitleScreenTilesheet
    ld hl, _VRAM
    ld bc, TitleScreenTilesheet.end - TitleScreenTilesheet
    call Memcpy
    ;ld de, TitleScreenMap
    ;ld hl, _SCRN1
    ;ld bc, TitleScreenMap.end - TitleScreenMap
    ;call Memcpy

; Reset palette
    ld a, %11100100
    ld [rBGP], a
    ld [hBGP], a

; Re-enable screen
    ld a, LCDCF_ON | LCDCF_BGON | LCDCF_BG8000
    ldh [rLCDC], a
    ldh [hLCDC], a

; Reset interrupt flag and enable interrupts
    ld a, IEF_VBLANK
    ldh [rIE], a
    xor a
    ei
    ldh [rIF], a