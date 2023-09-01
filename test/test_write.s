section .data
        level4 db NL, 'Level 4 - write(<fd>, <buffer>, <count>): Write <count> character(s) from <buffer> into <fd>', NL, 0
        level4_len equ $ - level4
        level4_input1 db '<fd>: ', 0
        level4_input1_len equ $ - level4_input1
        level4_input2 db '<buffer>: ', 0
        level4_input2_len equ $ - level4_input2
        level4_input3 db '<count>: ', 0
        level4_input3_len equ $ - level4_input3

        format_write db '--> write: %d', NL, 0
        format_ft_write db '--> ft_write: %d', NL, 0

        write_errno db '--> write', 0
        ft_write_errno db '--> ft_write', 0

section .text
        global test_write
        extern write, ft_write

test_write:
        FT_ENTER

        WRITE level4, level4_len
        RET_TEST

        .loop:
                WRITE level4_input1, level4_input1_len
                RET_TEST

                READ buffer1, BUFFER_SIZE - 1
                RET_TEST
                mov r12, rax
                TCFLUSH

                WRITE level4_input2, level4_input2_len
                RET_TEST

                READ buffer2, BUFFER_SIZE - 1
                RET_TEST
                mov r13, rax
                TCFLUSH

                WRITE level4_input3, level4_input3_len
                RET_TEST

                READ buffer3, BUFFER_SIZE - 1
                RET_TEST
                mov r14, rax
                TCFLUSH

        .do_ft_write:
                ATOI buffer3
                mov rbx, rax

                ATOI buffer1
                mov rdi, rax
                lea rsi, [buffer2]
                mov rdx, rbx
                call ft_write
                mov rbx, rax

                PRINTF format_ft_write, rbx
                RET_TEST
                
                test rbx, rbx
                jns .do_write

                mov rdi, ft_write_errno
                call perror

        .do_write:
                ATOI buffer3
                mov rbx, rax

                ATOI buffer1
                mov rdi, rax
                lea rsi, [buffer2]
                mov rdx, rbx
                call write
                mov rbx, rax

                PRINTF format_write, rbx
                RET_TEST
                
                test rbx, rbx
                jns .end_check

                mov rdi, write_errno
                call perror

        .end_check:
                test r12, r12
                jnz .new_loop
                test r13, r13
                jnz .new_loop
                test r14, r14
                jnz .new_loop

        .exit:
                FT_LEAVE
                ret

        .new_loop:
                BZERO buffer1, r12
                BZERO buffer2, r13
                BZERO buffer3, r14
                jmp .loop
