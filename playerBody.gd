extends KinematicBody2D

# class member variables go here, for example:

# Constants that facilitate movement
const UP = Vector2( 0, -1 )
const GRAVITY = 30
const MAX_SPEED_FALL = 980
const MAX_SPEED_X = 460
const ACCEL_X = 16
const DECEL_X = 60
const JUMP_SPEED = -600

# Variables that make platforming more interactive
var player_speed = Vector2( 0, 0 )
var doubleJump = 0
var wallJump = 0
var direction = 1
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
		elif doubleJump > 0: # allow for a doublejump
			player_speed.y = JUMP_SPEED + 110
			doubleJump -= 1
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
		doubleJump = 1
	
	if is_on_wall():
		doubleJump = 1
		wallJump = 1
	# Make sure that the vertical_speed is within bounds
	player_speed.y = clamp( player_speed.y, JUMP_SPEED, MAX_SPEED_FALL)

	#####################################################
	#				Horizontal Movement					#
	#####################################################
	var move_right = Input.is_action_pressed("player_RIGHT")
	var move_left = Input.is_action_pressed("player_LEFT")
	var not_moving = (not move_right) and (not move_left) 
	# We sort the directional movement of the player
	# to make the change of direction more realistic
	if move_right :
		last_direction = 1
	elif move_left:
		last_direction = -1
	elif not_moving:
		last_direction = 0
	# Process lateral movement after processing direction changes
	# If player is in the middle of changing directions
	if (move_left or move_right) and last_direction:
		if last_direction == -direction:
			player_speed.x /= 4
			direction = last_direction
	
	# Accelerate (or decelarate) accordingly
	if last_direction: #just when we actually started moving
		if is_on_floor():
			player_speed.x += ACCEL_X
		else:
			player_speed.x += ACCEL_X/2
	else:
		player_speed.x -= DECEL_X
	
	# We also need to clamp it
	player_speed.x = clamp( player_speed.x, 0, MAX_SPEED_X )
	player_speed.x *= direction
	# The player movement method is then updated
	move_and_slide( player_speed, UP )
	pass
