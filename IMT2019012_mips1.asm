# Made by Archit Sangal
# email: archit.sangal@iiitb.org

# Base code written by -by Harshith(IMT2017516)
# email: Harshith.Reddy@iiitb.org

#run in linux terminal by java -jar Mars4_5.jar nc filename.asm(take inputs from console)

#system calls by MARS simulator:
#http://courses.missouristate.edu/kenvollmar/mars/help/syscallhelp.html
.data
	next_line: .asciiz "\n"	
.text
#input: N= how many numbers to sort should be entered from terminal. 
#It is stored in $t1	
jal input_int 
move $t1,$t4			

#input: X=The Starting address of input numbers (each 32bits) should be entered from
# terminal in decimal format. It is stored in $t2
jal input_int
move $t2,$t4

#input:Y= The Starting address of output numbers(each 32bits) should be entered
# from terminal in decimal. It is stored in $t3
jal input_int
move $t3,$t4 

#input: The numbers to be sorted are now entered from terminal.
# They are stored in memory array whose starting address is given by $t2
move $t8,$t2
move $s7,$zero	#i = 0
loop1:  beq $s7,$t1,loop1end
	jal input_int
	sw $t4,0($t2)
	addi $t2,$t2,4
      	addi $s7,$s7,1
        j loop1      
loop1end: move $t2,$t8       
#############################################################
#Do not change any code above this line
#Occupied registers $t1,$t2,$t3. Don't use them in your sort function.
#############################################################
#function: should be written by students(sorting function)
# code begins-----------------------------------------------------------------------------------------------
# Written by Archit Sangal
# IMT2019012

# At $t3, Y is stored.
# At $t2, X is stored.
move $t9,$t3
move $t8,$t2

# The loop below is to copy all the values from location X to Y
# (By location X we mean that the memory starts from location X)

# This is a loop -------------------------
# Here, $s7 is like loop variable and at the starting of the loop we assign it to be zero
move $s7,$zero	#i = 0

# $t1 = N
# if($s7==$t1) then goto loop2end ---> i.e. loop ends 
loop2:  beq $s7,$t1,loop2end

	# load word $t7 = Memory[$t8+0] $t8 is a moving pointer in array 1 at location X
	lw $t7,0($t8)

	# save word Memory[$t9+0] = $t7 $t9 is a moving pointer in array 2 at location Y
	sw $t7,0($t9)
	
	# updating the value of $t9 and $t8 to next value in array
	addi $t9,$t9,4
	addi $t8,$t8,4

	# updating loop variable
	addi $s7,$s7,1
	
	# loop the statements again
	j loop2    
loop2end: 
# below are the statements which gets executed when the above loop ends

# Sorting Algorithm begins ---------------------------------------------------------------------------------------------#

# outer loop --> $s7 can be comsidered as loop variable.
move $s7,$zero	#i = 0

# $t9 is the upper end of the loop and upper end is N-1
move $t9,$t1
addi $t9,$t9,-1

# subi $t9,$t9,1 --> subi was not mentioned in the pdf given to us
# but MARS was suggesting it so I didn't use it but addi may not work for
# bigger inputs.

# $t6 has 1, this is used for checking the condition inside inner loop
move $t6,$zero
addi $t6,$t6,1

loop3:  beq $s7,$t9,loop3end
	
	# inner loop begins
	
	# $s0 stores zero
	move $s0,$zero
	
	# inner loop variable is $s6
	move $s6,$zero	#j = 0

	# $t8 is the upper bound of inner variable i.e. N-1-i here i = $s7
	move $t8,$t1
	addi $t8,$t8,-1
	sub $t8,$t8,$s7

	loop4:  beq $s6,$t8,loop4end
	
		# $t7 = $t3 t7 is Y
		move $t7,$t3
		# $t7 is moved to correct location in array 2 initially $s0 is $zero
		add $t7,$t7,$s0
		
		# $t7 is a moving pointer in array 2
		# $t4 is A[j] and $t5 is A[j+1] 
		lw $t4,0($t7)
		lw $t5,4($t7)

		# $t0 is 1 if value in $t5 > $t4
		slt $t0,$t5,$t4

		# $t0 == $t6(1) the branch to falseCondition
		bne $t0,$t6,falseCondition

			# swaping the values
			sw $t5,0($t7)
			sw $t4,4($t7)

        	falseCondition:
    
			# if no swapping is required then update the values for next iteration
	    	addi $s6,$s6,1
			addi $s0,$s0,4
        	j loop4
	loop4end:
	# inner loop ends -----------------------------------------------------------------------------------
	
	# updating the values before next iteration of outer loop
	addi $s7,$s7,1
	j loop3

loop3end:

# java code
# void bubbleSort(int arr[]) 
#    { 
#        int n = arr.length; 
#        for (int i = 0; i < n-1; i++) 
#            for (int j = 0; j < n-i-1; j++) 
#                if (arr[j] > arr[j+1]) 
#                { 
#                    // swap arr[j+1] and arr[j] 
#                    int temp = arr[j]; 
#                    arr[j] = arr[j+1]; 
#                    arr[j+1] = temp; 
#                } 
#    } 

#endfunction
#############################################################
#You need not change any code below this line

#print sorted numbers
move $s7,$zero	#i = 0
loop: beq $s7,$t1,end
      lw $t4,0($t3)
      jal print_int
      jal print_line
      addi $t3,$t3,4
      addi $s7,$s7,1
      j loop 
#end
end:  li $v0,10
      syscall
#input from command line(takes input and stores it in $t6)
input_int: li $v0,5
	   syscall
	   move $t4,$v0
	   jr $ra
#print integer(prints the value of $t6 )
print_int: li $v0,1		#1 implie
	   move $a0,$t4
	   syscall
	   jr $ra
#print nextline
print_line:li $v0,4
	   la $a0,next_line
	   syscall
	   jr $ra

