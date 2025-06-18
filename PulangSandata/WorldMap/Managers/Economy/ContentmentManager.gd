extends Node2D

@onready var storage_fill_threshold: float = 0.2

func _ready() -> void:
	Initializer.contentmentmanager_isready = true
	print("Contentment Manager ready")

func intialize() -> void:
	print("Contentment Manager initialized")

func increase_contentment(settlement: Settlement_Data) -> void:
	var faction = settlement.world_building_faction
	settlement.contentment += 1
	settlement.contentment = clamp (settlement.contentment,0,100)
	print(faction,"'s settlement contentment increased to: ",settlement.contentment)

func decrease_contentment(settlement: Settlement_Data) -> void:
	var faction = settlement.world_building_faction
	settlement.contentment -= 1
	settlement.contentment = clamp (settlement.contentment,0,100)
	print(faction,"'s settlement contentment decreased to: ",settlement.contentment)

func tax_contentment(settlement: Settlement_Data) -> void:
	var faction = settlement.world_building_faction
	var tax_penalty : int = int(settlement.tax_rate * 10)
	settlement.contentment -= tax_penalty
	settlement.contentment = clamp (settlement.contentment,0,100)
	print(faction," tax collection decreased contentment to: ",settlement.contentment)

func resources_contentment(settlement: Settlement_Data) -> void:
	var storage_above_threshold: bool = true
	var faction = settlement.world_building_faction
	
	var depleted = false

	for resource in settlement.resources.keys():
		if settlement.resources[resource] <= 0:
			settlement.contentment -= 1
			depleted = true
			print(faction, "'s settlement ", resource, " depleted, contentment decreased to: ", settlement.contentment)

	if not depleted:
		settlement.contentment += 1
		print(faction, "'s settlement consumed resources, contentment increased to: ", settlement.contentment)

	settlement.contentment = clamp(settlement.contentment, 0, 100)
	
	for resource in settlement.resources.keys():
		var float_resource = float(settlement.resources[resource])
		var float_resource_capacity = float(settlement.resource_capacity[resource])
		var storage_fill_ratio: float = 0.0
		storage_fill_ratio = float(float_resource / float_resource_capacity)
		if storage_fill_ratio >= storage_fill_threshold:
			storage_above_threshold = true
		else:
			storage_above_threshold = false
			break
	
	if storage_above_threshold:
		settlement.contentment += 1
		settlement.contentment = clamp(settlement.contentment,0,100)
		print(faction,"'s settlement resources fill is above 20% of capicity, contentment increased to: ",settlement.contentment)
	else:
		settlement.contentment -= 1
		settlement.contentment = clamp(settlement.contentment,0,100)
		print(faction,"'s settlement resources fill is equal or below 20% of capicity, contentment decreased to: ",settlement.contentment)
