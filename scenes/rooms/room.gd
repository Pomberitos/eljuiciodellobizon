class_name Room extends Node2D

@export var label_name: String

var positions: Array


func _ready():
	positions = $SpawnPositions.get_children()


func _on_player_detector_body_entered(body: Node2D) -> void:
	if body is Player:
		Events.room_entered.emit(self)


func _input(_event: InputEvent) -> void:
	pass
