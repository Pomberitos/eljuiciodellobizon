class_name Room extends Node2D

@export var label_name: String
var hall_first_time: bool = false
var positions: Array


func _ready():
	hall_first_time = false
	positions = $SpawnPositions.get_children()


func _on_player_detector_body_entered(body: Node2D) -> void:
	if body is Player:
		Events.room_entered.emit(self)
		if not hall_first_time and Events.current_room.label_name == "MainHall":
			hall_first_time = true
			Dialogic.start("main_door_locked")

func _input(_event: InputEvent) -> void:
	pass
