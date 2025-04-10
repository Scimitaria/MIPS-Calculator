.data
    promptFst:	.asciiz "\nEnter the first integer: "		
    promptSnd:	.asciiz "Enter the second integer: "		
    promptOp: 	.asciiz "Enter an operation (+,-,*,/,^,%): "	
    result:    	.asciiz "\nResult: "				
    continue:	.asciiz "\nContinue? (y/n): "			
    notOp:	.asciiz "\nInvalid operator, please try again"
    divZero:	.asciiz "\nPlease do not divide or modulo by zero"
    equals:	.asciiz " = "

.text
    # handle the IO logic
    IO:
	# load first integer into $s0
        la $a0,promptFst
        li $v0,4
        syscall
        li $v0,5
        syscall
        move $s0,$v0
        
	# load second integer into $s1       
        la $a0,promptSnd
        li $v0,4
        syscall
        li $v0,5
        syscall
        move $s1,$v0
        
	# load operation character into $s2
        la $a0,promptOp
        li $v0,4
        syscall
        li $v0,12
        syscall
        move $s2,$v0

    # handle the operator jumping logic
    jump:
    	li $t0,43		# ascii value for +
    	beq $s2,$t0,addit
    	li $t0,45		# ascii value for -
    	beq $s2,$t0,subit
    	li $t0,42		# ascii value for *
    	beq $s2,$t0,multit
    	li $t0,47		# ascii value for /
    	beq $s2,$t0,divit
    	li $t0,37		# ascii value for %
    	beq $s2,$t0,modit	
    	li $t0,94		# ascii value for ^
    	beq $s2,$t0,expit
    	li $t0,55357		# unicode value for 💯
    	beq $s2,$t0,percit
	j opError
                
    addit:
        add $s3,$s0,$s1
        j print
        
    subit:
        sub $s3,$s0,$s1
        j print
        
    multit:
        mult $s0,$s1
        mflo $s3
        j print
        
    divit:
       	beq $s1,$zero,zeroError
        div $s0,$s1
        mflo $s3
        j print
        
    modit:
       	beq $s1,$zero,zeroError
    	rem $s3,$s0,$s1
    	j print
    
    # does not work with really large outputs, max output is still only 32 bits
    expit:
    	li $t0,1
    	move $s3,$s0
    	loop:
    	    bge $t0,$s1,print
    	    mult $s3,$s0
            mflo $s3
            addi $t0,$t0,1
            j loop
            
    # for first and second integers x and y, this returns x percent of y, truncated to the nearest integer
    percit:
        mult $s0,$s1
        mflo $t2
    	li $t0,100
        div $t2,$t0
        mflo $s3
        j print    	
            
    # print an error if the input is not a valid operation
    opError:
    	la $a0,notOp
    	li $v0,4
    	syscall
    	j IO
                    
    # print an error if the user tries to divide or modulo by zero
    zeroError:
    	la $a0,divZero
    	li $v0,4
    	syscall
    	j IO
        
    # formats the print statement all fancy, assumes the output is stored in s3
    print:
     	la $a0,result
    	li $v0,4
    	syscall
    	move $a0,$s0
     	li $v0,1
    	syscall
     	move $a0,$s2
     	li $v0,11
    	syscall
    	move $a0,$s1
     	li $v0,1
    	syscall
    	la $a0,equals
     	li $v0,4
    	syscall   	
    	move $a0,$s3
    	li $v0,1
    	syscall
	j check
    	
    # check whether the user wants to continue the program
    check:
    	la $a0,continue
        li $v0,4
        syscall
        li $v0,12
        syscall
        li $t0,121	# ascii value for y
        beq $v0,$t0,IO	
        j exit
       
    # exit the program cleanly
    exit:
        li $v0,10
        syscall
