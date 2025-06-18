extends Control

@onready var date_label = %DateLabel
@onready var time_label = %TimeLabel

func _ready():
	Initializer.time_ui = self
	Initializer.timeui_isready = true
	print("TimeUI is ready.")

func update_ui(time_state: Time_State):
	# Example: "Day: 3"
	date_label.text = "Year: %d Day: %d" % [time_state.year, time_state.day]
	# Example: "12:00 - Day"
	time_label.text = "%02dhr:%02dmin\n%s" % [time_state.hour, time_state.minute, time_state.get_phase()]

func unpressed_all_buttons() -> void:
	%PauseButton.button_pressed = false
	%Speed1xButton.button_pressed = false
	%Speed2xButton.button_pressed = false
	%Speed4xButton.button_pressed = false
	%Speed12xButton.button_pressed = false

func _on_pause_button_pressed() -> void:
	print("Paused.")
	unpressed_all_buttons()
	%PauseButton.button_pressed = true
	TimeController.set_time_speed(0)


func _on_speed_1x_button_pressed() -> void:
	print("Speed 1X.")
	unpressed_all_buttons()
	%Speed1xButton.button_pressed = true
	TimeController.set_time_speed(1)

func _on_speed_2x_button_pressed() -> void:
	print("Speed 2X.")
	unpressed_all_buttons()
	%Speed2xButton.button_pressed = true
	TimeController.set_time_speed(2)

func _on_speed_4x_button_pressed() -> void:
	print("Speed 4X.")
	unpressed_all_buttons()
	%Speed4xButton.button_pressed = true
	TimeController.set_time_speed(4)

func _on_speed_12x_button_pressed() -> void:
	print("Speed 12X.")
	unpressed_all_buttons()
	%Speed12xButton.button_pressed = true
	TimeController.set_time_speed(12)


func _on_reset_time_button_pressed() -> void:
	print("Request for Time reset.")
	TimeController.reset_time()
	_on_speed_1x_button_pressed()
