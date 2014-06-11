[BITS 16]	;Tells the assembler that its a 16 bit code
[ORG 0x7C00]	;Origin, tell the assembler that where the code will
	;be in memory after it is been loaded

MOV AL, 65
CALL PrintCharacter
JMP $ 		;Infinite loop, hang it here.


PrintCharacter:	;Procedure to print character on screen
	;Assume that ASCII value is in register AL
MOV AH, 0x0E	;Tell BIOS that we need to print one charater on screen.
MOV BH, 0x00	;Page no.
MOV BL, 0x07	;Text attribute 0x07 is lightgrey font on black background

INT 0x10	;Call video interrupt
RET		;Return to calling procedure

TIMES 510 - ($ - $$) db 0	;Fill the rest of sector with 0
DW 0xAA55			;Add boot signature at the end of bootloader
