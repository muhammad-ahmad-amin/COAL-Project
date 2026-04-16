; Board drawing procedures

; Get console color for cell type
; Input: al = cell type
; Output: eax = color attribute
GetCellColor PROC
    cmp al, 1
    je @@red
    cmp al, 2
    je @@blue
    cmp al, 3
    je @@green
    cmp al, 4
    je @@yellow
    cmp al, 6
    je @@homecol
    cmp al, 7
    je @@center
    ; default: track
    mov eax, CLR_DIM
    ret
@@red:
    mov eax, CLR_RED
    ret
@@blue:
    mov eax, CLR_BLUE
    ret
@@green:
    mov eax, CLR_GREEN
    ret
@@yellow:
    mov eax, CLR_YELLOW
    ret
@@homecol:
    mov eax, CLR_CYAN
    ret
@@center:
    mov eax, CLR_WHITE
    ret
GetCellColor ENDP

; Check if position is safe
; Input: eax = absolute position
; Output: eax = 1 if safe, 0 if not
IsSafeSpot PROC
    push ebx
    push ecx
    xor ecx, ecx
@@loop:
    cmp ecx, numSafeSpots
    jge @@no
    cmp eax, safeSpots[ecx*4]
    je @@yes
    inc ecx
    jmp @@loop
@@yes:
    mov eax, 1
    pop ecx
    pop ebx
    ret
@@no:
    xor eax, eax
    pop ecx
    pop ebx
    ret
IsSafeSpot ENDP

; Draw the entire game board
DrawBoard PROC
    LOCAL gridRow:DWORD, gridCol:DWORD
    LOCAL screenX:DWORD, screenY:DWORD
    LOCAL idx:DWORD, ct:BYTE

    ; Draw 15x15 grid
    mov gridRow, 0
@@rowLoop:
    cmp gridRow, 15
    jge @@drawPieces

    mov gridCol, 0
@@colLoop:
    cmp gridCol, 15
    jge @@nextRow

    ; Compute cell index = row*15 + col
    mov eax, gridRow
    imul eax, 15
    add eax, gridCol
    mov idx, eax

    ; Get cell type
    movzx eax, cellType[eax]
    mov ct, al

    ; Skip empty cells
    cmp al, 0
    je @@skipCell

    ; Compute screen position
    mov eax, gridCol
    shl eax, 2              ; col * 4
    add eax, BOARD_X
    mov screenX, eax

    mov eax, gridRow
    shl eax, 1              ; row * 2
    add eax, BOARD_Y
    mov screenY, eax

    ; Set position
    mov ecx, screenX
    mov edx, screenY
    call SetPos

    ; Set color based on cell type
    movzx eax, ct
    call GetCellColor
    call SetColor

    ; Draw cell content
    cmp ct, 7
    je @@drawCenter
    cmp ct, 5
    je @@drawTrack
    cmp ct, 6
    je @@drawHomeCol

    ; Home area cells: draw colored block
    mov esi, offset szDot
    call PrintStr
    jmp @@skipCell

@@drawCenter:
    mov eax, CLR_WHITE
    call SetColor
    ; Print home symbol
    push offset szSpace3
    pop esi
    call PrintStr
    ; Draw "HOM" at center
    mov ecx, screenX
    mov edx, screenY
    call SetPos
    mov eax, CLR_MAGENTA
    call SetColor
    push 'H'
    call crt_putchar
    add esp, 4
    push 'O'
    call crt_putchar
    add esp, 4
    push 'M'
    call crt_putchar
    add esp, 4
    jmp @@skipCell

@@drawTrack:
    mov esi, offset szDot
    call PrintStr

    ; Draw separator line below
    mov ecx, screenX
    mov edx, screenY
    inc edx
    call SetPos
    mov eax, CLR_DIM
    call SetColor
    mov esi, offset szBar
    call PrintStr
    jmp @@skipCell

@@drawHomeCol:
    mov esi, offset szDot
    call PrintStr
    jmp @@skipCell

@@skipCell:
    inc gridCol
    jmp @@colLoop

@@nextRow:
    inc gridRow
    jmp @@rowLoop

@@drawPieces:
    ; Overlay pieces on the board
    xor ebx, ebx            ; player index
