# File: res://WorldMap/Data/Faction/Faction_Config.gd
extends Node
class_name Faction_Config

const DEFAULT_RESOURCES := {
	"food": 50,
	"wealth": 50,
	"weapons": 50,
	"wood": 50,
}

var faction_data: Dictionary = {
	"none": {
		"faction_id": "none",
		"faction_name": "Neutral",
		"color": "#ffff00",
		"source_id": -1,
		"atlas_id": Vector2i(-1, -1),
		"is_player": false,
		"home_settlement_id": -1,
	},
	"2": {
		"faction_id": "2",
		"faction_name": "Blood Tribes",
		"color": "#ff0000",
		"source_id": 1,
		"atlas_id": Vector2i(0, 0),
		"is_player": false,
		"home_settlement_id": -1,
	},
	"1": {
		"faction_id": "1",
		"faction_name": "Pintados",
		"color": "#0000ff",
		"source_id": 2,
		"atlas_id": Vector2i(0, 0),
		"is_player": true,
		"home_settlement_id": -1,
	}
}

func _ready() -> void:
	Initializer.factionconf_isready = true
	print("Faction Config ready")

func get_faction_info(key: String) -> Dictionary:
	if faction_data.has(key):
		return faction_data[key]
	return {
		"faction_id": "-1",
		"faction_name": "Unknown",
		"color": "#ffff00",
		"source_id": -1,
		"atlas_id": Vector2i(-1, -1),
		"is_player": false,
		"home_settlement_id": -1,
	}

func get_all_factions() -> Array:
	return faction_data.keys()

func get_faction_data(key: String) -> Faction_Data:
	if not faction_data.has(key):
		return Faction_Data.new()

	var raw = faction_data[key]
	var data := Faction_Data.new()
	data.faction_id = raw.get("faction_id", "-1")
	data.faction_name = raw.get("faction_name", "")
	data.color = raw.get("color", "#ffffff")
	data.source_id = raw.get("source_id", 0)
	data.atlas_id = raw.get("atlas_id", Vector2i.ZERO)
	data.is_player = raw.get("is_player", false)
	data.home_settlement_id = raw.get("home_settlement_id", -1)
	data.resources = DEFAULT_RESOURCES.duplicate()
	return data


func get_all_faction_data() -> Array:
	var result : Array = []
	for key in get_all_factions():
		result.append(get_faction_data(key))
	return result
