# 208687251 Ahiya Schneider 

.section .rodata
.align 8 # Align address to multiple of 8
.L10:
.quad .L1 # Case 31: pstrlen
.quad .L2 # Case 32: replacechar
.quad .L2 # Case 33: replacechar
.quad .L6 # Case 34: invalid!
.quad .L3 # Case 35: pstrijcpy- copy
.quad .L4 # Case 36: swapCase
.quad .L5 # Case 37: pstrijcmp- compare
.quad .L6 # Case 38and bigger: invald

format_char_scanf:          .string     " %c"
format_int_scanf:           .string     "%d"

format_pstrlen_printf:      .string     "first pstring length: %d, second pstring length: %d\n"
format_replaceChar_printf:  .string     "old char: %c, new char: %c, first string: %s, second string: %s\n"
format_pstrijcpy_printf:     .string     "length: %d, string: %s\n"
format_swapCase_printf:     .string     "length: %d, string: %s\n"
format_pstrijcmp_printf:    .string     "compare result: %d\n"
format_invalid_printf:      .string     "invalid option!\n"
format_invalid_chose_printf:.string     "%d"

    .text
    .globl run_func
.type run_func, @function
run_func:                                   #get 3 args: 1.%rdi- num for the jump table, 2.%rsi- *pstr1, 3.%rdx- *pstr2.
    push %rbp
    movq %rsp, %rbp
    #pushq %rbx
                                            # Set up the jump table access
    leaq -31(%rdi),%r8                      # Compute xi = x-31
    cmpq $0, %r8
    jl .L6
    cmpq $7, %r8                            # Compare xi:7
    ja .L6                                  # if >, goto default-case
    jmp *.L10(,%r8,8)                      # Goto jt[xi]
    
#pstr length - need to print the length of the 2 pstr.    
#%rsi - *pstr1 , %rdx - *pstr2
#pstrlen func get 1 arg - 1.*pstr.

.L1:                                        # Case 31 - pstrlen
    movq %rsi, %rdi                         
    xorq %rax, %rax                             
    call pstrlen                            #send to pstrlen *pstr1 and get the length of pstr
    
    xorq %r8, %r8
    movq %rax, %r8                          #save the len of pstr1 in %r8

    movq %rdx, %rdi
    xorq %rax, %rax
    call pstrlen                            #send to pstrlen the *pstr2 get the len of pstr2 
      
    xorq %r9, %r9
    movq %rax, %r9                          #save in %r9 the len of the pstr    
    
    xorq %rsi, %rsi                         #set the 2nd arg as 0
    xorq %rdx, %rdx                         #set the 3rd arg as 0
    movq %r8, %rsi                          #set the 2nd arg as the len of pstr1
    movq %r9, %rdx                          #set the 3rd arg as the len of pstr2.
    
    movq $format_pstrlen_printf , %rdi      # "first pstring length: %d, second pstring length: %d\n"
    xorq %rax, %rax
    call printf
    
    jmp .L9                                 # Goto done
    
#replace char- scan 2 chars from user the first is the old(to change) char the second new char
#than replace every where there is the old char to new char
#%rsi - *pstr1 , %rdx - *pstr2
#replacechar func get 3 args - 1.*pstr, 2. old char 3.newchar
    
