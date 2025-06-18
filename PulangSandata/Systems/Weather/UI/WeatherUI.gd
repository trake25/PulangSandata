extends Control

var current_weather := ""
var duration := 0

@onready var weather_label = %WeatherLabel
@onready var weather_icon = %WeatherIcon

func update_weather_display(weather_type: String, duration_hours: int, last_weather: String):
	current_weather = weather_type
	duration = duration_hours
	weather_label.text = "Weather: %s\nDuration: %d hrs\nPrev: %s" % [weather_type.capitalize(), duration_hours, last_weather.capitalize()]
	# Placeholder: switch texture based on weather_type
	match weather_type:
		"clear":
			#weather_icon.texture = preload("res://assets/weather/clear_icon.png")  # Placeholder
			pass
		"storm":
			#weather_icon.texture = preload("res://assets/weather/storm_icon.png")  # Placeholder
			pass
		"rain":
			#weather_icon.texture = preload("res://assets/weather/rain_icon.png")   # Placeholder
			pass
		_:
			weather_icon.texture = null
