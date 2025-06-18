## res://.../Army/Managers/UnitManager.gd

extends Node2D


const PATH := "user://data/army/units_data.json"
@onready var all_units : Dictionary = {}
@onready var next_unit_id: int = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Initializer.unitmanager_isready = true
	print("Unit Manager ready")

func initialize() -> void:
	load_all_units()
	print("Unit Manager initialized")

func save_all_units() -> void:
	var data : Dictionary = {}
	for key in all_units.keys():
		data[key] = all_units[key].to_dict()
	DataIOManager.save_data(data, PATH)

func load_all_units() -> void:
	var loaded_units = DataIOManager.load_data(PATH)

	if loaded_units.is_empty():
		print("Loaded Units data is empty.")
		return
	
	var highest_id = 0
	all_units.clear()
	
	for key in loaded_units.keys():
		var unit : Unit_Data = Unit_Data.new()
		unit.from_dict(loaded_units[key])
		all_units[key] = unit
		
		if int(unit.unit_id) > highest_id:
			highest_id = int(unit.unit_id)
	
	next_unit_id = highest_id + 1
	print("All Units are loaded.")
	print("Next unit id: ",next_unit_id)

func remove_zero_health_unit() -> void:
	for unit in all_units.keys():
		var unit_data = all_units[unit]
		if unit_data.battle_stats["health"] <= 0:
			print(unit_data.unit_name,unit_data.unit_id," health is 0. Unit died.")
			all_units.erase(unit)


func recruit_unit(unit_type: String) -> Unit_Data:
	var unit: Unit_Data
	
	match unit_type:
		"Laborers":
			unit = Slaves_Data.new()
		"Town Watch":
			unit = Militia_Data.new()
		_:
			unit = Militia_Data.new()
	
	unit.unit_id = str(next_unit_id)
	next_unit_id += 1

	all_units[unit.unit_id] = unit
	save_all_units()
	return unit

func quit_game():
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	get_tree().quit()

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		print("💾 All Units Data saved on application quit.")
		save_all_units()
