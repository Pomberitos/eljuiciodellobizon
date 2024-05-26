class_name Player
extends CharacterBody2D

@export var max_speed = 100.0
@export var accel = 1000.0
@export var friction = 500.0

@export var lamp: PointLight2D
@export var inventory: Inventory


func _physics_process(delta: float) -> void:
	var input = Input.get_vector("left", "right", "up", "down")
	if input.length() > 0:
		velocity = velocity.move_toward(input * max_speed, accel * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	move_and_slide()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("lamp"):
		lamp.enabled = !lamp.enabled

func pick_item(item: InventoryItem):
	inventory.insert(item)
