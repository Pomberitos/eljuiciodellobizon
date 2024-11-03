class_name ClockBox extends CharacterBody2D

@export var sliding_time: float = 0.45
@export var drag_audio_fx: AudioStreamPlayer
@export var interaction_area: Area2D

@onready var move_dir_dict: Dictionary = {
		Vector2i.UP: $UpRay,
		Vector2i.DOWN: $DownRay,
		Vector2i.RIGHT: $RightRay,
		Vector2i.LEFT: $LeftRay
	}
var tile_map: TileMapLayer
var sliding: bool = false
var cannot_move: bool = false

func _ready() -> void:
#	
	tile_map = get_parent()
	add_to_group(self.get_class())
	

func calculate_destination(_direction: Vector2) -> Vector2:
	var new_dir: Vector2i = Vector2i(_direction)
	var local_pos: Vector2i = tile_map.local_to_map(position)
	var tile_map_position: Vector2i = local_pos + new_dir
	return tile_map.map_to_local(tile_map_position)

func push(_motion: Vector2) -> void:
	if cannot_move:
		return
	var move_to: Vector2 = calculate_destination(_motion.normalized())
	var dir: Vector2i = Vector2i(_motion.normalized())
	if sliding or dir == Vector2i.ZERO:
		return
	if can_move(dir):
		Events.emit_signal("box_moved", Vector2i(_motion.normalized()))
		var tween: Tween = create_tween()
		tween.set_ease(Tween.EASE_OUT)
		
		tween.tween_property(self, "position", move_to, sliding_time)
		sliding = true
		drag_audio_fx.play()
		await drag_audio_fx.finished
		await tween.finished
		sliding = false

func can_move(dir: Vector2i) -> bool:
	var is_colliding = check_collisions_with_group(dir)
	return !is_colliding


func check_collisions_with_group(move_dir: Vector2i):
	var raycast: RayCast2D = move_dir_dict[move_dir]
	if raycast.is_colliding():
		return true
	return false
