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
PLAYER_FAST_FALL_DIVIDER: .word 30
PLAYER_NORMAL_FALL_DIVIDER: .word 4
PLAYER_TOTAL_FALL_TIME: .word 300

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
EMPTY_COLOR:
    .word 0x000000
#Keyboard#
Q:
    .word 0x71
D:
    .word 0x64
W:
    .word 0x77
A:
    .word 0x61
S:
    .word 0x73
next_capsule_row: .word 4 
next_capsule_col: .word 17 
##############################################################################
# Mutable Data
##############################################################################
player_row: .word 3 # between 0 and 63 inclusive
player_col: .word 8 # between 0 and 63 inclusive
player_rotation: .word 1 # 1 means color 2 on top color 1 on bottom, 2 means color 1 on left, color 2 on right, ... this is between 1 and 4 inclusive
player_color1: .word 0x0000FF
player_color2: .word 0x0000FF   
next_player_color1: .word 0x0000FF
next_player_color2: .word 0x0000FF  
capsule_orientation_array: .space 660  # array of orientation of capsule. 11 col x 15 row graid left top corner coordinate ： col 3 row 4
player_is_fast_falling: .word 0

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
    
    
    
    # clear capsule_orientation_array
    la $t3, capsule_orientation_array    # $t3 holds address of capsule_orientation_array
    add $t0, $zero $zero                 # t0 holds 4*i, initially 0
    addi $t1, $zero, 660                # $t1 holds capsule_orientation_array's size*4
    clear_capsule_orientation_array_loop:
    bge $t0 $t1 clear_capsule_orientation_array_end
    add $t4, $t3 $t0                     # $t4 holds addr(capsule_orientation_array[i])
    sw $zero 0($t4)                      # capsule_orientation_array[i] = 0
    addi $t0,$t0 4                       # update offset in $t0
    j clear_capsule_orientation_array_loop
    clear_capsule_orientation_array_end:
    
    
    # spawn 4 virus 
    
    addi $sp $sp -4 #allocate stack space
    sw $s6 0($sp)
    addi $sp $sp -4 #allocate stack space
    sw $s7 0($sp)
    
    addi $s6 $zero 4 # $s6 hold 4 (max i )
    addi $s7 $zero 0 # $s7 hold i (start from 0)
    virus_loop:
    beq $s6 $s7 spwan_virus_done
    # random col
    li $v0, 42
    li $a0, 0
    li $a1, 11
    syscall
    move $t3 $a0    
    addi $t3 $t3 3  # $t3 hold random col
    
    # random row
    li $v0, 42
    li $a0, 0
    li $a1, 8
    syscall
    move $t4 $a0    
    addi $t4 $t4 11  # $t4 hold random row
    
    move $a0 $t4
    move $a1 $t3
    jal get_unit
    lw $t5 0($v0)
    addi $t6 $zero 0x000000
    bne $t5 $t6 virus_loop  # check if its already painted if yes get another random location 
    move $t8 $v0            
    
    li $v0, 42
    li $a0, 0
    li $a1, 3
    syscall         
    sll $a0 $a0 3       # $a0 0 8 16
    addi $t9 $zero 0x0000ff
    sllv $t9 $t9 $a0   # $t9 0xff0000 0x00ff00 0x0000ff  yello 0xffff00
    addi $t0 $zero 0x00ff00
    bne $t9 $t0 handle_yellow_virus_color_1
    addi $t9 $t9 0xff0000
    handle_yellow_virus_color_1:
    move $a0 $t9
    move $a1 $t8
    jal draw_unit
    
    addi $s7 $s7 1
    j virus_loop
    spwan_virus_done:
    lw $s7 0($sp) 
    addi $sp $sp 4 # move stack pointer back down (to the new top of stack)
    lw $s6 0($sp) 
    addi $sp $sp 4 # move stack pointer back down (to the new top of stack)
    
    
    
    
    # randomize player color 1 and 2 
    li $v0, 42
    li $a0, 0
    li $a1, 3
    syscall         
    sll $a0 $a0 3       # now $a0 is a random number of 0, 2, 4 
    addi $t1 $zero 0x0000ff
    sllv $t1 $t1 $a0   
    addi $t0 $zero 0x00ff00
    bne $t1 $t0 handle_yellow_player_color_1
    addi $t1 $t1 0xff0000
    handle_yellow_player_color_1:
    sw $t1 player_color1
    li $v0, 42
    li $a0, 0
    li $a1, 3
    syscall         
    sll $a0 $a0 3      # now $a0 is a random number of 0, 2, 4 
    addi $t1 $zero 0x0000ff
    sllv $t1 $t1 $a0   
    addi $t0 $zero 0x00ff00
    bne $t1 $t0 handle_yellow_player_color_2
    addi $t1 $t1 0xff0000
    handle_yellow_player_color_2:
    sw $t1 player_color2
    
    
    # randomize next player color 1 and 2 
    jal randomize_next_capsule
    
    
    #Draw the next capsule section 
    jal draw_next_capsule
    
    # Draw the player
    jal draw_player
    
    # initialize $s1
    lw $s1 PLAYER_TOTAL_FALL_TIME
    
 game_loop:   

	li 		$v0, 32
	li 		$a0, 1
	syscall
	
    # remove the previous frame
    jal remove_player
        
    # tells us through v0 if key is pressed, and v1 is the key pressed assuming v0 is 1.
    jal key_pressed
    #################### HANDLES KEY PRESSED ###############################
    bne $v0 1 ELSE # if equals 1 (the key is pressed)
        move $s0 $v1 # $s0 should not change here since it contains the actual key.
        
   # if q preseed 
        lw $t0 Q
        bne $s0 $t0 Not_Q
        jal draw_player
        li $v0, 10 # terminate the program gracefully syscall
        syscall    
    Not_Q:
        lw $t0 D
        bne $s0 $t0 NOT_D
        jal move_right_position
        
        # Here we check collision
        # save the expected position
        move $s2 $v0
        move $s3 $v1
        # here we check if $v0 and $v1 are valid for collision
        move $a0 $v0
        move $a1 $v1
        lw $a2 player_rotation
        jal can_move_here_with_rotation_i
        beq $v0 0 END
        
        
        sw $s2 player_row
        sw $s3 player_col
        j END
    NOT_D:
            
        # if w pressed
        lw $t0 W
        bne $s0 $t0 NOT_W
        jal rotate_position

        # here check if this rotation ($v0) is valid for collision
        # save the expected rotation
        move $s4 $v0
        
        move $a2 $s4 # load the rotation argument with expected rotation
        lw $a0 player_row
        lw $a1 player_col
        jal can_move_here_with_rotation_i
        beq $v0 0 END
        
        sw $s4 player_rotation
        J END
    NOT_W:
        # if a pressed
        lw $t0 A
        bne $s0 $t0 NOT_A
        jal move_left_position
        
        # Here we check collision
        # save the expected position
        move $s2 $v0
        move $s3 $v1
        # here we check if $v0 and $v1 are valid for collision
        move $a0 $v0
        move $a1 $v1
        lw $a2 player_rotation
        jal can_move_here_with_rotation_i
        beq $v0 0 END
        
        
        sw $s2 player_row
        sw $s3 player_col
        j END
        
    NOT_A:
        # if s presseed
        lw $t0 S
        bne $s0 $t0 END
        li $t0 1 # set fast_fall to true
        sw $t0 player_is_fast_falling
        j END
