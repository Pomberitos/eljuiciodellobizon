extends Node

@export var key_2: PackedScene
@export var key_spawn: Marker2D
@export var puzzle_hamster: Control
@export var audio_player: AudioStreamPlayer

func _ready():
	puzzle_hamster.puzzle_completed.connect(_on_puzzle_completed)

func _on_puzzle_completed():
	if audio_player:
		audio_player.play()
	var instance := key_2.instantiate() as StaticBody2D
	instance.position = key_spawn.position
	call_deferred("add_child", instance)
	Dialogic.start("puzzle_hamster_completed")
#	$PuzzleHamster.visible = false 
# Se removio porque hay jugadores que les hubiera gustado ver el puzzle terminado
	# tal vez se pueda poner un timer antes de que se desactive y otro feedback
