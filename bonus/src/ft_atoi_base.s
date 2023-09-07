section .data
        error_msg db "ft_atoi_base(): invalid base", 0xa, 0
        error_msg_len equ $ - error_msg

section .text
        global ft_atoi_base

ft_atoi_base:
        push rbp
        mov rbp, rsp

        mov rdx, 0x1

        call check_base
        test rax, rax
        jz .exit_failure
        cmp byte rax, 0x1
        jz .exit_failure

        mov r8, rax
        xor rax, rax

        .through_whitespaces:
                cmp byte [rdi], 0x9
                je .is_whitespace
                cmp byte [rdi], 0xa
                je .is_whitespace
                cmp byte [rdi], 0xb
                je .is_whitespace
                cmp byte [rdi], 0xc
                je .is_whitespace
                cmp byte [rdi], 0xd
                je .is_whitespace
                cmp byte [rdi], 0x20
                je .is_whitespace

                jmp .through_signs
        
        .is_whitespace:
                inc rdi
                jmp .through_whitespaces

        .through_signs:
                cmp byte [rdi], 0x2b
                je .is_sign
                cmp byte [rdi], 0x2d
                je .is_minus

                xor rcx, rcx
                jmp .through_digits

        .is_minus:
                neg rdx

        .is_sign:
                inc rdi
                jmp .through_signs

        .through_digits:
                mov r9b, [rsi + rcx]

                test r9b, r9b
                jz .exit

                cmp [rdi], r9b
                je .is_in_base

                inc rcx
                jmp .through_digits

        .is_in_base:
                imul rax, r8
                add rax, rcx

                xor rcx, rcx
                inc rdi
                jmp .through_digits

        .exit:
                imul rax, rdx
                mov rsp, rbp
                pop rbp
                ret
        
        .exit_failure:
                mov rdi, 1
                lea rsi, [error_msg]
                mov rdx, error_msg_len
                mov rax, 1
                syscall

                xor rax, rax
                jmp .exit

check_base:
        xor rax, rax
        xor rcx, rcx

        .loop:
                mov r9b, [rsi + rcx]

                test r9b, r9b
                jz .exit
                cmp r9b, 0x9
                je .exit_failure
                cmp r9b, 0xa
                je .exit_failure
                cmp r9b, 0xb
                je .exit_failure
                cmp r9b, 0xc
                je .exit_failure
                cmp r9b, 0xd
                je .exit_failure
                cmp r9b, 0x20
                je .exit_failure
                cmp r9b, 0x2b
                je .exit_failure
                cmp r9b, 0x2d
                je .exit_failure

                xor r8, r8
        
        .check-duplicates:
                mov r10b, [rsi + r8]
                
                test r10b, r10b
                jz .new_loop
                
                cmp r9b, r10b
                je .exit_failure
                
                inc r8
                jmp .check-duplicates

        .new_loop:
                inc rcx
                inc rax
                jmp .loop

        .exit:
                ret

        .exit_failure:
                xor rax, rax
                ret