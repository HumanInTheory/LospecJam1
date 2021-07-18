extends KinematicBody2D

# Variables
const DIRECTION_RIGHT = 1
const DIRECTION_LEFT = -1
var direction = Vector2(DIRECTION_RIGHT, 1)

var jumpVelocity = 200
var walkSpeed = 200
var walkAcceleration = 30
var gravity = 170
var gravityAcceleration = 10
var velocity = Vector2(0,0)
onready var animSprite = get_node("AnimatedSprite")
onready var manaShot = preload("res://scenes/ManaShot.res")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Get input from input buffer based on defined inputs
func get_input(current_velocity):
	#var touching = get_slide_count() == 0 if true else false
	var touching = true
	# Horizontal movement
	if Input.is_action_pressed("gm_left") and touching:
		current_velocity.x -= walkAcceleration
		animSprite.animation = "walk"
		set_direction(DIRECTION_LEFT)
	elif Input.is_action_pressed("gm_right") and touching:
		current_velocity.x += walkAcceleration
		animSprite.animation = "walk"
		set_direction(DIRECTION_RIGHT)
	else:
		# If neither left or right are pressed, slow down the player
		if current_velocity.x > 0:
			current_velocity.x -= gravityAcceleration
		if current_velocity.x < 0:
			current_velocity.x += gravityAcceleration
	
	# Vertical movement
	if Input.is_action_pressed("gm_up") and current_velocity.y > 0:
		current_velocity.y = -jumpVelocity
	else:
		current_velocity.y += gravityAcceleration
		
	if current_velocity.y < gravityAcceleration*2:
		animSprite.animation = "idle"
		
	# Max velocity locks
	if current_velocity.x > walkSpeed:
		current_velocity.x = walkSpeed
	elif current_velocity.x < -walkSpeed:
		current_velocity.x = -walkSpeed
	if current_velocity.y > gravity:
		current_velocity.y = gravity
		
	# Min velocity locks
	if abs(current_velocity.x) < walkAcceleration:
		current_velocity.x = 0
		animSprite.animation = "idle"
		
	if Input.is_action_just_pressed("gm_a"):
		var b = manaShot.instance()
		owner.add_child(b)
		b.transform = $BulletSpawn.global_transform
		if direction == Vector2(DIRECTION_RIGHT, direction.y):
			b.apply_central_impulse(Vector2(500,0))
		else:
			b.apply_central_impulse(Vector2(-500,0))
	
	return current_velocity

# Called every physics frame
func _physics_process(_delta):
	velocity = get_input(self.velocity)
	move_and_slide_with_snap(velocity, Vector2(0,-1))

func set_direction(hor_direction):
	if hor_direction == 0:
		hor_direction = DIRECTION_RIGHT # default to right if param is 0
	var hor_dir_mod = hor_direction / abs(hor_direction) # get unit direction
	apply_scale(Vector2(hor_dir_mod * direction.x, 1)) # flip
	direction = Vector2(hor_dir_mod, direction.y) # update direction