ELSE:
#################### HANDLES KEY NOT PRESSED ###############################
    
END:
    # if $s1 is greater than 0, don't move down
    slt $t0 $zero $s1 # $t0 is 1 if 0 < $s1, 0 otherwise
    beq $t0 1 DO_NOT_MOVE_DOWN 
        # here we want to move down
        jal move_down_position 
        
        # Here we check for collision
        # save the expected position
        move $s2 $v0
        move $s3 $v1
        # check if $v0 and $v1 are valid for collision
        move $a0 $v0
        move $a1 $v1
        lw $a2 player_rotation
        jal can_move_here_with_rotation_i
        beq $v0 0 HIT_BOTTOM
        
        sw $s2 player_row
        sw $s3 player_col
        # reset $s1
        lw $s1 PLAYER_TOTAL_FALL_TIME
DO_NOT_MOVE_DOWN:
    # if fast falling, then load the fast fall multiplyer, else load the normal multiplier
    lw $t1 player_is_fast_falling
    bne $t1 1 PLAYER_NOT_FAST_FALLING
    # here player is fast falling
    lw $t0 PLAYER_FAST_FALL_DIVIDER
    sub $t0 $zero $t0 # make it negative
    add $s1 $s1 $t0
PLAYER_NOT_FAST_FALLING:
    lw $t0 PLAYER_NORMAL_FALL_DIVIDER
    sub $t0 $zero $t0 # make it negative
    add $s1 $s1 $t0
    
    jal draw_player
    j game_loop
