class_name Player
extends CharacterBody2D

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

var can_move = true


func _ready() -> void:
	add_to_group(self.get_class())

func _physics_process(_delta: float) -> void:
	# TODO: Only relay on can_move
	if !ui_open() and can_move:
		var current_speed = max_speed
		if Input.is_action_pressed("run"):
			current_speed = max_speed * max_speed_multiplier
		var input_vector: Vector2 = Input.get_vector("left", "right", "up", "down")
		if input_vector.length() > 0:
			animation_tree.set("parameters/Idle/blend_position", input_vector)
			animation_tree.set("parameters/Walk/blend_position", input_vector)
			animation_state.travel("Walk")
			velocity = velocity.move_toward(input_vector * current_speed, accel)
		else:
			animation_state.travel("Idle")
			velocity = velocity.move_toward(Vector2.ZERO, friction)
		move_and_slide()
		if get_slide_collision_count() > 0:
			check_box_collision(velocity)
	else:
		velocity = Vector2.ZERO
		animation_state.travel("Idle")
			

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("lamp"):
		lamp.enabled = !lamp.enabled

func pick_item(item: InventoryItem):
	inventory.insert(item)
	Events.object_picked.emit(item)


func check_box_collision(motion: Vector2) -> void:
	if get_slide_collision_count() > 0:
		if motion.is_equal_approx(Vector2.ZERO):
			return
		var box: GridBox = get_slide_collision(0).get_collider() as GridBox

		if box:
			box.push(motion)

func die():
	print("ready to die")
	get_tree().change_scene_to_file("res://scenes/UIs/game_over.tscn")


func ui_open() -> bool:
	var canvas_nodes = canvas_layer.get_children()
	for canva_node in canvas_nodes:
		if canva_node.visible:
			return true
	return false
