.data
    promptFst:	.asciiz "\nEnter the first integer: "		
    promptSnd:	.asciiz "Enter the second integer: "		
    promptOp: 	.asciiz "Enter an operation (+,-,*,/,^,%): "	
    result:    	.asciiz "\nResult: "				
    continue:	.asciiz "\nContinue? (y/n): "			
    notOp:	.asciiz "\nInvalid operator, please try again"
    divZero:	.asciiz "\nPlease do not divide or modulo by zero"
    equals:	.asciiz " = "
    
    yesString:	.asciiz "y"
    addString:	.asciiz "+"
    subString:	.asciiz "-"
    mulString:	.asciiz "*"
    divString:	.asciiz "/"
    modString:	.asciiz "%"
    expString:	.asciiz "^"
    lovString:	.asciiz "♥"
    
    operator: 	.space 6	# this is a buffer that will be used for reading user input as a string
    yes:	.space 3	# this is a buffer for taking the y or n input for continuation

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
        
	# load operation string into the operator label
        la $a0,promptOp
        li $v0,4
        syscall
        li $v0,8
        la $a0,operator
        li $a1,6
        syscall
	jal rmNewline

    # handle the operator jumping logic
    jump:
    	li $t9,1
	la $a0,operator
	
	la $a1,addString
	jal strComp
	beq $v0,$t9,addit

	la $a1,subString
	jal strComp
	beq $v0,$t9,subit

	la $a1,mulString
	jal strComp
	beq $v0,$t9,multit

	la $a1,divString
	jal strComp
	beq $v0,$t9,divit

	la $a1,modString
	jal strComp
	beq $v0,$t9,modit
	
	la $a1,expString
	jal strComp
	beq $v0,$t9,expit
	
	la $a1,lovString
	jal strComp
	beq $v0,$t9,lovit
	
	j opError
	
    # string comparison function
    strComp:
    	move $t0,$a0
    	move $t1,$a1
    	strLoop:
    	    lb $t2,0($t0)
    	    lb $t3,0($t1)
    	    bne $t2,$t3,notEqual
    	    beq $t2,$zero,equal	
    	    addi $t0,$t0,1
    	    addi $t1,$t1,1
    	    j strLoop
    	notEqual:
    	    li $v0,0
    	    jr $ra
    	equal:
    	    li $v0,1
    	    jr $ra 
    
    # remove the newline from the end of a string
    rmNewline:
    	rmLoop:
    	    lb $t1,0($a0)
    	    li $t2,10		# ascii value of \n
    	    beq $t1,$t2,rm
    	    addi $a0,$a0,1
    	    j rmLoop
    	rm:
    	    sb $zero,0($a0)
    	    jr $ra

    # handle addition            
    addit:
        add $s2,$s0,$s1
        j print
        
    # handle subtraction
    subit:
        sub $s2,$s0,$s1
        j print
        
    # handle multiplication
    multit:
        mult $s0,$s1
        mflo $s2
        j print
        
    # handle division
    divit:
       	beq $s1,$zero,zeroError
        div $s0,$s1
        mflo $s2
        j print
        
    # handle modulo
    modit:
       	beq $s1,$zero,zeroError
    	rem $s2,$s0,$s1
    	j print
    
    # handle exponents
    expit:
    	li $t0,1
    	move $s2,$s0
    	expLoop:
    	    bge $t0,$s1,print
    	    mult $s2,$s0
            mflo $s2
            addi $t0,$t0,1
            j expLoop
    
    # handle the heart operator
    lovit:
    	li $s2,69420
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
    	
     	la $a0,operator
     	li $v0,4
    	syscall
    	
    	move $a0,$s1
     	li $v0,1
    	syscall
    	
    	la $a0,equals
     	li $v0,4
    	syscall  
    	 	
    	move $a0,$s2
    	li $v0,1
    	syscall
	
    # check whether the user wants to continue the program
    check:
    	la $a0,continue
        li $v0,4
        syscall
        
        li $v0,8
        la $a0,yes
        la $a1,3
        syscall
        
        jal rmNewline
        
        la $a0,yes
        la $a1,yesString
        jal strComp
        
        li $t9,1
        beq $v0,$t9,IO
       
    # exit the program cleanly
    exit:
        li $v0,10
        syscall
