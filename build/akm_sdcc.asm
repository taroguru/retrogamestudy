PLY_AKM_REGISTERS_OFFSETVOLUME = .+1
PLY_AKM_STOP_SOUNDS = .+1
PLY_AKM_USE_HOOKS = .+1
PLY_AKM_DATA_OFFSETPTSTARTTRACK = .+1
PLY_AKM_SOUNDEFFECTDATA_OFFSETINVERTEDVOLUME = .+2
PLY_AKM_START:
PLY_AKM_DATA_OFFSETWAITEMPTYCELL:
PLY_AKM_OFFSET2B:
PLY_AKM_OFFSET1B: jp PLY_AKM_INIT
PLY_AKM_SOUNDEFFECTDATA_OFFSETSPEED = .+1
PLY_AKM_DATA_OFFSETBASENOTE = .+2
PLY_AKM_REGISTERS_OFFSETSOFTWAREPERIODLSB = .+2
PLY_AKM_DATA_OFFSETPTTRACK:
PLY_AKM_SOUNDEFFECTDATA_OFFSETCURRENTSTEP: jp PLY_AKM_PLAY
PLY_AKM_DATA_OFFSETESCAPEINSTRUMENT = .+1
PLY_AKM_DATA_OFFSETESCAPEWAIT = .+2
PLY_AKM_DATA_OFFSETSECONDARYINSTRUMENT = .+2
PLY_AKM_DATA_OFFSETESCAPENOTE: jp PLY_AKM_INITVARS_END
PLY_AKM_DATA_OFFSETINSTRUMENTCURRENTSTEP = .+2
_PLY_AKM_INITSOUNDEFFECTS::
PLY_AKM_INITSOUNDEFFECTS:
PLY_AKM_DATA_OFFSETPTINSTRUMENT:
PLY_AKM_REGISTERS_OFFSETSOFTWAREPERIODMSB: ld (PLY_AKM_PTSOUNDEFFECTTABLE),hl
PLY_AKM_DATA_OFFSETINSTRUMENTSPEED: ret 
_PLY_AKM_PLAYSOUNDEFFECT::
PLY_AKM_PLAYSOUNDEFFECT:
PLY_AKM_DATA_OFFSETTRACKINVERTEDVOLUME: dec a
PLY_AKM_DATA_OFFSETPTARPEGGIOTABLE = .+1
PLY_AKM_DATA_OFFSETISARPEGGIOTABLEUSED: ld hl,(PLY_AKM_PTSOUNDEFFECTTABLE)
PLY_AKM_DATA_OFFSETPTARPEGGIOOFFSET: ld e,a
PLY_AKM_DATA_OFFSETARPEGGIOORIGINALSPEED = .+1
PLY_AKM_DATA_OFFSETARPEGGIOCURRENTSTEP: ld d,#0x0
PLY_AKM_DATA_OFFSETCURRENTARPEGGIOVALUE: add hl,de
    add hl,de
    ld e,(hl)
    inc hl
    ld d,(hl)
    ld a,(de)
    inc de
    ex af,af'
    ld a,b
    ld hl,#PLY_AKM_CHANNEL1_SOUNDEFFECTDATA
    ld b,#0x0
    sla c
    sla c
    sla c
    add hl,bc
    ld (hl),e
    inc hl
    ld (hl),d
    inc hl
    ld (hl),a
    inc hl
    ld (hl),#0x0
    inc hl
    ex af,af'
    ld (hl),a
    ret 
_PLY_AKM_STOPSOUNDEFFECTFROMCHANNEL::
PLY_AKM_STOPSOUNDEFFECTFROMCHANNEL: add a,a
    add a,a
    add a,a
    ld e,a
    ld d,#0x0
    ld hl,#PLY_AKM_CHANNEL1_SOUNDEFFECTDATA
    add hl,de
    ld (hl),d
    inc hl
    ld (hl),d
    ret 
PLY_AKM_PLAYSOUNDEFFECTSSTREAM: rla 
    rla 
    ld ix,#PLY_AKM_CHANNEL1_SOUNDEFFECTDATA
    ld iy,#PLY_AKM_TRACK1_REGISTERS
    ld c,a
    call PLY_AKM_PSES_PLAY
    ld ix,#PLY_AKM_CHANNEL2_SOUNDEFFECTDATA
    ld iy,#PLY_AKM_TRACK2_REGISTERS
    srl c
    call PLY_AKM_PSES_PLAY
    ld ix,#PLY_AKM_CHANNEL3_SOUNDEFFECTDATA
    ld iy,#PLY_AKM_TRACK3_REGISTERS
    scf
    rr c
    call PLY_AKM_PSES_PLAY
    ld a,c
    ld (PLY_AKM_MIXERREGISTER),a
    ret 
PLY_AKM_PSES_PLAY: ld l,+0(ix)
    ld h,+1(ix)
    ld a,l
    or h
    ret z
PLY_AKM_PSES_READFIRSTBYTE: ld a,(hl)
    inc hl
    ld b,a
    rra 
    jr c,PLY_AKM_PSES_SOFTWAREORSOFTWAREANDHARDWARE
    rra 
    rra 
PLY_AKM_PSES_S_ENDORLOOP: xor a
    ld +0(ix),a
    ld +1(ix),a
    ret 
PLY_AKM_PSES_SAVEPOINTERANDEXIT: ld a,+3(ix)
    cp +4(ix)
    jr c,PLY_AKM_PSES_NOTREACHED
    ld +3(ix),#0x0
    .db 0xdd
    .db 0x75
    .db 0x0
    .db 0xdd
    .db 0x74
    .db 0x1
    ret 
PLY_AKM_PSES_NOTREACHED: inc +3(ix)
    ret 
PLY_AKM_PSES_SOFTWAREORSOFTWAREANDHARDWARE: rra 
    call PLY_AKM_PSES_MANAGEVOLUMEFROMA_FILTER4BITS
    rl b
    call PLY_AKM_PSES_READNOISEIFNEEDEDANDOPENORCLOSENOISECHANNEL
PLY_AKM_ROM_BUFFERSIZE = .+1
    res 2,c
    call PLY_AKM_PSES_READSOFTWAREPERIOD
    jr PLY_AKM_PSES_SAVEPOINTERANDEXIT
PLY_AKM_PSES_SHARED_READRETRIGHARDWAREENVPERIODNOISE: rra 
    and #0x7
    add a,#0x8
    ld (PLY_AKM_SETREG13),a
    set 5,c
    call PLY_AKM_PSES_READHARDWAREPERIOD
    ld a,#0x10
    jp PLY_AKM_PSES_MANAGEVOLUMEFROMA_HARD
PLY_AKM_PSES_READNOISEIFNEEDEDANDOPENORCLOSENOISECHANNEL: jr c,PLY_AKM_PSES_READNOISEANDOPENNOISECHANNEL_OPENNOISE
    set 5,c
    ret 
PLY_AKM_PSES_READNOISEANDOPENNOISECHANNEL_OPENNOISE: ld a,(hl)
    ld (PLY_AKM_NOISEREGISTER),a
    inc hl
    res 5,c
    ret 
PLY_AKM_PSES_READHARDWAREPERIOD: ld a,(hl)
    ld (PLY_AKM_REG11),a
    inc hl
    ld a,(hl)
    ld (PLY_AKM_REG12),a
    inc hl
    ret 
PLY_AKM_PSES_READSOFTWAREPERIOD: ld a,(hl)
    ld +5(iy),a
    inc hl
    ld a,(hl)
    ld +9(iy),a
    inc hl
    ret 
PLY_AKM_PSES_MANAGEVOLUMEFROMA_FILTER4BITS: and #0xf
PLY_AKM_PSES_MANAGEVOLUMEFROMA_HARD: sub +2(ix)
    jr nc,PLY_AKM_PSES_MVFA_NOOVERFLOW
    xor a
PLY_AKM_PSES_MVFA_NOOVERFLOW: ld +1(iy),a
    ret 
_PLY_AKM_INIT::
PLY_AKM_INIT: ld de,#PLY_AKM_PTINSTRUMENTS
    ldi
    ldi
    ld de,#PLY_AKM_PTARPEGGIOS
    ldi
    ldi
    inc hl
    inc hl
    add a,a
    ld e,a
    ld d,#0x0
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld ix,#PLY_AKM_INITVARS_START
    ld a,#0xd
PLY_AKM_INITVARS_LOOP: ld e,+0(ix)
    ld d,+1(ix)
    inc ix
    inc ix
    ldi
    dec a
    jr nz,PLY_AKM_INITVARS_LOOP
    ld (PLY_AKM_PATTERNREMAININGHEIGHT),a
    ex de,hl
    ld hl,#PLY_AKM_PTLINKER
    ld (hl),e
    inc hl
    ld (hl),d
    ld hl,#PLY_AKM_TRACK1_WAITEMPTYCELL
    ld de,#PLY_AKM_TRACK1_PTSTARTTRACK
    ld bc,#0x3e
    ld (hl),a
    ldir
    ld (PLY_AKM_RT_READEFFECTSFLAG),a
    ld a,(PLY_AKM_SPEED)
    dec a
    ld (PLY_AKM_TICKCOUNTER),a
    ld hl,(PLY_AKM_PTINSTRUMENTS)
    ld e,(hl)
    inc hl
    ld d,(hl)
    inc de
    ld (PLY_AKM_TRACK1_PTINSTRUMENT),de
    ld (PLY_AKM_TRACK2_PTINSTRUMENT),de
    ld (PLY_AKM_TRACK3_PTINSTRUMENT),de
    ld hl,#0x0
    ld (PLY_AKM_CHANNEL1_SOUNDEFFECTDATA),hl
    ld (PLY_AKM_CHANNEL2_SOUNDEFFECTDATA),hl
    ld (PLY_AKM_CHANNEL3_SOUNDEFFECTDATA),hl
    ld ix,#PLY_AKM_REGISTERSFORROM
    ld iy,#PLY_AKM_TRACK1_REGISTERS
    ld bc,#PLY_AKM_SENDPSGREGISTER
    ld de,#0x4
PLY_AKM_INITROM_LOOP: ld a,+0(ix)
    ld h,a
    inc ix
    and #0x3f
    ld +0(iy),a
    ld +1(iy),#0x0
    ld a,h
    and #0xc0
    jr nz,PLY_AKM_INITROM_SPECIAL
    ld +2(iy),c
    ld +3(iy),b
    add iy,de
    jr PLY_AKM_INITROM_LOOP
