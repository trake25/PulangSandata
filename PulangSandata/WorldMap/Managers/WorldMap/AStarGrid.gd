extends Node2D

const OFFSET :int = 100  # Ensure no coord ever goes below this
const MAX_MAP_WIDTH: int = 2000  # support -1000 to +1000

@onready var astar: AStar2D = AStar2D.new()
@onready var tile_map: TileMapLayer
@onready var astar_tile_datas: Dictionary = {} # coords: {tile_id_int, tile_world_pos}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Initializer.astargrid_isready = true
	Initializer.astar_grid = self
	print("AStar Grid ready")

func initialize() -> void:
	tile_map = Initializer.world_map.tilemap_terrain
	generate_astar_grid()
	print("AStar Grid initialized")

func generate_astar_grid():
	var tile_datas = MapDataManager.tile_map
	for coords in tile_datas:
		register_tile(coords)
	connect_neighbors()

func get_tile_id(coord: Vector2i) -> int:
	return (coord.y + OFFSET) * MAX_MAP_WIDTH + (coord.x + OFFSET)

func get_coord_from_id(id: int) -> Vector2i:
	var x = (id % MAX_MAP_WIDTH) - OFFSET
	@warning_ignore("integer_division")
	var y = int(id / MAX_MAP_WIDTH) - OFFSET
	return Vector2i(x, y)

func register_tile(coord: Vector2i) -> void:
	if astar_tile_datas.has(coord):
		return

	var tile_id_int = get_tile_id(coord)
	var tile_world_pos = tile_map.map_to_local(coord)

	astar_tile_datas[coord] = {
		"tile_id_int": tile_id_int,
		"tile_world_pos": tile_world_pos,
		}
	if not astar.has_point(tile_id_int):
		astar.add_point(tile_id_int, tile_world_pos)

func is_tile_walkable(coord: Vector2i, unit_type: String) -> bool:
	var tile_data = MapDataManager.get_tile(coord)
	if tile_data == null:
		return false

	if unit_type == "Land_Unit":
		return tile_data.terrain_category != "Water"
	elif unit_type == "Sea_Unit":
		return tile_data.terrain_category == "Water"
	else:
		return true

func connect_neighbors():
	for coord in astar_tile_datas:
		var tile_id = astar_tile_datas[coord]["tile_id_int"]
		var neighbors = tile_map.get_surrounding_cells(coord)

		for neighbor in neighbors:
			# Check if neighbor is registered and walkable
			if not astar_tile_datas.has(neighbor):
				continue
			if not is_tile_walkable(neighbor, "Land_Unit"):  # Or dynamic type
				continue

			var neighbor_id = astar_tile_datas[neighbor]["tile_id_int"]

			# Avoid double connections, let AStar handle bidirectional
			if not astar.are_points_connected(tile_id, neighbor_id):
				var _dist = astar_tile_datas[coord]["tile_world_pos"].distance_to(
					astar_tile_datas[neighbor]["tile_world_pos"]
				)
				astar.connect_points(tile_id, neighbor_id, true)

func find_path(start_coord: Vector2i, end_coord: Vector2i) -> Array:
	if not astar_tile_datas.has(start_coord) or not astar_tile_datas.has(end_coord):
		return []  # Invalid tiles

	var start_id = get_tile_id(start_coord)
	var end_id = get_tile_id(end_coord)

	if not astar.has_point(start_id) or not astar.has_point(end_id):
		return []  # Points not in AStar graph
	
	return astar.get_point_path(start_id, end_id)
	
