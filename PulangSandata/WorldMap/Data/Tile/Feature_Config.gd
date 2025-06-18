extends Node
class_name Feature_Config

## -------------------------------------
## Description:
## Holds registry and validation for terrain features.
## Structured for logic and rendering support.
## -------------------------------------

func _ready():
	randomize()
	Initializer.featureconf_isready = true
	print("Feature Config ready")

# Logical compatibility (category constraints)
var feature_registry: Dictionary = {
	"Forest": ["Flatland", "Elevatedland"],
#	"Rainforest": ["Flatland"],
#	"River": ["Flatland", "Wetland"],
#	"Lake": ["Wetland"],
#	"Fertile": ["Flatland", "Wetland"],
#	"Minerals": ["Elevatedland"],
#	"Oasis": ["Dryland"],
	"none": ["Flatland", "Elevatedland", "Dryland", "Wetland", "Water", ""],
}

# Rendering metadata — now fully Vector2i-based
var feature_render_data: Dictionary = {
	"Forest":     { "source_id": 1, "atlas_id": Vector2i(0, 0) },
	#"Rainforest": { "source_id": 1, "atlas_id1": Vector2i(0, 0) },
	#"River":      { "source_id": 1, "atlas_id1": Vector2i(0, 0) },
	#"Lake":       { "source_id": 1, "atlas_id1": Vector2i(0, 0) },
	#"Fertile":    { "source_id": 1, "atlas_id1": Vector2i(0, 0) },
	#"Minerals":   { "source_id": 1, "atlas_id1": Vector2i(0, 0) },
	#"Oasis":      { "source_id": 1, "atlas_id1": Vector2i(0, 0) },
	"none": { "source_id": -1, "atlas_id": Vector2i(-1, -1) },
}



## -- Validation --
func is_valid_feature_on_category(feature: String, category: String) -> bool:
	return feature_registry.has(feature) and category in feature_registry[feature]

func get_features_for_category(category: String) -> Array[String]:
	var result: Array[String] = []
	for feature in feature_registry:
		if category in feature_registry[feature]:
			result.append(feature as String)
	return result


func get_all_features() -> Array[String]:
	var result: Array[String] = []
	for key in feature_registry.keys():
		result.append(key as String)
	return result


## -- Rendering Info: Called by TileMap_Renderer --
func get_tile_info(feature_type: String) -> Dictionary:
	if not feature_render_data.has(feature_type):
		return {
			"source_id": -1,
			"atlas_id": Vector2i(-1, -1)
		}

	var entry = feature_render_data[feature_type]
	if entry.has("atlas_id"):
		return {
			"source_id": entry["source_id"],
			"atlas_id": entry["atlas_id"]
		}
	# Last resort fallback
	return {
		"source_id": -1,
		"atlas_id": Vector2i(-1, -1)
	}
