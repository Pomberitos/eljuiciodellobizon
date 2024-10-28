extends Node2D

@export var point_light: PointLight2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


#	randomize()
#	set_tween_light()


func set_tween_light() -> void:
	var tween: Tween = create_tween()
	tween.set_trans(Tween.TRANS_BOUNCE)
	tween.set_loops()
	var start: float = randf_range(0.1, 0.2)
	var end: float = randf_range(0.3, 0.4)
	tween.tween_property(point_light, "energy", end, 0.3)
	tween.tween_property(point_light, "energy", start, 0.6)
