extends Control
@export var audio_slider: HSlider
@export var audio_label_value: Label



@export_enum("Master", "Music", "FXs") var bus_name: String

var volume_levels: Array[Dictionary] = [
   {"label": "Apagado", "min": 0, "max": 0.1}, # 0.0
   {"label": "Apenas audible", "min": 0.06, "max": 0.13}, # 0.125
   {"label": "Tirando a suave", "min": 0.20, "max": 0.30}, # 0.25
   {"label": "Más bajo que alto", "min": 0.35, "max": 0.4},# 0.375
   {"label": "Ni alto ni bajo", "min": 0.45, "max": 0.55}, # 0.5
   {"label": "Más alto que bajo", "min": 0.59, "max": 0.65}, # 0.625
   {"label": "Soportablemente alto", "min": 0.67, "max": 0.8}, # 0.75
   {"label": "Casi al máximo", "min": 0.81, "max": 0.9}, # 0.875
   {"label": "Máximo", "min": 0.91, "max": 1.1}, # 1.0
]


var bus_index: int = 0

func _ready()->void:
	audio_slider.value_changed.connect(on_value_changed)
	audio_slider.drag_ended.connect(_on_h_slider_drag_ended)
	set_bus_index_by_name()
	set_audio_value_label_text()
	set_audio_slider_value()

func on_value_changed(value: float)-> void:
	AudioServer.set_bus_volume_db(bus_index,linear_to_db(value))
	set_audio_value_label_text()

	
func set_bus_index_by_name() -> void:
	bus_index = AudioServer.get_bus_index(bus_name)

func set_audio_value_label_text() -> void:
	audio_label_value.text = get_volume_label(audio_slider.value)
	AudioServer.set_bus_volume_db(1, linear_to_db(audio_slider.value))

func set_audio_slider_value() -> void:
	var audio_settings: Dictionary = ConfigHandler.load_audio_settings()
	audio_slider.value = audio_settings[bus_name]

func get_volume_label(volume: float) -> String:
	for level in volume_levels:
		if volume >= level["min"] and volume <= level["max"]:
			return level["label"]
	return "Desconocido"

func _on_h_slider_drag_ended(value_changed: bool) -> void:
	print(audio_slider.value)
	if value_changed:
		ConfigHandler.save_audio_setting(bus_name, audio_slider.value)
