extends StaticBody2D

@export var interaction_area: InteractionArea
@export var key_resource: InventoryItem
@export var item_sound: AudioStreamPlayer
@export var point_light2D: PointLight2D

var player: Player = null


func _ready() -> void:
	interaction_area.interact = Callable(self, "_on_interact")
	if point_light2D:
		set_tween_light()


func _on_interact() -> void:
	player = interaction_area.current_player as Player
	player.pick_item(key_resource)
	if item_sound:
		item_sound.play()
		await item_sound.finished
		Dialogic.VAR[key_resource.name] = true
		if Dialogic.VAR.Caravaca and Dialogic.VAR.key4:
			get_tree().change_scene_to_file("res://scenes/UIs/finish_mvp.tscn")
		queue_free()
	queue_free()


func set_tween_light() -> void:
	var tween: Tween = create_tween()
	tween.set_trans(Tween.TRANS_BOUNCE)
	tween.set_loops()
	var start: float = 1
	var end: float = 1.2
	tween.tween_property(point_light2D, "texture_scale", end, 0.2)
	tween.tween_property(point_light2D, "texture_scale", start, 0.2)
