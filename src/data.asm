;; ═══════════════════════════════════════════════════════════════
;;  LUDO - Data Declarations
;; ═══════════════════════════════════════════════════════════════

.data
;; ── Console handles ────────────────────────────────────────
hOut            dd 0
hIn             dd 0
dwWritten       dd 0
dwRead          dd 0
coordBuf        COORD <0,0>
csbi            CONSOLE_SCREEN_BUFFER_INFO <>
inputBuf        db 16 dup(0)

;; ── Game State ─────────────────────────────────────────────
numPlayers      dd 4
currentPlayer   dd 0            ; 0-3
diceValue       dd 0
gameOver        dd 0
consecutiveSixes dd 0
randSeed        dd 0

;; Piece positions: 4 players x 4 pieces = 16 entries
;; Values: -1=home, 0-50=track(relative), 51-56=home column, 57=finished
pieces          dd 16 dup(PIECE_HOME)

;; Movable piece flags for current roll (4 entries, 1=movable)
movableFlags    dd 4 dup(0)
movableCount    dd 0

;; Player start positions on 52-cell absolute track
startPos        dd 0, 13, 26, 39

;; Safe spots (absolute positions)
safeSpots       dd 0, 8, 13, 21, 26, 34, 39, 47
numSafeSpots    dd 8

;; ── Track grid coordinates (col,row) for 52 cells ─────────
;; Each track cell maps to a (col,row) in the 15x15 Ludo grid
trackCol dd 6,6,6,6,6, 5,4,3,2,1,0, 0,0, 1,2,3,4,5
         dd 6,6,6,6,6,6, 7,8, 8,8,8,8,8, 9,10,11,12,13,14
         dd 14,14, 13,12,11,10,9, 8,8,8,8,8,8, 7,6

trackRow dd 1,2,3,4,5, 6,6,6,6,6,6, 7,8, 8,8,8,8,8
         dd 9,10,11,12,13,14, 14,14, 13,12,11,10,9
         dd 8,8,8,8,8,8, 7,6, 6,6,6,6,6, 5,4,3,2,1,0, 0,0

;; Home column coordinates (6 cells per player)
homeColCol dd 7,7,7,7,7,7        ; Red
           dd 1,2,3,4,5,6        ; Blue
           dd 7,7,7,7,7,7        ; Green
           dd 13,12,11,10,9,8    ; Yellow

homeColRow dd 1,2,3,4,5,6        ; Red
           dd 7,7,7,7,7,7        ; Blue
           dd 13,12,11,10,9,8    ; Green
           dd 7,7,7,7,7,7        ; Yellow

;; Home base piece positions (4 spots per player, col then row)
homeBaseCol dd 1,3,1,3            ; Red
            dd 1,3,1,3            ; Blue
            dd 10,12,10,12        ; Green
            dd 10,12,10,12        ; Yellow

homeBaseRow dd 1,1,3,3            ; Red
            dd 10,10,12,12        ; Blue
            dd 10,10,12,12        ; Green
            dd 1,1,3,3            ; Yellow

;; Player color attributes
playerColors    dd CLR_RED, CLR_BLUE, CLR_GREEN, CLR_YELLOW

;; ── Cell type map for 15x15 grid (225 bytes) ──────────────
;; 0=empty, 1=Red home, 2=Blue home, 3=Green home, 4=Yellow home
;; 5=track, 6=home col, 7=center
cellType db 1,1,1,1,1,1, 5,5,5, 4,4,4,4,4,4     ; row 0
         db 1,1,1,1,1,1, 5,6,5, 4,4,4,4,4,4     ; row 1
         db 1,1,1,1,1,1, 5,6,5, 4,4,4,4,4,4     ; row 2
         db 1,1,1,1,1,1, 5,6,5, 4,4,4,4,4,4     ; row 3
         db 1,1,1,1,1,1, 5,6,5, 4,4,4,4,4,4     ; row 4
         db 1,1,1,1,1,1, 5,6,5, 4,4,4,4,4,4     ; row 5
         db 5,5,5,5,5,5, 5,5,5, 5,5,5,5,5,5     ; row 6
         db 5,6,6,6,6,6, 6,7,6, 6,6,6,6,6,5     ; row 7
         db 5,5,5,5,5,5, 5,5,5, 5,5,5,5,5,5     ; row 8
         db 2,2,2,2,2,2, 5,6,5, 3,3,3,3,3,3     ; row 9
         db 2,2,2,2,2,2, 5,6,5, 3,3,3,3,3,3     ; row 10
         db 2,2,2,2,2,2, 5,6,5, 3,3,3,3,3,3     ; row 11
         db 2,2,2,2,2,2, 5,6,5, 3,3,3,3,3,3     ; row 12
         db 2,2,2,2,2,2, 5,6,5, 3,3,3,3,3,3     ; row 13
         db 2,2,2,2,2,2, 5,5,5, 3,3,3,3,3,3     ; row 14

;; ── Strings ───────────────────────────────────────────────
szTitle     db 13,10
            db "   ========================================",13,10
            db "        * * *   L U D O   G A M E   * * *  ",13,10
            db "   ========================================",13,10,0

szSelPlayers db 13,10,"   Select number of players (2-4): ",0
szInvalid    db "   Invalid choice! Try again.",13,10,0
szPressRoll  db " Press ENTER to roll dice...",0
szRolled     db " Rolled: ",0
szExtraTurn  db " Rolled 6! Extra turn!",0
szThreeSixes db " 3 sixes in a row! Turn lost!",0
szNoMoves    db " No valid moves. Turn passes.",0
szSelectPc   db " Select piece to move (1-4): ",0
szCantMove   db " That piece can't move!",0
szPieceOut   db " Piece enters the board!",0
szCapture    db " ** CAPTURE! Opponent sent home! **",0
szEnterHome  db " Piece enters home column!",0
szFinished   db " Piece reached HOME! ",0
szWinner     db 13,10,"   !!! WINNER: ",0
szWinEnd     db " WINS THE GAME !!!",13,10,0
szPlayAgain  db 13,10,"   Play again? (Y/N): ",0
szTurn       db "'s Turn   ",0
szDice       db "Dice: [",0
szDiceEnd    db "]  ",0
szHome       db "Home:",0
szOnBoard    db " Play:",0
szDone       db " Done:",0
szSafe       db " *",0
szCR         db 13,10,0
szSpace3     db "   ",0
szDot        db " . ",0
szBar        db "---",0
szPlus       db "+",0

szColors     dd offset szRed, offset szBlue, offset szGreen, offset szYellow
szRed        db "RED",0
szBlue       db "BLUE",0
szGreen      db "GREEN",0
szYellow     db "YELLOW",0

szPieceChars db "R","B","G","Y"

;; Dice faces (text art)
szDice1      db "[1]",0
szDice2      db "[2]",0
szDice3      db "[3]",0
szDice4      db "[4]",0
szDice5      db "[5]",0
szDice6      db "[6]",0
szDiceFaces  dd offset szDice1, offset szDice2, offset szDice3
             dd offset szDice4, offset szDice5, offset szDice6

;; Format strings for crt_printf
fmtNum       db "%d",0
fmtStr       db "%s",0
fmtCls       db "cls",0

.data?
tmpBuf       db 64 dup(?)

.code