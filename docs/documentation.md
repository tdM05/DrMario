# Variables

# Functions

## get_pixel

**Purpose**: Returns the memory location of the pixel given row $a0 and column $a1

**Parameters**:

- $a0 - Row number
- $a1 - Column number

**Return Value**

- $v0 - Contains the adress of the pixel

## draw_block

**Purpose**: Draws a block of color $a0 at location $a1

**Parameters**:

- $a0 - Color
- $a1 - The top left pixel of the block

**Return Value**:

- null

## draw_pixel

**Purpose**: Draws a pixel of color $a0 at location $a1

**Parameters**:

- $a0 - Color
- $a1 - The pixel location in memory

**Return Value**:

- null

## Draw Player

**Purpose**: Draws the player (location, rotation, and color are already in memory, so no parameters or return values).

## Move Right

**Purpose**: Moves the player right based on the top left corner of the player

**Parameters**:

- $a0 - The top left corner of the player

**Return Value**

- null
