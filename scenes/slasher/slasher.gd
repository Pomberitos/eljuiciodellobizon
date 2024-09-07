class_name Slasher
extends CharacterBody2D

const speed = 200

@export var player: Node2D
@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
@onready var timer: Timer = $Timer
@export var minimap_icon: String = "slasher"

func _ready():
	call_deferred("makepath")

func _physics_process(_delta: float) -> void:
	var current_agent_position = global_position
	var next_path_position = nav_agent.get_next_path_position()
	var new_velocity = current_agent_position.direction_to(next_path_position) * speed
	if nav_agent.avoidance_enabled:
		nav_agent.set_velocity(new_velocity)
	else:
		_on_navigation_agent_2d_velocity_computed(new_velocity)
	move_and_slide()

func _on_timer_timeout():
	call_deferred("makepath")

func makepath() -> void:
	await get_tree().physics_frame
	if player:
		nav_agent.target_position = player.global_position

func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	velocity = safe_velocity

func _on_navigation_agent_2d_navigation_finished() -> void:
	timer.start()


func _on_attack_area_body_entered(body: Node2D) -> void:
	print("hiiiit")
	if body.has_method("die"):
		body.die()


func _on_life_timer_timeout() -> void:
	queue_free()
	Events.slasher_gone.emit()
