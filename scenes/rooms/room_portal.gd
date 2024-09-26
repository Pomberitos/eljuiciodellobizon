extends Area2D

@onready var destination: Marker2D = $Marker2D

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.global_position = destination.global_position