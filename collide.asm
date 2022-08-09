
.data
	# after performing a tilemap collision, holds the tile x/y coords of the tile that was hit.
	collide_tx: .word 0
	collide_ty: .word 0

	# after performing a tilemap collision, holds the type of tile at (collide_tx, collide_ty).
	collide_tile_type: .word 0
.text

# ------------------------------------------------------------------------------------------------

# tilemap_collide_x(x, y, vx)
# given the starting position and x velocity, tries to move to the point (x + vx, y).
# returns two values:
#   v0 = type of tile (0 if no tile was hit)
#   v1 = x + vx, corrected for collision.
tilemap_collide_x:
enter s0, s1
	move s0, a0 # s0 = original x
	move s1, a2 # s1 = vx

	# is_solid_tile((int)((x + vx) / 5), (int)(y / 5))
	add a0, s0, s1
	div a0, a0, 5
	srl a0, a0, 8
	div a1, a1, 5
	srl a1, a1, 8

	# save these!
	sw a0, collide_tx
	sw a1, collide_ty

	jal is_solid_tile

	# save this!
	sw v1, collide_tile_type

	# if is_solid_tile returned something...
	beq v0, 0, _no_hit
		# right now, v0 is a bool and v1 is the type of tile.
		# but we want v0 = type of tile, and v1 = updated x...
		move v0, v1        # v0 = type of tile
		add  v1, s0, s1    # v1 = x + vx
		div  v1, v1, 0x500 # v1 = (x + vx) / 5

		blt s1, 0, _hit_left
			mul v1, v1, 0x500 # v1 = ((x + vx) / 5) * 5
		j _endif # yes, the outer if's endif
		_hit_left:
			add v1, v1, 1 # v1 = ((x + vx) / 5) + 1
			mul v1, v1, 0x500 # v1 = (((x + vx) / 5) + 1) * 5
	j _endif
	_no_hit:
		# return 0 for type of tile if nothing solid was hit.
		li  v0, 0
		add v1, s0, s1 # v1 = x + vx
	_endif:
leave s0, s1

# ------------------------------------------------------------------------------------------------

# tilemap_collide_y(x, y, vy)
# given the starting position and y velocity, tries to move to the point (x, y + vy).
# returns two values:
#   v0 = type of tile (0 if no tile was hit)
#   v1 = y + vy, corrected for collision.
tilemap_collide_y:
enter s0, s1
	move s0, a1 # s0 = original y
	move s1, a2 # s1 = vy

	# is_solid_tile((int)(x / 5), (int)((y + vy) / 5))
	div a0, a0, 5
	srl a0, a0, 8
	add a1, a1, a2
	div a1, a1, 5
	srl a1, a1, 8

	# save these!
	sw a0, collide_tx
	sw a1, collide_ty

	jal is_solid_tile

	# save this!
	sw v1, collide_tile_type

	# if is_solid_tile returned something...
	beq v0, 0, _no_hit
		# right now, v0 is a bool and v1 is the type of tile.
		# but we want v0 = type of tile, and v1 = updated x...
		move v0, v1        # v0 = type of tile
		add  v1, s0, s1    # v1 = y + vy
		div  v1, v1, 0x500 # v1 = (y + vy) / 5

		blt s1, 0, _hit_up
			mul v1, v1, 0x500 # v1 = ((y + vy) / 5) * 5
		j _endif # yes, the outer if's endif
		_hit_up:
			add v1, v1, 1 # v1 = ((y + vy) / 5) + 1
			mul v1, v1, 0x500 # v1 = (((y + vy) / 5) + 1) * 5
	j _endif
	_no_hit:
		# return 0 for type of tile if nothing solid was hit.
		li  v0, 0
		add v1, s0, s1 # v1 = y + vy
	_endif:
leave s0, s1

# ------------------------------------------------------------------------------------------------

obj_move_and_collide_tilemap_x:
enter s0
	move s0, a0

	# early-out for objects that aren't moving horizontally
	li  v0, 0
	lw  a2, object_vx(s0)
	beq a2, 0, _return

	# adjust tested x coordinate based on velocity
	lw  a0, object_x(s0)
	blt a2, 0, _else
		# moving right
		add a0, a0, OBJ_HALF_SIZE
	j _endif
	_else:
		sub a0, a0, OBJ_HALF_SIZE
	_endif:

	lw  a1, object_y(s0)
	jal tilemap_collide_x

	# if we hit something, have to adjust the x coordinate in the opposite direction
	lw t0, object_vx(s0)
	blt t0, 0, _else2
		sub v1, v1, OBJ_HALF_SIZE
	j _endif2
	_else2:
		add v1, v1, OBJ_HALF_SIZE
	_endif2:

	sw  v1, object_x(s0)
_return:
leave s0

# ------------------------------------------------------------------------------------------------

obj_move_and_collide_tilemap_y_left:
enter s0
	move s0, a0 # s0 = object index

	# no early-out for objects that aren't moving vertically, because
	# vertical collision is also used for objects on the ground.

	lw  a0, object_x(s0)
	sub a0, a0, OBJ_HALF_SIZE
	add a0, a0, 0x80

	lw  a1, object_y(s0)

	# adjust tested y coordinate based on velocity
	lw  a2, object_vy(s0)
	blt a2, 0, _else
		# moving down
		add a1, a1, OBJ_HALF_SIZE
	j _endif
	_else:
		sub a1, a1, OBJ_HALF_SIZE
	_endif:

	jal tilemap_collide_y

	# if we hit something, have to adjust the y coordinate in the opposite direction
	lw  t0, object_vy(s0)
	blt t0, 0, _else2
		sub v1, v1, OBJ_HALF_SIZE
	j _endif2
	_else2:
		add v1, v1, OBJ_HALF_SIZE
	_endif2:

	sw  v1, object_y(s0)
leave s0

# ------------------------------------------------------------------------------------------------

obj_move_and_collide_tilemap_y_right:
enter s0
	move s0, a0 # s0 = object index

	# no early-out for objects that aren't moving vertically, because
	# vertical collision is also used for objects on the ground.

	lw  a0, object_x(s0)
	add a0, a0, OBJ_HALF_SIZE
	sub a0, a0, 0x80

	lw  a1, object_y(s0)

	# adjust tested y coordinate based on velocity
	lw  a2, object_vy(s0)
	blt a2, 0, _else
		# moving down
		add a1, a1, OBJ_HALF_SIZE
	j _endif
	_else:
		sub a1, a1, OBJ_HALF_SIZE
	_endif:

	jal tilemap_collide_y

	# if we hit something, have to adjust the y coordinate in the opposite direction
	lw  t0, object_vy(s0)
	blt t0, 0, _else2
		sub v1, v1, OBJ_HALF_SIZE
	j _endif2
	_else2:
		add v1, v1, OBJ_HALF_SIZE
	_endif2:

	sw  v1, object_y(s0)
leave s0
