# @tool

extends Door
@export var interaction_area: InteractionArea

var objectsInside = 0

func _ready() -> void:
	interaction_area.interact = Callable(self, "_on_interact")
	for child in get_children():
		if child.is_in_group("door_switch"):
			child.connect("body_entered", _on_switch_body_entered)
			child.connect("body_exited", _on_switch_body_exited)

func _process(_delta: float) -> void:
	var collision_shape = interaction_area.get_child(0) as CollisionShape2D
	if objectsInside > 0:
		open()
		collision_shape.disabled = true
	else:
		close()
		collision_shape.disabled = false

func _on_switch_body_exited(_body: Node2D) -> void:
	objectsInside -= 1

func _on_switch_body_entered(_body: Node2D) -> void:
	objectsInside += 1
	

func _get_configuration_warnings() -> PackedStringArray:
	var warnings = []
	var nodes_in_group = get_tree().get_nodes_in_group("door_switch")
	if nodes_in_group.is_empty():
		warnings.append("Switch node is missing")
	return warnings

func _on_interact() -> void:
	Dialogic.start("no_key_door")
