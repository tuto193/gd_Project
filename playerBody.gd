extends KinematicBody2D

# class member variables go here, for example:
const UP = Vector2( 0, 1 )
const GRAVITY = 80
const MAX_SPEED_FALL = 500
const MAX_SPEED_X = 300
const ACCEL_X = 20
const JUMP_SPEED = 400
var player_speed = Vector2( 0, 0 )

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	player_speed = Vector2(0,0)
	pass

func _process(delta):
	# Called every frame. Delta is time since last frame.
	# Update game logic here.

	# The player is affected by gravity as long as he's in the air
	if( !is_on_floor() ):
		if( player_speed.y < MAX_SPEED_FALL ):
			player_speed.y += GRAVITY
	# Here is the player movement handled
	if InputEvent.is_action_just_pressed("player_UP"):
		if is_on_floor():
			player_speed.y = JUMP_SPEED
	elif InputEvent.is_action_pressed("player_RIGHT"):
		if player_speed.x < MAX_SPEED_X:
			player_speed.x += ACCEL_X
	elif InputEvent.is_action_pressed( "player_LEFT" ):
		if player_speed.x > -MAX_SPEED_X:
			player_speed.x -= ACCEL_X


	pass
