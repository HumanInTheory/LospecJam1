extends Node2D

var levelTileSet
var rng = RandomNumberGenerator.new()
onready var tileMap = get_node("LevelMap")

func _ready():
	pass

func setTileSet(tileSet: TileSet):
	if (tileSet == null):
		push_error("setTileSet: requested TileSet is null")
		
	levelTileSet = tileSet
	
	tileMap.tile_set = levelTileSet
	
func placeJSONTileChunk(x: int, y:int, tileChunkName: String) -> Vector2:
	var file = File.new()
	file.open("res://tiled/" + tileChunkName + ".json", File.READ)
	var content = file.get_as_text()
	file.close()
	
	var parseResult = JSON.parse(content)
	
	if parseResult.error != OK:
		push_error("placeJSONTileChunk: failed to load TileChunk JSON: " + parseResult.get_error_string())
	
	if typeof(parseResult.result) != TYPE_DICTIONARY:
		push_error("placeJSONTileChunk: JSON formatting error: JSON is " + parseResult.result.get_class())
	
	var tileChunk = parseResult.result
	var tileIterator = 0
	
	for yOffset in range(tileChunk["height"]):
		for xOffset in range(tileChunk["width"]):
			var tile = tileChunk["layers"][0]["data"][tileIterator] - 1
			var tileCoords = Vector2(int(tile) % 6, floor(tile / 6))
			tileMap.set_cell(x + xOffset, y + yOffset, 0, false, false, false, tileCoords)
			tileIterator += 1
			
	return Vector2(x + tileChunk["width"], y + tileChunk["properties"][0]["value"])

func generateLevel(length: int, theme: String) -> Vector2:
	var pointer = Vector2(0,0)
	
	pointer = placeJSONTileChunk(pointer.x, pointer.y, theme + "_entry")
	
	rng.randomize()
	
	for _i in range(length):
		match(rng.randi_range(0,1)):
			0:
				pointer = placeJSONTileChunk(pointer.x, pointer.y, theme + "_straight_%d" % [rng.randi_range(0, 9)])
			1:
				pointer = placeJSONTileChunk(pointer.x, pointer.y, theme + "_sloped_%d" % [rng.randi_range(0, 4)])
	
	pointer = placeJSONTileChunk(pointer.x, pointer.y, theme + "_exit")
	
	tileMap.update_dirty_quadrants()
	
	return pointer
