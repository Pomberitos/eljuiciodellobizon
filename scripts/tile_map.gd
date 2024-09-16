extends TileMapLayer

# This function checks if the tile at the given coordinates on the specified layer
# is used (i.e., contains a specific tile type) and returns a boolean value.
func _use_tile_data_runtime_update(coords: Vector2i) -> bool:
	# Check if the coordinates are in the list of used cells with tile ID 2
	if coords in get_used_cells_by_id(2):
		return true # Return true if the tile ID is 2
	return false # Return false otherwise

# This function updates the tile data at the specified coordinates on the given layer.
# It sets the navigation polygon of the tile data to null.
func _tile_data_runtime_update(_coords: Vector2i, tile_data: TileData) -> void:
	# Set the navigation polygon of the tile data to null for the first layer (index 0)
	tile_data.set_navigation_polygon(0, null)
