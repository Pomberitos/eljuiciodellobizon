extends Node2D

var base_text: String = "Pulsá [E] para {action} {item_name}"
var alt_text: String
var text_y_offset: float
var text_x_offset: float
var active_areas: Array = []
var can_interact: bool = true
@onready var player = get_tree().get_first_node_in_group("player")
@onready var label: Label = $CanvasLayer/Label


func set_pivot_offset() -> void:
	label.pivot_offset = Vector2(label.size.x / 2, label.size.y / 2)


func _ready() -> void:
	set_pivot_offset()
	set_tween_scale()
	Events.slasher_spawned.connect(_on_slasher_spawned)
	Events.slasher_gone.connect(_on_slasher_gone)


func register_area(
	area: InteractionArea, text: String = "", text_offset: Vector2i = Vector2i(0, 32)
) -> void:
	active_areas.push_back(area)
	alt_text = text
	text_x_offset = text_offset.x
	text_y_offset = text_offset.y


func unregister_area(area: InteractionArea) -> void:
	var index = active_areas.find(area)
	if index != -1:
		active_areas.remove_at(index)


func _process(_delta: float) -> void:
	if active_areas.size() > 0 and can_interact:
		active_areas.sort_custom(_sort_by_distance_to_player)
		base_text.format(
			{"action": active_areas[0].action_name, "item_name": active_areas[0].item_name}
		)
		if alt_text.length() > 0:
			label.text = alt_text

		label.global_position = active_areas[0].global_position
		label.global_position.y -= text_y_offset
		label.global_position.x += text_x_offset
		label.show()
	else:
		label.hide()


func _sort_by_distance_to_player(area1, area2) -> bool:
	var area1_to_player = player.global_position.distance_to(area1.global_position)
	var area2_to_player = player.global_position.distance_to(area2.global_position)
	return area1_to_player < area2_to_player


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and can_interact and !Events.is_dialog_open:
		if active_areas.size() > 0:
			can_interact = false
			label.hide()

			await active_areas[0].interact.call()
			can_interact = true


func _on_slasher_spawned(_room: Room) -> void:
	can_interact = false


func _on_slasher_gone() -> void:
	can_interact = true


func set_tween_scale() -> void:
	var tween: Tween = create_tween()
	tween.set_trans(Tween.TRANS_BOUNCE)
	tween.set_loops()
	var start_y: Vector2 = Vector2(1, 1)
	var end_y: Vector2 = Vector2(1.25, 1.25)
	tween.tween_property(label, "scale", end_y, 0.6).from(start_y)
	tween.tween_property(label, "scale", start_y, 0.6).from(end_y)
