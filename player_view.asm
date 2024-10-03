

.include "macros.asm"

.include "constants.asm"

.include "player_struct.asm"

.text

.globl player_draw
# This function draws the player sprite
player_draw:
	enter	s0
	
	la	s0, playerArray 
	lw	a0, x_coordinate(s0)
	lw	a1, y_coordinate(s0)
	la	a2, player_sprite
	jal	display_blit_5x5
	
	leave	s0
