extends Puzzle

@export var door_to_open: Door

func _ready() -> void:
	super()
	puzzle_completed.connect(_on_puzzle_completed)

func _on_puzzle_completed() -> void:
	door_to_open.open()
	AudioManager.play_sound(AudioManager.DOOR_OPEN_SOUND)
	Dialogic.start("brothers_puzzle_completed")
