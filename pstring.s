# 208687251 Ahiya Schneider

.section .rodata
format_inValid:   .string     "invalid input!\n"

    .text
    .globl pstrlen
.type pstrlen, @function
pstrlen:                        #get 1 arg: 1.%rdi- *pstr
    push %rbp                   #set the pointer to the head of the stack
    movq %rsp, %rbp             #set the pointer to the botttom of the stack
    
    xorq %rax,%rax
    movb (%rdi),%al             #put in %rax the return value the length of the pstr
    
    movq %rbp, %rsp             #set the top of the stack to bottom
    popq %rbp                   #pop the head of stack to %rbp
    ret

.globl replaceChar
.type replaceChar, @function
replaceChar:                    #with 3 args 1.%rdi-Pstring* pstr,2.%rsi-char oldChar,3.%rdx-char newChar 
    push %rbp                   #set the pointer to the head of the stack
    movq %rsp, %rbp             #set the pointer to the botttom of the stack

    xorq %r8,%r8                #set %r8(counter) = 0
    xorq %r9,%r9                #set %r9 = 0              
    
    movb (%rdi),%r9b            #put in %r9 the length of the pstr.
    
    cmpq %r8,%r9                #check if the counter = pstrlen.
    je endReplaceChar           #if yes jump to the finish.
    
    replaceingLoop:
    cmpq %r8,%r9                #check if the counter = pstrlen.
    je endReplaceChar           #if yes jump to the finish.
    addq $1,%r8                 #else add 1 to counter and start checking
    
    xorq %rcx,%rcx              # set %rcx = 0
    movq %rdi, %rcx             # set %rcx on the head of the pstr
    addq %r8,%rcx               # go to %r8 index in pstr
    cmpb (%rcx),%sil           # test byte in %rcx index with the given char.
    je replaceCharac            #if equal jump to replace the letter   
    jmp replaceingLoop          #else go back to the start of loop
    
    replaceCharac:
    movb %dl,(%rcx)             #put in %rcx index byte the char from user 
    jmp replaceingLoop          #else go back to the start of loop
    
    endReplaceChar:
    xorq %rax, %rax
    movq %rdi, %rax             #return pointer to the pstr
    movq %rbp, %rsp             #set the top of the stack to bottom
    popq %rbp                   #pop the head of stack to %rbp
    ret

.globl pstrijcpy
.type pstrijcpy, @function
pstrijcpy:                      # get 4 args: 1.%rdi-Pstring* dst, 2.%rsi-Pstring* src, 3.%rdx-char i, 4.%rcx-char j .return Pstring*
    push %rbp                   #set the pointer to the head of the stack
    movq %rsp, %rbp             #set the pointer to the botttom of the stack

    validationCpy:                 #to check: 1. i > j, 2.j > pstrlen 3.????? i < 0 not yet???
    cmp %rdx,%rcx               # %rdx = i, %rcx = j (j-i)
    jl notValidCpy                 # if i > j  jump to not valid
    
    xorq %rbx, %rbx
    movb (%rdi), %bl
    subq $1, %rbx
    cmpb %bl,%cl             # (%rdi) = pstrlen1 , %cl = j (j- pstrlen1)
    ja notValidCpy                 # if j > pstrlen1 jump to not valid
    
    xorq %rbx, %rbx
    movb (%rsi), %bl
    subq $1, %rbx
    cmpb %bl,%cl             # (%rsi) = pstrlen2 , %cl = j (j- pstrlen2)
    ja notValidCpy                 # if j > pstrlen2 jump to not valid
    
    movq %rdx,%r8               #set %r8(counter) = i
    subq $1, %r8                # %r8 = i - 1 (in the loop start I will add to %r8 1 so now i sub 1.
    movq %rcx,%r9               #set %r9 = j
    
    cpyLoop:
    cmpq %r8,%r9                #check if the counter = pstrlen.
    je endPstrijcpy               #if yes jump to the finish.
    addq $1, %r8                #add 1 now so not stay in loop, in start %r8 = i-1    
    
                    
    movq %rdi, %r11             # set %r11 on the head of the dst
    add $1, %r11                # to skip the strlen byte
    movq %rsi, %r12             # set %r12 on the head of the src
    add $1, %r12                # to skip the strlen byte
    addq %r8, %r11              # jump to index as the counter in range i - j in dst
    addq %r8, %r12              # jump to index as the counter in range i - j in src
    
    xorq %rbx, %rbx
    movb (%r12), %bl            #save the value of the char in rbx.
    movb %bl,(%r11)             #save in the dst the value of the char.
    jmp cpyLoop

    endPstrijcpy:
    xorq %rax, %rax
    movq %rdi,%rax              #return the dst pointer
    movq %rbp, %rsp             #set the top of the stack to bottom
    popq %rbp                   #pop the head of stack to %rbp
    ret
    
    notValidCpy:
    movq %rdi, %r12             #save the original *pstr
    movq $format_inValid, %rdi
    xorq %rax, %rax
    call printf
    movq %r12, %rdi             #return the original *pstr to %rdi 
    jmp endPstrijcpy

