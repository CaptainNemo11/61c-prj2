.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
# 	d = matmul(m0, m1)
# Arguments:
# 	a0 (int*)  is the pointer to the start of m0 
#	a1 (int)   is the # of rows (height) of m0
#	a2 (int)   is the # of columns (width) of m0
#	a3 (int*)  is the pointer to the start of m1
# 	a4 (int)   is the # of rows (height) of m1
#	a5 (int)   is the # of columns (width) of m1
#	a6 (int*)  is the pointer to the the start of d
# Returns:
#	None (void), sets d = matmul(m0, m1)
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 72.
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 73.
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 74.
# =======================================================
matmul:

    # Error checks
    ble a1, zero, exit_72
    ble a2, zero, exit_72
    blt a4, zero, exit_73
    blt a5, zero, exit_73
    bne a2, a4, exit_74 

    # Prologue
    addi sp, sp, -32
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw s5, 20(sp)
    sw s6, 24(sp)
    sw ra, 28(sp)
    mv s0, a0
    mv s1, a1
    mv s2, a2
    mv s3, a3
    mv s4, a4
    mv s5, a5
    mv s6, a6

    mv t0, zero #i == 0
outer_loop_start:
    beq t0, s1, outer_loop_end
    mv t1, zero #j == 0
inner_loop_start:
    beq t1, s5, inner_loop_end
    mul t3, s2, t0
    slli t3, t3 2
    add t3, s0, t3
    slli t4, t1, 2 
    add t4, s3, t4
    
    mv a0, t3
    mv a1, t4
    mv a2, s2
    li a3, 1
    mv a4, s5

    #prologue
    addi sp, sp, -8
    sw t0, 0(sp)
    sw t1, 4(sp)
    jal dot
    #epilogue
    lw t0, 0(sp)
    lw t1, 4(sp)
    addi sp, sp, 8

    mul t3, t0, s5
    add t3, t3, t1
    slli t3, t3, 2
    add t3, t3, s6
    sw a0, 0(t3)
    
    addi t1, t1, 1
    j inner_loop_start
inner_loop_end:
    addi t0, t0, 1
    j outer_loop_start
outer_loop_end:

    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw s6, 24(sp)
    lw ra, 28(sp)
    addi sp, sp, 32

    ret

exit_72:
    addi a1, x0, 72
    j exit2
exit_73:
    addi a1, x0, 73
    j exit2
exit_74:
    addi a1, x0, 74
    j exit2