# Registers to not modify during game loop

- $s0 - this always contains the key pressed
- $s1 - this is a countdown for when to move down (it moves down when it hits 0).
- $s2 - this saves the player's expected next row before checking collision
- $s3 - this saves the player's expected next column before checking collision
- $s4 - this saves the player's expected next rotation before checking collision

# MUSIC constants, variables and functions

### FRAMES_IN_SIXTEENTH_NOTE

### SIXTTEENTH_NOTES_IN_TRACK

### sixteenth_note_number

### sixteenth_note_frame_incrementer

### do_not_play_note_on_this_frame

## play_music

**Purpose**: plays music based on where we are (sixteenth_note_number)

**Parameters**:

- None

**Return Value**

- None

## increment_sixteenth_note_number

**Purpose**: increments sixteenth_note_number if needed using,
sixteenth_note_frame_incrementer, and FRAMES_IN_SIXTEENTH_NOTE

**Parameters**:

- None

**Return Value**

- None

# Constants

### EMPTY_COLOR

This is black

### BOTAL_TOP_ROW

### BOTAL_BOTTOM_ROW

### BOTAL_LEFT_COL

### BOTAL_RIGHT_COL

### PLAYER_TOTAL_FALL_TIME

The default amount of frames until we move down. When $s0 hits 0, it moves down, then
$s0 resets to this constant.;

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
- 1: color 2 on top, color 1 on bottom
- 2: color 1 on left, color 2 on right
- 3: color 1 on top, color 2 on bottom
- 4: color 2 on left, color 1 on right

### player_row

- the row (in blocks) of the player between 0 and 64 inclusive

### player_col

- this is in pixels since falling down can be done pixel by pixel
- the column (in pixels) of the player between 0 and 64 inclusive

### move_col_array

- array of information to move col down (col, empty row # , first row # need to move, # of unit need to be moved)

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

## draw_virus_pattern

**Purpose**: Draws a virus pattern of color $a0 at location $a1

**Parameters**:

- $a0 - Color
- $a1 - The top left pixel memory location in memory for that unit

## move_one_unit_down

**Purpose**: Draws a move unit with top left corner address $a1 to unit with top left corner address $a0.

**Parameters**:

- $a0 - down address
- $a1 - original adress

## move_col_down

**Purpose**: move 1 columb down

**Parameters**:

- use move_col_array
- 0 - col number
- 1 - empty row #
- 2 - first row # need to move
- 3 - # of col need to move

## draw_row

**Purpose**: Draws a row from $a0 to $a1 with row $a2, and color $a3

**Parameters**:

- $a0 - row start
- $a1 - row end
- $a2 - the row number
- $a3 - the color

**Return Value**:

- null

## draw_col

**Purpose**: Draws a col from $a0 to $a1 with column $a2, and color $a3

**Parameters**:

- $a0 - col start
- $a1 - col end
- $a2 - the column number
- $a3 - the color

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

# Collision Functions

## can_move_here_with_rotation_i:

**Purpose**: Tells us if the player can move to this location with rotation i. This is
a helper function for can_move_here.

**Parameters**:

- $a0 - The row
- $a1 - The column
- $a2 - The rotation (i).

  **Return Value**

- $v0 - Returns 1 if we can move here and 0 if we cannot

## block_empty

**Purpose**: Tells us if this block is empty

- $a0 - The row
- $a1 - The column

**Return Value**:

- $v0 - Returns 1 if it is empty and 0 otherwise.

# Process Hit Bottom Functions

## remove_four_in_a_row

**Purpose**: Removes all four in a rows on the screen

**Parameters**: Null

**Return Value**: Returns 1 if at least one four in a row has been removed, zero otherwise.

## set_capsule_locations

**Purpose**: Sets a location in capsule_locations with a capsule position
so that we know which capsules need to be moved when calling move_capsules_down

**Parameters**:

- $a0 the row
- $a1 the column
- $a2 the rotation

**Return Value**: None

## move_capsules_down

**Purpose**: Moves all capsules in capsule_locations to the bottom, based on
the screen positions.

**Parameters**: Null

**Return Value**: None

## update_number_of_unit_need_move

**Purpose**: find number of unit need move for move col down

**Parameters**:

- $a0 row
- $a1 col

**Return Value**:

- $v0 # of unit need to be moved
