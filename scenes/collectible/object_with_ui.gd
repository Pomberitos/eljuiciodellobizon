extends Node2D

class_name ObjectWithUI

@export var interaction_area: Area2D
@export var ObjectUI: Control

var player: Player = null

func _ready() -> void:
	interaction_area.interact = Callable(self, "_on_interact")
	Events.slasher_spawned.connect(_on_slasher_spawned)

func _on_interact() -> void:
	ObjectUI.visible = !ObjectUI.visible


func _on_slasher_spawned(_room: Room) -> void:
	ObjectUI.visible = false
