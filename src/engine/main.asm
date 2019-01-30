SECTION "Engine", ROM0
; Here, we assume that interrupts are disabled and the screen is off. 
EngineInit::
    ; Initialize Engine state and variables
    xor a
    ldh [hCurrentArea], a
    ld a, STATE_LOADING_AREA
    ldh [hEngineState], a

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

EngineMainLoop:
    ; Refresh user input
    call GetCurrentInput
    ld b, a
    ldh a, [hCurrentInput] ; At this point, hCurrentInput is past input. Compare it with new value to get changed buttons
    xor b
    ldh [hChangedInput], a
    ld a, b
    ldh [hCurrentInput], a

    ; Jump to code for handling current engine state(see states.asm)
    ld a, [hEngineState]
    add a, a
    cp a, LOW(StateJumpTable.end) - LOW(StateJumpTable)
    jp nc, UnknownEngineStateError ; If the current state is greater than the state handler jump table, then jump to UnknownEngineStateError
    add a, LOW(StateJumpTable)
    ld l, a
    adc a, HIGH(StateJumpTable)
    sub l
    ld h, a
    ld a, [hli]
    ld h, [hl]
    ld l, a
    jp hl

.stateMachineEnd::

    ; Output changes
    call WaitVBlank
jp EngineMainLoop

SECTION "StateMachinePlaying", ROM0
StateMachinePlaying::

    jp EngineMainLoop.stateMachineEnd

SECTION "StateMachineDialogue", ROM0
StateMachineDialogue::

    jp EngineMainLoop.stateMachineEnd

SECTION "StateMachineMenu", ROM0
StateMachineMenu::

    jp EngineMainLoop.stateMachineEnd

SECTION "StateMachineLoadingArea", ROM0
StateMachineLoadingArea::
    ; Load requested area
    ; Set player position
    jp EngineMainLoop.stateMachineEnd

SECTION "StateMachineExitingArea", ROM0
StateMachineExitingArea::
    ; Fade out screen, changing the pallette
    ; Request new area, set state to STATE_LOADING_AREA
    jp EngineMainLoop.stateMachineEnd

SECTION "StateMachineEnteringArea", ROM0
StateMachineEnteringArea::

    jp EngineMainLoop.stateMachineEnd