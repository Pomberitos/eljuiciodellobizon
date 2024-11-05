extends Node2D

@export var point_light: PointLight2D
@export var animation_player: AnimationPlayer
var animation_list: Array[String] = [
	"flicker",
	"flicker_2",
	"flicker_3",
	"flicker_4",
	"flicker_5",
]


func _ready() -> void:
	randomize()
	set_random_animation()


func set_tween_light() -> void:
	var tween: Tween = create_tween()
	tween.set_trans(Tween.TRANS_BOUNCE)
	tween.set_loops()
	var start: float = randf_range(0.1, 0.2)
	var end: float = randf_range(0.3, 0.4)
	tween.tween_property(point_light, "energy", end, 0.3)
	tween.tween_property(point_light, "energy", start, 0.6)


func set_random_animation() -> void:
	var random_animation_name: String = animation_list[randi() % animation_list.size()]
	animation_player.play(random_animation_name)
