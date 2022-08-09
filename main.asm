# Matt Semmel
# mws73

# This is used in a few places to make grading your project easier.
.eqv GRADER_MODE 1

# This .include has to be up here so we can use the constants in the variables below.
.include "game_constants.asm"

# ------------------------------------------------------------------------------------------------
.data
# Counts down after the player touches the goal.
goal_timer: .word 0

# Boolean (0/1): 1 when the game is over, either successfully or not.
# If player_health == 0, it was not successful.
game_over: .word 0

# How many rings the player has collected.
player_rings: .word 0

# How many hits the player can take until a game over.
player_health: .word PLAYER_MAX_HEALTH

# 0 = normal, nonzero = player is invincible and flashing.
player_iframes: .word 0

# What state the player is in.
player_state: .word STATE_GROUND

# Boolean, 1 if the player *wants* to jump (but they may not be allowed to).
player_wants_to_jump: .word 0

# Used in collision to tell if the player walked off an edge.
player_floor_tile_left: .word 0
player_floor_tile_right: .word 0

# Object arrays. These are parallel arrays. The player object is in slot 0,
# so the "player_x" and "player_y" labels are pointing to the same place as
# slot 0 of those arrays. Same thing for "player_vx/vy".
object_type:  .word OBJ_EMPTY:NUM_OBJECTS
player_x:
object_x:     .word 0:NUM_OBJECTS # fixed 24.8 - X position
player_y:
object_y:     .word 0:NUM_OBJECTS # fixed 24.8 - Y position
player_vx:
object_vx:    .word 0:NUM_OBJECTS # fixed 24.8 - X velocity
player_vy:
object_vy:    .word 0:NUM_OBJECTS # fixed 24.8 - Y velocity

.text

# ------------------------------------------------------------------------------------------------

# these .includes are here to make these big arrays come *after* the interesting
# variables in memory. it makes things easier to debug.
.include "display_2227_0611.asm"
.include "tilemap.asm"
.include "textures.asm"
.include "map.asm"
.include "obj.asm"
.include "collide.asm"

# ------------------------------------------------------------------------------------------------

.globl main
main:
	# load the map and objects
	jal load_map

	# main game loop
	_loop:
		jal check_input
		jal update_all
		jal draw_all
		jal display_update_and_clear
		jal wait_for_next_frame
	jal check_game_over
	beq v0, 0, _loop

	# when the game is over, show a message
	jal show_game_over_message
syscall_exit

# ------------------------------------------------------------------------------------------------
# Misc game logic
# ------------------------------------------------------------------------------------------------

# returns a boolean (1/0) of whether the game is over. 1 means it is.
check_game_over:
enter
	li v0, 0

	# game is over when game_over is 1 and goal_timer is 0.
	lw t0, game_over
	beq t0, 0, _return

		lw t0, goal_timer
		bne t0, 0, _return

			li v0, 1
_return:
leave

# ------------------------------------------------------------------------------------------------

show_game_over_message:
enter
	# first clear the display
	jal display_update_and_clear

	# Then show a different message depending on whether player_health is 0 or not.
	lw t0, player_health
	beq t0, 0, _died
		# they finished successfully!
		li   a0, 7
		li   a1, 25
		lstr a2, "yay! you"
		li   a3, COLOR_GREEN
		jal  display_draw_colored_text

		li   a0, 12
		li   a1, 31
		lstr a2, "did it!"
		li   a3, COLOR_GREEN
		jal  display_draw_colored_text
	j _endif
	_died:
		# they... didn't...
		li   a0, 5
		li   a1, 30
		lstr a2, "oh no :("
		li   a3, COLOR_RED
		jal  display_draw_colored_text
	_endif:

	jal display_update_and_clear
leave

# ------------------------------------------------------------------------------------------------

# update all the parts of the game and do collision between objects.
update_all:
enter
	jal update_timers
	jal obj_update_all
	jal update_camera
leave

# ------------------------------------------------------------------------------------------------

# positions camera based on player position.
update_camera:
enter
	lw  a0, player_x
	sub a0, a0, OBJ_HALF_SIZE
	sra a0, a0, 8
	add a0, a0, CAMERA_OFFSET_X
	lw  a1, player_y
	sub a1, a1, OBJ_HALF_SIZE
	sra a1, a1, 8
	add a1, a1, CAMERA_OFFSET_Y
	jal tilemap_set_scroll
leave

# ------------------------------------------------------------------------------------------------

update_timers:
enter
	# TODO
leave

# ------------------------------------------------------------------------------------------------
# Player input/logic
# ------------------------------------------------------------------------------------------------

