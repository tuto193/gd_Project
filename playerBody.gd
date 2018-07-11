extends KinematicBody2D

# class member variables go here, for example:
var UP = Vector2( 0, 1 )
var GRAVITY = 80
var MAX_SPEED_FALL = 500
var MAX_SPEED_X = 300
var MAX_ACCEL_X = 20
var JUMP_SPEED = 400
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
	
	if( InputEvent.is_action_just_pressed("player_UP") ):


	pass
