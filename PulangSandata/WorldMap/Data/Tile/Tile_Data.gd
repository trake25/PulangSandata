# File: res://WorldMapMVP/data/Tile_Data.gd
extends Resource

class_name Tile_Data

## -------------------------------------
## Description:
## Stores per-tile map data (terrain, ownership, building, etc.)
## Used by Map_Data_Manager and related systems.
## Standalone script. No scene attached.
## -------------------------------------

var terrain_category: String = "Water"  # Flatland, Wetland, Dryland, Water
var terrain_type: String = "sea"         # Visual variant (e.g., grass, dirt, coast)

var feature: String = "none"           # forest, river, fertile, minerals, etc
var building: String = "none"                  # Placeholder for MVP1 (camp, etc.)
var owner: String = "none"                 # "Red", "Blue", or "none"

## -- Serialization --
func to_dict() -> Dictionary:
	return {
		"terrain_category": terrain_category,
		"terrain_type": terrain_type,
		"feature": feature,
		"building": building,
		"owner": owner,                     #Faction
	}

func from_dict(data: Dictionary) -> void:
	terrain_category = data.get("terrain_category", "Water")
	terrain_type = data.get("terrain_type", "sea")
	feature = data.get("feature", "")
	building = data.get("building", "")
	owner = data.get("owner", "none")

## -- General utility --
func is_valid() -> bool:
	return terrain_category != "" and terrain_type != ""
