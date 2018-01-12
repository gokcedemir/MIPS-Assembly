	#Register used: 
	## $s0 - used to hold the first number.
	## $s1 - used to hold the second number.
	## $t0 - used to hold the input operator
        ## $t1 - used to hold the + operator
        ## $t2 - used to hold the - operator
        ## $t3 - used to hold the * operator
        ## $t4 - used to hold count array
	## $s2 - used to hold the third number.
	## $s3 - used to hold the fourth number.
	## $s4 - used to hold the digit number in count.
	
	.data
count_Array:
	.space 20    #declare 16 bytes of storage to hold array of 5 integers (num of digits)
count:
	.word 0

pow_result:
	.word 1    #basamak esitlemede sayiyi 10 ile carpip sonucu tutma
	
pow_counter:
	.word 0    # basamak esitlemedeki sondaki 0 sayisi
		
dot:	
	.asciiz "."
min:
	.asciiz "-"
val1:
	.asciiz "Enter Value1: "
val2:
	.asciiz "Enter Value2: "
opinput:
	.asciiz "Enter Operator: "
val3:
	.asciiz "Enter Value3: "
val4:
	.asciiz "Enter Value4:"
res:
	.asciiz "RESULT: "
		
op_buf:
	.space 3  #operator buffer

	.text
	.globl main

main:
	li $v0, 4 	#system call print_string
	la $a0, val1
	syscall

	## Get first number from user, put into $s0
	li $v0,5  		#load syscall read_int into $v0
	syscall
	add $a0, $zero, $v0  	#add the number read_into and 0 
	move $s0, $a0
	jal count_digit
	
	li $v0, 4 	#system call print_string
	la $a0, val2
	syscall
	
	## Get second number from user, put into $t1
	li $v0,5  #load syscall read_int into $v0
	syscall
	add $a0, $zero, $v0   #add the number read_into and 0
	move $s1, $a0
	jal count_digit
	
	li $v0, 4 	#system call print_string
	la $a0, opinput
	syscall
	
	## Get operator from user, put into $t2
	li $v0, 8 		 #tell sycall want to read operator
	la $a0, op_buf   
	li $a1,3
	syscall 		 #read in operator from user
	
	lb $t0, op_buf          # load the first byte of op
	li $t1, '+'             # load const for plus
        li $t2, '-'             # load const for minus
        li $t3, '*'             # load const for multiplying
        
        li $v0, 4 	#system call print_string
	la $a0,val3
	syscall
	  	
  	## Get third number from user, put into $t3
  	li $v0, 5
  	syscall 
  	add $a0, $zero, $v0
  	move $s2, $a0
  	jal count_digit
  	
  	li $v0, 4 	#system call print_string
	la $a0, val4
	syscall
  	
  	## Get fourth number from user, put into $t4
  	li $v0, 5
  	syscall
  	add $a0,$zero,$v0
  	move $s3, $a0
  	jal count_digit
  	
	beq $t0, $t1, plus      # adding
        beq $t0, $t2, minus     # subtracting
        #beq $t2, $t8, multi     # multiplying
        		
print:	li $v0, 4 	#system call print_string
	la $a0, res
	syscall

	li $v0, 1             # system call print_int (virgulden oncesi)
	add $a0, $t5, $zero
	syscall
	
	li $v0, 4 	#system call print_string
	la $a0, dot
	syscall
	
	li $v0, 1          #system call print_int (virgulden sonrasi)
	add $a0, $t6, $zero
	syscall

	li $v0, 10
	syscall
				
	.text
	.globl count_digit

count_digit:
	lw $s4, count
	move $s5, $a0
loop:	addi $s4, $s4, 1
	div $s5, $s5, 10  # bolum is in $t2
	bnez $s5, loop
	la $t4, count_Array    #load base address of array into register $t4
	lw $t8, ($t4)
	bnez $t8, arr1
	sw $s4, ($t4)        # first array element set to content of $t4
	jr $ra
	
arr1:
	lw $t8, 4($t4)
	bnez $t8, arr2
	sw $s4, 4($t4)       # second array element set to $s4
	jr $ra

arr2:
	lw $t8, 8($t4)
	bnez $t8, arr3
	sw $s4, 8($t4)       # third array element set to $s4
	jr $ra
	
arr3:
	lw $t8, 12($t4)
	bnez $t8,arr4
	sw $s4, 12($t4)	      # fourth array element set to $s4
	jr $ra
	
arr4:
	sw $s4, 16($t4)
	jr $ra
	
