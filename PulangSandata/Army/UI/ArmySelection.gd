extends Control

@onready var army_container : VBoxContainer = %ArmyContainer
@onready var army_buttons : Array = []
@onready var command_label : Label = %Command

func _ready() -> void:
	Initializer.army_selection = self
	Initializer.armyselection_isready = true
	print("Army Selection ready")

func initialize() -> void:
	command_label.text = "None"
	print("Army Selection initialized")

func populate_army_select() -> void:
	var all_armies = ArmyManager.all_armies
	if all_armies.size() > 0:
		for army_key in all_armies.keys():
			var new_button = Button.new()
			new_button.name = army_key
			new_button.text = "Name: " + all_armies[army_key].army_name
			new_button.text += "\nStatus: " + all_armies[army_key].world_status
			new_button.text += "\nCommand: " + all_armies[army_key].world_command
			new_button.text += "\nLocation: " + str(all_armies[army_key].location)
			new_button.toggle_mode = true
			new_button.pressed.connect(_on_army_button_pressed.bind(new_button))  # <- Connect with bind
			army_container.add_child(new_button)
			army_buttons.append(new_button)  # Optional: track buttons if needed

func _on_army_button_pressed(selected_button: Button) -> void:
	for button in army_container.get_children():
		if button != selected_button:
			button.button_pressed = false


func clear_army_select() -> void:
	for child in army_container.get_children():
		child.queue_free()

func _on_cancel_pressed() -> void:
	InputManager.selection_lock = false
	visible = false
	clear_army_select()

func _on_confirm_pressed() -> void:
	for child in army_container.get_children():
		if child.button_pressed:
			ArmyManager.all_armies[child.name].world_command = command_label.text
			ArmyManager.execute_command(child.name)
	InputManager.selection_lock = false
	visible = false
	command_label.text = "None"
	clear_army_select()
	
