extends Node

# Posibles posiciones del "Este" en la vista top-down
enum EastPosition {UP, DOWN, LEFT, RIGHT}

@export var key_1: PackedScene
@export var spawn_position: Marker2D

@export var bell_sound: AudioStreamPlayer
@export var incorrect_sound: AudioStreamPlayer

@export var tile_layer: TileMapLayer

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

var current_movement = []

func _ready() -> void:
	Events.connect("box_placed", on_clock_moved)
	current_dir_mapping = direction_mappings.get(EastPosition.RIGHT)

func on_clock_moved(box_name: String) -> void:
	print(box_name)
	_register_movement(box_name)

# Registrar los movimientos de la caja
func _register_movement(movement_name: String):
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

# Acciones al resolver el puzzle correctamente
func _on_puzzle_solved():
	bell_sound.play()
	print("Puzzle Resuelto")
	if key_1:
		var instance = key_1.instantiate() as StaticBody2D
		instance.position = spawn_position.position
		call_deferred("add_child", instance)


	current_movement.clear()
