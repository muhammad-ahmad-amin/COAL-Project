; Status and UI drawing

DrawStatus PROC
    LOCAL pIdx:DWORD, homeCount:DWORD, playCount:DWORD, doneCount:DWORD

    ; Draw at row 34 (below board)
    mov ecx, 2
    mov edx, 34
    call SetPos

    ; Turn indicator
    mov eax, currentPlayer
    mov eax, playerColors[eax*4]
    call SetColor

    ; Print player name
    mov eax, currentPlayer
    mov esi, szColors[eax*4]
    call PrintStr
    mov esi, offset szTurn
    call PrintStr

    ; Dice value
    mov eax, CLR_WHITE
    call SetColor
    mov esi, offset szDice
    call PrintStr
    cmp diceValue, 0
    je @@noDice
    mov eax, diceValue
    dec eax
    mov esi, szDiceFaces[eax*4]
    call PrintStr
    jmp @@afterDice
@@noDice:
    push '-'
    call crt_putchar
    add esp, 4
    mov esi, offset szDiceEnd
    call PrintStr
@@afterDice:

    ; Player stats
    mov pIdx, 0
@@statLoop:
    mov eax, pIdx
    cmp eax, numPlayers
    jge @@statDone

    mov ecx, 2
    mov edx, 36
    add edx, pIdx
    call SetPos

    ; Set player color
    mov eax, pIdx
    mov eax, playerColors[eax*4]
    call SetColor

    ; Player name
    mov eax, pIdx
    mov esi, szColors[eax*4]
    call PrintStr

    mov eax, CLR_GRAY
    call SetColor

    ; Count pieces in each state
    mov homeCount, 0
    mov playCount, 0
    mov doneCount, 0
    mov eax, pIdx
    shl eax, 2              ; player * 4
    xor ecx, ecx
@@countLoop:
    cmp ecx, 4
    jge @@printStats
    push ecx
    add ecx, eax
    mov edx, pieces[ecx*4]
    cmp edx, PIECE_HOME
    jne @@notHome
    inc homeCount
    jmp @@countNext
@@notHome:
    cmp edx, PIECE_FINISHED
    jl @@notDone
    inc doneCount
    jmp @@countNext
@@notDone:
    inc playCount
@@countNext:
    pop ecx
    inc ecx
    jmp @@countLoop

@@printStats:
    ; Print: " Home:X  Play:X  Done:X"
    mov esi, offset szHome
    call PrintStr
    mov eax, homeCount
    call PrintNum
    mov esi, offset szOnBoard
    call PrintStr
    mov eax, playCount
    call PrintNum
    mov esi, offset szDone
    call PrintStr
    mov eax, doneCount
    call PrintNum

    inc pIdx
    jmp @@statLoop

@@statDone:
    ; Message line
    mov ecx, 2
    mov edx, 36
    add edx, numPlayers
    inc edx
    call SetPos
    mov eax, CLR_GRAY
    call SetColor
    ret
DrawStatus ENDP