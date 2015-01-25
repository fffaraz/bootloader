; a20.inc

; Include guards
%ifndef START_A20_INCLUDED
%define START_A20_INCLUDED

; Since we are in Real Mode, 16-bit
bits 16

; Activate gate A20 through the keyboard's controller
OpenA20:
         ; Switch off interrupts
         cli
         ; Save all the registers in memory
         pusha

         ; Will continue when the keyboard's input buffer is free
         call WaitForInput
         ; Copy the instruction that will disable the keyboard in AL
         mov al, 0xad
         ; Send the command to the controller
         out 0x64, al

         ; Will continue when the keyboard's input buffer is free
         call WaitForInput
         ; The controller's command for reading the output port
         mov al, 0xd0
         ; Send the command to the controller
         out 0x64, al
        
         ; Will continue when the keyboard's input buffer is free
         call WaitForOutput
         ; Read data from the keyboard port
         in al, 0x60
         ; Store data in EAX
         push eax
        
         ; Will continue when the keyboard's input buffer is free
         call WaitForInput
         ; The controller's command for writing the output port
         mov al, 0xd1
         ; Send the command to the controller
         out 0x64, al
        
         ; Will continue when the keyboard's input buffer is free
         call WaitForInput
        
         ; Restore data from memory in the EAX register
         pop eax
         ; Active gate A20
         or al, 2
         ; Write information back to port
         out 0x60, al

         ; Will continue when the keyboard's input buffer is free
         call WaitForInput
         ; Activate keyboard
         mov al, 0xae
         ; Send command
         out 0x64, al

         ; Will continue when the keyboard's input buffer is free
         call WaitForInput
         ; Restore registry
         popa
         ; Reactivate interrupts
         sti
         ; Return
         ret

; Wait for the input buffer to be free
WaitForInput:
         ; Read port status
         in al, 0x64
         ; Check if buffer is empty
         test al, 1
         ; Try again if it is not empty
         jnz WaitForInput
         ; Return
         ret

; Wait for output buffer to be free
WaitForOutput:
         ; Read port status
         in al, 0x64
         ; Check if buffer is empty
         test al, 1
         ; Try again
         jz WaitForOutput
         ; Return
         ret

%endif