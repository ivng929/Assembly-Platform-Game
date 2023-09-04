#####################################################################
#
# CSCB58 Summer 2023 Assembly Final Project
# University of Toronto, Scarborough
#
# Student: Ivy Nguyen, 1008717612, nguy3180, caomp.nguyen@mail.utoronto.ca
#
# Bitmap Display Configuration:
# - Unit width in pixels: 4
# - Unit height in pixels: 4
# - Display width in pixels: 512
# - Display height in pixels: 256
# - Base Address for Display: 0x10008000 ($gp)
#
# Which milestones have been reached in this submission?
# (See the assignment handout for descriptions of the milestones)
# - Milestone 3
#
# Which approved features have been implemented for milestone 3?
# (See the assignment handout for the list of additional features)
# 1. Health		(2 marks)
# 2. Fail condition	(1 mark)
# 3. Moving Objects	(2 marks)
# 4. Moving Platforms	(2 marks)
# 5. Pick-up effects	(2 marks)
#
# Link to video demonstration for final submission:
# - https://www.youtube.com/watch?v=xKQJ35VcuA8
#
# Are you OK with us sharing the video with people outside course staff?
# - yes
#
# Any additional information that the TA needs to know:
# - (write here, if any)
#
#####################################################################



# SIZE AND ADDRESS
.eqv BASE_ADDRESS 0x10008000
.eqv SCR_WIDTH 512
#COLOR
.eqv SCREEN_COLOR 0x00ffdddd
.eqv RED 0x00ff0000
.eqv ORANGE 0x00fc4e03
.eqv WHITE 0x00ffffff
.eqv GREEN  0x0033ffe3 #0x00ff00
.eqv PURPLE 0x00cf9fff
.eqv BLACK 0x000000
.eqv FLAGdarkcolor 0x00031cfc
.eqv FLAGcolor 0x0003e7fc
.eqv PlatformColor 0x00420420
.eqv PLIGHT 0x007863ff
.eqv PDARK 0x0020127d
#COORDINATE
#### Player Info
.eqv Px 16
.eqv Py 12800
.eqv Ph 6
.eqv Pw 5
.eqv JumpHeight 18 # used to be 22
##### Platform info
.eqv PFw 25
.eqv PF1x 0
.eqv PF1y 29696 # 58 * 512

.eqv PF3w 45
.eqv PF3x 316 # 79 * 4
.eqv PF3y 25088  # 49 * 512

.eqv PF4w 12
.eqv PF4x 96 # 24 *4
.eqv PF4y 25088 # 49 * 512

.eqv PF5w 40
.eqv PF5x 148 # 37 *4
.eqv PF5y 20480 # 40 * 512

.eqv PF7w 40
.eqv PF7x 148 # 37 *4
.eqv PF7y 28672 # 56 * 512

.eqv PF9w 20
.eqv PF9x 428 # 107 *4
.eqv PF9y 10240 # 20 * 512

# Moving platforms
.eqv PF2w 10
.eqv PF2x 280 #70		#136 # 34
.eqv PF2y 12800 # 25			#29696  # 58 * 512

.eqv PF6w 10
.eqv PF6x 76 #19		#136 # 34
.eqv PF6y 13824 # 27		#29696  # 58 * 512

.eqv PF8w 10
.eqv PF8x 360 # 90		
.eqv PF8y 14848 # 29		

# Enemies:
.eqv ENMx 408 # 102 * 4
.eqv ENMy 19968 # 39 * 512 (PF3y - 9 * 512)
.eqv ENMcolor 0x0009ec27

.eqv ENM1shiftamount 20

.eqv ENM2x 204 # 51 * 4
.eqv ENM2y 15360 # 30 * 512 (PF5y - 9 * 512)
.eqv ENM2shiftamount 15

# hearts
.eqv H1x 220 # 55
.eqv H1y 25600 # 50

.eqv H2x 156 # 39
.eqv H2y 17408 # 34

	# black heart
.eqv H3x 108 # 27
.eqv H3y 22016 # 43
.eqv H3color 0x000000

# Other pick-ups
# T - pick up
.eqv T1x 96 #24
.eqv T1y 11264 #22
.eqv T1color 0x00fc4e03

# Flag
.eqv Flagx 452 # 113
.eqv Flagy 20992 # 41

################# DATA SECTION #####################################
.data
	# player address store in $s1: 12800 offset from BASE_ADDRESS, $s4 for Px, $s5 for Py
	# enemy 1 address stores in $s6
	heart2picked: .word 0
	heart1picked: .word 0
	heart3picked: .word 0
	T1picked: .word 0
	FLAGpicked: .word 0
	
	platform2x: .word PF2x
	platform2dir: .word 0 # 0 then move right, if 1 then move left
	platform2refresh: .word 10
	
	platform6x: .word PF6x
	platform6dir: .word 0 # 0 then move right, if 1 then move left
	platform6refresh: .word 15
	
	platform8x: .word PF8x
	platform8dir: .word 0 # 0 then move right, if 1 then move left
	platform8refresh: .word 15
	
	ENM1refresh: .word 10
	ENM1dir: .word 1 # 1 then moves left, 0 then right
	ENM1shift: .word 20
	ENM1xcor: .word 408
	
	ENM2refresh: .word 10
	ENM2dir: .word 0 # 1 then moves left, 0 then right
	ENM2shift: .word ENM2shiftamount
	ENM2xcor: .word ENM2x
	
	heartlives: .word 3
	collideEffect: .word 100

################## MAIN ##############################################
.globl main
.text

main:
	jal drawScreen
	li $t0, BASE_ADDRESS
	li $t1, 0x00ff00
	li, $s4, Px
	li, $s5, Py
	
	li $t1, BASE_ADDRESS
	addi $t1, $t1, H1x
	addi $t1, $t1, H1y
	move $a0, $t1
	li $a1, RED
	jal drawHeart
	
	li $t1, BASE_ADDRESS
	addi $t1, $t1, H2x
	addi $t1, $t1, H2y
	move $a0, $t1
	li $a1, RED
	jal drawHeart
	
	li $t1, BASE_ADDRESS
	addi $t1, $t1, H3x
	addi $t1, $t1, H3y
	move $a0, $t1
	li $a1, H3color
	jal drawHeart
	
	## reset heart 1 and 2 and 3
	la $t0, heart1picked
	li $t2, 0
	sw $t2, 0($t0)
	
	la $t0, heart2picked
	li $t2, 0
	sw $t2, 0($t0)
	
	la $t0, heart3picked
	li $t2, 0
	sw $t2, 0($t0)
	
	## reset T1
	la $t0, T1picked
	li $t2, 0
	sw $t2, 0($t0)
	
	li $t1, BASE_ADDRESS
	addi $t1, $t1, T1x
	addi $t1, $t1, T1y
	move $a0, $t1
	li $a1, T1color
	jal drawTpickup
	
	# reset heart lives
	la $t0, heartlives
	li $t1, 3
	sw $t1, 0($t0)
	
	# reset flag
	li $t2, 0
	la $t0, FLAGpicked
	sw $t2, 0($t0)
	
