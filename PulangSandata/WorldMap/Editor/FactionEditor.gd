# res://WorldMapMVP/Editor/FactionEditor.gd
extends Editor_Interface

@onready var active_faction: String = "red"
@onready var active_faction_index: int = 0
@onready var faction_keys: Array = FactionConfig.get_all_factions()

func _ready() -> void:
	pass

func _unhandled_input(event):
	if editor_mode and event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
		active_faction_index = (active_faction_index + 1) % faction_keys.size()
		active_faction = faction_keys[active_faction_index]
		print("Active Faction: ", active_faction)

func apply_to_tile(coord: Vector2i) -> void:
	var tile = MapDataManager.get_tile(coord)
	if tile == null:
		tile = Tile_Data.new()
		print("Created a new tile.")

	tile.owner = active_faction
	MapDataManager.set_tile(coord, tile)

	print("Tile ownership set to: ", tile.owner)
