extends Editor_Interface

@onready var terrain_keys: Array = TerrainConfig.get_all_terrain_types()
@onready var active_terrain_index: int = 0
@onready var active_terrain_type: String = terrain_keys[active_terrain_index]
@onready var active_terrain_category: String = TerrainConfig.get_category_for_terrain(active_terrain_type)

func _unhandled_input(event):
	if editor_mode and event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
		active_terrain_index = (active_terrain_index + 1) % terrain_keys.size()
		active_terrain_type = terrain_keys[active_terrain_index]
		active_terrain_category = TerrainConfig.get_category_for_terrain(active_terrain_type)
		print("Terrain Category: ", active_terrain_category, " Type: ", active_terrain_type)

func apply_to_tile(coord: Vector2i) -> void:
	var tile = MapDataManager.get_tile(coord)
	if tile == null:
		tile = Tile_Data.new()
		print("Created a new tile.")

	tile.terrain_type = active_terrain_type
	tile.terrain_category = active_terrain_category
	MapDataManager.set_tile(coord, tile)

	print("Tile terrain set to: ", tile.terrain_type)
