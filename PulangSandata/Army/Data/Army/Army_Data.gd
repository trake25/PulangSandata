extends Resource
class_name Army_Data

## Identifiers
var army_id: String = "-1"
var army_name: String = "Army"
var commander_id: int = -1
var army_faction: String = "-1"
var army_units: Array = []  # List of unit_ids

## Core Position (tile coordinate)
var location: Vector2i = Vector2i.ZERO  # tilemap coords for logic

## Movement Path (world coordinates)
var cur_pos: Vector2 = Vector2.ZERO
var path: Array = []  # array of Vector2

## World Map Stats
var world_stats: Dictionary = {
	"move_speed": 0,
	"build_speed": 0,
}

## Army Orders
var world_status: String = "Idle"  # Idle, Marching, Garrisoned, Defending, Capturing, Battling, etc.
var world_command: String = "None"  # None, Defend, Capture, Build, Attack, Raid, etc.

## Carried Supplies
var supplies := {
	"food": 0,
	"wood": 0,
	"weapons": 0,
	"wealth": 0,
}

## Aggregated Battle Stats
var battle_stats := {
	"total_max_health": 0,
	"total_health": 0,
	"average_morale": 0,
	"total_attack_power": 0,
	"total_defense_power": 0,
	"visual_power_ratio": 0,  # (def/atk)*10
}

## Promotions
var army_promotions: Array = []

## World Upkeep
var deployment_upkeep := {
	"food": 0,
	"wood": 0,
	"weapons": 0,
	"wealth": 0,
}

## --- Serialization ---
func to_dict() -> Dictionary:
	var path_serialized := []
	for pos in path:
		path_serialized.append([pos.x, pos.y])
	
	return {
		"army_id": army_id,
		"army_name": army_name,
		"commander_id": commander_id,
		"army_faction": army_faction,
		"army_units": army_units,
		"location": [location.x, location.y],

		"cur_pos": [cur_pos.x, cur_pos.y],
		"path": path_serialized,

		"world_stats": world_stats,
		"world_status": world_status,
		"world_command": world_command,
		
		"supplies": supplies,
		"battle_stats": battle_stats,
		"army_promotions": army_promotions,
		"deployment_upkeep": deployment_upkeep,
	}

func from_dict(data: Dictionary) -> void:
	army_id = data.get("army_id", "-1")
	army_name = data.get("army_name", "Army")
	commander_id = data.get("commander_id", -1)
	army_faction = data.get("army_faction", "-1")
	army_units = data.get("army_units", [])
	
	var loc = data.get("location", [0, 0])
	location = Vector2i(loc[0], loc[1])

	var cp = data.get("cur_pos", [0.0, 0.0])
	cur_pos = Vector2(cp[0], cp[1])

	path.clear()
	for pos in data.get("path", []):
		path.append(Vector2(pos[0], pos[1]))

	world_stats = data.get("world_stats", {})
	world_status = data.get("world_status", "Idle")
	world_command = data.get("world_command", "Defend")
	supplies = data.get("supplies", {})
	battle_stats = data.get("battle_stats", {})
	army_promotions = data.get("army_promotions", [])
	deployment_upkeep = data.get("deployment_upkeep", {})
