
# Player states.
.eqv STATE_GROUND 0
.eqv STATE_JUMP 1
.eqv STATE_FALL 2

# How many hits the player starts with (and the maximum number they can have).
.eqv PLAYER_MAX_HEALTH 3

# How long the player is invincible for after getting hurt.
.eqv PLAYER_HURT_IFRAMES 90 # frames

# Initial Y velocity when the player jumps.
.eqv PLAYER_JUMP_VY -0x140

# When player releases jump button, if they are moving up, their Y velocity is multiplied by this.
.eqv PLAYER_JUMP_RELEASE_MULTIPLIER 0x080

# Speed of player acceleration.
.eqv PLAYER_ACCEL 0x014

# Friction constant used to decay acceleration.
.eqv PLAYER_FRICTION 0x0C0

# Maximum speed player can move horizontally.
.eqv PLAYER_MIN_VX -0x100
.eqv PLAYER_MAX_VX 0x100

# Maximum speed player can move vertically.
.eqv PLAYER_MIN_VY -0x200
.eqv PLAYER_MAX_VY 0x200

# Y velocity applied when player steps on a spring.
.eqv SPRING_VY -0x180

# Strength of gravity.
.eqv GRAVITY 0x014

# Minimum player Y velocity needed to destroy a crumble block.
.eqv CRUMBLE_MIN_VY 0x120

# How fast the player walks right after touching the goal.
.eqv PLAYER_GOAL_VX 0x80

# Camera position is player position plus these offsets.
.eqv CAMERA_OFFSET_X -30
.eqv CAMERA_OFFSET_Y -25

# Tile types.
.eqv TILE_EMPTY   0
.eqv TILE_SKY     1
.eqv TILE_BRICK   2
.eqv TILE_SPIKE   3
.eqv TILE_SPRING  4
.eqv TILE_CRUMBLE 5
.eqv TILE_RING    6
.eqv TILE_GOAL    7

# Maximum number of objects in the game world.
.eqv NUM_OBJECTS 32

# Used in array bounds checks
.eqv NUM_OBJECTS_X4 128 #= NUM_OBJECTS * 4

# The width/height of objects. It's fixed at 5 pixels.
.eqv OBJ_SIZE 0x500

# Half the width/height of objects, used a lot in collision and drawing.
.eqv OBJ_HALF_SIZE 0x280 #= OBJ_SIZE / 2

# Object types.
.eqv OBJ_EMPTY     0
.eqv OBJ_PLAYER    1
.eqv OBJ_HEART     2
.eqv OBJ_MSPIKE    3

# Moving spike velocity.
.eqv MSPIKE_VY 0x40

# How long after touching the goal the game will end.
.eqv GOAL_TIMER_LENGTH 120 # frames