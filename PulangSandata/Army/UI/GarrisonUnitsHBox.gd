extends HBoxContainer

@onready var unit_card_scene = preload("res://PulangSandata/Army/UI/UnitCard.tscn")

func _can_drop_data(_pos, data):
	return typeof(data) == TYPE_DICTIONARY and data.get("type", "") == "Unit_Data"

func _drop_data(_pos, data):
	if typeof(data) != TYPE_DICTIONARY or data.get("type", "") != "Unit_Data":
		return

	# Remove original UnitCard from the previous container
	if data.has("source_node") and is_instance_valid(data["source_node"]):
		data["source_node"].queue_free()

	# Rebuild Unit_Data and create a new card
	var unit_dict = data["data"]
	var new_unit = Unit_Data.new()
	new_unit.from_dict(unit_dict)

	var new_card = unit_card_scene.instantiate()
	new_card.set_unit(new_unit)
	add_child(new_card)
