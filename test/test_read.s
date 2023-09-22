section .data
        level5 db NL, 'Level 5 - read(<fd>, <buffer>, <count>): Read <count> character(s) from <fd>, save that into <buffer>', NL, 0
        level5_len equ $ - level5
        level5_input1 db '<fd>: ', 0
        level5_input1_len equ $ - level5_input1
        level5_input2 db '<count>: ', 0
        level5_input2_len equ $ - level5_input2

        format_read db '--> read: %d', NL, 0
        format_ft_read db '--> ft_read: %d', NL, 0
        format_read_buffer db '--> read_buffer: %s', NL, 0
        format_ft_read_buffer db '--> ft_read_buffer: %s', NL, 0

        read_errno db '--> read', 0
        ft_read_errno db '--> ft_read', 0

section .text
        global test_read
        extern read, ft_read

test_read:
        FT_ENTER

        WRITE level5, level5_len
        RET_TEST

        WRITE null_test_msg, null_test_msg_len
        RET_TEST

        mov rdi, 0x0
        mov rsi, 0x0
        mov rdx, 0xa
        call ft_read
        PRINTF format_ft_read, rax
        RET_TEST
        mov rdi, ft_read_errno
        call perror
        TCFLUSH

        mov rdi, 0x0
        mov rsi, 0x0
        mov rdx, 0xa
        call ft_read
        PRINTF format_read, rax
        RET_TEST
        mov rdi, read_errno
        call perror
        TCFLUSH

        .loop:
                WRITE level5_input1, level5_input1_len
                RET_TEST

                READ buffer1, BUFFER_SIZE - 1
                RET_TEST
                mov r12, rax
                TCFLUSH

                WRITE level5_input2, level5_input2_len
                RET_TEST

                READ buffer2, BUFFER_SIZE - 1
                RET_TEST
                mov r13, rax
                TCFLUSH

        .do_ft_read:
                ATOI buffer2
                mov rbx, rax

                ATOI buffer1
                mov rdi, rax
                lea rsi, [buffer3]
                mov rdx, rbx
                call ft_read
                mov rbx, rax
                TCFLUSH

                PRINTF format_ft_read, rbx
                RET_TEST

                PRINTF format_ft_read_buffer, buffer3
                RET_TEST

                BZERO buffer3, BUFFER_SIZE
            
                test rbx, rbx
                jns .do_read

                mov rdi, ft_read_errno
                call perror

        .do_read:
                ATOI buffer2
                mov rbx, rax
 
                ATOI buffer1
                mov rdi, rax
                lea rsi, [buffer3]
                mov rdx, rbx
                call read
                mov rbx, rax
                TCFLUSH

                PRINTF format_read, rbx
                RET_TEST

                PRINTF format_read_buffer, buffer3
                RET_TEST

                BZERO buffer3, BUFFER_SIZE
            
                test rbx, rbx
                jns .end_check

                mov rdi, read_errno
                call perror

        .end_check:
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
