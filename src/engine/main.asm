SECTION "EngineStart", ROM0
StartEngine::
; Here, we assume that interrupts are disabled and the screen is off. 

; Re-enable screen
    ld a, LCDCF_ON | LCDCF_BGON
    ldh [rLCDC], a
    ldh [hLCDC], a

; Reset and enable interrupts
    ld a, IEF_VBLANK
    ldh [rIE], a
    xor a
    ei
    ldh [rIF], a