HIT_BOTTOM:
# here we check for four (or more) in a rows, remove four in a rows, and then make all floating blocks fall, then add a new player capsule.

    jal draw_player
    sw $zero  player_is_fast_falling
    # if bottle neck has color then game end 
    li $a0 3
    li $a1 7
    jal get_unit
    lw $t0 0($v0)
    bne $t0 $zero die
    li $a0 3
    li $a1 8
    jal get_unit
    lw $t0 0($v0)
    bne $t0 $zero die
    li $a0 3
    li $a1 9
    jal get_unit
    lw $t0 0($v0)
    bne $t0 $zero die
    j still_alive
    die:
    li $v0, 10
    syscall
    
    
    still_alive:
    # reset the player location 
    addi $t0 $zero 3
    sw $t0 player_row
    addi $t0 $zero 8
    sw $t0 player_col
    addi $t0 $zero 1 
    sw $t0 player_rotation
    # give next color to player color 
    lw $a0 next_capsule_row
    lw $a1 next_capsule_col
    jal get_unit
    lw $t0 0($v0)
    sw $t0 player_color1
    
    lw $a0 next_capsule_row
    addi $a0 $a0 1
    lw $a1 next_capsule_col
    jal get_unit
    lw $t0 0($v0)
    sw $t0 player_color2
    
    # draw new player capsule 
    jal draw_player
    # randomnize next color and draw
    jal randomize_next_capsule
    jal draw_next_capsule
    j game_loop
    
######################### Stuff here won't be run directly since j game_loop causes prevents code reaching here #############


######################## Collision Functions #########################
        
