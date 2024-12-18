class_name Player extends CharacterBody2D

enum Position {
	ENTRANCE,
	MAIN_HALL,
	LIBRARY,
	DINNER_1,
	DINNER_2,
	BASEMENT,
	KITCHEN,
	PANTRY,
	HALL,
	HALL_B,
	ATTIC,
	HALL_C,
	ASTORS_BEDROOM
}

@export var selected_initial_position: Position = Position.ENTRANCE

@export var max_speed: float = 100.0
@export var max_speed_multiplier: float = 1.5
@export var accel: float = 1000.0
@export var friction: float = 500.0

@export var lamp: PointLight2D
@export var sight: PointLight2D
@export var inventory: Inventory

@export var canvas_layer: CanvasLayer
@export var raycast_group: Array[RayCast2D] # added these raycast to fine tune the push animation
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var animation_state = animation_tree.get("parameters/playback")
@onready var raycast: RayCast2D = $RayCast2D # added these raycast to fine tune the push animation

# Posiciones iniciales definidas
var initial_positions: Array[Vector2] = [
	Vector2(321, 762), # ENTRANCE
	Vector2(349, 360), # MAIN_HALL
	Vector2(1166, -1097), # LIBRARY
	Vector2(898, 210), # DINNER_1
	Vector2(1631, 210), # DINNER_2
	Vector2(2456, 210), # BASEMENT
	Vector2(1519, -96), # KITCHEN
	Vector2(1760, -368), # PANTRY
	Vector2(360, -96), # HALL
	Vector2(376, -584), # HALL B
	Vector2(688, -1112), # ATTIC
	Vector2(896, -766), # HALL C
	Vector2(1720, -766), # ASTOR
]

enum {WALK, CROSS, IDLE, PUSH}

var state = IDLE
var input_vector: Vector2


func _ready() -> void:
	reset_params()
	Dialogic.timeline_started.connect(_on_dialogue_started)
	set_tween_light()
	global_position = initial_positions[selected_initial_position]
	add_to_group(self.get_class())


func reset_params() -> void:
	state = IDLE

func _on_dialogue_started() -> void:
	velocity = Vector2.ZERO
	state = IDLE


func _physics_process(_delta: float) -> void:
	handle_state_transitions()
	perform_state_actions(_delta)
	move_and_slide()


func perform_state_actions(_delta: float) -> void:
	match state:
		WALK:
			animation_state.travel("Walk")
			velocity = velocity.move_toward(input_vector * max_speed, accel)
		PUSH:
			velocity = velocity.move_toward(input_vector * max_speed, accel)
			check_box_collision(velocity)
		IDLE:
			animation_state.travel("Idle")
		CROSS:
			velocity = Vector2.ZERO
			animation_state.travel("Cross")


func handle_state_transitions() -> void:
	if !is_ui_open():
		input_vector = Input.get_vector("left", "right", "up", "down").normalized()
		set_sight_rotation()
		animation_tree.set("parameters/Idle/blend_position", input_vector)
		animation_tree.set("parameters/Walk/blend_position", input_vector)
		animation_tree.set("parameters/Push/blend_position", input_vector)
		animation_tree.set("parameters/Cross/blend_position", input_vector)

		if input_vector != Vector2.ZERO:
			state = WALK
		else:
			velocity = velocity.move_toward(Vector2.ZERO, friction)
			state = IDLE

		if Input.is_action_pressed("cross") and Dialogic.VAR.Caravaca and (!is_ui_open()):
			state = CROSS

		if Input.is_action_just_released("cross") and Dialogic.VAR.Caravaca:
			state = IDLE

		if get_slide_collision_count() > 0 and input_vector != Vector2.ZERO and raycast_colliding():
			state = PUSH
		if (
			get_slide_collision_count() == 0
			and input_vector == Vector2.ZERO
			and !raycast_colliding()
		):
			state = IDLE


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("lamp"):
		lamp.enabled = !lamp.enabled


func pick_item(item: InventoryItem):
	inventory.insert(item)
	Events.object_picked.emit(item)


func check_box_collision(motion: Vector2) -> void:
	if motion.is_equal_approx(Vector2.ZERO) and !raycast_colliding():
		return
	var box := get_slide_collision(0).get_collider()
	var motion_same_as_raycast: bool = raycast.target_position.normalized() == motion.normalized()
	if (box is GridBox or box is ClockBox) and raycast_colliding() and motion_same_as_raycast:
		box.push(motion)
		animation_state.travel("Push")


func die():
	# print("ready to die").bind("res://some_scene.tscn").call_deferred()
	get_tree().change_scene_to_file.bind("res://scenes/UIs/game_over.tscn").call_deferred()


func set_tween_light() -> void:
	var tween: Tween = create_tween()
	tween.set_trans(Tween.TRANS_SPRING)
	tween.set_loops()
	var start: float = -0.02
	var end: float = 0.02
	tween.tween_property(lamp, "skew", end, 0.3)
	tween.tween_property(lamp, "skew", start, 0.3)


func is_ui_open() -> bool:
	if !canvas_layer:
		return false
	var canvas_nodes := canvas_layer.get_children()
	for canva_node in canvas_nodes:
		if canva_node.visible:
			return true
	return Events.is_dialog_open


func set_sight_rotation() -> void:
	if input_vector == Vector2.ZERO:
		return
	var angle_in_radians: float = atan2(input_vector.y, input_vector.x)
	sight.rotation = lerp_angle(sight.rotation, angle_in_radians, 0.4)


func raycast_colliding() -> bool:
	for _raycast in raycast_group:
		if _raycast.is_colliding():
			return true
	return false
