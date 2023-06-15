# 208687251 Ahiya Schneider 

.section .rodata
format_int_scanf:           .string     "%d"
format_int_printf:          .string     "The int is: %d\n"
format_string_scanf:        .string     "%s"
format_string_printf:       .string     "The string is: %s\n"

    .text
    .globl run_main
.type run_main, @function
run_main:
    push %rbp
    movq %rsp, %rbp

    sub $528, %rsp
    
    scan_the_first_pstring:
    movq $format_int_scanf, %rdi     #scanf for getting the first number from user the length of the array.
    leaq -528(%rbp), %rsi             #send in %rsi the place to save the number
    xorq %rax, %rax                  #set %rax = 0 so the return value will be valid
    call scanf
    xorq %r14, %r14
    movb -528(%rbp), %r14b
    movb %r14b, -524(%rbp)

    movq $format_string_scanf, %rdi  #the str.len will be at 528
    leaq -523(%rbp), %rsi            #the string will be between 527-271
    xorq %rax, %rax
    call scanf
    
    scan_the_second_pstring:
    movq $format_int_scanf, %rdi     #scanf for getting the first number from user the length of the array.
    leaq -268(%rbp), %rsi            #send in %rsi the place to save the number
    xorq %rax, %rax                  #set %rax = 0 so the return value will be valid
    call scanf
    xorq %r14, %r14
    movb -268(%rbp), %r14b
    movb %r14b, -264(%rbp)

    movq $format_string_scanf, %rdi  #the str.len will be at 270
    leaq -263(%rbp), %rsi            #the string will be between 269-13
    xorq %rax, %rax
    call scanf
    
    scan_the_num_for_swith_case:
    movq $format_int_scanf, %rdi     #scanf for getting the first number from user the length of the array.
    leaq -8(%rbp), %rsi             #send in %rsi the place to save the number
    xorq %rax, %rax                  #set %rax = 0 so the return value will be valid
    call scanf
    
    call_switch_case_part:           # %rdi - the number from user, %rsi - *pstr1 , %rdx - *pstr2 
    movq -8(%rbp), %rdi
    leaq -524(%rbp), %rsi
    leaq -264(%rbp), %rdx
    xorq %rax, %rax
    call run_func
    
    #printing_both_pstrings:
    #leaq -527(%rbp), %rsi
    #movq $format_string_printf, %rdi
    #xorq %rax, %rax
    #call printf
    
    #leaq -269(%rbp), %rsi
    #movq $format_string_printf, %rdi
    #xorq %rax, %rax
    #call printf

    end_main:
    movq %rbp, %rsp
    popq %rbp

    xorq %rax, %rax
    ret