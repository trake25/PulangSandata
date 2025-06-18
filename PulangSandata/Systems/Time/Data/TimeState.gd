# TimeState.gd
extends Resource

class_name Time_State

# Time Components
var minute: int = 0            # 0 - 59
var hour: int = 0            # 0 - 23
var day: int = 1             # 1+
var season: int = 0          # 0 = Spring, 1 = Summer, etc. (placeholder)
var year: int = 1

# Phase calculation (auto-generated)
func get_phase() -> String:
	var h = hour % 24
	if h >= 6 and h < 12:
		return "Morning"
	elif h >= 12 and h < 18:
		return "Afternoon"
	elif h >= 18 and h < 24:
		return "Evening"
	else:
		return "Midnight"

func to_dict() -> Dictionary:
	return {
		"minute": minute,
		"hour": hour,
		"day": day,
		"season": season,
		"year": year,
	}

func from_dict(data: Dictionary) -> void:
	minute = data.get("minute", 0)
	hour = data.get("hour", 0)
	day = data.get("day", 1)
	season = data.get("season", 0)
	year = data.get("year", 1)
