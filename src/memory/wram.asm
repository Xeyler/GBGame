SECTION "Stack", WRAM0[$E000 - STACK_SIZE]

wStackTop::
    ds STACK_SIZE
wStackBottom::

SECTION "WRAMVars", WRAM0