extends PanelContainer
class_name Slot

signal piece_placed
@warning_ignore("unused_signal")
signal mouse_entered_slot
@warning_ignore("unused_signal")
signal mouse_exited_slot

@export var current_value = 0 # The value the piece has.
@export var desired_value = 0 # The value the piece should have.

@onready var texture_rect = $TextureRect

func _ready():
	self.mouse_entered.connect(_on_mouse_entered)
	self.mouse_exited.connect(_on_mouse_exited)
	mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND

func _get_drag_data(_at_position: Vector2) -> Variant:
	# Do not allow to drag if the piece is in the correct place.
	if (current_value == desired_value) or (texture_rect.visible == false):
		return null
	
	set_drag_preview(get_preview())
	return self

func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	# Only allow to drop if the data is a Slot and the piece is not in the correct place.
	return (data is Slot and current_value != desired_value) and texture_rect.visible

func _drop_data(_pos, data):
	var tmp_texture = texture_rect.texture
	var tmp_current_value = current_value

	texture_rect.texture = data.texture_rect.texture
	current_value = data.current_value

	data.texture_rect.texture = tmp_texture
	data.current_value = tmp_current_value

	piece_placed.emit()

func get_preview():
	var preview_texture = TextureRect.new()
	preview_texture.texture = texture_rect.texture
	preview_texture.expand_mode = 1
	preview_texture.size = Vector2(64, 64)

	var preview = Control.new()
	preview.add_child(preview_texture)
	return preview

func _on_mouse_entered():
	# Visual feedback when mouse enters
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1.1, 1.1), 0.1)
	emit_signal("mouse_entered_slot")

func _on_mouse_exited():
	# Return to original state
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.1)
	emit_signal("mouse_exited_slot")

func reveal_piece() -> void:
	texture_rect.visible = true
