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
    global debug
    debug: resq 1

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

    

    ; args:
    ;   RDI: address to free
    memory_free:
        push rbp
        mov rbp, rsp

        mov r8, [base_heap] ; r8 will be our iterator
        add r8, [BUSY_OFFSET]

        cmp rdi, r8
        jl _memory_free_error1
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

memory_alloc:
        push rbp

        mov rbp, rsp

        mov [rbp - 56], rdi
        mov rdx, [base_heap]
        mov rax, [current_brk]
        cmp rdx, rax
        jne .L4
        mov QWORD rdi, [rbp - 56]
        add rdi, [BUSY_OFFSET]
        call my_sbrk

        mov rax, [current_brk]
        sub rax, 8
        mov QWORD rdi, [rbp - 56]
        mov QWORD [rax], rdi
        sub rax, 1
        mov BYTE [rax], 0

    .L4:
        mov	rax, [base_heap]
        add	rax, 9
        mov	[rbp - 40], rax
        mov	QWORD [rbp - 16], 0
        mov rdi, [rbp - 56]
        mov	QWORD [rbp - 32], rdi
        mov	QWORD [rbp - 24], 0
        mov	BYTE [rbp - 41], 0
        jmp	.L5
    .L7:
        mov	rax, [rbp - 40]
        mov	rax, [rax - 8]
        mov	[rbp - 16], rax
        mov	rax, [rbp - 40]
        movzx eax, byte [rax - 9]
        mov	[rbp - 41], al
        mov	rax, [rbp - 32]
        cmp	rax, [rbp - 16]
        jg	.L6
        cmp	byte [rbp - 41], 0
        jne	.L6
        mov	rax, [rbp - 40]
        mov	[rbp - 24], rax
        mov	rax, [rbp - 16]
        mov	[rbp - 32], rax

    .L6:
        mov	rax, [rbp - 16]
        add	rax, 9
        add	[rbp - 40], rax
    .L5:
        mov	rdx, [rbp - 40]
        mov	rax, [current_brk]
        cmp	rdx, rax
        jb	.L7

        cmp	QWORD [rbp - 24], 0
        je	.L8
        
        mov	rax, [rbp - 24]
        sub	rax, 9
        mov	BYTE [rax], 1
        mov	rax, [rbp - 56]
        add	rax, 10
        cmp	QWORD [rbp - 32], rax
        jb	.L9
        mov	rax, [rbp - 56]
        lea	rdx, [rax + 9]
        mov	rax, [rbp - 24]
        add	rax, rdx
        mov	[rbp - 8], rax
        mov	rax, [rbp - 8]
        sub	rax, 9
        mov	BYTE [rax], 0
        mov	rax, [rbp - 32]
        sub	rax, [rbp - 56]
        mov	rdx, rax
        mov	rax, [rbp - 8]
        sub	rax, 8
        sub	rdx, 9
        mov	[rax], rdx
        mov	rax, [rbp - 24]
        lea	rdx, [rax - 8]
        mov	rax, [rbp - 56]
        mov	[rdx], rax
        jmp	.L9
    .L8:

        mov rdi, [rbp - 56]
        add  rdi, [BUSY_OFFSET]
        call my_sbrk
        
        mov rax, [current_brk]
        lea rdx, [rax + 9]
        mov rax, [rbp - 24]
        mov [rax], rdx
        mov rdx, [current_brk]
        mov rax, [rbp - 56]
        add rax, rdx
        add rax, 9
        mov [current_brk], rax
        mov rax, [rbp - 24]
        sub rax, 9
        mov byte [rax], 1
        mov rax, [rbp - 24]
        lea rdx, [rax - 8]
        mov rax, [rbp - 56]
        mov [rdx], rax
    .L9:
        mov rax, [rbp - 24]
        pop rbp
        ret
