extends Node

# Posibles posiciones del "Este" en la vista top-down
enum EastPosition {UP, DOWN, LEFT, RIGHT}

@export var key_1: PackedScene
@export var spawn_position: Marker2D

@export var bell_sound: AudioStreamPlayer
@export var incorrect_sound: AudioStreamPlayer
@export var correct_sound: AudioStreamPlayer

@export var tile_map_layer: TileMapLayer

var atlas_coord: Dictionary = {
	"red": Vector2i(16, 0),
	"blue": Vector2i(16, 3),
	"green": Vector2i(16, 6),
}

# Diccionario que contiene el mapeo de las direcciones para cada posición del "Este"
@onready var direction_mappings: Dictionary = {
	EastPosition.UP: {
		Vector2i.UP: "west",
		Vector2i.RIGHT: "north",
		Vector2i.DOWN: "east",
		Vector2i.LEFT: "south"
	},
	EastPosition.DOWN: {
		Vector2i.UP: "east",
		Vector2i.RIGHT: "south",
		Vector2i.DOWN: "west",
		Vector2i.LEFT: "north"
	},
	EastPosition.LEFT: {
		Vector2i.UP: "north",
		Vector2i.RIGHT: "west",
		Vector2i.DOWN: "south",
		Vector2i.LEFT: "east"
	},
	EastPosition.RIGHT: {
		Vector2i.UP: "north",
		Vector2i.RIGHT: "east",
		Vector2i.DOWN: "south",
		Vector2i.LEFT: "west"
	}
}
var current_dir_mapping: Dictionary

var movement_code = [
	"north",
	"east",
	 "west",
	 "south"
]

var local_maps_coord: Dictionary = {
	"north": Vector2i(22, 7),
	"east": Vector2i(12, 3),
	"west": Vector2i(2, 7),
	"south": Vector2i(12, 11),
}


var current_movement = []

func _ready() -> void:
	Events.connect("box_placed", on_clock_moved)
	current_dir_mapping = direction_mappings.get(EastPosition.RIGHT)

func on_clock_moved(box_name: String, _position: Vector2) -> void:
	_register_movement(box_name, get_tile_position(_position))

# Registrar los movimientos de la caja
func _register_movement(movement_name: String, _coord: Vector2i):
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
	print("Secuencia incorrecta, reiniciando...")
	current_movement.clear()
	reset_switches()

# Acciones al resolver el puzzle correctamente
func _on_puzzle_solved():
	Events.emit_signal("puzzle_1_solved")
	Events.disconnect("box_placed", on_clock_moved)
	bell_sound.play()
	if key_1:
		var instance = key_1.instantiate() as StaticBody2D
		instance.position = spawn_position.position
		call_deferred("add_child", instance)

	current_movement.clear()
	for coord in local_maps_coord.values():
		tile_map_layer.set_cell(coord, 0, atlas_coord["blue"])

func get_tile_position(_position: Vector2) -> Vector2i:
	return tile_map_layer.local_to_map(_position)


func reset_switches() -> void:
	for coord in local_maps_coord.values():
		tile_map_layer.set_cell(coord, 0, atlas_coord["red"])
		