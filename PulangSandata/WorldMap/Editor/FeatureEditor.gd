# res://WorldMapMVP/editors/FeatureEditor.gd
extends Editor_Interface

@onready var active_feature_index: int = 0
@onready var active_feature_type: String = FeatureConfig.get_all_features()[0]

func _unhandled_input(event):
	if editor_mode and event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
		cycle_feature()

func cycle_feature():
	var features = FeatureConfig.get_all_features()
	active_feature_index += 1
	if active_feature_index >= features.size():
		active_feature_index = 0
	active_feature_type = features[active_feature_index]
	print("Feature set to: ", active_feature_type)

func apply_to_tile(coord: Vector2i) -> void:
	var tile = MapDataManager.get_tile(coord)
	if tile == null:
		tile = Tile_Data.new()
		print("Created a new tile.")

	var terrain_category = tile.terrain_category
	if FeatureConfig.is_valid_feature_on_category(active_feature_type, terrain_category):
		tile.feature = active_feature_type
		MapDataManager.set_tile(coord, tile)
		print("Tile feature set to: ", tile.feature)
	else:
		print("Invalid feature for this terrain category.")
