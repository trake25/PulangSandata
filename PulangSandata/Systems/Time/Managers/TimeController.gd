# TimeController.gd
extends Node

# Reference to the TimeManager
var time_manager: Node

func _ready():
	Initializer.timecontroller_isready = true
	time_manager = Initializer.time_manager
	print("Time Controller ready.")

# Initialize time system with default speed
func initialize() -> void:
	time_manager = Initializer.time_manager
	time_manager.time_ui._on_speed_1x_button_pressed()
	print("Time Controller initialized")

# Getter for current time state object
func get_time_state() -> Time_State:
	return time_manager.time_state

# Getter for current phase (e.g., Morning, Afternoon, etc.)
func get_current_phase() -> String:
	return time_manager.time_state.get_phase()

# Getter for current speed multiplier (e.g., 1x, 2x)
func get_time_speed() -> float:
	return time_manager.speed_multiplier

# Check if time is currently running
func is_time_running() -> bool:
	return time_manager.speed_multiplier > 0

# Pause time by setting speed to 0
func pause_time():
	set_time_speed(0)

# Set a new time speed multiplier
func set_time_speed(multiplier: float):
	time_manager.set_speed(multiplier)

# Reset time state to default
func reset_time():
	time_manager.reset_time_state()

# Save time state to disk
func save_time_data():
	time_manager.save_time_state()

# Load time state from disk
func load_time_data():
	time_manager.load_time_state()
