.data
    promptNum: .asciiz "\nEnter a number:"
    promptOp:  .asciiz "\nEnter an operation:"
    
    addition:  .ascii "+"
    subtract:  .ascii "-"
    multiply:  .ascii "*"
    divide:    .ascii "/"
    quit:      .ascii "q"

.text
    la $t3,addition
    la $t4,subtract
    la $t5,multiply
    la $t6,divide
    la $t7,quit

    IO:
#load first num into $t0
        la $a0,promptNum
        li $v0,4
        syscall
        li $v0,5
        syscall
        move $t0,$v0
        
#load op into $t1
        la $a0,promptOp
        li $v0,4
        syscall
        li $v0,8
        syscall
        move $t1,$v0
#if user inputs q, exit. Not working.
	beq $t1,$t5,exit

#load second num into $t2       
        la $a0,promptNum
        li $v0,4
        syscall
        li $v0,5
        syscall
        move $t2,$v0
                
    add:
        add $a0,$t0,$t2
        li $v0,1
        syscall
        
    sub:
        sub $a0,$t0,$t2
        li $v0,1
        syscall
        
    mult:
        mult $t0,$t2
        mflo $a0 #mult is weird
        li $v0,1
        syscall
        
    div:
        div $t0,$t2
        mflo $a0
        li $v0,1
        syscall

    exit:
        li $v0,10
        syscall