@@playerLoop:
    cmp ebx, numPlayers
    jge @@drawSafeMarkers

    xor edi, edi             ; piece index 0-3
@@pieceLoop:
    cmp edi, 4
    jge @@nextPlayer

    ; Get piece position
    mov eax, ebx
    shl eax, 2               ; player * 4
    add eax, edi
    mov ecx, pieces[eax*4]   ; piece position (relative)

    ; Determine screen coords based on piece state
    cmp ecx, PIECE_HOME
    je @@drawAtHome
    cmp ecx, PIECE_FINISHED
    jge @@drawAtCenter
    cmp ecx, 51
    jg @@drawAtHomeCol

    ; On main track: convert relative to absolute
    mov eax, ebx
    mov eax, startPos[ebx*4]
    add eax, ecx
    xor edx, edx
    push ebx
    mov ebx, TRACK_LEN
    div ebx
    pop ebx
    ; edx = absolute position
    ; Get grid coords from track arrays
    mov eax, trackCol[edx*4]
    shl eax, 2
    add eax, BOARD_X
    mov screenX, eax

    mov eax, trackRow[edx*4]
    shl eax, 1
    add eax, BOARD_Y
    mov screenY, eax
    jmp @@renderPiece

@@drawAtHome:
    ; Draw at home base position
    mov eax, ebx
    shl eax, 2              ; player * 4
    add eax, edi             ; + piece index
    push eax
    mov eax, homeBaseCol[eax*4]
    shl eax, 2
    add eax, BOARD_X
    mov screenX, eax
    pop eax
    mov eax, homeBaseRow[eax*4]
    shl eax, 1
    add eax, BOARD_Y
    mov screenY, eax
    jmp @@renderPiece

@@drawAtHomeCol:
    ; In home column: position 51-56 -> cell 0-5
    mov eax, ecx
    sub eax, 51             ; home col cell index 0-5
    ; Look up coords
    push eax
    mov edx, ebx
    imul edx, 6
    add edx, eax
    mov eax, homeColCol[edx*4]
    shl eax, 2
    add eax, BOARD_X
    mov screenX, eax
    mov eax, homeColRow[edx*4]
    shl eax, 1
    add eax, BOARD_Y
    mov screenY, eax
    pop eax
    jmp @@renderPiece

@@drawAtCenter:
    ; Finished piece - draw at center
    mov screenX, BOARD_X + 7*4
    mov screenY, BOARD_Y + 7*2
    jmp @@renderPiece

@@renderPiece:
    ; Set position
    mov ecx, screenX
    mov edx, screenY
    call SetPos

    ; Set player color
    mov eax, playerColors[ebx*4]
    call SetColor

    ; Print piece char: letter + number
    movzx eax, szPieceChars[ebx]
    push eax
    call crt_putchar
    add esp, 4
    mov eax, edi
    inc eax                  ; 1-based
    add eax, '0'
    push eax
    call crt_putchar
    add esp, 4
    push ' '
    call crt_putchar
    add esp, 4

    inc edi
    jmp @@pieceLoop

@@nextPlayer:
    inc ebx
    jmp @@playerLoop

@@drawSafeMarkers:
    ; Mark safe spots with stars
    mov eax, CLR_WHITE
    call SetColor
    xor ecx, ecx
@@safeLoop:
    cmp ecx, numSafeSpots
    jge @@done
    push ecx
    mov eax, safeSpots[ecx*4]
    ; Get screen position of this safe spot
    mov edx, trackCol[eax*4]
    shl edx, 2
    add edx, BOARD_X
    push edx
    mov edx, trackRow[eax*4]
    shl edx, 1
    add edx, BOARD_Y
    inc edx                 ; on the separator line below
    mov ecx, [esp]
    add esp, 4
    call SetPos
    mov esi, offset szSafe
    push ' '
    call crt_putchar
    add esp, 4
    push '*'
    call crt_putchar
    add esp, 4
    push ' '
    call crt_putchar
    add esp, 4
    pop ecx
    inc ecx
    jmp @@safeLoop

@@done:
    mov eax, CLR_GRAY
    call SetColor
    ret
DrawBoard ENDP