extends CanvasLayer
@export var label: Label
@export var animation_player: AnimationPlayer


func _ready() -> void:
	Events.room_entered.connect(show_current_room_label)


func show_current_room_label(new_room: Room) -> void:
	label.text = new_room.label_name
	animation_player.play("fade_out_name")
