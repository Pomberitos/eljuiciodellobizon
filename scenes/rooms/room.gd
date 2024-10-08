class_name Room
extends Node2D

@export_enum("Room 1:1", "Room 2:2", "Room 3:3", "Room 4:4", "Room 5:5") var number: int

var positions: Array

func _ready():
	Events.room_entered.connect(_on_room_entered)
	positions = $SpawnPositions.get_children()

func _on_player_detector_body_entered(body: Node2D) -> void:
	if body is Player:
		Events.room_entered.emit(self)

func _on_room_entered(room: Room) -> void:
	print("Room entered: ", room.number)
