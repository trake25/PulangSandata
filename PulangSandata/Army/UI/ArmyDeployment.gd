extends Control

@onready var garrison_units_hbox : HBoxContainer = %GarrisonUnitsHBox
@onready var army_units_hbox : HBoxContainer = %ArmyUnitsHBox
@onready var unit_card : PackedScene = preload("res://PulangSandata/Army/UI/UnitCard.tscn")

@onready var food_supplies_label : Label = %FoodSupplies
@onready var food_supplies_slider : HSlider = %FoodSuppliesSlider
@onready var wood_supplies_label : Label = %WoodSupplies
@onready var wood_supplies_slider : HSlider = %WoodSuppliesSlider
@onready var weapons_supplies_label : Label = %WeaponSupplies
@onready var weapons_supplies_slider : HSlider = %WeaponsSuppliesSlider
@onready var wealth_supplies_label : Label = %WealthSupplies
@onready var wealth_supplies_slider : HSlider = %WealthSuppliesSlider

@onready var info_tip_panel : Panel = %InfoTipPanel
@onready var info_tip_label : Label

@onready var total_min_deployment_cost : Dictionary = {
		"food": 0,
		"wood": 0,
		"weapons": 0,
		"wealth": 0,
	}

@onready var total_supplies : Dictionary = {
		"food": 0,
		"wood": 0,
		"weapons": 0,
		"wealth": 0,
	}

@onready var deployed_units: Array[Unit_Data] = []
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	Initializer.army_deployment = self
	Initializer.armydeployment_isready = true
	print("Army Deployment ready")

func initialize() -> void:
	init_slider()
	info_tip_label = info_tip_panel.get_node("%InfoTipPanelLabel")
	%ArmyName.max_length = 16
	print("Army Deployment initialized")

func init_slider() -> void:
	var resource = FactionManager.player_faction.resources
	food_supplies_slider.max_value = resource["food"]
	wood_supplies_slider.max_value = resource["wood"]
	weapons_supplies_slider.max_value = resource["weapons"]
	wealth_supplies_slider.max_value = resource["wealth"]


	
func clear_garrisons() -> void:
	if garrison_units_hbox.get_child_count() > 0:
		for child in garrison_units_hbox.get_children():
			child.queue_free()

func clear_army_units_hbox() -> void:
	if army_units_hbox.get_child_count() > 0:
		for child in army_units_hbox.get_children():
			child.queue_free()
	
func populate_garrison_units(garrisons: Array) -> void:
	clear_garrisons()
	clear_army_units_hbox()
	
	for unit_id in garrisons:
		var new_card = unit_card.instantiate()
		var unit_data = UnitManager.all_units[unit_id]
		new_card.name = "GarrisonUnit" + unit_id
		new_card.set_unit(unit_data)
		new_card.mode = "garrison"  # We'll use this flag later in drag behavior
		garrison_units_hbox.add_child(new_card)

func calculate_total_supplies() -> void:
	#var resources = FactionManager.player_faction.resources
	
	calculate_min_deployment_cost()
		
	for supply in total_supplies.keys():
		total_supplies[supply] = 0
	
	for req_res in total_min_deployment_cost:
		total_supplies[req_res] += total_min_deployment_cost[req_res]
	
	
	total_supplies["food"] += food_supplies_slider.value
	total_supplies["wood"] += wood_supplies_slider.value
	total_supplies["weapons"] += weapons_supplies_slider.value
	total_supplies["wealth"] += wealth_supplies_slider.value


func calculate_min_deployment_cost() -> void:
	check_army_units_box()
	for key in total_min_deployment_cost.keys():
		total_min_deployment_cost[key] = 0
	
	for unit in deployed_units:
		for resource in unit.min_deployment_cost.keys():
			total_min_deployment_cost[resource] += int(unit.min_deployment_cost[resource])

func faction_can_afford_deployment() -> bool:
	var player_resources := FactionManager.player_faction.resources
	
	for resource in total_supplies:
		var required = total_supplies[resource]
		var available = player_resources.get(resource, 0)
		
		if available < required:
			return false
	
	return true

func check_army_units_box() -> void:
	deployed_units.clear()
	
	for card in army_units_hbox.get_children():
		if card.unit_data:
			deployed_units.append(card.unit_data)
	
func _on_army_to_garrison_pressed() -> void:
	var garrisons = Initializer.player_settlement.player_settlement_data.garrison_units
	deployed_units.clear()
	populate_garrison_units(garrisons)

func _on_garrison_to_army_pressed() -> void:
	var children = garrison_units_hbox.get_children()
	for child in children:
		garrison_units_hbox.remove_child(child)
		army_units_hbox.add_child(child)

