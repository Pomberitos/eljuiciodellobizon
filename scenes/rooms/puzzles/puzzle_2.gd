extends Node

@export var key_2: PackedScene
@export var key_spawn: Marker2D

func _ready():
    $PuzzleHamster.puzzle_completed.connect(_on_puzzle_completed)

func _on_puzzle_completed():
    var instance = key_2.instantiate() as StaticBody2D
    instance.position = key_spawn.position
    call_deferred("add_child", instance)
    $PuzzleHamster.visible = false