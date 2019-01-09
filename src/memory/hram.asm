SECTION "HRAMVars", HRAM

; The OAM DMA routine
hOAMDMA::
    ds 8 ; OAMDMAEnd - OAMDMA

; Place variables that need to be zero-cleared on init (and soft-reset) below
hClearStart::

; Used to let VBlank know it needs to ACK
; IMPORTANT: VBlank doesn't preserve AF **on purpose** when this is set
; Thus, make sure to wait for the Z flag before continuing
hVBlankFlag::
    db

; Values transferred to high ram regs on VBlank update request
hLCDC::
    db
hSCY::
    db
hSCX::
    db
hWY::
    db
hWX::
    db
hBGP::
    db
hOBP0::
    db
hOBP1::
    db

hVBlankCopySrc::
    dw
hVBlankCopyDest::
    dw
hVBlankCopyLen::
    db

; hCurrentFrameInput only changes after VBlankHandler has processed.
; Request VBlankHandler to update input
hCurrentFrameInput::
    db
; hChangedInput only changes after VBlankHandler has processed.
; Request VBlankHandler to update input
hChangedInput::
    db