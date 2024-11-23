extends ObjectWithUI


func _ready() -> void:
	super()
	interaction_area.interact = Callable(self, "_on_interact")


func _on_interact() -> void:
	ObjectUI.visible = !ObjectUI.visible
	if ObjectUI.visible:
		Events.letter_displayed.emit()
	else:
		Events.letter_removed.emit()
