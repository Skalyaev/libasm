section .data
        error_msg db "ft_list_push_front(): error", 0xa, 0
        error_msg_len equ $ - error_msg

section .text
        global ft_list_push_front

        extern malloc

ft_list_push_front:
        push rbp
        mov rbp, rsp
        push rdi
        push rsi

        mov rdi, 0x10
        call malloc
        test rax, rax
        jz .malloc_failed

        pop rsi
        pop rdi

        mov r8, [rdi]
        mov qword [rax], rsi
        mov qword [rax + 0x8], r8
        mov [rdi], rax

        .exit:
                mov rsp, rbp
                pop rbp
                ret

        .malloc_failed:
                pop rsi
                pop rdi
                mov rax, -0xc
                jmp .exit