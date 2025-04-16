.data
    promptFst:	.asciiz "\nEnter the first integer: "		
    promptSnd:	.asciiz "Enter the second integer: "		
    promptOp: 	.asciiz "Enter an operation (+,-,*,/,^,%,g): "	
    continue:	.asciiz "\nContinue? (y/n): "			
    notOp:	    .asciiz "\nInvalid operator, please try again"
    divZero:	.asciiz "\nPlease do not divide or modulo by zero"

    result:    	.asciiz "\nResult: "				
    gcd:	    .asciiz "gcd("
    equals:	    .asciiz " = "

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
    	li $t0,103		# ascii value for g (used for gcd)
    	beq $s2,$t0,gcdit
   	j opError
    
    # handle addition            
    addit:
        add $s3,$s0,$s1
        j print
        
    # handle subtraction
    subit:
        sub $s3,$s0,$s1
        j print
        
    # handle multiplication
    multit:
        mult $s0,$s1
        mflo $s3
        j print
        
    # handle division
    divit:
       	beq $s1,$zero,zeroError
        div $s0,$s1
        mflo $s3
        j print
        
    # handle modulo
    modit:
       	beq $s1,$zero,zeroError
    	rem $s3,$s0,$s1
    	j print
    
    # handle exponents
    expit:
    	beq $s1,$zero,retOne
    	li $t0,1
    	move $s3,$s0
    	loop:
    	    bge $t0,$s1,print
    	    mult $s3,$s0
            mflo $s3
            addi $t0,$t0,1
            j loop
        retOne:
            li $s3,1
            j print
    
    # handle gcd
    gcdit:
        # put the larger input integer into t0 and the smaller into t1
    	blt $s0,$s1,lt
    	gt:
    	    move $t0,$s0
    	    move $t1,$s1
    	    j zeroCheck
    	lt:
    	    move $t0,$s1
    	    move $t1,$s0
    	    
    	# handle the zero cases
    	zeroCheck:
    	    beq $t0,$zero,negOther
    	    beq $t1,$zero,retOther
    	    
    	# do the gcd calculations
    	gcdLoop:
    	    rem $t2,$t0,$t1
	    beq $t2,$zero,gcdPrint
	    move $t0,$t1
	    move $t1,$t2
	    j gcdLoop
	
        # handle the zero cases
        negOther:
            sub $t1,$zero,$t1
            j gcdPrint
        retOther:
            move $t1,$t0
            j gcdPrint

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
	    
    # print function for the gcd operation, assumes result is in t1
    gcdPrint:
        la $a0,result
    	li $v0,4
    	syscall
    	
    	la $a0,gcd
    	li $v0,4
    	syscall
    	
    	move $a0,$s0
     	li $v0,1
    	syscall
    	
    	li $a0,44		# ascii value for ,
    	li $v0,11
    	syscall
    	
    	move $a0,$s1
     	li $v0,1
    	syscall
    	
    	li $a0,41		# ascii value for )
    	li $v0,11
    	syscall
    	
    	la $a0,equals
     	li $v0,4
    	syscall 
    	  	
    	move $a0,$t1
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
        
        li $t0,121		# ascii value for y
        beq $v0,$t0,IO	
        j exit
       
    # exit the program cleanly
    exit:
        li $v0,10
        syscall
