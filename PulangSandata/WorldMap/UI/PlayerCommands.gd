extends Control

@onready var input_manager : Node
@onready var camera_manager : Camera2D
@onready var tile_commands : Control
@onready var player_settlement : Control
@onready var army_deployment : Control
@onready var army_selection : Control


# === Player Home Coord ===
@onready var player_settlement_coords

func _ready() -> void:
	Initializer.player_commands = self
	Initializer.playercommands_isready = true
	print("Player Commands ready")

func initialize() -> void:
	input_manager = InputManager
	camera_manager = Initializer.camera_manager
	player_settlement_coords = FactionManager.player_settlement_coords
	tile_commands = Initializer.tile_commands
	player_settlement = %PlayerSettlement
	army_deployment = Initializer.army_deployment
	army_selection = Initializer.army_selection
	print("Player Commands initialized")


func _on_player_home_pressed() -> void:
	camera_manager.global_position = camera_manager.camera_settlement_pos
	InputManager.select_tile(player_settlement_coords)
	
	#tile_commands.tile_info_label.text = player_settlement.player_settlement.world_building_custom_name
	#tile_commands.tile_owner_info_label.text = player_settlement.player_faction.faction_name
	#tile_commands.position = camera_manager.camera_settlement_pos
	tile_commands.show_player_settlement_tc()
	


func _on_enter_pressed() -> void:
	tile_commands.hide_all_tile_commands()
	InputManager.selection_lock = true
	player_settlement.visible = true


func _on_deploy_pressed() -> void:
	var garrisons : Array = player_settlement.player_settlement_data.garrison_units
	tile_commands.hide_all_tile_commands()
	InputManager.selection_lock = true
	army_deployment.populate_garrison_units(garrisons)
	army_deployment.visible = true
	


func _on_capture_pressed() -> void:
	
	tile_commands.hide_all_tile_commands()
	InputManager.selection_lock = true
	InputManager.deselect_tile()
	army_selection.command_label.text = "Capture"
	army_selection.populate_army_select()
	army_selection.visible = true
	
	#var raw_coords = InputManager.selected_coord
	#for army_key in ArmyManager.all_armies.keys():
	#	if ArmyManager.set_army_path(army_key, raw_coords):
	#		print("Army set to path.")
		#else:
		#	print("Unable to set army path")
		
	#for child in Initializer.army_renderer.get_children():
	#	child.change_state("Marching")
