.include "player_struct.asm"

.include "macros.asm"

.include "constants.asm"

.include "box_struct.asm"

.globl player_update

.text

# This function will move the player and possibly box in a certain direction depending on the user input.
# 	v0 = 1 if player has won and 0 if not
player_update:
	enter	s0, s1, s2, s3, s4
	
	la	s0, playerArray
	
	lw	s1, right_pressed
	beq	s1, 1, _go_right
	
	lw	s1, left_pressed
	beq	s1, 1, _go_left
	
	lw	s1, up_pressed
	beq	s1, 1, _go_up
	
	lw	s1, down_pressed
	beq	s1, 1, _go_down
	
	j	_end_player_update
	
	
	
_go_right:
	lw	s1, x_coordinate(s0)
	add	s1, s1, 5
	move	a0, s1
	lw	s2, y_coordinate(s0)
	move	a1, s2
	jal	check_for_box
	beq	v0, 0, _dont_move_right

	move	a0, v1
	move	s3, v1
	li	a1, 5
	li	a2, 0
	jal	move_box
	beq	v0, 0, _end_player_update
	
_dont_move_right:

	lw	s1, x_coordinate(s0)
	bgt	s1, 55, _end_player_update 
	add	s1, s1, 6
	move	a0, s1
	lw	a1, y_coordinate(s0)
	add	a1, a1, 1
	jal	contains_wall
	beq	v0, 1, _end_player_update
	sub	s1, s1, 1	
	sw	s1, x_coordinate(s0)
	lw	s1, moves(s0)
	inc	s1
	sw	s1, moves(s0)
	j	_end_player_update
	
	
	
_go_left:	

	lw	s1, x_coordinate(s0)
	sub	s1, s1, 5
	move	a0, s1
	lw	s2, y_coordinate(s0)
	move	a1, s2
	jal	check_for_box
	beq	v0, 0, _dont_move_left

	move	a0, v1
	li	a1, -5
	li	a2, 0
	jal	move_box
	beq	v0, 0, _end_player_update
	
_dont_move_left:
	
	lw	s1, x_coordinate(s0)	
	blt	s1, 5, _end_player_update
	sub	s1, s1, 1
	move	a0, s1
	lw	a1, y_coordinate(s0)
	add	a1, a1, 1
	jal	contains_wall
	beq	v0, 1, _end_player_update
	sub	s1, s1, 4
	sw	s1, x_coordinate(s0)
	lw	s1, moves(s0)
	inc	s1
	sw	s1, moves(s0)
	j	_end_player_update
	
	
_go_up:	

	lw	s1, x_coordinate(s0)
	move	a0, s1
	lw	s2, y_coordinate(s0)
	sub	s2, s2, 5
	move	a1, s2
	jal	check_for_box
	beq	v0, 0, _dont_move_up

	move	a0, v1
	li	a1, 0
	li	a2, -5
	jal	move_box
	beq	v0, 0, _end_player_update
	
_dont_move_up:
	
	
	lw	s1, y_coordinate(s0)
	blt	s1, 5, _end_player_update
	sub	s1, s1, 1
	move	a1, s1
	lw	a0, x_coordinate(s0)
	add	a0, a0, 1
	jal	contains_wall
	beq	v0, 1, _end_player_update	
	sub	s1, s1, 4
	sw	s1, y_coordinate(s0)
	lw	s1, moves(s0)
	inc	s1
	sw	s1, moves(s0)
	j	_end_player_update	
	
_go_down:

	lw	s1, x_coordinate(s0)
	move	a0, s1
	lw	s2, y_coordinate(s0)
	add	s2, s2, 5
	move	a1, s2
	jal	check_for_box
	beq	v0, 0, _dont_move_down

	move	a0, v1
	li	a1, 0
	li	a2, 5
	jal	move_box
	beq	v0, 0, _end_player_update
	
