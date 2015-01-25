; boot.asm

; At this address we will find the code in memory, after BIOS loads it
org 07c00h
; For now we run the boot loader in 16-bit real mode
bits 16

; Reset disk
jmp short Start

; Boot-loader init
Start:
         ; Store the value of the hard drive, as defined by the BIOS
         mov al, dl
         ; We're going to read the disk
         jmp ReadDisk

; This procedure will read the second boot-loade from the disk
ReadDisk:
         ; Reset hard drive starting position
         call ResetDisk
         ; The memory segment where we save the read sector
         mov bx, 0x0500
         ; Save base address in the extra segments' register
         mov es, bx
         ; Save offset [es: bx]
         mov bx, 0x0000
         ; Indicates the disc to be read, stored in AL
         mov dl, al
         ; Desired operation is 'read disk into memory'
         mov ah, 0x02
         ; Number of sectors to read
         mov al, 0x03
         ; We read the first track / cylinder
         mov ch, 0x00
         ; We read starting with the second sector (the second boot-loader)
         mov cl, 0x02
         ; Read head
         mov dh, 0x00
         ; Execute
         int 0x13
         ; Try again
         jc ReadDisk
         ; Jump to the location where the read bytes are supposed to be
         jmp 0x0500: 0x0000

; The procedure to reset the hard drive and position the reader to 0
ResetDisk:
         ; Specify that the operation will be 'reset disk'
         mov ah, 0x00
         ; The disc to be reset - disk stored in AL by BIOS
         mov dl, al
         ; The reset interrupt
         int 0x13
         ; If an error is returned, try again
         jc ResetDisk
         ; Return
         ret

; Fill with 0 until the file has 512 bits
times 510 - ($ - $$) db 0
; Add Signature Identifiers for boot loader in position 510, 511
dw 0xAA55