can_move_here_with_rotation_i:
    # Prologue
    addi $sp $sp -4 #allocate stack space
    sw $ra 0($sp)
    addi $sp $sp -4 #allocate stack space
    sw $s0 0($sp)
    addi $sp $sp -4 #allocate stack space
    sw $s1 0($sp)
    addi $sp $sp -4 #allocate stack space
    sw $s2 0($sp)
    
    # s0 and s1 store the row and column.
    move $s0 $a0
    move $s1 $a1
    jal block_empty
    beq $v0 0 can_not_move_here_with_rotation_i_END
    # we can move to the first block, now check second block based on rotation
    move $t0 $a2
    beq $t0 1 HERE_ROTATION_IS_1
    beq $t0 2 HERE_ROTATION_IS_2
    beq $t0 3 HERE_ROTATION_IS_3
    beq $t0 4 HERE_ROTATION_IS_4
    # These functions get the second block location based on rotation
    HERE_ROTATION_IS_1:
        addi $s0 $s0 -1
        j TEST_SECOND_BLOCK_IS_EMPTY
    HERE_ROTATION_IS_2:
        addi $s1 $s1 1
        j TEST_SECOND_BLOCK_IS_EMPTY    
    HERE_ROTATION_IS_3:
        addi $s0 $s0 1
        j TEST_SECOND_BLOCK_IS_EMPTY
    HERE_ROTATION_IS_4:
        addi $s1 $s1 -1
        j TEST_SECOND_BLOCK_IS_EMPTY
    
    TEST_SECOND_BLOCK_IS_EMPTY:
    move $a0 $s0
    move $a1 $s1
    jal block_empty
    beq $v0 0 can_not_move_here_with_rotation_i_END
    
    # so we can move here
    li $v0 1
    #Epilogue
    lw $s2 0($sp) # pop $s1 from stack;
    addi $sp $sp 4 # move stack pointer back down (to the new top of stack)
    lw $s1 0($sp) # pop $s1 from stack;
    addi $sp $sp 4 # move stack pointer back down (to the new top of stack)
    lw $s0 0($sp) # pop $s0 from stack;
    addi $sp $sp 4 # move stack pointer back down (to the new top of stack)
    lw $ra 0($sp) # pop $ra from stack;
    addi $sp $sp 4 # move stack pointer back down (to the new top of stack)
    jr $ra
    
    can_not_move_here_with_rotation_i_END:
        li $v0 0
        #Epilogue
        lw $s2 0($sp) # pop $s1 from stack;
        addi $sp $sp 4 # move stack pointer back down (to the new top of stack)
        lw $s1 0($sp) # pop $s1 from stack;
        addi $sp $sp 4 # move stack pointer back down (to the new top of stack)
        lw $s0 0($sp) # pop $s0 from stack;
        addi $sp $sp 4 # move stack pointer back down (to the new top of stack)
        lw $ra 0($sp) # pop $ra from stack;
        addi $sp $sp 4 # move stack pointer back down (to the new top of stack)
        jr $ra
    
block_empty:
    # Notice that we only need to check the top left pixel since everything is in blocks
    
    # Prologue
    addi $sp $sp -4 #allocate stack space
    sw $ra 0($sp)
    
    # $a0 and $a1 are already correctly loaded
    jal get_unit
    
    lw $t0 EMPTY_COLOR
    lw $t1 0($v0) # t1 contains the color for the top left pixel in question
    beq $t1 $t0 BLOCK_IS_EMPTY
    # block is not empty
        li $v0 0
        #Epilogue
        lw $ra 0($sp) # pop $ra from stack;
        addi $sp $sp 4 # move stack pointer back down (to the new top of stack)
        jr $ra
    BLOCK_IS_EMPTY:
        li $v0 1
        #Epilogue
        lw $ra 0($sp) # pop $ra from stack;
        addi $sp $sp 4 # move stack pointer back down (to the new top of stack)
        jr $ra
        
######################## I/O Functions #########################
rotate_position:
    # Prologue
    addi $sp $sp -4 #allocate stack space
    sw $ra 0($sp)
    
    lw $t0 player_rotation # we must move t0 to the next rotation state
    
    bne $t0 4 ROTATION_NOT_4
    # rotation is 4
    li $t0 1
    j ROTATE_END
    ROTATION_NOT_4:
    addi $t0 $t0 1
    ROTATE_END:
    # t0 contains new rotation
    move $v0 $t0
    
    #Epilogue
    lw $ra 0($sp) # pop $ra from stack;
    addi $sp $sp 4 # move stack pointer back down (to the new top of stack)
    jr $ra
    
move_down_position:
    # Prologue
    addi $sp $sp -4 #allocate stack space
    sw $ra 0($sp)
    
    lw $t1 player_col
    
    lw $t0 player_row
    addi $t0 $t0 1
    
    move $v0 $t0
    move $v1 $t1
    
    #Epilogue
    lw $ra 0($sp) # pop $ra from stack;
    addi $sp $sp 4 # move stack pointer back down (to the new top of stack)
    jr $ra
    
move_right_position:
    # Prologue
    addi $sp $sp -4 #allocate stack space
    sw $ra 0($sp)
    
    lw $t1 player_col
    addi $t1 $t1 1
    lw $t0 player_row
    move $v0 $t0
    move $v1 $t1
    
    #Epilogue
    lw $ra 0($sp) # pop $ra from stack;
    addi $sp $sp 4 # move stack pointer back down (to the new top of stack)
    jr $ra
    