PLY_AKM_INITROM_SPECIAL: rl h
    jr c,PLY_AKM_INITROM_WRITEENDCODE
    ld bc,#PLY_AKM_SENDPSGREGISTERR13
    ld +2(iy),c
    ld +3(iy),b
    ld bc,#PLY_AKM_SENDPSGREGISTERAFTERPOP
    ld +4(iy),c
    ld +5(iy),b
    add iy,de
PLY_AKM_INITROM_WRITEENDCODE: ld bc,#PLY_AKM_SENDPSGREGISTEREND
    ld +2(iy),c
    ld +3(iy),b
    ret 
PLY_AKM_REGISTERSFORROM: .db 0x8
    .db 0x0
    .db 0x1
    .db 0x9
    .db 0x2
    .db 0x3
    .db 0xa
    .db 0x4
    .db 0x5
    .db 0x6
    .db 0x7
    .db 0xb
    .db 0x4c
PLY_AKM_INITVARS_START: .dw PLY_AKM_NOTEINDEXTABLE
    .dw PLY_AKM_NOTEINDEXTABLE+1
    .dw PLY_AKM_TRACKINDEX
    .dw PLY_AKM_TRACKINDEX+1
    .dw PLY_AKM_SPEED
    .dw PLY_AKM_PRIMARYINSTRUMENT
    .dw PLY_AKM_SECONDARYINSTRUMENT
    .dw PLY_AKM_PRIMARYWAIT
    .dw PLY_AKM_SECONDARYWAIT
    .dw PLY_AKM_DEFAULTSTARTNOTEINTRACKS
    .dw PLY_AKM_DEFAULTSTARTINSTRUMENTINTRACKS
    .dw PLY_AKM_DEFAULTSTARTWAITINTRACKS
    .dw PLY_AKM_FLAGNOTEANDEFFECTINCELL
PLY_AKM_INITVARS_END:
_PLY_AKM_STOP::
PLY_AKM_STOP: ld (PLY_AKM_SAVESP),sp
    xor a
    ld (PLY_AKM_TRACK1_VOLUME),a
    ld (PLY_AKM_TRACK2_VOLUME),a
    ld (PLY_AKM_TRACK3_VOLUME),a
    ld a,#0xbf
    ld (PLY_AKM_MIXERREGISTER),a
    jp PLY_AKM_SENDPSG
_PLY_AKM_PLAY::
PLY_AKM_PLAY: ld (PLY_AKM_SAVESP),sp
    ld a,(PLY_AKM_SPEED)
    ld b,a
    ld a,(PLY_AKM_TICKCOUNTER)
    inc a
    cp b
    jp nz,PLY_AKM_TICKCOUNTERMANAGED
    ld a,(PLY_AKM_PATTERNREMAININGHEIGHT)
    sub #0x1
    jr c,PLY_AKM_LINKER
    ld (PLY_AKM_PATTERNREMAININGHEIGHT),a
    jr PLY_AKM_READLINE
PLY_AKM_LINKER: ld de,(PLY_AKM_TRACKINDEX)
    exx
    ld hl,(PLY_AKM_PTLINKER)
PLY_AKM_LINKERPOSTPT: xor a
    ld (PLY_AKM_TRACK1_WAITEMPTYCELL),a
    ld (PLY_AKM_TRACK2_WAITEMPTYCELL),a
    ld (PLY_AKM_TRACK3_WAITEMPTYCELL),a
    ld a,(PLY_AKM_DEFAULTSTARTNOTEINTRACKS)
    ld (PLY_AKM_TRACK1_ESCAPENOTE),a
    ld (PLY_AKM_TRACK2_ESCAPENOTE),a
    ld (PLY_AKM_TRACK3_ESCAPENOTE),a
    ld a,(PLY_AKM_DEFAULTSTARTINSTRUMENTINTRACKS)
    ld (PLY_AKM_TRACK1_ESCAPEINSTRUMENT),a
    ld (PLY_AKM_TRACK2_ESCAPEINSTRUMENT),a
    ld (PLY_AKM_TRACK3_ESCAPEINSTRUMENT),a
    ld a,(PLY_AKM_DEFAULTSTARTWAITINTRACKS)
    ld (PLY_AKM_TRACK1_ESCAPEWAIT),a
    ld (PLY_AKM_TRACK2_ESCAPEWAIT),a
    ld (PLY_AKM_TRACK3_ESCAPEWAIT),a
    ld b,(hl)
    inc hl
    rr b
    jr nc,PLY_AKM_LINKERAFTERSPEEDCHANGE
    ld a,(hl)
    inc hl
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    jr PLY_AKM_LINKERPOSTPT
PLY_AKM_LINKERAFTERSPEEDCHANGE: rr b
    jr nc,PLY_AKM_LINKERUSEPREVIOUSHEIGHT
    ld a,(hl)
    inc hl
    ld (PLY_AKM_LINKERPREVIOUSREMAININGHEIGHT),a
    jr PLY_AKM_LINKERSETREMAININGHEIGHT
PLY_AKM_LINKERUSEPREVIOUSHEIGHT: ld a,(PLY_AKM_LINKERPREVIOUSREMAININGHEIGHT)
PLY_AKM_LINKERSETREMAININGHEIGHT: ld (PLY_AKM_PATTERNREMAININGHEIGHT),a
    ld ix,#PLY_AKM_TRACK1_WAITEMPTYCELL
    call PLY_AKM_CHECKTRANSPOSITIONANDTRACK
    ld ix,#PLY_AKM_TRACK2_WAITEMPTYCELL
    call PLY_AKM_CHECKTRANSPOSITIONANDTRACK
    ld ix,#PLY_AKM_TRACK3_WAITEMPTYCELL
    call PLY_AKM_CHECKTRANSPOSITIONANDTRACK
    ld (PLY_AKM_PTLINKER),hl
PLY_AKM_READLINE: ld de,(PLY_AKM_PTINSTRUMENTS)
    ld bc,(PLY_AKM_NOTEINDEXTABLE)
    exx
    ld ix,#PLY_AKM_TRACK1_WAITEMPTYCELL
    call PLY_AKM_READTRACK
    ld ix,#PLY_AKM_TRACK2_WAITEMPTYCELL
    call PLY_AKM_READTRACK
    ld ix,#PLY_AKM_TRACK3_WAITEMPTYCELL
    call PLY_AKM_READTRACK
    xor a
PLY_AKM_TICKCOUNTERMANAGED: ld (PLY_AKM_TICKCOUNTER),a
    ld de,#PLY_AKM_PERIODTABLE
    exx
    ld c,#0xe0
    ld ix,#PLY_AKM_TRACK1_WAITEMPTYCELL
    call PLY_AKM_MANAGEEFFECTS
    ld iy,#PLY_AKM_TRACK1_REGISTERS
    call PLY_AKM_PLAYSOUNDSTREAM
    srl c
    ld ix,#PLY_AKM_TRACK2_WAITEMPTYCELL
    call PLY_AKM_MANAGEEFFECTS
    ld iy,#PLY_AKM_TRACK2_REGISTERS
    call PLY_AKM_PLAYSOUNDSTREAM
    scf
    rr c
    ld ix,#PLY_AKM_TRACK3_WAITEMPTYCELL
    call PLY_AKM_MANAGEEFFECTS
    ld iy,#PLY_AKM_TRACK3_REGISTERS
    call PLY_AKM_PLAYSOUNDSTREAM
    ld a,c
    call PLY_AKM_PLAYSOUNDEFFECTSSTREAM
PLY_AKM_SENDPSG: ld sp,#PLY_AKM_TRACK1_REGISTERS
PLY_AKM_SENDPSGREGISTER: pop hl
PLY_AKM_SENDPSGREGISTERAFTERPOP: ld a,l
    out (0xa0),a
    ld a,h
    out (0xa1),a
    ret 
PLY_AKM_SENDPSGREGISTERR13: ld a,(PLY_AKM_SETREG13OLD)
    ld b,a
    ld a,(PLY_AKM_SETREG13)
    cp b
    jr z,PLY_AKM_SENDPSGREGISTEREND
    ld (PLY_AKM_SETREG13OLD),a
    ld h,a
    ld l,#0xd
    ret 
PLY_AKM_SENDPSGREGISTEREND: ld sp,(PLY_AKM_SAVESP)
    ret 
PLY_AKM_CHECKTRANSPOSITIONANDTRACK: rr b
    rr b
    jr nc,PLY_AKM_CHECKTRANSPOSITIONANDTRACK_NONEWTRACK
    ld a,(hl)
    inc hl
    sla a
    jr nc,PLY_AKM_CHECKTRANSPOSITIONANDTRACK_TRACKOFFSET
    exx
    ld l,a
    ld h,#0x0
    add hl,de
    ld a,(hl)
    ld +1(ix),a
    ld +3(ix),a
    inc hl
    ld a,(hl)
    ld +2(ix),a
    ld +4(ix),a
    exx
    ret 
PLY_AKM_CHECKTRANSPOSITIONANDTRACK_TRACKOFFSET: rra 
    ld d,a
    ld e,(hl)
    inc hl
    ld c,l
    ld a,h
    add hl,de
    .db 0xdd
    .db 0x75
    .db 0x1
    .db 0xdd
    .db 0x74
    .db 0x2
    .db 0xdd
    .db 0x75
    .db 0x3
    .db 0xdd
    .db 0x74
    .db 0x4
    ld l,c
    ld h,a
    ret 
PLY_AKM_CHECKTRANSPOSITIONANDTRACK_NONEWTRACK: ld a,+1(ix)
    ld +3(ix),a
    ld a,+2(ix)
    ld +4(ix),a
    ret 
PLY_AKM_READTRACK: ld a,+0(ix)
    sub #0x1
    jr c,PLY_AKM_RT_NOEMPTYCELL
    ld +0(ix),a
    ret 
PLY_AKM_RT_NOEMPTYCELL: ld l,+3(ix)
    ld h,+4(ix)
PLY_AKM_RT_GETDATABYTE: ld b,(hl)
    inc hl
    ld a,(PLY_AKM_FLAGNOTEANDEFFECTINCELL)
    ld c,a
    ld a,b
    and #0xf
    cp c
    jr c,PLY_AKM_RT_NOTEREFERENCE
    sub #0xc
    jr z,PLY_AKM_RT_NOTEANDEFFECTS
    dec a
    jr z,PLY_AKM_RT_NONOTEMAYBEEFFECTS
    dec a
    jr z,PLY_AKM_RT_NEWESCAPENOTE
    ld a,+6(ix)
    jr PLY_AKM_RT_AFTERNOTEREAD
