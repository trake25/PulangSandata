extends Node



 ## Autoloads ##
@onready var is_everyone_initialized : bool = false
@onready var dataio_isready : bool = false
@onready var terrainconf_isready : bool = false
@onready var featureconf_isready : bool = false
@onready var buildingconf_isready : bool = false
@onready var factionconf_isready : bool = false
@onready var mapdata_isready : bool = false
@onready var factionmanager_isready : bool = false
@onready var tilemaprenderer_isready : bool = false
@onready var inputmanager_isready : bool = false
@onready var timecontroller_isready : bool = false
@onready var weathersys_isready : bool = false
@onready var worldbuildingmanager_isready : bool = false
@onready var productionmanager_isready : bool = false
@onready var populationmanager_isready : bool = false
@onready var contentmentmanager_isready : bool = false
@onready var taxmanager_isready : bool = false
@onready var playersettlement_isready : bool = false
@onready var unitmanager_isready : bool = false
@onready var armymanager_isready : bool = false


 ## Main Scene ##
@onready var worldmap_isready : bool = false
@onready var cameramanager_isready : bool = false
@onready var timemanager_isready: bool = false
@onready var sunlightcontroller_isready: bool = false
@onready var timeui_isready: bool = false
@onready var tilecommands_isready : bool = false
@onready var playercommands_isready : bool = false
@onready var playerresouces_isready : bool = false
@onready var armydeployment_isready : bool = false
@onready var armyrenderer_isready : bool = false
@onready var astargrid_isready : bool = false



## References ##
@onready var world_map : Node
@onready var camera_manager : Camera2D
@onready var time_manager : Node
@onready var sunlight_controller : DirectionalLight2D
@onready var time_ui : Control
@onready var tile_commands: Control
@onready var player_commands : Control
@onready var player_resources : Control
@onready var player_settlement : Control
@onready var army_deployment : Control
@onready var army_renderer : Node
@onready var astar_grid : Node


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if not is_everyone_initialized:
		is_everyone_initialized = (
			dataio_isready and terrainconf_isready and 
			featureconf_isready and buildingconf_isready and 
			factionconf_isready and mapdata_isready and 
			factionmanager_isready and tilemaprenderer_isready and
			worldmap_isready and inputmanager_isready and
			cameramanager_isready and timecontroller_isready and
			timemanager_isready and sunlightcontroller_isready and
			timeui_isready and weathersys_isready and
			worldbuildingmanager_isready and playercommands_isready and
			playerresouces_isready and productionmanager_isready and
			populationmanager_isready and taxmanager_isready and 
			contentmentmanager_isready and tilecommands_isready and
			playersettlement_isready and unitmanager_isready and
			armymanager_isready and armydeployment_isready and
			armyrenderer_isready and astargrid_isready
		)
		if is_everyone_initialized:
			MapDataManager.initialize()
			FactionManager.initialize()
			world_map.initialize()
			TileMapRenderer.initialize()
			camera_manager.initialize()
			InputManager.initialize()
			time_manager.initialize()
			TimeController.initialize()
			WeatherSystem.initialize()
			WorldBuildingManager.initialize()
			tile_commands.initialize()
			player_commands.initialize()
			player_resources.initialize()
			UnitManager.initialize()
			player_settlement.initialize()
			ArmyManager.initialize()
			army_deployment.initialize()
			army_renderer.initialize()
			astar_grid.initialize()
			print("Everyone initialized.")
