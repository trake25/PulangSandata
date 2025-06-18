extends Unit_Data
class_name Slaves_Data

func _init() -> void:
	unit_name = "Alipin"
	unit_type = "Laborers"

	#  Building speed boost for laborers
	world_stats["build_speed"] = 3

	#  Randomize battle stats (weaker overall)
	var hp := randi_range(50, 100)
	battle_stats["max_health"] = hp
	battle_stats["health"] = hp
	battle_stats["attack_power"] = randi_range(8, 12)
	battle_stats["defense_power"] = randi_range(4, 6)

	#  Cheaper upkeep (no weapons or wealth required)
	garrison_upkeep = {
		"food": 5,
		"wealth": 0
	}
	min_deployment_cost = {
		"food": 10,
		"weapons": 0,
		"wealth": 0
	}
	deployment_upkeep = {
		"food": 5,
		"weapons": 0,
		"wealth": 0
	}
