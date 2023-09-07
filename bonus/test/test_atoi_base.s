section .data
        level1 db NL, 'Level 1 - atoi_base(<value>, <base>): Convert <value> from its <base> into an int', NL, 0
        level1_len equ $ - level1
        level1_input1 db '<value>: ', 0
        level1_input1_len equ $ - level1_input1
        level1_input2 db '<base>: ', 0
        level1_input2_len equ $ - level1_input2

        format_atoi_base db '--> atoi_base: %d', NL, 0

section .text
        global test_atoi_base

        extern ft_atoi_base

test_atoi_base:
        FT_ENTER

        WRITE level1, level1_len
        RET_TEST

        .loop:
                WRITE level1_input1, level1_input1_len
                RET_TEST

                READ buffer1, BUFFER_SIZE - 1
                RET_TEST
                mov r12, rax
                TCFLUSH

                WRITE level1_input2, level1_input2_len
                RET_TEST

                READ buffer2, BUFFER_SIZE - 1
                RET_TEST
                mov r13, rax
                TCFLUSH

                lea rdi, [buffer1]
                lea rsi, [buffer2]
                call ft_atoi_base

                PRINTF format_atoi_base, rax
                RET_TEST

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
