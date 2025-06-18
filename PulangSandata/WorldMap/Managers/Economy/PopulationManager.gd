extends Node2D

@onready var healthy_storage_threshold : float = 0.2  #Above 20% of storage filled means population can grow
@onready var variability = randf_range(0.9, 1.1)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Initializer.populationmanager_isready = true
	print("Population Manager ready")

func initialize() -> void:
	print("Population Manager initialzed")

func update_populations(settlement: Settlement_Data) -> void:
	var current_food = float(settlement.resources["food"])
	var food_capacity = float(settlement.resource_capacity["food"])
	var storage_fill_ratio = current_food / food_capacity
	
	if settlement.contentment > 50 and storage_fill_ratio > healthy_storage_threshold:
		var contentment_factor = clamp((settlement.contentment - 50) / 50.0 * 0.05, 0.0, 0.05) # max 0.05
		var storage_fill_factor = clamp((storage_fill_ratio - healthy_storage_threshold) / 0.8 * 0.05, 0.0, 0.05)  # max 0.05
		var growth_rate = (contentment_factor + storage_fill_factor) * variability                # max 0.1 * variability
		var growth = int(settlement.population * growth_rate)
		settlement.population += growth
		settlement.population = min(settlement.population, settlement.population_limit)
		print(settlement.world_building_faction,"'s settlement population is growing by ",growth)
		
		ContentmentManager.increase_contentment(settlement)
		
	elif settlement.contentment < 50 or storage_fill_ratio <= healthy_storage_threshold:
		var contentment_factor = clamp((50 - settlement.contentment) / 50.0 * 0.1, 0.0, 0.1) # max 0.1
		var storage_fill_factor = clamp((healthy_storage_threshold - storage_fill_ratio) / healthy_storage_threshold * 0.1, 0.0, 0.1)  # max 0.1
		var decay_rate = (contentment_factor + storage_fill_factor) * variability                    # max 0.2 * variability
		var decay = int(settlement.population * decay_rate)
		settlement.population -= decay
		settlement.population = max(settlement.population, 0)
		print(settlement.world_building_faction,"'s settlement population is declining by ",decay)
		
		ContentmentManager.decrease_contentment(settlement)
