extends ObjectWithUI


func _ready() -> void:
	super()
	interaction_area.interact = Callable(self, "_on_interact")


func _on_interact() -> void:
	ObjectUI.visible = !ObjectUI.visible
	if ObjectUI.visible:
		Events.puzzle1_hint_displayed.emit()
	else:
		Events.puzzle1_hint_removed.emit()
