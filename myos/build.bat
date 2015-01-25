@echo off

nasm boot.asm -f bin -o boot.bin
nasm start.asm -f bin -o start.bin

pause
exit