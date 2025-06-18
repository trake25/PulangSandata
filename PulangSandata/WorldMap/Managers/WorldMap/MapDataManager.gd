extends Node

const temp_map := "user://data/maps/map_data.json"
@onready var data_io_manager : Node
@onready var tile_map_renderer : Node2D

var tile_map: Dictionary = {}  # Dictionary<Vector2i, Tile_Data>

func _ready() -> void:
	Initializer.mapdata_isready = true
	print("Map Data Manager is ready")
	

func initialize():
	data_io_manager = DataIOManager
	tile_map_renderer = TileMapRenderer
	load_map_data()
	print("Map Data Manager initialized")
	
func load_map_data() -> bool:
	var loaded_data : Dictionary = data_io_manager.load_data(temp_map)

	if loaded_data.size() > 0:
		tile_map.clear()
		for coord_str in loaded_data.keys():
			var coord : Vector2i = str_to_vector2i(coord_str)
			var tile_data_dict = loaded_data[coord_str]
			if typeof(tile_data_dict) == TYPE_DICTIONARY:
				var tile_data := Tile_Data.new()
				tile_data.from_dict(tile_data_dict)
				tile_map[coord] = tile_data
			else:
				print("Invalid tile data for key: %s" % coord_str)
		print("Map loaded successfully. Total tiles loaded: ", tile_map.size())
		return true
	else:
		print("No saved map found or failed to load. Tile map is empty.")
		return false

func save_map_data() -> void:
	var save_dict := {}
	for coord in tile_map:
		save_dict[str(coord)] = tile_map[coord].to_dict()
	data_io_manager.save_data(save_dict, temp_map)

func get_tile(coord: Vector2i) -> Tile_Data:
	return tile_map.get(coord, null)

func set_tile(coord: Vector2i, tile_data: Tile_Data) -> void:
	tile_map[coord] = tile_data
	tile_map_renderer.update_tile(coord)
	save_map_data()

func str_to_vector2i(s: String) -> Vector2i:
	var regex = RegEx.new()
	if regex.compile(r"\((-?\d+),\s*(-?\d+)\)") != OK:
		push_error("Regex compile error")
		return Vector2i.ZERO

	var result = regex.search(s)
	if result == null:
		push_error("Invalid coordinate string: %s" % s)
		return Vector2i.ZERO

	return Vector2i(int(result.get_string(1)), int(result.get_string(2)))
