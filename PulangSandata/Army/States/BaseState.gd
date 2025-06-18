extends AnimatedSprite2D
class_name State

@onready var army = get_parent().get_parent()
@onready var tile_map = InputManager.tile_map



func _ready() -> void:
	visible = false
	stop()
	
func enter_state():
	play(name)
	visible = true

func exit_state():
	visible = false
	stop()
	

func update_state(_delta: float):
	pass
