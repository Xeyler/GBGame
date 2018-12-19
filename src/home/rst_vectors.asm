; TODO: Use rst vector 08
; TODO: Use rst vector 10
; TODO: Use rst vector 17
; TODO: Use rst vector 20
; TODO: Use rst vector 28
; TODO: Use rst vector 30

SECTION "rst00", ROM0[$0000]
; Traps jumps to $0000 or PC roll-over from $FFFF
; Pad with nops incase we got here mid-operator and expect one or two operands
nop 
nop
jp NullExecutionError

SECTION "rst08", ROM0[$0008]

SECTION "rst10", ROM0[$0010]

SECTION "rst18", ROM0[$0017]

SECTION "rst20", ROM0[$0020]

SECTION "rst28", ROM0[$0028]

SECTION "rst30", ROM0[$0030]

SECTION "rst38", ROM0[$0038]
; Traps execution of opcode $FF (which is the ROM's padding)
jp Rst38Error