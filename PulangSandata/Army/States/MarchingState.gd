extends State

const base_speed = 20.2 #base_speed = distance / time_speed * duration | duration = 10 secs to reach 1 tile / 1 in-game hour

var path: Array = []
var tween: Tween = null


func enter_state():
	play(name)
	visible = true

	path = army.army_data.path
	
	# Start marching if path exists
	if path.is_empty():
		_finish_march()
	else:
		_move_to_next_tile()

func exit_state():
	visible = false
	stop()

	# Cancel any active tween when exiting state
	if tween:
		tween.kill()
		tween = null

func update_state(_delta: float):
	pass  # No per-frame logic needed while tweening

func _move_to_next_tile():
	if path.is_empty():
		_finish_march()
		return

	var target = path[0] 
	var distance = army.position.distance_to(target)
	
	
	var time_speed = TimeController.get_time_speed()
	var duration = distance / (base_speed * time_speed)

	tween = create_tween()
	tween.tween_property(army, "position", target, duration)
	tween.tween_callback(Callable(self, "_on_tile_reached"))


func _on_tile_reached():
	var target_reached = path[0]
	path.remove_at(0)

	army.army_data.location = tile_map.local_to_map(target_reached)
	army.army_data.cur_pos = target_reached
	army.army_data.path = path
	print("Reached: ", target_reached, " Remaining path: ", path)

	_move_to_next_tile()

func _finish_march():
	
	army.army_data.location = tile_map.local_to_map(army.army_data.cur_pos)
	print(army.army_data.location)
	army.army_data.path.clear()
	army.change_state("Idle")

func on_time_speed_changed(new_speed: float):
	if tween:
		tween.kill()
		tween = null
		
	if new_speed <= 0.0:
		return
	
	# recreate tween from current position to next tile
	if path.is_empty():
		return
	
	var target = path[0]
	var distance = army.position.distance_to(target)
	var duration = distance / (base_speed * new_speed)

	tween = create_tween()
	tween.tween_property(army, "position", target, duration)
	tween.tween_callback(Callable(self, "_on_tile_reached"))
