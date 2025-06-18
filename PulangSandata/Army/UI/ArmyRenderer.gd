extends Node2D

@onready var army_scene : PackedScene = preload("res://PulangSandata/Army/Army.tscn")
@onready var army_instances: Dictionary = {} # army_id -> ArmyUI instance

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Initializer.army_renderer = self
	Initializer.armyrenderer_isready = true
	print("Army Renderer ready")

func initialize() -> void:
	render_all_armies()
	print("Army Renderer Initialized")

func render_all_armies() -> void:
	var armies = ArmyManager.all_armies
	for army_id in armies:
		render_army(army_id, armies[army_id])

func render_army(army_id: String, army_data: Army_Data) -> void:
	print("Rendering Army.")
	if army_instances.has(army_id):
		# Already spawned, just update position
		update_army_position(army_id, army_data.location)
		print("Army position updated.")
	else:
		# New army
		var army = army_scene.instantiate()
		army.army_data = army_data
		army.name = army_id
		#var army_pos = TileMapRenderer.coordinates(army_data.location)
		#army_pos = Vector2i(army_pos.x, army_pos.y)          # offset to top right
		#army.position = army_pos
		army.position = army.army_data.cur_pos
		add_child(army)
		army_instances[army_id] = army
		print("Army Renderer set army position: ",army.position)

func update_army_position(army_id: String, tile_coords: Vector2i):
	var army_ui = army_instances.get(army_id)
	if army_ui:
		var army_pos = TileMapRenderer.coordinates(tile_coords)
		army_pos = Vector2i(army_pos.x, army_pos.y)
		army_ui.position = army_pos

func remove_army(army_id: String):
	if army_instances.has(army_id):
		army_instances[army_id].queue_free()
		army_instances.erase(army_id)
	
	for child in get_children():
		if child.name == army_id:
			child.queue_free()
