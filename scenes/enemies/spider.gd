extends Path2D

@onready var pathFollow = $PathFollow2D

@export var speed = 5.0

var is_moving_forward = true

func _process(delta: float) -> void:
	pathFollow.progress += speed * delta
