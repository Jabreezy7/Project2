.include "box_struct.asm"

.include "macros.asm"



.globl	box_draw

.text

# This function draws all of the boxes in our game
box_draw:
	enter	s0, s1
	
	li	s0, 0
	
_box_draw_loop:
	bgt	s0, 6, _box_draw_exit
	move	a0, s0
	jal	box_get_element
	move	s1, v0
	lw	a0, x_coordinate(s1)
	lw	a1, y_coordinate(s1)
	la	a2, box_sprite
	jal	display_blit_5x5_trans
	inc	s0	
	j	_box_draw_loop
		
_box_draw_exit:		
	leave	s0, s1
	
	
	
	
