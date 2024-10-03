
.data	

.globl	playerArray

playerArray:		.word 	20 # This represents the x-coordinate
			.word 	10 # This represents the y-coordinate
			.word	0 # This represents the move count
			
.globl player_sprite

# This matrix represents the design pattern for our player sprite
player_sprite:		.byte	0, 0, 1, 0, 0, 
				1, 1, 1, 1, 1,								
				0, 1, 1, 1, 0,
				0, 1, 0, 1, 0, 
				0, 1, 0, 1, 0			
	
										
	
			

