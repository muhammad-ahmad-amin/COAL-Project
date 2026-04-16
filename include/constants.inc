; Constants

; Track and board constants
TRACK_LEN       EQU 52
HOME_COL_LEN    EQU 6
PIECE_HOME      EQU -1          ; piece sitting in home base
PIECE_FINISHED  EQU 58          ; piece reached center

; Console color attributes
CLR_RED         EQU 0Ch         ; bright red
CLR_BLUE        EQU 09h         ; bright blue
CLR_GREEN       EQU 0Ah         ; bright green
CLR_YELLOW      EQU 0Eh         ; bright yellow
CLR_WHITE       EQU 0Fh         ; bright white
CLR_GRAY        EQU 07h         ; normal gray
CLR_DIM         EQU 08h         ; dark gray
CLR_CYAN        EQU 0Bh         ; bright cyan
CLR_MAGENTA     EQU 0Dh         ; bright magenta

; Board drawing offsets
BOARD_X         EQU 4
BOARD_Y         EQU 3