extends Control

@onready var player_settlement : Control
@onready var camera_manager : Camera2D
@onready var tile_map : TileMapLayer

@onready var tile_info_vbox_top : VBoxContainer = $TileInfoHboxT
@onready var player_settlement_vboxtc : VBoxContainer = $PlayerSettlementTC
@onready var neutral_adjacent_vboxtc : VBoxContainer = $NeutralAdjacentTC
@onready var neutral_notadjacent_vboxtc : VBoxContainer = $NeutralNonAdjacentTC
@onready var non_player_adjacent_vboxtc : VBoxContainer = $NonPlayerAdjacentTC
@onready var non_player_non_adjacent_vboxtc : VBoxContainer = $NonPlayerNonAdjacentTC
@onready var player_tile_building : VBoxContainer = $PlayerTileBuildingTC
@onready var player_tile_no_building : VBoxContainer = $PlayerTileNoBuildingTC

@onready var tile_info_label : Label = %TileInfo
@onready var tile_owner_info_label : Label = %TileOwnerInfo

@onready var tile_command_position : Vector2i = Vector2i.ZERO


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Initializer.tile_commands = self
	Initializer.tilecommands_isready = true
	print("Tile Commands ready")

func initialize() -> void:
	player_settlement = Initializer.player_settlement
	camera_manager = Initializer.camera_manager
	tile_map = camera_manager.tile_map
	hide_all_tile_commands()
	print("Tile Commands initialized")

func hide_all_tile_commands() -> void:
	tile_info_vbox_top.visible = false
	player_settlement_vboxtc.visible = false
	neutral_adjacent_vboxtc.visible = false
	neutral_notadjacent_vboxtc.visible = false
	non_player_adjacent_vboxtc.visible = false
	non_player_non_adjacent_vboxtc.visible = false
	player_tile_building.visible = false
	player_tile_no_building.visible = false
	self.visible = false
	tile_info_label.text = ""
	tile_owner_info_label.text = ""

func show_tile_info_top ()-> void:
	tile_info_vbox_top.visible = true

func show_player_settlement_tc()-> void:
	if player_settlement.player_settlement_data:
		tile_info_label.text = player_settlement.player_settlement_data.world_building_custom_name
		tile_owner_info_label.text = player_settlement.player_faction.faction_name
		position = camera_manager.camera_settlement_pos
		show_tile_info_top()
		player_settlement_vboxtc.visible = true
		self.visible = true

func show_neutral_adjacent_tc() -> void:
	var selected_coord = InputManager.selected_coord
	var selected_tile_data = MapDataManager.get_tile(selected_coord)
	tile_command_position = tile_map.map_to_local(selected_coord)
	
	if selected_tile_data.terrain_category == "Water":
		tile_info_label.text = selected_tile_data.terrain_type
		position = tile_command_position
		show_tile_info_top()
		self.visible = true
	else:
		tile_owner_info_label.text = FactionManager.factions[selected_tile_data.owner].faction_name
		if selected_tile_data.feature != "none":
			tile_info_label.text = selected_tile_data.feature
		else:
			tile_info_label.text = selected_tile_data.terrain_type
		position = tile_command_position
		show_tile_info_top()
		neutral_adjacent_vboxtc.visible = true
		self.visible = true

func show_neutral_non_adjacent_tc() -> void:
	var selected_coord = InputManager.selected_coord
	var selected_tile_data = MapDataManager.get_tile(selected_coord)
	tile_command_position = tile_map.map_to_local(selected_coord)
	
	if selected_tile_data.terrain_category == "Water":
		tile_info_label.text = selected_tile_data.terrain_type
		position = tile_command_position
		show_tile_info_top()
		self.visible = true
	else:
		tile_owner_info_label.text = FactionManager.factions[selected_tile_data.owner].faction_name
		if selected_tile_data.feature != "none":
			tile_info_label.text = selected_tile_data.feature
		else:
			tile_info_label.text = selected_tile_data.terrain_type
		position = tile_command_position
		show_tile_info_top()
		neutral_notadjacent_vboxtc.visible = true
		self.visible = true

