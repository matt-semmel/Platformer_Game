
.data

# ASCII representation of the level the player plays on.
# This is loaded into the tilemap by translating each character to tiles and/or objects,
# using the char_to_tile and char_to_obj arrays.
level_data:
	.ascii "####################################################################################################"
	.ascii "#                                                 #####                     ######                 #"
	.ascii "#   oooo                                          #####                     ######                 #"
	.ascii "#   oooo                                          #####                     ######                 #"
	.ascii "#   oooo                                          #####      #####          ######                 #"
	.ascii "#                                      #          #####      #######        ######                 #"
	.ascii "#                         #  #              #     #####   #  #########      ######                 #"
	.ascii "#             #***#       #       #         #     #####      ###########****######                 #"
	.ascii "#   TTTT      # h #       #                 #     #####      ###########****######                 #"
	.ascii "####################    ###x x x x x x x x x#     #####      ###########****######                 #"
	.ascii "#             +  +        ###################     #####T     #####  o                   ############"
	.ascii "#                    #    ##############o         ######     ##### ooo                  %          #"
	.ascii "#                         ##############oo          +        #####oohoo                 %          #"
	.ascii "#         #              x##############ooo                  ##### ooo                  %          #"
	.ascii "#  $  ooo #            #################hooo               #T#####  o                   %          #"
	.ascii "####################################################################################################"

# Array that maps characters to tile types. Index 0 is ASCII 32 (space).
# The 0 entries are TILE_EMPTY but I wrote them as 0 to make it easy to visually tell
# which characters map to non-empty tiles.
char_to_tile: .byte
	TILE_SKY     # ' '
	0            # '!'
	0            # '"'
	TILE_BRICK   # '#'
	TILE_SKY     # '$' (also sets the player start position)
	TILE_GOAL    # '%'
	0            # '&'
	0            # '''
	0            # '('
	0            # ')'
	TILE_CRUMBLE # '*'
	TILE_SKY     # '+' (also makes a moving spike)
	0            # ','
	0            # '-'
	0            # '.'
	0            # '/'
	0            # '0'
	0            # '1'
	0            # '2'
	0            # '3'
	0            # '4'
	0            # '5'
	0            # '6'
	0            # '7'
	0            # '8'
	0            # '9'
	0            # ':'
	0            # ';'
	0            # '<'
	0            # '='
	0            # '>'
	0            # '?'
	0            # '@'
	0            # 'A'
	0            # 'B'
	0            # 'C'
	0            # 'D'
	0            # 'E'
	0            # 'F'
	0            # 'G'
	0            # 'H'
	0            # 'I'
	0            # 'J'
	0            # 'K'
	0            # 'L'
	0            # 'M'
	0            # 'N'
	0            # 'O'
	0            # 'P'
	0            # 'Q'
	0            # 'R'
	0            # 'S'
	TILE_SPRING  # 'T'
	0            # 'U'
	0            # 'V'
	0            # 'W'
	0            # 'X'
	0            # 'Y'
	0            # 'Z'
	0            # '['
	0            # '\'
	0            # ']'
	0            # '^'
	0            # '_'
	0            # '`'
	0            # 'a'
	0            # 'b'
	0            # 'c'
	0            # 'd'
	0            # 'e'
	0            # 'f'
	0            # 'g'
	TILE_SKY     # 'h' (also makes a heart object)
	0            # 'i'
	0            # 'j'
	0            # 'k'
	0            # 'l'
	0            # 'm'
	0            # 'n'
	TILE_RING    # 'o'
	0            # 'p'
	0            # 'q'
	0            # 'r'
	0            # 's'
	0            # 't'
	0            # 'u'
	0            # 'v'
	0            # 'w'
	TILE_SPIKE   # 'x'
	0            # 'y'
	0            # 'z'
	0            # '{'
	0            # '|'
	0            # '}'
	0            # '~'

