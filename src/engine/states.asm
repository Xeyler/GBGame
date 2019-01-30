; Engine states
STATE_PLAYING         EQU 0
STATE_DIALOGUE        EQU 1
STATE_MENU            EQU 2
STATE_LOADING_AREA    EQU 3
STATE_EXITING_AREA    EQU 4
STATE_ENTERING_AREA   EQU 5

; Game engine state handler jump table
; NOTE: The addresses here must correspond with the engine states above ^
SECTION "State Jump Table", ROM0
StateJumpTable::
    dw StateMachinePlaying
    dw StateMachineDialogue
    dw StateMachineMenu
    dw StateMachineLoadingArea
    dw StateMachineExitingArea
    dw StateMachineEnteringArea
.end::