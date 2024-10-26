extends StaticBody2D

@export var interaction_area: InteractionArea
@export var key_resource: InventoryItem
@export var item_sound: AudioStreamPlayer

var player: Player = null


func _ready() -> void:
	interaction_area.interact = Callable(self, "_on_interact")


func _on_interact() -> void:
	player = interaction_area.current_player as Player
	player.pick_item(key_resource)
	if item_sound:
		item_sound.play()
		await item_sound.finished
		Dialogic.VAR[key_resource.name] = true
		queue_free()
	queue_free()