move_left_position:
    # Prologue
    addi $sp $sp -4 #allocate stack space
    sw $ra 0($sp)
    
    lw $t1 player_col
    addi $t1 $t1 -1
    lw $t0 player_row
    move $v0 $t0
    move $v1 $t1
    
    #Epilogue
    lw $ra 0($sp) # pop $ra from stack;
    addi $sp $sp 4 # move stack pointer back down (to the new top of stack)
    jr $ra
    
key_pressed:
    # Prologue
    addi $sp $sp -4 # allocate stack space
    sw $ra 0($sp)


    # 1a. Check if key has been pressed
    # lw loads the value in the adress. $t contains the adress that contains the value. Label are the adress that contain the value
    lw $t0 ADDR_KBRD # loads the keyboard adress into $t0
    
    lw $t8 0($t0) # loads the actual keyboard input into $t8
    beqz $t8 no_key_pressed
    li $v0 1
    
    # load the actual key press into $v1
    lw $t0, ADDR_KBRD               
    lw $t8, 0($t0)       
    lw $v1, 4($t0) 
    #Epilogue
    lw $ra 0($sp) # pop $ra from stack;
    addi $sp $sp 4 # move stack pointer back down (to the new top of stack)
    jr $ra
    
    no_key_pressed:
        li $v0 0
        #Epilogue
        lw $ra 0($sp) # pop $ra from stack;
        addi $sp $sp 4 # move stack pointer back down (to the new top of stack)
        jr $ra

keyboard_input:
    # use t to store parameters (since syscall needs the a registers)
    move $t1 $a0

    li $v0, 1
    la $a0, 1
    syscall
    
    li $t2 1
    j game_loop
######################## Draw Functions ########################
draw_player:
#   TODO check rotation and draw player based on that
    # Prologue
    addi $sp $sp -4 #allocate stack space
    sw $ra 0($sp)
    
    # Get rotation and store in $t3
    lw $t3 player_rotation
        #IF ROTATION IS 1
        bne $t3 1 DRAW_PLAYER_ROTATION_NOT_1
        jal draw_player_with_rotation_1
        j DRAW_PLAYER_END
    DRAW_PLAYER_ROTATION_NOT_1:
        #IF ROTATION IS 2
        bne $t3 2 DRAW_PLAYER_ROTATION_NOT_2
        jal draw_player_with_rotation_2
        j DRAW_PLAYER_END
    DRAW_PLAYER_ROTATION_NOT_2:
        #IF ROTATION IS 3
        bne $t3 3 DRAW_PLAYER_ROTATION_NOT_3
        jal draw_player_with_rotation_3
        j DRAW_PLAYER_END
    DRAW_PLAYER_ROTATION_NOT_3:
        #IF ROTATION IS 4
        jal draw_player_with_rotation_4
        j DRAW_PLAYER_END
    DRAW_PLAYER_END:
        #Epilogue
        lw $ra 0($sp) # pop $ra from stack;
        addi $sp $sp 4 # move stack pointer back down (to the new top of stack)
        jr $ra

# a helper for draw_player
draw_player_with_rotation_1:
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
    
    # Get the unit one up.
    lw $t1 player_row
    addi $t0 $t1 -1 # add 1 to the player_row
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
    