# Get input from the user and move the player object accordingly.
check_input:
enter
	jal input_get_keys_held

	and t0, v0, KEY_L
	bne t0, 0, _move_left
	
	and t0, v0, KEY_R
	bne t0, 0, _move_right
	
	j _apply_friction

	_move_left:
        # Move left
        lw t7, player_vx
        sub t8, t7, PLAYER_ACCEL
        maxi t9, t8, PLAYER_MIN_VX # t0=max(t0, PLAYER_MIN_VX)
        sw t9, player_vx
        
	j _endif_horiz
	
	_move_right:
        # Move right
        lw t7, player_vx
        add t8, t7, PLAYER_ACCEL
        mini t9, t8, PLAYER_MAX_VX # t0=min(t0, PLAYER_MAX_VX)
        sw t9, player_vx
        
	j _endif_horiz
	
	_apply_friction:
        # Slow the player down
	lw t6, player_vx
	mul t6, t6, PLAYER_FRICTION
	div t6, t6, 256
	sw t6, player_vx
	
	_endif_horiz:
	
	sw zero, player_wants_to_jump
	and t4, v0, KEY_C
	beq t4, 0, _wantjump_ZERO
		li t5, 1
		sw t5, player_wants_to_jump
	# add t5, t5, 1
	# sw t5, player_wants_to_jump
	
	_wantjump_ZERO: 
	
	jal input_get_keys_released
	and t3, v0, KEY_C
	beq t3, 0, _no
		lw t2, player_state
		bne t2, STATE_JUMP, _no
			lw t1, player_vy
			bgt t1, 0, _no
				li t8, PLAYER_JUMP_RELEASE_MULTIPLIER
				mul t7, t1, t8
				sra t1, t7, 8
				sw t1, player_vy
	
	_no:
	
leave

# ------------------------------------------------------------------------------------------------
# Player object
# ------------------------------------------------------------------------------------------------

obj_update_player:
enter
	# move and collide horizontally (any state)
	jal player_move_and_collide_x

	# apply gravity if they're in the air (NON-ground-state only, jump->fall)
	jal player_apply_gravity

	# move and collide vertically (jump->fall, fall->ground)
	jal player_move_and_collide_y

	# see if they want to jump or if they fell off an edge (ground->jump, ground->fall)
	jal player_check_jump_and_fall

	# check for other kinds of tiles (rings, goal)
	jal player_check_nonsolid_tiles
leave

# ------------------------------------------------------------------------------------------------

player_move_and_collide_x:
enter

	li a0, 0
	jal obj_move_and_collide_tilemap_x
	beq v0, 0, _pvx_ZERO
		sw v0, player_vx

	_pvx_ZERO:
		
leave

# ------------------------------------------------------------------------------------------------

player_apply_gravity:
enter

	lw t0, player_state
	beq t0, STATE_GROUND, _not_GROUND
		lw t1, player_vy
		add t2, t1, GRAVITY
		mini t3, t2, PLAYER_MAX_VY
		maxi t4, t3, PLAYER_MIN_VY
		sw t4, player_vy
		
		bne t0, STATE_JUMP, _not_JUMP
			lw t5, player_vy
			ble t5, 0, _greaterTHAN
				li t6, STATE_FALL
				sw t6, player_state
	
	_not_GROUND:
	
	_not_JUMP:
	
	_greaterTHAN:

leave

# ------------------------------------------------------------------------------------------------

# ref: player_floor_tile_left/right: .word 0
player_move_and_collide_y:
enter
	sw zero, player_floor_tile_left
	sw zero, player_floor_tile_right
	
	li a0, 0
	jal obj_move_and_collide_tilemap_y_left
	
	beq v0, 0, _noCollide_left
		sw v0, player_floor_tile_left
		jal player_collide_y
	
	li a0, 0
	jal obj_move_and_collide_tilemap_y_right
	
	beq v0, 0, _noCollide_right
		sw v0, player_floor_tile_right
		jal player_collide_y
	
	_noCollide_left:
	
	_noCollide_right:
leave

# ------------------------------------------------------------------------------------------------

player_collide_y:
enter
	lw t0 player_state
	beq t0, STATE_GROUND, _if
	bne t0, STATE_GROUND, _else
	
	_if:	
		jal player_collide_y_ground
		j _end
	
	_else:
		jal player_collide_y_air
	_end:

leave

# ------------------------------------------------------------------------------------------------

player_collide_y_ground:
enter
	
leave

# ------------------------------------------------------------------------------------------------

player_collide_y_air:
enter
	# for ref: collide_tile_type/tx/ty: .word 0
	lw t0, collide_tile_type
	beq t0, 0, _end
		lw t9, player_vy
		sw zero, player_vy
		
		bge t9, 0, _if
		blt t9, 0, _else
	_if:
		li t1, STATE_GROUND
		sw t1, player_state

		j _end
	
	_else:
		li t2, STATE_FALL
		sw t2, player_state

	_end:
leave

# ------------------------------------------------------------------------------------------------

