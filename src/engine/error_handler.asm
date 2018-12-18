SECTION "ErrorHandlers", rom0
NullExecutionError:: ; TODO: Maybe actually make a proper handler??
    nop 
    jp NullExecutionError

Rst38Error:: ; TODO: Maybe actually make a proper handler??
    nop 
    jp Rst38Error