mainloop:
	####### DRAW PLATFORMS  AND PLAYER ##########
	li $a0, PF1x
	li $a1, PF1y
	li $a2, PFw
	jal drawPlatForm
	
	li $a0, PF3x
	li $a1, PF3y
	li $a2, PF3w
	jal drawPlatForm
	
	li $a0, PF4x
	li $a1, PF4y
	li $a2, PF4w
	jal drawPlatForm
	
	li $a0, PF5x
	li $a1, PF5y
	li $a2, PF5w
	jal drawPlatForm
	
	li $a0, PF9x
	li $a1, PF9y
	li $a2, PF9w
	jal drawPlatForm
	
	la $t1, T1picked
	lw $t2, 0($t1)
	beq $t2, 1, drawPF7
	j donePF7
drawPF7:
	li $a0, PF7x
	li $a1, PF7y
	li $a2, PF7w
	jal drawPlatForm
donePF7:

		### DRAW PF1 guard ####
	li $t2, BASE_ADDRESS
	addi $t2, $t2, 92 #22
	addi $t2, $t2, 30208 # 59
	li $t3, PlatformColor
	sw $t3, 0($t2)
	sw $t3, 4($t2)
	sw $t3, 512($t2)
	sw $t3, 516($t2)
	sw $t3, 1024($t2)
	sw $t3, 1028($t2)
	sw $t3, 1536($t2)
	sw $t3, 1540($t2)
	sw $t3, 2048($t2)
	sw $t3, 2052($t2)
	
		##### DRAW PLAYER ########
	add $s1, $t0, $s4  ## this 2 lines to compute current 
	add $s1, $s1, $s5  ##  address of Player, store in $s1
	move $a0, $s1
	jal drawPlayer
	
		##### DRAW ENEMY #######
	# draw Enemy 1
	#la $t3, ENM1xcor
	#lw $t1, 0($t3)
	lw $t1, ENM1xcor
	li $s6, BASE_ADDRESS
	add $s6, $s6, $t1
	addi $s6, $s6, ENMy
	move $a2, $s6
	jal drawEnemy
	
	la $t3, ENM1refresh
	lw $t1, 0($t3)
	beq $t1, 10, movingENM1
	addi $t1, $t1, 1
	la $t2, ENM1refresh
	sw $t1, 0($t2)
	j doneMovingENM1
movingENM1:
	la $t1, ENM1refresh
	li $t2, 0
	sw $t2, 0($t1) # set ENM1refresh to 0
	### do some actions .....
	la $t2, ENM1shift
	lw $t2, 0($t2)
	beq $t2, 0, ENM1changedir
	
	# substract one from shift
	la $t1, ENM1shift
	lw $t1, 0($t1)
	subi $t1, $t1, 1
	la $t2, ENM1shift
	sw $t1, 0($t2)
	
		#delete ENM1
	li $a0, 9
	li $a1, 7
	move $a2, $s6
	li $a3, SCREEN_COLOR
	jal drawBlk
		#redraw ENM1 at a different location
	la $t2, ENM1dir
	lw $t2, 0($t2)
	beq $t2, 1, ENM1goleft
	la $t3, ENM1xcor
	lw $t1, 0($t3)
	addi $t1, $t1, 4
	la $t2, ENM1xcor
	sw $t1, 0($t2)
	j doneMovingENM1
ENM1goleft:
	la $t3, ENM1xcor
	lw $t1, 0($t3)
	subi $t1, $t1, 4
	la $t2, ENM1xcor
	sw $t1, 0($t2)
	j doneMovingENM1
	
ENM1changedir:

	la $t1, ENM1shift
	li $t2, ENM1shiftamount
	sw $t2, 0($t1) # set ENM1shift to 0

	la $t2, ENM1dir
	lw $t2, 0($t2)
	beq $t2, 1, setENM1dirZero
	li $t1, 1
	la $t2, ENM1dir
	sw $t1, 0($t2)
	j doneMovingENM1
setENM1dirZero:
	li $t1, 0
	la $t2, ENM1dir
	sw $t1, 0($t2)
	j doneMovingENM1
doneMovingENM1:

	########## DRAW ENEMY 2 ##########
	# draw Enemy 2
	la $t3, ENM2xcor
	lw $t1, 0($t3)
	li $t8, BASE_ADDRESS
	add $t8, $t8, $t1
	addi $t8, $t8, ENM2y
	move $a2, $t8
	jal drawEnemy
	
	la $t1, ENM2refresh
	lw $t1, 0($t1)
	beq $t1, 10, movingENM2
	addi $t1, $t1, 1
	la $t2, ENM2refresh
	sw $t1, 0($t2)
	j doneMovingENM2
movingENM2:
	la $t1, ENM2refresh
	li $t2, 0
	sw $t2, 0($t1) # set ENM2refresh to 0
	### do some actions .....
	la $t2, ENM2shift
	lw $t2, 0($t2)
	beq $t2, 0, ENM2changedir
	
	# substract one from shift
	la $t1, ENM2shift
	lw $t1, 0($t1)
	subi $t1, $t1, 1
	la $t2, ENM2shift
	sw $t1, 0($t2)
	
		#delete ENM2
	li $a0, 9
	li $a1, 7
	
	la $t3, ENM2xcor
	lw $t1, 0($t3)
	li $t8, BASE_ADDRESS
	add $t8, $t8, $t1
	addi $t8, $t8, ENM2y
	move $a2, $t8
	
	li $a3, SCREEN_COLOR
	jal drawBlk
		#redraw ENM2 at a different location
	la $t2, ENM2dir
	lw $t2, 0($t2)
	beq $t2, 1, ENM2goleft
	la $t1, ENM2xcor
	lw $t1, 0($t1)
	addi $t1, $t1, 4
	la $t2, ENM2xcor
	sw $t1, 0($t2)
	j doneMovingENM2
ENM2goleft:
	la $t1, ENM2xcor
	lw $t1, 0($t1)
	subi $t1, $t1, 4
	la $t2, ENM2xcor
	sw $t1, 0($t2)
	j doneMovingENM2
	
