section .data
    msg1 db "string :", 0xa
    msg1_len equ $ - msg1
    msg3 db 0xa

section .bss
    str1 resb 100       ; input string
    counts resb 256     ; frequency table for all ASCII characters
    charbuf resb 1      ; single character buffer
    countbuf resb 4     ; buffer for count (single digit for now)

section .text
    global _start

_start:
    ; print "string :"
    mov eax,4
    mov ebx,1
    mov ecx,msg1
    mov edx,msg1_len
    int 0x80

    ; read string
    mov eax,3
    mov ebx,0
    mov ecx,str1
    mov edx,100
    int 0x80
    mov byte [str1 + eax - 1], 0  ; remove newline

    ; zero counts array
    mov ecx,256
    mov edi,counts
    xor eax,eax
    
zero_loop:

    mov [edi],al
    inc edi
    loop zero_loop

    ; count each character
    mov esi,str1
    
count_loop:

    mov al,[esi]
    cmp al,0
    je print_all
    movzx ebx,al
    inc byte [counts + ebx]
    inc esi
    jmp count_loop

; print all characters and counts
print_all:
    mov edi,0          ; start index

next_char:
    cmp edi,256
    jge done

    mov al,[counts + edi]
    cmp al,0
    je skip_char

    ; print character
    mov eax, edi        ; copy the index into eax
    mov bl, al          ; get the low byte from eax
    mov [charbuf], bl   ; store it in charbuf

    mov [charbuf], bl
    mov eax,4
    mov ebx,1
    mov ecx,charbuf
    mov edx,1
    int 0x80

    ; print ":"
    mov byte [charbuf], ':'
    mov eax,4
    mov ebx,1
    mov ecx,charbuf
    mov edx,1
    int 0x80

    ; print space
    mov byte [charbuf], ' '
    mov eax,4
    mov ebx,1
    mov ecx,charbuf
    mov edx,1
    int 0x80

    ; print count (single digit)
    mov al,[counts + edi]
    add al,'0'
    mov [countbuf],al
    mov eax,4
    mov ebx,1
    mov ecx,countbuf
    mov edx,1
    int 0x80

    ; newline
    mov eax,4
    mov ebx,1
    mov ecx,msg3
    mov edx,1
    int 0x80

skip_char:
    inc edi
    jmp next_char

done:
    ; exit
    mov eax,1
    xor ebx,ebx
    int 0x80
