section .data
        level2 db NL, 'Level 2 - strcpy(<dest>, <src>): Copy <src> into <dest>', NL, 0
        level2_len equ $ - level2
        level2_input1 db '<dest>: ', 0
        level2_input1_len equ $ - level2_input1
        level2_input2 db '<src>: ', 0
        level2_input2_len equ $ - level2_input2

        format_strcpy db '--> strcpy: %s', NL, 0
        format_ft_strcpy db '--> ft_strcpy: %s', NL, 0

section .text
        global test_strcpy
        extern strcpy, ft_strcpy

test_strcpy:
        FT_ENTER

        WRITE level2, level2_len
        RET_TEST

        ;---> strcpy() actually SEGVs when passed NULL 
        ;WRITE null_test_msg, null_test_msg_len
        ;RET_TEST

        ;mov rdi, 0x0
        ;mov rsi, 0x0
        ;call ft_strcpy
        ;PRINTF format_ft_strcpy, rax
        ;RET_TEST

        ;mov rdi, 0x0
        ;lea rsi, [level2_input1]
        ;call strcpy
        ;PRINTF format_strcpy, rax
        ;RET_TEST

        .loop:
                WRITE level2_input1, level2_input1_len
                RET_TEST

                READ buffer1, BUFFER_SIZE - 1
                RET_TEST
                mov r12, rax
                TCFLUSH

                WRITE level2_input2, level2_input2_len
                RET_TEST

                READ buffer2, BUFFER_SIZE - 1
                RET_TEST
                mov r13, rax
                TCFLUSH

                sub rsp, BUFFER_SIZE
                xor rcx, rcx

        .push_first_buffer:
                mov al, [buffer1 + rcx]
                mov [rsp + rcx], al
                inc rcx
                test al, al
                jnz .push_first_buffer

                mov r14, rsp

                sub rsp, BUFFER_SIZE
                xor rcx, rcx

        .push_second_buffer:
                mov al, [buffer2 + rcx]
                mov [rsp + rcx], al
                inc rcx
                test al, al
                jnz .push_second_buffer

                mov r15, rsp

        .run_strcpy:
                mov rdi, r14
                mov rsi, r15
                call ft_strcpy

                PRINTF format_ft_strcpy, rax
                RET_TEST

                lea rdi, [buffer1]
                lea rsi, [buffer2]
                call strcpy

                PRINTF format_strcpy, rax
                RET_TEST

                add rsp, BUFFER_SIZE
                add rsp, BUFFER_SIZE

                test r12, r12
                jnz .new_loop
                test r13, r13
                jnz .new_loop

        .exit:
                FT_LEAVE
                ret

        .new_loop:
                BZERO buffer1, r12
                BZERO buffer2, r13
                jmp .loop