ENM2changedir:

	la $t1, ENM2shift
	li $t2, ENM2shiftamount
	sw $t2, 0($t1) # set ENM2shift to 0

	la $t2, ENM2dir
	lw $t2, 0($t2)
	beq $t2, 1, setENM2dirZero
	li $t1, 1
	la $t2, ENM2dir
	sw $t1, 0($t2)
	j doneMovingENM2
setENM2dirZero:
	li $t1, 0
	la $t2, ENM2dir
	sw $t1, 0($t2)
	j doneMovingENM2
doneMovingENM2:

		

    
    	#li $s6, BASE_ADDRESS
	#addi $s6, $s6, ENMx
	#addi $s6, $s6, ENMy
	#move $a2, $s6
	#j drawEnemy
    #doneDrawEnenmy:
    	
	######## gravity #######
	j gravity # went from jal to j
    donePullDown: 
	
	####### PRESSING KEYS ###############
	li $t4, 0xffff0000
	lw $t3, 0($t4)
	beq $t3, 1, keypressed
	j doneKeyPress
	
keypressed:
	lw $t2, 4($t4)
	beq $t2, 0x70, main
	beq $t2, 0x71, GameOver
	beq $t2, 0x64, moveright
	beq $t2, 0x61, moveleft
	beq $t2, 0x77, jump
	
doneKeyPress:
	
	##### MOVING PLATFORM ########
	
	#### PF 2 ######
	lw $a0, platform2x
	li $a1, PF2y
	li $a2, PF2w
	jal drawPlatForm
MovPF2:
	lw $t1, platform2refresh
	beq $t1, 10, setbackPF2
	la $t0, platform2refresh
	addi $t1, $t1, 1
	sw $t1, 0($t0)
	j doneMovPF2
setbackPF2:
	la $t0, platform2refresh
	li $t1, 0
	sw $t1, 0($t0)
	# the refresh is 5 now, move PF2
	lw $a0, platform2x
	li $a1, PF2y
	li $a2, PF2w
	j movingPlatform2
  	doneMovPF2: 
  	
  	##### PF 6 ############
  	lw $a0, platform6x
	li $a1, PF6y
	li $a2, PF6w
	jal drawPlatForm
MovPF6:
	lw $t1, platform6refresh
	beq $t1, 15, setbackPF6
	la $t0, platform6refresh
	addi $t1, $t1, 1
	sw $t1, 0($t0)
	j doneMovPF6
setbackPF6:
	la $t0, platform6refresh
	li $t1, 0
	sw $t1, 0($t0)
	# the refresh is 0 now, move PF6
	lw $a0, platform6x
	li $a1, PF6y
	li $a2, PF6w
	j movingPlatform6
  	doneMovPF6: 
  	
  	##### PF 8 ############
  	lw $a0, platform8x
	li $a1, PF8y
	li $a2, PF8w
	jal drawPlatForm
MovPF8:
	lw $t1, platform8refresh
	beq $t1, 15, setbackPF8
	la $t0, platform8refresh
	addi $t1, $t1, 1
	sw $t1, 0($t0)
	j doneMovPF8
setbackPF8:
	la $t0, platform8refresh
	li $t1, 0
	sw $t1, 0($t0)
	# the refresh is 0 now, move PF8
	lw $a0, platform8x
	li $a1, PF8y
	li $a2, PF8w
	j movingPlatform8
  	doneMovPF8: 
  	###### PICK-UP HEART ##################
  	
  	
  		#### heart 1 - heart next to monster
  	lw $t1, heart1picked # 1 if picked, 0 if not
    	beq, $t1, 1, donePickH1
    	li $t0, BASE_ADDRESS
	addi $t0, $t0, H1x
	addi $t0, $t0, H1y
	lw $t2, 4($t0)
	bne, $t2, RED, PickH1
	lw $t1, 12($t0)
	bne, $t2, RED, PickH1
    	lw $t2, 512($t0)
    	bne, $t2, RED, PickH1
	lw $t2, 520($t0)
	bne, $t2, RED, PickH1
	lw $t2, 528($t0)
	bne, $t2, RED, PickH1
	j donePickH1
PickH1:
	li $t1, BASE_ADDRESS
	addi $t1, $t1, H1x
	addi $t1, $t1, H1y
	move $a0, $t1
	li $a1, SCREEN_COLOR
	jal drawHeart
	## change heart2picked to 1
	la $t0, heart1picked
	li $t2, 1
	sw $t2, 0($t0)
	### some other effects to be implemented ...
	### ......
	### ........
	# add one heart to lives to display
	lw $t1, heartlives
	la $t0, heartlives
	addi $t1, $t1, 1
	sw $t1, 0($t0)

donePickH1:
  	
  		##### heart 2 - the first h on second platform ######
    	lw $t1, heart2picked # 1 if picked, 0 if not
    	beq, $t1, 1, donePickH2
    	li $t0, BASE_ADDRESS
	addi $t0, $t0, H2x
	addi $t0, $t0, H2y
	lw $t2, 4($t0)
	bne, $t2, RED, PickH2
	lw $t1, 12($t0)
	bne, $t2, RED, PickH2
    	lw $t2, 512($t0)
    	bne, $t2, RED, PickH2
	lw $t2, 520($t0)
	bne, $t2, RED, PickH2
	lw $t2, 528($t0)
	bne, $t2, RED, PickH2
	j donePickH2
PickH2:
	li $t1, BASE_ADDRESS
	addi $t1, $t1, H2x
	addi $t1, $t1, H2y
	move $a0, $t1
	li $a1, SCREEN_COLOR
	jal drawHeart
	## change heart2picked to 1
	la $t0, heart2picked
	li $t2, 1
	sw $t2, 0($t0)

	# add one heart to lives to display
	lw $t1, heartlives
	la $t0, heartlives
	addi $t1, $t1, 1
	sw $t1, 0($t0)

donePickH2:

	###### Pick Heart 3 - black heart on central PF 5
    	lw $t1, heart3picked # 1 if picked, 0 if not
    	beq, $t1, 1, donePickH3
    	li $t0, BASE_ADDRESS
	addi $t0, $t0, H3x
	addi $t0, $t0, H3y
	lw $t2, 4($t0)
	bne, $t2, H3color, PickH3
	lw $t1, 12($t0)
	bne, $t2, H3color, PickH3
    	lw $t2, 512($t0)
    	bne, $t2, H3color, PickH3
	lw $t2, 520($t0)
	bne, $t2, H3color, PickH3
	lw $t2, 528($t0)
	bne, $t2, H3color, PickH3
	j donePickH3
