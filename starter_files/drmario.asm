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

##############################################################################
# Mutable Data
##############################################################################
player_row: .word 10 # between 0 and 63 inclusive
player_col: .word 64 # between 0 and 63 inclusive
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
    # Get the starting position
    lw $a0 player_row
    lw $a1 player_col
    jal get_pixel
    # Draw the player with rotation 1

    # first draw a block of color1
    lw $a0, player_color1        # $t1 = red
    move $a1, $v0       # $t0 = base address for display
    jal draw_pixel

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
draw_pixel:
    sw $a0, 0($a1)  
    jr $ra
    
get_pixel:
    # deal with rows first
    lw $t0 ADDR_DSPL
    sll $t1 $a1 2 # multiples the rows by 4 
    add $v0 $t1 $t0
    # deal with columns
    lw $t0 ADDR_DSPL
    lw $t1 DISP_WIDTH
    sll $t2 $a0 2 # multiples the columns by 4
    sll $t2 $t2 6 # multiples the columns by 64
    add $v0 $t2 $v0
    jr $ra
    
keyboard_input:
    # use t to store parameters (since syscall needs the a registers)
    move $t1 $a0

    li $v0, 1
    la $a0, 1
    syscall
    
    li $t2 1
    j game_loop


