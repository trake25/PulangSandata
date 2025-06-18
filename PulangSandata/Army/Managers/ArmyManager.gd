# ArmyManager.gd
# Responsible for managing deployed armies and their data
# Uses UnitManager as reference for retrieving unit data
extends Node

const PATH := "user://data/army/armies_data.json"

@onready var all_armies : Dictionary = {}   # army_id (String) : Army_Data
@onready var next_army_id : int = 1

# Reference to UnitManager (must be set externally or as a singleton)
var unit_manager: UnitManager = null

func _ready() -> void:
	Initializer.armymanager_isready = true
	print("Army Manager ready")

func initialize() -> void:
	load_all_armies()
	print("Army Manager initialized")

func create_army(faction_id: String, army_name: String, deployed_units: Array, total_supplies: Dictionary) -> Army_Data:       #deployed_units Array of Unit_Data
	var army = Army_Data.new()
	army.army_id = str(next_army_id)
	army.army_faction = faction_id
	army.army_name = "Army" + str(army.army_id) + " " + army_name
	army.commander_id = deployed_units[0].unit_id
	army.location = WorldBuildingManager.player_settlement.world_building_coord
	army.cur_pos = InputManager.tile_map.map_to_local(army.location)
	

	# Compute stats based on unit data
	var total_max_health = 0
	var total_health = 0
	var total_attack = 0
	var total_defense = 0
	var total_morale = 0
	var total_move = 0
	var total_build = 0
	var food_upkeep = 0
	var wood_upkeep = 0
	var weapons_upkeep = 0
	var wealth_upkeep = 0
	var supplies = total_supplies
	var promotions = []

	for unit in deployed_units:
		army.army_units.append(unit.unit_id)
		
		total_max_health += unit.battle_stats["max_health"]
		total_health += unit.battle_stats["health"]
		total_attack += unit.battle_stats["attack_power"]
		total_defense += unit.battle_stats["defense_power"]
		total_morale += unit.battle_stats["morale"]
		total_move += unit.world_stats["move_speed"]
		total_build += unit.world_stats["build_speed"]		
		
		food_upkeep += unit.deployment_upkeep.get("food", 0)
		wood_upkeep += unit.deployment_upkeep.get("wood",0)
		weapons_upkeep += unit.deployment_upkeep.get("weapons", 0)
		wealth_upkeep += unit.deployment_upkeep.get("wealth", 0)

		promotions.append_array(unit.unit_promotions)
		
		

	# Set computed stats
	
	army.battle_stats["total_max_health"] = total_max_health
	army.battle_stats["total_health"] = total_health
	army.battle_stats["total_attack_power"] = total_attack
	army.battle_stats["total_defense_power"] = total_defense
	army.battle_stats["average_morale"] = int(total_morale / deployed_units.size())
	army.world_stats["move_speed"] = float(total_move / deployed_units.size())
	army.world_stats["build_speed"] = float(total_build / deployed_units.size())
	army.battle_stats["visual_power_ratio"] = int((total_defense / total_attack) * 10)

	army.supplies = supplies

	army.deployment_upkeep["food"] = food_upkeep
	army.deployment_upkeep["wood"] = wood_upkeep
	army.deployment_upkeep["weapons"] = weapons_upkeep
	army.deployment_upkeep["wealth"] = wealth_upkeep

	army.army_promotions = promotions

	all_armies[str(army.army_id)] = army
	next_army_id += 1
	save_all_armies()
	return army

func is_coords_occupied(coords: Vector2i) -> bool:
	for army in all_armies:
		if army.location == coords:
			return true
	return false

func execute_command(army_key: String) -> void:
	var command = all_armies[army_key].world_command
	match command:
		"Capture":
			army_capture_tile(army_key)

func army_capture_tile(army_key: String) -> void:
	var raw_coords = InputManager.selected_coord
	if set_army_path(army_key, raw_coords):
		for child in Initializer.army_renderer.get_children():
			child.change_state("Marching")
	

func get_army(army_id: String) -> Army_Data:
	return all_armies.get(army_id, null)

func remove_army(army_id: String) -> void:
	all_armies.erase(army_id)
	save_all_armies()

func save_all_armies() -> void:
	var data : Dictionary = {}
	for id in all_armies:
		data[id] = all_armies[id].to_dict()
	DataIOManager.save_data(data, PATH)

func load_all_armies() -> void:
	var loaded_armies = DataIOManager.load_data(PATH)
	if loaded_armies.is_empty():
		print("Loaded Army data is empty.")
		return

	var highest_id = 0
	all_armies.clear()
	
	for key in loaded_armies.keys():
		var army = Army_Data.new()
		army.from_dict(loaded_armies[key])
		all_armies[key] = army
		
		if int(army.army_id) > highest_id:
			highest_id = int(army.army_id)

	next_army_id = highest_id + 1
	print("All Armies are loaded.")
	print("Next army id: ", next_army_id)

func set_army_path(army_id: String, destination: Vector2i) -> bool:
	if not all_armies.has(army_id):
		return false

	var army_data = all_armies[army_id]
	var start_coord = army_data.location
	var path : Array = Initializer.astar_grid.find_path(start_coord, destination)

	if path.is_empty():
		return false  # Invalid move

	# Store movement orders
	print(path)
	army_data.cur_pos = path.pop_front()
	army_data.path = path
	return true

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		print("💾 All Army Data saved on application quit.")
		save_all_armies()

func quit_game():
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	get_tree().quit()
