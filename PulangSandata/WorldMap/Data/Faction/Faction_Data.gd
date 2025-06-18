# res://WorldMap/Data/Faction/Faction_Data.gd
extends Resource
class_name Faction_Data

## Data container for a single faction.

var faction_id: String = "-1"
var faction_name: String = ""
var color: String = "red"                 # e.g., "#ff0000"
var is_player: bool = false
var home_settlement_id: int = -1

var atlas_id: Vector2i = Vector2i.ZERO      # Visual variation
var source_id: int = 0                      # TileMap source layer

# Expandable
var resources: Dictionary = {
	"food": 0,
	"wealth": 0,
	"weapons": 0,
	"wood": 0,
}
#var ai_behavior: Dictionary = {}

# Armies
var army_ids: Array[int] = []

# --- Serialization ---
func to_dict() -> Dictionary:
	return {
		"faction_id": faction_id,
		"faction_name": faction_name,
		"color": color,
		"is_player": is_player,
		"home_settlement_id": home_settlement_id,
		"atlas_id": [atlas_id.x, atlas_id.y],
		"source_id": source_id,
		"resources": resources,
	}

func from_dict(data: Dictionary) -> void:
	faction_id = data.get("faction_id", -1)
	faction_name = data.get("faction_name", "")
	color = data.get("color", "white")
	is_player = data.get("is_player", false)
	home_settlement_id = data.get("home_settlement_id", -1)
	var id = data.get("atlas_id", [0, 0])
	atlas_id = Vector2i(id[0], id[1])
	source_id = data.get("source_id", 0)
	resources = data.get("resources", {}).duplicate()
