extends Node2D

var levelResource = preload("res://scenes/Level.tscn")
var caveTileSet = preload("res://tilesets/caves.res")
onready var playerNode = get_node("Player")

func _ready():
	createNewLevel("caves", 15)

func createNewLevel(levelType: String, levelSize: int):
	var level = levelResource.instance()
	add_child(level)
	
	match(levelType):
		"caves":
			level.setTileSet(caveTileSet)
			print(level.levelTileSet.get_tiles_ids())
	
	var cameraLimit = level.generateLevel(levelSize, levelType)
	cameraLimit.y += 9
	cameraLimit *= 15
