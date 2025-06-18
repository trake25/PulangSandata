extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Initializer.taxmanager_isready = true
	print("Tax Manager ready")

func initialize() -> void:
	print("Tax Manager initialized")

func calculate_taxes(settlement: Settlement_Data) -> void:
	var tax_rate : float = settlement.tax_rate if settlement.tax_rate > 0 else 0.1
	
	var tax_allowed : bool = true
	if settlement.contentment < 51:
		tax_allowed = false
	
	if not tax_allowed:
		return
	
	var taxed_resources : Dictionary = {}
	for resource in settlement.resources.keys():
		var amount = int(settlement.resources[resource] * tax_rate)
		taxed_resources[resource] = amount
		settlement.resources[resource] -= amount
	
	var building_owner = settlement.world_building_faction
	var faction = FactionManager.get_faction_data(building_owner)
	if faction:
		for resource in taxed_resources.keys():
			faction.resources[resource] += taxed_resources[resource]
			if building_owner == FactionManager.get_player_faction_key():
				print("Player ",building_owner," collected ",resource," tax: ",taxed_resources[resource])
