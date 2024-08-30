@tool

extends Door

func _ready() -> void:
	var switch = get_node("switch")

	switch.connect("body_entered", _on_switch_body_entered)
	switch.connect("body_exited", _on_switch_body_exited)


func _on_switch_body_exited(_body: Node2D) -> void:
	close()


func _on_switch_body_entered(_body: Node2D) -> void:
	open()

func _get_configuration_warnings() -> PackedStringArray:
	print("in tool")
	var warnings = []
	if not get_node("switch"):
		warnings.append("Switch node is missing")
	return warnings