# Ludo Console Game

A console-based implementation of the Ludo board game in **MASM32 assembly language**.

## Features
- 2–4 players
- Turn-based gameplay
- Full standard Ludo rules
- Console-based interface with colors

## Requirements
- MASM32 assembler
- Windows console
- Git (optional, for cloning)

## Clone the Project
Clone the repository and place it inside your MASM32 projects folder:

```bash
git clone https://github.com/muhammad-ahmad-amin/COAL-Project.git
cd COAL-Project
```

Recommended location:

```text
C:\masm32\projects\COAL-Project
```

## Build
Run the batch file to assemble and link the program:

```bash
build.bat
```

This will generate:

```text
ludo.exe
```

## How to Run
After building, open **Command Prompt**, navigate to the project folder, and run:

```bash
ludo.exe
```

Example:

```bash
cd C:\masm32\projects\COAL-Project
ludo.exe
```

## Game Rules
Standard Ludo rules apply. Roll the dice to move pieces from home to the center.  
The first player to move all pieces to the center wins.
