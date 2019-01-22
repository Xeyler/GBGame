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
    ; User input
    call GetCurrentInput
    ld b, a
    ldh a, [hCurrentInput] ; At this point, hCurrentInput is past input. Compare it with new value to get changed buttons
    xor b
    ldh [hChangedInput], a
    ld a, b
    ldh [hCurrentInput], a

    ; State machine containing game logic
    ld a, [hEngineState]
    cp a, STATE_PLAYING
    jp z, StateMachinePlaying
    cp a, STATE_DIALOGUE
    jp z, StateMachineDialogue
    cp a, STATE_MENU
    jp z, StateMachineMenu
    cp a, STATE_LOADING_AREA
    jp z, StateMachineLoadingArea
    cp a, STATE_EXITING_AREA
    jp z, StateMachineExitingArea
    cp a, STATE_ENTERING_AREA
    jp z, StateMachineEnteringArea

    jp UnknownEngineStateError ; The current state was undefined, jump to respective error handler

.stateMachineEnd::

    ; Output
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

    jp EngineMainLoop.stateMachineEnd

SECTION "StateMachineExitingArea", ROM0
StateMachineExitingArea::

    jp EngineMainLoop.stateMachineEnd

SECTION "StateMachineEnteringArea", ROM0
StateMachineEnteringArea::

    jp EngineMainLoop.stateMachineEnd