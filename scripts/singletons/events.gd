extends Node

var current_room: Room
@warning_ignore("unused_signal")
signal room_entered(next_room)  #ignore-warning
@warning_ignore("unused_signal")
signal slasher_spawned
@warning_ignore("unused_signal")
signal slasher_gone
@warning_ignore("unused_signal")
signal letter_displayed
@warning_ignore("unused_signal")
signal letter_removed
@warning_ignore("unused_signal")
signal puzzle1_hint_displayed(interactable_name: String)
@warning_ignore("unused_signal")
signal puzzle1_hint_removed(interactable_name: String)
@warning_ignore("unused_signal")
signal box_moved(move_dir: Vector2i)
@warning_ignore("unused_signal")
signal box_placed(string_name: String)
@warning_ignore("unused_signal")
signal object_picked(object: InventoryItem)
@warning_ignore("unused_signal")
signal puzzle_1_solved


func _ready() -> void:
	connect("room_entered", set_current_room)


func set_current_room(new_room: Room):
	current_room = new_room
