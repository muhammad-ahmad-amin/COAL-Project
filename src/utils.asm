; Utility procedures

; Set console text color
; Input: color attribute in eax
SetColor PROC
    push eax
    invoke SetConsoleTextAttribute, hOut, eax
    pop eax
    ret
SetColor ENDP

; Set cursor position
; Input: ecx=col, edx=row
SetPos PROC
    push ecx
    push edx
    push ebx
    ; Pack COORD into a DWORD: low word = X, high word = Y
    and edx, 0FFFFh
    shl edx, 16
    and ecx, 0FFFFh
    or  ecx, edx             ; ecx = packed COORD (Y << 16 | X)
    ; Call SetConsoleCursorPosition(hOut, coordDword)
    push ecx
    push hOut
    call SetConsoleCursorPosition
    pop ebx
    pop edx
    pop ecx
    ret
SetPos ENDP

; Print null-terminated string
; Input: esi = pointer to string
PrintStr PROC
    push esi
    invoke crt_printf, offset fmtStr, esi
    pop esi
    ret
PrintStr ENDP

; Print integer
; Input: eax = number
PrintNum PROC
    invoke crt_printf, offset fmtNum, eax
    ret
PrintNum ENDP

; Clear screen
ClearScreen PROC
    invoke crt_system, offset fmtCls
    ret
ClearScreen ENDP

; Generate random 1-6
; Output: eax = 1-6
RandNum PROC
    invoke GetTickCount
    add eax, randSeed
    imul eax, 1103515245
    add eax, 12345
    mov randSeed, eax
    ; eax mod 6 + 1
    and eax, 7FFFFFFFh      ; ensure positive
    xor edx, edx
    mov ecx, 6
    div ecx
    mov eax, edx
    inc eax
    ret
RandNum ENDP

; Wait for ENTER key
WaitEnter PROC
    LOCAL nRead:DWORD
    invoke FlushConsoleInputBuffer, hIn
    invoke ReadConsole, hIn, offset inputBuf, 8, addr nRead, NULL
    ret
WaitEnter ENDP

; Read a single character
; Output: al = character
GetChar PROC
    LOCAL nRead:DWORD
    invoke FlushConsoleInputBuffer, hIn
    invoke ReadConsole, hIn, offset inputBuf, 8, addr nRead, NULL
    movzx eax, byte ptr [inputBuf]
    ret
GetChar ENDP