.data
    promptFst:	.asciiz "\nEnter the first integer: "		# requires a \n because the previous print is the result which has no implicit \n
    promptSnd:	.asciiz "Enter the second integer: "		# does not require a \n because the previous print is an int which has implicit \n
    promptOp: 	.asciiz "Enter an operation (+,-,*,/): "	# same here
    result:    	.asciiz "\nResult: "				# requires a \n because the previous print is a char which does not have an implicit \n
    equals:	.asciiz " = "
    
    addition:  	.byte '+'
    subtract:  	.byte '-'
    multiply:  	.byte '*'
    divide:    	.byte '/'

#load the operation bytes into a s1-s4
.text
    la $t1,addition
    lb $s1,0($t1)
    la $t2,subtract
    lb $s2,0($t2)
    la $t3,multiply
    lb $s3,0($t3)
    la $t4,divide
    lb $s4,0($t4)

    IO:
#load first num into $t0
        la $a0,promptFst
        li $v0,4
        syscall
        li $v0,5
        syscall
        move $t0,$v0
        
#load second num into $t1       
        la $a0,promptSnd
        li $v0,4
        syscall
        li $v0,5
        syscall
        move $t1,$v0
        
#load op into $t2
        la $a0,promptOp
        li $v0,4
        syscall
        li $v0,12
        syscall
        move $t2,$v0

    jump:
    	beq $t2,$s1,addit
    	beq $t2,$s2,subit
    	beq $t2,$s3,multit
    	beq $t2,$s4,divit
	j exit
                
    addit:
        add $t3,$t0,$t1
        j print
        
    subit:
        sub $t3,$t0,$t1
        j print
        
    multit:
        mult $t0,$t1
        mflo $t3 #mult is weird
        j print
        
    divit:
        div $t0,$t1
        mflo $t3
        j print
        
    #formats the print statement all fancy, assumes the output is stored in t3
    print:
     	la $a0,result
    	li $v0,4
    	syscall
    	move $a0,$t0
     	li $v0,1
    	syscall
     	move $a0,$t2
     	li $v0,11
    	syscall
    	move $a0,$t1
     	li $v0,1
    	syscall
    	la $a0,equals
     	li $v0,4
    	syscall   	
    	move $a0,$t3
    	li $v0,1
    	syscall
    	j IO

    exit:
        li $v0,10
        syscall
