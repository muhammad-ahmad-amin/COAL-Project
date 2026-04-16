.386
.model flat, stdcall
option casemap:none

include ..\include\windows.inc
include ..\include\kernel32.inc
include ..\include\user32.inc
include ..\include\msvcrt.inc
includelib ..\lib\kernel32.lib
includelib ..\lib\user32.lib
includelib ..\lib\msvcrt.lib

;; Include constants
include include\constants.inc

;; Include data declarations
include src\data.asm

;; Include utility procedures
include src\utils.asm

;; Include board drawing
include src\board.asm

;; Include UI/status drawing
include src\ui.asm

;; Include main game loop
include src\main.asm

end main