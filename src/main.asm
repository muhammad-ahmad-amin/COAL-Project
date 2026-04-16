; Main game loop

main PROC
    ; Get console handles
    invoke GetStdHandle, STD_OUTPUT_HANDLE
    mov hOut, eax
    invoke GetStdHandle, STD_INPUT_HANDLE
    mov hIn, eax

    ; Set console title
    invoke SetConsoleTitle, offset szTitle+2

    ; Seed random
    invoke GetTickCount
    mov randSeed, eax

@@startMenu:
    call ClearScreen
    mov eax, CLR_CYAN
    call SetColor
    mov esi, offset szTitle
    call PrintStr

    mov eax, CLR_WHITE
    call SetColor
    mov esi, offset szSelPlayers
    call PrintStr

    call GetChar
    sub al, '0'
    cmp al, 2
    jl @@badChoice
    cmp al, 4
    jg @@badChoice
    movzx eax, al
    mov numPlayers, eax
    jmp @@initGame

@@badChoice:
    mov eax, CLR_RED
    call SetColor
    mov esi, offset szInvalid
    call PrintStr
    call WaitEnter
    jmp @@startMenu

@@initGame:
    ; Reset all pieces to home
    xor ecx, ecx
@@resetLoop:
    cmp ecx, 16
    jge @@resetDone
    mov pieces[ecx*4], PIECE_HOME
    inc ecx
    jmp @@resetLoop
@@resetDone:
    mov currentPlayer, 0
    mov gameOver, 0
    mov consecutiveSixes, 0
    mov diceValue, 0

;; ═══════ GAME LOOP ═══════
@@gameLoop:
    call ClearScreen
    call DrawBoard
    call DrawStatus

    ;; Prompt to roll
    mov ecx, 2
    mov edx, 41
    call SetPos
    mov eax, currentPlayer
    mov eax, playerColors[eax*4]
    call SetColor
    mov eax, currentPlayer
    mov esi, szColors[eax*4]
    call PrintStr

    mov eax, CLR_GRAY
    call SetColor
    mov esi, offset szPressRoll
    call PrintStr
    call WaitEnter

    ;; Roll dice
    call RandNum
    mov diceValue, eax

    ;; Redraw with dice value
    call ClearScreen
    call DrawBoard
    call DrawStatus

    ;; Show rolled value
    mov ecx, 2
    mov edx, 41
    call SetPos
    mov eax, CLR_WHITE
    call SetColor
    mov esi, offset szRolled
    call PrintStr
    mov eax, diceValue
    call PrintNum

    ;; For now, do nothing with the roll
    call WaitEnter
    jmp @@nextTurn

@@nextTurn:
    mov eax, currentPlayer
    inc eax
    xor edx, edx
    div numPlayers
    mov currentPlayer, edx
    jmp @@gameLoop

main ENDP