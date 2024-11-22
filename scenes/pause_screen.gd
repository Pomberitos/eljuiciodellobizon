extends Panel

var intro_finished: bool = false
var can_pause: bool = false
@export var config_menu: Control
@export var audio_panel: Panel
@export var control_panel: Panel
@export var reset_config: Button


func _ready() -> void:
	Events.cinematic_finished.connect(_activate_pause)
	Events.slasher_spawned.connect(_activate_pause_with_room)
	Events.slasher_gone.connect(_activate_pause)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") and can_pause:
		toggle_paused()
		
func _activate_pause()-> void:
	can_pause = true

func _activate_pause_with_room(_room: Room)-> void:
	can_pause = true
func toggle_paused() -> void:
	if config_menu.visible:
		config_menu.hide()
		return
	if get_tree().paused:
		self.hide()
		get_tree().paused = false
		
	elif !get_tree().paused:
		self.show()
		get_tree().paused = true


func _on_new_game_button_pressed() -> void:
	get_tree().reload_current_scene()


func _on_volver_menu_pressed() -> void:
	get_tree().change_scene_to_file.bind("res://scenes/UIs/main_menu.tscn").call_deferred()


func _on_unpause_pressed() -> void:
	toggle_paused()


func _on_volver_a_pause_pressed() -> void:
	config_menu.hide()


func _on_config_button_pressed() -> void:
	config_menu.show()


func _on_audio_pressed() -> void:
	control_panel.hide()
	audio_panel.show()
	reset_config.visible = audio_panel.visible


func _on_controles_pressed() -> void:
	audio_panel.hide()
	control_panel.show()
	reset_config.visible = audio_panel.visible


func _on_reset_config_pressed() -> void:
	Events.sound_config_reset.emit()
