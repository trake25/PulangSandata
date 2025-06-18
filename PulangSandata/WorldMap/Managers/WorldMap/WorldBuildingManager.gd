# World Building Manager
extends Node

@onready var data_io_manager : Node
@onready var map_data_manager : Node

@onready var world_buildings : Dictionary = {}     # Dictionary<Vector2i, Settlement_Data, Farm_Data, etc>
@onready var player_settlement : Settlement_Data

const PATH := "user://data/building/buildings_data.json"

func _ready() -> void:
	Initializer.worldbuildingmanager_isready = true
	print("World Building Manager ready")

func initialize() -> void:
	data_io_manager = DataIOManager
	map_data_manager = MapDataManager
	load_world_buildings()
	print("World Building Manager initialized")

func load_world_buildings() -> void:
	var tiles_data_with_building  : Dictionary = {}
	var loaded_buildings : Dictionary = DataIOManager.load_data(PATH)
	for coords in MapDataManager.tile_map:
		var tile_data = MapDataManager.tile_map[coords]
		if tile_data.building != "none" and tile_data.building != "":
			tiles_data_with_building [coords] = tile_data
	
	for coords in tiles_data_with_building.keys() :            # coords vector2i
		var string_coords = str(coords)                      # string coords
		if loaded_buildings.has(string_coords):
			if tiles_data_with_building[coords].building == "Settlement":
				var settlement = Settlement_Data.new()
				settlement.from_dict(loaded_buildings[string_coords])
				world_buildings[coords] = settlement
		else:
			world_buildings[coords] = _create_default_world_building(coords, tiles_data_with_building [coords])
		
		if world_buildings[coords].world_building_faction == FactionManager.get_player_faction_key() and world_buildings[coords].world_building_type == "Settlement":
			player_settlement = world_buildings[coords]
	
	save_world_buildings()

func save_world_buildings() -> void:
	var save_data : Dictionary = {}
	for coords in world_buildings.keys():
		save_data[coords] = world_buildings[coords].to_dict()
	DataIOManager.save_data(save_data, PATH)

func _create_default_world_building(coords: Vector2i, tile_data: Tile_Data) -> WorldBuilding_Data:
	var default_world_building
	match tile_data.building:
		"Settlement":
			default_world_building = Settlement_Data.new()
			default_world_building.world_building_coord = coords
			default_world_building.world_building_faction = tile_data.owner
		"Farm":
			#placeholder
			pass
	return default_world_building

func update_production() -> void:
	for coords in world_buildings.keys():
		var building = world_buildings[coords]
		
		if building.world_building_type == "Settlement":
			ProductionManager.produce_resources(building)
			
	print("World Buildings produced resources.")

func update_consumption() -> void:
	for coords in world_buildings.keys():
		var building = world_buildings[coords]
		
		if building.world_building_type == "Settlement":
			ProductionManager.consume_resources(building)
		
		ContentmentManager.resources_contentment(building)

	print("Settlements consumed resources.")

func update_population() -> void:
	for coords in world_buildings.keys():
		var building = world_buildings[coords]
		if building.world_building_type == "Settlement":
			PopulationManager.update_populations(building)
			
	print("Settlements population updated.")

func collect_taxes() -> void:
	for coords in world_buildings.keys():
		var building = world_buildings[coords]
		if building.world_building_type == "Settlement":
			TaxManager.calculate_taxes(building)
		
		ContentmentManager.tax_contentment(building)
		
	print("Factions collected taxes on Settlements")

func quit_game():
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	get_tree().quit()

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		print("💾 World Building Data saved on application quit.")
		save_world_buildings()
