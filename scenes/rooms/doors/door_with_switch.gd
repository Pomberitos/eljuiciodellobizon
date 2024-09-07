@tool

extends Door

var objectsInside = 0

func _ready() -> void:
	var switch = get_node("switch")

	switch.connect("body_entered", _on_switch_body_entered)
	switch.connect("body_exited", _on_switch_body_exited)

func _process(_delta: float) -> void:
	if objectsInside > 0:
		open()
	else:
		close()

func _on_switch_body_exited(_body: Node2D) -> void:
	objectsInside -= 1

func _on_switch_body_entered(_body: Node2D) -> void:
	objectsInside += 1
	

func _get_configuration_warnings() -> PackedStringArray:
	var warnings = []
	if not get_node("switch"):
		warnings.append("Switch node is missing")
	return warnings
