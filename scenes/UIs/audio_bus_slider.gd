extends Control
@export var audio_slider: HSlider
@export var audio_label_value: Label



@export_enum("Master", "Music", "FXs") var bus_name: String

var volume_levels: Array[Dictionary] = [
   {"label": "Apagado", "min": 0, "max": 0.05},
   {"label": "Apenas audible", "min": 0.06, "max": 0.15},
   {"label": "Tirando a suave", "min": 0.16, "max": 0.25},
   {"label": "Más bajo que alto", "min": 0.26, "max": 0.35},
   {"label": "Ni alto ni bajo", "min": 0.36, "max": 0.45},
   {"label": "Más alto que bajo", "min": 0.46, "max": 0.60},
   {"label": "Soportablemente alto", "min": 0.61, "max": 0.75},
   {"label": "Casi al máximo", "min": 0.76, "max": 0.90},
   {"label": "Máximo", "min": 0.91, "max": 1.0},
]


var bus_index: int = 0

func _ready()->void:
	audio_slider.value_changed.connect(on_value_changed)
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
	audio_slider.value = db_to_linear(AudioServer.get_bus_volume_db(bus_index))

func get_volume_label(volume: float) -> String:
	for level in volume_levels:
		if volume >= level["min"] and volume <= level["max"]:
			return level["label"]
	return "Desconocido"