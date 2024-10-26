extends Door

signal door_opened

@export var interaction_area: InteractionArea
@export var key_resource: InventoryItem
var player: Player = null
var collision_shape: CollisionShape2D

func _ready() -> void:
	interaction_area.interact = Callable(self, "_on_interact")
	door_opened.connect(on_door_opened)


func _on_interact() -> void:
	player = interaction_area.current_player as Player
	emit_signal("door_opened")
	

func on_door_opened() -> void:
	Dialogic.start(label)
	if isDoorClosed and use_key():
		open()
		collision_shape = interaction_area.get_child(0) as CollisionShape2D
		collision_shape.disabled = true
	else:
		close()


func use_key() -> bool:
	return player.inventory.remove(key_resource)