extends Resource
class_name Unit_Data

## Identifiers
var unit_id: String = "-1"
var unit_name: String = "Tanod"
var unit_type: String = "Militia"  # Militia, Laborers, etc.
var army_id: String = "-1"

## World Map Stats
var world_stats := {
	"move_speed": 1,
	"build_speed": 1,
	"status": "Garrisoned",  # Garrisoned or Mustered
}

## Battle Stats
var battle_stats := {
	"max_health": 100,
	"health": 100,
	"morale": 100,
	"attack_power": 20,
	"defense_power": 10,
	"attack_range": 1,
	"battle_pc": "IDLE",  # IDLE, ATTACK, DEFEND, etc.
}

## Promotions
var unit_promotions: Array = []

## Garrison Upkeep (Settlement level)
var garrison_upkeep := {
	"food": 5,
	"wealth": 5,
}

## Deployment Cost (One-time cost at deployment)
var min_deployment_cost := {
	"food": 10,
	"weapons": 10,
	"wealth": 5,
}

## Deployment Upkeep (Per turn upkeep)
var deployment_upkeep := {
	"food": 5,
	"wood": 0,
	"weapons": 2,
	"wealth": 1,
}

## -- Serialization --
func to_dict() -> Dictionary:
	return {
		"unit_id": unit_id,
		"unit_name": unit_name,
		"unit_type": unit_type,
		"army_id": army_id,
		"world_stats": world_stats,
		"battle_stats": battle_stats,
		"unit_promotions": unit_promotions,
		"garrison_upkeep": garrison_upkeep,
		"min_deployment_cost": min_deployment_cost,
		"deployment_upkeep": deployment_upkeep,
	}

func from_dict(data: Dictionary) -> void:
	unit_id = data.get("unit_id", "-1")
	unit_name = data.get("unit_name", "Tanod")
	unit_type = data.get("unit_type", "Militia")
	army_id = data.get("army_id", "-1")
	world_stats = data.get("world_stats", {})
	battle_stats = data.get("battle_stats", {})
	unit_promotions = data.get("unit_promotions", [])
	garrison_upkeep = data.get("garrison_upkeep", {})
	min_deployment_cost = data.get("min_deployment_cost", {})
	deployment_upkeep = data.get("deployment_upkeep", {})
