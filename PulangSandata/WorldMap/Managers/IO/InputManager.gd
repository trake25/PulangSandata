# res://WorldMapMVP/Managers/InputManager.gd
extends Node

@onready var tile_map: TileMapLayer
@onready var camera_manager: Camera2D
@onready var player_commands: Control
@onready var tile_commands: Control

# Editor references
@onready var TerrainEditor: Editor_Interface = $TerrainEditor
@onready var FactionEditor: Editor_Interface = $FactionEditor
@onready var FeatureEditor: Editor_Interface = $FeatureEditor
@onready var BuildingEditor: Editor_Interface = $BuildingEditor

# Editor registry
@onready var editors := {
	"terrain": TerrainEditor,
	"feature": FeatureEditor,
	"building": BuildingEditor,
	"faction": FactionEditor
}

@onready var active_editor_name: String = ""
@onready var selected_coord: Vector2i
@onready var last_click_time : float = 0.0
@onready var double_click_threshold : float = 0.3
@onready var selection_lock : bool = false

func _ready() -> void:
	Initializer.inputmanager_isready = true
	print("Input Manager ready")

func initialize() -> void:
	player_commands = Initializer.player_commands
	tile_commands = Initializer.tile_commands
	
	print("Input Manager initialized")
	
func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed and not selection_lock:
		handle_tile_selection()
		
	# Editor switching inputs
	if event.is_action_pressed("Terrain Editor Mode"):
		toggle_editor("terrain")
	elif event.is_action_pressed("Faction Editor Mode"):
		toggle_editor("faction")
	elif event.is_action_pressed("Feature Editor Mode"):
		toggle_editor("feature")
	elif event.is_action_pressed("Building Editor Mode"):
		toggle_editor("building")

func handle_tile_selection():
	var global_pos = camera_manager.get_global_mouse_position()
	var local_coord = tile_map.to_local(global_pos)
	var tile_coord = tile_map.local_to_map(local_coord)
	selected_coord = tile_coord
		
	print("Selected: ", selected_coord)
	select_tile(selected_coord)

	if active_editor_name != "":
		var editor: Editor_Interface = editors[active_editor_name]
		editor.apply_to_tile(selected_coord)
	else:
		handle_tile_commands(selected_coord)

func select_tile(coords: Vector2i) -> void:
	TileMapRenderer.tilemap_highlight.clear()
	TileMapRenderer.tilemap_highlight.set_cell(coords, 1, Vector2i(0, 0))

func handle_tile_commands(coords: Vector2i) -> void:
	tile_commands.hide_all_tile_commands()

	var selected_tile_data = MapDataManager.get_tile(coords)
	if not selected_tile_data:
		tile_commands.tile_command("Unexplored")
		return

	var player_faction_key = FactionManager.get_player_faction_key()
	var is_selected_owned_by_player = selected_tile_data.owner == player_faction_key
	var is_selected_neutral = selected_tile_data.owner == "none"

	
	var is_adjacent_to_player = false
	for cell in tile_map.get_surrounding_cells(coords):
		var tile_data = MapDataManager.get_tile(cell)
		if tile_data and tile_data.owner == player_faction_key:
			is_adjacent_to_player = true
			break

	if is_selected_neutral:
		if is_adjacent_to_player:
			tile_commands.tile_command("Neutral Adjacent")
		else:
			tile_commands.tile_command("Neutral Non-Adjacent")
	elif is_selected_owned_by_player:
		if selected_tile_data.building == "none":
			tile_commands.tile_command("Player No Building")
		elif selected_tile_data.building == "Settlement":
			tile_commands.tile_command("Player Settlement")
		else:
			tile_commands.tile_command("Player Building")
	else: 
		if is_adjacent_to_player:
			tile_commands.tile_command("Non-Player Adjacent")
		else:
			tile_commands.tile_command("Non-Player Non-Adjacent")

func toggle_editor(toggle_name: String):
	for editor_name in editors.keys():
		var editor = editors[editor_name]
		var is_active = editor_name == toggle_name and editor_name != active_editor_name
		editor.editor_mode = is_active

	if active_editor_name == toggle_name:
		print(toggle_name.capitalize(), " editor deactivated.")
		active_editor_name = ""
	else:
		print(toggle_name.capitalize(), " editor activated.")
		active_editor_name = toggle_name
