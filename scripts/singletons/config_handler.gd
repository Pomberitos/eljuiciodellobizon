extends Node

var config_file: ConfigFile = ConfigFile.new()
const CONFIG_FILE_PATH: String = "user://settings.ini"
const AUDIO_KEYS: Array[String] = ["Master", "Music", "FXs"]


func _ready() -> void:
	check_settings_file()

func check_settings_file() -> void:
	if !FileAccess.file_exists(CONFIG_FILE_PATH):
		for audio_key in AUDIO_KEYS:
			save_audio_setting(audio_key, 1.0)
		config_file.save(CONFIG_FILE_PATH)
	else:
		config_file.load(CONFIG_FILE_PATH)

func save_audio_setting(key:String, value: float) -> void:
	config_file.set_value("audio", key, value)
	config_file.save(CONFIG_FILE_PATH)


func load_audio_settings( )-> Dictionary:
	var audio_settings: Dictionary = {}
	
	for key in config_file.get_section_keys("audio"):
		audio_settings[key] = config_file.get_value("audio", key)

	return audio_settings
