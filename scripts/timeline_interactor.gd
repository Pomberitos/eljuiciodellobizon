extends Node2D

class_name TimelineInteractor

@export var dialogicTimeline: DialogicTimeline

@export var interaction_area: Area2D


func _ready() -> void:
	interaction_area.interact = Callable(self, "_on_interact")

func _on_interact():
	Dialogic.start(dialogicTimeline)
