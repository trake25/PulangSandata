extends Node
class_name Terrain_Config

## -------------------------------------
## Description:
## Holds a centralized terrain registry for terrain validation and structure.
## Required for scalable logic across terrain, movement, buildings, etc.
## Also includes rendering metadata: source_id and atlas_id (Vector2i)
## -------------------------------------

func _ready() -> void:
	Initializer.terrainconf_isready = true
	print("Terrain Config ready")

# Logical registry
var terrain_registry: Dictionary = {
	"Flatland": ["grass", "dirt"],
	"Wetland": ["coast", "marsh"],
	"Dryland": ["desert"],
	"Elevatedland": ["hill", "mountain"],
	"Water": ["sea", "ocean"]
}

# Rendering metadata (must match terrain_registry entries)
var terrain_render_data: Dictionary = {
	"Flatland": {
		"source_id": 1,
		"types": {
			"grass": Vector2i(0, 0),
			"dirt": Vector2i(1, 0)
		}
	},
	"Wetland": {
		"source_id": 2,
		"types": {
			"coast": Vector2i(0, 0),
			"marsh": Vector2i(1, 0)
		}
	},
	"Dryland": {
		"source_id": 3,
		"types": {
			"desert": Vector2i(0, 0)
		}
	},
	"Elevatedland": {
		"source_id": 4,
		"types": {
			"hill": Vector2i(0, 0),
			"mountain": Vector2i(1, 0)
		}
	},
	"Water": {
		"source_id": 5,
		"types": {
			"sea": Vector2i(0, 0),
			"ocean": Vector2i(1, 0)
		}
	}
}

## -- Validation --
func is_valid_combination(category: String, terrain: String) -> bool:
	return terrain_registry.has(category) and terrain in terrain_registry[category]

func get_all_terrain_types() -> Array[String]:
	var all_types: Array[String] = []
	for type_list in terrain_registry.values():
		for terrain in type_list:
			all_types.append(terrain as String)
	return all_types



func get_category_for_terrain(terrain: String) -> String:
	for category in terrain_registry:
		if terrain in terrain_registry[category]:
			return category
	return ""

## -- Rendering Info: Called by TileMap_Renderer --
func get_tile_info(category: String, terrain: String) -> Dictionary:
	if not terrain_render_data.has(category):
		return {
			"source_id": -1,
			"atlas_id": Vector2i(-1, -1)
		}
	var atlas_id: Vector2i = terrain_render_data[category].types.get(terrain, Vector2i(-1, -1))
	return {
		"source_id": terrain_render_data[category].source_id,
		"atlas_id": atlas_id
	}
