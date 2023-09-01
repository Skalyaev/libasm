section .text
        global ft_read

        extern __errno_location

ft_read:
        push rbp
        mov rbp, rsp

        xor rax, rax
        syscall
        test rax, rax
        js .set_errno

        .exit:
                mov rsp, rbp
                pop rbp
                ret

        .set_errno:
                neg rax
                push rbx
                mov rbx, rax
                call __errno_location
                mov [rax], rbx

                pop rbx
                mov rax, -1
                jmp .exit