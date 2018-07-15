extends KinematicBody2D

# class member variables go here, for example:

# Constants that facilitate movement
const UP = Vector2( 0, -1 )
const GRAVITY = 30
const MAX_SPEED_FALL = 980
const MAX_SPEED_X = 460
const ACCEL_X = 16
const DECEL_X = 40
const JUMP_SPEED = -600

# Variables that make platforming more interactive
var player_speed = Vector2( 0, 0 )
var player_move = Vector2( 0, 0 )
var doubleJump = 2
var wallJump = 1
var input_direction = 1
var last_direction = 0

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	set_process(true)
	set_process_input(true)


#	Vertical Movement is handled here
func _input( event ):
	if Input.is_action_just_pressed("player_UP"):
		if is_on_floor():
			player_speed.y = JUMP_SPEED
			doubleJump += 1
		elif doubleJump < 2: # allow for a doublejump
			player_speed.y = JUMP_SPEED + 110
			doubleJump += 1
	# IMPLEMENT WALL-JUMPING
	pass

func _process(delta):
	# Called every frame. Delta is time since last frame.
	# Update game logic here.

	#####################################################
	#				Vertical Movement					#
	#####################################################
	# The player is affected by gravity as long as he's in the air
	# Replenish wall/double-jumps
	if !is_on_floor():
		player_speed.y += GRAVITY
	else:
		doubleJump = 0
	
	if is_on_wall():
		doubleJump = 0
		wallJump = 0
	# Make sure that the vertical_speed is within bounds
	player_speed.y = clamp( player_speed.y, JUMP_SPEED, MAX_SPEED_FALL)

	#####################################################
	#				Horizontal Movement					#
	#####################################################
	var move_right = Input.is_action_pressed("player_RIGHT")
	var move_left = Input.is_action_pressed("player_LEFT")
	# We sort theinput_directional movement of the player
	# to make the change ofinput_direction more realistic
	if input_direction != 0:
		last_direction = input_direction

	if move_right :
		input_direction = 1
	elif move_left:
		input_direction = -1
	else:
		input_direction = 0
	# Process lateral movement after processinginput_direction changes
	# If player is in the middle of changinginput_directions
	if last_direction == -input_direction:
		if is_on_floor():
			player_speed.x /= 2.8
		else:
			player_speed.x /= 4
	# Accelerate (or decelarate) accordingly
	if input_direction != 0: #just when we actually started moving
		if is_on_floor():
			player_speed.x += ACCEL_X
		else:
			player_speed.x += ACCEL_X/2
	else:
		player_speed.x -= DECEL_X
	
	# We also need to clamp it
	player_speed.x = clamp( player_speed.x, 0, MAX_SPEED_X )
	player_move = player_speed
	player_move.x *= last_direction
	# The player movement method is then updated
	move_and_slide( player_move, UP )
	pass
