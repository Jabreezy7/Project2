.include "constants.asm"
.include "macros.asm"


			
				
.globl game
.text


game:
	enter s0

_game_while:

	jal	handle_input


	# Move stuff

	# Draw stuff
	
	beq	s0, 1, _game_active	# game start flag 
	jal	display_start_screen
	j	_update_pixel
	
_game_active:	
	jal	display_bottom_screen

	jal	display_map
	
	jal	player_draw
	
	jal	box_draw

		
_update_pixel:		
	# Must update the frame and wait
	jal	display_update_and_clear
	jal	wait_for_next_frame
	jal	player_update
	
	beq	v0, 1, _win


	# Leave if x was pressed
	lw	t0, x_pressed
	bnez	t0, _game_end
	
	
	#Start game if any key was pressed
	jal	input_get_keys_pressed
	move	t0, v0
	bnez	t0, _game_start


	
	j	_game_while
		
_win:
	li	v0, 1
	li	a0, 1
	syscall
	jal	display_win_screen
	jal	display_update_and_clear
	li	v0, 10
	syscall	

	
	
_game_start:
	li	s0, 1    	# activates game start flag
	j	_game_while	



_game_end:
	# Clear the screen
	jal	display_update_and_clear
	jal	wait_for_next_frame

	leave	s0
	
	
	
	
	
	
	
	
#Functions:




.globl contains_wall	
# This function will tell us if there is a wall, target, or open space at a given x and y coordinate
# a0 = x coordinate
# a1 = y coordinate
# v0 = 0 if there is not a wall or target, 1 if there is a wall, 2 if there is a target								
contains_wall:													
	enter	s0, s1
		
	move	s0, a0
	move 	s1, a1
			
	div	s0, s0, 5
	
	mflo	s0
	mfhi	t0
	
	bne	s0, 0, _sub_edgex
	j	_check_y
	
_sub_edgex:
	bne	t0, 0, _check_y
	sub	s0, s0, 1
	
_check_y:			
	div	s1, s1, 5
	
	mflo	s1
	mfhi	t1
	
	bne	s1, 0, _sub_edgey
	j	_check_map
	
_sub_edgey:
	bne	t1, 0, _check_map
	sub	s1, s1, 1
	
_check_map:							
	la	a0, mapMatrix 
	move	a1, s0
	move	a2, s1
	li	a3, 9
	jal 	get_matrix_address   # get the address of the wanted index in our 2d array
	
	lw	t0, (v0)
	beq	t0, 1, _is_wall
	beq	t0, 2, _is_target
	li	v0, 0
	j	_end_contains_wall
	
_is_wall:
	li	v0, 1
	j	_end_contains_wall	
	
_is_target:
	li	v0, 2	

_end_contains_wall:																																																																																																																												
	leave 	s0, s1		
	
																																																																																																																											
																																																																																																																																																																																																																																																																																																																																																																															
	
