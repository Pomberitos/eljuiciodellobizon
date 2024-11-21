extends Control

class_name Puzzle

signal puzzle_completed


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Connect the piece_placed signal from the Slot nodes to the on_piece_placed function.
	var slots = $HBoxContainer/Puzzle.get_children()
	for slot in slots:
		slot.piece_placed.connect(on_piece_placed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func on_piece_placed() -> void:
	if is_puzzle_completed():
		puzzle_completed.emit()

func is_puzzle_completed() -> bool:
	var slots = $HBoxContainer/Puzzle.get_children()
	for slot in slots:
		if slot.current_value != slot.desired_value:
			return false
	return true

func reveal_pieces() -> void:
	var slots = $HBoxContainer/Holders.get_children()
	for slot in slots:
		slot.reveal_piece()