PLY_AKM_RT_NEWESCAPENOTE: ld a,(hl)
    ld +6(ix),a
    inc hl
    jr PLY_AKM_RT_AFTERNOTEREAD
PLY_AKM_RT_NOTEANDEFFECTS: dec a
    ld (PLY_AKM_RT_READEFFECTSFLAG),a
    jr PLY_AKM_RT_GETDATABYTE
PLY_AKM_RT_NONOTEMAYBEEFFECTS: bit 4,b
    jr z,PLY_AKM_RT_READWAITFLAGS
    ld a,b
    ld (PLY_AKM_RT_READEFFECTSFLAG),a
    jr PLY_AKM_RT_READWAITFLAGS
PLY_AKM_RT_NOTEREFERENCE: exx
    ld l,a
    ld h,#0x0
    add hl,bc
    ld a,(hl)
    exx
PLY_AKM_RT_AFTERNOTEREAD: ld +5(ix),a
    ld a,b
    and #0x30
    jr z,PLY_AKM_RT_SAMEESCAPEINSTRUMENT
    cp #0x10
    jr z,PLY_AKM_RT_PRIMARYINSTRUMENT
    cp #0x20
    jr z,PLY_AKM_RT_SECONDARYINSTRUMENT
    ld a,(hl)
    inc hl
    ld +7(ix),a
    jr PLY_AKM_RT_STORECURRENTINSTRUMENT
PLY_AKM_RT_SAMEESCAPEINSTRUMENT: ld a,+7(ix)
    jr PLY_AKM_RT_STORECURRENTINSTRUMENT
PLY_AKM_RT_SECONDARYINSTRUMENT: ld a,(PLY_AKM_SECONDARYINSTRUMENT)
    jr PLY_AKM_RT_STORECURRENTINSTRUMENT
PLY_AKM_RT_PRIMARYINSTRUMENT: ld a,(PLY_AKM_PRIMARYINSTRUMENT)
PLY_AKM_RT_STORECURRENTINSTRUMENT: exx
    add a,a
    ld l,a
    ld h,#0x0
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld a,(hl)
    inc hl
    ld +12(ix),a
    .db 0xdd
    .db 0x75
    .db 0x9
    .db 0xdd
    .db 0x74
    .db 0xa
    exx
    xor a
    ld +11(ix),a
    ld +17(ix),a
    ld +18(ix),a
PLY_AKM_RT_READWAITFLAGS: ld a,b
    and #0xc0
    jr z,PLY_AKM_RT_SAMEESCAPEWAIT
    cp #0x40
    jr z,PLY_AKM_RT_PRIMARYWAIT
    cp #0x80
    jr z,PLY_AKM_RT_SECONDARYWAIT
    ld a,(hl)
    inc hl
    ld +8(ix),a
    jr PLY_AKM_RT_STORECURRENTWAIT
PLY_AKM_RT_SAMEESCAPEWAIT: ld a,+8(ix)
    jr PLY_AKM_RT_STORECURRENTWAIT
PLY_AKM_RT_PRIMARYWAIT: ld a,(PLY_AKM_PRIMARYWAIT)
    jr PLY_AKM_RT_STORECURRENTWAIT
PLY_AKM_RT_SECONDARYWAIT: ld a,(PLY_AKM_SECONDARYWAIT)
PLY_AKM_RT_STORECURRENTWAIT: ld +0(ix),a
    ld a,(PLY_AKM_RT_READEFFECTSFLAG)
    or a
    jr nz,PLY_AKM_RT_READEFFECTS
PLY_AKM_RT_AFTEREFFECTS: .db 0xdd
    .db 0x75
    .db 0x3
    .db 0xdd
    .db 0x74
    .db 0x4
    ret 
PLY_AKM_RT_READEFFECTS: xor a
    ld (PLY_AKM_RT_READEFFECTSFLAG),a
PLY_AKM_RT_READEFFECT: ld iy,#PLY_AKM_EFFECTTABLE
    ld b,(hl)
    ld a,b
    inc hl
    and #0xe
    ld e,a
    ld d,#0x0
    add iy,de
    ld a,b
    rra 
    rra 
    rra 
    rra 
    and #0xf
    jp (iy)
PLY_AKM_RT_READEFFECT_RETURN: bit 0,b
    jr nz,PLY_AKM_RT_READEFFECT
    jr PLY_AKM_RT_AFTEREFFECTS
PLY_AKM_RT_WAITLONG: ld a,(hl)
    inc hl
    ld +0(ix),a
    jr PLY_AKM_RT_CELLREAD
PLY_AKM_RT_WAITSHORT: ld a,b
    rlca 
    rlca 
    and #0x3
    ld +0(ix),a
PLY_AKM_RT_CELLREAD: .db 0xdd
    .db 0x75
    .db 0x3
    .db 0xdd
    .db 0x74
    .db 0x4
    ret 
PLY_AKM_MANAGEEFFECTS: ld a,+14(ix)
    or a
    jr z,PLY_AKM_ME_ARPEGGIOTABLEFINISHED
    ld e,+15(ix)
    ld d,+16(ix)
    ld l,+17(ix)
    ld h,#0x0
    add hl,de
    ld a,(hl)
    sra a
    ld +20(ix),a
    ld a,+18(ix)
    cp +19(ix)
    jr c,PLY_AKM_ME_ARPEGGIOTABLE_SPEEDNOTREACHED
    ld +18(ix),#0x0
    inc +17(ix)
    inc hl
    ld a,(hl)
    rra 
    jr nc,PLY_AKM_ME_ARPEGGIOTABLEFINISHED
    ld l,a
    ld +17(ix),a
    jr PLY_AKM_ME_ARPEGGIOTABLEFINISHED
PLY_AKM_ME_ARPEGGIOTABLE_SPEEDNOTREACHED: inc a
    ld +18(ix),a
PLY_AKM_ME_ARPEGGIOTABLEFINISHED: ret 
PLY_AKM_PLAYSOUNDSTREAM: ld l,+9(ix)
    ld h,+10(ix)
PLY_AKM_PSS_READFIRSTBYTE: ld a,(hl)
    ld b,a
    inc hl
    rra 
    jr c,PLY_AKM_PSS_SOFTORSOFTANDHARD
    rra 
    jr c,PLY_AKM_PSS_SOFTWARETOHARDWARE
    rra 
    jr nc,PLY_AKM_PSS_NSNH_NOTENDOFSOUND
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    .db 0xdd
    .db 0x75
    .db 0x9
    .db 0xdd
    .db 0x74
    .db 0xa
    jr PLY_AKM_PSS_READFIRSTBYTE
PLY_AKM_PSS_NSNH_NOTENDOFSOUND: set 2,c
    call PLY_AKM_PSS_SHARED_ADJUSTVOLUME
    ld +1(iy),a
    rl b
    jr PLY_AKM_PSS_SHARED_STOREINSTRUMENTPOINTER
PLY_AKM_PSS_SOFTORSOFTANDHARD: rra 
    jr c,PLY_AKM_PSS_SOFTANDHARD
    call PLY_AKM_PSS_SHARED_ADJUSTVOLUME
    ld +1(iy),a
    ld d,#0x0
    rl b
    jr nc,PLY_AKM_PSS_S_AFTERARPANDORNOISE
    ld a,(hl)
    inc hl
    sra a
    ld d,a
    call c,PLY_AKM_PSS_READNOISE
PLY_AKM_PSS_S_AFTERARPANDORNOISE: ld a,d
    call PLY_AKM_CALCULATEPERIODFORBASENOTE
    rl b
    call c,PLY_AKM_READPITCHANDADDTOPERIOD
    exx
    ld +5(iy),l
    ld +9(iy),h
    exx
PLY_AKM_PSS_SHARED_STOREINSTRUMENTPOINTER: ld a,+11(ix)
    cp +12(ix)
    jr nc,PLY_AKM_PSS_S_SPEEDREACHED
    inc +11(ix)
    ret 
PLY_AKM_PSS_S_SPEEDREACHED: .db 0xdd
    .db 0x75
    .db 0x9
    .db 0xdd
    .db 0x74
    .db 0xa
    ld +11(ix),#0x0
    ret 
PLY_AKM_PSS_SOFTANDHARD: call PLY_AKM_PSS_SHARED_READENVBITPITCHARP_SOFTPERIOD_HARDVOL_HARDENV
    ld a,(hl)
    ld (PLY_AKM_REG11),a
    inc hl
    ld a,(hl)
    ld (PLY_AKM_REG12),a
    inc hl
    jr PLY_AKM_PSS_SHARED_STOREINSTRUMENTPOINTER
PLY_AKM_PSS_SOFTWARETOHARDWARE: call PLY_AKM_PSS_SHARED_READENVBITPITCHARP_SOFTPERIOD_HARDVOL_HARDENV
    ld a,b
    rlca 
    rlca 
    rlca 
    rlca 
    and #0x7
    exx
    jr z,PLY_AKM_PSS_STH_RATIOEND
PLY_AKM_PSS_STH_RATIOLOOP: srl h
    rr l
    dec a
    jr nz,PLY_AKM_PSS_STH_RATIOLOOP
    jr nc,PLY_AKM_PSS_STH_RATIOEND
    inc hl
PLY_AKM_PSS_STH_RATIOEND: ld a,l
    ld (PLY_AKM_REG11),a
    ld a,h
    ld (PLY_AKM_REG12),a
    exx
    jr PLY_AKM_PSS_SHARED_STOREINSTRUMENTPOINTER
PLY_AKM_PSS_SHARED_READENVBITPITCHARP_SOFTPERIOD_HARDVOL_HARDENV: and #0x2
    add a,#0x8
    ld (PLY_AKM_SETREG13),a
    ld +1(iy),#0x10
    xor a
    call PLY_AKM_CALCULATEPERIODFORBASENOTE
    exx
    ld +5(iy),l
    ld +9(iy),h
    exx
    ret 
PLY_AKM_PSS_SHARED_ADJUSTVOLUME: and #0xf
    sub +13(ix)
    ret nc
    xor a
    ret 
PLY_AKM_PSS_READNOISE: ld a,(hl)
    inc hl
    ld (PLY_AKM_NOISEREGISTER),a
    res 5,c
    ret 
