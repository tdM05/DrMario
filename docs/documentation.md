# Registers to not modify during game loop

- $s0 - this always contains the key pressed
- $s1 - this is a countdown for when to move down (it moves down when it hits 0).

# Constants

### EMPTY_COLOR

This is black

### PLAYER_TOTAL_FALL_TIME

The default amount of frames until we move down. When $s0 hits 0, it moves down, then
$s0 resets to this constant.

### PLAYER_FAST_FALL_DIVIDER

Divides PLAYER_TOTAL_FALL_TIME to speed up the fast fall time.

### PLAYER_NORMAL_FALL_DIVIDER

Divides PLAYER_TOTAL_FALL_TIME to speed up the normal fall time.

# Variables

### player_is_fast_falling

1 if the player is fast falling (has pressed s) and 0 if not. Once a player has pressed s,
the pill will continue to fast fall until a new pill is created.

### player_color1

Color1 of the player

### player_color2

Color2 of the player

### player_rotation:

- color 1 is always the origin of the player
- 1: color 2 on top, color 2 on bottom
- 2: color 1 on left, color 2 on right
- 3: color 1 on top, color 2 on bottom
- 4: color 2 on left, color 1 on right

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

## move_down_position

**Purpose**: Moves the player down fast or normal.

**Parameters**:

- $a0 - 1 if fast fall, 0 if normal speed.

**Return Value**

- $v0 - The new player_col position

- $v1 - The new player_row position

## move_right_position

**Purpose**: Moves the player right

**Parameters**:

- null

**Return Value**

- $v0 - The new player_col position
- $v1 - The new player_row position

## move_left_position

**Purpose**: Moves the player left

**Parameters**:

- null

**Return Value**

- $v0 - The new player_col position
- $v1 - The new player_row position

## rotate_position

**Purpose**: Rotates the player 90 degrees clockwise

**Parameters**:

- null

**Return Value**

- $v0 - The new player_rotation
