extends Node

var states := {}  # Dictionary of state_name -> state_node
var current_state: AnimatedSprite2D = null

func _ready():
	_register_states()

func _register_states():
	for child in get_children():
		if child is State:
			var state_name = child.name
			states[state_name] = child

func set_state(state_name: String):
	if not states.has(state_name):
		push_warning("FSM: Unknown state '" + state_name + "'")
		return
	
	if current_state:
		current_state.exit_state()
	
	current_state = states[state_name]
	current_state.enter_state()

func update(delta: float):
	if current_state:
		current_state.update_state(delta)
