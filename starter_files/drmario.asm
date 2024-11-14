################# CSC258 Assembly Final Project ###################
# This file contains our implementation of Dr Mario.
#
# Student 1: Name, Student Number
# Student 2: Name, Student Number (if applicable)
#
# We assert that the code submitted here is entirely our own 
# creation, and will indicate otherwise when it is not.
#
######################## Bitmap Display Configuration ########################
# - Unit width in pixels:       TODO
# - Unit height in pixels:      TODO
# - Display width in pixels:    TODO
# - Display height in pixels:   TODO
# - Base Address for Display:   0x10008000 ($gp)
##############################################################################

    .data
##############################################################################
# Immutable Data
##############################################################################
DISP_WIDTH:
    .word 64
DISP_HEIGHT:
    .word 64
# The address of the bitmap display. Don't forget to connect it!
ADDR_DSPL:
    .word 0x10008000
# The address of the keyboard. Don't forget to connect it!
ADDR_KBRD:
    .word 0xffff0000
BOTTLE_COlOR:
    .word 0xc0c0c0
##############################################################################
# Mutable Data
##############################################################################
player_row: .word 2 # between 0 and 63 inclusive
player_col: .word 8 # between 0 and 63 inclusive
player_rotation: .word 1 # 1 means color 1 on top color 2 on bottom, 2 means color 1 on left, color 2 on right, ... this is between 1 and 4 inclusive
player_color1: .word 0xFF0000
player_color2: .word 0x0000FF    
##############################################################################
# Code
##############################################################################
	.text
	.globl main

    # Run the game.
main:
    # Initialize the game
    # Paint the bottle
    addi $s0 $zero 2 # first bottle unit row
    addi $s1 $zero 6 # first bottle unit column
    addi $s3 $zero 1
    addi $s4 $zero 1
draw_bottle:
    jal draw_bottle_unit
    addi $s1 $s1 4    
    jal draw_bottle_unit
    # top line 1
    addi $s0 $zero 3
    addi $s1 $zero 2
    addi $t5 $zero 7
    bottle_top_line_1:
    beq $s1 $t5 bottle_top_line_1_done
    jal draw_bottle_unit
    addi $s1 $s1 1
    j bottle_top_line_1
    bottle_top_line_1_done:
    # top line 2
    addi $s1 $s1 3
    addi $t5 $zero 15
    bottle_top_line_2:
    beq $s1 $t5 bottle_top_line_2_done
    jal draw_bottle_unit
    addi $s1 $s1 1
    j bottle_top_line_2
    bottle_top_line_2_done:
    # left line 
    addi $s0 $zero 4
    addi $s1 $zero 2
    addi $t5 $zero 20
    bottle_left_line:
    beq $s0 $t5 bottle_left_line_done
    jal draw_bottle_unit
    addi $s0 $s0 1
    j bottle_left_line
    bottle_left_line_done:
    # right line 
    addi $s0 $zero 4
    addi $s1 $zero 14
    addi $t5 $zero 20
    bottle_right_line:
    beq $s0 $t5 bottle_right_line_done
    jal draw_bottle_unit
    addi $s0 $s0 1
    j bottle_right_line
    bottle_right_line_done:
    # bottom line
    addi $s0 $zero 19
    addi $s1 $zero 3
    addi $t5 $zero 15
    bottle_bottom_line:
    beq $s1 $t5 bottle_bottom_line_done
    jal draw_bottle_unit
    addi $s1 $s1 1
    j bottle_bottom_line
    bottle_bottom_line_done:
    
    # Draw the player
    jal draw_player
    

game_loop:
    # 1a. Check if key has been pressed
    # lw loads the value in the adress. $t contains the adress that contains the value. Label are the adress that contain the value
    lw $t0 ADDR_KBRD # loads the keyboard adress into $t0
    lw $t8 0($t0) # loads the actual keyboard input into $t8
    
    # move input stuff
    lw $a0 ADDR_KBRD
    
    
    # push values to stack
    addi $sp $sp -4
    sw $ra 0($sp)
    
    beq $t8 1 keyboard_input
    
    # 1b. Check which key has been pressed
    # 2a. Check for collisions
	# 2b. Update locations (capsules)
	# 3. Draw the screen
	# 4. Sleep

    # 5. Go back to Step 1
    j game_loop

######################### Stuff here won't be run directly since j game_loop causes prevents code reaching here #############
######################## Movement functions ########################
draw_player:
    # Prologue
    addi $sp $sp -4 #allocate stack space
    sw $ra 0($sp)
    
    # Get the starting position
    lw $a0 player_row
    lw $a1 player_col
    jal get_unit
    # Draw the player with rotation 1

    # first draw a block of color1
    lw $a0, player_color1        # $t1 = red
    move $a1, $v0       # $t0 = base address for display
    jal draw_unit
    
    # Get the unit one down.
    lw $t1 player_row
    addi $t0 $t1 1 # add 1 to the player_row
    move $a0 $t0
    lw $a1 player_col
    jal get_unit
    
    # draw second block
    lw $a0, player_color2       # $t1 = red
    move $a1, $v0       # $t0 = base address for display
    jal draw_unit
    
    #Epilogue
    lw $ra 0($sp) # pop $ra from stack;
    addi $sp $sp 4 # move stack pointer back down (to the new top of stack)
    jr $ra
    
    
    
draw_unit:
    # Prologue
    addi $sp $sp -4 #allocate stack space
    sw $ra 0($sp)
    
    sw $a0, 0($a1)  
    sw $a0, 4($a1)
    sw $a0, 8($a1)
    addi $a1 $a1 256
    sw $a0, 0($a1)  
    sw $a0, 4($a1)
    sw $a0, 8($a1)
    addi $a1 $a1 256
    sw $a0, 0($a1)  
    sw $a0, 4($a1)
    sw $a0, 8($a1)
    jr $ra
    
    #Epilogue
    lw $ra 0($sp) # pop $ra from stack;
    addi $sp $sp 4 # move stack pointer back down (to the new top of stack)
    jr $ra
    
get_unit:
    # Prologue
    addi $sp $sp -4 #allocate stack space
    sw $ra 0($sp)
    
    # deal with col first
    lw $t0 ADDR_DSPL
    addi $t1 $zero 3 
    mult $t1 $a1
    mflo $a1 
    sll $a1 $a1 2
    add $v0 $a1 $t0
    # deal with row
    lw $t1 DISP_WIDTH
    sll $t1 $t1 2
    get_pixel_loop:
        beq $a0 $zero get_pixel_end
        add $v0 $v0 $t1
        add $v0 $v0 $t1
        add $v0 $v0 $t1
        addi $a0 $a0 -1
        j get_pixel_loop
    get_pixel_end:
        jr $ra
        
    #Epilogue
    lw $ra 0($sp) # pop $ra from stack;
    addi $sp $sp 4 # move stack pointer back down (to the new top of stack)
    jr $ra

draw_bottle_unit:
    move $s5 $ra
    move $a0 $s0
    move $a1 $s1
    jal get_unit
    lw $a0 BOTTLE_COlOR
    move $a1 $v0
    jal draw_unit
    jr $s5
    
keyboard_input:
    # use t to store parameters (since syscall needs the a registers)
    move $t1 $a0

    li $v0, 1
    la $a0, 1
    syscall
    
    li $t2 1
    j game_loop


