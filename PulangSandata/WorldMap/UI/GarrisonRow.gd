extends HBoxContainer

@onready var garrison_unit_name : Label 
@onready var info_tip_button : Button 
@onready var disband_button : Button 

signal garrison_info_requested(upgrade_name: String)
signal disband_requested(upgrade_name: String)


func setup(unit_key: String, unit_data: Unit_Data):
	garrison_unit_name = %GarrisonUnitName
	info_tip_button = %InfoTip
	disband_button = %Disband
	
	garrison_unit_name.text = " (" + str(unit_data.unit_id) + ") " + unit_data.unit_type

	info_tip_button.pressed.connect(func(): garrison_info_requested.emit(unit_key))
	disband_button.pressed.connect(func(): disband_requested.emit(unit_key))
