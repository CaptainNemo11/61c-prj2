.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int vectors
# Arguments:
#   a0 (int*) is the pointer to the start of v0
#   a1 (int*) is the pointer to the start of v1
#   a2 (int)  is the length of the vectors
#   a3 (int)  is the stride of v0
#   a4 (int)  is the stride of v1
# Returns:
#   a0 (int)  is the dot product of v0 and v1
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 75.
# - If the stride of either vector is less than 1,
#   this function terminates the program with error code 76.
# =======================================================
dot:
    li t0 1
    blt a2 t0 exit_75
    blt a3 t0 exit_76
    blt a4 t0 exit_76

    # Prologue
    addi sp, sp, -12
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)

#    li s0, 0
#    li t0, 0
#    slli a3, a3, 2
#    slli a4, a4, 2
#loop_start:
#
#    beq t0, a2, loop_end
#    mul t1, t0, a3
#    slli t1, t1, 2
#    mul t2, t0, a4
#    slli t2, t2, 2
#    add t1, t1, a0
#    add t2, t2, a1
#    lw s1, 0(t1)
#    lw s2, 0(t2)
#    mul t3, s1, s2
#    add s0, s0, t3
#    addi t0, t0, 1
#    j loop_start
    li t0, 4
    li t1, 4
    mul t0, t0, a3 # array0's stride
    mul t1, t1, a4 # array1's stride
    li t2, 0 # i = 0
    li s0, 0 # sum = 0
loop_start:
	lw s1 0(a0)
    lw s2, 0(a1)
    mul t3, s1, s2
    add s0, s0, t3
	addi t2, t2, 1
    beq t2, a2, loop_end
    add a0, a0, t0
    add a1, a1, t1
    j loop_start
loop_end:
    mv a0, s0

    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    addi sp, sp, 12
    
    ret
exit_75:
    addi a1, x0, 75
    j exit2
exit_76:
    addi a1, x0, 76
    j exit2
