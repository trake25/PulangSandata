# Systems/Weather/Weather_System.gd
extends Node

signal weather_changed(new_type: String)

const WEATHER_STATE_PATH := "user://data/weather/weather_data.json"

var weather_data := Weather_Data.new()
var hours_since_last_change: int = 0
var change_interval_hours: int = 24  # Roll weather every 24 in-game hours

@onready var config = preload("res://PulangSandata/Systems/Weather/Data/Weather_Config.gd")

func _ready():
	Initializer.weathersys_isready = true
	print("Weather System ready")

func initialize() -> void:
	randomize()
	_connect_timesystem_weathersystem()
	_load_weather_from_file()
	print("Weather System initialized")
	

func _connect_timesystem_weathersystem() -> void:
	if TimeController.time_manager.has_signal("phase_advanced"):
		TimeController.time_manager.connect("phase_advanced", Callable(self,"on_phase_advanced"))
		print("WeatherSystem connected to TimeSystem.")

func on_phase_advanced():
	# Called every 6 in-game hours by the TimeSystem
	weather_data.advance_time(6)
	hours_since_last_change += 6
	
	if hours_since_last_change >= change_interval_hours:
		hours_since_last_change = 0
		var new_type = config.get_random_weather_type()
		weather_data.set_weather(new_type, config.WEATHER_TYPES)
		emit_signal("weather_changed", new_type)
	
	print("Weather: %s Duration: %d Previous: %s Last change: %d" 
	% [weather_data.current_type, weather_data.duration_hours, weather_data.previous_type, hours_since_last_change])

func get_current_weather() -> Weather_Data:
	return weather_data

func to_dict() -> Dictionary:
	return {
		"current_weather": weather_data.current_type,
		"duration": weather_data.duration_hours,
		"previous_weather": weather_data.previous_type,
		"hours_since_last_change": hours_since_last_change
	}

func from_dict(data: Dictionary) -> void:
	var type = data.get("current_weather", "clear")
	var duration = data.get("duration", 0)
	var previous = data.get("previous_weather", "")
	weather_data.current_type = type
	weather_data.duration_hours = duration
	weather_data.previous_type = previous
	hours_since_last_change = data.get("hours_since_last_change", 0)
	print("Loaded Weather: %s Duration: %d Previous: %s Last change: %d" 
	% [type, duration, previous, hours_since_last_change])
	emit_signal("weather_changed", type)

func _load_weather_from_file():
	if DataIOManager.load_data(WEATHER_STATE_PATH):
		var data = DataIOManager.load_data(WEATHER_STATE_PATH)
		from_dict(data)
	else:
		_set_initial_weather("clear") # fallback

func _save_weather_to_file():
	var data = to_dict()
	DataIOManager.save_data(data, WEATHER_STATE_PATH)

func _set_initial_weather(type: String):
	weather_data.set_weather(type, config.WEATHER_TYPES)
	hours_since_last_change = 0
	emit_signal("weather_changed", type)

func quit_game():
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	get_tree().quit()

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		print("💾 Weather state saved on application quit. current: %s, duration: %d, previous: %s, last changed: %d"
		% [weather_data.current_type, weather_data.duration_hours, weather_data.previous_type, hours_since_last_change])
		_save_weather_to_file()
	
	#if what == NOTIFICATION_PREDELETE:            #Scene change, usable later
	#	save_time_state()


func _on_weather_changed(new_type: String) -> void:
	print("Weather changed: ",new_type)
