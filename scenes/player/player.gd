class_name Player extends CharacterBody2D

enum Position { ROOM_1, ROOM_2, ROOM_3, ROOM_4 }

@export var selected_initial_position: Position = Position.ROOM_1

@export var max_speed = 100.0
@export var max_speed_multiplier = 1.5
@export var accel = 1000.0
@export var friction = 500.0

@export var lamp: PointLight2D
@export var inventory: Inventory

@export var minimap_icon: String = "arrow"

@export var canvas_layer: CanvasLayer

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var animation_state = animation_tree.get("parameters/playback")

# Posiciones iniciales definidas
var initial_positions: Array[Vector2] = [
	Vector2(435, 376),  # ROOM_1
	Vector2(342, -87),  # ROOM_2
	Vector2(898, 210),  # ROOM_3
	Vector2(1497, -90),  # ROOM_4
]
enum { WALK, CROSS, IDLE, PUSH }

var state = WALK


func _ready() -> void:
	Dialogic.timeline_started.connect(_on_dialogue_started)
	set_tween_light()
	global_position = initial_positions[selected_initial_position]
	add_to_group(self.get_class())

func _on_dialogue_started()-> void:
	velocity = Vector2.ZERO
	state = IDLE

func _physics_process(_delta: float) -> void:
	handle_state_transitions()
	perform_state_actions(_delta)
	move_and_slide()

		
func perform_state_actions(_delta: float)-> void:
	match state:
		WALK:
			var input_vector: Vector2 = Input.get_vector("left", "right", "up", "down")
			animation_state.travel("Walk")
			velocity = velocity.move_toward(input_vector * max_speed, accel)
		PUSH:
			var input_vector: Vector2 = Input.get_vector("left", "right", "up", "down")
			velocity = velocity.move_toward(input_vector * max_speed, accel)
			check_box_collision(velocity)
			animation_state.travel("Push")
		IDLE:
			animation_state.travel("Idle")
		CROSS:
			velocity = Vector2.ZERO
			animation_state.travel("Cross")
			


			
func handle_state_transitions()-> void:
	var input_vector: Vector2 = Input.get_vector("left", "right", "up", "down")
	animation_tree.set("parameters/Idle/blend_position", input_vector)
	animation_tree.set("parameters/Walk/blend_position", input_vector)
	animation_tree.set("parameters/Push/blend_position", input_vector)
	animation_tree.set("parameters/Cross/blend_position", input_vector)

	if !is_ui_open():
		if input_vector != Vector2.ZERO:
			state = WALK
		else:
			velocity = velocity.move_toward(Vector2.ZERO, friction)
			state = IDLE
		
		if Input.is_action_pressed("cross") and Dialogic.VAR.Caravaca and (!is_ui_open()):
			state = CROSS
			
		if Input.is_action_just_released("cross") and Dialogic.VAR.Caravaca:
			state = IDLE
			
		if get_slide_collision_count() > 0 and input_vector != Vector2.ZERO:
			state = PUSH


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("lamp"):
		lamp.enabled = !lamp.enabled


func pick_item(item: InventoryItem):
	inventory.insert(item)
	Events.object_picked.emit(item)


func check_box_collision(motion: Vector2) -> void:
	if motion.is_equal_approx(Vector2.ZERO):
		return
	var box := get_slide_collision(0).get_collider()
	if box is GridBox or box is ClockBox:
		box.push(motion)


func die():
	print("ready to die")
	get_tree().change_scene_to_file("res://scenes/UIs/game_over.tscn")
	

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