PLY_AKM_CALCULATEPERIODFORBASENOTE: exx
    ld h,#0x0
    add a,+5(ix)
    add a,+20(ix)
    ld bc,#0xff0c
PLY_AKM_FINDOCTAVE_LOOP: inc b
    sub c
    jr nc,PLY_AKM_FINDOCTAVE_LOOP
    add a,c
    add a,a
    ld l,a
    ld h,#0x0
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld a,b
    or a
    jr z,PLY_AKM_FINDOCTAVE_OCTAVESHIFTLOOP_FINISHED
PLY_AKM_FINDOCTAVE_OCTAVESHIFTLOOP: srl h
    rr l
    djnz PLY_AKM_FINDOCTAVE_OCTAVESHIFTLOOP
PLY_AKM_FINDOCTAVE_OCTAVESHIFTLOOP_FINISHED: jr nc,PLY_AKM_FINDOCTAVE_FINISHED
    inc hl
PLY_AKM_FINDOCTAVE_FINISHED: exx
    ret 
PLY_AKM_READPITCHANDADDTOPERIOD: ld a,(hl)
    inc hl
    exx
    ld c,a
    exx
    ld a,(hl)
    inc hl
    exx
    ld b,a
    add hl,bc
    exx
    ret 
PLY_AKM_EFFECTRESETWITHVOLUME: ld +13(ix),a
    xor a
    ld +14(ix),a
    ld +20(ix),a
    jp PLY_AKM_RT_READEFFECT_RETURN
PLY_AKM_EFFECTVOLUME: ld +13(ix),a
    jp PLY_AKM_RT_READEFFECT_RETURN
PLY_AKM_EFFECTTABLE: jr PLY_AKM_EFFECTRESETWITHVOLUME
    jr PLY_AKM_EFFECTVOLUME
    jr PLY_AKM_EFFECTTABLE+4
    jr PLY_AKM_EFFECTARPEGGIOTABLE
    jr PLY_AKM_EFFECTARPEGGIOTABLE-6
    jr PLY_AKM_EFFECTARPEGGIOTABLE-4
    jr PLY_AKM_EFFECTARPEGGIOTABLE-2
PLY_AKM_EFFECTARPEGGIOTABLE: call PLY_AKM_EFFECTREADIFESCAPE
    ld +14(ix),a
    or a
    jr z,PLY_AKM_EFFECTARPEGGIOTABLE_STOP
    add a,a
    exx
    ld l,a
    ld h,#0x0
    ld bc,(PLY_AKM_PTARPEGGIOS)
    add hl,bc
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld a,(hl)
    inc hl
    ld +19(ix),a
    .db 0xdd
    .db 0x75
    .db 0xf
    .db 0xdd
    .db 0x74
    .db 0x10
    ld bc,(PLY_AKM_NOTEINDEXTABLE)
    exx
    xor a
    ld +17(ix),a
    ld +18(ix),a
    jp PLY_AKM_RT_READEFFECT_RETURN
PLY_AKM_EFFECTARPEGGIOTABLE_STOP: ld +20(ix),a
    jp PLY_AKM_RT_READEFFECT_RETURN
PLY_AKM_EFFECTREADIFESCAPE: cp #0xf
    ret c
    ld a,(hl)
    inc hl
    ret 
PLY_AKM_PERIODTABLE: .dw 0x1a7a
    .dw 0x18fe
    .dw 0x1797
    .dw 0x1644
    .dw 0x1504
    .dw 0x13d6
    .dw 0x12b9
    .dw 0x11ac
    .dw 0x10ae
    .dw 0xfbe
    .dw 0xedc
    .dw 0xe07
PLY_AKM_END:
_PLY_AKM_ISSOUNDEFFECTON::
PLY_AKM_ISSOUNDEFFECTON: ld a,l
    add a,a
    add a,a
    add a,a
    ld c,a
    ld b,#0x0
    ld hl,#PLY_AKM_CHANNEL1_SOUNDEFFECTDATA
    add hl,bc
    ld a,(hl)
    inc hl
    or (hl)
    ld l,a
    ret 
_SONG::
ALIENALL_START:
_ALIENALL_START:: .dw ALIENALL_INSTRUMENTINDEXES
    .dw ALIENALL_INSTRUMENT9LOOP+2
    .dw 0x0
    .dw ALIENALL_PITCHINDEXES
ALIENALL_INSTRUMENTINDEXES: .dw ALIENALL_INSTRUMENT0
    .dw ALIENALL_INSTRUMENT1
    .dw ALIENALL_INSTRUMENT2
    .dw ALIENALL_INSTRUMENT3
    .dw ALIENALL_INSTRUMENT4
    .dw ALIENALL_INSTRUMENT5
    .dw ALIENALL_INSTRUMENT6
    .dw ALIENALL_INSTRUMENT7
    .dw ALIENALL_INSTRUMENT8
    .dw ALIENALL_INSTRUMENT9
ALIENALL_INSTRUMENT0: .db 0xff
ALIENALL_INSTRUMENT0LOOP: .db 0x0
    .db 0x4
    .dw ALIENALL_INSTRUMENT0LOOP
ALIENALL_INSTRUMENT1: .db 0x0
    .db 0x3d
    .db 0x3d
    .db 0x39
    .db 0x39
    .db 0x35
    .db 0x35
    .db 0x31
    .db 0x31
    .db 0x2d
    .db 0x2d
    .db 0x29
    .db 0x29
    .db 0x25
    .db 0x25
    .db 0x21
    .db 0x21
    .db 0x1d
    .db 0x1d
    .db 0x19
    .db 0x19
    .db 0x15
    .db 0x15
    .db 0x11
    .db 0x11
    .db 0xd
    .db 0xd
    .db 0x9
    .db 0x9
    .db 0x5
    .db 0x5
    .db 0x0
ALIENALL_INSTRUMENT1LOOP: .db 0x0
    .db 0x4
    .dw ALIENALL_INSTRUMENT1LOOP
ALIENALL_INSTRUMENT2: .db 0x0
    .db 0x35
    .db 0x35
    .db 0x35
    .db 0x35
    .db 0x39
    .db 0x39
    .db 0x39
    .db 0x39
    .db 0x3d
    .db 0x3d
    .db 0x3d
    .db 0x3d
    .db 0x3d
    .db 0x3d
    .db 0x3d
    .db 0x39
    .db 0x39
    .db 0x39
    .db 0x39
    .db 0x39
    .db 0x35
    .db 0x35
    .db 0x35
    .db 0x35
    .db 0x35
    .db 0x31
    .db 0x31
    .db 0x31
    .db 0x31
    .db 0x31
    .db 0x31
    .db 0x31
ALIENALL_INSTRUMENT2LOOP: .db 0x31
    .db 0x31
    .db 0x31
    .db 0x31
    .db 0x31
    .db 0x31
    .db 0x4
    .dw ALIENALL_INSTRUMENT2LOOP
ALIENALL_INSTRUMENT3: .db 0x0
    .db 0x2d
    .db 0x31
    .db 0x31
    .db 0x31
    .db 0x6d
    .db 0x1
    .db 0x0
    .db 0x6d
    .db 0x1
    .db 0x0
    .db 0x6d
    .db 0x1
    .db 0x0
    .db 0x6d
    .db 0x1
    .db 0x0
    .db 0x2d
    .db 0x2d
    .db 0x2d
    .db 0x2d
    .db 0x6d
    .db 0x1
    .db 0x0
    .db 0x6d
    .db 0x1
    .db 0x0
    .db 0x6d
    .db 0x1
    .db 0x0
    .db 0x6d
    .db 0x1
    .db 0x0
    .db 0x2d
    .db 0x2d
    .db 0x2d
    .db 0x2d
    .db 0x6d
    .db 0x1
    .db 0x0
    .db 0x6d
    .db 0x1
    .db 0x0
    .db 0x6d
    .db 0x1
    .db 0x0
    .db 0x6d
    .db 0x1
    .db 0x0
    .db 0x2d
    .db 0x2d
    .db 0x2d
    .db 0x2d
    .db 0x6d
    .db 0x1
    .db 0x0
    .db 0x6d
    .db 0x1
    .db 0x0
    .db 0x6d
    .db 0x1
    .db 0x0
    .db 0x6d
    .db 0x1
    .db 0x0
ALIENALL_INSTRUMENT3LOOP: .db 0x2d
    .db 0x2d
    .db 0x2d
    .db 0x2d
    .db 0x6d
    .db 0xff
    .db 0xff
    .db 0x6d
    .db 0xff
    .db 0xff
    .db 0x6d
    .db 0xff
    .db 0xff
    .db 0x6d
    .db 0xff
    .db 0xff
    .db 0x4
    .dw ALIENALL_INSTRUMENT3LOOP
ALIENALL_INSTRUMENT4: .db 0x0
    .db 0x3d
    .db 0x7d
    .db 0x1
    .db 0x0
    .db 0x79
    .db 0x2
    .db 0x0
    .db 0x79
    .db 0x3
    .db 0x0
    .db 0x75
    .db 0x2
    .db 0x0
    .db 0x75
    .db 0x1
    .db 0x0
    .db 0x75
    .db 0xff
    .db 0xff
    .db 0x75
    .db 0xfe
    .db 0xff
    .db 0x75
    .db 0xfd
    .db 0xff
    .db 0x71
    .db 0xfe
    .db 0xff
    .db 0x71
    .db 0xff
    .db 0xff
    .db 0x71
    .db 0x1
    .db 0x0
    .db 0x71
    .db 0x3
    .db 0x0
    .db 0x71
    .db 0x5
    .db 0x0
    .db 0x75
    .db 0x3
    .db 0x0
    .db 0x75
    .db 0x1
    .db 0x0
    .db 0x75
    .db 0xff
    .db 0xff
    .db 0x75
    .db 0xfd
    .db 0xff
    .db 0x75
    .db 0xfb
    .db 0xff
    .db 0x71
    .db 0xfd
    .db 0xff
    .db 0x71
    .db 0xff
    .db 0xff
    .db 0x71
    .db 0x1
    .db 0x0
    .db 0x71
    .db 0x4
    .db 0x0
    .db 0x71
    .db 0x7
    .db 0x0
    .db 0x75
    .db 0x4
    .db 0x0
    .db 0x75
    .db 0x1
    .db 0x0
    .db 0x75
    .db 0xff
    .db 0xff
    .db 0x75
    .db 0xfc
    .db 0xff
    .db 0x75
    .db 0xf9
    .db 0xff
    .db 0x71
    .db 0xfc
    .db 0xff
    .db 0x71
    .db 0xff
    .db 0xff
