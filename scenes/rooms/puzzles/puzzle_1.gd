extends Node


# Posibles posiciones del "Este" en la vista top-down
enum EastPosition {UP, DOWN, LEFT, RIGHT}

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
    "north", "east", "south", "west"
]
var current_movement = []


func _ready() -> void:
	Events.connect("box_moved", on_clock_moved)
	current_dir_mapping = direction_mappings.get(EastPosition.RIGHT)
	
func on_clock_moved(new_dir: Vector2i) -> void:
	print(new_dir)
	_register_movement(new_dir)

# Registrar los movimientos de la caja
func _register_movement(direction: Vector2i):
	var movement = current_dir_mapping.get(direction)
	current_movement.append(movement)

	if current_movement.size() > movement_code.size():
		current_movement.remove_at(0)

	if _check_movement_sequence():
		_on_puzzle_solved()


func _check_movement_sequence() -> bool:
	if movement_code.size() != current_movement.size():
		return false
	for i in range(movement_code.size()):
		if current_movement[i] != movement_code[i]:
			return false
	return true

func _on_puzzle_solved():
	print("¡Puzzle resuelto! La caja se ha movido correctamente.")
	current_movement.clear()