# Systems/Weather/Data/Weather_Data.gd
extends Resource

class_name Weather_Data

var current_type: String = "clear"
var previous_type: String = "clear"

var duration_hours: int = 0      # How long current weather has lasted (in-game hours)
var intensity: int = 0           # Intensity of current weather
var effects: Dictionary = {}     # Cached effects dictionary

func set_weather(new_type: String, config: Dictionary) -> void:
	previous_type = current_type
	current_type = new_type
	duration_hours = 0
	
	var data = config.get(new_type, {})
	intensity = data.get("intensity", 0)
	effects = data.get("effects", {})

func advance_time(hours: int) -> void:
	duration_hours += hours

func get_effects() -> Dictionary:
	return effects

func to_dict() -> Dictionary:
	return {
		"current_type": current_type,
		"previous_type": previous_type,
		"duration_hours": duration_hours,
		"intensity": intensity,
		"effects": effects
	}

func from_dict(data: Dictionary) -> void:
	current_type = data.get("current_type", "clear")
	previous_type = data.get("previous_type", "clear")
	duration_hours = data.get("duration_hours", 0)
	intensity = data.get("intensity", 0)
	effects = data.get("effects", {})
