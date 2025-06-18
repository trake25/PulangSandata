extends Resource
class_name WorldBuilding_Data

# Identity
var world_building_id: int = -1
var world_building_custom_name: String = "Settlement"
var world_building_type: String = "Settlement"  # Could be: "Settlement", "Farm", "Mine", "Lumberyard", "Camp", "Fort", etc
var world_building_coord: Vector2i = Vector2i.ZERO
var world_building_faction: String = "blue"  # Owning faction


var resources : Dictionary = {
	"food": 0,
	"wood": 0,
	"weapons": 0,
	"wealth": 0,
}

var resource_capacity : Dictionary = {
	"food": 500,
	"wood": 500,
	"weapons": 500,
	"wealth": 500,
}

# Mechanics
var production: int = 0           # Produced resources per cycle (specific rules depend on building type)
var tax_rate: float = 0.1         # % of resources taxed to faction per cycle

# Morale System (Settlement Only)
var contentment: int = 51        # 0-100
# If < 51, tax is disabled
# If < 50, % chance of revolt per update: (50 - contentment) * 2%
# Revolting building becomes neutral and is destroyed (if it's a settlement, player loses)
var population: int = 0
var population_limit: int = 500

var upgrades : Dictionary = {}
var recruitable_units : Dictionary = {}
var garrison_units : Array = []


# --- Serialization ---
func to_dict() -> Dictionary:
	return {
		"world_building_id": world_building_id,
		"world_building_custom_name": world_building_custom_name,
		"world_building_type": world_building_type,
		"world_building_coord": [world_building_coord.x, world_building_coord.y],
		"world_building_faction": world_building_faction,
		"resources": resources,
		"resource_capacity": resource_capacity,
		"production": production,
		"tax_rate": tax_rate,
		"contentment": contentment,
		"population": population,
		"population_limit": population_limit,
		"upgrades": upgrades,
		"recruitable_units": recruitable_units,
		"garrison_units": garrison_units,
	}

func from_dict(data: Dictionary) -> void:
	world_building_id = data.get("world_building_id", -1)
	world_building_custom_name = data.get("world_building_custom_name", "Unnamed")
	world_building_type = data.get("world_building_type", "Settlement")
	var coord = data.get("world_building_coord", [0, 0])
	world_building_coord = Vector2i(coord[0], coord[1])
	world_building_faction = data.get("world_building_faction", "blue")
	resources = data.get("resources", {
		"food": 0,
		"wood": 0,
		"weapons": 0,
		"wealth": 0,
	})
	resource_capacity = data.get("resource_capacity", {
	"food": 500,
	"wood": 500,
	"weapons": 500,
	"wealth": 500,
	})
	production = data.get("production", 0)
	tax_rate = data.get("tax_rate", 0.1)
	contentment = data.get("contentment", 100)
	population = data.get("population",0)
	population_limit = data.get("population_limit",500)
	upgrades = data.get("upgrades", {})
	recruitable_units = data.get("recruitable_units", {})
	garrison_units = data.get("garrison_units", {})
