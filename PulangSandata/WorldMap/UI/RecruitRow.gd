extends HBoxContainer

@onready var recruit_name : Label 
@onready var info_tip_button : Button 
@onready var recruit_button : Button 

@onready var recruit_dict : Dictionary


signal recruit_info_requested(upgrade_name: String)
signal recruit_requested(upgrade_name: String)

func setup(recruit_key: String, recruit_dictionary: Dictionary):
	recruit_dict = recruit_dictionary
	var recruit_name_str = recruit_key
	recruit_name = %RecruitName
	info_tip_button = %InfoTipButton
	recruit_button = %RecruitButton
	
	recruit_name.text = "  " + recruit_name_str

	info_tip_button.pressed.connect(func(): recruit_info_requested.emit(recruit_name_str))
	recruit_button.pressed.connect(func(): recruit_requested.emit(recruit_name_str))
