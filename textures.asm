
.data

# Array of pointers to the textures for each tile, ordered by tile type.
tile_textures: .word
	tex_empty   # TILE_EMPTY
	tex_sky     # TILE_SKY
	tex_brick   # TILE_BRICK
	tex_spike   # TILE_SPIKE
	tex_spring  # TILE_SPRING
	tex_crumble # TILE_CRUMBLE
	tex_ring    # TILE_RING
	tex_goal    # TILE_GOAL

tex_empty: .byte
     0  0  0  0  0
     0  0  0  0  0
     0  0  0  0  0
     0  0  0  0  0
     0  0  0  0  0

tex_brick: .byte
	 2 10  2  2  2
	10 10 10 10 10
	 2  2  2 10  2
	 2  2  2 10  2
	10 10 10 10 10

tex_sky: .byte
	 5  5  5  5  5
	 5  5  5  5  5
	 5  5  5  5  5
	 5  5  5  5  5
	 5  5  5  5  5

tex_spike: .byte
	 7  5  5  5  7
	 5  7 15  7  5
	 5 15  8 15  5
	 5  7 15  7  5
	 7  5  5  5  7

tex_spring: .byte
	 3  3  3  3  3
	 3  3  3  3  3
	 5 15 15 15  5
	 5  8  8  8  5
	 5 15 15 15  5

tex_crumble: .byte
	 2 10  2  2 10
	10  5 10 10 10
	10  2  2  5  2
	 2  2  2 10  2
	10 10  5 10 10

tex_ring: .byte
	 5  3  3  5  5
	 3  5  5  3  5
	 3  5  5  3  5
	 5  3  3  5  5
	 5  5  5  5  5

tex_goal: .byte
	 0  7  0  7  0
	 7  0  7  0  7
	 0  7  0  7  0
	 7  0  7  0  7
	 0  7  0  7  0

# -------------------------------------------------------------------------------------------------

# Ring, but used for the HUD
tex_hud_ring: .byte
	-1  3  3 -1 -1
	 3 -1 -1  3 -1
	 3 -1 -1  3 -1
	-1  3  3 -1 -1
	-1 -1 -1 -1 -1

# -------------------------------------------------------------------------------------------------

# Player texture (ORB)
tex_player: .byte
	-1  1  1  1 -1
	 1  7  1  1  9
	 1  1  1  1  9
	 1  1  1  9  9
	-1  9  9  9 -1

# -------------------------------------------------------------------------------------------------

# Heart texture (health).
tex_heart: .byte
	-1  1 -1  1 -1
	 1  1  1  1  1
	 1  1  1  1  1
	-1  1  1  1 -1
	-1 -1  1 -1 -1

# -------------------------------------------------------------------------------------------------

# Moving spike object texture.
tex_mspike: .byte
	 7 -1 -1 -1  7
	-1  7 15  7 -1
	-1 15  1 15 -1
	-1  7 15  7 -1
	 7 -1 -1 -1  7

# -------------------------------------------------------------------------------------------------

# Turret object texture.
tex_turret: .byte
	-1 -1  7 15  8
	-1  7 15 15  8
	 7 15  1 15  8
	-1 15 15 15  8
	-1 -1 15  8  0