ALIENALL_INSTRUMENT4LOOP: .db 0x31
    .db 0x4
    .dw ALIENALL_INSTRUMENT4LOOP
ALIENALL_INSTRUMENT5: .db 0x0
    .db 0x39
    .db 0x39
    .db 0x39
    .db 0x39
    .db 0x35
    .db 0x35
    .db 0x35
    .db 0x35
    .db 0x71
    .db 0xff
    .db 0xff
    .db 0x71
    .db 0xfe
    .db 0xff
    .db 0x71
    .db 0xff
    .db 0xff
    .db 0x2d
    .db 0x6d
    .db 0x1
    .db 0x0
    .db 0x6d
    .db 0x2
    .db 0x0
    .db 0x6d
    .db 0x1
    .db 0x0
    .db 0x2d
    .db 0x2d
    .db 0x71
    .db 0x1
    .db 0x0
    .db 0x71
    .db 0x2
    .db 0x0
    .db 0x71
    .db 0x3
    .db 0x0
    .db 0x71
    .db 0x2
    .db 0x0
    .db 0x71
    .db 0x1
    .db 0x0
    .db 0x71
    .db 0xff
    .db 0xff
    .db 0x75
    .db 0xfe
    .db 0xff
    .db 0x75
    .db 0xfd
    .db 0xff
    .db 0x75
    .db 0xfe
    .db 0xff
    .db 0x75
    .db 0xff
    .db 0xff
    .db 0x75
    .db 0x2
    .db 0x0
    .db 0x75
    .db 0x3
    .db 0x0
    .db 0x79
    .db 0x4
    .db 0x0
    .db 0x79
    .db 0x3
    .db 0x0
    .db 0x79
    .db 0x2
    .db 0x0
ALIENALL_INSTRUMENT5LOOP: .db 0x71
    .db 0x1
    .db 0x0
    .db 0x75
    .db 0x2
    .db 0x0
    .db 0x75
    .db 0x3
    .db 0x0
    .db 0x75
    .db 0x2
    .db 0x0
    .db 0x75
    .db 0x1
    .db 0x0
    .db 0x75
    .db 0xfe
    .db 0xff
    .db 0x75
    .db 0xfd
    .db 0xff
    .db 0x79
    .db 0xfc
    .db 0xff
    .db 0x79
    .db 0xfd
    .db 0xff
    .db 0x79
    .db 0xfe
    .db 0xff
    .db 0x4
    .dw ALIENALL_INSTRUMENT5LOOP
ALIENALL_INSTRUMENT6: .db 0x0
    .db 0x3d
    .db 0x35
    .db 0x2d
    .db 0x29
    .db 0x25
    .db 0x21
    .db 0x21
    .db 0x1d
    .db 0x1d
    .db 0x19
    .db 0x19
    .db 0x15
    .db 0x15
    .db 0x15
    .db 0x11
    .db 0x11
    .db 0x11
    .db 0xd
    .db 0xd
    .db 0xd
    .db 0x9
    .db 0x9
    .db 0x9
    .db 0x9
    .db 0x5
    .db 0x5
    .db 0x5
    .db 0x5
    .db 0x0
    .db 0x0
    .db 0x0
ALIENALL_INSTRUMENT6LOOP: .db 0x0
    .db 0x4
    .dw ALIENALL_INSTRUMENT6LOOP
ALIENALL_INSTRUMENT7: .db 0x0
    .db 0xbd
    .db 0x1
    .db 0xc
    .db 0x7d
    .db 0x32
    .db 0x0
    .db 0x7d
    .db 0x64
    .db 0x0
    .db 0x7d
    .db 0x91
    .db 0x0
    .db 0x7d
    .db 0xbe
    .db 0x0
    .db 0x79
    .db 0xeb
    .db 0x0
    .db 0x79
    .db 0x22
    .db 0x1
    .db 0x75
    .db 0x4a
    .db 0x1
    .db 0x71
    .db 0x7c
    .db 0x1
    .db 0x69
    .db 0xa9
    .db 0x1
    .db 0x59
    .db 0xd6
    .db 0x1
    .db 0x0
    .db 0x0
    .db 0x0
    .db 0x0
    .db 0x0
    .db 0x0
    .db 0x0
    .db 0x0
    .db 0x0
    .db 0x0
    .db 0x0
    .db 0x0
    .db 0x0
    .db 0x0
    .db 0x0
    .db 0x0
    .db 0x0
    .db 0x0
    .db 0x0
    .db 0x0
ALIENALL_INSTRUMENT7LOOP: .db 0x0
    .db 0x4
    .dw ALIENALL_INSTRUMENT7LOOP
ALIENALL_INSTRUMENT8: .db 0x0
    .db 0xb9
    .db 0x1
    .db 0x9
    .db 0xf9
    .db 0x1
    .db 0x9
    .db 0x20
    .db 0x0
    .db 0xf5
    .db 0x1
    .db 0x8
    .db 0x40
    .db 0x0
    .db 0xf5
    .db 0x1
    .db 0x6
    .db 0x60
    .db 0x0
    .db 0xf1
    .db 0x1
    .db 0x6
    .db 0xa0
    .db 0x0
    .db 0xf1
    .db 0x1
    .db 0x7
    .db 0xe0
    .db 0x0
    .db 0xad
    .db 0x1
    .db 0x8
    .db 0xed
    .db 0x1
    .db 0x9
    .db 0x20
    .db 0x0
    .db 0xe9
    .db 0x1
    .db 0xb
    .db 0x40
    .db 0x0
    .db 0xe9
    .db 0x1
    .db 0xa
    .db 0x60
    .db 0x0
    .db 0xe5
    .db 0x1
    .db 0x9
    .db 0xa0
    .db 0x0
    .db 0xe5
    .db 0x1
    .db 0x6
    .db 0xe0
    .db 0x0
    .db 0xa1
    .db 0x1
    .db 0x6
    .db 0xe1
    .db 0x1
    .db 0x8
    .db 0x20
    .db 0x0
    .db 0xd9
    .db 0x1
    .db 0x8
    .db 0x40
    .db 0x0
    .db 0xd5
    .db 0x1
    .db 0x7
    .db 0x60
    .db 0x0
    .db 0xc9
    .db 0x1
    .db 0x6
    .db 0x80
    .db 0x0
    .db 0x0
    .db 0x0
    .db 0x0
    .db 0x0
    .db 0x0
    .db 0x0
    .db 0x0
    .db 0x0
    .db 0x0
    .db 0x0
    .db 0x0
    .db 0x0
    .db 0x0
    .db 0x0
ALIENALL_INSTRUMENT8LOOP: .db 0x0
    .db 0x4
    .dw ALIENALL_INSTRUMENT8LOOP
ALIENALL_INSTRUMENT9: .db 0x0
ALIENALL_INSTRUMENT9LOOP: .db 0x52
    .db 0x4
    .dw ALIENALL_INSTRUMENT9LOOP
ALIENALL_ARPEGGIOINDEXES: .dw ALIENALL_ARPEGGIO1
    .dw ALIENALL_ARPEGGIO2
    .dw ALIENALL_ARPEGGIO3
    .dw ALIENALL_ARPEGGIO4
ALIENALL_ARPEGGIO1: .db 0x0
    .db 0x0
    .db 0x0
    .db 0xf6
    .db 0xf6
    .db 0xf0
    .db 0xf0
    .db 0x0
    .db 0x0
    .db 0xf6
    .db 0xf6
    .db 0xf0
    .db 0xf0
    .db 0x0
    .db 0x0
    .db 0xf6
    .db 0xf6
    .db 0xf0
    .db 0xf0
    .db 0x0
    .db 0x0
    .db 0xf6
    .db 0xf6
    .db 0xf0
    .db 0xf0
    .db 0x0
    .db 0x0
    .db 0xf6
    .db 0xf6
    .db 0xf0
    .db 0xf0
    .db 0x0
    .db 0x0
    .db 0x1
ALIENALL_ARPEGGIO2: .db 0x0
    .db 0x0
    .db 0x0
    .db 0xf8
    .db 0xf8
    .db 0xf2
    .db 0xf2
    .db 0x0
    .db 0x0
    .db 0xf8
    .db 0xf8
    .db 0xf2
    .db 0xf2
    .db 0x0
    .db 0x0
    .db 0xf8
    .db 0xf8
    .db 0xf2
    .db 0xf2
    .db 0x0
    .db 0x0
    .db 0xf8
    .db 0xf8
    .db 0xf2
    .db 0xf2
    .db 0x0
    .db 0x0
    .db 0xf8
    .db 0xf8
    .db 0xf2
    .db 0xf2
    .db 0x0
    .db 0x0
    .db 0x1
ALIENALL_ARPEGGIO3: .db 0x0
    .db 0x0
    .db 0x0
    .db 0xf8
    .db 0xf8
    .db 0xee
    .db 0xee
    .db 0x0
    .db 0x0
    .db 0xf8
    .db 0xf8
    .db 0xee
    .db 0xee
    .db 0x0
    .db 0x0
    .db 0xf8
    .db 0xf8
    .db 0xee
    .db 0xee
    .db 0x0
    .db 0x0
    .db 0xf8
    .db 0xf8
    .db 0xee
    .db 0xee
    .db 0x0
    .db 0x0
    .db 0xf8
    .db 0xf8
    .db 0xee
    .db 0xee
    .db 0x0
    .db 0x0
    .db 0x1
ALIENALL_ARPEGGIO4: .db 0x0
    .db 0x0
    .db 0x0
    .db 0xfa
    .db 0xfa
    .db 0xf2
    .db 0xf2
    .db 0x0
    .db 0x0
    .db 0xfa
    .db 0xfa
    .db 0xf2
    .db 0xf2
    .db 0x0
    .db 0x0
    .db 0xfa
    .db 0xfa
    .db 0xf2
    .db 0xf2
    .db 0x0
    .db 0x0
    .db 0xfa
    .db 0xfa
    .db 0xf2
    .db 0xf2
    .db 0x0
    .db 0x0
    .db 0xfa
    .db 0xfa
    .db 0xf2
    .db 0xf2
    .db 0x0
    .db 0x0
    .db 0x1
