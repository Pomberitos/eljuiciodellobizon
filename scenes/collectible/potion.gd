extends StaticBody2D

@export var interaction_area: InteractionArea
@export var potion_resource: InventoryItem
var player: Player = null


func _ready() -> void:
	interaction_area.interact = Callable(self, "_on_interact")


func _on_interact()-> void:
	player = interaction_area.current_player as Player
	player.pick_item(potion_resource)
	queue_free()
