extends Node2D

@onready var army_data : Army_Data
@onready var army_name_label : Label = %ArmyNameLabel
@onready var fsm : Node2D = %FSM

@onready var army_status : String
@onready var tile_map : TileMapLayer = InputManager.tile_map


func _ready() -> void:
	if army_data:
		army_name_label.text = army_data.army_name
		army_status = army_data.world_status
	
	fsm.set_state(army_status)
	
	Initializer.time_manager.connect("time_speed_changed", Callable(self, "_on_time_speed_changed"))

func _process(delta):
	fsm.update(delta)

func change_state(new_state: String):
	army_data.world_status = new_state
	fsm.set_state(new_state)
	print("Army State change: ",new_state)

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		army_data.cur_pos = position
		army_data.location = tile_map.local_to_map(position)
		ArmyManager.save_all_armies()

func quit_game():
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	get_tree().quit()

func _on_time_speed_changed(new_speed: float) -> void:
	if fsm.current_state and fsm.current_state.has_method("on_time_speed_changed"):
		fsm.current_state.on_time_speed_changed(new_speed)
