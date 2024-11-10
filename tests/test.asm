.data                   # Data segment
prompt: .asciiz "Enter two numbers: "   # A string for prompt

.text                   # Code segment
.globl main             # Declare main as global (entry point)

main:
    li $v0, 4           # System call for printing string
    la $a0, prompt      # Load address of prompt into $a0
    syscall             # Make system call (print string)

    li $v0, 5           # System call for reading integer
    syscall             # Read integer into $v0
    move $t0, $v0       # Move first integer to $t0

    li $v0, 5           # System call for reading integer
    syscall             # Read second integer into $v0
    move $t1, $v0       # Move second integer to $t1

    add $t2, $t0, $t1   # Add the two numbers, store result in $t2

    move $a0, $t2       # Move result to $a0 for printing
    li $v0, 1           # System call for printing integer
    syscall             # Print result

    li $v0, 10          # System call for exit
    syscall             # Exit the program