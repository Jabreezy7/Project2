
.include "macros.asm"

.include "constants.asm"

.include "player_struct.asm"


.text



.globl display_map
# This function displays the map
display_map:
	enter	s0, s1

	li	s0, 0      # initializing row counter variable
_for_2d_array_row:
	bge	s0, 8, _exit_2d_array   # for(s0<5)
	

	li	s1, 0	   # initializing column counter variable		
_for_2d_array_col:
	bge	s1, 9, _end_for_2d_array_row   # for(s1<5)
	
	la	a0, mapMatrix 
	move	a1, s0
	move	a2, s1
	li	a3, 9
	jal 	get_matrix_address   # get the address of the wanted index in our 2d array
	
	lw	t0, (v0)
	beq	t0, 1, _add_wall
	beq	t0, 2, _add_target
	j	_iterate_row
	
	
_add_wall:	
	mul	a0, s0, 5
	mul	a1, s1, 5
	la	a2, pixel_pattern
	jal	display_blit_5x5
	j	_iterate_row
	
_add_target:
	mul	a0, s0, 5
	mul	a1, s1, 5
	la	a2, target_pattern
	jal	display_blit_5x5_trans
	j	_iterate_row	
	
	
_iterate_row:	
	inc	s1
	j	_for_2d_array_col
	
_end_for_2d_array_row:
	inc	s0
	j	_for_2d_array_row
	
_exit_2d_array:
	leave	s0, s1
	
	


				
.globl get_matrix_address
# This function calculates the address of the element (i, j) in our map matrix
# Inputs:
#	 a0: The base address of the matrix
#	 a1: The index (i) of the row
#	 a2: The index (j) of the column
#	 a3: The number of elements in a row
# Outputs:
#	 v0: The address of the element
get_matrix_address:

	enter	s0 s1 s2 s3
	
	move	s0, a0
	move	s1, a1
	move	s2, a2
	move	s3, a3
	
	mul	t0, s3, 4     # b value for matrix
	mul	t0, t0, s1    # bi value for matrix
	add	s0, s0, t0    # A + bi value (our A value for the row we wish to enter)
	
	
	mul	t0, s2, 4     # bi value for row
	add	v0, s0, t0    # A + bi value
	
	leave	s0, s1, s2, s3		
	
	
	
	
.globl display_start_screen						
# This function displays the start screen 			
display_start_screen:
	enter
	
	li	a0, 5
	li	a1, 2
	lstr	a2, "PRESS ANY"
	jal	display_draw_text
	
	li	a0, 15
	li	a1, 10
	lstr	a2, "KEY TO"
	jal	display_draw_text
	
	li	a0, 17
	li	a1, 18
	lstr	a2, "START"
	jal	display_draw_text
	
	leave		
	
										
.globl display_bottom_screen																																																				
# This function displays the bottom menu of the game (the move count)
display_bottom_screen:
	enter 	s0
			
	li	a0, 0
	li	a1, 55
	li	a2, 64
	li 	a3, COLOR_BLUE
	jal	display_draw_hline
	
	li	a0, 2
	li	a1, 57
	lstr	a2, "Moves: "
	jal	display_draw_text
	
	li	a0, 40
	li	a1, 57
	la	s0, playerArray
	lw	a2, moves(s0)
	jal	display_draw_int
	
	leave	s0	
	
	
.globl display_win_screen
# This function displays the win screen	
display_win_screen:
	enter
	
	li	a0, 10
	li	a1, 20
	lstr	a2, "YOU WON "
	jal	display_draw_text
	
	
	li	a0, 5
	li	a1, 57
	lstr	a2, "Moves: "
	jal	display_draw_text
	
	li	a0, 45
	li	a1, 57
	la	s0, playerArray
	lw	a2, moves(s0)
	jal	display_draw_int
	
	leave
