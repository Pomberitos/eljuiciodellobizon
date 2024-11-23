extends Room

@export var light: DirectionalLight2D
@export var astor: CharacterBody2D
var hasShownAstorDialogue = false

func _ready() -> void:
	super()
	Events.room_entered.connect(_on_room_entered)
	Dialogic.signal_event.connect(_on_dialogic_signal)

func _on_room_entered(room: Room) -> void:
	if room.name == "Astor's Bedroom" and !hasShownAstorDialogue:
		hasShownAstorDialogue = true
		Dialogic.start("astor-bedroom-1")

func _on_dialogic_signal(argument: String) -> void:
	if argument == "astor-dissapear":
		AudioManager.play_sound(AudioManager.THUNDER_SOUND)
		light.show()
		remove_child.call_deferred(astor)
		await get_tree().create_timer(1.0).timeout
		light.hide()