.L2:                                        # Case 32,33 - replacechar
    movq %rsi, %r13                         #save *pstr1 in %r13
    movq %rdx, %r14                         #save *pstr2 in %r14
    
    scan_first_char_L2:
    sub $16, %rsp
    
    movq $format_char_scanf, %rdi           #scanf for getting the first char from user.
    leaq -16(%rbp), %rsi                    #send in %rsi the place to save the char
    xorq %rax, %rax                         #set %rax = 0 so the return value will be valid
    call scanf
    xorq %rsi, %rsi
    movb -16(%rbp), %sil                    #save in the 2nd arg the 1st char.
    movq %rsi, %r15                         #save the letter
    
    scan_second_char_L2:
    movq $format_char_scanf, %rdi           #scanf for getting the second number from user.
    leaq -16(%rbp), %rsi                    #send in %rsi the place to save the char
    xorq %rax, %rax                         #set %rax = 0 so the return value will be valid
    call scanf
    xorq %rdx, %rdx
    movb -16(%rbp), %dl                     #save in the 3rd arg the 2nd char.
    movq %r15, %rsi                         #save in the 2nd arg the 1st char.
    
    replace_first_pstr_L2:
    movq %r13, %rdi                         #send as first arg *pstr1 
    xorq %rax, %rax
    call replaceChar
    movq %rax, %r13                         #put the new *pstr1 in %r13 back
    
    replace_second_pstr_L2:
    movq %r14, %rdi                         #send as first arg *pstr2 
    xorq %rax, %rax
    call replaceChar
    movq %rax, %r14                         #put the new *pstr2 in %r14 back
    
    print_L2:
    add $16, %rsp                           
    
    movq %r13, %rcx                         #the 1st and 2nd chars already in there registers 
    movq %r14, %r8                          #so change to 4th and 5th args the *pstr1, *pstr2
    addq $1, %rcx                           #skip on the len byte
    addq $1, %r8                           #skip on the len byte
    movq $format_replaceChar_printf , %rdi  # "old char: %c, new char: %c, first string: %s, second string: %s\n"
    xorq %rax, %rax
    call printf
    
    jmp .L9                                 # Goto done

#pstr i-j copy - get 2 index from user and copy the chars from *pstr2 to *pstr1
#%rsi - *pstr1 , %rdx - *pstr2
#pstrijcpy - get 4 args: 1.%rdi-Pstring* dst, 2.%rsi-Pstring* src, 3.%rdx-char i, 4.%rcx-char j .return *pstr to be *pstr1
            
.L3:                                        # Case 35 - pstrijcpy- copy
    movq %rsi, %r13                         #save *pstr1 in %r13
    movq %rdx, %r14                         #save *pstr2 in %r14
    
    scan_first_int_L3:
    sub $16, %rsp
    
    movq $format_int_scanf, %rdi            #scanf for getting the first int from user.
    leaq -16(%rbp), %rsi                    #send in %rsi the place to save the int
    xorq %rax, %rax                         #set %rax = 0 so the return value will be valid
    call scanf
    xorq %r12, %r12
    movq -16(%rbp), %r12                    #save in the 3rd arg the 1st int.

    scan_second_int_L3: 
    movq $format_int_scanf, %rdi            #scanf for getting the first int from user.
    leaq -16(%rbp), %rsi                    #send in %rsi the place to save the int
    xorq %rax, %rax                         #set %rax = 0 so the return value will be valid
    call scanf
    xorq %rsi, %rsi
    movq -16(%rbp), %rcx                    #save in the 4th arg the 2nd int.
    movq %r12, %rdx
    
    calling_pstrijcpy_L3:
    movq %r13, %rdi                         #save *pstr1 in 1st arg
    movq %r14, %rsi                         #save *pstr2 in 2nd arg, the 2 index already in 3rd and 4th args
    xorq %rax, %rax
    call pstrijcpy
    
    print_new_pstr1_L3:
    movq %rax, %rbx                         #the new *pstr1 is returned in %rax
    xorq %rsi, %rsi
    xorq %rdx, %rdx
    movb (%rbx),%sil                        #save in rsi the length int
    addq $1, %rbx                           #to skip on the len byte
    movq %rbx, %rdx                         #save in %rdx (3rd arg) the *pstr after the first byte 
    movq $format_pstrijcpy_printf, %rdi     #  "length: %d, string: %s\n"
    xorq %rax, %rax
    call printf
    
    print_pstr2_L3:              
    xorq %rsi, %rsi                         
    xorq %rdx, %rdx
    movb (%r14),%sil                        #save in rsi the length int
    addq $1, %r14                           #to skip on the len byte
    movq %r14, %rdx                         #save in %rdx (3rd arg) the *pstr after the first byte              
    movq $format_pstrijcpy_printf, %rdi     #  "length: %d, string: %s\n"
    xorq %rax, %rax
    call printf
        
    jmp .L9                                 # Goto done

