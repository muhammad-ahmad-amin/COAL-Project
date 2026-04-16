@echo off

if exist ludo.obj del ludo.obj
if exist ludo.exe del ludo.exe

..\bin\ml /c /coff ludo.asm
if errorlevel 1 goto errasm

..\bin\Link /SUBSYSTEM:CONSOLE /OPT:NOREF ludo.obj
if errorlevel 1 goto errlink

dir ludo.*
goto TheEnd

:errasm
echo Assembly Error
goto TheEnd

:errlink
echo Linking Error
goto TheEnd

:TheEnd