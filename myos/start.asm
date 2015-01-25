; start.asm

; At this address we will find the code in memory 
org 5000h
; Still in Real Mode
bits 16

; Jump to the initialization procedure
jmp Start
; We include global descriptor table
%include "gdt.inc"
; Include procedures that will open the A20 gate
%include "a20.inc"
Start:
         ; Switch off interrupts
         cli
         ; Updated segment registers
         xor ax, ax
         mov ds, ax
         mov es, ax
         mov ax, 0x7e00
         mov ss, ax
         mov sp, 0xFFFF
         sti
         ; Install global descriptor table
         call InstallGDT
         ; Open A20 gate
         call OpenA20

ProtectedMode:
         ; Switch off interrupts
         cli
         ; Copy the CR0 register into EAX for to change
         mov eax, CR0
         ; Set the registry value to 0
         or eax, 1
         ; We enter safe mode by setting the CR0 register to 0
         mov CR0, eax

         jmp 0x8: LoadSystem

; We are in protected mode, 32-bit operations are available now
bits 32
; Here begins our adventure
LoadSystem:
         ; Set the data and code indicators based on the descriptors in the GDT
         mov ax, 0x10
         mov ds, ax
         mov ss, ax
         mov es, ax
         mov fs, ax
         mov gs, ax
         mov esp, 7e000h
; Include system code - control given to you from here on
%include "system.asm"
; As an extra safety measure, make sure we stop here
cli
hlt