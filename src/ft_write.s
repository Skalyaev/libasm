section .text
    global ft_write
    extern __errno_location

ft_write:
    push rbp
    mov rbp, rsp

    mov rax, 1
    syscall
    test rax, rax
    js .set_errno

    .exit:
        mov rsp, rbp
        pop rbp
        ret

    .set_errno:
        neg rax
        mov rbx, rax
        call __errno_location
        mov [rax], rbx

        mov rax, -1
        jmp .exit