#swap case- swapping every letter from upper to lower case and the opposit
#%rsi - *pstr1 , %rdx - *pstr2
#swapcase - 1 arg- *pstr and return *swpPstr
                  
.L4:                                        # Case 36 - swapcase
    
    swap_1st_pstr:
    movq %rsi, %rdi                         #put the 2nd arg(*pstr1) in 1st arg
    xorq %rax, %rax
    call swapCase
    movq %rax, %r12                         #take the return *pstr after swap and save in %r12
    
    swap_2nd_pstr:
    movq %rdx, %rdi                         #put the 3rd arg(*pstr2) in 1st arg
    xorq %rax, %rax
    call swapCase
    movq %rax, %rbx                         #take the return *pstr after swap and save in %rbx
    
    print_new_pstr1_L4:
    xorq %rsi, %rsi
    xorq %rdx, %rdx
    movb (%r12),%sil
    addq $1, %r12                           #to skip on the len byte
    movq %r12, %rdx             
    movq $format_swapCase_printf , %rdi     #  "length: %d, string: %s\n"
    xorq %rax, %rax
    call printf
    
    print_new_pstr2_L4:
    xorq %rsi, %rsi
    xorq %rdx, %rdx
    movb (%rbx),%sil
    addq $1, %rbx                           #to skip on the len byte
    movq %rbx, %rdx             
    movq $format_swapCase_printf , %rdi     #  "length: %d, string: %s\n"
    xorq %rax, %rax
    call printf
    
    jmp .L9                                 # Goto done
    
# pstr i-j compare: compare the chars between i to j indexes (getting i,j from user) and return 1 if pstr1 is bigger 
# 0 if they equal, -1 if pstr2 is bigger
# %rsi - *pstr1 , %rdx - *pstr2    
# get 4 args: 1.%rdi-Pstring* pstr1,2.%rsi- Pstring* pstr2,3.%rdx- char i,4.%rcx- char j    

.L5:                                        # Case 37 - pstrijcmp - compare
    movq %rsi, %r13                         #save *pstr1 in %r13
    movq %rdx, %r14                         #save *pstr2 in %r14
    
    scan_first_int_L5:
    sub $16, %rsp
    
    movq $format_int_scanf, %rdi            #scanf for getting the first int from user.
    leaq -16(%rbp), %rsi                    #send in %rsi the place to save the int
    xorq %rax, %rax                         #set %rax = 0 so the return value will be valid
    call scanf
    xorq %r12, %r12
    movq -16(%rbp), %r12                    #save in the 3rd%r12 arg the 1st int.

    scan_second_int_L5: 
    movq $format_int_scanf, %rdi            #scanf for getting the first int from user.
    leaq -16(%rbp), %rsi                    #send in %rsi the place to save the int
    xorq %rax, %rax                         #set %rax = 0 so the return value will be valid
    call scanf
    xorq %rsi, %rsi
    movq -16(%rbp), %rcx                    #save in the 4th arg the 2nd int.
    movq %r12, %rdx
    
    calling_pstrijcmp_L5:
    movq %r13, %rdi                         #save *pstr1 in 1st arg
    movq %r14, %rsi                         #save *pstr2 in 2nd arg, the 2 index already in 3rd and 4th args
    xorq %rax, %rax
    call pstrijcmp
   
    print_pstrijcmp_L5:
    movq %rax, %rsi                         # save the result from the compare in 2nd arg
    movq $format_pstrijcmp_printf, %rdi     # "compare result: %d\n"
    xorq %rax, %rax
    call printf
    
    jmp .L9                                 # Goto done

#L6- in case of invalud input.
        
.L6:                                 #invalid number
    # movq %rdi, %rsi
    movq $format_invalid_printf, %rdi       
    xorq %rax, %rax
    call printf  

    jmp .L9                                 # Goto done
 
.L9:                                
    popq %rbx
    movq %rbp, %rsp
    popq %rbp

    xorq %rax, %rax
    ret