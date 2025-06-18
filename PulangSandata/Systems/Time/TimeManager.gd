# Systems/Time/TimeManager.gd
extends Node2D

# Signals
signal phase_advanced
signal time_speed_changed(new_speed: float)


# Constants
const SECONDS_PER_REAL_PHASE := 60.0           # Real seconds per in-game 6-hour phase at normal speed
const HOURS_PER_DAY := 24
const PHASE_HOURS := 6
const TIME_STATE_PATH := "user://data/time/time_state.json"

# Time data
var time_state: Time_State = Time_State.new()
var time_accumulator := 0.0
var speed_multiplier := 1.0

# Optional: references
@export var sunlight_node_path: NodePath
@export var timeui_node_path: NodePath
@onready var sunlight_controller: Node2D
@onready var time_ui: Control

func _ready():
	Initializer.time_manager = self
	Initializer.timemanager_isready = true
	print("Time Manager ready")

# Called by TimeController after scene is ready
func initialize():
	sunlight_controller = Initializer.sunlight_controller
	time_ui = Initializer.time_ui
	time_ui.update_ui(time_state)
	load_time_state()
	print("Time Manager initialized")

func _process(delta: float) -> void:
	if speed_multiplier <= 0:
		return

	var scaled_delta = delta * speed_multiplier
	time_accumulator += scaled_delta

	var seconds_per_minute = SECONDS_PER_REAL_PHASE / (PHASE_HOURS * 60.0)

	while time_accumulator >= seconds_per_minute:
		time_accumulator -= seconds_per_minute
		_increment_minute()

# Advance in-game minute
func _increment_minute():
	time_state.minute += 1
	if time_state.minute >= 60:
		time_state.minute = 0
		_increment_hour()

	# Optionally trigger per-minute events here

	if time_ui:
		time_ui.update_ui(time_state)

# Advance in-game hour
func _increment_hour():
	time_state.hour += 1

	if time_state.hour >= HOURS_PER_DAY:
		time_state.hour = 0
		_increment_day()

	# Trigger weather/phase change and events
	_weather_phase_advanced()
	_trigger_time_events()

	# Notify Sunlight Controller
	if sunlight_controller:
		sunlight_controller.update_sunlight(time_state)

	if time_ui:
		time_ui.update_ui(time_state)

# Advance in-game day
func _increment_day():
	time_state.day += 1
	if time_state.day > 90:  # Placeholder: 90 days per season
		time_state.day = 1
		time_state.season += 1

		if time_state.season > 3:
			time_state.season = 0
			time_state.year += 1

# Check and emit phase signal if needed
func _weather_phase_advanced() -> void:
	if time_state.hour % PHASE_HOURS == 0:
		# print("🕓 Phase advanced: Hour %d" % time_state.hour)
		emit_signal("phase_advanced")

# Handle specific hour events
func _trigger_time_events():
	if time_state.minute != 0:
		return

	match time_state.hour:
		6:
			print("☀️ Morning begins: Day %d, Year %d" % [time_state.day, time_state.year])
			_resources_consume()
			_population_update()
			Initializer.player_settlement.update_settlement_info_current()

		12:
			print("☀️ Afternoon begins: Day %d, Year %d" % [time_state.day, time_state.year])
			_tax_collection()
			Initializer.player_settlement.update_settlement_info_current()

		18:
			print("🌙 Evening begins: Day %d, Year %d" % [time_state.day, time_state.year])
			_resources_production()
			Initializer.player_settlement.update_garrison_wage()
			Initializer.player_settlement.update_trend()
			Initializer.player_settlement.update_settlement_info_current()

		0:
			print("🌙 Midnight begins: Day %d, Year %d" % [time_state.day, time_state.year])

	# Always update recruit progress
	Initializer.player_settlement.update_recruit_progress()

# Morning: consume resources
func _resources_consume() -> void:
	WorldBuildingManager.update_consumption()
	WorldBuildingManager.save_world_buildings()

# Evening: produce resources
func _resources_production() -> void:
	WorldBuildingManager.update_production()
	WorldBuildingManager.save_world_buildings()

# Morning: update population
func _population_update() -> void:
	WorldBuildingManager.update_population()
	WorldBuildingManager.save_world_buildings()

# Noon: collect taxes
func _tax_collection() -> void:
	WorldBuildingManager.collect_taxes()
	FactionManager.update_player_resources()
	FactionManager.save_factions()

# External API
func set_speed(multiplier: float):
	if multiplier != speed_multiplier:
		speed_multiplier = clamp(multiplier, 0.0, 100.0)
		emit_signal("time_speed_changed", speed_multiplier)


func reset_time_state():
	time_state = Time_State.new()
	time_accumulator = 0.0
	if sunlight_controller:
		sunlight_controller.update_sunlight(time_state)
	if time_ui:
		time_ui.update_ui(time_state)

	print("🕒 Time state has been reset.")
	save_time_state()

# Save and Load Time State
func save_time_state() -> void:
	var data: Dictionary = time_state.to_dict()
	DataIOManager.save_data(data, TIME_STATE_PATH)

func load_time_state() -> void:
	var data: Dictionary = DataIOManager.load_data(TIME_STATE_PATH)
	if data.size() == 0:
		print("⚠️ No saved time state found. Using default time state.")
		return

	time_state.from_dict(data)
	time_accumulator = 0.0

	if sunlight_controller:
		sunlight_controller.update_sunlight(time_state)
	if time_ui:
		time_ui.update_ui(time_state)

	print("✅ Time state loaded: Day %d, %02d:%02d, Season %d, Year %d"
		% [time_state.day, time_state.hour, time_state.minute, time_state.season, time_state.year])

# Save on quit
func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		print("💾 Time state saved on application quit: Day %d, %02d:%02d, Season %d, Year %d"
		% [time_state.day, time_state.hour, time_state.minute, time_state.season, time_state.year])
		save_time_state()

	# if what == NOTIFICATION_PREDELETE:            #Scene change, usable later
	#	save_time_state()