PickH3:
	li $t1, BASE_ADDRESS
	addi $t1, $t1, H3x
	addi $t1, $t1, H3y
	move $a0, $t1
	li $a1, SCREEN_COLOR
	jal drawHeart
	## change heart2picked to 1
	la $t0, heart3picked
	li $t2, 1
	sw $t2, 0($t0)
	
	# substract one heart to lives to display
	lw $t1, heartlives
	la $t0, heartlives
	subi $t1, $t1, 1
	sw $t1, 0($t0)

donePickH3:

	# Pick up T-pick up
	lw $t1, T1picked # 1 if picked, 0 if not
    	beq, $t1, 1, donePickT1
    	li $t0, BASE_ADDRESS
	addi $t0, $t0, T1x
	addi $t0, $t0, T1y
	li $t3, T1color
	lw $t2, 0($t0)
	bne, $t2, $t3, PickT1
	lw $t2, 4($t0)
	bne, $t2, $t3, PickT1
	lw $t2, 8($t0)
	bne, $t2, $t3, PickT1
	lw $t2, 516($t0)
	bne, $t2, $t3, PickT1
	
	j donePickT1
PickT1:
	li $t1, BASE_ADDRESS
	addi $t1, $t1, T1x
	addi $t1, $t1, T1y
	move $a0, $t1
	li $a1, SCREEN_COLOR
	jal drawTpickup
	## change T1picked to 1
	la $t0, T1picked
	li $t2, 1
	sw $t2, 0($t0)
donePickT1:
	
	
	########### COLLIDE W ENEMIES 1 #####
	lw $t1, 1556($s1)######
	beq $t1, ENMcolor, collideENM1 ####
	lw $t1, 1532($s1)######
	beq $t1, ENMcolor, collideENM1 ####
	j doneCollideENM1
collideENM1:
	move $a0, $s1
	li $a1, ORANGE
	jal delPlayer
	
	move $a0, $s1
	li $a1, SCREEN_COLOR
	jal delPlayer
	
	lw $t1, heartlives
	la $t0, heartlives
	subi $t1, $t1, 1
	sw $t1, 0($t0)
	
	li $s4, Px
	li $s5, Py
	add $s1, $t0, $s4  ## this 2 lines to compute current 
	add $s1, $s1, $s5

	
doneCollideENM1:

	##### CHECK WHEN PLAYER FALLS OUT OF SCREEN #########
    	bge $s5, 29184, FallOut # 5, 32768//64
    	j doneFallOut
FallOut:
	j GameOver
	### we want the game to end here. Gameover
	
doneFallOut:
	############### GAME OVER WHEN NUM OF HEARTS IS ZERO ####
	lw $t2, heartlives
	ble $t2, 0, ZeroHeart
	j doneZeroHeart
ZeroHeart: 
	j GameOver
doneZeroHeart: 
	################ DISPLAY HEARTS ##############
displayHeart: # $t2 store the number of hearts
	lw $t2, heartlives
	li $t0, BASE_ADDRESS
	addi $t0, $t0, 1024
	li $a1, RED
    heartloop:
    	beq $t2, 0, doneHeartloop
    	addi $t0, $t0, 16
    	move $a0, $t0
    	jal drawHeart
    	addi $t0, $t0, 16
    	subi $t2, $t2, 1
 	j heartloop
    doneHeartloop:
   	li $a1, SCREEN_COLOR
    	addi $t0, $t0, 16
    	move $a0, $t0
    	jal drawHeart
    	
    	
    	########### DRAW FLAG ##############
    	la $t0, FLAGpicked
    	lw $t1, 0($t0)
    	beq $t1, 0, drawFLag
    	# else, jump to GameOver
    	j GameOver
    	j doneDrawFlag
drawFLag:    	
    	li $a0, 7
    	li $a1, 1
    	li $t0, BASE_ADDRESS
    	addi $t0, $t0, Flagx
    	addi $t0, $t0, Flagy
    	move $a2, $t0
    	li $a3, FLAGdarkcolor
    	jal drawBlk
    	
    	li $a0, 4
    	li $a1, 5
    	li $t0, BASE_ADDRESS
    	addi $t0, $t0, Flagx
    	addi $t0, $t0, Flagy
    	addi $t0, $t0, 4
    	move $a2, $t0
    	li $a3, FLAGcolor
    	jal drawBlk
doneDrawFlag:

	# pick-up flag
	move $t1, $s1
	addi $t1, $t1, 8
	lw $t2, 0($t1)
	beq $t2, FLAGcolor, PickUpFlag 
	j donePickUpFlag
PickUpFlag:
	li $t2, 1
	la $t0, FLAGpicked
	sw $t2, 0($t0)
donePickUpFlag:
    	
	########### SLEEP ###############
	li $v0, 32
	li $a0, 4
	syscall
	j mainloop
	
####################### EXIT ##############
exit:
	li $v0, 10
	syscall
##########################################

gravity:
	# need to change the condition of pull down: do NOT pull down when the block below player is (PlatformColor)
	
	#li $t1, 14080  # the bottom of the screen <--  delete this
	
	move $t1, $s1 # load the current address of player to $t1
	add $t2, $t1, 3076 # compute the block below the first leg (1540 = 1*4 + Ph * SCR_WITDH)
	add $t3, $t1, 3084 # compute block below second  leg
	lw $t4, 0($t2) # $t4 = color in the block below first leg
	lw $t5, 0($t3) # $t5 = color in the block below second leg
	
	# if one of the first or second leg stand on the platform
	beq $t4, PlatformColor, donePullDown
	beq $t5, PlatformColor, donePullDown
	beq $t4, ENMcolor, donePullDown
	beq $t5, ENMcolor, donePullDown

	move $a2, $s1
	li $a1, SCREEN_COLOR
	jal delPlayer
	
	addi $s5, $s5, SCR_WIDTH
	
	add $s1, $t0, $s4  ## this 2 lines to compute current 
	add $s1, $s1, $s5  ##  address of Player, store in $s1 before drawing Player
	 # set player info before drawing
	li $a0, Ph
	li $a1, Pw
	move $a2, $s1
	jal drawPlayer
	
	##### fall right fall left
	li $t4, 0xffff0000
	lw $t3, 0($t4)
	beq $t3, 1, Fallkeypressed
	j Falldone
	
Fallkeypressed:
	lw $t2, 4($t4)
	beq $t2, 0x64, fallright
	beq $t2, 0x61, fallleft
	beq $t2, 0x70, main
	beq $t2, 0x71, GameOver
	
Falldone: 
	####
	
	li $v0, 32
	li $a0, 30
	syscall
	#j gravity
	j donePullDown
	
