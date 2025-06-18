extends Camera2D

# === Initialization ===


# === Zoom Settings ===
var zoom_step := 0.05
var zoom_min := 0.4            #far view limit
var zoom_max := 1.8            #near view limit

# === Pan Settings ===
var is_panning := false

# === Edge Panning Settings ===
var edge_scroll_enabled := true
var edge_scroll_margin := 10               # pixels from screen edge to trigger pan
var edge_scroll_speed := 500.0             # world units per second

# === Optional: Map Bounds (set externally by MapDataManager or similar)
#var map_bounds := Rect2(Vector2(-300,-200), Vector2(4500, 3000))
var map_bounds := Rect2(Vector2(-2000,-2000), Vector2(7000, 7000))

# === Tile Map ===
var tile_map : TileMapLayer              #WorldMap.gd references this to tilemap upon load
var camera_settlement_pos : Vector2i = Vector2i.ZERO




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Initializer.camera_manager = self
	Initializer.cameramanager_isready = true
	print("Camera Manager is ready.")

func initialize() -> void:
	zoom = Vector2(0.5, 0.5)
	
	InputManager.camera_manager = self
		
	if tile_map:
		camera_settlement_pos = FactionManager.player_settlement_coords
		camera_settlement_pos = tile_map.map_to_local(camera_settlement_pos)
		global_position = camera_settlement_pos
	else:
		print("tile_map: NULL")
	
	print("Camera Manager initialized")

func _process(delta):
	if edge_scroll_enabled and not InputManager.selection_lock:
		handle_edge_scroll(delta)


func _unhandled_input(event):
	##Zooming
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP and not InputManager.selection_lock:
			adjust_zoom(-zoom_step)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN and not InputManager.selection_lock:
			adjust_zoom(zoom_step)
		elif event.button_index == MOUSE_BUTTON_MIDDLE and not InputManager.selection_lock:
			is_panning = event.pressed
			clamp_position_to_bounds()
	
	##Panning
	elif event is InputEventMouseMotion and is_panning:
		var delta = event.relative
		position -= delta / zoom  # move relative to zoom level
		clamp_position_to_bounds()

func adjust_zoom(amount: float):
	var old_zoom = zoom.x
	var new_zoom = clamp(old_zoom + amount, zoom_min, zoom_max)
	if new_zoom == old_zoom:
		return

	# Get mouse world position before zoom
	var mouse_world_before = get_global_mouse_position()

	# Apply new zoom
	zoom = Vector2(new_zoom, new_zoom)

	# Get mouse world position after zoom
	var mouse_world_after = get_global_mouse_position()

	# Offset camera to keep mouse focus
	position += mouse_world_before - mouse_world_after

	clamp_position_to_bounds()


func handle_edge_scroll(delta):
	var viewport_size = get_viewport().size
	var mouse_pos = get_viewport().get_mouse_position()
	var move_vector = Vector2.ZERO

	if mouse_pos.x <= edge_scroll_margin:
		move_vector.x -= 1
	elif mouse_pos.x >= viewport_size.x - edge_scroll_margin:
		move_vector.x += 1

	if mouse_pos.y <= edge_scroll_margin:
		move_vector.y -= 1
	elif mouse_pos.y >= viewport_size.y - edge_scroll_margin:
		move_vector.y += 1

	if move_vector != Vector2.ZERO:
		move_vector = move_vector.normalized()
		position += move_vector * (edge_scroll_speed * delta / zoom.x)
	
	clamp_position_to_bounds()

func clamp_position_to_bounds():
	var view_size = get_viewport().size

	# Convert Vector2i to Vector2 before division
	var view_size_f = Vector2(view_size) / zoom
	var half_view = view_size_f / 2.0

	var min_x = map_bounds.position.x + half_view.x
	var max_x = map_bounds.position.x + map_bounds.size.x - half_view.x
	var min_y = map_bounds.position.y + half_view.y
	var max_y = map_bounds.position.y + map_bounds.size.y - half_view.y

	position.x = clamp(position.x, min_x, max_x)
	position.y = clamp(position.y, min_y, max_y)


func set_map_bounds(rect: Rect2):
	map_bounds = rect
