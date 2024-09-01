class_name Player
extends CharacterBody2D

@export var max_speed = 100.0
@export var accel = 1000.0
@export var friction = 500.0

@export var lamp: PointLight2D
@export var inventory: Inventory

@export var minimap_icon: String = "arrow"

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var animation_state = animation_tree.get("parameters/playback")


func _physics_process(_delta: float) -> void:
	var input_vector: Vector2 = Input.get_vector("left", "right", "up", "down")
	if input_vector.length() > 0:
		animation_tree.set("parameters/Idle/blend_position", input_vector)
		animation_tree.set("parameters/Walk/blend_position", input_vector)
		animation_state.travel("Walk")
		velocity = velocity.move_toward(input_vector * max_speed, accel)
	else:
		animation_state.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, friction)
	move_and_slide()
	if get_slide_collision_count() > 0:
		check_box_collision(velocity)
		

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("lamp"):
		lamp.enabled = !lamp.enabled

func pick_item(item: InventoryItem):
	inventory.insert(item)


func check_box_collision(motion: Vector2) -> void:
	if get_slide_collision_count() > 0:
		if motion.x != 0 and motion.y != 0:
			return
		var box: GridBox = get_slide_collision(0).get_collider() as GridBox

		if box:
			box.push(motion)
