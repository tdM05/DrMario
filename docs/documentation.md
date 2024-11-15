# Constants

# Variables

### player_color1

Color1 of the player

### player_color2

Color2 of the player

### player_rotation:

- color 1 is always the origin of the player
- 1: color 2 on top, color 2 on bottom
- 2: color 1 on left, color 2 on right
- 3: color 1 on top, color 2 on bottom
- 4: color 2 on right, color 1 on left

### player_row

- the row (in blocks) of the player between 0 and 64 inclusive

### player_col

- this is in pixels since falling down can be done pixel by pixel
- the column (in pixels) of the player between 0 and 64 inclusive

# I/O Functions

## key_pressed

**Purpose**: Tells us if a key is pressed, and what key was pressed if one was pressed.

**Parameters**: None

**Return Value**

- $v0 - 1 if key is pressed, and 0 if not.
- $v1 - the key that was pressed in hex.

# Draw Functions

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
- $a1 - The top left pixel memory location in memory for that unit

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

## remove_player

**Purpose**: Removes the player by drawing black pixels in player's location.

# Movement functions

## move_right

**Purpose**: Moves the player right based on the top left corner of the player

**Parameters**:

- $a0 - The top left corner of the player

**Return Value**

- null
