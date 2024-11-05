extends TileMapLayer

@export var objects_layer: TileMapLayer


func _ready() -> void:
	Events.box_moved.connect(_on_box_moved)


func _use_tile_data_runtime_update(coords: Vector2i) -> bool:
	if coords in objects_layer.get_used_cells():
		return true
	return false


func _tile_data_runtime_update(coords: Vector2i, tile_data: TileData) -> void:
	if coords in objects_layer.get_used_cells():
		tile_data.set_navigation_polygon(0, null)


func _on_box_moved(move_dir: Vector2i) -> void:
	print(move_dir)