func _on_back_pressed() -> void:
	InputManager.selection_lock = false
	visible = false

func _on_close_pressed() -> void:
	InputManager.selection_lock = false
	visible = false
	
func _on_food_supplies_slider_value_changed(value: float) -> void:
	var resources = FactionManager.player_faction.resources
	
	calculate_min_deployment_cost()
	food_supplies_slider.max_value = resources["food"] - total_min_deployment_cost["food"]
	food_supplies_label.text = "Food Supplies: " + str(int(value))


func _on_wood_supplies_slider_value_changed(value: float) -> void:
	var resources = FactionManager.player_faction.resources
	calculate_min_deployment_cost()
	wood_supplies_slider.max_value = resources["wood"] - total_min_deployment_cost["wood"]
	wood_supplies_label.text = "Wood Supplies: " + str(int(value))



func _on_weapons_supplies_slider_value_changed(value: float) -> void:
	var resources = FactionManager.player_faction.resources
	calculate_min_deployment_cost()
	weapons_supplies_slider.max_value = resources["weapons"] - total_min_deployment_cost["weapons"]
	weapons_supplies_label.text = "Weapons Supplies: " + str(int(value))
	


func _on_wealth_supplies_slider_value_changed(value: float) -> void:
	var resources = FactionManager.player_faction.resources
	calculate_min_deployment_cost()
	wealth_supplies_slider.max_value = resources["wealth"] - total_min_deployment_cost["wealth"]
	wealth_supplies_label.text = "Wealth Supplies: " + str(int(value))


func _on_min_deploy_cost_info_pressed() -> void:
	calculate_min_deployment_cost()
	var text : String = "Minimum amount of resources for army to be deployed.\n"
	for req_res in total_min_deployment_cost.keys():
		text += req_res + ": " + str(int(total_min_deployment_cost[req_res])) + "  "
	show_info_tip(text)

func show_info_tip(text: String) -> void:
	info_tip_panel.visible = !info_tip_panel.visible
	info_tip_label.text = text
	info_tip_panel.set_position(get_viewport().get_mouse_position() + Vector2(10, 10))

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if info_tip_panel.visible:
				info_tip_panel.visible = false


func _on_total_deploy_cost_info_pressed() -> void:
	calculate_total_supplies()
	var text : String = "Total supplies that the army will carry after deployment.\n"
	for supply in total_supplies.keys():
		text += supply + ": " + str(int(total_supplies[supply])) + "  "
	show_info_tip(text)

func faction_pay_deployment_cost() -> void:
	var resources = FactionManager.player_faction.resources
	
	for resource in resources:
		resources[resource] -= total_supplies[resource]
	
	FactionManager.update_player_resources()

func deploy_army(army_id: String) -> void:
	var garrisons = Initializer.player_settlement.player_settlement_data.garrison_units
	#var player_settlement = Initializer.player_settlement
	for unit in deployed_units:
		var unit_id = unit.unit_id
		garrisons.erase(unit_id)
		UnitManager.all_units[unit_id].world_stats["status"] = "Mustered"
		UnitManager.all_units[unit_id].army_id = army_id
	
	deployed_units.clear()
	#player_settlement.update_settlement_ui()              # still buggy
	
		
func _on_deploy_pressed() -> void:
	var text = ""
		
	check_army_units_box()
	if deployed_units.is_empty():
		text = "No units in Army Box for deployment."
		show_info_tip(text)
		return
	
	calculate_total_supplies()
	if !faction_can_afford_deployment():
		text = "Not enough faction resources. Check total supplies info."
		show_info_tip(text)
		return
	
	print("Resources enough. Deploying Army.")
	faction_pay_deployment_cost()
	
	var army_name = %ArmyName.placeholder_text
	print("army_name: ",army_name)
	var player_faction_id = FactionManager.player_faction_id
	var army = ArmyManager.create_army(player_faction_id, army_name, deployed_units, total_supplies)
	
	deploy_army(army.army_id)
	Initializer.army_renderer.render_army(army.army_id, army)
	
	_on_close_pressed()
	


func _on_army_name_text_changed(new_text: String) -> void:
	
	var regex = RegEx.new()
	regex.compile("[^a-zA-Z]")  # Regular expression to match non-letter characters
	var result = regex.search(new_text)
	if result:  # If the text contains non-letter characters
		var old_caret_pos = %ArmyName.get_caret_column()  # Save the current caret position
		%ArmyName.text = regex.sub(new_text, "", true)  # Remove non-letter characters
		%ArmyName.set_caret_column(old_caret_pos - result.get_string().length())  # Adjust caret position


func _on_army_name_text_submitted(new_text: String) -> void:
	%ArmyName.placeholder_text = new_text
	%ArmyName.text = ""
