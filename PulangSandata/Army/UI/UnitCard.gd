extends Control

@onready var mode: String = "garrison" # or "army"
@onready var unit_name_label : Label
@onready var unit_type_label : Label
@onready var unit_stats_label : Label

var unit_data: Unit_Data  # The unit this card represents

func set_unit(garrison_unit_data: Unit_Data) -> void:
	unit_data = garrison_unit_data
	unit_name_label = %UnitNameLabel
	unit_type_label = %UnitTypeLabel
	unit_stats_label = %UnitStatsLabel
	
	unit_name_label.text = " " + unit_data.unit_name
	unit_type_label.text = " " + unit_data.unit_type
	unit_stats_label.text = " Health: " + str(int(unit_data.battle_stats["health"])) + "/" + str(int(unit_data.battle_stats["max_health"]))
	unit_stats_label.text += "\n Morale: " + str(int(unit_data.battle_stats["morale"])) + "/100"
	

func _get_drag_data(_at_position: Vector2) -> Variant:
	print("Drag started: ", unit_data.unit_name)

	var preview = duplicate()  # This will be the ghost image while dragging
	preview.modulate = Color(1, 1, 1, 0.8)  # Optional: make it semi-transparent
	var card_size = preview.size

	# Create a wrapper Control to offset the drag preview
	var wrapper = Control.new()
	wrapper.size = card_size
	wrapper.add_child(preview)
	
	# Move the card inside the wrapper to center (or adjust as needed)
	preview.position = -card_size / 2  # Centered under mouse
	#preview.position = -card_size     # Bottom-right under mouse

	set_drag_preview(wrapper)
	#wrapper.tree_exited.connect(func(): print("Preview wrapper freed"))
	return {
		"type": "Unit_Data",
		"data": unit_data.to_dict(),
		"source_node": self
		}