draw_player_with_rotation_2:
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
    
    
    lw $t0 player_row
    move $a0 $t0
    
    lw $t1 player_col
    addi $t1 $t1 1
    move $a1 $t1
    jal get_unit
    
    # draw second block
    lw $a0, player_color2       # $t1 = red
    move $a1, $v0       # $t0 = base address for display
    jal draw_unit
    
    #Epilogue
    lw $ra 0($sp) # pop $ra from stack;
    addi $sp $sp 4 # move stack pointer back down (to the new top of stack)
    jr $ra
    
   draw_player_with_rotation_3:
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
    
    # now deal with second block
    lw $t0 player_row
    addi $t0 $t0 1
    move $a0 $t0
    
    lw $t1 player_col
    move $a1 $t1
    jal get_unit
    
    # draw second block
    lw $a0, player_color2       # $t1 = red
    move $a1, $v0       # $t0 = base address for display
    jal draw_unit
    
    #Epilogue
    lw $ra 0($sp) # pop $ra from stack;
    addi $sp $sp 4 # move stack pointer back down (to the new top of stack)
    jr $ra
    
   draw_player_with_rotation_4:
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
    
    # now deal with second block
    lw $t0 player_row
    move $a0 $t0
    
    lw $t1 player_col
    addi $t1 $t1 -1
    move $a1 $t1
    jal get_unit
    
    # draw second block
    lw $a0, player_color2       # $t1 = red
    move $a1, $v0       # $t0 = base address for display
    jal draw_unit
    
    #Epilogue
    lw $ra 0($sp) # pop $ra from stack;
    addi $sp $sp 4 # move stack pointer back down (to the new top of stack)
    jr $ra
     
remove_player:
    # Prologue
    addi $sp $sp -4 #allocate stack space
    sw $ra 0($sp)
    
    # Get rotation and store in $t3
    lw $t3 player_rotation
        #IF ROTATION IS 1
        bne $t3 1 REMOVE_PLAYER_ROTATION_NOT_1
        jal remove_player_with_rotation_1
        j REMOVE_PLAYER_END
    REMOVE_PLAYER_ROTATION_NOT_1:
        #if rotation is 2
        bne $t3 2 REMOVE_PLAYER_ROTATION_NOT_2
        jal remove_player_with_rotation_2
        j REMOVE_PLAYER_END
    REMOVE_PLAYER_ROTATION_NOT_2:
        #IF ROTATION IS 3
        bne $t3 3 REMOVE_PLAYER_ROTATION_NOT_3
        jal remove_player_with_rotation_3
        j REMOVE_PLAYER_END
    REMOVE_PLAYER_ROTATION_NOT_3:
        #IF ROTATION IS 4
        jal remove_player_with_rotation_4
        j REMOVE_PLAYER_END
    REMOVE_PLAYER_END:
    #Epilogue
    lw $ra 0($sp) # pop $ra from stack;
    addi $sp $sp 4 # move stack pointer back down (to the new top of stack)
    jr $ra
    
remove_player_with_rotation_1:
    # Prologue
    addi $sp $sp -4 #allocate stack space
    sw $ra 0($sp)
    
    # Get the starting position
    lw $a0 player_row
    lw $a1 player_col
    jal get_unit
    # Draw the player with rotation 1

    # first draw a block of color1
    lw $a0, EMPTY_COLOR        # $t1 = red
    move $a1, $v0       # $t0 = base address for display
    jal draw_unit
    
    # Get the unit one up.
    lw $t1 player_row
    addi $t0 $t1 -1 # add 1 to the player_row
    move $a0 $t0
    lw $a1 player_col
    jal get_unit
    
    # draw second block
    lw $a0, EMPTY_COLOR       # $t1 = red
    move $a1, $v0       # $t0 = base address for display
    jal draw_unit
    
    #Epilogue
    lw $ra 0($sp) # pop $ra from stack;
    addi $sp $sp 4 # move stack pointer back down (to the new top of stack)
    jr $ra
    
remove_player_with_rotation_2:
    # Prologue
    addi $sp $sp -4 #allocate stack space
    sw $ra 0($sp)
    
    # Get the starting position
    lw $a0 player_row
    lw $a1 player_col
    jal get_unit
    # Draw the player with rotation 1

    # first draw a block of color1
    lw $a0, EMPTY_COLOR        # $t1 = red
    move $a1, $v0       # $t0 = base address for display
    jal draw_unit
    
    
    lw $t0 player_row
    move $a0 $t0
    
    lw $t1 player_col
    addi $t1 $t1 1
    move $a1 $t1
    jal get_unit
    
    # draw second block
    lw $a0, EMPTY_COLOR       # $t1 = red
    move $a1, $v0       # $t0 = base address for display
    jal draw_unit
    
    #Epilogue
    lw $ra 0($sp) # pop $ra from stack;
    addi $sp $sp 4 # move stack pointer back down (to the new top of stack)
    jr $ra
    