#########
fallright:
	lw $t1, 1556($s1)###### can not fall right when touching enemies
	bne $t1, SCREEN_COLOR, Falldone ####
	lw $t1, 1532($s1)###### can not fall right when touching enemies
	bne $t1, SCREEN_COLOR, Falldone ####
	
	bge $s4, 484, Falldone   ## 508 - Pw * 4
	# load player info
	move $a0, $s1
	li $a1, SCREEN_COLOR
	jal delPlayer
	addi $s4, $s4, 8
	j Falldone
fallleft: 
	lw $t1, 1532($s1)###### can not fall left when touching enemies
	bne $t1, SCREEN_COLOR, Falldone ####
	lw $t1, 1556($s1)###### can not fall left when touching enemies
	bne $t1, SCREEN_COLOR, Falldone ####
	
	ble $s4, 8, Falldone
	# load player info
	move $a0, $s1
	li $a1, SCREEN_COLOR
	jal delPlayer
	subi $s4, $s4, 8 #
	j Falldone

#########

######################### FLATFORM ###############################

drawPlatForm:  #(take in $a0: x, $a1: y, $a2: length)
	li $t0, BASE_ADDRESS
	add $t2, $t0, $a0 ## this 2 lines to compute current 
	add $t2, $t2, $a1 
	li $t1, PlatformColor
	#$t2 store address of the platform
platloop: 
	beq $a2, 0, doneplat
	sw $t1, 0($t2)
	sw $t1, -512($t2)
	subi $a2, $a2, 1
	addi $t2, $t2, 4
	j platloop
doneplat:
	jr $ra
	
delPlatForm:  #(take in $a0: x, $a1: y, $a2: length)
	li $t0, BASE_ADDRESS
	add $t2, $t0, $a0 ## this 2 lines to compute current 
	add $t2, $t2, $a1 
	li $t1, SCREEN_COLOR
	#$t2 store address of the platform
delplatloop: 
	beq $a2, 0, delDoneplat
	sw $t1, 0($t2)
	sw $t1, -512($t2)
	subi $a2, $a2, 1
	addi $t2, $t2, 4
	j platloop
delDoneplat:
	jr $ra

############## MOVING PLATFORM #######

##### PF 2 ##################
movingPlatform2: #(take in $a0: x, $a1: y, $a2: length)  ## PF2x = 136
	#jal delPlatForm
	li $t1, PF2x # $t1 = fixed value of PF2x
	addi $t1, $t1, 40 # shift 10 * 4
	beq $a0, PF2x, setDirPF2one
	beq $a0, $t1, setDirPF2zero
	j doneSetDirPF2
setDirPF2one:
	la $t0, platform2dir
	li $t2, 1
	sw $t2, 0($t0)
	j doneSetDirPF2
setDirPF2zero: 
	la $t0, platform2dir
	li $t2, 0
	sw $t2, 0($t0)
doneSetDirPF2:
	lw $t3, platform2dir
	beq $t3, 1, MovRightPF2
	j MovLeftPF2
MovRightPF2:
	lw $t2, platform2x
	add $t2, $t2, 4
	la $t0, platform2x
	sw $t2, 0($t0)
	#j doneMovPF2
	j DelPF2ends
MovLeftPF2:
	lw $t2, platform2x
	sub $t2, $t2, 4
	la $t0, platform2x
	sw $t2, 0($t0)
	#j doneMovPF2
	j DelPF2ends
DelPF2ends:
	li $t2, PF2x # $t2 is extreme left
	lw $t3, platform2x
	# shade the block between $t2 and $t3
	li $a0, 2
	sub $a1, $t3, $t2
	srl $a1, $a1, 2
	li $a2, BASE_ADDRESS
	addi $a2, $a2, PF2x
	addi $a2, $a2, PF2y
	subi $a2, $a2, 512
	li $a3, SCREEN_COLOR
	jal drawBlk
	###########################
	li $t1, PF2x
	addi $t1, $t1, 40 # add the shift ammount
	addi $t1, $t1, 40 # add the len of the PF, then $t1 is the extreme right
	
	lw $t3, platform2x
	addi $t4, $t3, 40 # add the len of the block, $t4 is the right end of the PF2
	
	# shade the block between $t4 and $t1
	
	li $a0, 2
	sub $a1, $t1, $t4
	srl $a1, $a1, 2
	li $a2, BASE_ADDRESS
	add $a2, $a2, $t4
	addi $a2, $a2, PF2y
	subi $a2, $a2, 512
	li $a3, SCREEN_COLOR
	jal drawBlk
	j doneMovPF2
	
##### PF 6 ##################
movingPlatform6: #(take in $a0: x, $a1: y, $a2: length)  ## PF2x = 136
	li $t1, PF6x # $t1 = fixed value of PF2x
	addi $t1, $t1, 40 # shift 10 * 4
	beq $a0, PF6x, setDirPF6one
	beq $a0, $t1, setDirPF6zero
	j doneSetDirPF6
setDirPF6one:
	la $t0, platform6dir
	li $t2, 1
	sw $t2, 0($t0)
	j doneSetDirPF6
setDirPF6zero: 
	la $t0, platform6dir
	li $t2, 0
	sw $t2, 0($t0)
doneSetDirPF6:
	lw $t3, platform6dir
	beq $t3, 1, MovRightPF6
	j MovLeftPF6
MovRightPF6:
	lw $t2, platform6x
	add $t2, $t2, 4
	la $t0, platform6x
	sw $t2, 0($t0)

	j DelPF6ends
MovLeftPF6:
	lw $t2, platform6x
	sub $t2, $t2, 4
	la $t0, platform6x
	sw $t2, 0($t0)
	j DelPF6ends
DelPF6ends:
	li $t2, PF6x # $t2 is extreme left
	lw $t3, platform6x
	# shade the block between $t2 and $t3
	li $a0, 2
	sub $a1, $t3, $t2
	srl $a1, $a1, 2
	li $a2, BASE_ADDRESS
	addi $a2, $a2, PF6x
	addi $a2, $a2, PF6y
	subi $a2, $a2, 512
	li $a3, SCREEN_COLOR
	jal drawBlk
	###########################
	li $t1, PF6x
	addi $t1, $t1, 40 # add the shift ammount
	addi $t1, $t1, 40 # add the len of the PF, then $t1 is the extreme right
	
	lw $t3, platform6x
	addi $t4, $t3, 40 # add the len of the block, $t4 is the right end of the PF2
	
	# shade the block between $t4 and $t1
	
	li $a0, 2
	sub $a1, $t1, $t4
	srl $a1, $a1, 2
	li $a2, BASE_ADDRESS
	add $a2, $a2, $t4
	addi $a2, $a2, PF6y
	subi $a2, $a2, 512
	li $a3, SCREEN_COLOR
	jal drawBlk
	j doneMovPF6
	
