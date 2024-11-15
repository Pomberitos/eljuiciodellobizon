extends ObjectWithUI

@export var puzzle_pieces: InventoryItem


func _ready() -> void:
	super()
	interaction_area.interact = Callable(self, "_on_interact")


func _on_interact() -> void:
	if use_puzzle_pieces():
		ObjectUI.visible = !ObjectUI.visible
		if ObjectUI.visible:
			Events.letter_displayed.emit()
		else:
			Events.letter_removed.emit()
	else:
		Dialogic.start("brothers_puzzle_main_hall")
	

func use_puzzle_pieces() -> bool:
	return player.inventory.remove(puzzle_pieces)