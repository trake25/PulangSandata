# File: res://WorldMapMVP/Managers/TileMapRenderer.gd
extends Node2D

@onready var tilemap_terrain: TileMapLayer
@onready var tilemap_features: TileMapLayer
@onready var tilemap_buildings: TileMapLayer
@onready var tilemap_ownership: TileMapLayer
@onready var tilemap_highlight: TileMapLayer

@onready var map_data_manager: Node
@onready var building_config: Building_Config
@onready var terrain_config : Terrain_Config
@onready var feature_config : Feature_Config
@onready var faction_manager : Node

func _ready():
	Initializer.tilemaprenderer_isready = true
	print("Tile Map Renderer is ready")

func initialize() -> void:
	
	terrain_config = TerrainConfig
	building_config = BuildingConfig
	feature_config = FeatureConfig
	map_data_manager = MapDataManager
	faction_manager = FactionManager
	
	clear_all_layers()
	_render_entire_map()
	print("Tile Map Renderer initialized")

func coordinates(raw_coords: Vector2i) -> Vector2i:
	return tilemap_terrain.map_to_local(raw_coords)

func _render_entire_map() -> void:
	for coord in map_data_manager.tile_map.keys():
		var tile_data = map_data_manager.get_tile(coord)
		_render_tile(coord, tile_data)

func _render_tile(coord: Vector2i, tile_data) -> void:
	# Terrain Layer
	var terrain_info := terrain_config.get_tile_info(tile_data.terrain_category, tile_data.terrain_type)
	if terrain_info:
		tilemap_terrain.set_cell(coord, terrain_info.source_id, terrain_info.atlas_id)
		

	# Feature Layer
	var feature_info := feature_config.get_tile_info(tile_data.feature)
	if feature_info:
		tilemap_features.set_cell(coord, feature_info.source_id, feature_info.atlas_id)

	# Building Layer (placeholder logic for future Building_Config)
	var building_info := building_config.get_tile_info(tile_data.building)
	if building_info:
		tilemap_buildings.set_cell(coord, building_info.source_id, building_info.atlas_id)

	# Ownership Layer
	var owner_atlas_id = faction_manager.get_atlas_id(tile_data.owner)
	var ownership_source_id = faction_manager.get_source_id(tile_data.owner)
	if ownership_source_id >= 0:
		tilemap_ownership.set_cell(coord, ownership_source_id, owner_atlas_id)
	else:
		tilemap_ownership.erase_cell(coord)

	# Highlight Layer - empty for now
	# tilemap_highlight.set_cell(coord, ...)

# --- Utility API ---
func update_tile(coord: Vector2i) -> void:
	var tile_data = map_data_manager.get_tile(coord)
	if tile_data:
		_render_tile(coord, tile_data)

func clear_all_layers() -> void:
	tilemap_terrain.clear()
	tilemap_features.clear()
	tilemap_buildings.clear()
	tilemap_ownership.clear()
	tilemap_highlight.clear()