ALIENALL_PITCHINDEXES:
ALIENALL_SUBSONG0: .dw ALIENALL_SUBSONG0_NOTEINDEXES
    .dw ALIENALL_SUBSONG0_TRACKINDEXES
    .db 0x6
    .db 0x1
    .db 0x7
    .db 0x0
    .db 0x1
    .db 0x21
    .db 0x2
    .db 0x0
    .db 0xc
    .db 0xaa
    .db 0x1f
    .db 0x86
    .db 0x87
    .db 0x87
    .db 0x80
    .db 0x0
    .db 0xf5
    .db 0x20
    .db 0x0
    .db 0xf9
    .db 0x88
    .db 0x1
    .db 0x9
    .db 0x1
    .db 0x2f
    .db 0xa8
    .db 0x86
    .db 0x1
    .db 0x32
    .db 0x80
    .db 0xa8
    .db 0x0
    .db 0xff
    .db 0x1
    .db 0x60
    .db 0x81
ALIENALL_SUBSONG0_LOOP: .db 0xa8
    .db 0x82
    .db 0x88
    .db 0x80
    .db 0xa8
    .db 0x83
    .db 0x1
    .db 0xad
    .db 0x81
    .db 0xa8
    .db 0x82
    .db 0x88
    .db 0x80
    .db 0xa8
    .db 0x83
    .db 0x1
    .db 0xb0
    .db 0x81
    .db 0xa8
    .db 0x82
    .db 0x1
    .db 0xb2
    .db 0x80
    .db 0xa8
    .db 0x83
    .db 0x2
    .db 0x0
    .db 0x81
    .db 0xa8
    .db 0x82
    .db 0x1
    .db 0xa8
    .db 0x80
    .db 0xa8
    .db 0x83
    .db 0x2
    .db 0x1d
    .db 0x2
    .db 0x42
    .db 0xa8
    .db 0x84
    .db 0x89
    .db 0x80
    .db 0xa8
    .db 0x85
    .db 0x8a
    .db 0x81
    .db 0xa8
    .db 0x84
    .db 0x89
    .db 0x80
    .db 0xa8
    .db 0x85
    .db 0x8a
    .db 0x81
    .db 0xa8
    .db 0x82
    .db 0x88
    .db 0x80
    .db 0xa8
    .db 0x83
    .db 0x1
    .db 0x76
    .db 0x81
    .db 0xa8
    .db 0x82
    .db 0x88
    .db 0x80
    .db 0xa8
    .db 0x83
    .db 0x1
    .db 0x79
    .db 0x81
    .db 0xa8
    .db 0x84
    .db 0x3
    .db 0x1c
    .db 0x80
    .db 0xa8
    .db 0x85
    .db 0x3
    .db 0x27
    .db 0x81
    .db 0xa8
    .db 0x84
    .db 0x3
    .db 0x12
    .db 0x80
    .db 0xa8
    .db 0x85
    .db 0x3
    .db 0x27
    .db 0x3
    .db 0x30
    .db 0xa8
    .db 0x84
    .db 0x89
    .db 0x80
    .db 0xa8
    .db 0x85
    .db 0x8a
    .db 0x81
    .db 0xa8
    .db 0x84
    .db 0x89
    .db 0x80
    .db 0xa8
    .db 0x85
    .db 0x8a
    .db 0x81
    .db 0xa8
    .db 0x86
    .db 0x87
    .db 0x87
    .db 0x1
    .db 0x0
    .dw ALIENALL_SUBSONG0_LOOP
ALIENALL_SUBSONG0_TRACKINDEXES: .dw ALIENALL_SUBSONG0_TRACK7
    .dw ALIENALL_SUBSONG0_TRACK9
    .dw ALIENALL_SUBSONG0_TRACK10
    .dw ALIENALL_SUBSONG0_TRACK12
    .dw ALIENALL_SUBSONG0_TRACK19
    .dw ALIENALL_SUBSONG0_TRACK21
    .dw ALIENALL_SUBSONG0_TRACK0
    .dw ALIENALL_SUBSONG0_TRACK1
    .dw ALIENALL_SUBSONG0_TRACK11
    .dw ALIENALL_SUBSONG0_TRACK20
    .dw ALIENALL_SUBSONG0_TRACK22
ALIENALL_SUBSONG0_TRACK0: .db 0xc
    .db 0xb1
    .db 0x6
    .db 0x2
    .db 0x47
    .db 0xc
    .db 0x41
    .db 0x32
    .db 0xc
    .db 0x42
    .db 0x2
    .db 0xc
    .db 0x47
    .db 0x32
    .db 0xc
    .db 0x47
    .db 0x2
    .db 0xc
    .db 0x42
    .db 0x32
    .db 0xc
    .db 0x41
    .db 0x2
    .db 0xc
    .db 0x47
    .db 0x32
    .db 0xc
    .db 0x47
    .db 0x2
    .db 0xc
    .db 0x41
    .db 0x32
    .db 0xc
    .db 0x42
    .db 0x2
    .db 0xc
    .db 0x47
    .db 0x32
    .db 0xc
    .db 0x47
    .db 0x2
    .db 0xc
    .db 0x42
    .db 0x32
    .db 0xc
    .db 0x43
    .db 0x2
    .db 0xc
    .db 0x47
    .db 0x32
    .db 0xc
    .db 0x42
    .db 0x2
    .db 0xc
    .db 0x43
    .db 0x32
    .db 0xc
    .db 0x43
    .db 0x2
    .db 0xc
    .db 0x42
    .db 0x32
    .db 0xc
    .db 0x41
    .db 0x2
    .db 0x45
    .db 0xc
    .db 0x42
    .db 0x52
    .db 0xc
    .db 0x45
    .db 0x2
    .db 0x81
    .db 0x43
    .db 0xc
    .db 0x41
    .db 0x32
    .db 0xc
    .db 0x45
    .db 0x2
    .db 0xc
    .db 0xc3
    .db 0x7f
    .db 0x32
ALIENALL_SUBSONG0_TRACK1: .db 0xcd
    .db 0x7f
ALIENALL_SUBSONG0_TRACK2: .db 0xc
    .db 0xff
    .db 0x9
    .db 0xf
    .db 0x0
    .db 0xc4
    .db 0x7f
ALIENALL_SUBSONG0_TRACK3: .db 0xe0
    .db 0x3
    .db 0xb8
    .db 0x8
    .db 0xa0
    .db 0xa0
    .db 0x60
    .db 0x60
    .db 0x88
    .db 0xa0
    .db 0x20
    .db 0x88
    .db 0xa0
    .db 0xa0
    .db 0x60
    .db 0x60
    .db 0x88
    .db 0xe0
    .db 0x7f
ALIENALL_SUBSONG0_TRACK4: .db 0xc
    .db 0xf9
    .db 0x6
    .db 0x2
    .db 0x2
    .db 0xc
    .db 0x9
    .db 0x32
    .db 0xc
    .db 0x89
    .db 0x52
    .db 0xc
    .db 0x8a
    .db 0x2
    .db 0x42
    .db 0xc
    .db 0x4a
    .db 0x32
    .db 0xc
    .db 0x43
    .db 0x2
    .db 0xc
    .db 0x42
    .db 0x32
    .db 0xc
    .db 0x41
    .db 0x2
    .db 0x43
    .db 0xc
    .db 0x42
    .db 0x52
    .db 0xc
    .db 0x41
    .db 0x32
    .db 0x83
    .db 0xc
    .db 0x41
    .db 0x52
    .db 0xc3
    .db 0x7f
ALIENALL_SUBSONG0_TRACK5: .db 0xc
    .db 0xf6
    .db 0x9
    .db 0xf
    .db 0x0
    .db 0xc4
    .db 0x7f
ALIENALL_SUBSONG0_TRACK6: .db 0xf2
    .db 0x3
    .db 0x9
    .db 0x8a
    .db 0x8b
    .db 0x82
    .db 0xc3
    .db 0x7
    .db 0x81
    .db 0xc3
    .db 0x7f
ALIENALL_SUBSONG0_TRACK7: .db 0xc
    .db 0x60
    .db 0x0
    .db 0xff
    .db 0x9
    .db 0x2
    .db 0x78
    .db 0x8
    .db 0x7f
    .db 0x9
    .db 0x60
    .db 0x4f
    .db 0x60
    .db 0x4f
    .db 0x60
    .db 0x60
    .db 0x78
    .db 0x8
    .db 0x7f
    .db 0x9
    .db 0x60
    .db 0x4f
    .db 0x60
    .db 0x4
    .db 0x78
    .db 0x8
    .db 0x74
    .db 0x9
    .db 0x60
    .db 0x44
    .db 0x60
    .db 0x44
    .db 0x60
    .db 0x60
    .db 0x78
    .db 0x8
    .db 0x74
    .db 0x9
    .db 0x60
    .db 0xc4
    .db 0x7f
ALIENALL_SUBSONG0_TRACK8: .db 0xf9
    .db 0x3
    .db 0x7
    .db 0x8a
    .db 0x82
    .db 0x83
    .db 0x81
    .db 0xc5
    .db 0x5
    .db 0x1
    .db 0xc3
    .db 0x7f
ALIENALL_SUBSONG0_TRACK9: .db 0xc
    .db 0x60
    .db 0x0
    .db 0xf6
    .db 0x9
    .db 0x2
    .db 0x78
    .db 0x8
    .db 0x76
    .db 0x9
    .db 0x60
    .db 0x46
    .db 0x60
    .db 0x46
    .db 0x60
    .db 0x60
    .db 0x78
    .db 0x8
    .db 0x76
    .db 0x9
    .db 0x60
    .db 0x46
    .db 0x60
    .db 0x4
    .db 0x78
    .db 0x8
    .db 0x74
    .db 0x9
    .db 0x60
    .db 0x44
    .db 0x60
    .db 0x44
    .db 0x60
    .db 0x60
    .db 0x78
    .db 0x8
    .db 0x74
    .db 0x9
    .db 0x60
    .db 0xc4
    .db 0x7f
ALIENALL_SUBSONG0_TRACK10: .db 0xc
    .db 0xc1
    .db 0xf
    .db 0x1
    .db 0x16
    .db 0xc
    .db 0xc5
    .db 0x7f
    .db 0x1
    .db 0x26
ALIENALL_SUBSONG0_TRACK11: .db 0xf1
    .db 0x5
    .db 0x9
    .db 0x83
    .db 0x82
    .db 0x4a
    .db 0xcb
    .db 0x7f
