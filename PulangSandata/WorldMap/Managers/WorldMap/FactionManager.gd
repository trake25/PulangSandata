extends Node

@onready var faction_config: Faction_Config
@onready var player_resources: Control

const TEMP_PATH := "user://data/faction/factions_data.json"
@onready var factions : Dictionary = {}  # key: String => Faction_Data
@onready var player_settlement_coords : Vector2i = Vector2i.ZERO
@onready var player_faction : Faction_Data
@onready var player_faction_id : String

# Called when node is added to the scene
func _ready() -> void:
	Initializer.factionmanager_isready = true
	print("Faction Manager is ready.")

func initialize() -> void:
	faction_config = FactionConfig
	player_resources = Initializer.player_resources
	load_factions(TEMP_PATH)
	link_factions_to_world()
	update_player_resources()
	print("Faction Manager is initialized.")

func update_player_resources() -> void:
	var food_label = player_resources.food_label
	var wood_label = player_resources.wood_label
	var weapons_label = player_resources.weapons_label
	var wealth_label = player_resources.wealth_label
	var player_food = str(int(player_faction.resources["food"]))
	var player_wood = str(int(player_faction.resources["wood"]))
	var player_weapons = str(int(player_faction.resources["weapons"]))
	var player_wealth = str(int(player_faction.resources["wealth"]))
	food_label.text = "Food🌾: "
	food_label.text += player_food
	wood_label.text = "Wood🎋: "
	wood_label.text += player_wood
	weapons_label.text = "Weapons⚔️: "
	weapons_label.text += player_weapons
	wealth_label.text = "Wealth🟡: "
	wealth_label.text += player_wealth
	
func link_factions_to_world() -> void:
	player_faction = get_player_faction()
	player_faction_id = player_faction.faction_id
	
	for coords in MapDataManager.tile_map:
		var tile_data = MapDataManager.tile_map[coords]
		if tile_data.building == "Settlement":
			if tile_data.owner != "" and tile_data.owner != "none":
				print("Settlement: ",coords," Owner: ",tile_data.owner)
				if player_faction.faction_id == get_faction_data(tile_data.owner).faction_id:
					player_settlement_coords = coords
					
					print("Player faction is: ",tile_data.owner)
			
# === Load Factions from Save or Config ===
func load_factions(file_path: String) -> void:
	var loaded_data := DataIOManager.load_data(file_path)

	if loaded_data.is_empty():
		loaded_data = _create_default_factions()

	for key in loaded_data.keys():
		var faction := Faction_Data.new()
		faction.from_dict(loaded_data[key])
		factions[key] = faction

	print("Factions loaded: ", factions.keys())


# === Save Factions ===
func save_factions() -> void:
	var data := {}
	for key in factions.keys():
		data[key] = factions[key].to_dict()
	DataIOManager.save_data(data, TEMP_PATH)


# === Accessors ===
func get_faction_data(key: String) -> Faction_Data:
	return factions.get(key, null)

func get_all_factions() -> Array[String]:
	return factions.keys()

func get_player_faction() -> Faction_Data:
	for faction in factions.values():
		if faction.is_player:
			return faction
	return null

func get_player_faction_key() -> String:
	for key in factions.keys():
		if factions[key].is_player:
			return key
	return "none"


# === Helpers for Static Info from Config ===
func get_faction_name(key: String) -> String:
	return faction_config.get_faction_info(key).faction_name

func get_color(key: String) -> String:
	return faction_config.get_faction_info(key).color

func get_atlas_id(key: String) -> Vector2i:
	return faction_config.get_faction_info(key).atlas_id

func get_source_id(key: String) -> int:
	return faction_config.get_faction_info(key).source_id


# === Default Faction Creation (if no save exists) ===
func _create_default_factions() -> Dictionary:
	var result := {}

	for key in faction_config.get_all_factions():
		var base_info := faction_config.get_faction_info(key)
		var faction := Faction_Data.new()
		faction.faction_id = base_info.faction_id
		faction.faction_name = base_info.faction_name
		faction.color = base_info.color
		faction.atlas_id = base_info.atlas_id
		faction.source_id = base_info.source_id
		faction.is_player = base_info.is_player
		faction.home_settlement_id = base_info.home_settlement_id
		faction.resources = Faction_Config.DEFAULT_RESOURCES
		# You can customize defaults here if needed
		result[key] = faction.to_dict()

	factions = {}  # clear live dictionary before loading new
	for key in result.keys():
		var faction := Faction_Data.new()
		faction.from_dict(result[key])
		factions[key] = faction

	print("Saving default Factions.")
	DataIOManager.save_data(result, TEMP_PATH)
	return result

func quit_game():
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	get_tree().quit()

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		print("💾 Factions Data saved on application quit.")
		save_factions()
