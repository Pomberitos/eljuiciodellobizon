extends Room

@export var light: DirectionalLight2D
@export var jackie: CharacterBody2D

var hasShownMaiddialogue = false

func _ready():
	super()
	hasShownMaiddialogue = false
	Events.room_entered.connect(_on_room_entered)
	Dialogic.signal_event.connect(_on_dialogic_signal)

func _on_room_entered(room: Room) -> void:
	if room.name == "Dinner 1" and not hasShownMaiddialogue:
		hasShownMaiddialogue = true
		Dialogic.start("room-3-1")

func _on_dialogic_signal(argument: String) -> void:
	if argument == "jackie-disappear":
		AudioManager.play_sound(AudioManager.LAUGH_SOUND)
		remove_child(jackie)
		await get_tree().create_timer(1.0).timeout
