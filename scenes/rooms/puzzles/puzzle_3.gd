extends Node

# Posibles posiciones del "Este" en la vista top-down
enum EastPosition {UP, DOWN, LEFT, RIGHT}

@export var price: PackedScene
@export var price_spawn_position: Marker2D

@export var bell_sound: AudioStreamPlayer
@export var incorrect_sound: AudioStreamPlayer
@export var correct_sound: AudioStreamPlayer

@export var tile_map_layer: TileMapLayer

var atlas_coord: Dictionary = {
	"red": Vector2i(16, 0),
	"blue": Vector2i(16, 3),
	"green": Vector2i(16, 6),
}


var movement_code = ["Twelve", "Three", "Six"]

var local_maps_coord: Dictionary = {
	"north": Vector2i(11, 4),
	"east": Vector2i(17, 8),
	"west": Vector2i(5, 8),
	"south": Vector2i(11, 11),
}

var current_movement = []


# Registrar los movimientos de la caja
func _register_movement(movement_name: String, _coord: Vector2i):
	print(" voy a registrar el movimiento ", movement_name)
	# Si el movimiento es correcto, lo añadimos
	if current_movement.size() < movement_code.size():
		current_movement.append(movement_name)
	else:
		current_movement.remove_at(0)
		current_movement.append(movement_name)

	# Verificamos la secuencia
	if not _check_movement_sequence():
		_reset_movement() # Si la secuencia es incorrecta, reseteamos
	else:
		print("voy a pintar el tile ", _coord)
		tile_map_layer.set_cell(_coord, 0, atlas_coord["green"])
		correct_sound.play()
		if current_movement.size() == movement_code.size():
			_on_puzzle_solved()


# Verificar si la secuencia es correcta
func _check_movement_sequence() -> bool:
	for i in range(current_movement.size()):
		if current_movement[i] != movement_code[i]:
			return false
	return true


# Si la secuencia es incorrecta, se resetea
func _reset_movement():
	incorrect_sound.play()
	current_movement.clear()
	reset_switches()


# Acciones al resolver el puzzle correctamente
func _on_puzzle_solved():
	Events.emit_signal("puzzle_2_solved")
	bell_sound.play()
	if price:
		var instance = price.instantiate() as StaticBody2D
		instance.position = price_spawn_position.position
		call_deferred("add_child", instance)

	current_movement.clear()
	for coord in local_maps_coord.values():
		tile_map_layer.set_cell(coord, 0, atlas_coord["blue"])


func reset_switches() -> void:
	tile_map_layer.set_cell($TileSwitchTwelve.position, 0, atlas_coord["red"])
	tile_map_layer.set_cell($TileSwitchThree.position, 0, atlas_coord["red"])
	tile_map_layer.set_cell($TileSwitchSix.position, 0, atlas_coord["red"])
	tile_map_layer.set_cell($TileSwitchNine.position, 0, atlas_coord["red"])


func _onTileSwitchTwelveBodyEntered(_body: Node) -> void:
	_register_movement("Twelve", local_maps_coord["north"])

func _onTileSwitchThreeBodyEntered(_body: Node) -> void:
	_register_movement("Three", local_maps_coord["east"])

func _onTileSwitchSixBodyEntered(_body: Node) -> void:
	_register_movement("Six", local_maps_coord["south"])

func _onTileSwitchNineBodyEntered(_body: Node) -> void:
	_register_movement("Nine", local_maps_coord["west"])
