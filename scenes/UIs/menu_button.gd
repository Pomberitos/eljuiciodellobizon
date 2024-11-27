extends Button


func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func _on_mouse_entered():
	# Visual feedback when mouse enters
	var tween = create_tween()
	pivot_offset = size / 2
	tween.tween_property(self, "scale", Vector2(1.1,1.1), 0.1)
	AudioManager.play_sound(AudioManager.PAGE_FLIP, -5)

func _on_mouse_exited():
	# Return to original state
	var tween = create_tween()
	pivot_offset = size / 2
	tween.tween_property(self, "scale", Vector2(1.0,1.0), 0.1)
