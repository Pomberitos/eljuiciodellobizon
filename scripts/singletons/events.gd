extends Node

var current_room: Room
var is_dialog_open: bool = false
var puzzle_1_done: bool = false

@warning_ignore("unused_signal")
signal room_entered(next_room) # ignore-warning
@warning_ignore("unused_signal")
signal slasher_spawned
@warning_ignore("unused_signal")
signal slasher_gone
@warning_ignore("unused_signal")
signal letter_displayed
@warning_ignore("unused_signal")
signal letter_removed
@warning_ignore("unused_signal")
signal puzzle1_hint_displayed
@warning_ignore("unused_signal")
signal puzzle1_hint_removed
@warning_ignore("unused_signal")
signal box_moved(move_dir: Vector2i)
@warning_ignore("unused_signal")
signal box_placed(string_name: String)
@warning_ignore("unused_signal")
signal object_picked(object: InventoryItem)
@warning_ignore("unused_signal")
signal puzzle_1_solved
@warning_ignore("unused_signal")
signal hamster_puzzle_displayed
@warning_ignore("unused_signal")
signal hamster_puzzle_removed
@warning_ignore("unused_signal")
signal ui_changed
@warning_ignore("unused_signal")
signal cinematic_finished
@warning_ignore("unused_signal")
signal slasher_approaching

func _ready() -> void:
	Dialogic.timeline_started.connect(_on_dialogue_started)
	Dialogic.timeline_ended.connect(_on_dialogue_ended)
	connect("room_entered", set_current_room)
	connect("puzzle_1_solved", set_puzzle_1_solved)


func _on_dialogue_started():
	is_dialog_open = true


func _on_dialogue_ended():
	is_dialog_open = false


func set_current_room(new_room: Room):
	current_room = new_room


func set_puzzle_1_solved() -> void:
	puzzle_1_done = true
