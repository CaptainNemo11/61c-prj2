.globl classify

.text
classify:
    # =====================================
    # COMMAND LINE ARGUMENTS
    # =====================================
    # Args:
    #   a0 (int)    argc
    #   a1 (char**) argv
    #   a2 (int)    print_classification, if this is zero, 
    #               you should print the classification. Otherwise,
    #               this function should not print ANYTHING.
    # Returns:
    #   a0 (int)    Classification
    # Exceptions:
    # - If there are an incorrect number of command line args,
    #   this function terminates the program with exit code 89.
    # - If malloc fails, this function terminats the program with exit code 88.
    #
    # Usage:
    #   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>
    
    li t0, 5
    bne a0, t0, exit_89

    #prologue
    addi sp, sp, -48
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)
    sw s5, 24(sp)
    sw s6, 28(sp)
    sw s7, 32(sp)
    sw s8, 36(sp)
    sw s9, 40(sp)
    sw s10, 44(sp)    

    mv s1, a1
    mv s2, a2
    



	# =====================================
    # LOAD MATRICES
    # =====================================

    # Load pretrained m0

    li a0, 8
    jal malloc
    beq a0, x0, exit_88
    mv s3, a0   #s3->m0 row column
    #read m1
    lw a0, 4(s1)
    addi a1, s3, 0
    addi a2, s3, 4
    jal read_matrix
    mv s4, a0   # s4-> m0 

    # Load pretrained m1

    li a0, 8
    jal malloc
    beq a0, x0, exit_88
    mv s5, a0   #s5-> m1 row, column
    #read m1
    lw a0, 8(s1)
    addi a1, s5, 0
    addi a2, s5, 4
    jal read_matrix
    mv s6, a0   #s6-> m1

    # Load input matrix

    li a0, 8
    jal malloc
    beq a0, x0, exit_88
    mv s7, a0   #s7-> input row, column
    #read input
    lw a0, 12(s1)
    addi a1, s7, 0 
    addi a2, s7, 4
    jal read_matrix
    mv s8, a0   #s8->input

    # =====================================
    # RUN LAYERS
    # =====================================
    # 1. LINEAR LAYER:    m0 * input
    # 2. NONLINEAR LAYER: ReLU(m0 * input)
    # 3. LINEAR LAYER:    m1 * ReLU(m0 * input)

    lw t0, 0(s3)
    lw t1, 4(s7)
    mul a0, t0, t1
    slli a0, a0, 2
    jal malloc
    beq a0, x0, exit_88
    mv s9, a0  #s9 -> hidden_layer
    mv a0, s4
    mv a3, s8
    lw a1, 0(s3)
    lw a2, 4(s3)
    lw a4, 0(s7)
    lw a5, 4(s7)
    mv a6, s9
    jal matmul

    lw t0, 0(s3)
    lw t1, 4(s7)
    mul a1, t0, t1
    mv a0, s9
    jal relu

    #lw t0, 0(s5)
    #lw t1, 4(s7)
    #mul a0, t0, t1
    #slli a0, a0, 2
    li a0, 80
    jal malloc
    beq a0, x0, exit_88
    mv s10, a0  #s10 ->scores
    mv a0, s6
    mv a3, s9
    lw a1, 0(s5)
    lw a2, 4(s5)
    lw a4, 0(s3)
    lw a5, 4(s7)
    mv a6, s10
    jal matmul
    

    # =====================================
    # WRITE OUTPUT
    # =====================================
    # Write output matrix
    mv a1, s10
    lw a0, 16(s1)
    #m1 row input column
    lw a2, 0(s5)
    lw s3, 4(s7)
    jal write_matrix



    # =====================================
    # CALCULATE CLASSIFICATION/LABEL
    # =====================================
    # Call argmax
    mv a0 ,s10
    #lw t0, 0(s5)
    #lw t1, 4(s7)
    #mul a1, t0, t1
    li a1, 10
    jal argmax
    mv s0, a0   


    # Print classification
    beq s2, x0, exit 
    mv a1, s0
    jal print_int


    # Print newline afterwards for clarity
    li a1,'\n'
    jal print_char


exit:
    mv a0, s3
    jal free
    mv a0, s4
    jal free
    mv a0, s5
    jal free
    mv a0, s6
    jal free
    mv a0, s7
    jal free
    mv a0, s8
    jal free
    mv a0, s9
    jal free     
    mv a0, s10
    jal free

    mv a0, s0

    #epilogue
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    lw s5, 24(sp)
    lw s6, 28(sp)
    lw s7, 32(sp)
    lw s8, 36(sp)
    lw s9, 40(sp)
    lw s10, 44(sp)
    addi sp, sp, 48

    ret
exit_88:
    li a1, 88
    j exit2
exit_89:
    li a1, 89
    j exit2
