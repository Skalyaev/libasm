section .text
        global ft_strdup

        extern malloc

ft_strdup:
        push rbp
        mov rbp, rsp
        sub rsp, 0x8
        push rbx

        mov rbx, rdi
        xor rax, rax
        mov rcx, 1

        .count:
                cmp byte [rdi], 0
                je .alloc

                inc rdi
                inc rcx
                jmp .count

        .alloc:
                mov rdi, rcx
                call malloc
                test rax, rax
                jz .exit

                xor rcx, rcx

        .copy:
                cmp byte [rbx + rcx], 0
                je .null_terminate

                mov r8, [rbx + rcx]
                mov [rax + rcx], r8

                inc rcx
                jmp .copy

        .null_terminate:
                mov byte [rax + rcx], 0

        .exit:
                pop rbx
                mov rsp, rbp
                pop rbp
                ret
