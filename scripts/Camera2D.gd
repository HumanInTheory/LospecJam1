extends Camera2D

export var DESIRED_RESOLUTION = Vector2(240, 135)
var vp
var scaling_factor = 1
var player_bounds_left = -75
var player_bounds_right = 0
var player_bounds_top = 0
var player_bounds_bottom = 58.5
var center = Vector2(120, 67.5)
var speed = Vector2()
var acceleration = 5
onready var gameNode = get_parent()

func _ready():
	vp = get_viewport()
	vp.connect(
		"size_changed", self, "on_vp_size_change"
		)
	on_vp_size_change()

func on_vp_size_change():
	var scale_vector = vp.size / DESIRED_RESOLUTION
	var new_scaling_factor = max(floor(min(scale_vector[0], scale_vector[1])), 1)
	if new_scaling_factor != scaling_factor:
		scaling_factor = new_scaling_factor
		zoom = Vector2(1 / scaling_factor, 1 / scaling_factor)

func _physics_process(_delta):
	var playerPos = gameNode.playerNode.get_global_transform().get_origin()
	var cameraPos = self.get_global_transform().get_origin()
	var relativePos = playerPos - cameraPos - center
	var mappedPosX = remap_range(relativePos.x, player_bounds_left, player_bounds_right, -1, 1)
	var mappedPosY = remap_range(relativePos.y, player_bounds_top, player_bounds_bottom, -1, 1)
	if relativePos.x != 0:
		speed.x = acceleration * mappedPosX
	if relativePos.y != 0:
		speed.y = acceleration * mappedPosY
	
	translate(speed)
	
func remap_range(value, InputA, InputB, OutputA, OutputB):
	return(value - InputA) / (InputB - InputA) * (OutputB - OutputA) + OutputA