ALIENALL_SUBSONG0_TRACK12: .db 0xc
    .db 0xc9
    .db 0xf
    .db 0x1
    .db 0x36
    .db 0xc
    .db 0xc1
    .db 0x7
    .db 0x1
    .db 0x16
    .db 0xc
    .db 0xc5
    .db 0x7f
    .db 0x1
    .db 0x36
ALIENALL_SUBSONG0_TRACK13: .db 0xfe
    .db 0x42
    .db 0x5
    .db 0x5
    .db 0xb
    .db 0xca
    .db 0x3
    .db 0x82
    .db 0x8a
    .db 0x82
    .db 0xc3
    .db 0x7f
ALIENALL_SUBSONG0_TRACK14: .db 0xfe
    .db 0x45
    .db 0x5
    .db 0xf
    .db 0xce
    .db 0x47
    .db 0x7f
ALIENALL_SUBSONG0_TRACK15: .db 0xc
    .db 0x91
    .db 0x2
    .db 0x57
    .db 0xc
    .db 0x51
    .db 0x32
    .db 0xc
    .db 0x52
    .db 0x2
    .db 0xc
    .db 0x57
    .db 0x32
    .db 0xc
    .db 0x57
    .db 0x2
    .db 0xc
    .db 0x52
    .db 0x32
    .db 0xc
    .db 0x51
    .db 0x2
    .db 0xc
    .db 0x57
    .db 0x32
    .db 0xc
    .db 0x57
    .db 0x2
    .db 0xc
    .db 0x51
    .db 0x32
    .db 0xc
    .db 0x52
    .db 0x2
    .db 0xc
    .db 0x57
    .db 0x32
    .db 0xc
    .db 0x57
    .db 0x2
    .db 0xc
    .db 0x52
    .db 0x32
    .db 0xc
    .db 0x53
    .db 0x2
    .db 0xc
    .db 0x57
    .db 0x32
    .db 0xc
    .db 0x52
    .db 0x2
    .db 0xc
    .db 0x53
    .db 0x32
    .db 0xc
    .db 0x53
    .db 0x2
    .db 0xc
    .db 0x52
    .db 0x32
    .db 0xc
    .db 0x51
    .db 0x2
    .db 0x55
    .db 0xc
    .db 0x52
    .db 0x52
    .db 0xc
    .db 0x55
    .db 0x2
    .db 0x91
    .db 0x53
    .db 0xc
    .db 0x51
    .db 0x32
    .db 0xc
    .db 0x55
    .db 0x2
    .db 0xc
    .db 0xd3
    .db 0x7f
    .db 0x32
ALIENALL_SUBSONG0_TRACK16: .db 0xc
    .db 0xd9
    .db 0x2
    .db 0x2
    .db 0xc
    .db 0x19
    .db 0x32
    .db 0xc
    .db 0x99
    .db 0x52
    .db 0xc
    .db 0x9a
    .db 0x2
    .db 0x52
    .db 0xc
    .db 0x5a
    .db 0x32
    .db 0xc
    .db 0x53
    .db 0x2
    .db 0xc
    .db 0x52
    .db 0x32
    .db 0xc
    .db 0x51
    .db 0x2
    .db 0x53
    .db 0xc
    .db 0x52
    .db 0x52
    .db 0xc
    .db 0x51
    .db 0x32
    .db 0x93
    .db 0xc
    .db 0x51
    .db 0x52
    .db 0xd3
    .db 0x7f
ALIENALL_SUBSONG0_TRACK17: .db 0xc
    .db 0xd9
    .db 0x2
    .db 0x2
    .db 0xc
    .db 0x19
    .db 0x32
    .db 0xc
    .db 0x99
    .db 0x52
    .db 0xc
    .db 0x9a
    .db 0x2
    .db 0x52
    .db 0xc
    .db 0x5a
    .db 0x32
    .db 0xc
    .db 0x53
    .db 0x2
    .db 0xc
    .db 0x52
    .db 0x32
    .db 0xc
    .db 0x51
    .db 0x2
    .db 0x5b
    .db 0xc
    .db 0x52
    .db 0x52
    .db 0xc
    .db 0x51
    .db 0x32
    .db 0x9b
    .db 0xc
    .db 0x51
    .db 0x52
    .db 0xdb
    .db 0x7f
ALIENALL_SUBSONG0_TRACK18: .db 0xc
    .db 0x60
    .db 0x0
    .db 0xf6
    .db 0x9
    .db 0x2
    .db 0x78
    .db 0x8
    .db 0x76
    .db 0x9
    .db 0x60
    .db 0x46
    .db 0x60
    .db 0x46
    .db 0x60
    .db 0x60
    .db 0x78
    .db 0x8
    .db 0x76
    .db 0x9
    .db 0x60
    .db 0x46
    .db 0x60
    .db 0x4
    .db 0x78
    .db 0x8
    .db 0x74
    .db 0x9
    .db 0x6e
    .db 0x2b
    .db 0x6f
    .db 0x6e
    .db 0x28
    .db 0x6f
    .db 0x44
    .db 0x6e
    .db 0x26
    .db 0x6f
    .db 0x44
    .db 0x60
    .db 0xc4
    .db 0x7f
ALIENALL_SUBSONG0_TRACK19: .db 0xc
    .db 0xc1
    .db 0xf
    .db 0x1
    .db 0x16
    .db 0xc
    .db 0xc3
    .db 0x7f
    .db 0x1
    .db 0x46
ALIENALL_SUBSONG0_TRACK20: .db 0xc
    .db 0x51
    .db 0x2
    .db 0xc
    .db 0x53
    .db 0x32
    .db 0xc
    .db 0x52
    .db 0x2
    .db 0xc
    .db 0x51
    .db 0x32
    .db 0xc
    .db 0x5b
    .db 0x2
    .db 0xc
    .db 0x52
    .db 0x32
    .db 0xc
    .db 0x52
    .db 0x2
    .db 0xc
    .db 0x5b
    .db 0x32
    .db 0xc
    .db 0x51
    .db 0x2
    .db 0xc
    .db 0x52
    .db 0x32
    .db 0xc
    .db 0x52
    .db 0x2
    .db 0xc
    .db 0x51
    .db 0x32
    .db 0xc
    .db 0x5b
    .db 0x2
    .db 0xc
    .db 0x52
    .db 0x32
    .db 0xc
    .db 0x52
    .db 0x2
    .db 0xc
    .db 0x5b
    .db 0x32
    .db 0xc
    .db 0x57
    .db 0x2
    .db 0xc
    .db 0x52
    .db 0x32
    .db 0xc
    .db 0x55
    .db 0x2
    .db 0xc
    .db 0x57
    .db 0x32
    .db 0xc
    .db 0x53
    .db 0x2
    .db 0xc
    .db 0x55
    .db 0x32
    .db 0xc
    .db 0x55
    .db 0x2
    .db 0xc
    .db 0x53
    .db 0x32
    .db 0xc
    .db 0x53
    .db 0x2
    .db 0xc
    .db 0x55
    .db 0x32
    .db 0xc
    .db 0x52
    .db 0x2
    .db 0xc
    .db 0x53
    .db 0x32
    .db 0xc
    .db 0x53
    .db 0x2
    .db 0xc
    .db 0x52
    .db 0x32
    .db 0xc
    .db 0x55
    .db 0x2
    .db 0xc
    .db 0xd3
    .db 0x7f
    .db 0x32
ALIENALL_SUBSONG0_TRACK21: .db 0xc
    .db 0xca
    .db 0xf
    .db 0x1
    .db 0x16
    .db 0xc
    .db 0xcb
    .db 0x7f
    .db 0x1
    .db 0x16
ALIENALL_SUBSONG0_TRACK22: .db 0xc
    .db 0x59
    .db 0x2
    .db 0xc
    .db 0x55
    .db 0x32
    .db 0xc
    .db 0x51
    .db 0x2
    .db 0xc
    .db 0x59
    .db 0x32
    .db 0xc
    .db 0x5a
    .db 0x2
    .db 0xc
    .db 0x51
    .db 0x32
    .db 0xc
    .db 0x51
    .db 0x2
    .db 0xc
    .db 0x5a
    .db 0x32
    .db 0xc
    .db 0x59
    .db 0x2
    .db 0xc
    .db 0x51
    .db 0x32
    .db 0xc
    .db 0x51
    .db 0x2
    .db 0xc
    .db 0x59
    .db 0x32
    .db 0xc
    .db 0x5a
    .db 0x2
    .db 0xc
    .db 0x51
    .db 0x32
    .db 0xc
    .db 0x51
    .db 0x2
    .db 0xc
    .db 0x5a
    .db 0x32
    .db 0xc
    .db 0x53
    .db 0x2
    .db 0xc
    .db 0x51
    .db 0x32
    .db 0xc
    .db 0x51
    .db 0x2
    .db 0xc
    .db 0x53
    .db 0x32
    .db 0xc
    .db 0x55
    .db 0x2
    .db 0xc
    .db 0x51
    .db 0x32
    .db 0xc
    .db 0x51
    .db 0x2
    .db 0xc
    .db 0x55
    .db 0x32
    .db 0xc
    .db 0x53
    .db 0x2
    .db 0xc
    .db 0x51
    .db 0x32
    .db 0xc
    .db 0x51
    .db 0x2
    .db 0xc
    .db 0x53
    .db 0x32
    .db 0xc
    .db 0x55
    .db 0x2
    .db 0xc
    .db 0x51
    .db 0x32
    .db 0xc
    .db 0x53
    .db 0x2
    .db 0xc
    .db 0xd5
    .db 0x7f
    .db 0x32
ALIENALL_SUBSONG0_TRACK23: .db 0xf2
    .db 0x4
    .db 0x3
    .db 0x2
    .db 0x82
    .db 0x4a
    .db 0xc2
    .db 0x2
    .db 0x81
    .db 0xc3
    .db 0x7
    .db 0x81
    .db 0x85
    .db 0x49
    .db 0xc5
    .db 0x7f
ALIENALL_SUBSONG0_TRACK24: .db 0xf9
    .db 0x4
    .db 0x5
    .db 0x5
    .db 0xc1
    .db 0x3
    .db 0xc2
    .db 0x5
    .db 0xc3
    .db 0x7f
