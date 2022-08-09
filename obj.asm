
# -------------------------------------------------------------------------------------------------

# a0 = object type
# tries to allocate an object.
# if successful, zeros out the other variables and returns the object's array index.
# if unsuccessful, returns -1.
obj_alloc:
enter
	# start at object 1 so we skip the player object slot.
	li v0, 4
	_loop:
		lw  t0, object_type(v0)
		beq t0, OBJ_EMPTY, _found
	add v0, v0, 4
	blt v0, NUM_OBJECTS_X4, _loop

	# fail!
	li v0, -1
	j _return

_found:
	# initialize the variables associated with it
	sw a0,   object_type(v0)
	sw zero, object_x(v0)
	sw zero, object_y(v0)
	sw zero, object_vx(v0)
	sw zero, object_vy(v0)
_return:
leave

# -------------------------------------------------------------------------------------------------

# a0 = object index
# frees an object.
obj_free:
enter
	tlti a0, 0 # you passed a negative object index.
	tgei a0, NUM_OBJECTS_X4 # you passed an invalid object index.
	sw zero, object_type(a0) # if this crashes, your index is not a multiple of 4.
leave

# -------------------------------------------------------------------------------------------------

# obj_new_heart(x, y)
# Tries to create a heart object and crashes if unsuccessful.
obj_new_heart:
enter s0, s1
	move s0, a0
	move s1, a1

	li  a0, OBJ_HEART
	jal obj_alloc
	blt v0, 0, _else
		sw s0, object_x(v0)
		sw s1, object_y(v0)
	j _endif
	_else:
		println_str "Could not spawn heart!"
		syscall_exit
	_endif:
leave s0, s1

# -------------------------------------------------------------------------------------------------

# obj_new_mspike(x, y)
# Tries to create a moving spike object and crashes if unsuccessful.
obj_new_mspike:
enter s0, s1
	move s0, a0
	move s1, a1

	li  a0, OBJ_MSPIKE
	jal obj_alloc
	blt v0, 0, _else
		sw s0, object_x(v0)
		sw s1, object_y(v0)

		li t0, MSPIKE_VY
		sw t0, object_vy(v0)
	j _endif
	_else:
		println_str "Could not spawn moving spike!"
		syscall_exit
	_endif:
leave s0, s1

# -------------------------------------------------------------------------------------------------

# a0 = object index
# returns a boolean (1/0) of whether the object is visible (within the tilemap viewport).
# empty objects are also considered invisible.
obj_is_visible:
enter
	li v0, 0

	# empty?
	lw  t0, object_type(a0)
	beq t0, OBJ_EMPTY, _return

	lw t0, object_x(a0)
	sra t0, t0, 8
	lw t1, object_y(a0)
	sra t1, t1, 8
	lw t2, tilemap_scx
	lw t3, tilemap_scy

	sub t4, t2, 5
	blt t0, t4, _return # object x < tilemap x - 5?
	sub t4, t3, 5
	blt t1, t4, _return # object y < tilemap y - 5?

	add t2, t2, TILEMAP_VIEWPORT_W
	add t3, t3, TILEMAP_VIEWPORT_H

	bge t0, t2, _return # object x >= tilemap x + screen w?
	bge t1, t3, _return # object y >= tilemap y + screen h?

	# ok, it's visible!
	li v0, 1

_return:
leave

# -------------------------------------------------------------------------------------------------

# a0 = object index
# a1 = other object index
# returns boolean (1/0) of whether these two objects are overlapping.
# if a0 == a1, returns 0.
obj_collides_with_obj:
enter
	li v0, 0

	# don't check object against itself.
	beq a0, a1, _return

	# if abs(object_x[a0] - object_x[a1]) >= OBJ_SIZE, return
	lw t0, object_x(a0)
	lw t1, object_x(a1)
	sub t0, t0, t1
	abs t0, t0
	bge t0, OBJ_SIZE, _return

	# if abs(object_y[a0] - object_y[a1]) >= OBJ_SIZE, return
	lw t0, object_y(a0)
	lw t1, object_y(a1)
	sub t0, t0, t1
	abs t0, t0
	bge t0, OBJ_SIZE, _return

	# passed both checks, colliding
	li v0, 1
_return:
leave

# -------------------------------------------------------------------------------------------------

# a0 = object index
# returns boolean (1/0) of whether this object is overlapping with the player object.
# if a0 == 0, returns 0.
obj_collides_with_player:
enter
	li a1, 0
	jal obj_collides_with_obj
leave

# -------------------------------------------------------------------------------------------------

.data
# array of pointers to object update methods, indexed by type.
obj_update_methods: .word
	0                    # OBJ_EMPTY
	obj_update_player    # OBJ_PLAYER
	obj_update_heart     # OBJ_HEART
	obj_update_mspike    # OBJ_MSPIKE
.text

# update all visible objects.
obj_update_all:
enter s0
	# then, call the update methods.
	li s0, 0
	_loop:
		move a0, s0
		jal  obj_is_visible
		beq  v0, 0, _invisible
			move a0, s0

			lw   t0, object_type(a0)
			mul  t0, t0, 4
			lw   t0, obj_update_methods(t0)
			teqi t0, 0 # update method is null! aaaahh!
			jalr t0
		_invisible:
	add s0, s0, 4
	blt s0, NUM_OBJECTS_X4, _loop
leave s0

# -------------------------------------------------------------------------------------------------

.data
# array of pointers to object drawing methods, indexed by type.
obj_draw_methods: .word
	0                  # OBJ_EMPTY
	obj_draw_player    # OBJ_PLAYER
	obj_draw_heart     # OBJ_HEART
	obj_draw_mspike    # OBJ_MSPIKE
.text

# draw all visible objects.
obj_draw_all:
enter s0
	li s0, 0
	_loop:
		move a0, s0
		jal  obj_is_visible
		beq  v0, 0, _invisible
			move a0, s0

			lw   t0, object_type(a0)
			mul  t0, t0, 4
			lw   t0, obj_draw_methods(t0)
			teqi t0, 0 # drawing method is null! aaaahh!
			jalr t0
		_invisible:
	add s0, s0, 4
	blt s0, NUM_OBJECTS_X4, _loop
leave s0
