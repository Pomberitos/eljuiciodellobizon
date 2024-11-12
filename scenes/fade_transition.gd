extends CanvasLayer

#signal on_transition_finished
@onready var color_rect: ColorRect = $ColorRect
@onready var animation_player: AnimationPlayer = $AnimationPlayer

#func _ready() -> void:
#	animation_player.animation_finished.connect(_on_animation_finished)
	
	
func transition_fade_in()-> void:
	animation_player.play("fade_in")
	
	
#func _on_animation_finished(anim_name: String)-> void:
#	if anim_name == "fade_out":
#		on_transition_finished.emit()
#		animation_player.play("fade_in")
#	if anim_name == "fade_in":
#		color_rect.hide()