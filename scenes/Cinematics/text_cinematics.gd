extends Control
class_name TextCinematics
@export var texts: Array[CinematicText] = []


@onready var richTextLabel: RichTextLabel = $RichTextLabel
@onready var timer: Timer = $Timer

var current_text_index: int = 0

func _ready() -> void:
	richTextLabel.text = "[center]" + texts[current_text_index].text + "[/center]"
	timer.wait_time = texts[current_text_index].duration
	timer.start()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		if current_text_index < texts.size():
			advance_text()

func _on_timer_timeout() -> void:
	advance_text()

func advance_text():
	current_text_index += 1

	if current_text_index >= texts.size():
		fade_out()
		return

	richTextLabel.text = "[center]" + texts[current_text_index].text + "[/center]"
	timer.wait_time = texts[current_text_index].duration
	timer.start()

func fade_out():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 1.0)
	await tween.finished
	self.hide()
	Events.cinematic_finished.emit()