#########3######## PF 8 ############
movingPlatform8: #(take in $a0: x, $a1: y, $a2: length)  
	li $t1, PF8x # $t1 = fixed value of PF2x
	addi $t1, $t1, 40 # shift 10 * 4
	beq $a0, PF8x, setDirPF8one
	beq $a0, $t1, setDirPF8zero
	j doneSetDirPF8
setDirPF8one:
	la $t0, platform8dir
	li $t2, 1
	sw $t2, 0($t0)
	j doneSetDirPF8
setDirPF8zero: 
	la $t0, platform8dir
	li $t2, 0
	sw $t2, 0($t0)
doneSetDirPF8:
	lw $t3, platform8dir
	beq $t3, 1, MovRightPF8
	j MovLeftPF8
MovRightPF8:
	lw $t2, platform8x
	add $t2, $t2, 4
	la $t0, platform8x
	sw $t2, 0($t0)

	j DelPF8ends
MovLeftPF8:
	lw $t2, platform8x
	sub $t2, $t2, 4
	la $t0, platform8x
	sw $t2, 0($t0)
	j DelPF8ends
DelPF8ends:
	li $t2, PF8x # $t2 is extreme left
	lw $t3, platform8x
	# shade the block between $t2 and $t3
	li $a0, 2
	sub $a1, $t3, $t2
	srl $a1, $a1, 2
	li $a2, BASE_ADDRESS
	addi $a2, $a2, PF8x
	addi $a2, $a2, PF8y
	subi $a2, $a2, 512
	li $a3, SCREEN_COLOR
	jal drawBlk
	###########################
	li $t1, PF8x
	addi $t1, $t1, 40 # add the shift ammount
	addi $t1, $t1, 40 # add the len of the PF, then $t1 is the extreme right
	
	lw $t3, platform8x
	addi $t4, $t3, 40 # add the len of the block, $t4 is the right end of the PF8
	
	# shade the block between $t4 and $t1
	
	li $a0, 2
	sub $a1, $t1, $t4
	srl $a1, $a1, 2
	li $a2, BASE_ADDRESS
	add $a2, $a2, $t4
	addi $a2, $a2, PF8y
	subi $a2, $a2, 512
	li $a3, SCREEN_COLOR
	jal drawBlk
	j doneMovPF8
	
####################### SCREEN #####################
drawScreen:
	li $t2, 8192
	li $a0, BASE_ADDRESS
drawingScr:
	beq $t2, 0, doneScreen
	li $t1, SCREEN_COLOR
	sw $t1, 0($a0)
	subi $t2, $t2, 1
	addi $a0, $a0, 4
	j drawingScr
doneScreen: 
	jr $ra
	
###################################### Draw Player #####
drawPlayer: # take in: $a0 = current address of Player
	move $a0, $s1
	move $t2, $a0 # $t2 store current address
	li $t1, 0
	li $t3, PLIGHT
	li $t4, PDARK
Firstdraw:
	beq $t1, 5, doneFirst
	sw $t4, 516($a0)
	sw $t4, 524($a0)
	sw $t3, 4($t2)
	sw $t3, 12($t2)
	addi $t1, $t1, 1
	add $t2, $t2, SCR_WIDTH
	j Firstdraw
doneFirst:
Seconddraw:
	sw $t4, 520($a0) # a0 + 2*4 + 1 * 512
	sw $t4, 1032($a0)
	sw $t3, 1544($a0)
	sw $t3, 2056($a0)
Thirddraw:
	sw $t3, 1536($a0) # 512 * 3
	sw $t3, 1552($a0) # 512 * 3 + 4 * 4
	sw $t4, 2564($a0) # 512 * 5 + 4
	sw $t4, 2572($a0) # 512 * 5 + 12
DrawDark:
	sw $t4, 516($a0)
	sw $t4, 524($a0)
	
	jr $ra

################################ DELETE INSTANCE OF MOVING PLAYER
delPlayer: # take in: $a0 = current address of Player, $a1 = color
	move $a0, $s1
	move $t2, $a0 # $t2 store current address
	li $t1, 0
	move $t3, $a1
Firstdel:
	beq $t1, 6, doneFirstdel
	sw $t3, 4($t2)
	sw $t3, 12($t2)
	addi $t1, $t1, 1
	add $t2, $t2, SCR_WIDTH
	j Firstdel
doneFirstdel:
Seconddel:
	sw $t3, 520($a0) # a0 + 2*4 + 1 * 512
	sw $t3, 1032($a0)
	sw $t3, 1544($a0)
	sw $t3, 2056($a0)
Thirddel:
	sw $t3, 1536($a0) # 512 * 3
	sw $t3, 1552($a0) # 512 * 3 + 4 * 4
	sw $t3, 2564($a0) # 512 * 5 + 4
	sw $t3, 2572($a0) # 512 * 5 + 12

	sw $t3, 516($a0)
	sw $t3, 520($a0)
	sw $t3, 524($a0)
	sw $t3, 1032($a0)
	
	jr $ra

######################## MOVEMENT OF PLAYER
moveright:
	lw $t1, 1556($s1)######
	beq $t1, SCREEN_COLOR, plmoveright####
	beq $t1, RED, plmoveright####
	beq $t1, T1color, plmoveright####
	beq $t1, H3color, plmoveright####
	beq $t1, FLAGdarkcolor, plmoveright####
	beq $t1, FLAGcolor, plmoveright####
	j mainloop
plmoveright:
	beq $s4, 488, mainloop   ## 508 - Pw * 4
	# load player info
	move $a0, $s1
	li $a1, SCREEN_COLOR
	jal delPlayer
	addi $s4, $s4, 4
	j mainloop

moveleft:
	lw $t1, 1532($s1)######
	beq $t1, SCREEN_COLOR, plmoveleft####
	beq $t1, RED, plmoveleft####
	beq $t1, T1color, plmoveleft####
	beq $t1, H3color, plmoveleft####
	beq $t1, FLAGdarkcolor, plmoveleft####
	beq $t1, FLAGcolor, plmoveleft####
	j mainloop
plmoveleft:
	beq $s4, 4, mainloop
	# load player info
	move $a0, $s1
	li $a1, SCREEN_COLOR
	jal delPlayer
	subi $s4, $s4, 4 #
	j mainloop
	
######################### JUMPING 
jump:
	li, $t5, JumpHeight
