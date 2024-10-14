class_name Door extends StaticBody2D
@export var closedDoorTexture: Texture2D = preload("res://scenes/rooms/doors/door_closed.png") as Texture2D
@export var openDoorTexture: Texture2D = preload("res://scenes/rooms/doors/door_open.png") as Texture2D

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
