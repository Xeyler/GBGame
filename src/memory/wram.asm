SECTION "Stack", WRAM0[$E000 - STACK_SIZE]

wStackTop::
    ds STACK_SIZE
wStackBottom::

SECTION "OAMBuffer", WRAM0, ALIGN[8]

wOAMBuffer::
    ds $9F

SECTION "WRAMVars", WRAM0

