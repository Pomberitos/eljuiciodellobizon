class_name InteractionArea extends Area2D

@export var action_name: String = "interact"
@export var item_name: String = "item_name"
@export var alt_text: String = ""
@export var item_sprite: Sprite2D
@export var text_y_offset: float = 32



@onready var shader_material: ShaderMaterial = load("res://scenes/interaction/hint_material.tres") as ShaderMaterial

var current_player: Player = null

var interact: Callable = func():
	pass


func _ready() -> void:
	clear_material()

func _on_body_entered(body: Node2D) -> void:
	if body is Player or body.is_in_group(str(Player)):
		current_player = body
		InteractionManager.register_area(self, alt_text, text_y_offset)
		add_material()


func _on_body_exited(body: Node2D) -> void:
	if body is Player or body.is_in_group(str(Player)):
		current_player = null
		InteractionManager.unregister_area(self)
		clear_material()

func add_material() -> void:
	if item_sprite:
		item_sprite.material = shader_material

func clear_material() -> void:
	if item_sprite:
		item_sprite.material = null
