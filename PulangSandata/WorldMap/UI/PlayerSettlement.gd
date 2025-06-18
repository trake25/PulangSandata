extends Control

@onready var player_key : String
@onready var player_faction : Faction_Data
@onready var player_settlement_data : Settlement_Data

@onready var settlement_name : LineEdit = %SettlementName
@onready var settlement_info_label : Label = %SettlementInfoLabel
@onready var settlement_info_current : Label = %SettlementInfoCurrent
@onready var settlement_info_maximum : Label = %SettlementInfoMaximum
@onready var trends_label : Label = %TrendsLabel
@onready var info_tip_label : Label
@onready var tax_rate_hslider : HSlider = %TaxRateHSlider

@onready var storage_fill_threshold : float = 0.2
@onready var last_food_amount : int = 0
@onready var last_wood_amount : int = 0
@onready var last_weapons_amount : int = 0
@onready var last_wealth_amount : int = 0
@onready var last_population_amount : int = 0
@onready var last_contentment_amount : int = 0
@onready var recruit_progress_per_hr : float = 0.0

@onready var upgrade_list_container = %UpgradeListContainer
@onready var recruit_list_container = %RecruitListContainer
@onready var garrison_list_container = %GarrisonListContainer
@onready var info_tip_panel = %InfoTipPanel
@onready var upgrade_row = preload("res://PulangSandata/WorldMap/UI/UpgradeRow.tscn")
@onready var recruit_row = preload("res://PulangSandata/WorldMap/UI/RecruitRow.tscn")
@onready var garrison_row = preload("res://PulangSandata/WorldMap/UI/GarrisonRow.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	Initializer.player_settlement = self
	Initializer.playersettlement_isready = true
	print("Player Settlement ready")

func initialize() -> void:
	player_key = FactionManager.get_player_faction_key()
	player_faction = FactionManager.get_player_faction()
	player_settlement_data = WorldBuildingManager.player_settlement
	info_tip_label = info_tip_panel.get_node("%InfoTipPanelLabel")
	if player_settlement_data:
		show_settlement_info()
		format_values()
		update_settlement_info_current()
		update_settlement_maximum()
		update_trend()
		trends_label.text = "Trend"
		tax_rate_hslider.value = player_settlement_data.tax_rate
		populate_upgrade_list()
		populate_recruit_list()
		populate_garrison_list()
		update_progress_label()
		print("Player Settlement initialized")

func update_settlement_ui() -> void:
	show_settlement_info()
	update_settlement_info_current()
	update_settlement_maximum()
	populate_upgrade_list()
	populate_recruit_list()
	populate_garrison_list()
	#update_progress_label()
	
func _gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		if info_tip_panel.visible:
			info_tip_panel.visible = false
			
			
func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed:
		if info_tip_panel.visible:
			info_tip_panel.visible = false
			
			
func update_garrison_wage() -> void:
	if not player_settlement_data:
		return
	var resources = player_settlement_data.resources
	var garrisons = player_settlement_data.garrison_units

	for unit_key in garrisons:
		if not UnitManager.all_units.has(unit_key):
			continue

		var unit_data = UnitManager.all_units[unit_key]
		var upkeep = unit_data.garrison_upkeep

		for resource_name in upkeep.keys():
			var cost = upkeep[resource_name]
			var available = resources.get(resource_name, 0)

			if available >= cost:
				resources[resource_name] = int(clamp(available - cost, 0, player_settlement_data.resource_capacity[resource_name]))
				print(unit_data.unit_name,unit_data.unit_id," consumed upkeep: ",resource_name,": ",cost)
			else:
				if resource_name == "food":
					unit_data.battle_stats["health"] = int(max(unit_data.battle_stats["health"] - (cost - available), 0))
					print(unit_data.unit_id,unit_data.unit_name," cannot upkeep, losing health: ",unit_data.battle_stats["health"])
				elif resource_name == "wealth":
					unit_data.battle_stats["morale"] = int(max(unit_data.battle_stats["morale"] - (cost - available), 0))
					print(unit_data.unit_id,unit_data.unit_name," cannot upkeep, losing morale: ",unit_data.battle_stats["morale"])

				# Set the resource to 0
				
				resources[resource_name] = 0
	
	UnitManager.remove_zero_health_unit()
	populate_garrison_list()
	
	
func populate_recruit_list() -> void:
	var recruit_list_container_vbox = recruit_list_container.get_child(0)
	
	for child in recruit_list_container_vbox.get_children():
		child.queue_free()
	
	for recruit_name in player_settlement_data.recruitable_units.keys():
		var row = recruit_row.instantiate()
		row.name = recruit_name
		row.setup(recruit_name, player_settlement_data.recruitable_units[recruit_name])
		row.recruit_info_requested.connect(_on_recruit_info_requested)
		row.recruit_requested.connect(_on_recruit_requested)
		recruit_list_container_vbox.add_child(row)

func populate_upgrade_list() -> void:
	var upgrade_list_container_vbox = upgrade_list_container.get_child(0)
	
	for child in upgrade_list_container_vbox.get_children():
		child.queue_free()
		
	for upgrade_name in player_settlement_data.upgrades.keys():
		var row = upgrade_row.instantiate()
		row.name = upgrade_name
		row.setup(upgrade_name, player_settlement_data.upgrades[upgrade_name])
		row.upgrade_info_requested.connect(_on_upgrade_info_requested)
		row.upgrade_requested.connect(_on_upgrade_requested)
		upgrade_list_container_vbox.add_child(row)

func populate_garrison_list() -> void:
	
	var garrison_list_container_vbox = garrison_list_container.get_child(0)
	var garrison_keys = player_settlement_data.garrison_units
	
	for child in garrison_list_container_vbox.get_children():
		child.queue_free()
	
	for unit_key in garrison_keys:
		if UnitManager.all_units.has(unit_key):
			var unit_data = UnitManager.all_units[unit_key]
			var row = garrison_row.instantiate()
			row.name = unit_key
			row.setup(unit_key,unit_data)
			row.garrison_info_requested.connect(_on_garrison_info_requested)
			row.disband_requested.connect(_on_disband_requested)
			garrison_list_container_vbox.add_child(row)
		else:
			player_settlement_data.garrison_units.erase(unit_key)
		
func _on_garrison_info_requested(unit_key: String) -> void:
	var unit_data = UnitManager.all_units[unit_key]
	if not info_tip_panel.visible:
		info_tip_panel.visible = !info_tip_panel.visible
	info_tip_label.text = unit_data.unit_name + ".\nHealth: " + str(unit_data.battle_stats["health"])
	info_tip_label.text += "\nMorale: " + str(int(unit_data.battle_stats["morale"]))
	info_tip_label.text += "\nGarrison daily food: " + str(int(unit_data.garrison_upkeep["food"]))
	info_tip_label.text += "\nGarrison daily wage: " + str(int(unit_data.garrison_upkeep["wealth"]))
	info_tip_panel.set_position(get_viewport().get_mouse_position() + Vector2(10, 10))

func _on_disband_requested(unit_key: String) -> void:
	var garrison_list_container_vbox = garrison_list_container.get_child(0)
	if player_settlement_data.garrison_units.has(unit_key) and UnitManager.all_units.has(unit_key):
		UnitManager.all_units.erase(unit_key)
		player_settlement_data.garrison_units.erase(unit_key)
		for child in garrison_list_container_vbox.get_children():
			if child.name == unit_key:
				child.queue_free()
				
		print("Disband successful")
		populate_garrison_list()
		

func _on_upgrade_info_requested(upgrade_name: String) -> void:
	var upgrade_info = player_settlement_data.upgrades.get(upgrade_name)
	if upgrade_info:
		info_tip_panel.visible = !info_tip_panel.visible
		info_tip_label.text = upgrade_info.local_name + "\n"
		info_tip_label.text += upgrade_info.description + "\n"
		info_tip_label.text += "Upgrade Cost: " + "Wood= " + str(int(upgrade_info.cost["wood"])) + " Wealth= " + str(int(upgrade_info.cost["wealth"]))
		info_tip_panel.set_position(get_viewport().get_mouse_position() + Vector2(10, 10))

func _on_upgrade_requested(upgrade_name: String):
	if info_tip_panel.visible:
			info_tip_panel.visible = false
	
	info_tip_panel.visible = true
	info_tip_label.text = "Not implemented yet."
	info_tip_panel.set_position(get_viewport().get_mouse_position() + Vector2(10, 10))
	print("Upgrading: ", upgrade_name)
	# Check resources, level, etc. Then apply upgrade

func _on_recruit_info_requested(recruit_name: String) -> void:
	var recruit_info = player_settlement_data.recruitable_units.get(recruit_name)
	if recruit_info:
		info_tip_panel.visible = !info_tip_panel.visible
		info_tip_label.text = recruit_info.local_name + "\n"
		info_tip_label.text += recruit_info.description + "\n"
		info_tip_label.text += "Recruit Cost:"
		for key in recruit_info.cost.keys():
			info_tip_label.text += " " + key + " = " + str(int(recruit_info.cost[key]))
		info_tip_panel.set_position(get_viewport().get_mouse_position() + Vector2(10, 10))

func _on_recruit_requested(recruit_name: String) -> void:
	if info_tip_panel.visible:
		info_tip_panel.visible = false

	var requested_unit = player_settlement_data.recruitable_units[recruit_name]
	var building_level = player_settlement_data.upgrades[requested_unit.required_building].level
	
	if building_level >= 1:
		if not requested_unit.in_progress:
			var resources_needed : Array = []
			for resource_cost in requested_unit.cost.keys():
				if player_settlement_data.resources.has(resource_cost) and player_settlement_data.resources[resource_cost] >= requested_unit.cost[resource_cost]:
					resources_needed.append(resource_cost)

			if resources_needed.size() == requested_unit.cost.size():
				for needed_resource in resources_needed:
					player_settlement_data.resources[needed_resource] -= int(requested_unit.cost[needed_resource])

				update_settlement_info_current()
				print(recruit_name, " recruitment started.")
				requested_unit.progress = 0.1
				requested_unit.in_progress = true  
				player_settlement_data.recruitable_units[recruit_name] = requested_unit
				update_progress_label()
				
			else:
				info_tip_panel.visible = true
				info_tip_label.text = "Not enough resources to recruit."
				info_tip_panel.set_position(get_viewport().get_mouse_position() + Vector2(10, 10))
				print("Not enough resources to recruit ", recruit_name)
		else:
			info_tip_panel.visible = true
			info_tip_label.text = str(recruit_name) + " recruitment in progress."
			info_tip_panel.set_position(get_viewport().get_mouse_position() + Vector2(10, 10))
			print(recruit_name, " recruitment in progress.")
	else:
		info_tip_panel.visible = true
		info_tip_label.text = "Upgrade required building atleast Lv. 1 to recruit this unit."
		info_tip_panel.set_position(get_viewport().get_mouse_position() + Vector2(10, 10))
		print("Upgrade required building atleast Lv. 1 to recruit this unit.")

func update_recruit_progress() -> void:
	if player_settlement_data:
		var pop : float = player_settlement_data.population
		var pop_cap : float = player_settlement_data.population_limit
		var pop_fill_ratio : float = clamp(float( pop / pop_cap), 0.21, 1.0)
		var contentment_ratio = clamp (float(player_settlement_data.contentment / 100.0), 0.21, 1.0)
		recruit_progress_per_hr = float (100 * pop_fill_ratio * contentment_ratio)
		
		for recruit_name in player_settlement_data.recruitable_units.keys():
			var recruit_data = player_settlement_data.recruitable_units[recruit_name]
			if recruit_data.in_progress and recruit_data.progress < 100.0:
				recruit_data.progress += recruit_progress_per_hr
				print(recruit_data.local_name," progress: ",recruit_data.progress)
			if recruit_data.in_progress and recruit_data.progress >= 100.0:
				recruit_data.in_progress = false
				recruit_data.progress = 0.0
				var new_unit = UnitManager.recruit_unit(recruit_name)
				player_settlement_data.garrison_units.append(new_unit.unit_id)
				populate_garrison_list()
				
				WorldBuildingManager.save_world_buildings()
				print(recruit_data.local_name," recruited.")
		
		
		update_progress_label()



func update_progress_label() -> void:
	var recruit_list_container_vbox = recruit_list_container.get_child(0)
	for recruit_name in player_settlement_data.recruitable_units.keys():
		var recruit = player_settlement_data.recruitable_units[recruit_name]
		for child in recruit_list_container_vbox.get_children():
			if child.name == recruit_name:
				var recruit_progress_label = child.get_node("%RecruitProgress")
				var recruit_progress_button = child.get_node("%RecruitButton")
				if recruit.progress > 0.0 and recruit.progress < 100.0:
					recruit_progress_label.text = " " + str(int(recruit.progress)) + "%"
					recruit_progress_button.visible = false
				else:
					recruit_progress_label.text = ""
					recruit_progress_button.visible = true


func show_settlement_info() -> void:
	settlement_info_label.text = "Settlement"
	settlement_info_label.text += "\n Food: "
	settlement_info_label.text += "\n Wood: "
	settlement_info_label.text += "\n Weapons: "
	settlement_info_label.text += "\n Wealth: "
	settlement_info_label.text += "\n Population: "
	settlement_info_label.text += "\n Contentment: "
	settlement_info_label.text += "\n Tax Rate: "

func update_settlement_info_current() -> void:
	if player_settlement_data:
		settlement_info_current.text = "cur"
		settlement_info_current.text += "\n" + str(player_settlement_data.resources["food"])
		settlement_info_current.text += "\n" + str(player_settlement_data.resources["wood"])
		settlement_info_current.text += "\n" + str(player_settlement_data.resources["weapons"])
		settlement_info_current.text += "\n" + str(player_settlement_data.resources["wealth"])
		settlement_info_current.text += "\n" + str(player_settlement_data.population)
		settlement_info_current.text += "\n" + str(player_settlement_data.contentment)
		settlement_info_current.text += "\n" + str(int(player_settlement_data.tax_rate * 100)) + " %"
		print("Updating settlement info current")

func update_settlement_maximum() -> void:
	settlement_info_maximum.text = "  max"
	settlement_info_maximum.text += "\n / " + str(player_settlement_data.resource_capacity["food"])
	settlement_info_maximum.text += "\n / " + str(player_settlement_data.resource_capacity["wood"])
	settlement_info_maximum.text += "\n / " + str(player_settlement_data.resource_capacity["weapons"])
	settlement_info_maximum.text += "\n / " + str(player_settlement_data.resource_capacity["wealth"])
	settlement_info_maximum.text += "\n / " + str(player_settlement_data.population_limit)
	settlement_info_maximum.text += "\n / 100"
	settlement_info_maximum.text += "\n / 50 %"
	print("Updating settlement info current")

func update_trend() -> void:
	if player_settlement_data:
		trends_label.text = "Trend"
		var cur_food = player_settlement_data.resources["food"]
		if cur_food > last_food_amount:
			trends_label.text += "\n⬆️"
		else:
			trends_label.text += "\n⬇️"
		
		last_food_amount = cur_food
		
		var cur_wood = player_settlement_data.resources["wood"]
		if cur_wood > last_wood_amount:
			trends_label.text += "\n⬆️"
		else:
			trends_label.text += "\n⬇️"
		
		last_wood_amount = cur_wood
		
		var cur_weapons = player_settlement_data.resources["weapons"]
		if cur_weapons > last_weapons_amount:
			trends_label.text += "\n⬆️"
		else:
			trends_label.text += "\n⬇️"
		
		last_weapons_amount = cur_weapons
		
		var cur_wealth = player_settlement_data.resources["wealth"]
		if cur_wealth > last_wealth_amount:
			trends_label.text += "\n⬆️"
		else:
			trends_label.text += "\n⬇️"
		
		last_wealth_amount = cur_wealth
		
		var cur_population = player_settlement_data.population
		if cur_population > last_population_amount:
			trends_label.text += "\n⬆️"
		else:
			trends_label.text += "\n⬇️"
		
		last_population_amount = cur_population
		
		var cur_contentment = player_settlement_data.contentment
		if cur_contentment > last_contentment_amount:
			trends_label.text += "\n⬆️"
		else:
			trends_label.text += "\n⬇️"
		
		last_contentment_amount = cur_contentment
	
func _on_back_pressed() -> void:
	info_tip_panel.visible = false
	InputManager.selection_lock = false
	visible = false

func _on_close_pressed() -> void:
	info_tip_panel.visible = false
	InputManager.selection_lock = false
	visible = false

func format_values() -> void:
	player_settlement_data.resources["food"] = int(player_settlement_data.resources["food"])
	player_settlement_data.resources["wood"] = int(player_settlement_data.resources["wood"])
	player_settlement_data.resources["weapons"] = int(player_settlement_data.resources["weapons"])
	player_settlement_data.resources["wealth"] = int(player_settlement_data.resources["wealth"])
	player_settlement_data.resource_capacity["food"] = int(player_settlement_data.resource_capacity["food"])
	player_settlement_data.resource_capacity["wood"] = int(player_settlement_data.resource_capacity["wood"])
	player_settlement_data.resource_capacity["weapons"] = int(player_settlement_data.resource_capacity["weapons"])
	player_settlement_data.resource_capacity["wealth"] = int(player_settlement_data.resource_capacity["wealth"])
	
	last_food_amount = player_settlement_data.resources["food"]
	last_wood_amount = player_settlement_data.resources["wood"]
	last_weapons_amount = player_settlement_data.resources["weapons"]
	last_wealth_amount = player_settlement_data.resources["wealth"]
	last_population_amount = player_settlement_data.population
	last_contentment_amount = player_settlement_data.contentment
	
	settlement_name.placeholder_text = player_settlement_data.world_building_custom_name
	settlement_name.max_length = 16
	
	info_tip_panel.visible = false

func _on_settlement_name_text_changed(new_text: String) -> void:
	info_tip_panel.visible = false
	var regex = RegEx.new()
	regex.compile("[^a-zA-Z]")  # Regular expression to match non-letter characters
	var result = regex.search(new_text)
	if result:  # If the text contains non-letter characters
		var old_caret_pos = settlement_name.get_caret_column()  # Save the current caret position
		settlement_name.text = regex.sub(new_text, "", true)  # Remove non-letter characters
		settlement_name.set_caret_column(old_caret_pos - result.get_string().length())  # Adjust caret position
		
func _on_settlement_name_text_submitted(new_text: String) -> void:
	player_settlement_data.world_building_custom_name = new_text
	settlement_name.placeholder_text = new_text
	settlement_name.text = ""
	WorldBuildingManager.save_world_buildings()


func _on_settlement_name_editing_toggled(_toggled_on: bool) -> void:
	info_tip_panel.visible = false


func _on_tax_rate_h_slider_value_changed(value: float) -> void:
	player_settlement_data.tax_rate = value
	update_settlement_info_current()
	print("Tax rate changed to: ",value)
