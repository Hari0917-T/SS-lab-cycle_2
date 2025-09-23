section .data
    msg db "Enter a String:",0xa
    len equ $-msg
    msg1 db "Palindrome",0xa
    len1 equ $-msg1
    msg2 db "Not Palindrome",0xa
    len2 equ $-msg2

section .bss
    str1 resb 100
    rev resb 100

section .text
    global _start
_start:
    ; print prompt
    mov eax,4
    mov ebx,1
    mov ecx,msg
    mov edx,len
    int 0x80

    ; read input
    mov eax,3
    mov ebx,0
    mov ecx,str1
    mov edx,100
    int 0x80

    ; replace newline with null
    mov byte [str1+eax-1],0
    mov ecx,eax
    dec ecx
 
    ; ---- Convert to lowercase (for non-case-sensitive check) ----
    mov esi,str1

to_lower:
    mov al,[esi]
    test al,al         ; end of string?
    jz done_lower
    cmp al,'A'
    jb skip_lower      ; below 'A'
    cmp al,'Z'
    ja skip_lower      ; above 'Z'
    add al,32          ; convert to lowercase
    mov [esi],al
skip_lower:
    inc esi
    jmp to_lower
done_lower:

    ; ---- Reverse the string ----
    mov esi,str1
    mov edi,rev
    add esi,ecx
    dec esi

reverse:
    mov al,[esi]
    mov [edi],al
    inc edi
    dec esi
    loop reverse

    mov byte[edi],0

    ; ---- Compare strings ----
    mov esi,str1
    mov edi,rev	
cmp:
    mov al,[esi]
    mov bl,[edi]
    cmp al,bl
    jne not_eq
    inc esi
    inc edi
    test al,al
    jz end
    jmp cmp

end:
    mov eax,4
    mov ebx,1
    mov ecx,msg1
    mov edx,len1
    int 0x80
    jmp exit

not_eq:
    mov eax,4
    mov ebx,1
    mov ecx,msg2
    mov edx,len2
    int 0x80

exit:
    mov eax,1
    xor ebx,ebx
    int 0x80
