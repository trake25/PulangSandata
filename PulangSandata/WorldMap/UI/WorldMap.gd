extends Node2D

@onready var tilemap_terrain : TileMapLayer = %TileMap_Terrain
@onready var tilemap_features : TileMapLayer = %TileMap_Features
@onready var tilemap_buildings : TileMapLayer = %TileMap_Buildings
@onready var tilemap_ownership : TileMapLayer = %TileMap_Ownership
@onready var tilemap_highlight : TileMapLayer = %TileMap_Highlight
@onready var camera_manager : Camera2D = %CameraManager

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Initializer.world_map = self
	Initializer.worldmap_isready = true
	print("World Map ready")

func initialize() -> void:
	TileMapRenderer.tilemap_terrain = tilemap_terrain
	TileMapRenderer.tilemap_features = tilemap_features
	TileMapRenderer.tilemap_buildings = tilemap_buildings
	TileMapRenderer.tilemap_ownership = tilemap_ownership
	TileMapRenderer.tilemap_highlight = tilemap_highlight
	
	InputManager.tile_map = tilemap_terrain
	
	camera_manager.tile_map = tilemap_terrain
	
	print("World Map initialized")
