##DataIOManager
extends Node

#
#const temp_faction := "user://data/factions/faction_data.json"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Initializer.dataio_isready = true
	print("DataIO Manager is ready")

## return value is Dictionary, must use Dictionary.size() to check if not empty
func load_data(data_save_path : String) -> Dictionary:
	if not FileAccess.file_exists(data_save_path):
		print("Requested Data does not exist. Creating empty Data file.")
		save_data({}, data_save_path)

	var file := FileAccess.open(data_save_path, FileAccess.READ)
	var content := file.get_as_text()
	file.close()

	var parsed = JSON.parse_string(content)
	if typeof(parsed) != TYPE_DICTIONARY:
		print("Requested Data is not a dictionary. Returning empty Data file.")
		return {}
	
	return parsed

func save_data(data_dictionary: Dictionary, data_save_path: String) -> void:
	# Ensure the directory exists before saving
	var dir_path := data_save_path.get_base_dir()
	var dir := DirAccess.open("user://")
	if not dir.dir_exists(dir_path):
		var success := dir.make_dir_recursive(dir_path)
		if success != OK:
			push_error("❌ Failed to create directory: %s" % dir_path)

	var file := FileAccess.open(data_save_path, FileAccess.WRITE)
	var json_string := JSON.stringify(data_dictionary, "\t")  # Pretty-print with tab
	file.store_string(json_string)
	file.close()

	print("✅ Data saved to: ", data_save_path)
