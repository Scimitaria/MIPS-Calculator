.data
    promptNum: .asciiz "\nEnter a number:"
    promptOp:  .asciiz "\nEnter an operation:"
    
    addition:  .ascii "+"
    subtract:  .ascii "-"
    multiply:  .ascii "*"
    divide:    .ascii "/"


.text
    la $t3,addition
    la $t4,subtract
    la $t5,multiply
    la $t6,divide

    IO:
#load first num into $t0
        la $a0,promptNum
        li $v0,4
        syscall
        li $v0,5
        syscall
        move $t0,$v0
        
#load second num into $t1       
        la $a0,promptNum
        li $v0,4
        syscall
        li $v0,5
        syscall
        move $t1,$v0
        
#load op into $t2
        la $a0,promptOp
        li $v0,4
        syscall
        li $v0,8
        syscall
        move $t2,$v0

    jump:
#Not working.
	beq $t2,$t3,addit
	beq $t2,$t4,subit
	beq $t2,$t5,multit
	beq $t2,$t6,divit
	j exit


                
    addit:
        add $a0,$t0,$t1
        li $v0,1
        syscall
        j IO
        
    subit:
        sub $a0,$t0,$t1
        li $v0,1
        syscall
        j IO
        
    multit:
        mult $t0,$t1
        mflo $a0 #mult is weird
        li $v0,1
        syscall
        j IO
        
    divit:
        div $t0,$t1
        mflo $a0
        li $v0,1
        syscall
        j IO

    exit:
        li $v0,10
        syscall