plus:	add $t5, $s0, $s2         # sum of first and third number
ytr:	lw $s6, 4($t4)            # 2. sayinin basamak sayisini tuttum $s6 da
	lw $s7, 12($t4)           # 4. sayinin basamak sayisini tuttum $s7 da
	sub $a2, $s6, $s7         # $a2 de basamak sayisi arasindaki fark var  secondNum- fourthNum
	sub $a3, $s7, $s6         # $a3 de basamak sayisi arasindaki fark fourthNum- secondNum
	move $a0, $s1 		  #fonksiyona $s1 gonderme 
	move $a1, $s3		  # fonksiyona $s3 gonderme
	bgt $a2, 0 , get_power	   # eger 2. sayi 4. sayidan buyukse
	bgt $a3, 0, get_power2     #eger 4. sayi 2.sayidan buyukse
result:	add $t6, $s1, $s3     	 	# sum of second and fourth number
	bltz $t6, label
	move $a0, $t6
	jal count_digit
	lw $t1, 16($t4)		# sonucun basamak degeri $t1 yazilir
	bgt $t1,$s6,portakal            # sonucun basamak sayisi sayilardan bir fazla ise
	j print
portakal: la $t7, pow_result 		# pow_resultun contenttini $t7 atama
	  lw $t3,($t7)
	  add $t3, $zero,10		# $t7 10 olur
	  la $t2, pow_counter
	  lw $t4, ($t2)
	  addi $t4, $t4, 1	  
	  sub $t1, $t1,1
son:	  mul $t3, $t3,10
	  addi $t4, $t4, 1
	  bne $t4, $t1, son
	  div $t6,$t3
	  mfhi $t0		# kalan, virgulden sonra
	  mflo $t1		# bolum, elde
	  add $t5,$t5,$t1
	  move $t6, $t0
	  j print
label:
	div $t6,$t6, 100
	mfhi $t6
	mul $t6,$t6,-1
	mul $t5,$t5,1
	mul $t5, $t5, 100
	sub $t6, $t5, $t6
	bltz $t6, prn
	move $t5, $zero	

	
	j print
prn:	mul $t6,$t6,-1	
	li $v0, 4 	#system call print_string
	la $a0, min
	syscall	
	move $t5, $zero
	j print
	  
		
get_power:
	bne $a2, 1, for   	 	# basamak farki 1'den fazla mi 
	la $t7, pow_result  		# pow_resultun contenttini $t7 atama
	lw $t3, ($t7)
	addi $t3, $zero, 10		# $t7 10 olur
	mult $a1, $t3			# 4.sayiyi 10 ile carpma
	mflo $s3			# sonucu $s3 yazma
	jal result
for:	la $t7, pow_result
	lw $t9, ($t7)
	add $t9, $zero, 10	       # $t7'i 10 olur --> pow-result
	la $t2, pow_counter
	lw $t1, ($t2)
for2:	addi $t1, $t1, 1
	mult $a1, $t9
	mflo $s3
	move $a1,$s3
	bne $t1,$a2, for2
	jal result

get_power2:
	bne $a3, 1, myfor   	 	# basamak farki 1'den fazla mi
	la $t7, pow_result  		# pow_resultun contenttini $t7 atama
	lw $t3, ($t7)
	addi $t3, $zero, 10		# $t7 10 olur
	mult $a0, $t3			# 2.sayiyi 10 ile carpma
	mflo $s1			# sonucu $s1 yazma	
	jal result
myfor:	la $t7, pow_result
	lw $t9, ($t7)
	add $t9, $zero, 10	       # $t7'i 10 olur --> pow-result
	la $t2, pow_counter
	lw $t1, ($t2)
myfor2:	addi $t1, $t1, 1
	mult $a0, $t9
	mflo $s1
	move $a0,$s1
	bne $t1,$a2, myfor2
	jal result

minus:  
	blt $s0, $s2, smll
	sub $t5,$s0,$s2       #subtraciton first-third number
	mul $s2, $s2, -1
	mul $s3,$s3,-1
	jal ytr
smll:
	move $t7,$s2
	move $s2,$s0
	move $s0, $t7   ## swap $s2=$s0
	move $t7, $s3
	move $s3, $s1
	move $s1,$t7  ## swap $3=$s1
	sub $t5,$s0,$s2       #subtraciton first-third number
	mul $s2, $s2, -1
	mul $s3,$s3,-1
	li $v0, 4 	#system call print_string
	la $a0, min
	syscall
	jal ytr	
	j print

	
