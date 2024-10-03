.include "macros.asm"

.include "box_struct.asm"


.data	

.globl box_sprite

# This is the design pattern for our box sprite

box_sprite:		.byte	9, 9, 9, 9, 9, 
				9, -1, 9, -1, 9,								
				9, 9, -1, 9, 9,
				9, -1, 9, -1, 9, 
				9, 9, 9, 9, 9	

.globl	array_of_box_structs

array_of_box_structs:		.word 	15 # This represents the x-coordinate 	\
				.word 	10 # This represents the y-coordinate	  } Box struct 1
				.word	0 # This represents the move count	/
				.word 	20 # This represents the x-coordinate 	\
				.word 	15 # This represents the y-coordinate	  } Box struct 2
				.word	0 # This represents the move count	/
				.word 	20 # This represents the x-coordinate 	\s
				.word 	20 # This represents the y-coordinate	  } Box struct 3
				.word	0 # This represents the move count	/
				.word 	5 # This represents the x-coordinate 	\
				.word 	30 # This represents the y-coordinate	  } Box struct 4
				.word	0 # This represents the move count	/
				.word 	15 # This represents the x-coordinate 	\
				.word 	30 # This represents the y-coordinate	  } Box struct 5
				.word	0 # This represents the move count	/
				.word 	20 # This represents the x-coordinate 	\
				.word 	30 # This represents the y-coordinate	  } Box struct 6
				.word	0 # This represents the move count	/
				.word 	25 # This represents the x-coordinate 	\
				.word 	30 # This represents the y-coordinate	  } Box struct 7
				.word	0 # This represents the move count	/
			
			
.text						
.globl box_get_element
# This function gets the address of a desired box
#	a0 = index of box to get address
box_get_element:
	enter
	
	la	t0, array_of_box_structs
				# First we load the address of the beginning of the array
	mul	t1, a0, box_size	# Then we multiply the index by 12
				#	(the size of a pixel struct) to calculate the offset
	add	v0, t0, t1	# Finally add the offset to the address of the beginning of the array
	# Now v0 contains the address of the element i of the array
	
	leave
				
			
			
			
