;This is a boot loader program which hangs after printing Welcome Message
;Run bochs using the following command :==> bochs -q 'boot:a' 'floppya:1_44=floppy.img, status=inserted'
[BITS 16]             ;Tells the assembler that its a 16 bit code
[ORG 0x7C00]          ;Origin, tell the assembler that where the code will be in memory after it is loaded

MOV SI, WelcomeString                 ;Store string pointer to SI
CALL _Video_Mode
CALL _Cursor_Position
CALL _PrintString                ;Call print string procedure

JMP $                         ;Infinite loop, hang it here.

_Video_Mode:
        MOV AH,0X00
        MOV AL,0X13
        INT 0X10
        RET
_Cursor_Position:
        MOV AH,0x02      ;Function Code for setting up cursor position
        MOV BH,0x00      ;Page Number
        MOV DH,0x06      ;Row
        MOV DL,0x00      ;Column
        INT 0x10         ;Call video interrupt
        RET              ;Return to calling procedure

_PrintCharacter:         ;Procedure to print character on screen
                        ;Assume that ASCII value is in register AL
        MOV AH, 0x0E     ;Tell BIOS that we need to print one character on screen.
        MOV BH, 0x00    ;Page no.
        MOV BL, 0x07    ;Text attribute 0x07 is light grey font on black background
        INT 0x10        ;Call video interrupt
        RET             ;Return to calling procedure

_PrintString:           ;Procedure to print string on screen
                        ;Assume that string starting pointer is in register SI
next_character:         ;Label to fetch next character from string
        MOV AL, [SI]    ;Get a byte from string and store in AL register
        INC SI                ;Increment SI pointer
        OR AL, AL            ;Check if value in AL is zero (end of string)
        JZ exit_function         ;If end then return
        CALL _PrintCharacter   ;Else print the character which is in AL register
        JMP next_character      ;Fetch next character from string

        exit_function:         ;End label
        RET                ;Return from procedure

;Data
WelcomeString db 'Welcome to AD OS....', 0    ;ADwita parashar Operating System string which ends with 0

TIMES 510 - ($ - $$) db 0    ;Fill the rest of sector with 0
DW 0xAA55            ;Add boot signature at the end of bootloader
