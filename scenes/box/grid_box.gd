class_name GridBox extends CharacterBody2D

@export var sliding_time: float = 0.45
@export var drag_audio_fx: AudioStreamPlayer

var tile_map: TileMapLayer
var sliding: bool = false

	
func _ready() -> void:
	tile_map = get_parent()
	add_to_group(self.get_class())

func calculate_destination(_direction: Vector2) -> Vector2:
	var new_dir: Vector2i = Vector2i(_direction)
	var local_pos: Vector2i = tile_map.local_to_map(position)
	var tile_map_position: Vector2i = local_pos + new_dir
	return tile_map.map_to_local(tile_map_position)

func push(_motion: Vector2) -> void:
	if sliding:
		return
	var move_to: Vector2 = calculate_destination(_motion.normalized())

	if can_move(move_to):
		Events.emit_signal("box_moved", Vector2i(_motion.normalized()))
		var tween: Tween = create_tween()
		tween.set_ease(Tween.EASE_OUT)
		
		tween.tween_property(self, "position", move_to, sliding_time)
		sliding = true
		drag_audio_fx.play()
		await drag_audio_fx.finished
		await tween.finished
		sliding = false

func can_move(_move_to: Vector2) -> bool:
	var future_transform := Transform2D(transform)
	future_transform.origin = _move_to
	return !test_move(future_transform, Vector2.ZERO)
