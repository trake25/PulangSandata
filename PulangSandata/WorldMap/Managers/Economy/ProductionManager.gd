extends Node2D

const food_upper_limit = 0.5
const wood_upper_limit = 0.2
const weapons_upper_limit = 0.15
const wealth_upper_limit = 0.15

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	Initializer.productionmanager_isready = true
	print("ProductionManager is ready")

## Settlement production
func produce_food(contentment: int, population: int) -> int:
	var clamp_contentment = clamp(contentment, 50, 100)
	var food_lower_limit = 0.01 + ((clamp_contentment - 50) * (food_upper_limit - 0.01) / 50)
	var prod_rate = randf_range(food_lower_limit, food_upper_limit)
	var prod_value = int(population * prod_rate)
	
	return prod_value

func produce_wood(contentment: int, population: int) -> int:
	var clamp_contentment = clamp(contentment, 50, 100)
	var wood_lower_limit = 0.01 + ((clamp_contentment - 50) * (wood_upper_limit - 0.01) / 50)
	var prod_rate = randf_range(wood_lower_limit, wood_upper_limit)
	var prod_value = int(population * prod_rate)
	
	return prod_value

func produce_weapons(contentment: int, population: int) -> int:
	var clamp_contentment = clamp(contentment, 50, 100)
	var weapons_lower_limit = 0.01 + ((clamp_contentment - 50) * (weapons_upper_limit - 0.01) / 50)
	var prod_rate = randf_range(weapons_lower_limit, weapons_upper_limit)
	var prod_value = int(population * prod_rate)
	
	return prod_value

func produce_wealth(contentment: int, population: int) -> int:
	var clamp_contentment = clamp(contentment, 50, 100)
	var wealth_lower_limit = 0.01 + ((clamp_contentment - 50) * (wealth_upper_limit - 0.01) / 50)
	var prod_rate = randf_range(wealth_lower_limit, wealth_upper_limit)
	var prod_value = int(population * prod_rate)
	
	return prod_value

func produce_resources(settlement: Settlement_Data) -> void:
	var clamp_contentment = clamp(settlement.contentment, 50, 100)
	for resource in settlement.resources.keys():
		var prod_rate : float = 0
		
		if resource == "food":
			var food_lower_limit = 0.01 + ((clamp_contentment - 50) * (food_upper_limit - 0.01) / 50)
			prod_rate = randf_range(food_lower_limit, food_upper_limit)
		elif resource == "wood":
			var wood_lower_limit = 0.01 + ((clamp_contentment - 50) * (wood_upper_limit - 0.01) / 50)
			prod_rate = randf_range(wood_lower_limit, wood_upper_limit)
		elif resource == "weapons":
			var weapons_lower_limit = 0.01 + ((clamp_contentment - 50) * (weapons_upper_limit - 0.01) / 50)
			prod_rate = randf_range(weapons_lower_limit, weapons_upper_limit)
		elif resource == "wealth":
			var wealth_lower_limit = 0.01 + ((clamp_contentment - 50) * (wealth_upper_limit - 0.01) / 50)
			prod_rate = randf_range(wealth_lower_limit, wealth_upper_limit)
		
		var prod_res_value = int(settlement.population * prod_rate)
		print(settlement.world_building_faction,"'s ",settlement.world_building_type," produced ",resource,": ",prod_res_value)
		settlement.resources[resource] += prod_res_value
		settlement.resources[resource] = min(settlement.resources[resource], settlement.resource_capacity[resource])
		
		
## Settlement consumption
func consume_resources(settlement: Settlement_Data) -> void:
	var clamp_contentment = clamp(settlement.contentment, 50, 100)
	for resource in settlement.resources.keys():
		var consum_rate : float = 0
		
		if resource == "food":
			var food_lower_limit = food_upper_limit - ((clamp_contentment - 50) * (food_upper_limit - 0.01) / 50)
			consum_rate = randf_range(food_lower_limit, food_upper_limit)
		elif resource == "wood":
			var wood_lower_limit = wood_upper_limit - ((clamp_contentment - 50) * (wood_upper_limit - 0.01) / 50)
			consum_rate = randf_range(wood_lower_limit, wood_upper_limit)
		elif resource == "weapons":
			var weapons_lower_limit = weapons_upper_limit - ((clamp_contentment - 50) * (weapons_upper_limit - 0.01) / 50)
			consum_rate = randf_range(weapons_lower_limit, weapons_upper_limit)
		elif resource == "wealth":
			var wealth_lower_limit = wealth_upper_limit - ((clamp_contentment - 50) * (wealth_upper_limit - 0.01) / 50)
			consum_rate = randf_range(wealth_lower_limit, wealth_upper_limit)
		
		var consum_res_value = int(settlement.population * consum_rate)
		print(settlement.world_building_faction,"'s ",settlement.world_building_type," consumed ",resource,": ",consum_res_value)
		settlement.resources[resource] -= consum_res_value
		settlement.resources[resource] = max(settlement.resources[resource], 0)
