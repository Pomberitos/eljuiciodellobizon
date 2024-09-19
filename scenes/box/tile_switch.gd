extends Area2D

@export var switch_name: String


func _on_body_entered(body: Node2D) -> void:
	if body is GridBox:
		Events.emit_signal("box_placed", switch_name)
