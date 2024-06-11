class_name Room
extends Node2D

@export_enum("Room 1:1", "Room 2:2", "Room 3:3", "Room 4:4") var number: int

@onready var positions: Array = $SpawnPositions.get_children()

func _on_player_detector_body_entered(body: Node2D) -> void:
	if body is Player:
		print("Player Entered Room: " + str(self.name))
		Events.room_entered.emit(self)
