; --- DEFINE
%define TAB 9
%define NL 10

; --- SYSCALL
%macro EXIT_SUCCESS 0
    xor rdi, rdi
    mov rax, 60
    syscall
%endmacro

%macro EXIT_FAILURE 0
    mov rdi, rax
    mov rax, 60
    syscall
%endmacro

%macro READ 2
    xor rdi, rdi
    lea rsi, [%1]
    mov rdx, %2
    xor rax, rax
    syscall
%endmacro

%macro WRITE 2
    mov rdi, 1
    lea rsi, [%1]
    mov rdx, %2
    mov rax, 1
    syscall
%endmacro

; --- LIB
%macro PRINTF 2
    lea rdi, [%1]
    mov rsi, %2
    xor rax, rax
    call printf
%endmacro

%macro TCFLUSH 0
    xor rdi, rdi
    xor rsi, rsi
    call tcflush
%endmacro

%macro ATOI 1
    lea rdi, [%1]
    call atoi
%endmacro

; --- NATIVE
%macro BZERO 2
    mov rdi, %1
    mov rcx, %2
    xor al, al
    rep stosb
%endmacro

%macro MEMSET 3
    mov rdi, %1
    mov rcx, %2
    mov al, %3
    rep stosb
%endmacro

%macro ENTER_PLS 0
    push rbp
    mov rbp, rsp
%endmacro

%macro LEAVE_PLS 0
    mov rsp, rbp
    pop rbp
%endmacro

%macro RET_TEST 0
    test rax, rax
    js .exit
%endmacro