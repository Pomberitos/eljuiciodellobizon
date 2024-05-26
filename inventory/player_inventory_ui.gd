extends Control

@onready var inventory: Inventory = preload("res://inventory/player_inventory.tres")
@onready var ui_slots: Array = $NinePatchRect/GridContainer.get_children()


func _ready() -> void:
	inventory.update.connect(update_slots)
	update_slots()
	visible = false


func update_slots():
	for i in range(min(inventory.item_slots.size(), ui_slots.size())):
		ui_slots[i].update(inventory.item_slots[i])


func toggle_visibility() -> void:
	visible = !visible


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_inventory"):
		toggle_visibility()
