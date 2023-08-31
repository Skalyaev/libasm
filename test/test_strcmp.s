section .data
        level3 db NL, 'Level 3 - strcmp(<string1>, <string2>): Compare <string1> with <string2>', NL, 0
        level3_len equ $ - level3
        level3_input1 db '<string1>: ', 0
        level3_input1_len equ $ - level3_input1
        level3_input2 db '<string2>: ', 0
        level3_input2_len equ $ - level3_input2
        format_strcmp db '--> strcmp: %d', NL, 0
        format_ft_strcmp db '--> ft_strcmp: %d', NL, 0

section .text
        global test_strcmp
        extern atoi
        extern strcmp, ft_strcmp

test_strcmp:
        ENTER_PLS
        WRITE level3, level3_len
        RET_TEST

        .loop:
                WRITE level3_input1, level3_input1_len
                RET_TEST
                READ buffer1, BUFFER_SIZE - 1
                RET_TEST
                mov r12, rax
                TCFLUSH

                WRITE level3_input2, level3_input2_len
                RET_TEST
                READ buffer2, BUFFER_SIZE - 1
                RET_TEST
                mov r13, rax
                TCFLUSH

                lea rdi, [buffer1]
                lea rsi, [buffer2]
                call ft_strcmp
                PRINTF format_ft_strcmp, rax
                RET_TEST

                lea rdi, [buffer1]
                lea rsi, [buffer2]
                call strcmp
                PRINTF format_strcmp, rax
                RET_TEST

                test r12, r12
                jz .first_is_empty

        .new_loop:
                BZERO buffer1, r12
                BZERO buffer2, r13
                jmp .loop

        .first_is_empty:
                test r13, r13
                jnz .new_loop

        .exit:
                LEAVE_PLS
                ret