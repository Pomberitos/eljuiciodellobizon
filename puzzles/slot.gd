extends PanelContainer
class_name Slot

@export var current_value = 0 # The value the piece has.
@export var desired_value = 0 # The value the piece should have.

@onready var texture_rect = $TextureRect

func _get_drag_data(_at_position: Vector2) -> Variant:
	# Do not allow to drag if the piece is in the correct place.
	if current_value == desired_value:
		return null
	
	set_drag_preview(get_preview())
	
	return self

func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	# Only allow to drop if the data is a Slot and the piece is not in the correct place.
	return data is Slot and current_value != desired_value

func _drop_data(_pos, data):

	var tmp_texture = texture_rect.texture
	var tmp_current_value = current_value

	texture_rect.texture = data.texture_rect.texture
	current_value = data.current_value

	data.texture_rect.texture = tmp_texture
	data.current_value = tmp_current_value

func get_preview():
	var preview_texture = TextureRect.new()

	preview_texture.texture = texture_rect.texture
	preview_texture.expand_mode = 1
	preview_texture.size = Vector2(64, 64)

	var preview = Control.new()
	preview.add_child(preview_texture)

	return preview
