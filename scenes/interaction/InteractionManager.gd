extends Node2D

@onready var player = get_tree().get_first_node_in_group("player")
@onready var label = $Label


var base_text: String = "[E] to {action} {item_name}"
var active_areas: Array = []
var can_interact: bool = true

func _ready() -> void:
	Events.slasher_spawned.connect(_on_slasher_spawned)
	Events.slasher_gone.connect(_on_slasher_gone)

func register_area(area: InteractionArea) -> void:
	active_areas.push_back(area)

func unregister_area(area: InteractionArea) -> void:
	var index = active_areas.find(area)
	if index != -1:
		active_areas.remove_at(index)


func _process(_delta: float) -> void:
	if active_areas.size() > 0 and can_interact:
		active_areas.sort_custom(_sort_by_distance_to_player)
		label.text = base_text.format({"action": active_areas[0].action_name, "item_name": active_areas[0].item_name})
		label.global_position = active_areas[0].global_position
		label.global_position.y -= 36
		label.global_position.x -= label.size.x / 2
		label.show()
	else:
		label.hide()


func _sort_by_distance_to_player(area1, area2) -> bool:
	var area1_to_player = player.global_position.distance_to(area1.global_position)
	var area2_to_player = player.global_position.distance_to(area2.global_position)
	return area1_to_player < area2_to_player


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and can_interact:
		if active_areas.size() > 0:
			can_interact = false
			label.hide()
			
			await active_areas[0].interact.call()
			can_interact = true

func _on_slasher_spawned(_room: Room) -> void:
	can_interact = false

func _on_slasher_gone() -> void:
	can_interact = true