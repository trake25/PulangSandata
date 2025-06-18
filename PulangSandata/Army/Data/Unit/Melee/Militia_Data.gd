extends Unit_Data
class_name Militia_Data

func _init() -> void:
	unit_name = "Tanod"
	unit_type = "Militia"

	# Slight randomization to simulate variation in training
	battle_stats["attack_power"] = randi_range(18, 22)
	battle_stats["defense_power"] = randi_range(8, 12)
