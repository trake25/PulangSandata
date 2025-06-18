extends Unit_Data
class_name Warrior_Data

func _init() -> void:
	unit_name = "Kawal"
	unit_type = "Warriors"

	# ⬆️ Sturdier, more powerful unit
	battle_stats["max_health"] = 200
	battle_stats["health"] = 200
	battle_stats["attack_power"] = randi_range(38, 42)
	battle_stats["defense_power"] = randi_range(38, 42)
