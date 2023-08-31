section .text
        global ft_strdup
        extern malloc
        extern __errno_location

ft_strdup:
        push rbp
        mov rbp, rsp
        push rbx
        push rcx
        push r12

        xor rcx, rcx

        .count:
                cmp byte [rdi + rcx], 0
                je .alloc

                inc rcx
                jmp .count

        .alloc:
                test rcx, rcx
                jz .exit

                mov rbx, rdi
                inc rcx

                mov rdi, rcx
                call malloc
                test rax, rax
                jz .set_errno

                xor rcx, rcx

        .copy:
                cmp byte [rbx + rcx], 0
                je .put_last_zero

                mov r12, [rbx + rcx]
                mov [rax + rcx], r12

                inc rcx
                jmp .copy

        .put_last_zero:
                mov r12, [rbx + rcx]
                mov [rax + rcx], r12

        .exit:
                pop r12
                pop rcx
                pop rbx
                mov rsp, rbp
                pop rbp
                ret

        .set_errno:
                neg rax
                mov rbx, rax
                call __errno_location
                mov [rax], rbx

                xor rax, rax
                jmp .exit
