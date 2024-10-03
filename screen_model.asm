
.data	

# This is our map where 0's correspond to open spaces on our map, 1's walls, and 2's targets. 
.globl mapMatrix	
mapMatrix:		.word	0, 1, 1, 1, 1, 1, 1, 1, 1,
				0, 1, 2, 1, 2, 0, 0, 0, 1,
				1, 1, 0, 1, 1, 1, 0, 0, 1, 
				1, 0, 0, 0, 1, 0, 2, 0, 1, 
				1, 0, 0, 0, 0, 2, 0, 2, 1, 
				1, 0, 0, 2, 0, 0, 0, 0, 1, 
				1, 1, 1, 1, 1, 0, 2, 0, 1, 
				0, 0, 0, 0, 1, 1, 1, 1, 1 
		
# This is the design pattern for the walls on our map						
.globl pixel_pattern				
pixel_pattern:		.byte	10, 10, 11, 10, 10,
				10, 11, 11, 11, 10,				
				11, 11, 10, 11, 11,
				10, 11, 11, 11, 10,
				10, 10, 11, 10, 10	
				

# This is the design pattern for the targets on our map
.globl target_pattern
target_pattern:		.byte	0, 0, 0, 0, 0,
				0, 2, 0, 2, 0, 		
				0, 0, 2, 0, 0, 
				0, 2, 0, 2, 0, 
				0, 0, 0, 0, 0														