_dont_move_down:

		
	lw	s1, y_coordinate(s0)
	bgt	s1, 55, _end_player_update	
	add	s1, s1, 6
	move	a1, s1
	lw	a0, x_coordinate(s0)
	add	a0, a0, 1
	jal	contains_wall
	beq	v0, 1, _end_player_update
	sub	s1, s1, 1
	sw	s1, y_coordinate(s0)
	lw	s1, moves(s0)
	inc	s1
	sw	s1, moves(s0)
	j	_end_player_update	
	
	
_end_player_update:
	jal	check_win_condition
	bne	v0, 1, _update_status
	j	_end_player_function

_update_status:
	li	v0, 0
	
_end_player_function:			
	leave	s0, s1, s2, s3, s4
	
	
	

.globl move_box
# This function moves a desired box by the desired inputs and returns 1 if it can move there and 0 if it was unable to move there
#	a0 = index of box you want to move
#	a1 = how much you want to change x-coordinate
#	a2 = how much you want to change y-coordinate
#	v0 = 0 if move was unavailable and 1 if move was available
move_box:	
	enter	s0, s1, s2, s3, s4
	
	move	s1, a1
	move	s2, a2
	
	
	jal	box_get_element
	move	s0, v0
	
	lw	s3, x_coordinate(s0)
	add	s3, s3, s1
	lw	s4, y_coordinate(s0)
	add	s4, s4, s2
	
	inc	s3
	inc	s4
	move	a0, s3
	move	a1, s4
	jal	contains_wall
	beq	v0, 1, _move_unavailable
	
	
	dec	s3
	dec	s4
	
	move	a0, s3
	move	a1, s4
	jal	check_for_box
	beq	v0, 1, _move_unavailable
	
	sw	s3, x_coordinate(s0)
	sw	s4, y_coordinate(s0)
	j	_move_available
	
	
_move_unavailable:
	li	v0, 0	
	j	_move_box_end
	
_move_available:	
	li	v0, 1
	j	_move_box_end	
	
	
_move_box_end:
	leave	s0, s1, s2, s3, s4
	
	



.globl check_for_box
# This function tells us if there is a box at a given x and y coordinate and if there is tells us the index of the box that is there.
# 	a0 = x-coordinate
# 	a1 = y-coordinate
# 	v0 = 1 if there is a box at this location and 0 if not
# 	v1 = index of box at this location
check_for_box:	
	enter	s0, s1, s2, s3, s4
	
	move	s0, a0
	move	s1, a1
	
	li	s2, 0
_check_box_loop:
	bgt	s2, 6, _no_box
	move	a0, s2
	jal	box_get_element
	move	s3, v0
	lw	s4, x_coordinate(s3)
	bne	s0, s4, _iterate_counter
	lw	s4, y_coordinate(s3)
	bne	s1, s4, _iterate_counter
	li	v0, 1
	move	v1, s2
	j	_check_box_end
	
	
_iterate_counter:
	inc	s2
	j	_check_box_loop	

_no_box:
	li	v0, 0
	j	_check_box_end

	
_check_box_end:	
	leave	s0, s1, s2, s3, s4
	
	
	
	
	
	
.globl	check_win_condition
# This function checks if all boxes are placed in target positions
# v0 = 1 if all boxes are in target position and 0 if not
check_win_condition:
	enter	s0, s1, s2, s3, s4
	
	#li	s1, 0 # amount of correct placements
	
	li	s0, 0 # counter variable for boxes
_check_win_loop:
	bgt	s0, 6, _you_won
	move	a0, s0
	jal	box_get_element
	move	s2, v0
	lw	s3, x_coordinate(s2)
	lw	s4, y_coordinate(s2)
	
	
	move	a0, s3
	add	a0, a0, 5
	move	a1, s4
	add	a1, a1, 5
	jal	contains_wall
	beq	v0, 2, _increment_alligned
	li	v0, 0
	j	_check_win_end
	
_increment_alligned:
	inc	s0
	j	_check_win_loop	
	
_you_won:
	li	v0, 1
	j	_check_win_end	
	
	
_check_win_end:		
	leave	s0, s1, s2, s3, s4


