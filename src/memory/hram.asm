SECTION "HRAMVars", HRAM

; The OAM DMA routine
hOAMDMA::
    ds 8 ; OAMDMAEnd - OAMDMA

; Place variables that need to be zero-cleared on init (and soft-reset) below
hClearStart::

; Used to let VBlank know it need to ACK
; NOTE: VBlank doesn't preserve AF **on purpose** when this is set
; Thus, make sure to wait for Z set before continuing
hVBlankFlag::
    db

; Values transferred to high ram regs on VBlank
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

hFastCopyBank::
    db
hFastCopySrc::
    dw
hFastCopyDest::
    dw
hFastCopyLen::
    db