
section .bss
    num resb 10          ; buffer to store input number as string
    count resb 1         ; to store digit count
    

section .data
    msg db "Enter a number: ", 0
    len equ $-msg
    result db "Number of digits: ", 0
    res_len equ $-result
    msg2 db 0xa
    

section .text
    global _start

_start:
    ; Print prompt
    mov eax, 4           ; sys_write
    mov ebx, 1           ; stdout
    mov ecx, msg
    mov edx, len
    int 0x80

    ; Read input
    mov eax, 3           ; sys_read
    mov ebx, 0           ; stdin
    mov ecx, num
    mov edx, 10          ; read max 10 bytes
    int 0x80

    ; Count digits
    mov ecx, 0           ; digit counter
    mov esi, num

count_loop:
    mov al, [esi]
    cmp al, 10           ; newline character?
    je done_count
    cmp al, 0
    je done_count
    inc ecx
    inc esi
    jmp count_loop

done_count:
    ; Store digit count
    add ecx, '0'         ; convert number to ASCII
    mov [count], cl

    ; Print result message
    mov eax, 4
    mov ebx, 1
    mov ecx, result
    mov edx, res_len
    int 0x80

    ; Print digit count
    mov eax, 4
    mov ebx, 1
    mov ecx, count
    mov edx, 1
    int 0x80
    
     mov eax, 4
    mov ebx, 1
    mov ecx, msg2
    mov edx, 1
    int 0x80

    


    ; Exit program
    mov eax, 1
    mov ebx, 0
    int 0x80
