SECTION "Input", ROM0
; Copies current joypad input into a
; @value A: input(bits ordered from highest to lowest: start, select, b, a, down, up, left, right)
GetCurrentInput::
    ld a, %00010000 ; start, select, b, a buttons
    ld [rP1], a
    ld a, [rP1] ; debounce
    ld a, [rP1]
    ld a, [rP1]
    ld a, [rP1]
    and $0F
    swap a
    ld c, a
    ld a, %00100000 ; down, up, left, right buttons
    ld [rP1], a
    ld a, [rP1] ; again, debounce
    ld a, [rP1]
    ld a, [rP1]
    ld a, [rP1]
    and $0F
    or c
    cpl ; invert bits because 0 == pressed doesn't make logical sense
    ret