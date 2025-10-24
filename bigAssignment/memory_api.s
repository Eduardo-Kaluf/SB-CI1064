section .data
    message db "Hello World!", 0xA
    message_len equ $ - message
    SIZE_OFFSET: dq 8
    BUSY_OFFSET: dq 9

section .bss
    global base_heap
    global current_brk
    current_brk: resq 1
    base_heap: resq 1

DEFAULT REL
section .text
    global setup_brk
    global dismiss_brk
    global memory_alloc
    global memory_free
    global my_sbrk

    ; brief:
    ;   makes a syscall to get the heap initial brk.
    ;   sets both base_heap and current_brk to the syscall return
    ; args:
    ;   NONE
    setup_brk:
        push rbp
        mov rbp, rsp

        mov rax, 12
        mov rdi, 0
        syscall

        mov [base_heap], rax
        mov [current_brk], rax

        pop rbp
        ret

    ; brief:
    ;   makes a syscall to set the brk to the base address.
    ;   sets the current_brk to the base address
    ;   returns the base heap address.
    ; args:
    ;   NONE
    dismiss_brk:
        push rbp
        mov rbp, rsp

        mov rax, 12
        mov rdi, [base_heap]
        syscall

        mov [current_brk], rax

        pop rbp
        ret

    memory_alloc:
        mov rax, 1
        mov rdi, 1
        mov rsi, message
        mov rdx, message_len
        syscall

    ; args:
    ;   RDI: address to free
    memory_free:
        push rbp
        mov rbp, rsp

        mov r8, [base_heap] ; r8 will be our iterator
        add r8, [BUSY_OFFSET]

        cmp rdi, r8
        jle _memory_free_error1
        cmp rdi, [current_brk]
        jge _memory_free_error1

    _loop_start:
        cmp r8, rdi
        jge _loop_out
        mov r9, r8
        sub r9, [SIZE_OFFSET]
        add r8, [r9]
        add r8, [BUSY_OFFSET]
        jmp _loop_start

    _loop_out:
        cmp r8, rdi
        jg _memory_free_error2

        sub r8, [BUSY_OFFSET]
        mov byte [r8], 0

        mov rax, 0
        jmp _memory_free_ret

    _memory_free_error1:
        mov rax, -1
        jmp _memory_free_ret

    _memory_free_error2:
        mov rax, -2

    _memory_free_ret:
        pop rbp
        ret

    ; brief:
    ;   adds the increment (RDI) to the current brk to get a new desired brk.
    ;   makes a syscall to set the brk to this new address.
    ;   returns the old brk on success.
    ;   returns -1 on failure.
    ; important:
    ;   this functions does not take in account negative bytes, it should not be used to decrease brk
    ;   setup_brk should already been called before using this function (current_brk has to be set at least once)
    ; args:
    ;   RDI: bytes
    my_sbrk:
        push rbp
        mov rbp, rsp

        mov r8, [current_brk]

        mov r9, 0
        cmp rdi, r9
        je _sbrk_success

        mov rax, 12
        add rdi, r8
        syscall

        cmp rax, r8
        je _sbrk_failure

        mov [current_brk], rax
    _sbrk_success:
        mov rax, r8
        jmp _sbrk_end

    _sbrk_failure:
        mov rax, -1

    _sbrk_end:
        pop rbp
        ret
