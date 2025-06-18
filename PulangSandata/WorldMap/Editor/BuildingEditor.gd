# res://WorldMapMVP/editor/BuildingEditor.gd
extends Editor_Interface

@onready var active_building_index: int = 0
@onready var active_building_type: String = BuildingConfig.get_all_building_types()[0]

func _unhandled_input(event):
	if editor_mode and event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
		cycle_building()

func cycle_building():
	var buildings = BuildingConfig.get_all_building_types()
	active_building_index += 1
	if active_building_index >= buildings.size():
		active_building_index = 0
	active_building_type = buildings[active_building_index]
	print("Building set to: ", active_building_type)

func apply_to_tile(coord: Vector2i) -> void:
	var tile = MapDataManager.get_tile(coord)
	if tile == null:
		tile = Tile_Data.new()
		print("Created a new tile.")

	var terrain_category = tile.terrain_category
	if BuildingConfig.is_valid_on_category(active_building_type, terrain_category):
		tile.building = active_building_type
		MapDataManager.set_tile(coord, tile)
		print("Tile building set to: ", tile.building)
	else:
		print("Invalid building for this terrain category.")
