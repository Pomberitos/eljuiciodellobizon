extends StaticBody2D

class_name Door

@export var closedDoorTexture: Texture2D = load("res://scenes/rooms/doors/door_closed.png")
@export var openDoorTexture: Texture2D = load("res://scenes/rooms/doors/door_open.png")

var isPlayerNearby = false
var isDoorClosed = true;

func open():
	if isDoorClosed:
		$DoorSprite.texture = openDoorTexture
		$CollisionShape.disabled = true
		isDoorClosed = false
		AudioManager.play_sound(AudioManager.DOOR_OPEN_SOUND)

func close():
	if !isDoorClosed:
		$DoorSprite.texture = closedDoorTexture
		$CollisionShape.disabled = false
		isDoorClosed = true
		AudioManager.play_sound(AudioManager.DOOR_OPEN_SOUND)
