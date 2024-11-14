# Variables

# Functions

## get_unit

**Purpose**: Returns the memory location of the top left pixel given unit coordinate row $a0 and column $a1

**Parameters**:

- $a0 - Row number
- $a1 - Column number

**Return Value**

- $v0 - Contains the adress of the top left pixel for that unit

## draw_unit

**Purpose**: Draws a unit of color $a0 at location $a1

**Parameters**:

- $a0 - Color
- $a1 - The top left pixel location in memory for that unit

**Return Value**:

- null

## draw_bottle_unit

**Purpose**: set $a0 and $a1 for draw_unit and use draw_unit to draw the draw_bottle_unit

**Parameters**:

- $s0 - Color
- $s1 - The top left pixel location in memory for that unit
- will use $s5 as $ra since this is a nested function

**Return Value**:

- null

## draw_player

**Purpose**: Draws the player (location, rotation, and color are already in memory, so no parameters or return values).

## Move Right

**Purpose**: Moves the player right based on the top left corner of the player

**Parameters**:

- $a0 - The top left corner of the player

**Return Value**

- null