jumpcont: 
	beq $t5, 0, mainloop
	beq $s5, 0, mainloop

	# load player info
	move $a0, $s1
	li $a1, SCREEN_COLOR
	jal delPlayer
	
	add $s1, $t0, $s4  ## this 2 lines to compute current 
	add $s1, $s1, $s5  ##  address of Player, store in $s1 before drawing Player
	 # set player info before drawing
	move $a0, $s1
	jal drawPlayer
	
	subi $t5, $t5, 1
	subi $s5, $s5, SCR_WIDTH
	
	li $v0, 32
	li $a0, 12
	syscall
	
	j jumpcont
Jumpdone:
jumpright:
	beq $s4, 488, Jumpdone   ## 508 - Pw * 4
	# load player info
	move $a0, $s1
	li $a1, SCREEN_COLOR
	jal delPlayer
	addi $s4, $s4, 8
	j jumpcont
jumpleft: 
	beq $s4, 4, Jumpdone
	# load player info
	move $a0, $s1
	li $a1, SCREEN_COLOR
	jal delPlayer
	subi $s4, $s4, 8 #
	j jumpcont

################ ENEMIES ########################
	
	######### FILL BLOCKS ###########
	# $a0,      $a1,    $a2
drawBlk: #take in $a0 which is the Ph, $a1 (Pw), $a2 (current coordinate), $a3 (color)
	move $t1, $a3  # set $t1 to store the color in $a3
	move $t2, $a2
fillBlk: 
	beq, $a1, $zero, donefillBlk
	move $t2, $a2
	move $t3, $a0
	j fillhBlk
contfillBlk:
	subi $a1, $a1, 1
	addi $t2, $t2, 4
	addi $a2, $a2, 4
	j fillBlk

fillhBlk: 
	beq $t3, $zero, contfillBlk
	sw $t1, 0($t2)
	subi $t3, $t3, 1
	addi $t2, $t2, SCR_WIDTH
	j fillhBlk

donefillBlk:
	jr $ra
	
	######### DRAW ENEMIES ########
drawEnemy: # take in $a2 which is enemy position
	
	#reserve $ra
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	move $t4, $a2
	li $a0, 2
	li $a1, 7
	li $a3, ENMcolor
	jal drawBlk
	
	move $a2, $t4
	li $a0, 9
	li $a1, 2
	li $a3, ENMcolor
	jal drawBlk
	
	move $a2, $t4
	addi $a2, $a2, 20
	li $a0, 9
	li $a1, 2
	li $a3, ENMcolor
	jal drawBlk
	
	move $a2, $t4
	addi $a2, $a2, 2048
	li $a0, 1
	li $a1, 7
	li $a3, ENMcolor
	jal drawBlk
	
	move $a2, $t4
	addi $a2, $a2, 3584
	li $a0, 2
	li $a1, 7
	li $a3, ENMcolor
	jal drawBlk
	
	move $a2, $t4
	addi $a2, $a2, 1544
	li $a0, 1
	li $a1, 3
	li $a3, WHITE
	jal drawBlk
	
	li $t1, WHITE
	sw $t1, 1032($t4)
	sw $t1, 1040($t4)
	sw $t1, 2568($t4)
	sw $t1, 2576($t4)
	li $t1, BLACK
	sw $t1, 2572($t4)
	sw $t1, 1036($t4)
	sw $t1, 3080($t4)
	sw $t1, 3084($t4)
	sw $t1, 3088($t4)
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra
	
	#### DRAW HEART #########
drawHeart: #take in $a0 as memory address, $a1 as color
	move $t1, $a1
	sw $t1, 4($a0)
	sw $t1, 12($a0)
	sw $t1, 512($a0)
	sw $t1, 516($a0)
	sw $t1, 520($a0)
	sw $t1, 524($a0)
	sw $t1, 528($a0)
	sw $t1, 1028($a0)
	sw $t1, 1032($a0)
	sw $t1, 1036($a0)
	sw $t1, 1544($a0)
	jr $ra
	
	#### DRAW T-pick up #########
drawTpickup: # take in $a0 as memory addr, $a1 as color
	move $t1, $a1
	sw $t1, 0($a0)
	sw $t1, 4($a0)
	sw $t1, 8($a0)
	sw $t1, 516($a0)
	jr $ra
	
	
############################ GAME OVER SCREEN ##############

######### THE SCREEN  ##############################
GameOver: 

#### draw black screen ##
drawBlackScreen:
	li $t2, 8192
	li $a0, BASE_ADDRESS
drawingBlackScr:
	beq $t2, 0, doneBlackScreen
	li $t1, BLACK
	sw $t1, 0($a0)
	subi $t2, $t2, 1
	addi $a0, $a0, 4
	j drawingBlackScr
doneBlackScreen: 

#### the loop to display letters ####
gameoverloop:

	####### PRESSING KEYS ###############
	li $t4, 0xffff0000
	lw $t3, 0($t4)
	beq $t3, 1, keypressedGameover
	j doneKeyPressGameover
	
keypressedGameover:
	lw $t2, 4($t4)
	beq $t2, 0x70, main
	beq $t2, 0x71, exit
	
doneKeyPressGameover:


	####### LETTERS ##########
	li $a0, BASE_ADDRESS
	addi $a0, $a0, 6244 # 25, 12
	move $t5, $a0
	j drawG
	doneDrawG:
	addi $t5, $t5, 60
	move $a0, $t5
	j drawA
	doneDrawA:
	addi $t5, $t5, 60
	move $a0, $t5
	j drawM
	doneDrawM:
	addi $t5, $t5, 68
	move $a0, $t5
	j drawE1
	doneDrawE1:
	li $a0, 0x10008000
	addi $a0, $a0, 6244 # 25, 12
	addi $t5, $a0, 12800 # 25
	move $a0, $t5
	j drawO
	doneDrawO:
	addi $t5, $t5, 68
	move $a0, $t5
	j drawV
	doneDrawV:
	addi $t5, $t5, 68
	move $a0, $t5
	j drawE2
	doneDrawE2:
	addi $t5, $t5, 64
	move $a0, $t5
	j drawR
	doneDrawR:
	
	
	### DISPLAYING HEARTS #################
displayHeartGOver: # $t2 store the number of hearts
	lw $t2, heartlives
	li $t0, BASE_ADDRESS
	addi $t0, $t0, 1024
	li $a1, RED
heartGOverloop:
    	beq $t2, 0, doneHeartGOverloop
    	addi $t0, $t0, 16
    	move $a0, $t0
    	jal drawHeart
    	addi $t0, $t0, 16
    	subi $t2, $t2, 1
 	j heartGOverloop
