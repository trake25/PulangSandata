extends Node

# 🔧 Make this static
static var WEATHER_TYPES = {
	"clear": {
		"display_name": "Clear Skies",
		"weight": 50,
		"intensity": 0,
		"effects": {
			"visibility_modifier": 1.0,
			"movement_modifier": 1.0
		}
	},
	"rain": {
		"display_name": "Rain",
		"weight": 25,
		"intensity": 1,
		"effects": {
			"visibility_modifier": 0.8,
			"movement_modifier": 0.9
		}
	},
	"storm": {
		"display_name": "Storm",
		"weight": 10,
		"intensity": 2,
		"effects": {
			"visibility_modifier": 0.5,
			"movement_modifier": 0.7
		}
	},
	"snow": {
		"display_name": "Snow",
		"weight": 10,
		"intensity": 1,
		"effects": {
			"visibility_modifier": 0.7,
			"movement_modifier": 0.85
		}
	},
	"fog": {
		"display_name": "Fog",
		"weight": 5,
		"intensity": 1,
		"effects": {
			"visibility_modifier": 0.6,
			"movement_modifier": 1.0
		}
	}
}

# 🔧 Static function accessing static variable
static func get_random_weather_type() -> String:
	var pool = []
	for weather_type in WEATHER_TYPES.keys():
		var weight = WEATHER_TYPES[weather_type]["weight"]
		for i in range(weight):
			pool.append(weather_type)
	return pool[randi() % pool.size()]