ALIENALL_SUBSONG0_TRACK25: .db 0xf9
    .db 0x4
    .db 0x5
    .db 0x5
    .db 0xc1
    .db 0x3
    .db 0xce
    .db 0x42
    .db 0x5
    .db 0xcb
    .db 0x7f
ALIENALL_SUBSONG0_TRACK26: .db 0xc
    .db 0x60
    .db 0x0
    .db 0xf6
    .db 0x9
    .db 0x2
    .db 0x78
    .db 0x8
    .db 0x76
    .db 0x9
    .db 0x60
    .db 0x46
    .db 0x60
    .db 0x46
    .db 0x60
    .db 0x60
    .db 0x78
    .db 0x8
    .db 0x76
    .db 0x9
    .db 0x60
    .db 0x46
    .db 0x60
    .db 0x4
    .db 0x78
    .db 0x8
    .db 0x74
    .db 0x9
    .db 0x60
    .db 0x44
    .db 0x60
    .db 0x44
    .db 0x6e
    .db 0x2b
    .db 0x6e
    .db 0x29
    .db 0x6e
    .db 0x28
    .db 0x6e
    .db 0x26
    .db 0x60
    .db 0xe0
    .db 0x7f
ALIENALL_SUBSONG0_NOTEINDEXES: .db 0x24
    .db 0x39
    .db 0x3d
    .db 0x3b
    .db 0x1c
    .db 0x38
    .db 0x1a
    .db 0x34
    .db 0x30
    .db 0x36
    .db 0x3e
    .db 0x40
_EFFECTS::
GREEN_SOUNDEFFECTS:
_GREEN_SOUNDEFFECTS:: .dw GREEN_SOUNDEFFECTS_SOUND1
    .dw GREEN_SOUNDEFFECTS_SOUND2
    .dw GREEN_SOUNDEFFECTS_SOUND3
    .dw GREEN_SOUNDEFFECTS_SOUND4
    .dw GREEN_SOUNDEFFECTS_SOUND5
GREEN_SOUNDEFFECTS_SOUND1: .db 0x0
GREEN_SOUNDEFFECTS_SOUND1_LOOP: .db 0x39
    .db 0x60
    .db 0x0
    .db 0x39
    .db 0x60
    .db 0x0
    .db 0x35
    .db 0x80
    .db 0x0
    .db 0x35
    .db 0x80
    .db 0x0
    .db 0x29
    .db 0x0
    .db 0x1
    .db 0x29
    .db 0x0
    .db 0x1
    .db 0x25
    .db 0x80
    .db 0x0
    .db 0x25
    .db 0x80
    .db 0x0
    .db 0x1d
    .db 0x80
    .db 0x0
    .db 0x1d
    .db 0x80
    .db 0x0
    .db 0x4
GREEN_SOUNDEFFECTS_SOUND2: .db 0x0
    .db 0x39
    .db 0x60
    .db 0x0
    .db 0x39
    .db 0x60
    .db 0x0
    .db 0x35
    .db 0x70
    .db 0x0
    .db 0x35
    .db 0x70
    .db 0x0
    .db 0x29
    .db 0x80
    .db 0x0
    .db 0x29
    .db 0x80
    .db 0x0
    .db 0x29
    .db 0x80
    .db 0x0
    .db 0x29
    .db 0x80
    .db 0x0
    .db 0x1
    .db 0x80
    .db 0x0
    .db 0x1
    .db 0x80
    .db 0x0
    .db 0x21
    .db 0x60
    .db 0x0
    .db 0x21
    .db 0x60
    .db 0x0
GREEN_SOUNDEFFECTS_SOUND2_LOOP: .db 0x1
    .db 0x60
    .db 0x0
    .db 0x1
    .db 0x60
    .db 0x0
    .db 0x19
    .db 0x80
    .db 0x0
    .db 0x19
    .db 0x80
    .db 0x0
    .db 0x4
GREEN_SOUNDEFFECTS_SOUND3: .db 0x0
    .db 0xb1
    .db 0x1
    .db 0x80
    .db 0x0
    .db 0xb1
    .db 0x1
    .db 0x80
    .db 0x0
    .db 0xb1
    .db 0x1
    .db 0x80
    .db 0x0
    .db 0xb1
    .db 0x1
    .db 0x80
    .db 0x0
    .db 0x31
    .db 0x80
    .db 0x0
    .db 0x31
    .db 0x60
    .db 0x0
    .db 0x31
    .db 0x60
    .db 0x0
    .db 0x31
    .db 0x0
    .db 0x1
GREEN_SOUNDEFFECTS_SOUND3_LOOP: .db 0x31
    .db 0x0
    .db 0x1
    .db 0x4
GREEN_SOUNDEFFECTS_SOUND4: .db 0x0
    .db 0xb9
    .db 0x1
    .db 0x0
    .db 0x1
    .db 0xb9
    .db 0x1
    .db 0x0
    .db 0x1
    .db 0xb9
    .db 0x1
    .db 0x0
    .db 0x2
    .db 0xb9
    .db 0x1
    .db 0x0
    .db 0x2
    .db 0x35
    .db 0x80
    .db 0x2
    .db 0x35
    .db 0x80
    .db 0x2
    .db 0x2d
    .db 0x60
    .db 0x2
    .db 0x2d
    .db 0x60
    .db 0x2
    .db 0x29
    .db 0x0
    .db 0x3
    .db 0x29
    .db 0x0
    .db 0x3
    .db 0x21
    .db 0x0
    .db 0x4
GREEN_SOUNDEFFECTS_SOUND4_LOOP: .db 0x21
    .db 0x0
    .db 0x4
    .db 0x4
GREEN_SOUNDEFFECTS_SOUND5: .db 0x0
    .db 0x39
    .db 0x0
    .db 0x2
    .db 0x39
    .db 0x0
    .db 0x2
    .db 0x39
    .db 0x60
    .db 0x2
    .db 0x39
    .db 0x60
    .db 0x2
    .db 0x39
    .db 0x20
    .db 0x3
    .db 0x39
    .db 0x20
    .db 0x3
    .db 0x35
    .db 0x0
    .db 0x3
    .db 0x35
    .db 0x0
    .db 0x4
    .db 0x2d
    .db 0x0
    .db 0x5
    .db 0x2d
    .db 0x0
    .db 0x6
    .db 0x29
    .db 0x0
    .db 0x8
    .db 0x29
    .db 0x0
    .db 0x8
    .db 0x21
    .db 0x0
    .db 0x8
    .db 0x21
    .db 0x0
    .db 0x8
    .db 0x21
    .db 0x0
    .db 0x8
    .db 0x21
    .db 0x0
    .db 0x8
    .db 0x19
    .db 0x0
    .db 0x8
GREEN_SOUNDEFFECTS_SOUND5_LOOP: .db 0x19
    .db 0x0
    .db 0x8
    .db 0x4
PLY_AKM_CHANNEL1_SOUNDEFFECTDATA = 0xc057
PLY_AKM_CHANNEL2_SOUNDEFFECTDATA = 0xc05f
PLY_AKM_CHANNEL3_SOUNDEFFECTDATA = 0xc067
PLY_AKM_DEFAULTSTARTINSTRUMENTINTRACKS = 0xc00f
PLY_AKM_DEFAULTSTARTNOTEINTRACKS = 0xc00e
PLY_AKM_DEFAULTSTARTWAITINTRACKS = 0xc010
PLY_AKM_FLAGNOTEANDEFFECTINCELL = 0xc015
PLY_AKM_LINKERPREVIOUSREMAININGHEIGHT = 0xc017
PLY_AKM_MIXERREGISTER = 0xc046
PLY_AKM_NOISEREGISTER = 0xc042
PLY_AKM_NOTEINDEXTABLE = 0xc008
PLY_AKM_PATTERNREMAININGHEIGHT = 0xc016
PLY_AKM_PRIMARYINSTRUMENT = 0xc011
PLY_AKM_PRIMARYWAIT = 0xc013
PLY_AKM_PTARPEGGIOS = 0xc002
PLY_AKM_PTINSTRUMENTS = 0xc000
PLY_AKM_PTLINKER = 0xc006
PLY_AKM_PTSOUNDEFFECTTABLE = 0xc055
PLY_AKM_REG11 = 0xc04a
PLY_AKM_REG12 = 0xc04e
PLY_AKM_RT_READEFFECTSFLAG = 0xc01c
PLY_AKM_SAVESP = 0xc00c
PLY_AKM_SECONDARYINSTRUMENT = 0xc012
PLY_AKM_SECONDARYWAIT = 0xc014
PLY_AKM_SETREG13 = 0xc01b
PLY_AKM_SETREG13OLD = 0xc01a
PLY_AKM_SPEED = 0xc018
PLY_AKM_TICKCOUNTER = 0xc019
PLY_AKM_TRACK1_ESCAPEINSTRUMENT = 0xc073
PLY_AKM_TRACK1_ESCAPENOTE = 0xc072
PLY_AKM_TRACK1_ESCAPEWAIT = 0xc074
PLY_AKM_TRACK1_PTINSTRUMENT = 0xc075
PLY_AKM_TRACK1_PTSTARTTRACK = 0xc06d
PLY_AKM_TRACK1_REGISTERS = 0xc01d
PLY_AKM_TRACK1_VOLUME = 0xc01e
PLY_AKM_TRACK1_WAITEMPTYCELL = 0xc06c
PLY_AKM_TRACK2_ESCAPEINSTRUMENT = 0xc088
PLY_AKM_TRACK2_ESCAPENOTE = 0xc087
PLY_AKM_TRACK2_ESCAPEWAIT = 0xc089
PLY_AKM_TRACK2_PTINSTRUMENT = 0xc08a
PLY_AKM_TRACK2_REGISTERS = 0xc029
PLY_AKM_TRACK2_VOLUME = 0xc02a
PLY_AKM_TRACK2_WAITEMPTYCELL = 0xc081
PLY_AKM_TRACK3_ESCAPEINSTRUMENT = 0xc09d
PLY_AKM_TRACK3_ESCAPENOTE = 0xc09c
PLY_AKM_TRACK3_ESCAPEWAIT = 0xc09e
PLY_AKM_TRACK3_PTINSTRUMENT = 0xc09f
PLY_AKM_TRACK3_REGISTERS = 0xc035
PLY_AKM_TRACK3_VOLUME = 0xc036
PLY_AKM_TRACK3_WAITEMPTYCELL = 0xc096
PLY_AKM_TRACKINDEX = 0xc00a
