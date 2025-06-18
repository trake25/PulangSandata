extends HBoxContainer

@onready var upgrade_name : Label 
@onready var upgrade_level : Label 
@onready var info_tip_button : Button 
@onready var upgrade_button : Button 

@onready var upgrade_dict : Dictionary


signal upgrade_info_requested(upgrade_name: String)
signal upgrade_requested(upgrade_name: String)

func setup(upgrade_key: String, upgrade_dictionary: Dictionary):
	upgrade_dict = upgrade_dictionary
	var upgrade_name_str = upgrade_key
	upgrade_name = %UpgradeName
	upgrade_level = %UpgradeLv
	info_tip_button = %InfoTipButton
	upgrade_button = %UpgradeButton
	
	upgrade_name.text = " " + upgrade_name_str
	upgrade_level.text = "Lv: " + str(int(upgrade_dict.level))

	info_tip_button.pressed.connect(func(): upgrade_info_requested.emit(upgrade_name_str))
	upgrade_button.pressed.connect(func(): upgrade_requested.emit(upgrade_name_str))
