extends ObjectWithUI

@export var player: Player
@export var puzzle_pieces: InventoryItem
@export var canvas_layer: CanvasLayer

func _ready() -> void:
	super()
	interaction_area.interact = Callable(self, "_on_interact")


func _on_interact() -> void:
	if use_puzzle_pieces():
		ObjectUI.reveal_pieces()
	else:
		if !is_ui_open(): 
			Dialogic.start("brothers_puzzle_main_hall")
			await Dialogic.timeline_ended
	
	ObjectUI.visible = !ObjectUI.visible
	if ObjectUI.visible:
		Events.letter_displayed.emit()
	else:
		Events.letter_removed.emit()
	

func use_puzzle_pieces() -> bool:
	return player.inventory.remove(puzzle_pieces)

func is_ui_open() -> bool:
	if !canvas_layer:
		return false
	var canvas_nodes := canvas_layer.get_children()
	for canva_node in canvas_nodes:
		if canva_node.visible:
			return true
	return Events.is_dialog_open