player_check_jump_and_fall:
enter
	# for reference: player_state: .word STATE_GROUND
	lw t0, player_state
	bne t0, STATE_GROUND, _not_GROUND
	#something goes here later
		lw t1, player_wants_to_jump
		beq t1, 0, _nowant_JUMP
			sw zero, player_wants_to_jump
			li t2, PLAYER_JUMP_VY
			sw t2, player_vy
			li t3, STATE_JUMP
			sw t3, player_state
	
	_not_GROUND:
	
	_nowant_JUMP:
leave

# ------------------------------------------------------------------------------------------------

player_check_nonsolid_tiles:
enter
	jal player_collect_rings
leave

# ------------------------------------------------------------------------------------------------

player_collect_rings:
enter
	# rightshift and div player_x
	lw t2, player_x
	sra t2, t2, 8
	div t2, t2, 5
	
	# rightshift and div player_y
	lw t3, player_y
	sra t3, t3, 8
	div t3, t3, 5
	
	# load dem args
	move a0, t2
	move a1, t3
	
	jal tilemap_get_tile
	bne v0, TILE_RING, _no_RING
		lw t4, player_rings
		inc t4
		sw t4, player_rings
	
		# load dem args
		move a0, t2
		move a1, t3
		li a2, TILE_SKY
		
		jal tilemap_set_tile

	_no_RING:
	
leave

# ------------------------------------------------------------------------------------------------
# Other objects
# ------------------------------------------------------------------------------------------------

obj_update_heart:
enter s0
	move s0, a0

	# TODO
leave s0

# ------------------------------------------------------------------------------------------------

obj_update_mspike:
enter s0
	move s0, a0

	# TODO
leave s0

# ------------------------------------------------------------------------------------------------
# Drawing functions
# ------------------------------------------------------------------------------------------------

draw_all:
enter
	jal tilemap_draw
	jal obj_draw_all
	jal draw_hud
leave

# ------------------------------------------------------------------------------------------------

draw_hud:
enter s0, s1
	li a0, 0
	li a1, 0
	li a2, 64
	li a3, TILEMAP_VIEWPORT_Y
	li v1, COLOR_BLACK
	jal display_fill_rect_fast

	# draw health
	lw s0, player_health
	beq s0, 0, _end_health_loop
	li s1, 2
	_health_loop:
		move a0, s1
		li   a1, 1
		la   a2, tex_heart
		jal  display_blit_5x5_trans

		add s1, s1, 6
	dec s0
	bgt s0, 0, _health_loop
	_end_health_loop:

	# draw rings
	li a0, 20
	li a1, 1
	la a2, tex_hud_ring
	jal display_blit_5x5_trans

	li a0, 26
	li a1, 1
	lw a2, player_rings
	jal display_draw_int

	# skip the rest if we're in grader mode
	beq zero, GRADER_MODE, _return
		# player state
		li a0, 58
		li a1, 1
		lw a2, player_state
		jal display_draw_int

		# player velocity
		li  a0, 2
		li  a1, 8
		lw  a2, player_vx
		li  a3, 4
		jal display_draw_int_hex

		li  a0, 2
		li  a1, 14
		lw  a2, player_vy
		li  a3, 4
		jal display_draw_int_hex
_return:
leave s0, s1

# ------------------------------------------------------------------------------------------------

obj_draw_player:
enter
	lw t0, player_iframes
	beq t0, 0, _draw
	and t0, t0, 4
	beq t0, 0, _return

_draw:
	lw  a0, player_x
	sub a0, a0, OBJ_HALF_SIZE
	sra a0, a0, 8
	lw  a1, player_y
	sub a1, a1, OBJ_HALF_SIZE
	sra a1, a1, 8
	la  a2, tex_player
	jal blit_5x5_sprite_trans

_return:
leave

# ------------------------------------------------------------------------------------------------

.data
	heart_vertical_offset: .word 0, 0x100, 0, -0x100
.text

obj_draw_heart:
enter s0
	move s0, a0

	# TODO
leave s0

# ------------------------------------------------------------------------------------------------

obj_draw_mspike:
enter s0
	move s0, a0

	# TODO
leave s0

# ------------------------------------------------------------------------------------------------

# a0 = world x, a1 = world y, a2 = pointer to texture
# draws a 5x5 image, but coordinates are relative to the "world" (i.e. the tilemap).
# figures out the screen coordinates and draws it there.
blit_5x5_sprite_trans:
enter
	# draw the dang thing
	# x = x - tilemap_scx + TILEMAP_VIEWPORT_X
	lw  t0, tilemap_scx
	sub a0, a0, t0
	add a0, a0, TILEMAP_VIEWPORT_X

	# y = y - tilemap_scy + TILEMAP_VIEWPORT_Y
	lw  t0, tilemap_scy
	sub a1, a1, t0
	add a1, a1, TILEMAP_VIEWPORT_Y

	jal display_blit_5x5_trans
leave
