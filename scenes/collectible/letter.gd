extends Node2D

@export var interaction_area: InteractionArea
@export var letter: Control
@export var opacity: Control

var player: Player = null

func _ready() -> void:
	interaction_area.interact = Callable(self, "_on_interact")
	Events.slasher_spawned.connect(_on_slasher_spawned)

func _on_interact() -> void:
	letter.visible = !letter.visible
	opacity.visible = !opacity.visible

func _on_slasher_spawned(_room: Room) -> void:
	letter.visible = false
	opacity.visible = false
