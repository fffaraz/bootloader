; gdt.inc

; Still 16-bit
bits 16

; Global Descriptor Table
StartGDT:
        ; Null descriptor. Avoid using selectors valued as 0
        dd     0
        dd     0

        ; Code descriptor
        dw     0ffffh
        ; Maximum level for the system's code
        dw     0
        db     0
        ; System Code (Ring 0, read-only)
        db     10011010b
        ; Granularity
        db     11001111b
        ; Segment base
        db     0
         
        ; The descriptor data (like code, but you can write, too)
        dw     0ffffh
        ; Maximum level for the system's data
        dw     0
        db     0
        ; System data (ring 0 - can be executed only in ring 0)
        db     10010010b
        ; Granularity
        db     11001111b
        ; Segment base
        db     0
             
StopGDT:

GDT:
        dw StopGDT - StartGDT - 1
        ; base of GDT
        dd StartGDT

; The procedure that installs the GDT in the GDTR register
InstallGDT:
        ; Switch off interrupts
        cli
        mov ebx, GDT
        ; Save the GDT in the corresponding register, GDTR
        lgdt [GDT]
        ; Enable interrupts
        sti
        ; Return to the line of code that called the procedure
        ret