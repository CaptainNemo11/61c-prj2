.globl argmax

.text
# =================================================================
# FUNCTION: Given a int vector, return the index of the largest
#	element. If there are multiple, return the one
#	with the smallest index.
# Arguments:
# 	a0 (int*) is the pointer to the start of the vector
#	a1 (int)  is the # of elements in the vector
# Returns:
#	a0 (int)  is the first index of the largest element
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 77.
# =================================================================
argmax:

    # Prologue
    li t0, 1
    blt a1, t0, exit    # #<1 : exit
    li t0, 0            #index in $t0 
    lw t3, 0(a0)        #initialize max in  $t3
    mv t4, a0
    li a0, 0            #max index in $a0
loop_start:
    beq t0, a1, loop_end    #loop_end
    lw t2, 0(t4)        #word in $t2
    ble t2, t3, loop_continue
    mv t3, t2
    mv a0, t0
loop_continue:
    addi t0, t0, 1
    addi t4, t4, 4     #address of i in $t4
    j loop_start

loop_end:
    # Epilogue
    ret
exit:
    addi a1, x0, 77
    j exit2