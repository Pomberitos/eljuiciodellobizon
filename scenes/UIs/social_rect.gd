extends TextureRect

@export var link_button: LinkButton

func _ready() -> void:
	link_button.mouse_entered.connect(_on_mouse_entered)
	link_button.mouse_exited.connect(_on_mouse_exited)
	
	
func _on_mouse_entered():
	# Visual feedback when mouse enters
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(1.0,0.92,0.0,1.0), 0.1)
	tween.tween_property(self, "scale", Vector2(1.1,1.1), 0.1)

func _on_mouse_exited():
	# Return to original state
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(1.0,1.0,1.0,1.0), 0.1)
	tween.tween_property(self, "scale", Vector2(1.0,1.0), 0.1)
	