func show_non_player_adjacent_tc() -> void:
	var selected_coord = InputManager.selected_coord
	var selected_tile_data = MapDataManager.get_tile(selected_coord)
	tile_command_position = tile_map.map_to_local(selected_coord)
	
	tile_owner_info_label.text = FactionManager.factions[selected_tile_data.owner].faction_name
	if selected_tile_data.building != "none":
		tile_info_label.text = selected_tile_data.building
	elif selected_tile_data.feature != "none":
		tile_info_label.text = selected_tile_data.feature
	else:
		tile_info_label.text = selected_tile_data.terrain_type
		
	position = tile_command_position
	show_tile_info_top()
	non_player_adjacent_vboxtc.visible = true
	self.visible = true

func show_non_player_non_adjacent_tc() -> void:
	var selected_coord = InputManager.selected_coord
	var selected_tile_data = MapDataManager.get_tile(selected_coord)
	tile_command_position = tile_map.map_to_local(selected_coord)
	
	tile_owner_info_label.text = FactionManager.factions[selected_tile_data.owner].faction_name
	if selected_tile_data.building != "none":
		tile_info_label.text = selected_tile_data.building
	elif selected_tile_data.feature != "none":
		tile_info_label.text = selected_tile_data.feature
	else:
		tile_info_label.text = selected_tile_data.terrain_type
		
	position = tile_command_position
	show_tile_info_top()
	non_player_non_adjacent_vboxtc.visible = true
	self.visible = true

func show_player_tile_building_tc() -> void:
	var selected_coord = InputManager.selected_coord
	var selected_tile_data = MapDataManager.get_tile(selected_coord)
	tile_command_position = tile_map.map_to_local(selected_coord)
	
	tile_owner_info_label.text = FactionManager.factions[selected_tile_data.owner].faction_name
	if selected_tile_data.building != "none":
		tile_info_label.text = selected_tile_data.building
	elif selected_tile_data.feature != "none":
		tile_info_label.text = selected_tile_data.feature
	else:
		tile_info_label.text = selected_tile_data.terrain_type
		
	position = tile_command_position
	show_tile_info_top()
	player_tile_building.visible = true
	self.visible = true

func show_player_tile_no_building_tc() -> void:
	var selected_coord = InputManager.selected_coord
	var selected_tile_data = MapDataManager.get_tile(selected_coord)
	tile_command_position = tile_map.map_to_local(selected_coord)
	
	tile_owner_info_label.text = FactionManager.factions[selected_tile_data.owner].faction_name
	if selected_tile_data.building != "none":
		tile_info_label.text = selected_tile_data.building
	elif selected_tile_data.feature != "none":
		tile_info_label.text = selected_tile_data.feature
	else:
		tile_info_label.text = selected_tile_data.terrain_type
		
	position = tile_command_position
	show_tile_info_top()
	player_tile_no_building.visible = true
	self.visible = true

func show_unexplored_tc() -> void:
	var selected_coord = InputManager.selected_coord
	var selected_tile_data = MapDataManager.get_tile(selected_coord)
	tile_command_position = tile_map.map_to_local(selected_coord)
	
	if not selected_tile_data:
		tile_info_label.text = "Unexplored\nRegion"
		position = tile_command_position
		show_tile_info_top()
		self.visible = true

func tile_command(tile_identity: String) -> void:
	match tile_identity:
		"Neutral Adjacent":
			show_neutral_adjacent_tc()
			print("Neutral Adjacent Tile")
		"Neutral Non-Adjacent":
			show_neutral_non_adjacent_tc()
			print("Neutral Non-Adjacent Tile")
		"Player No Building":
			show_player_tile_no_building_tc()
			print("Player Tile - No Building")
		"Player Settlement":
			show_player_settlement_tc()
			print("Player Settlement")
		"Player Building":
			show_player_tile_building_tc()
			print("Player Tile - With Building")
		"Non-Player Adjacent":
			show_non_player_adjacent_tc()
			print("Enemy Tile Adjacent")
		"Non-Player Non-Adjacent":
			show_non_player_non_adjacent_tc()
			print("Enemy Tile Non-Adjacent")
		"Unexplored":
			show_unexplored_tc()
			print("Unexplored Tile")
		_:
			print("Unknown tile identity:", tile_identity)