.globl swapCase
.type swapCase, @function
swapCase:                       # g 1 arg: %rdi - pstring* pstr
    push %rbp                   #set the pointer to the head of the stack
    movq %rsp, %rbp             #set the pointer to the botttom of the stack

    xorq %r8,%r8                #set %r8(counter) = 0
    xorq %r9,%r9                #set %r9 = 0              
    movb (%rdi),%r9b            #put in %r9 the length of the pstr.
    
    cmpq %r8,%r9                #check if the counter = pstrlen.
    je endSwapCase              #if yes jump to the finish.
    
    swapingLoop:
    cmpq %r8,%r9                #check if the counter = pstrlen.
    je endSwapCase              #if yes jump to the finish.
    addq $1,%r8                 #else add 1 to counter and start checking 
    
    xorq %rcx,%rcx              # set %rcx = 0
    movq %rdi, %rcx             # set %rcx on the head of the pstr
    addq %r8,%rcx               # go to %r8 index in pstr
    
    cmpb $97,(%rcx)             # compare byte to check if greater or equal to 'a'.
    jge swapToUpperChar         #if equal/greater jump to replace the letter   
    cmpb $90,(%rcx)             # compare byte to check if less or equal to 'Z'.
    jle swapToLowerChar         #if equal/lesser jump to replace the letter   

    jmp swapingLoop             #go back to the start of loop
    
    swapToUpperChar:
    xorq %r11, %r11
    movb (%rcx), %r11b 
    cmp $123, %r11              #need to check if (%rcx) is lower/equal to 'z'-122 (already checked biger/equal than 'a' = 97)
    jge swapingLoop             #if it bigger than 122 %rcx is out of range a-z
    
    subb $32,(%rcx)             #sub the ascii difer between upper and lower letter.
    jmp swapingLoop             #than go back to the start of loop
    
    swapToLowerChar:
    xorq %r11, %r11
    movb (%rcx), %r11b
    cmp $64,%r11             #need to check if (%rcx) is lower/equal to 'A'-65 (already checked lesser/equal than 'Z' = 90)
    jle swapingLoop             #else go back to the start of loop
      
    addb $32,(%rcx)             #add the ascii difer between upper and lower letter.
    jmp swapingLoop             #than go back to the start of loop

    endSwapCase:
    xorq %rax, %rax
    movq %rdi, %rax             #return pointer to the pstr
    movq %rbp, %rsp             #set the top of the stack to bottom
    popq %rbp                   #pop the head of stack to %rbp
    ret
 
    .globl pstrijcmp   
.type pstrijcmp, @function
pstrijcmp:                      #get 4 args: 1.%rdi-Pstring* pstr1,2.%rsi- Pstring* pstr2,3.%rdx- char i,4.%rcx- char j
    push %rbp                   #set the pointer to the head of the stack
    movq %rsp, %rbp             #set the pointer to the botttom of the stack
        
    validation:                 #to check: 1. i > j, 2.j > pstrlen 3.????? i < 0 not yet???
    cmp %rdx,%rcx               # %rdx = i, %rcx = j (j-i)
    jl notValid                 # if i > j  jump to not valid
    
    xorq %r10, %r10
    movb (%rdi), %r10b
    subq $1, %r10  
    cmpb %r10b,%cl             # (%rdi) = pstrlen1 , %cl = j (j- pstrlen1)
    ja notValid                 # if j > pstrlen1 jump to not valid
    
    xorq %r10, %r10
    movb (%rsi), %r10b
    subq $1, %r10  
    cmpb %r10b,%cl             # (%rdi) = pstrlen1 , %cl = j (j- pstrlen1)
    ja notValid                 # if j > pstrlen1 jump to not valid
    
    movq %rdx,%r8               #set %r8(counter) = i
    subq $1, %r8                # %r8 = i - 1 (in the loop start I will add to %r8 1 so now i sub 1.
    movq %rcx,%r9               #set %r9 = j
    xorq %r10,%r10              #set %r10 = 0 ,will count the difrence between the two pstr.

    cmpLoop:   #need a register that count for every byte the diffrence between the pstr1[counter] to pstr2[counter]
    cmpq %r8,%r9                #check if the counter = pstrlen.
    je endCmpLoop               #if yes jump to the finish.
    addq $1, %r8                #add 1 now so not stay in loop, in start %r8 = i-1    
    
                    
    movq %rdi, %r11             # set %r11 on the head of the pstr1
    add $1, %r11 #maby??? to skip the strlen byte???????? if yes do also to pstrlen2
    movq %rsi, %r12             # set %r12 on the head of the pstr2
    add $1, %r12 #maby??? to skip the strlen byte???????? if yes do also to pstrlen2
    addq %r8, %r11              # jump to index as the counter in range i - j in pstr1
    addq %r8, %r12              # jump to index as the counter in range i - j in pstr2
    
    addb (%r11), %r10b          #sum = sum + pstr1[counter]
    subb (%r12), %r10b          #sum = sum - pstr2[counter] in total (sum > 0) -> (pstr1 > pstr2)
    jmp cmpLoop
    
    endCmpLoop:
    cmp $0,%r10
    je pstrsEqual
    cmp $128,%r10
    jge pstr2Bigger
    jl pstr1Bigger
    
    pstr1Bigger:                #set %r12 = 1 so in the end label rax will be r12 = 1
    movq $1,%r12
    jmp endPstrijcmp
    
    pstr2Bigger:                #set %r12 = -1 so in the end label rax will be r12 = -1
    movq $-1,%r12
    jmp endPstrijcmp
    
    pstrsEqual:                 #set %r12 = 0 so in the end label rax will be r12 = 0
    movq $0,%r12
    jmp endPstrijcmp
     
    notValid:
    movq $format_inValid, %rdi
    xorq %rax, %rax
    call printf
    movq $-2,%r12
    jmp endPstrijcmp     
                    
    endPstrijcmp:
    xorq %rax, %rax
    movq %r12, %rax             #return the correct number 1 if pstr1 > pstr2 -1 the oppossit 0 equal -2 not valid
    movq %rbp, %rsp             #set the top of the stack to bottom
    popq %rbp                   #pop the head of stack to %rbp
    ret
