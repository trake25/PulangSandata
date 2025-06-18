extends Node
class_name Building_Config

## -------------------------------------
## Description:
## Centralized building registry for structure, validation, and rendering logic.
## Enables scalable integration with construction, ownership, and economy systems.
## -------------------------------------

func _ready() -> void:
	Initializer.buildingconf_isready = true
	print("Building Config ready")
	
# Format: building_type => [valid terrain categories]
var building_registry: Dictionary = {
	"Settlement": ["Flatland", "Elevatedland", "Wetland"],
	#"Camp": ["Flatland", "Elevatedland"],
	#"Outpost": ["Elevatedland", "Dryland"],
	#"TradingPost": ["Wetland", "Flatland"],
	#"Village": ["Flatland"]
	"none": ["Flatland", "Elevatedland", "Dryland", "Wetland", "Water", ""],
}

# Rendering metadata — fully Vector2i-based atlas_id
var building_render_data: Dictionary = {
	"Settlement":        { "source_id": 1, "atlas_id": Vector2i(0, 0) },
	#"Camp":        { "source_id": 1, "atlas_id": Vector2i(0, 0) },
	#"Village":     { "source_id": 1, "atlas_id": Vector2i(1, 0) },
	#"TradingPost": { "source_id": 2, "atlas_id": Vector2i(0, 0) },
	#"Outpost":     { "source_id": 2, "atlas_id": Vector2i(1, 0) }
	"none":        { "source_id": -1, "atlas_id": Vector2i(-1, -1) },
}

## -- Validate if building type is valid for a terrain category --
func is_valid_on_category(building_type: String, category: String) -> bool:
	return building_registry.has(building_type) and category in building_registry[building_type]

## -- Get tile info (source ID and atlas ID) for rendering --
func get_tile_info(building_type: String) -> Dictionary:
	if not building_render_data.has(building_type):
		return {
			"source_id": -1,
			"atlas_id": Vector2i(-1, -1)
		}
	var entry = building_render_data[building_type]
	return {
		"source_id": entry.source_id,
		"atlas_id": entry.atlas_id
	}

## -- List all building types --
func get_all_building_types() -> Array[String]:
	var result: Array[String] = []
	for key in building_registry.keys():
		result.append(key as String)
	return result