doneHeartGOverloop:

	### handle when no heart left ###
	lw $t2, heartlives
	ble $t2, 0, drawWhiteHeartGO
	j doneDrawWhiteHeartGO
drawWhiteHeartGO: 
	li $t0, BASE_ADDRESS
	addi $t0, $t0, 1024
	addi $t0, $t0, 16
    	move $a0, $t0
    	li $a1, WHITE
    	jal drawHeart
doneDrawWhiteHeartGO: 
	
	######### DISPLAY FLAG if picked up ###########
	la $t0, FLAGpicked
    	lw $t1, 0($t0)
    	beq $t1, 1, drawFLagGameOver
    	j doneDrawFlagGameOver
drawFLagGameOver:  	
    	li $a0, 12
    	li $a1, 2
    	li $t0, BASE_ADDRESS
    	addi $t0, $t0, 440 # 110
    	addi $t0, $t0, 1024 # 2
    	move $a2, $t0
    	li $a3, FLAGdarkcolor
    	jal drawBlk
    	
    	li $a0, 7
    	li $a1, 11
    	li $t0, BASE_ADDRESS
    	addi $t0, $t0, 440 # 110
    	addi $t0, $t0, 1024 # 2
    	addi $t0, $t0, 8
    	move $a2, $t0
    	li $a3, FLAGcolor
    	jal drawBlk
doneDrawFlagGameOver:
	######################################
	
	j gameoverloop



######## DRAW LETTERS G, A, M, E, O, V, R ########
drawG: # take $a0 the current address  # 10 * 15
	li $a3, WHITE
	move $t4, $a0
	move $a2, $a0
	li $a0, 2
	li $a1, 10
	jal drawBlk
	move $a2, $t4
	li $a0, 15
	li $a1, 2
	jal drawBlk
	addi $a2, $t4, 7680 #0, 15
	li $a0, 2
	li $a1, 10
	jal drawBlk
	addi $a2, $t4, 5160 #10, 10
	li $a0, 5
	li $a1, 2
	jal drawBlk
	addi $a2, $t4, 5140 # 5, 10
	li $a0, 2
	li $a1, 5
	jal drawBlk
	j doneDrawG
	
drawA:
	li $a3, WHITE
	move $t4, $a0
	move $a2, $a0
	li $a0, 15
	li $a1, 2
	jal drawBlk
	move $a2, $t4
	li $a0, 2
	li $a1, 10
	jal drawBlk
	addi $a2, $t4, 40 # 10, 0
	li $a0, 15
	li $a1, 2
	jal drawBlk
	addi $a2, $t4, 2560 # 0, 5
	li $a0, 2
	li $a1, 10
	jal drawBlk 
	j doneDrawA
drawM:
	li $a3, WHITE
	move $t4, $a0
	move $a2, $a0
	li $a0, 15
	li $a1, 2
	jal drawBlk
	move $a2, $t4
	li $a0, 2
	li $a1, 2
	jal drawBlk
	addi $a2, $t4, 8 # 2, 0
	li $a0, 2
	li $a1, 2
	jal drawBlk
	addi $a2, $t4, 1040 # 4, 2
	li $a0, 2
	li $a1, 2
	jal drawBlk
	addi $a2, $t4, 2072 # 6, 4
	li $a0, 10
	li $a1, 2
	jal drawBlk
	addi $a2, $t4, 1056 # 8, 2
	li $a0, 2
	li $a1, 2
	jal drawBlk
	addi $a2, $t4, 40 # 10, 0
	li $a0, 2
	li $a1, 2
	jal drawBlk
	addi $a2, $t4, 48 # 10, 0
	li $a0, 15
	li $a1, 2
	jal drawBlk
	j doneDrawM
drawE1:
	li $a3, WHITE
	move $t4, $a0
	move $a2, $a0
	li $a0, 15
	li $a1, 2
	jal drawBlk
	move $a2, $t4
	li $a0, 2
	li $a1, 10
	jal drawBlk
	addi $a2, $t4, 3584 # 0, 7
	li $a0, 2
	li $a1, 10
	jal drawBlk
	addi $a2, $t4, 7680 # 0, 15
	li $a0, 2
	li $a1, 10
	jal drawBlk
	j doneDrawE1

drawO:
	li $a3, WHITE
	move $t4, $a0
	move $a2, $a0
	li $a0, 15
	li $a1, 2
	jal drawBlk
	move $a2, $t4
	li $a0, 2
	li $a1, 10
	jal drawBlk
	addi $a2, $t4, 40
	li $a0, 17
	li $a1, 2
	jal drawBlk
	addi $a2, $t4, 7680 # 0, 15
	li $a0, 2
	li $a1, 10
	jal drawBlk
	j doneDrawO
drawV:
	li $a3, WHITE
	move $t4, $a0
	move $a2, $a0
	li $a0, 10
	li $a1, 2
	jal drawBlk
	addi $a2, $t4, 5124 # 2, 10
	li $a0, 5
	li $a1, 2
	jal drawBlk
	addi $a2, $t4, 7692 # 4, 15
	li $a0, 2
	li $a1, 3
	jal drawBlk
	addi $a2, $t4, 5144 # 6, 10
	li $a0, 5
	li $a1, 2
	jal drawBlk
	addi $a2, $t4, 32 # 8, 0
	li $a0, 10
	li $a1, 2
	jal drawBlk
	j doneDrawV
drawE2:
	li $a3, WHITE
	move $t4, $a0
	move $a2, $a0
	li $a0, 15
	li $a1, 2
	jal drawBlk
	move $a2, $t4
	li $a0, 2
	li $a1, 10
	jal drawBlk
	addi $a2, $t4, 3584 # 0, 7
	li $a0, 2
	li $a1, 10
	jal drawBlk
	addi $a2, $t4, 7680 # 0, 15
	li $a0, 2
	li $a1, 10
	jal drawBlk
	j doneDrawE2

drawR:
	li $a3, WHITE
	move $t4, $a0
	move $a2, $a0
	li $a0, 17
	li $a1, 2
	jal drawBlk
	move $a2, $t4  
	li $a0, 2
	li $a1, 10
	jal drawBlk
	addi $a2, $t4, 3584 # 0, 7  
	li $a0, 2
	li $a1, 10
	jal drawBlk
	addi $a2, $t4, 1064 # 10, 2
	li $a0, 5
	li $a1, 2
	jal drawBlk
	addi $a2, $t4, 4648 # 10, 9
	li $a0, 2
	li $a1, 2
	jal drawBlk
	addi $a2, $t4, 5680 # 12, 11
	li $a0, 6
	li $a1, 2
	jal drawBlk
	j doneDrawR
	

 	
	
