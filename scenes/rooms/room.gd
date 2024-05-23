class_name Room
extends Node2D


func _on_player_detector_body_entered(body: Node2D) -> void:
    if body is Player:
        print("Player Entered Room: " + str(self.name))
        Events.room_entered.emit(self)