remove_player_with_rotation_3:
    # Prologue
    addi $sp $sp -4 #allocate stack space
    sw $ra 0($sp)
    
    # Get the starting position
    lw $a0 player_row
    lw $a1 player_col
    jal get_unit
    # Draw the player with rotation 1

    # first draw a block of color1
    lw $a0, EMPTY_COLOR        # $t1 = red
    move $a1, $v0       # $t0 = base address for display
    jal draw_unit
    
    # now deal with second block
    lw $t0 player_row
    addi $t0 $t0 1
    move $a0 $t0
    
    lw $t1 player_col
    move $a1 $t1
    jal get_unit
    
    # draw second block
    lw $a0, EMPTY_COLOR       # $t1 = red
    move $a1, $v0       # $t0 = base address for display
    jal draw_unit
    
    #Epilogue
    lw $ra 0($sp) # pop $ra from stack;
    addi $sp $sp 4 # move stack pointer back down (to the new top of stack)
    jr $ra
    
remove_player_with_rotation_4:
    # Prologue
    addi $sp $sp -4 #allocate stack space
    sw $ra 0($sp)
    
    # Get the starting position
    lw $a0 player_row
    lw $a1 player_col
    jal get_unit
    # Draw the player with rotation 1

    # first draw a block of color1
    lw $a0, EMPTY_COLOR    
    move $a1, $v0       # $t0 = base address for display
    jal draw_unit
    
    # now deal with second block
    lw $t0 player_row
    move $a0 $t0
    
    lw $t1 player_col
    addi $t1 $t1 -1
    move $a1 $t1
    jal get_unit
    
    # draw second block
    lw $a0, EMPTY_COLOR       # $t1 = red
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
    
draw_next_capsule:
    # Prologue
    addi $sp $sp -4 #allocate stack space
    sw $ra 0($sp)
    
    # Get the starting position
    lw $a0 next_capsule_row
    lw $a1 next_capsule_col
    jal get_unit
    # Draw the next capsule with rotation 1

    # first draw a block of color1
    lw $a0, next_player_color1       
    move $a1, $v0       # $t0 = base address for display
    jal draw_unit
    
    # Get the second position
    lw $a0 next_capsule_row
    addi $a0 $a0 1
    lw $a1 next_capsule_col
    jal get_unit

    # second draw the second block of color2
    lw $a0, next_player_color2       
    move $a1, $v0       # $t0 = base address for display
    jal draw_unit
    
 #Epilogue
    lw $ra 0($sp) # pop $ra from stack;
    addi $sp $sp 4 # move stack pointer back down (to the new top of stack)
    jr $ra
    




randomize_next_capsule: 
# Prologue
    addi $sp $sp -4 #allocate stack space
    sw $ra 0($sp)

li $v0, 42
    li $a0, 0
    li $a1, 3
    syscall         
    sll $a0 $a0 3       # now $a0 is a random number of 0, 2, 4 
    addi $t1 $zero 0x0000ff
    sllv $t1 $t1 $a0   
    addi $t0 $zero 0x00ff00
    bne $t1 $t0 handle_yellow_next_player_color_1
    addi $t1 $t1 0xff0000
    handle_yellow_next_player_color_1:
    sw $t1 next_player_color1
    li $v0, 42
    li $a0, 0
    li $a1, 3
    syscall         
    sll $a0 $a0 3      # now $a0 is a random number of 0, 2, 4 
    addi $t1 $zero 0x0000ff
    sllv $t1 $t1 $a0   
    addi $t0 $zero 0x00ff00
    bne $t1 $t0 handle_yellow_next_player_color_2
    addi $t1 $t1 0xff0000
    handle_yellow_next_player_color_2:
    sw $t1 next_player_color2
    #Epilogue
    lw $ra 0($sp) # pop $ra from stack;
    addi $sp $sp 4 # move stack pointer back down (to the new top of stack)
    jr $ra