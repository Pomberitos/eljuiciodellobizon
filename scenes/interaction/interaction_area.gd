class_name InteractionArea extends Area2D

@export var action_name: String = "interact"
@export var item_name: String = "item_name"
@export var alt_text: String = ""

var current_player: Player = null

var interact: Callable = func():
	pass


func _on_body_entered(body: Node2D) -> void:
	if body is Player or body.is_in_group(str(Player)):
		current_player = body
		InteractionManager.register_area(self, alt_text)


func _on_body_exited(body: Node2D) -> void:
	if body is Player or body.is_in_group(str(Player)):
		current_player = null
		InteractionManager.unregister_area(self)