# Array that maps characters to object types. Index 0 is ASCII 32 (space).
# The 0 entries are OBJ_EMPTY but I wrote them as 0 to make it easy to visually tell
# which characters map to non-empty objects.
# One character can map to both a tile and an object (e.g. 'k', which makes a key object
# on top of a grass tile).
char_to_obj: .byte
	0              # ' '
	0              # '!'
	0              # '"'
	0              # '#'
	OBJ_PLAYER     # '$' (also places a sky tile)
	0              # '%'
	0              # '&'
	0              # '''
	0              # '('
	0              # ')'
	0              # '*'
	OBJ_MSPIKE     # '+' (also places a sky tile)
	0              # ','
	0              # '-'
	0              # '.'
	0              # '/'
	0              # '0'
	0              # '1'
	0              # '2'
	0              # '3'
	0              # '4'
	0              # '5'
	0              # '6'
	0              # '7'
	0              # '8'
	0              # '9'
	0              # ':'
	0              # ';'
	0              # '<'
	0              # '='
	0              # '>'
	0              # '?'
	0              # '@'
	0              # 'A'
	0              # 'B'
	0              # 'C'
	0              # 'D'
	0              # 'E'
	0              # 'F'
	0              # 'G'
	0              # 'H'
	0              # 'I'
	0              # 'J'
	0              # 'K'
	0              # 'L'
	0              # 'M'
	0              # 'N'
	0              # 'O'
	0              # 'P'
	0              # 'Q'
	0              # 'R'
	0              # 'S'
	0              # 'T'
	0              # 'U'
	0              # 'V'
	0              # 'W'
	0              # 'X'
	0              # 'Y'
	0              # 'Z'
	0              # '['
	0              # '\'
	0              # ']'
	0              # '^'
	0              # '_'
	0              # '`'
	0              # 'a'
	0              # 'b'
	0              # 'c'
	0              # 'd'
	0              # 'e'
	0              # 'f'
	0              # 'g'
	OBJ_HEART      # 'h' (also places a sky tile)
	0              # 'i'
	0              # 'j'
	0              # 'k'
	0              # 'l'
	0              # 'm'
	0              # 'n'
	0              # 'o'
	0              # 'p'
	0              # 'q'
	0              # 'r'
	0              # 's'
	0              # 't'
	0              # 'u'
	0              # 'v'
	0              # 'w'
	0              # 'x'
	0              # 'y'
	0              # 'z'
	0              # '{'
	0              # '|'
	0              # '}'
	0              # '~'
.text

# ------------------------------------------------------------------------------------------------

# fills in tilemap by translating the characters in level_data to tile types.
# also allocates objects for characters that correspond to those.
load_map:
enter s0, s1
	# set the textures array
	la a0, tile_textures
	jal tilemap_set_textures

	# s0 = column
	# s1 = row

	li s1, 0
	_row_loop:
		li s0, 0
		_col_loop:
			# t2 = index = row * TILEMAP_TILE_W + col
			mul t2, s1, TILEMAP_TILE_W
			add t2, t2, s0

			# t1 = level_data[t2] - ' '
			lb  t1, level_data(t2)    # t1 = character from level_data
			sub t1, t1, ' '          # t0 = the index into char_to_tile

			# tilemap_set_tile_no_update(s0, s1, char_to_tile[t1])
			move a0, s0
			move a1, s1
			lb   a2, char_to_tile(t1)
			jal  tilemap_set_tile_no_update

			# now see if we need to spawn an object
			lb  t0, char_to_obj(t1)
			beq t0, 0, _break
				# aha! which is it?
				beq t0, OBJ_PLAYER, _player
				beq t0, OBJ_HEART, _heart
				beq t0, OBJ_MSPIKE, _mspike
				j _default

				_player:
					li  t0, OBJ_PLAYER
					sw  t0, object_type
					mul t0, s0, 5
					sll t0, t0, 8
					add t0, t0, OBJ_HALF_SIZE
					sw  t0, player_x
					mul t0, s1, 5
					sll t0, t0, 8
					add t0, t0, OBJ_HALF_SIZE
					sw  t0, player_y
					j _break

				_heart:
					mul a0, s0, 5
					sll a0, a0, 8
					add a0, a0, OBJ_HALF_SIZE
					mul a1, s1, 5
					sll a1, a1, 8
					add a1, a1, OBJ_HALF_SIZE
					jal obj_new_heart
					j _break

				_mspike:
					mul a0, s0, 5
					sll a0, a0, 8
					add a0, a0, OBJ_HALF_SIZE
					mul a1, s1, 5
					sll a1, a1, 8
					add a1, a1, OBJ_HALF_SIZE
					jal obj_new_mspike
					j _break

				_default:
					print_str "error loading map: character "
					lb a0, level_data(t2)
					syscall_print_char
					println_str " unimplmented."
					syscall_exit
			_break:
		inc s0
		blt s0, TILEMAP_TILE_W, _col_loop
	inc s1
	blt s1, TILEMAP_TILE_H, _row_loop

	# commit the changes.
	jal tilemap_update_all
leave s0, s1

# ------------------------------------------------------------------------------------------------

# a0 = x, a1 = y
# returns a boolean (1/0) of whether the tile at those coordinates is solid (like a wall).
# also returns v1 = the tile type that was hit.
is_solid_tile:
enter
	jal tilemap_get_tile
	move v1, v0

	li  v0, 0
	beq v1, TILE_EMPTY,  _not_solid
	beq v1, TILE_SKY,    _not_solid
	beq v1, TILE_RING,   _not_solid
	beq v1, TILE_GOAL,   _not_solid
		li v0, 1
	_not_solid:
leave