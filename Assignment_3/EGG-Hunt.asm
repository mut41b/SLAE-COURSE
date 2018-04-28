
inc edx
dec edx
inc edx
dec edx
xor eax, eax
xor ebx, ebx
xor ecx, ecx
xor edx, edx
add eax, 4 
inc ebx  
push byte 0x0a  
push 0x65726568
push 0x74206968
mov ecx, esp  
add edx, 9 
int 0x80
xor eax, eax
inc eax
dec ebx ;  
int 0x80
mov ebx, 0x424a424a  
loop:
inc eax  
cmp DWORD [eax], ebx  
jne loop ; 
jmp eax ; FOUND AN EGG
